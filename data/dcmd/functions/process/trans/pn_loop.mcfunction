#告示牌合并
data modify block 29999984 0 8591 Text1 set value '[{"nbt":"Text1","block":"29999984 0 8591","interpret":true},{"nbt":"sstemp[0]","storage":"dcmd:io","interpret":true}]'

#递归迭代
data remove storage dcmd:io sstemp[0]
scoreboard players remove ssloop int 1
execute if score ssloop int matches 1.. run function dcmd:process/trans/pn_loop