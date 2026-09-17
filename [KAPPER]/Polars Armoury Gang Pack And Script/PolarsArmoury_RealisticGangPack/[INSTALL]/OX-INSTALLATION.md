#################################################################################################
## [Installation]
- Install the latest version of Zyke_lib from https://github.com/Zyke-Resources/zyke_lib and ensure it in your cfg before PolarsArmoury_RealisticGangPack and PolarsArmoury_StreetCraft
- Put the ``PolarsArmoury_RealisticGangPack`` AND ``PolarsArmoury_StreetCraft`` folder into your ``resources`` folder and ensure BOTH packs in your cfg make sure it is above inventory and ox_lib. and below zyke_lib
- Or you may add the pack to a folder with [] that is already ensured to conserve space. however if you experiance issues we reccommend to ensure it solo. 

# SUMMARY
# STEP 1: ADD IMAGES TO INVENTORY   ■   [ox_inventory/web/images]
# STEP 2: ADD FIRST CODE LIST TO    ■   [ox_inventory/data/weapons.lua]
# STEP 3: ADD CODE TO ITEMS.LUA     ■   [ox_inventory/data/items.lua]
[#################################################################################################]


# STEP 2: ADD FIRST CODE LIST TO    ■   [ox_inventory/data/weapons.lua]

--- Polars Realitic Gang Pack
--     Katanaas
['WEAPON_LGBTQGKATTANA'] = {
    label = 'LGBTQ Gang Kattana',
    weight = 500,
},
['WEAPON_RGKATTANA'] = {
    label = 'Red Gang Kattana',
    weight = 500,
},
['WEAPON_BGKATANA'] = {
    label = 'Blue Gang Kattana',
    weight = 500,
},
['WEAPON_OGKATANA'] = {
    label = 'Orange Gang Kattana',
    weight = 500,
},
['WEAPON_PGKATANA'] = {
    label = 'Purple Gang Kattana',
    weight = 500,
},
['WEAPON_GGKATANA'] = {
    label = 'Green Gang Kattana',
    weight = 500,
},
['WEAPON_PINKGKATANA'] = {
    label = 'Pink Gang Kattana',
    weight = 500,
},
['WEAPON_LBGKATANA'] = {
    label = 'Light Blue Gang Kattana',
    weight = 500,
},
['WEAPON_YGKATANA'] = {
    label = 'Yellow Gang Kattana',
    weight = 500,
},
['WEAPON_BLACKGKATANA'] = {
    label = 'Black Gang Kattana',
    weight = 500,
},
['WEAPON_WGKATANA'] = {
    label = 'White Gang Kattana',
    weight = 500,
},
['WEAPON_BRGKATANA'] = {
    label = 'Brown Gang Kattana',
    weight = 500,
},
['WEAPON_OLIVEGKATANA'] = {
    label = 'Olive Gang Kattana',
    weight = 500,
},
['WEAPON_GREYGKAT'] = {
    label = 'Grey Gang Kattana',
    weight = 500,
},
--- machetes
['WEAPON_LGBTQGMACH'] = {
    label = 'LGBTQ Gang Machete',
    weight = 500,
},
['WEAPON_RGMACH'] = {
    label = 'Red Gang Machete',
    weight = 500,
},
['WEAPON_ORGMACH'] = {
    label = 'Orange Gang Machete',
    weight = 500,
},
['WEAPON_BRGMACH'] = {
    label = 'Brown Gang Machete',
    weight = 500,
},
['WEAPON_YGMACH'] = {
    label = 'Yellow Gang Machete',
    weight = 500,
},
['WEAPON_WGMACH'] = {
    label = 'White Gang Machete',
    weight = 500,
},
['WEAPON_PGMACH'] = {
    label = 'Purple Gang Machete',
    weight = 500,
},
['WEAPON_OLGMACH'] = {
    label = 'Olive Gang Machete',
    weight = 500,
},
['WEAPON_LBGMACH'] = {
    label = 'LightBlue Gang Machete',
    weight = 500,
},
['WEAPON_GREYGMACH'] = {
    label = 'Grey Gang Machete',
    weight = 500,
},
['WEAPON_GGMACH'] = {
    label = 'Green Gang Machete',
    weight = 500,
},
['WEAPON_BLGMACH'] = {
    label = 'Black Gang Machete',
    weight = 500,
},
['WEAPON_PINKGMACH'] = {
    label = 'Pink Gang Machete',
    weight = 500,
},
['WEAPON_BGMACH'] = {
    label = 'Blue Gang Machete',
    weight = 500,
},
-------- knifes
['WEAPON_LGBTQGKNIFE'] = {
    label = 'LGBTQ Gang Knife',
    weight = 500,
},
['WEAPON_RGKNIFE'] = {
    label = 'Red Gang Knife',
    weight = 500,
},
['WEAPON_BGKNIFE'] = {
    label = 'Blue Gang Knife',
    weight = 500,
},
['WEAPON_OGKNIFE'] = {
    label = 'Orange Gang Knife',
    weight = 500,
},
['WEAPON_PGKNIFE'] = {
    label = 'Purple Gang Knife',
    weight = 500,
},
['WEAPON_GGKNIFE'] = {
    label = 'Green Gang Knife',
    weight = 500,
},
['WEAPON_PINKGKNIFE'] = {
    label = 'Pink Gang Knife',
    weight = 500,
},
['WEAPON_LBGKNIFE'] = {
    label = 'Light Blue Gang Knife',
    weight = 500,
},
['WEAPON_YGKNIFE'] = {
    label = 'Yellow Gang Knife',
    weight = 500,
},
['WEAPON_BLGKNIFE'] = {
    label = 'Black Gang Knife',
    weight = 500,
},
['WEAPON_WGKNIFE'] = {
    label = 'White Gang Knife',
    weight = 500,
},
['WEAPON_BRGKNIFE'] = {
    label = 'Brown Gang Knife',
    weight = 500,
},
['WEAPON_OLIVEGKNIFE'] = {
    label = 'Olive Gang Knife',
    weight = 500,
},
['WEAPON_GREYGKNIFE'] = {
    label = 'Grey Gang Knife',
    weight = 500,
},
--- plane weapons
['WEAPON_PBAT'] = {
    label = 'Baseball Bat ',
    weight = 500,
},
['WEAPON_NORMSBAT'] = {
    label = 'Spikey Baseball Bat ',
    weight = 500,
},
['WEAPON_NORMKNIFE'] = {
    label = 'Knife ',
    weight = 500,
},
['WEAPON_NORMKATANA'] = {
    label = 'Katana ',
    weight = 500,
},
['WEAPON_NORMBFK'] = {
    label = 'Butterfly Knife ',
    weight = 500,
},
['WEAPON_NORMMACHETE'] = {
    label = 'Machete ',
    weight = 500,
},
['WEAPON_NORMHATCHET'] = {
    label = 'Hatchet ',
    weight = 500,
},
['WEAPON_NORMSLEDGE'] = {
    label = 'Sledgehammer ',
    weight = 500,
},
--- Spikey Bandana Bat
['WEAPON_LGBTQGSBAT'] = {
    label = 'LGBTQ Spikey Gang Bat',
    weight = 500,
},
['WEAPON_RSGBAT'] = {
    label = 'Red Spikey Bat ',
    weight = 500,
},
['WEAPON_BSGBAT'] = {
    label = 'Blue Spikey Gang Bat',
    weight = 500,
},
['WEAPON_OSGBAT'] = {
    label = 'Orange Spikey Gang Bat',
    weight = 500,
},
['WEAPON_PSGBAT'] = {
    label = 'Purple Spikey Gang Bat',
    weight = 500,
},
['WEAPON_GSGBAT'] = {
    label = 'Green Spikey Gang Bat',
    weight = 500,
},
['WEAPON_PINKSGBAT'] = {
    label = 'Pink Spikey Gang Bat',
    weight = 500,
},
['WEAPON_LBSGBAT'] = {
    label = 'Light Blue Spikey Gang Bat',
    weight = 500,
},
['WEAPON_YSGBAT'] = {
    label = 'Yellow Spikey Gang Bat',
    weight = 500,
},
['WEAPON_BLSGBAT'] = {
    label = 'Black Spikey Gang Bat',
    weight = 500,
},
['WEAPON_WSGBAT'] = {
    label = 'White Spikey Gang Bat',
    weight = 500,
},
['WEAPON_BROWNYSBAT'] = {
    label = 'Brown Spikey Gang Bat',
    weight = 500,
},
['WEAPON_OLIVESGBAT'] = {
    label = 'Olive Spikey Gang Bat',
    weight = 500,
},
['WEAPON_GREYSGBAT'] = {
    label = 'Grey Spikey Gang Bat',
    weight = 500,
},
--- Bandana Bat
['WEAPON_LGBTQGBBAT'] = {
    label = 'LGBTQ B Gang Bat',
    weight = 500,
},
['WEAPON_RBGBAT'] = {
    label = 'Red B Gang Bat',
    weight = 500,
},
['WEAPON_OLIVEBGBAT'] = {
    label = 'Olive B Gang Bat',
    weight = 500,
},
['WEAPON_BBGBAT'] = {
    label = 'Blue B Gang Bat',
    weight = 500,
},
['WEAPON_LBBGBAT'] = {
    label = 'Light B B Gang Bat',
    weight = 500,
},
['WEAPON_GBGBAT'] = {
    label = 'Green B Gang Bat',
    weight = 500,
},
['WEAPON_BOBGBAT'] = {
    label = 'Brown B Gang Bat',
    weight = 500,
},
['WEAPON_PIBGBAT'] = {
    label = 'Pink B Gang Bat',
    weight = 500,
},
['WEAPON_ORABGBAT'] = {
    label = 'Orange B Gang Bat',
    weight = 500,
},
['WEAPON_GREYBGBAT'] = {
    label = 'Grey B Gang Bat',
    weight = 500,
},
['WEAPON_YEBGBAT'] = {
    label = 'Yellow B Gang Bat',
    weight = 500,
},
['WEAPON_BLBGBAT'] = {
    label = 'Black B Gang Bat',
    weight = 500,
},
['WEAPON_WHBGBAT'] = {
    label = 'White B Gang Bat',
    weight = 500,
},
['WEAPON_PUBBGBAT'] = {
    label = 'Purple B Gang Bat',
    weight = 500,
},
--- hatchets
['WEAPON_LGBTQGHATCHET'] = {
    label = 'LGBTQ Gang Hatchet',
    weight = 500,
},
['WEAPON_RGHATCHET'] = {
    label = 'Red Hatchet',
    weight = 500,
},
['WEAPON_BGHATCHET'] = {
    label = 'Blue Hatchet',
    weight = 500,
},
['WEAPON_YGHATCHET'] = {
    label = 'Yellow Hatchet',
    weight = 500,
},
['WEAPON_PUGHATCHET'] = {
    label = 'Purple Hatchet',
    weight = 500,
},
['WEAPON_PGHATCHET'] = {
    label = 'Pink Hatchet',
    weight = 500,
},
['WEAPON_OGHATCHET'] = {
    label = 'Orange Hatchet',
    weight = 500,
},
['WEAPON_OLGHATCHET'] = {
    label = 'Olive Hatchet',
    weight = 500,
},
['WEAPON_LBGHATCHET'] = {
    label = 'Light Blue Hatchet',
    weight = 500,
},
['WEAPON_GREYGHATCHET'] = {
    label = 'Grey Hatchet',
    weight = 500,
},
['WEAPON_GGHATCHET'] = {
    label = 'Green Hatchet',
    weight = 500,
},
['WEAPON_BLGHATCHET'] = {
    label = 'Black Hatchet',
    weight = 500,
},
['WEAPON_BRGHATCHET'] = {
    label = 'Brown Hatchet',
    weight = 500,
},
['WEAPON_WGHATCHET'] = {
    label = 'White Hatchet',
    weight = 500,
},
---- butterfly knife
['WEAPON_LGBTQGBFKNIFE'] = {
    label = 'LGBTQ Butterfly Knife',
    weight = 500,
},
['WEAPON_RGBKNIFE'] = {
    label = 'Red Butterfly Knife',
    weight = 500,
},
['WEAPON_BLGBKNIFE'] = {
    label = 'Black Butterfly Knife',
    weight = 500,
},
['WEAPON_BGBKNIFE'] = {
    label = 'Blue Butterfly Knife',
    weight = 500,
},
['WEAPON_BRGBKNIFE'] = {
    label = 'Brown Butterfly Knife',
    weight = 500,
},
['WEAPON_GGBKNIFE'] = {
    label = 'Green Butterfly Knife',
    weight = 500,
},
['WEAPON_GREYGBKNIFE'] = {
    label = 'Grey Butterfly Knife',
    weight = 500,
},
['WEAPON_LBGBKNIFE'] = {
    label = 'Light Blue Butterfly Knife',
    weight = 500,
},
['WEAPON_OGBKNIFE'] = {
    label = 'Orange Butterfly Knife',
    weight = 500,
},
['WEAPON_PGBKNIFE'] = {
    label = 'Pink Butterfly Knife',
    weight = 500,
},
['WEAPON_PUGBKNIFE'] = {
    label = 'Purple Butterfly Knife',
    weight = 500,
},
['WEAPON_WGBKNIFE'] = {
    label = 'White Butterfly Knife',
    weight = 500,
},
['WEAPON_YGBKNIFE'] = {
    label = 'Yellow Butterfly Knife',
    weight = 500,
},
['WEAPON_OLGBKNIFE'] = {
    label = 'Olive Butterfly Knife',
    weight = 500,
},
--- molotovs
['WEAPON_LGBTQMOLOTOV'] = {
    label = 'LGBTQ Gang Molotov',
    weight = 1800,
    throwable = true,
},
['WEAPON_RGMOLOTOV'] = {
    label = 'Red Gang Molotov',
    weight = 1800,
    throwable = true,
},
['WEAPON_OLMOLOTOV'] = {
    label = 'Olive Gang Molotov',
    weight = 1800,
    throwable = true,
},
['WEAPON_OMOLOTOV'] = {
    label = 'Orange Gang Molotov',
    weight = 1800,
    throwable = true,
},
['WEAPON_PMOLOTOV'] = {
    label = 'Pink Gang Molotov',
    weight = 1800,
    throwable = true,
},
['WEAPON_WMOLOTOV'] = {
    label = 'White Gang Molotov',
    weight = 1800,
    throwable = true,
},
['WEAPON_YMOLOTOV'] = {
    label = 'Yellow Gang Molotov',
    weight = 1800,
    throwable = true,
},
['WEAPON_PUMOLOTOV'] = {
    label = 'Purple Gang Molotov',
    weight = 1800,
    throwable = true,
},
['WEAPON_GMOLOTOV'] = {
    label = 'Green Gang Molotov',
    weight = 1800,
    throwable = true,
},
['WEAPON_GREYMOLOTOV'] = {
    label = 'Grey Gang Molotov',
    weight = 1800,
    throwable = true,
},
['WEAPON_LBMOLOTOV'] = {
    label = 'Light Blue Gang Molotov',
    weight = 1800,
    throwable = true,
},
['WEAPON_BLMOLOTOV'] = {
    label = 'Black Gang Molotov',
    weight = 1800,
    throwable = true,
},
['WEAPON_BMOLOTOV'] = {
    label = 'Blue Gang Molotov',
    weight = 1800,
    throwable = true,
},
['WEAPON_BRMOLOTOV'] = {
    label = 'Brown Gang Molotov',
    weight = 1800,
    throwable = true,
},
------- sledgehammer
['WEAPON_LGBTQGSHAMMER'] = {
    label = 'LGBTQ Gang Sledgehammer',
    weight = 500,
},
['WEAPON_REDSHAMMER'] = {
    label = 'Red Gang Sledgehammer',
    weight = 1800,
},
['WEAPON_BLSHAMMER'] = {
    label = 'Black Gang Sledgehammer',
    weight = 1800,
},
['WEAPON_BSHAMMER'] = {
    label = 'Blue Gang Sledgehammer',
    weight = 1800,
},
['WEAPON_BRSHAMMER'] = {
    label = 'Brown Gang Sledgehammer',
    weight = 1800,
},
['WEAPON_GSHAMMER'] = {
    label = 'Green Gang Sledgehammer',
    weight = 1800,
},
['WEAPON_GREYSHAMMER'] = {
    label = 'Grey Gang Sledgehammer',
    weight = 1800,
},
['WEAPON_LBSHAMMER'] = {
    label = 'Light Blue Gang Sledgehammer',
    weight = 1800,
},
['WEAPON_OGSHAMMER'] = {
    label = 'Orange Gang Sledgehammer',
    weight = 1800,
},
['WEAPON_OLGSHAMMER'] = {
    label = 'Olive Gang Sledgehammer',
    weight = 1800,
},
['WEAPON_PGSHAMMER'] = {
    label = 'Pink Gang Sledgehammer',
    weight = 1800,
},
['WEAPON_PUGSHAMMER'] = {
    label = 'Purple Gang Sledgehammer',
    weight = 1800,
},
['WEAPON_WGSHAMMER'] = {
    label = 'White Gang Sledgehammer',
    weight = 1800,
},
['WEAPON_YGSHAMMER'] = {
    label = 'Yellow Gang Sledgehammer',
    weight = 1800,
},


# STEP 3: ADD CODE TO ITEMS.LUA   ■       [ox_inventory/data/items.lua]

--- Polars Realitic Gang Pack

["lgbtqandbandana"] = {
    label = "Lgbtq Bandana",
    weight = 1,
    stack = true,
    close = true,
},
["greygandbandana"] = {
    label = "Grey Bandana",
    weight = 1,
    stack = true,
    close = true,
},
["blackgandbandana"] = {
    label = "Black Bandana",
    weight = 1,
    stack = true,
    close = true,
},
["bluegandbandana"] = {
    label = "Blue Bandana",
    weight = 1,
    stack = true,
    close = true,
},
["browngandbandana"] = {
    label = "Brown Bandana",
    weight = 1,
    stack = true,
    close = true,
},
["greengandbandana"] = {
    label = "Green Bandana",
    weight = 1,
    stack = true,
    close = true,
},
["lightbluegandbandana"] = {
    label = "Light Blue Bandana",
    weight = 1,
    stack = true,
    close = true,
},
["olivegandbandana"] = {
    label = "Olive Bandana",
    weight = 1,
    stack = true,
    close = true,
},
["orangegandbandana"] = {
    label = "Orange Bandana",
    weight = 1,
    stack = true,
    close = true,
},
["pinkgandbandana"] = {
    label = "Pink Bandana",
    weight = 1,
    stack = true,
    close = true,
},
["purplegandbandana"] = {
    label = "Purple Bandana",
    weight = 1,
    stack = true,
    close = true,
},
["redgandbandana"] = {
    label = "Red Bandana",
    weight = 1,
    stack = true,
    close = true,
},
["whitegandbandana"] = {
    label = "White Bandana",
    weight = 1,
    stack = true,
    close = true,
},
["yellowgandbandana"] = {
    label = "Yellow Bandana",
    weight = 1,
    stack = true,
    close = true,
},
["batnails"] = {
    label = "Nails",
    weight = 1,
    stack = true,
    close = true,
},
["pobeerbottle"] = {
    label = "Beer Bottle",
    weight = 1,
    stack = true,
    close = true,
},
["popetrolbottle"] = {
    label = "Petrol Bottle",
    weight = 1,
    stack = true,
    close = true,
},
