1- ensure weapons folder

2- add images to core_inventory/html/img

3- add the following to qb-core/shared/items.lua

    ['weapon_lgbtqgkattana'] = { name = 'weapon_lgbtqgkattana', label = 'LGBTQ Gang Kattana',category = 'weapons', ammotype = nil, useable = true, description = '' ,x = 2, y = 2},
    ['weapon_rgkattana'] = { name = 'weapon_rgkattana', label = 'Red Gang Kattana', category = 'weapons', ammotype = nil, useable = true, description = '' ,x = 2, y = 2},
    ['weapon_bgkatana'] = { name = 'weapon_bgkatana', label = 'Blue Gang Kattana', category = 'weapons', ammotype = nil, useable = true, description = '' ,x = 2, y = 2},
    ['weapon_ogkatana'] = { name = 'weapon_ogkatana', label = 'Orange Gang Kattana', category = 'weapons', ammotype = nil, useable = true, description = '' ,x = 2, y = 2},
    ['weapon_pgkatana'] = { name = 'weapon_pgkatana', label = 'Purple Gang Kattana', category = 'weapons', ammotype = nil, useable = true, description = '' ,x = 2, y = 2},
    ['weapon_ggkatana'] = { name = 'weapon_ggkatana', label = 'Green Gang Kattana', category = 'weapons', ammotype = nil, useable = true, description = '' ,x = 2, y = 2},
    ['weapon_pinkgkatana'] = { name = 'weapon_pinkgkatana', label = 'Pink Gang Kattana', category = 'weapons', ammotype = nil, useable = true, description = '' ,x = 2, y = 2},
    ['weapon_lbgkatana'] = { name = 'weapon_lbgkatana', label = 'Light Blue Gang Kattana', category = 'weapons', ammotype = nil, useable = true, description = '' ,x = 2, y = 2},
    ['weapon_ygkatana'] = { name = 'weapon_ygkatana', label = 'Yellow Gang Kattana', category = 'weapons', ammotype = nil, useable = true, description = '' ,x = 2, y = 2},
    ['weapon_blackgkatana'] = { name = 'weapon_blackgkatana', label = 'Black Gang Kattana', category = 'weapons', ammotype = nil, useable = true, description = '' ,x = 2, y = 2},
    ['weapon_wgkatana'] = { name = 'weapon_wgkatana', label = 'White Gang Kattana', category = 'weapons', ammotype = nil, useable = true, description = '' ,x = 2, y = 2},
    ['weapon_brgkatana'] = { name = 'weapon_brgkatana', label = 'Brown Gang Kattana', category = 'weapons', ammotype = nil, useable = true, description = '' ,x = 2, y = 2},
    ['weapon_olivegkatana'] = { name = 'weapon_olivegkatana', label = 'Olive Gang Kattana', category = 'weapons', ammotype = nil, useable = true, description = '' ,x = 2, y = 2},
    ['weapon_greygkat'] = { name = 'weapon_greygkat', label = 'Grey Gang Kattana', category = 'weapons', ammotype = nil, useable = true, description = '' ,x = 2, y = 2},
    --machete
    ['weapon_lgbtqgmach'] = { name = 'weapon_lgbtqgmach', label = 'LGBTQ Gang Machete', category = 'weapons', ammotype = nil, useable = true, description = '' ,x = 2, y = 2},
    ['weapon_rgmach'] = { name = 'weapon_rgmach', label = 'Red Gang Machete', category = 'weapons', ammotype = nil, useable = true, description = '' ,x = 2, y = 2},
    ['weapon_orgmach'] = { name = 'weapon_orgmach', label = 'Orange Gang Machete', category = 'weapons', ammotype = nil, useable = true, description = '' ,x = 2, y = 2},
    ['weapon_brgmach'] = { name = 'weapon_brgmach', label = 'Brown Gang Machete', category = 'weapons', ammotype = nil, useable = true, description = '' ,x = 2, y = 2},
    ['weapon_ygmach'] = { name = 'weapon_ygmach', label = 'Yellow Gang Machete', category = 'weapons', ammotype = nil, useable = true, description = '' ,x = 2, y = 2},
    ['weapon_wgmach'] = { name = 'weapon_wgmach', label = 'White Gang Machete', category = 'weapons', ammotype = nil, useable = true, description = '' ,x = 2, y = 2},
    ['weapon_pgmach'] = { name = 'weapon_pgmach', label = 'Purple Gang Machete', category = 'weapons', ammotype = nil, useable = true, description = '' ,x = 2, y = 2},
    ['weapon_olgmach'] = { name = 'weapon_olgmach', label = 'Olive Gang Machete', category = 'weapons', ammotype = nil, useable = true, description = '' ,x = 2, y = 2},
    ['weapon_lbgmach'] = { name = 'weapon_lbgmach', label = 'LightBlue Gang Machete', category = 'weapons', ammotype = nil, useable = true, description = '' ,x = 2, y = 2},
    ['weapon_greygmach'] = { name = 'weapon_greygmach', label = 'Grey Gang Machete', category = 'weapons', ammotype = nil, useable = true, description = '' ,x = 2, y = 2},
    ['weapon_ggmach'] = { name = 'weapon_ggmach', label = 'Green Gang Machete', category = 'weapons', ammotype = nil, useable = true, description = '' ,x = 2, y = 2},
    ['weapon_blgmach'] = { name = 'weapon_blgmach', label = 'Black Gang Machete', category = 'weapons', ammotype = nil, useable = true, description = '' ,x = 2, y = 2},
    ['weapon_pinkgmach'] = { name = 'weapon_pinkgmach', label = 'Pink Gang Machete', category = 'weapons', ammotype = nil, useable = true, description = '' ,x = 2, y = 2},
    ['weapon_bgmach'] = { name = 'weapon_bgmach', label = 'Blue Gang Machete', category = 'weapons', ammotype = nil, useable = true, description = '' ,x = 2, y = 2},
    --knives
    ['weapon_lgbtqgknife'] = { name = 'weapon_lgbtqgknife', label = 'LGBTQ Gang Knife', category = 'weapons', ammotype = nil, useable = true, description = '' ,x = 2, y = 2},
    ['weapon_rgknife'] = { name = 'weapon_rgknife', label = 'Red Gang Knife', category = 'weapons', ammotype = nil, useable = true, description = '' ,x = 2, y = 2},
    ['weapon_bgknife'] = { name = 'weapon_bgknife', label = 'Blue Gang Knife', category = 'weapons', ammotype = nil, useable = true, description = '' ,x = 2, y = 2},
    ['weapon_ogknife'] = { name = 'weapon_ogknife', label = 'Orange Gang Knife', category = 'weapons', ammotype = nil, useable = true, description = '' ,x = 2, y = 2},
    ['weapon_pgknife'] = { name = 'weapon_pgknife', label = 'Purple Gang Knife', category = 'weapons', ammotype = nil, useable = true, description = '' ,x = 2, y = 2},
    ['weapon_ggknife'] = { name = 'weapon_ggknife', label = 'Green Gang Knife', category = 'weapons', ammotype = nil, useable = true, description = '' ,x = 2, y = 2},
    ['weapon_pinkgknife'] = { name = 'weapon_pinkgknife', label = 'Pink Gang Knife', category = 'weapons', ammotype = nil, useable = true, description = '' ,x = 2, y = 2},
    ['weapon_lbgknife'] = { name = 'weapon_lbgknife', label = 'Light Blue Gang Knife', category = 'weapons', ammotype = nil, useable = true, description = '' ,x = 2, y = 2},
    ['weapon_ygknife'] = { name = 'weapon_ygknife', label = 'Yellow Gang Knife', category = 'weapons', ammotype = nil, useable = true, description = '' ,x = 2, y = 2},
    ['weapon_blgknife'] = { name = 'weapon_blgknife', label = 'Black Gang Knife', category = 'weapons', ammotype = nil, useable = true, description = '' ,x = 2, y = 2},
    ['weapon_wgknife'] = { name = 'weapon_wgknife', label = 'White Gang Knife', category = 'weapons', ammotype = nil, useable = true, description = '' ,x = 2, y = 2},
    ['weapon_brgknife'] = { name = 'weapon_brgknife', label = 'Brown Gang Knife', category = 'weapons', ammotype = nil, useable = true, description = '' ,x = 2, y = 2},
    ['weapon_olivegknife'] = { name = 'weapon_olivegknife', label = 'Olive Gang Knife', category = 'weapons', ammotype = nil, useable = true, description = '' ,x = 2, y = 2},
    ['weapon_greygknife'] = { name = 'weapon_greygknife', label = 'Grey Gang Knife', category = 'weapons', ammotype = nil, useable = true, description = '' ,x = 2, y = 2},
    --normal weapons
    ['weapon_pbat'] = { name = 'weapon_pbat', label = 'Baseball Bat ', category = 'weapons', ammotype = nil, useable = true, description = '' ,x = 2, y = 2},
    ['weapon_normsbat'] = { name = 'weapon_normsbat', label = 'Spikey Baseball Bat ', category = 'weapons', ammotype = nil, useable = true, description = '' ,x = 2, y = 2},
    ['weapon_normknife'] = { name = 'weapon_normknife', label = 'Knife ', category = 'weapons', ammotype = nil, useable = true, description = '' ,x = 2, y = 2},
    ['weapon_normkatana'] = { name = 'weapon_normkatana', label = 'Katana ', category = 'weapons', ammotype = nil, useable = true, description = '' ,x = 2, y = 2},
    ['weapon_normbfk'] = { name = 'weapon_normbfk', label = 'Butterfly Knife ', category = 'weapons', ammotype = nil, useable = true, description = '' ,x = 2, y = 2},
    ['weapon_normmachete'] = { name = 'weapon_normmachete', label = 'Machete ', category = 'weapons', ammotype = nil, useable = true, description = '' ,x = 2, y = 2},
    ['weapon_normhatchet'] = { name = 'weapon_normhatchet', label = 'Hatchet ', category = 'weapons', ammotype = nil, useable = true, description = '' ,x = 2, y = 2},
    ['weapon_normsledge'] = { name = 'weapon_normsledge', label = 'Sledgehammer ', category = 'weapons', ammotype = nil, useable = true, description = '' ,x = 2, y = 2},
    --spike bats
    ['weapon_lgbtqgsbat'] = { name = 'weapon_lgbtqgsbat', label = 'LGBTQ Spikey Gang Bat', category = 'weapons', ammotype = nil, useable = true, description = '' ,x = 2, y = 2},
    ['weapon_rsgbat'] = { name = 'weapon_rsgbat', label = 'Red Spikey Bat ', category = 'weapons', ammotype = nil, useable = true, description = '' ,x = 2, y = 2},
    ['weapon_bsgbat'] = { name = 'weapon_bsgbat', label = 'Blue Spikey Gang Bat', category = 'weapons', ammotype = nil, useable = true, description = '' ,x = 2, y = 2},
    ['weapon_osgbat'] = { name = 'weapon_osgbat', label = 'Orange Spikey Gang Bat', category = 'weapons', ammotype = nil, useable = true, description = '' ,x = 2, y = 2},
    ['weapon_psgbat'] = { name = 'weapon_psgbat', label = 'Purple Spikey Gang Bat', category = 'weapons', ammotype = nil, useable = true, description = '' ,x = 2, y = 2},
    ['weapon_gsgbat'] = { name = 'weapon_gsgbat', label = 'Green Spikey Gang Bat', category = 'weapons', ammotype = nil, useable = true, description = '' ,x = 2, y = 2},
    ['weapon_pinksgbat'] = { name = 'weapon_pinksgbat', label = 'Pink Spikey Gang Bat', category = 'weapons', ammotype = nil, useable = true, description = '' ,x = 2, y = 2},
    ['weapon_lbsgbat'] = { name = 'weapon_lbsgbat', label = 'Light Blue Spikey Gang Bat', category = 'weapons', ammotype = nil, useable = true, description = '' ,x = 2, y = 2},
    ['weapon_ysgbat'] = { name = 'weapon_ysgbat', label = 'Yellow Spikey Gang Bat', category = 'weapons', ammotype = nil, useable = true, description = '' ,x = 2, y = 2},
    ['weapon_blsgbat'] = { name = 'weapon_blsgbat', label = 'Black Spikey Gang Bat', category = 'weapons', ammotype = nil, useable = true, description = '' ,x = 2, y = 2},
    ['weapon_wsgbat'] = { name = 'weapon_wsgbat', label = 'White Spikey Gang Bat', category = 'weapons', ammotype = nil, useable = true, description = '' ,x = 2, y = 2},
    ['weapon_brownysbat'] = { name = 'weapon_brownysbat', label = 'Brown Spikey Gang Bat', category = 'weapons', ammotype = nil, useable = true, description = '' ,x = 2, y = 2},
    ['weapon_olivesgbat'] = { name = 'weapon_olivesgbat', label = 'Olive Spikey Gang Bat', category = 'weapons', ammotype = nil, useable = true, description = '' ,x = 2, y = 2},
    ['weapon_greysgbat'] = { name = 'weapon_greysgbat', label = 'Grey Spikey Gang Bat', category = 'weapons', ammotype = nil, useable = true, description = '' ,x = 2, y = 2},
    --bats
    ['weapon_lgbtqgbbat'] = { name = 'weapon_lgbtqgbbat', label = 'LGBTQ B Gang Bat', category = 'weapons', ammotype = nil, useable = true, description = '' ,x = 2, y = 2},
    ['weapon_rbgbat'] = { name = 'weapon_rbgbat', label = 'Red B Gang Bat', category = 'weapons', ammotype = nil, useable = true, description = '' ,x = 2, y = 2},
    ['weapon_olivebgbat'] = { name = 'weapon_olivebgbat', label = 'Olive B Gang Bat', category = 'weapons', ammotype = nil, useable = true, description = '' ,x = 2, y = 2},
    ['weapon_bbgbat'] = { name = 'weapon_bbgbat', label = 'Blue B Gang Bat', category = 'weapons', ammotype = nil, useable = true, description = '' ,x = 2, y = 2},
    ['weapon_lbbgbat'] = { name = 'weapon_lbbgbat', label = 'Light B B Gang Bat', category = 'weapons', ammotype = nil, useable = true, description = '' ,x = 2, y = 2},
    ['weapon_gbgbat'] = { name = 'weapon_gbgbat', label = 'Green B Gang Bat', category = 'weapons', ammotype = nil, useable = true, description = '' ,x = 2, y = 2},
    ['weapon_bobgbat'] = { name = 'weapon_bobgbat', label = 'Brown B Gang Bat', category = 'weapons', ammotype = nil, useable = true, description = '' ,x = 2, y = 2},
    ['weapon_pibgbat'] = { name = 'weapon_pibgbat', label = 'Pink B Gang Bat', category = 'weapons', ammotype = nil, useable = true, description = '' ,x = 2, y = 2},
    ['weapon_orabgbat'] = { name = 'weapon_orabgbat', label = 'Orange B Gang Bat', category = 'weapons', ammotype = nil, useable = true, description = '' ,x = 2, y = 2},
    ['weapon_greybgbat'] = { name = 'weapon_greybgbat', label = 'Grey B Gang Bat', category = 'weapons', ammotype = nil, useable = true, description = '' ,x = 2, y = 2},
    ['weapon_yebgbat'] = { name = 'weapon_yebgbat', label = 'Yellow B Gang Bat', category = 'weapons', ammotype = nil, useable = true, description = '' ,x = 2, y = 2},
    ['weapon_blbgbat'] = { name = 'weapon_blbgbat', label = 'Black B Gang Bat', category = 'weapons', ammotype = nil, useable = true, description = '' ,x = 2, y = 2},
    ['weapon_whbgbat'] = { name = 'weapon_whbgbat', label = 'White B Gang Bat', category = 'weapons', ammotype = nil, useable = true, description = '' ,x = 2, y = 2},
    ['weapon_pubbgbat'] = { name = 'weapon_pubbgbat', label = 'Purple B Gang Bat', category = 'weapons', ammotype = nil, useable = true, description = '' ,x = 2, y = 2},
    --hatchets
    ['weapon_lgbtqghatchet'] = { name = 'weapon_lgbtqghatchet', label = 'LGBTQ Gang Hatchet', category = 'weapons', ammotype = nil, useable = true, description = '' ,x = 2, y = 2},
    ['weapon_rghatchet'] = { name = 'weapon_rghatchet', label = 'Red Hatchet', category = 'weapons', ammotype = nil, useable = true, description = '' ,x = 2, y = 2},
    ['weapon_bghatchet'] = { name = 'weapon_bghatchet', label = 'Blue Hatchet', category = 'weapons', ammotype = nil, useable = true, description = '' ,x = 2, y = 2},
    ['weapon_yghatchet'] = { name = 'weapon_yghatchet', label = 'Yellow Hatchet', category = 'weapons', ammotype = nil, useable = true, description = '' ,x = 2, y = 2},
    ['weapon_pughatchet'] = { name = 'weapon_pughatchet', label = 'Purple Hatchet', category = 'weapons', ammotype = nil, useable = true, description = '' ,x = 2, y = 2},
    ['weapon_pghatchet'] = { name = 'weapon_pghatchet', label = 'Pink Hatchet', category = 'weapons', ammotype = nil, useable = true, description = '' ,x = 2, y = 2},
    ['weapon_oghatchet'] = { name = 'weapon_oghatchet', label = 'Orange Hatchet', category = 'weapons', ammotype = nil, useable = true, description = '' ,x = 2, y = 2},
    ['weapon_olghatchet'] = { name = 'weapon_olghatchet', label = 'Olive Hatchet', category = 'weapons', ammotype = nil, useable = true, description = '' ,x = 2, y = 2},
    ['weapon_lbghatchet'] = { name = 'weapon_lbghatchet', label = 'Light Blue Hatchet', category = 'weapons', ammotype = nil, useable = true, description = '' ,x = 2, y = 2},
    ['weapon_greyghatchet'] = { name = 'weapon_greyghatchet', label = 'Grey Hatchet', category = 'weapons', ammotype = nil, useable = true, description = '' ,x = 2, y = 2},
    ['weapon_gghatchet'] = { name = 'weapon_gghatchet', label = 'Green Hatchet', category = 'weapons', ammotype = nil, useable = true, description = '' ,x = 2, y = 2},
    ['weapon_blghatchet'] = { name = 'weapon_blghatchet', label = 'Black Hatchet', category = 'weapons', ammotype = nil, useable = true, description = '' ,x = 2, y = 2},
    ['weapon_brghatchet'] = { name = 'weapon_brghatchet', label = 'Brown Hatchet', category = 'weapons', ammotype = nil, useable = true, description = '' ,x = 2, y = 2},
    ['weapon_wghatchet'] = { name = 'weapon_wghatchet', label = 'White Hatchet', category = 'weapons', ammotype = nil, useable = true, description = '' ,x = 2, y = 2},
    --butterfly knives
    ['weapon_lgbtqgbfknife'] = { name = 'weapon_lgbtqgbfknife', label = 'LGBTQ Butterfly Knife', category = 'weapons', ammotype = nil, useable = true, description = '' ,x = 2, y = 2},
    ['weapon_rgbknife'] = { name = 'weapon_rgbknife', label = 'Red Butterfly Knife', category = 'weapons', ammotype = nil, useable = true, description = '' ,x = 2, y = 2},
    ['weapon_blgbknife'] = { name = 'weapon_blgbknife', label = 'Black Butterfly Knife', category = 'weapons', ammotype = nil, useable = true, description = '' ,x = 2, y = 2},
    ['weapon_bgbknife'] = { name = 'weapon_bgbknife', label = 'Blue Butterfly Knife', category = 'weapons', ammotype = nil, useable = true, description = '' ,x = 2, y = 2},
    ['weapon_brgbknife'] = { name = 'weapon_brgbknife', label = 'Brown Butterfly Knife', category = 'weapons', ammotype = nil, useable = true, description = '' ,x = 2, y = 2},
    ['weapon_ggbknife'] = { name = 'weapon_ggbknife', label = 'Green Butterfly Knife', category = 'weapons', ammotype = nil, useable = true, description = '' ,x = 2, y = 2},
    ['weapon_greygbknife'] = { name = 'weapon_greygbknife', label = 'Grey Butterfly Knife', category = 'weapons', ammotype = nil, useable = true, description = '' ,x = 2, y = 2},
    ['weapon_lbgbknife'] = { name = 'weapon_lbgbknife', label = 'Light Blue Butterfly Knife', category = 'weapons', ammotype = nil, useable = true, description = '' ,x = 2, y = 2},
    ['weapon_ogbknife'] = { name = 'weapon_ogbknife', label = 'Orange Butterfly Knife', category = 'weapons', ammotype = nil, useable = true, description = '' ,x = 2, y = 2},
    ['weapon_pgbknife'] = { name = 'weapon_pgbknife', label = 'Pink Butterfly Knife', category = 'weapons', ammotype = nil, useable = true, description = '' ,x = 2, y = 2},
    ['weapon_pugbknife'] = { name = 'weapon_pugbknife', label = 'Purple Butterfly Knife', category = 'weapons', ammotype = nil, useable = true, description = '' ,x = 2, y = 2},
    ['weapon_wgbknife'] = { name = 'weapon_wgbknife', label = 'White Butterfly Knife', category = 'weapons', ammotype = nil, useable = true, description = '' ,x = 2, y = 2},
    ['weapon_ygbknife'] = { name = 'weapon_ygbknife', label = 'Yellow Butterfly Knife', category = 'weapons', ammotype = nil, useable = true, description = '' ,x = 2, y = 2},
    ['weapon_olgbknife'] = { name = 'weapon_olgbknife', label = 'Olive Butterfly Knife', category = 'weapons', ammotype = nil, useable = true, description = '' ,x = 2, y = 2},
    --molotovs
    ['weapon_lgbtqmolotov'] = { name = 'weapon_lgbtqmolotov', label = 'LGBTQ Gang Molotov', category = 'weapons', ammotype = nil, useable = true, description = '' ,x = 2, y = 2},
    ['weapon_rgmolotov'] = { name = 'weapon_rgmolotov', label = 'Red Gang Molotov', category = 'weapons', ammotype = nil, useable = true, description = '' ,x = 2, y = 2},
    ['weapon_olmolotov'] = { name = 'weapon_olmolotov', label = 'Olive Gang Molotov', category = 'weapons', ammotype = nil, useable = true, description = '' ,x = 2, y = 2},
    ['weapon_omolotov'] = { name = 'weapon_omolotov', label = 'Orange Gang Molotov', category = 'weapons', ammotype = nil, useable = true, description = '' ,x = 2, y = 2},
    ['weapon_pmolotov'] = { name = 'weapon_pmolotov', label = 'Pink Gang Molotov', category = 'weapons', ammotype = nil, useable = true, description = '' ,x = 2, y = 2},
    ['weapon_wmolotov'] = { name = 'weapon_wmolotov', label = 'White Gang Molotov', category = 'weapons', ammotype = nil, useable = true, description = '' ,x = 2, y = 2},
    ['weapon_ymolotov'] = { name = 'weapon_ymolotov', label = 'Yellow Gang Molotov', category = 'weapons', ammotype = nil, useable = true, description = '' ,x = 2, y = 2},
    ['weapon_pumolotov'] = { name = 'weapon_pumolotov', label = 'Purple Gang Molotov', category = 'weapons', ammotype = nil, useable = true, description = '' ,x = 2, y = 2},
    ['weapon_gmolotov'] = { name = 'weapon_gmolotov', label = 'Green Gang Molotov', category = 'weapons', ammotype = nil, useable = true, description = '' ,x = 2, y = 2},
    ['weapon_greymolotov'] = { name = 'weapon_greymolotov', label = 'Grey Gang Molotov', category = 'weapons', ammotype = nil, useable = true, description = '' ,x = 2, y = 2},
    ['weapon_lbmolotov'] = { name = 'weapon_lbmolotov', label = 'Light Blue Gang Molotov', category = 'weapons', ammotype = nil, useable = true, description = '' ,x = 2, y = 2},
    ['weapon_blmolotov'] = { name = 'weapon_blmolotov', label = 'Black Gang Molotov', category = 'weapons', ammotype = nil, useable = true, description = '' ,x = 2, y = 2},
    ['weapon_bmolotov'] = { name = 'weapon_bmolotov', label = 'Blue Gang Molotov', category = 'weapons', ammotype = nil, useable = true, description = '' ,x = 2, y = 2},
    ['weapon_brmolotov'] = { name = 'weapon_brmolotov', label = 'Brown Gang Molotov', category = 'weapons', ammotype = nil, useable = true, description = '' ,x = 2, y = 2},
    --sledgehammers
    ['weapon_lgbtqgshammer'] = { name = 'weapon_lgbtqgshammer', label = 'LGBTQ Gang Sledgehammer', category = 'weapons', ammotype = nil, useable = true, description = '' ,x = 2, y = 2},
    ['weapon_redshammer'] = { name = 'weapon_redshammer', label = 'Red Gang Sledgehammer', category = 'weapons', ammotype = nil, useable = true, description = '' ,x = 2, y = 2},
    ['weapon_blshammer'] = { name = 'weapon_blshammer', label = 'Black Gang Sledgehammer', category = 'weapons', ammotype = nil, useable = true, description = '' ,x = 2, y = 2},
    ['weapon_bshammer'] = { name = 'weapon_bshammer', label = 'Blue Gang Sledgehammer', category = 'weapons', ammotype = nil, useable = true, description = '' ,x = 2, y = 2},
    ['weapon_brshammer'] = { name = 'weapon_brshammer', label = 'Brown Gang Sledgehammer', category = 'weapons', ammotype = nil, useable = true, description = '' ,x = 2, y = 2},
    ['weapon_gshammer'] = { name = 'weapon_gshammer', label = 'Green Gang Sledgehammer', category = 'weapons', ammotype = nil, useable = true, description = '' ,x = 2, y = 2},
    ['weapon_greyshammer'] = { name = 'weapon_greyshammer', label = 'Grey Gang Sledgehammer', category = 'weapons', ammotype = nil, useable = true, description = '' ,x = 2, y = 2},
    ['weapon_lbshammer'] = { name = 'weapon_lbshammer', label = 'Light Blue Gang Sledgehammer', category = 'weapons', ammotype = nil, useable = true, description = '' ,x = 2, y = 2},
    ['weapon_ogshammer'] = { name = 'weapon_ogshammer', label = 'Orange Gang Sledgehammer', category = 'weapons', ammotype = nil, useable = true, description = '' ,x = 2, y = 2},
    ['weapon_olgshammer'] = { name = 'weapon_olgshammer', label = 'Olive Gang Sledgehammer', category = 'weapons', ammotype = nil, useable = true, description = '' ,x = 2, y = 2},
    ['weapon_pgshammer'] = { name = 'weapon_pgshammer', label = 'Pink Gang Sledgehammer', category = 'weapons', ammotype = nil, useable = true, description = '' ,x = 2, y = 2},
    ['weapon_pugshammer'] = { name = 'weapon_pugshammer', label = 'Purple Gang Sledgehammer', category = 'weapons', ammotype = nil, useable = true, description = '' ,x = 2, y = 2},
    ['weapon_wgshammer'] = { name = 'weapon_wgshammer', label = 'White Gang Sledgehammer', category = 'weapons', ammotype = nil, useable = true, description = '' ,x = 2, y = 2},
    ['weapon_ygshammer'] = { name = 'weapon_ygshammer', label = 'Yellow Gang Sledgehammer', category = 'weapons', ammotype = nil, useable = true, description = '' ,x = 2, y = 2},
    --bandanas
    ["lgbtqandbandana"] = { name = "lgbtqandbandana", label = "Lgbtq Bandana", category = 'misc', useable = false, description = "" ,x = 1, y = 1},
    ["greygandbandana"] = { name = "greygandbandana", label = "Grey Bandana", category = 'misc', useable = false, description = "" ,x = 1, y = 1},
    ["blackgandbandana"] = { name = "blackgandbandana", label = "Black Bandana", category = 'misc', useable = false, description = "" ,x = 1, y = 1},
    ["bluegandbandana"] = { name = "bluegandbandana", label = "Blue Bandana", category = 'misc', useable = false, description = "" ,x = 1, y = 1},
    ["browngandbandana"] = { name = "browngandbandana", label = "Brown Bandana", category = 'misc', useable = false, description = "" ,x = 1, y = 1},
    ["greengandbandana"] = { name = "greengandbandana", label = "Green Bandana", category = 'misc', useable = false, description = "" ,x = 1, y = 1},
    ["lightbluegandbandana"] = { name = "lightbluegandbandana", label = "Light Blue Bandana", category = 'misc', useable = false, description = "" ,x = 1, y = 1},
    ["olivegandbandana"] = { name = "olivegandbandana", label = "Olive Bandana", category = 'misc', useable = false, description = "" ,x = 1, y = 1},
    ["orangegandbandana"] = { name = "orangegandbandana", label = "Orange Bandana", category = 'misc', useable = false, description = "" ,x = 1, y = 1},
    ["pinkgandbandana"] = { name = "pinkgandbandana", label = "Pink Bandana", category = 'misc', useable = false, description = "" ,x = 1, y = 1},
    ["purplegandbandana"] = { name = "purplegandbandana", label = "Purple Bandana", category = 'misc', useable = false, description = "" ,x = 1, y = 1},
    ["redgandbandana"] = { name = "redgandbandana", label = "Red Bandana", category = 'misc', useable = false, description = "" ,x = 1, y = 1},
    ["whitegandbandana"] = { name = "whitegandbandana", label = "White Bandana", category = 'misc', useable = false, description = "" ,x = 1, y = 1},
    ["yellowgandbandana"] = { name = "yellowgandbandana", label = "Yellow Bandana", category = 'misc', useable = false, description = "" ,x = 1, y = 1},
    ["batnails"] = { name = "batnails", label = "Nails", category = 'misc', useable = false, description = "" ,x = 1, y = 1},
    ["popetrolbottle"] = { name = "popetrolbottle", label = "Petrol Bottle", category = 'misc', useable = false, description = "" ,x = 1, y = 1},
    ["pobeerbottle"] = { name = "pobeerbottle", label = "Beer Bottle", category = 'misc', useable = false, description = "" ,x = 1, y = 1},

