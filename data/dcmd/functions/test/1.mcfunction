function dcmd:_reset
data modify storage dcmd:io input.return set value "function dcmd:test/result"
data modify storage dcmd:io input.strings set value ['{"text":"abc"}','{"text":"123"}']
data modify storage dcmd:io input.slice set value {cmd:"scoreboard players set test int 5",index:[91,98]}
function dcmd:_slice

function dcmd:_new