#生成任务marker
summon armor_stand 29999984 0 8591 {Tags:["result","dcmd_marker"],Marker:1b,ArmorItems:[{},{},{},{id:"minecraft:glass",Count:1b}]}
execute as @e[tag=result,limit=1] run function dcmd:process/marker_set