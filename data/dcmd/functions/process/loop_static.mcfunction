#添加执行命令方块
data modify storage dcmd:io input.cb_list append value {type:"cmd"}
data modify storage dcmd:io input.cb_list[-1].cmd set from storage dcmd:io stemp[0]

#递归迭代
data remove storage dcmd:io stemp[0]
scoreboard players remove sloop int 1
execute if score sloop int matches 1.. run function dcmd:process/loop_static