4- add the following to qb-core/shared/weapons.lua

    -- Katanas
    ['weapon_lgbtqgkattana'] = { name = 'weapon_lgbtqgkattana', label = 'LGBTQ Gang Kattana', weapontype = 'Melee', ammotype = nil, damagereason = 'Melee Killed / Katanaed' },
    ['weapon_rgkattana'] = { name = 'weapon_rgkattana', label = 'Red Gang Kattana', weapontype = 'Melee', ammotype = nil, damagereason = 'Melee Killed / Katanaed' },
    ['weapon_bgkatana'] = { name = 'weapon_bgkatana', label = 'Blue Gang Kattana', weapontype = 'Melee', ammotype = nil, damagereason = 'Melee Killed / Katanaed' },
    ['weapon_ogkatana'] = { name = 'weapon_ogkatana', label = 'Orange Gang Kattana', weapontype = 'Melee', ammotype = nil, damagereason = 'Melee Killed / Katanaed' },
    ['weapon_pgkatana'] = { name = 'weapon_pgkatana', label = 'Purple Gang Kattana', weapontype = 'Melee', ammotype = nil, damagereason = 'Melee Killed / Katanaed' },
    ['weapon_ggkatana'] = { name = 'weapon_ggkatana', label = 'Green Gang Kattana', weapontype = 'Melee', ammotype = nil, damagereason = 'Melee Killed / Katanaed' },
    ['weapon_pinkgkatana'] = { name = 'weapon_pinkgkatana', label = 'Pink Gang Kattana', weapontype = 'Melee', ammotype = nil, damagereason = 'Melee Killed / Katanaed' },
    ['weapon_lbgkatana'] = { name = 'weapon_lbgkatana', label = 'Light Blue Gang Kattana', weapontype = 'Melee', ammotype = nil, damagereason = 'Melee Killed / Katanaed' },
    ['weapon_ygkatana'] = { name = 'weapon_ygkatana', label = 'Yellow Gang Kattana', weapontype = 'Melee', ammotype = nil, damagereason = 'Melee Killed / Katanaed' },
    ['weapon_blackgkatana'] = { name = 'weapon_blackgkatana', label = 'Black Gang Kattana', weapontype = 'Melee', ammotype = nil, damagereason = 'Melee Killed / Katanaed' },
    ['weapon_wgkatana'] = { name = 'weapon_wgkatana', label = 'White Gang Kattana', weapontype = 'Melee', ammotype = nil, damagereason = 'Melee Killed / Katanaed' },
    ['weapon_brgkatana'] = { name = 'weapon_brgkatana', label = 'Brown Gang Kattana', weapontype = 'Melee', ammotype = nil, damagereason = 'Melee Killed / Katanaed' },
    ['weapon_olivegkatana'] = { name = 'weapon_olivegkatana', label = 'Olive Gang Kattana', weapontype = 'Melee', ammotype = nil, damagereason = 'Melee Killed / Katanaed' },
    ['weapon_greygkat'] = { name = 'weapon_greygkat', label = 'Grey Gang Kattana', weapontype = 'Melee', ammotype = nil, damagereason = 'Melee Killed / Katanaed' },

    -- Machetes
    ['weapon_lgbtqgmach'] = { name = 'weapon_lgbtqgmach', label = 'LGBTQ Gang Machete', weapontype = 'Melee', ammotype = nil, damagereason = 'Melee Killed / Macheted' },
    ['weapon_rgmach'] = { name = 'weapon_rgmach', label = 'Red Gang Machete', weapontype = 'Melee', ammotype = nil, damagereason = 'Melee Killed / Macheted' },
    ['weapon_orgmach'] = { name = 'weapon_orgmach', label = 'Orange Gang Machete', weapontype = 'Melee', ammotype = nil, damagereason = 'Melee Killed / Macheted' },
    ['weapon_brgmach'] = { name = 'weapon_brgmach', label = 'Brown Gang Machete', weapontype = 'Melee', ammotype = nil, damagereason = 'Melee Killed / Macheted' },
    ['weapon_ygmach'] = { name = 'weapon_ygmach', label = 'Yellow Gang Machete', weapontype = 'Melee', ammotype = nil, damagereason = 'Melee Killed / Macheted' },
    ['weapon_wgmach'] = { name = 'weapon_wgmach', label = 'White Gang Machete', weapontype = 'Melee', ammotype = nil, damagereason = 'Melee Killed / Macheted' },
    ['weapon_pgmach'] = { name = 'weapon_pgmach', label = 'Purple Gang Machete', weapontype = 'Melee', ammotype = nil, damagereason = 'Melee Killed / Macheted' },
    ['weapon_olgmach'] = { name = 'weapon_olgmach', label = 'Olive Gang Machete', weapontype = 'Melee', ammotype = nil, damagereason = 'Melee Killed / Macheted' },
    ['weapon_lbgmach'] = { name = 'weapon_lbgmach', label = 'LightBlue Gang Machete', weapontype = 'Melee', ammotype = nil, damagereason = 'Melee Killed / Macheted' },
    ['weapon_greygmach'] = { name = 'weapon_greygmach', label = 'Grey Gang Machete', weapontype = 'Melee', ammotype = nil, damagereason = 'Melee Killed / Macheted' },
    ['weapon_ggmach'] = { name = 'weapon_ggmach', label = 'Green Gang Machete', weapontype = 'Melee', ammotype = nil, damagereason = 'Melee Killed / Macheted' },
    ['weapon_blgmach'] = { name = 'weapon_blgmach', label = 'Black Gang Machete', weapontype = 'Melee', ammotype = nil, damagereason = 'Melee Killed / Macheted' },
    ['weapon_pinkgmach'] = { name = 'weapon_pinkgmach', label = 'Pink Gang Machete', weapontype = 'Melee', ammotype = nil, damagereason = 'Melee Killed / Macheted' },
    ['weapon_bgmach'] = { name = 'weapon_bgmach', label = 'Blue Gang Machete', weapontype = 'Melee', ammotype = nil, damagereason = 'Melee Killed / Macheted' },

    -- Knives
    ['weapon_lgbtqgknife'] = { name = 'weapon_lgbtqgknife', label = 'LGBTQ Gang Knife', weapontype = 'Melee', ammotype = nil, damagereason = 'Melee Killed / Knifed' },
    ['weapon_rgknife'] = { name = 'weapon_rgknife', label = 'Red Gang Knife', weapontype = 'Melee', ammotype = nil, damagereason = 'Melee Killed / Knifed' },
    ['weapon_bgknife'] = { name = 'weapon_bgknife', label = 'Blue Gang Knife', weapontype = 'Melee', ammotype = nil, damagereason = 'Melee Killed / Knifed' },
    ['weapon_ogknife'] = { name = 'weapon_ogknife', label = 'Orange Gang Knife', weapontype = 'Melee', ammotype = nil, damagereason = 'Melee Killed / Knifed' },
    ['weapon_pgknife'] = { name = 'weapon_pgknife', label = 'Purple Gang Knife', weapontype = 'Melee', ammotype = nil, damagereason = 'Melee Killed / Knifed' },
    ['weapon_ggknife'] = { name = 'weapon_ggknife', label = 'Green Gang Knife', weapontype = 'Melee', ammotype = nil, damagereason = 'Melee Killed / Knifed' },
    ['weapon_pinkgknife'] = { name = 'weapon_pinkgknife', label = 'Pink Gang Knife', weapontype = 'Melee', ammotype = nil, damagereason = 'Melee Killed / Knifed' },
    ['weapon_lbgknife'] = { name = 'weapon_lbgknife', label = 'Light Blue Gang Knife', weapontype = 'Melee', ammotype = nil, damagereason = 'Melee Killed / Knifed' },
    ['weapon_ygknife'] = { name = 'weapon_ygknife', label = 'Yellow Gang Knife', weapontype = 'Melee', ammotype = nil, damagereason = 'Melee Killed / Knifed' },
    ['weapon_blgknife'] = { name = 'weapon_blgknife', label = 'Black Gang Knife', weapontype = 'Melee', ammotype = nil, damagereason = 'Melee Killed / Knifed' },
    ['weapon_wgknife'] = { name = 'weapon_wgknife', label = 'White Gang Knife', weapontype = 'Melee', ammotype = nil, damagereason = 'Melee Killed / Knifed' },
    ['weapon_brgknife'] = { name = 'weapon_brgknife', label = 'Brown Gang Knife', weapontype = 'Melee', ammotype = nil, damagereason = 'Melee Killed / Knifed' },
    ['weapon_olivegknife'] = { name = 'weapon_olivegknife', label = 'Olive Gang Knife', weapontype = 'Melee', ammotype = nil, damagereason = 'Melee Killed / Knifed' },
    ['weapon_greygknife'] = { name = 'weapon_greygknife', label = 'Grey Gang Knife', weapontype = 'Melee', ammotype = nil, damagereason = 'Melee Killed / Knifed' },

    -- Normal Weapons
    ['weapon_pbat'] = { name = 'weapon_pbat', label = 'Baseball Bat', weapontype = 'Melee', ammotype = nil, damagereason = 'Melee Killed / Battered' },
    ['weapon_normsbat'] = { name = 'weapon_normsbat', label = 'Spikey Baseball Bat', weapontype = 'Melee', ammotype = nil, damagereason = 'Melee Killed / Battered' },
    ['weapon_normknife'] = { name = 'weapon_normknife', label = 'Knife', weapontype = 'Melee', ammotype = nil, damagereason = 'Melee Killed / Knifed' },
    ['weapon_normkatana'] = { name = 'weapon_normkatana', label = 'Katana', weapontype = 'Melee', ammotype = nil, damagereason = 'Melee Killed / Katanaed' },
    ['weapon_normbfk'] = { name = 'weapon_normbfk', label = 'Butterfly Knife', weapontype = 'Melee', ammotype = nil, damagereason = 'Melee Killed / Knifed' },
    ['weapon_normmachete'] = { name = 'weapon_normmachete', label = 'Machete', weapontype = 'Melee', ammotype = nil, damagereason = 'Melee Killed / Macheted' },
    ['weapon_normhatchet'] = { name = 'weapon_normhatchet', label = 'Hatchet', weapontype = 'Melee', ammotype = nil, damagereason = 'Melee Killed / Chopped' },
    ['weapon_normsledge'] = { name = 'weapon_normsledge', label = 'Sledgehammer', weapontype = 'Melee', ammotype = nil, damagereason = 'Melee Killed / Smashed' },

    -- Spikey Bats
    ['weapon_lgbtqgsbat'] = { name = 'weapon_lgbtqgsbat', label = 'LGBTQ Spikey Gang Bat', weapontype = 'Melee', ammotype = nil, damagereason = 'Melee Killed / Battered' },
    ['weapon_rsgbat'] = { name = 'weapon_rsgbat', label = 'Red Spikey Bat', weapontype = 'Melee', ammotype = nil, damagereason = 'Melee Killed / Battered' },
    ['weapon_bsgbat'] = { name = 'weapon_bsgbat', label = 'Blue Spikey Gang Bat', weapontype = 'Melee', ammotype = nil, damagereason = 'Melee Killed / Battered' },
    ['weapon_osgbat'] = { name = 'weapon_osgbat', label = 'Orange Spikey Gang Bat', weapontype = 'Melee', ammotype = nil, damagereason = 'Melee Killed / Battered' },
    ['weapon_psgbat'] = { name = 'weapon_psgbat', label = 'Purple Spikey Gang Bat', weapontype = 'Melee', ammotype = nil, damagereason = 'Melee Killed / Battered' },
    ['weapon_gsgbat'] = { name = 'weapon_gsgbat', label = 'Green Spikey Gang Bat', weapontype = 'Melee', ammotype = nil, damagereason = 'Melee Killed / Battered' },
    ['weapon_pinksgbat'] = { name = 'weapon_pinksgbat', label = 'Pink Spikey Gang Bat', weapontype = 'Melee', ammotype = nil, damagereason = 'Melee Killed / Battered' },
    ['weapon_lbsgbat'] = { name = 'weapon_lbsgbat', label = 'Light Blue Spikey Gang Bat', weapontype = 'Melee', ammotype = nil, damagereason = 'Melee Killed / Battered' },
    ['weapon_ysgbat'] = { name = 'weapon_ysgbat', label = 'Yellow Spikey Gang Bat', weapontype = 'Melee', ammotype = nil, damagereason = 'Melee Killed / Battered' },
    ['weapon_blsgbat'] = { name = 'weapon_blsgbat', label = 'Black Spikey Gang Bat', weapontype = 'Melee', ammotype = nil, damagereason = 'Melee Killed / Battered' },
    ['weapon_wsgbat'] = { name = 'weapon_wsgbat', label = 'White Spikey Gang Bat', weapontype = 'Melee', ammotype = nil, damagereason = 'Melee Killed / Battered' },
    ['weapon_brownysbat'] = { name = 'weapon_brownysbat', label = 'Brown Spikey Gang Bat', weapontype = 'Melee', ammotype = nil, damagereason = 'Melee Killed / Battered' },
    ['weapon_olivesgbat'] = { name = 'weapon_olivesgbat', label = 'Olive Spikey Gang Bat', weapontype = 'Melee', ammotype = nil, damagereason = 'Melee Killed / Battered' },
    ['weapon_greysgbat'] = { name = 'weapon_greysgbat', label = 'Grey Spikey Gang Bat', weapontype = 'Melee', ammotype = nil, damagereason = 'Melee Killed / Battered' },

    -- Gang Bats
    ['weapon_lgbtqgbbat'] = { name = 'weapon_lgbtqgbbat', label = 'LGBTQ B Gang Bat', weapontype = 'Melee', ammotype = nil, damagereason = 'Melee Killed / Battered' },
    ['weapon_rbgbat'] = { name = 'weapon_rbgbat', label = 'Red B Gang Bat', weapontype = 'Melee', ammotype = nil, damagereason = 'Melee Killed / Battered' },
    ['weapon_olivebgbat'] = { name = 'weapon_olivebgbat', label = 'Olive B Gang Bat', weapontype = 'Melee', ammotype = nil, damagereason = 'Melee Killed / Battered' },
    ['weapon_bbgbat'] = { name = 'weapon_bbgbat', label = 'Blue B Gang Bat', weapontype = 'Melee', ammotype = nil, damagereason = 'Melee Killed / Battered' },
    ['weapon_lbbgbat'] = { name = 'weapon_lbbgbat', label = 'Light B B Gang Bat', weapontype = 'Melee', ammotype = nil, damagereason = 'Melee Killed / Battered' },
    ['weapon_gbgbat'] = { name = 'weapon_gbgbat', label = 'Green B Gang Bat', weapontype = 'Melee', ammotype = nil, damagereason = 'Melee Killed / Battered' },
    ['weapon_bobgbat'] = { name = 'weapon_bobgbat', label = 'Brown B Gang Bat', weapontype = 'Melee', ammotype = nil, damagereason = 'Melee Killed / Battered' },
    ['weapon_pibgbat'] = { name = 'weapon_pibgbat', label = 'Pink B Gang Bat', weapontype = 'Melee', ammotype = nil, damagereason = 'Melee Killed / Battered' },
    ['weapon_orabgbat'] = { name = 'weapon_orabgbat', label = 'Orange B Gang Bat', weapontype = 'Melee', ammotype = nil, damagereason = 'Melee Killed / Battered' },
    ['weapon_greybgbat'] = { name = 'weapon_greybgbat', label = 'Grey B Gang Bat', weapontype = 'Melee', ammotype = nil, damagereason = 'Melee Killed / Battered' },
    ['weapon_yebgbat'] = { name = 'weapon_yebgbat', label = 'Yellow B Gang Bat', weapontype = 'Melee', ammotype = nil, damagereason = 'Melee Killed / Battered' },
    ['weapon_blbgbat'] = { name = 'weapon_blbgbat', label = 'Black B Gang Bat', weapontype = 'Melee', ammotype = nil, damagereason = 'Melee Killed / Battered' },
    ['weapon_whbgbat'] = { name = 'weapon_whbgbat', label = 'White B Gang Bat', weapontype = 'Melee', ammotype = nil, damagereason = 'Melee Killed / Battered' },
    ['weapon_pubbgbat'] = { name = 'weapon_pubbgbat', label = 'Purple B Gang Bat', weapontype = 'Melee', ammotype = nil, damagereason = 'Melee Killed / Battered' },

    -- Hatchets
    ['weapon_lgbtqghatchet'] = { name = 'weapon_lgbtqghatchet', label = 'LGBTQ Gang Hatchet', weapontype = 'Melee', ammotype = nil, damagereason = 'Melee Killed / Chopped' },
    ['weapon_rghatchet'] = { name = 'weapon_rghatchet', label = 'Red Hatchet', weapontype = 'Melee', ammotype = nil, damagereason = 'Melee Killed / Chopped' },
    ['weapon_bghatchet'] = { name = 'weapon_bghatchet', label = 'Blue Hatchet', weapontype = 'Melee', ammotype = nil, damagereason = 'Melee Killed / Chopped' },
    ['weapon_yghatchet'] = { name = 'weapon_yghatchet', label = 'Yellow Hatchet', weapontype = 'Melee', ammotype = nil, damagereason = 'Melee Killed / Chopped' },
    ['weapon_pughatchet'] = { name = 'weapon_pughatchet', label = 'Purple Hatchet', weapontype = 'Melee', ammotype = nil, damagereason = 'Melee Killed / Chopped' },
    ['weapon_pghatchet'] = { name = 'weapon_pghatchet', label = 'Pink Hatchet', weapontype = 'Melee', ammotype = nil, damagereason = 'Melee Killed / Chopped' },
    ['weapon_oghatchet'] = { name = 'weapon_oghatchet', label = 'Orange Hatchet', weapontype = 'Melee', ammotype = nil, damagereason = 'Melee Killed / Chopped' },
    ['weapon_olghatchet'] = { name = 'weapon_olghatchet', label = 'Olive Hatchet', weapontype = 'Melee', ammotype = nil, damagereason = 'Melee Killed / Chopped' },
    ['weapon_lbghatchet'] = { name = 'weapon_lbghatchet', label = 'Light Blue Hatchet', weapontype = 'Melee', ammotype = nil, damagereason = 'Melee Killed / Chopped' },
    ['weapon_greyghatchet'] = { name = 'weapon_greyghatchet', label = 'Grey Hatchet', weapontype = 'Melee', ammotype = nil, damagereason = 'Melee Killed / Chopped' },
    ['weapon_gghatchet'] = { name = 'weapon_gghatchet', label = 'Green Hatchet', weapontype = 'Melee', ammotype = nil, damagereason = 'Melee Killed / Chopped' },
    ['weapon_blghatchet'] = { name = 'weapon_blghatchet', label = 'Black Hatchet', weapontype = 'Melee', ammotype = nil, damagereason = 'Melee Killed / Chopped' },
    ['weapon_brghatchet'] = { name = 'weapon_brghatchet', label = 'Brown Hatchet', weapontype = 'Melee', ammotype = nil, damagereason = 'Melee Killed / Chopped' },
    ['weapon_wghatchet'] = { name = 'weapon_wghatchet', label = 'White Hatchet', weapontype = 'Melee', ammotype = nil, damagereason = 'Melee Killed / Chopped' },


    -- Butterfly Knives
    ['weapon_lgbtqgbfknife'] = { name = 'weapon_lgbtqgbfknife', label = 'LGBTQ Butterfly Knife', weapontype = 'Melee', ammotype = nil, damagereason = 'Melee Killed / Knifed' },
    ['weapon_rgbknife'] = { name = 'weapon_rgbknife', label = 'Red Butterfly Knife', weapontype = 'Melee', ammotype = nil, damagereason = 'Melee Killed / Knifed' },
    ['weapon_blgbknife'] = { name = 'weapon_blgbknife', label = 'Black Butterfly Knife', weapontype = 'Melee', ammotype = nil, damagereason = 'Melee Killed / Knifed' },
    ['weapon_bgbknife'] = { name = 'weapon_bgbknife', label = 'Blue Butterfly Knife', weapontype = 'Melee', ammotype = nil, damagereason = 'Melee Killed / Knifed' },
    ['weapon_brgbknife'] = { name = 'weapon_brgbknife', label = 'Brown Butterfly Knife', weapontype = 'Melee', ammotype = nil, damagereason = 'Melee Killed / Knifed' },
    ['weapon_ggbknife'] = { name = 'weapon_ggbknife', label = 'Green Butterfly Knife', weapontype = 'Melee', ammotype = nil, damagereason = 'Melee Killed / Knifed' },
    ['weapon_greygbknife'] = { name = 'weapon_greygbknife', label = 'Grey Butterfly Knife', weapontype = 'Melee', ammotype = nil, damagereason = 'Melee Killed / Knifed' },
    ['weapon_lbgbknife'] = { name = 'weapon_lbgbknife', label = 'Light Blue Butterfly Knife', weapontype = 'Melee', ammotype = nil, damagereason = 'Melee Killed / Knifed' },
    ['weapon_ogbknife'] = { name = 'weapon_ogbknife', label = 'Orange Butterfly Knife', weapontype = 'Melee', ammotype = nil, damagereason = 'Melee Killed / Knifed' },
    ['weapon_pgbknife'] = { name = 'weapon_pgbknife', label = 'Pink Butterfly Knife', weapontype = 'Melee', ammotype = nil, damagereason = 'Melee Killed / Knifed' },
    ['weapon_pugbknife'] = { name = 'weapon_pugbknife', label = 'Purple Butterfly Knife', weapontype = 'Melee', ammotype = nil, damagereason = 'Melee Killed / Knifed' },
    ['weapon_wgbknife'] = { name = 'weapon_wgbknife', label = 'White Butterfly Knife', weapontype = 'Melee', ammotype = nil, damagereason = 'Melee Killed / Knifed' },
    ['weapon_ygbknife'] = { name = 'weapon_ygbknife', label = 'Yellow Butterfly Knife', weapontype = 'Melee', ammotype = nil, damagereason = 'Melee Killed / Knifed' },
    ['weapon_olgbknife'] = { name = 'weapon_olgbknife', label = 'Olive Butterfly Knife', weapontype = 'Melee', ammotype = nil, damagereason = 'Melee Killed / Knifed' },


    -- Sledgehammers
    ['weapon_lgbtqgshammer'] = { name = 'weapon_lgbtqgshammer', label = 'LGBTQ Gang Sledgehammer', weapontype = 'Melee', ammotype = nil, damagereason = 'Melee Killed / Smashed' },
    ['weapon_redshammer'] = { name = 'weapon_redshammer', label = 'Red Gang Sledgehammer', weapontype = 'Melee', ammotype = nil, damagereason = 'Melee Killed / Smashed' },
    ['weapon_blshammer'] = { name = 'weapon_blshammer', label = 'Black Gang Sledgehammer', weapontype = 'Melee', ammotype = nil, damagereason = 'Melee Killed / Smashed' },
    ['weapon_bshammer'] = { name = 'weapon_bshammer', label = 'Blue Gang Sledgehammer', weapontype = 'Melee', ammotype = nil, damagereason = 'Melee Killed / Smashed' },
    ['weapon_brshammer'] = { name = 'weapon_brshammer', label = 'Brown Gang Sledgehammer', weapontype = 'Melee', ammotype = nil, damagereason = 'Melee Killed / Smashed' },
    ['weapon_gshammer'] = { name = 'weapon_gshammer', label = 'Green Gang Sledgehammer', weapontype = 'Melee', ammotype = nil, damagereason = 'Melee Killed / Smashed' },
    ['weapon_greyshammer'] = { name = 'weapon_greyshammer', label = 'Grey Gang Sledgehammer', weapontype = 'Melee', ammotype = nil, damagereason = 'Melee Killed / Smashed' },
    ['weapon_lbshammer'] = { name = 'weapon_lbshammer', label = 'Light Blue Gang Sledgehammer', weapontype = 'Melee', ammotype = nil, damagereason = 'Melee Killed / Smashed' },
    ['weapon_ogshammer'] = { name = 'weapon_ogshammer', label = 'Orange Gang Sledgehammer', weapontype = 'Melee', ammotype = nil, damagereason = 'Melee Killed / Smashed' },
    ['weapon_olgshammer'] = { name = 'weapon_olgshammer', label = 'Olive Gang Sledgehammer', weapontype = 'Melee', ammotype = nil, damagereason = 'Melee Killed / Smashed' },
    ['weapon_pgshammer'] = { name = 'weapon_pgshammer', label = 'Pink Gang Sledgehammer', weapontype = 'Melee', ammotype = nil, damagereason = 'Melee Killed / Smashed' },
    ['weapon_pugshammer'] = { name = 'weapon_pugshammer', label = 'Purple Gang Sledgehammer', weapontype = 'Melee', ammotype = nil, damagereason = 'Melee Killed / Smashed' },
    ['weapon_wgshammer'] = { name = 'weapon_wgshammer', label = 'White Gang Sledgehammer', weapontype = 'Melee', ammotype = nil, damagereason = 'Melee Killed / Smashed' },
    ['weapon_ygshammer'] = { name = 'weapon_ygshammer', label = 'Yellow Gang Sledgehammer', weapontype = 'Melee', ammotype = nil, damagereason = 'Melee Killed / Smashed' },

