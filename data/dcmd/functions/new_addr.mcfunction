#利用总计数器#dcmd_id生成一个新的空闲地址，加入空闲地址池
data modify storage dcmd:io free_addr prepend value 0
execute store result storage dcmd:io free_addr[0] int 1 run scoreboard players add #dcmd_id int 1