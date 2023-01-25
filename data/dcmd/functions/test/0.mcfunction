#常量
scoreboard players set 0 int 0

#测试
scoreboard players set test int 1
data modify storage dcmd:io input set value {pre_name:[],cb_list:[]}
data modify storage dcmd:io input.run_space set value {test:1b}
data modify storage dcmd:io input.pre_name append value '[{"text":"function dcmd:test/run"},{"score":{"name":"0","objective":"int"}}]'
data modify storage dcmd:io input.cb_list append value {type:"enchant"}
data modify storage dcmd:io input.cb_list append value {type:"trans",get_string:0,trans_string:2,pre_name:[]}
data modify storage dcmd:io input.cb_list[1].pre_name append value '[{"text":"function dcmd:test/run"},{"score":{"name":"test","objective":"int"}}]'
data modify storage dcmd:io input.cb_list append value {type:"cmd"}
data modify storage dcmd:io input.cb_list append value {type:"enchant"}
data modify storage dcmd:io input.cb_list append value {type:"trans",get_string:3,trans_string:5}
data modify storage dcmd:io input.cb_list append value {type:"cmd"}
data modify storage dcmd:io input.cb_list append value {type:"cmd",cmd:"function dcmd:test/end"}
function dcmd:_new

scoreboard players set test int 1
data modify storage dcmd:io input set value {pre_name:[],cb_list:[]}
data modify storage dcmd:io input.run_space set value {test:2b}
data modify storage dcmd:io input.set_name append value '[{"text":"function dcmd:test/run"},{"score":{"name":"0","objective":"int"}}]'
data modify storage dcmd:io input.cb_list append value {type:"enchant"}
data modify storage dcmd:io input.cb_list append value {type:"trans",get_string:0,trans_string:2,set_name:[]}
data modify storage dcmd:io input.cb_list[1].set_name append value '[{"text":"function dcmd:test/run"},{"score":{"name":"test","objective":"int"}}]'
data modify storage dcmd:io input.cb_list append value {type:"cmd"}
data modify storage dcmd:io input.cb_list append value {type:"enchant"}
data modify storage dcmd:io input.cb_list append value {type:"trans",get_string:3,trans_string:5}
data modify storage dcmd:io input.cb_list append value {type:"cmd"}
data modify storage dcmd:io input.cb_list append value {type:"cmd",cmd:"function dcmd:test/end"}
function dcmd:_new