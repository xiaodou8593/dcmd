#执行指定命令的命令方块
setblock ~ ~ ~ air
setblock ~ ~ ~ command_block{Command:"",TrackOutput:1b,auto:1b}
data modify block ~ ~ ~ Command set from storage dcmd:io stemp[0].cmd