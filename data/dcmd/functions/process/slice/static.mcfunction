#静态命令
data modify storage dcmd:io input.cb_list append value {type:"cmd"}
data modify storage dcmd:io input.cb_list[-1].cmd set from storage dcmd:io input.slice.cmd