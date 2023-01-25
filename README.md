# DCMD: Dynamic Commands

## Introduction 简要介绍

dcmd，是利用23w03a快照操作字符串新特性制作的前置数据包。

dcmd强加载了边界外坐标29999984 8591到29999984 8719内的9个区块，实现同时最多8*16\*384\*16次命令方块并行操作，为您提供字符串合并与动态命令执行服务。(移除了1.0版本中麻烦的自定义维度)

由于命令可变长，dcmd构造了一个729=3^6种情况的记分板树进行字符串长度穷举，每次需要检索3\*6=18次execute if score以获得对应字符串切片，因此命令字符串长度不能超过**729**(这对于绝大多数命令的长度来说完全够用了)。

dcmd利用了命令方块处理的微时序，实现了单刻内的顺序逻辑，所有的操作都将在**本刻的方块实体刻**被处理完成。

## Usages 基本操作

### init 初始化

```mcfunction
function dcmd:_init
```

使用dcmd之前必须手动执行初始化函数。

### io 输入输出

```mcfunction
data modify storage dcmd:io input set value {as:[I;0,0,0,0],at:[I;0,0,0,0],run_space:{},cb_list:[],pre_name:[],set_name:[]}
function dcmd:_new
```

input的复合标签描述了一个dcmd任务对象的数据模板，_new函数将任务实例化后在本刻的方块实体刻中处理。一个完整的dcmd任务对象由以下标签组成：

`cb_list`：dcmd任务中自定义的命令方块链依次从0号到n-1号的命令方块数据列表。每个命令方块使用复合标签描述。

`as`：指定dcmd任务的执行者UUID，使用@e[tag=dcmd_as,limit=1]选中。不可手动设置，只能使用_setas或_setasat函数设定。

`at`：指定dcmd任务的执行位置实体UUID，使用@e[tag=dcmd_at,limit=1]选中。不可手动设置，只能使用_setat或_setasat函数设定。

`run_space`：使用复合标签描述dcmd任务的执行环境，用于在_new函数执行期间将数据传递给dcmd任务处理的方块实体时期。

`pre_name`：JSON字符串的列表，在任务分发期，也就是函数调用期间被拼接并解析(称为预解析)，用于指定任务marker的初始CustomName。

`set_name`：JSON字符串的列表，在方块实体刻被拼接并解析(称为实时解析)，用于指定任务marker的初始CustomName。在cb链初始化时被拼接

这里有必要对一个dcmd任务的cb链构造进行说明：

dcmd任务的cb链由n+2个cb组成，编号为-1,0,1,2......n，在方块实体刻依次运行，其中0~n-1号为cb_list中的自定义cb，用于完成用户所需服务。-1号为任务环境的初始化函数，用于转移as,at,run_space数据，并把任务marker标记为dcmd_tmp，便于后续命令方块选择。n号用于执行任务marker的释放函数，清除marker实体，并把占用的任务地址编号释放回空闲地址池。

以下为复合标签描述自定义cb的格式：

```mcfunction
data modify storage dcmd:io input.cb_list set value [{type:"enchant"},{type:"cmd",cmd:""},{type:"trans",get_string:0,trans_string:2,pre_name:[],set_name:[]}]
```

enchant命令方块用于处理实体的CustomName，获得拍扁后的命令方块。

cmd命令方块用于执行特定命令，子标签cmd的字符串即为指定的命令字符串。

trans命令方块用于中转，将拍扁的CustomName字符串切割，传输给另外一个命令方块执行，还能顺便改变任务marker的CustomName用于下次enchant。get_string的整数值指定了被切割的enchant命令方块索引值，trans_string的整数值指定了被传输命令的命令方块索引值，pre_name和set_name与input标签中的pre_name和set_name同理，用于指定CustomName的预解析字符串或实时解析字符串(后文将举例说明两种解析的具体区别)。

例1：单条动态命令服务

```mcfunction
scoreboard players set test int 8593
data modify storage dcmd:io input set value {pre_name:[],cb_list:[]}
data modify storage dcmd:io input.pre_name append value '[{"text":"tag @a add tag_"},{"score":{"name":"test","objective":"int"}}]'
data modify storage dcmd:io input.cb_list append value {type:"enchant"}
data modify storage dcmd:io input.cb_list append value {type:"trans",get_string:0,trans_string:2}
data modify storage dcmd:io input.cb_list append value {type:"cmd"}
```

初始化CustomName为预解析字符串"tag @a add tag_8593"，0号cb将字符串拍扁，1号cb通过get_string:0选中了0号cb，对字符串进行切割，通过trans_string:2选中了2号cb，将切割后的字符串传输到了2号cb，2号cb执行了切割后的字符串"tag @a add tag_8593"，也就完成了动态命令任务：为全部玩家添加了动态标签tag_8593，8593用记分板分数指定。

例2：pre_name与set_name的区别

```mcfunction
#run0
say 0
scoreboard players set test int 2
```

```mcfunction
#run1
say 1
```

