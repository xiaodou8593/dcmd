#告示牌解析
data modify block 29999984 0 8591 Text1 set value '[{"text":"execute at @e[tag=dcmd_tmp,limit=1] run data modify storage dcmd:io result set string block ~ ~ ~ LastOutput "},{"nbt":"input.slice.index[0]","storage":"dcmd:io"},{"text":" "},{"nbt":"input.slice.index[1]","storage":"dcmd:io"}]'
data modify storage dcmd:io input.cb_list[-1].pre_name append from block 29999984 0 8591 Text1