5- add the following to core_inventory\client\main.lua
    --line 2113 roughly after (or weaponName =="weapon_bzgas")

            or weaponName == "weapon_lgbtqmolotov"
            or weaponName == "weapon_rgmolotov"
            or weaponName == "weapon_olmolotov"
            or weaponName == "weapon_omolotov"
            or weaponName == "weapon_pmolotov"
            or weaponName == "weapon_wmolotov"
            or weaponName == "weapon_ymolotov"
            or weaponName == "weapon_pumolotov"
            or weaponName == "weapon_gmolotov"
            or weaponName == "weapon_greymolotov"
            or weaponName == "weapon_lbmolotov"
            or weaponName == "weapon_blmolotov"
            or weaponName == "weapon_bmolotov"
            or weaponName == "weapon_brmolotov"

6- add the following to core_inventory\client\main.lua
    --line 2166 roughly after (or currentWeapon == "weapon_pipebomb")

            or currentWeapon == "weapon_lgbtqmolotov"
            or currentWeapon == "weapon_rgmolotov"
            or currentWeapon == "weapon_olmolotov"
            or currentWeapon == "weapon_omolotov"
            or currentWeapon == "weapon_pmolotov"
            or currentWeapon == "weapon_wmolotov"
            or currentWeapon == "weapon_ymolotov"
            or currentWeapon == "weapon_pumolotov"
            or currentWeapon == "weapon_gmolotov"
            or currentWeapon == "weapon_greymolotov"
            or currentWeapon == "weapon_lbmolotov"
            or currentWeapon == "weapon_blmolotov"
            or currentWeapon == "weapon_bmolotov"
            or currentWeapon == "weapon_brmolotov"


(note: to work with streetcraft script)
--install ox lib - https://github.com/overextended/ox_lib
--install zyke lib - https://github.com/Zyke-Resources/zyke_lib
--MAKE SURE YOU DOWNLOAD THE BUILD VERSIONS ON THE RIGHT SIDE!!!!

--ensure ox_lib, zyke_lib, then the gang pack then streetcraft

--MUST BE STARTED IN THAT ORDER!!!!!

