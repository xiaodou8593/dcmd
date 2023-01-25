#初始化执行环境的-1号cb
setblock ~ ~ ~ air
setblock ~ ~ ~ command_block{Command:"execute as @e[tag=dcmd_marker,limit=1,sort=nearest] run function dcmd:process/init_space",TrackOutput:1b,auto:1b}