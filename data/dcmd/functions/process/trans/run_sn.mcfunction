#转移到临时数据(路径短访问更快)
data modify storage dcmd:io stemp set from entity @s ArmorItems[3].tag.trans_list[0].set_name
#告示牌循环迭代
data modify block 29999984 0 8591 Text1 set value '{"text":""}'
execute store result score sloop int if data storage dcmd:io stemp[]
execute if score sloop int matches 1.. run function dcmd:process/trans/sn_loop

#设置CustomName
data modify entity @s CustomName set from block 29999984 0 8591 Text1