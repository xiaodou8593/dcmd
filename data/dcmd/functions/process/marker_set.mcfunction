#初始CustomName
execute if data storage dcmd:io input.pre_name run function dcmd:process/set_pn
execute if data storage dcmd:io input.set_name run data modify entity @s ArmorItems[3].tag.set_name set from storage dcmd:io input.set_name

#传递执行环境数据
data modify entity @s ArmorItems[3].tag.run_space set from storage dcmd:io input.run_space
data modify entity @s ArmorItems[3].tag.as set from storage dcmd:io input.as
data modify entity @s ArmorItems[3].tag.at set from storage dcmd:io input.at

#初始化任务编号池
data modify entity @s ArmorItems[3].tag.addr_list set value []

#生成-1号cb
function dcmd:new_ip
scoreboard players operation res int = sres int
scoreboard players operation stemp_id int = sres int
scoreboard players add stemp_id int 1
data modify entity @s ArmorItems[3].tag.addr_list append value 0
execute store result entity @s ArmorItems[3].tag.addr_list[-1] int 1 run scoreboard players get sres int
execute at @s run function dcmd:process/cb-1

#处理cb_list
execute at @s run function dcmd:process/cb_list