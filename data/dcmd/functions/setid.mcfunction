#懒加载UUID
tag @s add dcmd_setid
execute store result score @s dcmd_uuid0 run data get entity @s UUID[0]
execute store result score @s dcmd_uuid1 run data get entity @s UUID[1]
execute store result score @s dcmd_uuid2 run data get entity @s UUID[2]
execute store result score @s dcmd_uuid3 run data get entity @s UUID[3]