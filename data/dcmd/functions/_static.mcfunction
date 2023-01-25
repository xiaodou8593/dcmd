#输入转移到临时数据
data modify storage dcmd:io stemp set from storage dcmd:io input.strings
#遍历每一项任务
execute store result score sloop int if data storage dcmd:io stemp[]
execute if score sloop int matches 1.. run function dcmd:process/loop_static
#设置返回命令方块
execute if data storage dcmd:io input.return run function dcmd:process/add_return