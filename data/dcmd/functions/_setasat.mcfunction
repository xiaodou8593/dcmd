#检查是否已经懒加载UUID
execute unless entity @s[tag=dcmd_setid] run function dcmd:setid
#设置asat数据
data modify storage dcmd:io input.as set from entity @s UUID
data modify storage dcmd:io input.at set from entity @s UUID