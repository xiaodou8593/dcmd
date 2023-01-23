#检查是否已经懒加载UUID
execute unless entity @s[tag=dcmd_setid] run function dcmd:setid
#设置as数据
data modify storage dcmd:io input.as set from entity @s UUID