#实时解析动态命令

#获得当前cb编号
execute store result score stempn int if data storage dcmd:io input.cb_list[]
#添加CustomName命令方块
data modify storage dcmd:io stemp_cb set value {type:"trans",set_name:[]}
data modify storage dcmd:io stemp_cb.set_name append from storage dcmd:io input.slice.set_cmd
data modify storage dcmd:io input.cb_list append from storage dcmd:io stemp_cb
#添加附魔命令方块
data modify storage dcmd:io input.cb_list append value {type:"enchant"}
#添加中转命令方块
data modify storage dcmd:io stemp_cb set value {type:"trans"}
execute store result storage dcmd:io stemp_cb.get_string int 1 run scoreboard players add stempn int 1
execute store result storage dcmd:io stemp_cb.trans_string int 1 run scoreboard players add stempn int 2
data modify storage dcmd:io input.cb_list append from storage dcmd:io stemp_cb
#添加执行命令方块
data modify storage dcmd:io input.cb_list append value {type:"cmd"}