```mcfunction
#run2
say 2
```

```mcfunction
#test
scoreboard players set test int 1
data modify storage dcmd:io input set value {cb_list:[{type:"cmd",cmd:"function run0"},{type:"trans",pre_name:['[{"text":"function run"},{"score":{"name":"test","objective":"int"}}]']},{type:"enchant"},{type:"trans",get_string:2,trans_string:4},{type:"cmd"}]}
function dcmd:_new
```

在这个例子中，test int首先为1，但在run0函数中被修改为2。cb链依次执行静态命令"function run0"和动态命令"function run\$test"。我们在1号中转cb中使用了pre_name，也就是预解析指定了CustomName，那么\$test将会被解析为1而不是2，可以看到输出0,1。如果我们把pre_name修改为set_name，它将会输出0,2。这便是预解析与实时解析的区别。

例3：获得字符串输出

```mcfunction
#test
data modify storage dcmd:io input set value {pre_name:['{"text":"abc"}','{"text":"123"}'],cb_list:[{type:"enchant"},{type:"trans",get_string:0,pre_name:['{"text":"def"}','{"text":"456"}']},{type:"enchant"},{type:"trans",get_string:2},{type:"cmd",cmd:"function after"}]}
function dcmd:_new
```

```mcfunction
#after
data get storage dcmd:io result
data get storage dcmd:io strings
```

这里仅使用了trans命令方块的get_string功能，用于获得对0号和2号enchant命令方块切割后的字符串。每个get_string都会把切割结果赋值dcmd:io result，同时放入dcmd:io strings列表记录(strings列表在每个任务的初始化阶段都会被清空，因此它仅记录本次任务的历史字符串)。在静态命令调用的后续操作after函数中，我们可以获取result和strings的值，发现分别是"def456"和["abc123","def456"]。指的注意的是，在后文中介绍的_merge服务，它的输出也是dcmd:io result，却并不会被放入strings列表，因为_merge服务支持合并任意长度字符串，它的底层实现为动态的切割命令，而不是get_string。

### 服务添加：另一种输入方式

dcmd:io input.cb_list提供了高度自定义化的cb链构造功能，理论上可以实现任意cb链服务，但这也造成了输入的麻烦：我们在函数中构造input数据模板时，需要同时思考cb链的构造以及不同cb之间的数据传输问题，十分繁琐。如果任务较为复杂，cb_list的构造难度会加大。因此，我们有必要实现抽象的cb_list编辑，屏蔽底层的cb链细节，让开发者仅关注任务分发部分。这种抽象的cb_list编辑称为服务添加。以下为服务添加的基本模板：

```mcfunction
function dcmd:_reset
function dcmd:_xxx
#...
function dcmd:_new
```

_reset函数重置了dcmd:io input，如果不进行重置操作，将会在上个任务的基础上添加新的服务，上个任务也会被分发。

dcmd:\_xxx为各类抽象服务函数，包括dcmd:\_interpret、dcmd:\_exec、dcmd:\_static、dcmd:\_merge、dcmd:\_slice。可以将任意多，任意种类的抽象服务函数依次执行，这些服务都会被添加进cb_list，依次运行。以下分别介绍这些抽象服务函数：

1.dcmd:\_interpret：添加预解析动态命令任务。输入input.strings为预解析动态命令的列表。

例：

```mcfunction
scoreboard players set test int 1
function dcmd:_reset

data modify storage dcmd:io input.strings set value []
data modify storage dcmd:io input.strings append value '[{"text":"scoreboard players add test int "},{"score":{"name":"test","objective":"int"}}]'
data modify storage dcmd:io input.strings append value '[{"text":"scoreboard players add test int "},{"score":{"name":"test","objective":"int"}}]'
data modify storage dcmd:io input.strings append value '{"text":"function output"}'
function dcmd:_interpret

function dcmd:_new
```

在output函数中我们可以得到test int的值为3（连续两次add 1）。

2.dcmd:_exec：添加实时解析动态命令任务。输入input.strings为实时解析动态命令的列表。

```mcfunction
scoreboard players set test int 1
function dcmd:_reset

data modify storage dcmd:io input.strings set value []
data modify storage dcmd:io input.strings append value '[{"text":"scoreboard players add test int "},{"score":{"name":"test","objective":"int"}}]'
data modify storage dcmd:io input.strings append value '[{"text":"scoreboard players add test int "},{"score":{"name":"test","objective":"int"}}]'
data modify storage dcmd:io input.strings append value '{"text":"function output"}'
function dcmd:_exec

function dcmd:_new
```

在output函数中我们可以得到test int的值为4（先add 1变为2，后add 2）。

3.dcmd:_static：添加静态命令任务，输入input.strings为静态命令的列表。

```mcfunction
function dcmd:_reset

data modify storage dcmd:io input.strings set value ["say 0","say 1","say 2"]
function dcmd:_static

function dcmd:_new
```

依次输出0,1,2

