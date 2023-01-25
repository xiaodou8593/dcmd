#将编号形式转换为坐标形式
execute store result score sinp int run data get storage dcmd:io stemp[0].trans_string
scoreboard players operation sinp int += stemp_id int
function dcmd:topos
data modify storage dcmd:io stemp[0].trans_string set from entity @s Pos