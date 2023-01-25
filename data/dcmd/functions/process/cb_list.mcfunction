#初始化中转任务列表
data modify entity @s ArmorItems[3].tag.trans_list set value []

#进入循环，处理每一个cb
execute if score sloop int matches 1.. run function dcmd:process/loop

#生成n号cb
function dcmd:new_ip
data modify entity @s ArmorItems[3].tag.addr_list append value 0
execute store result entity @s ArmorItems[3].tag.addr_list[-1] int 1 run scoreboard players get sres int
execute at @s run function dcmd:process/cbn

#回溯到-1号cb的位置
tp @s ~ ~ ~