4.dcmd:_merge：添加字符串合并任务(支持任意长度而不是命令的729)，输入input.strings为待合并字符串。

```mcfunction
function dcmd:_reset

data modify storage dcmd:io input.strings set value ['{"text":"abc"}','{"text":"123"}']
data modify storage dcmd:io input.return set value "function output"
function dcmd:_merge

function dcmd:_new
```

这里使用了抽象服务函数特有的return功能，可以指定一个静态命令，作为任务完成后的后续操作，在\_interpret、\_exec、\_static、\_slice中同样适用。这里的return调用了output函数，在output函数中我们获取dcmd:io result可以发现输出为"abc123"

5.dcmd:\_slice：获取一条命令输出的动态索引切割，用input.slice.index列表指定切割索引，用input.slice.cmd可以把命令指定为静态命令，用input.slice.pre\_cmd可以把命令指定为预解析动态命令，用input.slice.set\_cmd可以把命令指定为实时解析动态命令，在一次服务中，三种命令只能选择一种。

```mcfunction
function dcmd:_reset
data modify storage dcmd:io input.return set value "function output"

data modify storage dcmd:io input.slice set value {cmd:"scoreboard players set test int 5",index:[5,8]}
function dcmd:_slice
data modify storage dcmd:io input.slice set value {pre_cmd:'{"text":"scoreboard players set test int 5"}',index:[5,8]}
function dcmd:_slice
data modify storage dcmd:io input.slice set value {set_cmd:'{"text":"scoreboard players set test int 5"}',index:[5]}
function dcmd:_slice

function dcmd:_new
```

三次动态切割任务，三次return，在output函数中依次得到三次输出。这里的index相当于data命令中string的两个参数。最后一次服务添加中，index只填写了一个参数，相当于string中第二个参数省略。

### 指定任务中的执行者执行位置

```mcfunction
function dcmd:_setas
```

为该函数传入执行者，在动态命令中可以使用as @e[tag=dcmd_as,limit=1]来继承执行者

```mcfunction
function dcmd:_setat
```

为该函数传入执行者，在动态命令中可以使用at @e[tag=dcmd_at,limit=1]来继承执行者位置

```mcfunction
function dcmd:_setasat
```

上述两函数功能的合并

例：让killer在kill_point的位置杀死半径5格内实体，并由自己报告。

```mcfunction
function dcmd:_reset

execute as @e[tag=killer,limit=1] run function dcmd:_setas
execute at @e[tag=kill_point,limit=1] run function dcmd:_setat

data modify storage dcmd:io input.strings set value ["execute at @e[tag=dcmd_at,limit=1] run kill @e[distance=..5]"]
data modify storage dcmd:io input.return set value "say i killed them."
function dcmd:_static

function dcmd:_new
```

### 指定任务中的执行环境

dcmd:io run_space称为当前的执行环境。dcmd:io input.run_space为任务中继承的执行环境。直接编辑input.run_space即可指定任务中的执行环境数据。若执行_reset，input.run_space默认与当前run_space一致。

例：让执行者(非玩家)在方块实体刻回传。

```mcfunction
function dcmd:_reset

function dcmd:_setas
data modify storage dcmd:io input.run_space.pos set from entity @s Pos

data modify storage dcmd:io input.strings set value ["execute as @e[tag=dcmd_as,limit=1] run data modify entity @s Pos set from storage dcmd:io run_space.pos"]

function dcmd:_new
```

又可以写为：

```mcfunction
data modify storage dcmd:io input.run_space.pos set from entity @s Pos
function dcmd:_reset

function dcmd:_setas

data modify storage dcmd:io input.strings set value ["execute as @e[tag=dcmd_as,limit=1] run data modify entity @s Pos set from storage dcmd:io run_space.pos"]

function dcmd:_new
```

## Features DCMD的特性

### 保序性

在同一tick函数内多次_new，分发后的任务在本tick命令方块处理期内也会按次序执行完成。
例：

```mcfunction
function dcmd:_reset

data modify storage dcmd:io input set value {strings:["function func0"]}
function dcmd:_static
function dcmd:_new

data modify storage dcmd:io input set value {strings:["function func1"]}
function dcmd:_static
function dcmd:_new

data modify storage dcmd:io input set value {strings:["function func2"],return:"function after"}
function dcmd:_static
function dcmd:_new
```

将会依次执行func0,func1,func2,after

### 编号机制

dcmd保证同一编号地址的重复利用，具体做法是维护一个编号池列表。

例如*编号0*对应坐标`0 -64 0`，*编号1*对应坐标`1 -64 0`，编号池是[0,1]

现在生成了两个任务，它们优先从编号池里拿到自己的*编号0,1*，此时编号池为[]

而第三个任务发现编号池中没有编号，于是利用总计数器生成了*编号2*，对应坐标`2 -64 0`

当任务123处理完成后，会依次将编号放入编号池，此时编号池变为[0,1,2]

*编号0 1 2*又可以被以后的任务重复利用，不够用了才生成新编号，以此类推......
