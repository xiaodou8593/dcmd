#设置CustomName命令方块
data modify storage dcmd:io input.cb_list append value {type:"trans",pre_name:[]}
data modify storage dcmd:io input.cb_list[-1].pre_name set from storage dcmd:io input.strings
#当前cb编号
execute store result score stempn int if data storage dcmd:io input.cb_list[]
#设置附魔命令方块
data modify storage dcmd:io input.cb_list append value {type:"enchant"}
#设置获取长度命令方块
data modify storage dcmd:io input.cb_list append value {type:"trans",set_name:['[{"text":"execute at @e[tag=dcmd_tmp,limit=1] run data modify storage dcmd:io result set string block ~ ~ ~ LastOutput 91 "},{"score":{"name":"sstempl","objective":"int"}}]']}
execute store result storage dcmd:io input.cb_list[-1].get_string int 1 run scoreboard players get stempn int
#设置附魔命令方块
data modify storage dcmd:io input.cb_list append value {type:"enchant"}
#设置中转命令方块
data modify storage dcmd:io input.cb_list append value {type:"trans"}
execute store result storage dcmd:io input.cb_list[-1].get_string int 1 run scoreboard players add stempn int 2
execute store result storage dcmd:io input.cb_list[-1].trans_string int 1 run scoreboard players add stempn int 3
#设置回溯位置命令方块
data modify storage dcmd:io input.cb_list append value {type:"trans"}
execute store result storage dcmd:io input.cb_list[-1].get_string int 1 run scoreboard players remove stempn int 5
#设置执行命令方块
data modify storage dcmd:io input.cb_list append value {type:"cmd"}
#设置返回命令方块
execute if data storage dcmd:io input.return run function dcmd:process/add_return