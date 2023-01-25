#返回命令方块
data modify storage dcmd:io input.cb_list append value {type:"cmd"}
data modify storage dcmd:io input.cb_list[-1].cmd set from storage dcmd:io input.return