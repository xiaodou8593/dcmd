#传递执行环境数据
data modify entity @s data.run_space set from storage dcmd:io input.run_space
data modify entity @s data.as set from storage dcmd:io input.as
data modify entity @s data.at set from storage dcmd:io input.at

#初始化任务编号池
data modify entity @s data.addr set value []

#生成-1号cb
function dcmd:new_ip
scoreboard players operation res int = sres int

#处理cb_list
execute at @s run function dcmd:process/cb_list