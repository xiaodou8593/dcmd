#运行中转函数
execute if data entity @s ArmorItems[3].tag.trans_list[0].get_string run function dcmd:process/trans/run_gs
execute if data entity @s ArmorItems[3].tag.trans_list[0].trans_string run function dcmd:process/trans/run_ts
execute if data entity @s ArmorItems[3].tag.trans_list[0].pre_name run data modify entity @s CustomName set from entity @s ArmorItems[3].tag.trans_list[0].pre_name
execute if data entity @s ArmorItems[3].tag.trans_list[0].set_name run function dcmd:process/trans/run_sn

#释放任务
data remove entity @s ArmorItems[3].tag.trans_list[0]