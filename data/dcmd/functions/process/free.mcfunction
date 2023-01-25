#将所有任务编号放回编号池
data modify storage dcmd:io free_addr append from entity @s ArmorItems[3].tag.addr_list[]
kill @s