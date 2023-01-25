#转移到临时数据(路径短访问更快)
data modify storage dcmd:io sstemp set from storage dcmd:io stemp[0].pre_name
#告示牌循环迭代
data modify block 29999984 0 8591 Text1 set value '{"text":""}'
execute store result score ssloop int if data storage dcmd:io sstemp[]
execute if score ssloop int matches 1.. run function dcmd:process/trans/pn_loop

#重载pre_name
data modify storage dcmd:io stemp[0].pre_name set from block 29999984 0 8591 Text1