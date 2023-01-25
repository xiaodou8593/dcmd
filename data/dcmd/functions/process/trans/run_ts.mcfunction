#传送到运行string的命令方块位置
data modify entity @s Pos set from entity @s ArmorItems[3].tag.trans_list[0].trans_string
execute at @s run data modify block ~ ~ ~ Command set from storage dcmd:io result