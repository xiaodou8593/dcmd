#传送到获取string的命令方块位置
data modify entity @s Pos set from entity @s ArmorItems[3].tag.trans_list[0].get_string
execute at @s run function dcmd:process/search
execute if score sstempl int matches ..820 run data modify storage dcmd:io strings append from storage dcmd:io result