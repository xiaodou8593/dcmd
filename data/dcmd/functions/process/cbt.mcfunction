#放置执行中转函数的命令方块
setblock ~ ~ ~ air
setblock ~ ~ ~ command_block{Command:"execute as @e[tag=dcmd_tmp,limit=1] run function dcmd:process/trans",TrackOutput:1b,auto:1b}

#中转函数翻译
#pre_name
execute if data storage dcmd:io stemp[0].pre_name run function dcmd:process/trans/set_pn
#set_name
#get_string
execute if data storage dcmd:io stemp[0].get_string run function dcmd:process/trans/set_gs
#trans_string
execute if data storage dcmd:io stemp[0].trans_string run function dcmd:process/trans/set_ts

#加入中转任务列表
data modify entity @s ArmorItems[3].tag.trans_list append from storage dcmd:io stemp[0]