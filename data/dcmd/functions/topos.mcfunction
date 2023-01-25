#将地址转换为坐标，并返回到执行者位置
scoreboard players operation stempz int = sinp int
scoreboard players operation stempx int = sinp int
scoreboard players operation stempz int /= 6144 int
execute store result entity @s Pos[2] double 1 run scoreboard players add stempz int 8592

scoreboard players operation stempx int %= 6144 int
scoreboard players operation stempy int = stempx int
scoreboard players operation stempy int /= 16 int
scoreboard players operation stempx int %= 16 int
#tellraw @a [{"text":"trans:"},{"score":{"name":"stempx","objective":"int"}},{"text":","},{"score":{"name":"stempy","objective":"int"}}]
execute store result entity @s Pos[1] double 1 run scoreboard players remove stempy int 64
execute store result entity @s Pos[0] double 1 run scoreboard players add stempx int 29999984

#对齐到方块中心，便于命令方块使用nearest选择，规避可能的store精度误差(虽然没见过这种情况)
execute at @s run tp @s ~0.5 ~0.5 ~0.5