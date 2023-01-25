#输入转移到临时数据
data modify storage dcmd:io stemp set from storage dcmd:io input.strings
#当前cb编号
execute store result score stempn int if data storage dcmd:io input.cb_list[]
#添加队首哨兵
data modify storage dcmd:io stemp_cb set value {type:"trans",set_name:[]}
data modify storage dcmd:io stemp_cb.set_name append from storage dcmd:io stemp[0]
data modify storage dcmd:io input.cb_list append from storage dcmd:io stemp_cb
#遍历每一项任务
execute store result score sloop int if data storage dcmd:io stemp[]
execute if score sloop int matches 1.. run function dcmd:process/loop_exec
#设置返回命令方块
execute if data storage dcmd:io input.return run function dcmd:process/add_return