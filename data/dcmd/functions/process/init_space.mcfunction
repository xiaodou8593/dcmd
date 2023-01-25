#继承执行者
tag @e remove dcmd_as
execute store result score stemp0 int run data get entity @s ArmorItems[3].tag.as[0]
execute store result score stemp1 int run data get entity @s ArmorItems[3].tag.as[1]
execute store result score stemp2 int run data get entity @s ArmorItems[3].tag.as[2]
execute store result score stemp3 int run data get entity @s ArmorItems[3].tag.as[3]
execute as @e[tag=dcmd_setid] if score @s dcmd_uuid0 = stemp0 int if score @s dcmd_uuid1 = stemp1 int if score @s dcmd_uuid2 = stemp2 int if score @s dcmd_uuid3 = stemp3 int run tag @s add dcmd_as

#继承执行位置
tag @e remove dcmd_at
execute store result score stemp0 int run data get entity @s ArmorItems[3].tag.at[0]
execute store result score stemp1 int run data get entity @s ArmorItems[3].tag.at[1]
execute store result score stemp2 int run data get entity @s ArmorItems[3].tag.at[2]
execute store result score stemp3 int run data get entity @s ArmorItems[3].tag.at[3]
execute as @e[tag=dcmd_setid] if score @s dcmd_uuid0 = stemp0 int if score @s dcmd_uuid1 = stemp1 int if score @s dcmd_uuid2 = stemp2 int if score @s dcmd_uuid3 = stemp3 int run tag @s add dcmd_at

#继承执行环境
data modify storage dcmd:io run_space set from entity @s ArmorItems[3].tag.run_space

#设置临时标签
tag @s add dcmd_tmp

#初始化合并结果列表
data modify storage dcmd:io strings set value []

#设置CustomName
execute if data entity @s ArmorItems[3].tag.set_name run function dcmd:process/set_sn