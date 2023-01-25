#释放marker的n号cb
setblock ~ ~ ~ air
setblock ~ ~ ~ command_block{Command:"execute as @e[tag=dcmd_tmp,limit=1] run function dcmd:process/free",TrackOutput:1b,auto:1b}