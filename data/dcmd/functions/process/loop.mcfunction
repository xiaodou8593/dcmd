#处理stemp[0]表示的命令方块
#分配新的命令方块
function dcmd:new_ip
data modify entity @s ArmorItems[3].tag.addr_list append value 0
execute store result entity @s ArmorItems[3].tag.addr_list[-1] int 1 run scoreboard players get sres int

#types：cmd,trans,enchant
execute store result score stempl int run data get storage dcmd:io stemp[0].type
execute if score stempl int matches 3 at @s run function dcmd:process/cbc
execute if score stempl int matches 5 at @s run function dcmd:process/cbt
execute if score stempl int matches 7 at @s run function dcmd:process/cbe

#递归迭代
data remove storage dcmd:io stemp[0]
scoreboard players remove sloop int 1
execute if score sloop int matches 1.. run function dcmd:process/loop