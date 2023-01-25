#测试
scoreboard players set test int 1
function dcmd:_reset
data modify storage dcmd:io input.return set value "function dcmd:test/return"

data modify storage dcmd:io input.strings set value ['{"text":"function dcmd:test/run0"}']
data modify storage dcmd:io input.strings append value '[{"text":"function dcmd:test/run"},{"score":{"name":"test","objective":"int"}}]'
function dcmd:_interpret
function dcmd:_exec

data modify storage dcmd:io input.strings set value ['{"text":"abc"}','{"text":"123"}']
data modify storage dcmd:io input.return set value "function dcmd:test/result"
function dcmd:_merge

data modify storage dcmd:io input.slice set value {set_cmd:'{"text":"scoreboard players set test int 5"}',index:[91,98]}
function dcmd:_slice

data remove storage dcmd:io input.return
data modify storage dcmd:io input.strings set value ["say static0","say static1","say static2"]
function dcmd:_static

function dcmd:_new