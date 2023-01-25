#设置执行命令方块
scoreboard players set stemp_type int 0
execute if data storage dcmd:io input.slice.pre_cmd run scoreboard players set stemp_type int 1
execute if data storage dcmd:io input.slice.set_cmd run scoreboard players set stemp_type int 2
execute if score stemp_type int matches 0 run function dcmd:process/slice/static
execute if score stemp_type int matches 1 run function dcmd:process/slice/pre_name
execute if score stemp_type int matches 2 run function dcmd:process/slice/set_name
#设置CustomName命令方块
data modify storage dcmd:io input.cb_list append value {type:"trans",pre_name:[]}
execute in minecraft:overworld run function dcmd:set_slice_text
#获得当前编号
execute store result score stempn int if data storage dcmd:io input.cb_list[]
#设置附魔命令方块
data modify storage dcmd:io input.cb_list append value {type:"enchant"}
#设置中转命令方块
data modify storage dcmd:io input.cb_list append value {type:"trans"}
execute store result storage dcmd:io input.cb_list[-1].get_string int 1 run scoreboard players get stempn int
execute store result storage dcmd:io input.cb_list[-1].trans_string int 1 run scoreboard players add stempn int 3
#设置回溯位置命令方块
data modify storage dcmd:io input.cb_list append value {type:"trans"}
execute store result storage dcmd:io input.cb_list[-1].get_string int 1 run scoreboard players remove stempn int 5
#设置切割命令方块
data modify storage dcmd:io input.cb_list append value {type:"cmd"}
#设置返回命令方块
execute if data storage dcmd:io input.return run function dcmd:process/add_return