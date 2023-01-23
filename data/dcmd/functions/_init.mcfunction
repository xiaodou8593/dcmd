#主世界进行的init操作
execute in minecraft:overworld run function dcmd:init_operations

#用于储存懒加载UUID
scoreboard objectives add dcmd_uuid0 dummy
scoreboard objectives add dcmd_uuid1 dummy
scoreboard objectives add dcmd_uuid2 dummy
scoreboard objectives add dcmd_uuid3 dummy

#int记分板，必要常量
scoreboard objectives add int dummy
scoreboard players set 6144 int 6144
scoreboard players set 16 int 16

#重置空闲地址池，重置总计数器，清空全部任务
kill @e[tag=dcmd_marker]
scoreboard players set #dcmd_id int -1
data modify storage dcmd:io free_addr set value []