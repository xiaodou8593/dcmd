#处理stemp[0]表示的命令方块

#递归迭代
data remove storage dcmd:io stemp[0]
scoreboard players remove sloop int 1
execute if score sloop int matches 1.. run function dcmd:process/loop