#总长度扣去固有长度
execute store result score sstempl int run data get block ~ ~ ~ LastOutput
scoreboard players remove sstempl int 129
#调用记分板树检索
execute if score sstempl int matches 1..729 run function dcmd:process/search/1_729
#记录字符串尾部索引
scoreboard players add sstempl int 91