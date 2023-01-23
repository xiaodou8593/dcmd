# DCMD: Dynamic Commands

## Introduction 简要介绍

dcmd，是利用23w03a快照操作字符串新特性制作的前置数据包。

dcmd添加了一个新维度，通过新维度一个常加载区块的方块区域中的命令方块，实现同时最多16\*384\*16次命令方块并行操作，为您提供字符串合并与动态命令执行服务。

由于命令可变长，dcmd维护了一个729=3^6种情况的记分板树进行字符串长度穷举，每次需要检3\*6=18次execute if score以获得对应字符串切片，因此合并后字符串长度不能超过**729**(这对于绝大多数命令的长度来说完全够用了)。

dcmd利用了命令方块处理的微时序，实现了单刻内的顺序逻辑，所有的操作都将在**本刻的方块实体刻**被处理完成。

## Usages 基本操作

### init 初始化

```mcfunction
function dcmd:_init
```

使用dcmd之前必须手动执行初始化函数。

**注意：**如果是创建世界以后加入的数据包，需要**重进游戏**以后再执行_init，保证维度生成。

### io 输入输出

```mcfunction
data modify storage dcmd:io input set value {strings:[],return:""}
function dcmd:_input
```

`strings`为待合并字符串列表(必须为JSON文本格式，不能为字符串)，`return`为任务完成后调用的后续命令

在列表中的JSON文本被解析后的内容，将会拼接到一起。如下例子：

```
strings:[
'[{"text":"a"},{"text":"b"}],{"text":"c"}',
'[{"text":"d"},{"text":"e"}]',
'{"text":"f"}',
]
```

将会被拼接为"abcdf"。

在执行`function dcmd:_input`以后，输出将会保存在dcmd:io result中

#### 例1：为实体添加动态的tag

```
{strings:['[{"text":"tag @e add entity_"},{"score":{"name":"test","objective":"int"}}]'],
return:"say done!"}
```

该动态命令为全部实体添加标签 entity_\$score，\$score随着test int动态变化.。

执行结束后会提示done!

#### 例2：获取合并字符串

```
{strings:['{"text":"test"}','{"text":"123"}'],return:"function #after"}
```

该输入提供合并字符串服务，在#after函数中使用storage dcmd:io result可获得合并后字符串"test123"

### 指定动态命令的执行者执行位置

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

## Features DCMD的特性

### 保序性

在同一tick函数内多次_input，分发后的任务在本tick命令方块处理期内也会按次序执行完成。
例：（这里用cmd0代表某条命令）

```mcfunction
data modify storage dcmd:io input set value {strings:[cmd0]}
function dcmd:_input
data modify storage dcmd:io input set value {strings:[cmd1]}
function dcmd:_input
data modify storage dcmd:io input set value {strings:[cmd2],return:"function after"}
function dcmd:_input
```

将会依次执行cmd0,cmd1,cmd2,after

### 编号机制

dcmd保证同一编号地址的重复利用，具体做法是维护一个编号池列表。

例如*编号0*对应坐标`0 -64 0`，*编号1*对应坐标`1 -64 0`，编号池是[0,1]

现在生成了两个任务，它们优先从编号池里拿到自己的*编号0,1*，此时编号池为[]

而第三个任务发现编号池中没有编号，于是利用总计数器生成了*编号2*，对应坐标`2 -64 0`

当任务123处理完成后，会依次将编号放入编号池，此时编号池变为[0,1,2]

*编号0 1 2*又可以被以后的任务重复利用，不够用了才生成新编号，以此类推......

## Examples 实践举例



**test.mcfunction**

```mcfunction
data modify storage dcmd:io input set value {
	strings:[
			'[{"text":"execute at @e[tag=dcmd_at,limit=1] run kill @e[distance=.."},
			{"score":{"name":"dis","objective":"int"}},
			{"text":"]"}]'
		],
	return:"execute as @e[tag=dcmd_as,limit=1] run function #after"
	}
execute as @e[tag=killer,limit=1] run function dcmd:_setas
execute as @e[tag=kill_point,limit=1] run function dcmd:_setat
function dcmd:_input
```

test函数使用dcmd分发了一个动态命令任务，`execute at @e[tag=dcmd_at,limit=1] run kill @e[distance=..$score]` 。其中`$score `使用dis int动态指定(注意：这里使用了虚拟玩家，但如果需要使用 @s 需要先把 @s分数赋值虚拟分数，这是因为nbt里的json无法选中 @s)
设置完成任务后的返回命令：`execute as @e[tag=dcmd_as,limit=1] run function #after`

然后利用`_setas`和`_setat`函数设置了dcmd_as和dcmd_at分别指代killer和kill_point
最后调用_input函数完成任务分发



**after.mcfunction**

```mcfunction
data get storage dcmd:io result
tellraw @a [{"selector":"@s"},{"text":"：我使用了命令"},{"nbt":"result","storage":"dcmd:io"}]
```

在after函数中，使用了dcmd:io result来获得动态命令的字符串。
