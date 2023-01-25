#添加附魔命令方块
data modify storage dcmd:io input.cb_list append value {type:"enchant"}
#添加中转命令方块
data modify storage dcmd:io stemp_cb set value {type:"trans",pre_name:[]}
data modify storage dcmd:io stemp_cb.pre_name append from storage dcmd:io stemp[1]
execute store result storage dcmd:io stemp_cb.get_string int 1 run scoreboard players add stempn int 1
execute store result storage dcmd:io stemp_cb.trans_string int 1 run scoreboard players add stempn int 2
data modify storage dcmd:io input.cb_list append from storage dcmd:io stemp_cb
#添加执行命令方块
data modify storage dcmd:io input.cb_list append value {type:"cmd"}

#递归迭代
data remove storage dcmd:io stemp[0]
scoreboard players remove sloop int 1
execute if score sloop int matches 1.. run function dcmd:process/loop_interpret