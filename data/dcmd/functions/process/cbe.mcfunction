#拍扁CustomName的附魔命令方块
setblock ~ ~ ~ air
setblock ~ ~ ~ command_block{Command:"enchant @e[tag=dcmd_tmp,limit=1] minecraft:aqua_affinity",TrackOutput:1b,auto:1b}