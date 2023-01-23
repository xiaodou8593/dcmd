#设置临时数据
tag @e remove result
data modify storage dcmd:io stemp set from storage dcmd:io input.cb_list
execute store result score sloop int if data storage dcmd:io stemp[]

#在主世界进行的new操作
execute in minecraft:overworld run function dcmd:new_operations