#进入循环，处理每一个cb
execute if score sloop int matches 1.. run function dcmd:process/loop

#回溯到-1号cb的位置
tp @s ~ ~ ~