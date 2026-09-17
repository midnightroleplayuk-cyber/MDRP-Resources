██████╗  ██████╗ ██╗      █████╗ ██████╗     ███╗   ███╗███████╗██╗     ███████╗███████╗    ██████╗  █████╗  ██████╗██╗  ██╗
██╔══██╗██╔═══██╗██║     ██╔══██╗██╔══██╗    ████╗ ████║██╔════╝██║     ██╔════╝██╔════╝    ██╔══██╗██╔══██╗██╔════╝██║ ██╔╝
██████╔╝██║   ██║██║     ███████║██████╔╝    ██╔████╔██║█████╗  ██║     █████╗  █████╗      ██████╔╝███████║██║     █████╔╝ 
██╔═══╝ ██║   ██║██║     ██╔══██║██╔══██╗    ██║╚██╔╝██║██╔══╝  ██║     ██╔══╝  ██╔══╝      ██╔═══╝ ██╔══██║██║     ██╔═██╗ 
██║     ╚██████╔╝███████╗██║  ██║██║  ██║    ██║ ╚═╝ ██║███████╗███████╗███████╗███████╗    ██║     ██║  ██║╚██████╗██║  ██╗
╚═╝      ╚═════╝ ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝    ╚═╝     ╚═╝╚══════╝╚══════╝╚══════╝╚══════╝    ╚═╝     ╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝


-- STEP 1: Put Polartheplug_meleeweaponpack folder into your resources then ensure it in your server.cfg
-- STEP 2: ADD IMAGES THAT ARE IN THE INSTALL FOLDER TO OX_INVENTORY    [ox_inventory/web/images]                                     
-- STEP 3: ADD FIRST Copy paste list to   								[ox_inventory/data/weapons.lua]                      
-- STEP 4: ADD SECOND copy paste list to    							[ox_inventory/data/weapons.lua]            

AND THEN YOUR DONE :) 

███████╗██╗██████╗ ███████╗████████╗     ██████╗ ██████╗ ██████╗ ██╗   ██╗    ██████╗  █████╗ ███████╗████████╗███████╗
██╔════╝██║██╔══██╗██╔════╝╚══██╔══╝    ██╔════╝██╔═══██╗██╔══██╗╚██╗ ██╔╝    ██╔══██╗██╔══██╗██╔════╝╚══██╔══╝██╔════╝
█████╗  ██║██████╔╝███████╗   ██║       ██║     ██║   ██║██████╔╝ ╚████╔╝     ██████╔╝███████║███████╗   ██║   █████╗  
██╔══╝  ██║██╔══██╗╚════██║   ██║       ██║     ██║   ██║██╔═══╝   ╚██╔╝      ██╔═══╝ ██╔══██║╚════██║   ██║   ██╔══╝  
██║     ██║██║  ██║███████║   ██║       ╚██████╗╚██████╔╝██║        ██║       ██║     ██║  ██║███████║   ██║   ███████╗
╚═╝     ╚═╝╚═╝  ╚═╝╚══════╝   ╚═╝        ╚═════╝ ╚═════╝ ╚═╝        ╚═╝       ╚═╝     ╚═╝  ╚═╝╚══════╝   ╚═╝   ╚══════╝

-- PUT THIS IN OX_INVENTORY > DATA > WEAPONS.LUA AND PUT IT IN THE SECTION WHERE ALL THE WEAPONS ARE AT 

	['WEAPON_BUTCHER'] = {           
			label = 'Butcher Knife',
			weight = 500,
		},
		['WEAPON_SCIMITAR'] = {           
			label = 'Scimitar',
			weight = 500,
		},
		['WEAPON_BATON'] = {            
			label = 'Baton',
			weight = 500,
		},
		['WEAPON_SLEDGEHAMMER'] = {           
			label = 'Sledge Hammer',
			weight = 500,
		},
		['WEAPON_SCIFISWORD'] = {           
			label = 'SCIFI Sword',
			weight = 500,
		},
		['WEAPON_SCYTHE'] = {           
			label = 'Scythe',
			weight = 500,
		},
		['WEAPON_TWOHBATTLEAXE'] = {           
			label = '2H Battleaxe',
			weight = 500,
		},
		['WEAPON_PEPPERSPRAY'] = {           
			label = '200ML Pepper Spray',
			weight = 200,
			ammoname = 'ammo-pepperspray'
		},
		['WEAPON_ACIDSPRAY'] = {           
			label = '200ML Acid Spray',
			weight = 200,
			ammoname = 'ammo-acidspray'
		},
		['WEAPON_BARBEDBAT'] = {         
			label = 'Barbed Wire Bat',
			weight = 750,
		},
		['WEAPON_KITCHENKNIFE'] = {         
			label = 'Kitchen Knife',
			weight = 200,
		},
		['WEAPON_TACCLEAVER'] = {       
			label = 'Tactical Cleaver', 
			weight = 350,
		},
		['WEAPON_EGUITAR'] = {        
			label = 'Electric Guitar',
			weight = 800,
		},
		['WEAPON_GUITAR'] = {         
			label = 'Guitar',
			weight = 750,
		},
		['WEAPON_PITCHFORK'] = {         
			label = 'Pitchfork',
			weight = 600,
		},
		['WEAPON_TACAXE'] = {        
			label = 'Tactical Axe',
			weight = 650,
		},
		['WEAPON_WCLAWS'] = {       
			label = 'Wolverine Claws',
			weight = 250,
		},
		['WEAPON_SCISSORS'] = {       
			label = 'Scissors',
			weight = 100,
		},
		['WEAPON_PICKAXE'] = {       
			label = 'Pickaxe',
			weight = 650,
		},
		['WEAPON_SCREWDRIVER'] = {       
			label = 'Screwdriver',
			weight = 149,
		},
		['WEAPON_DILDO'] = {        
			label = 'Dildo',
			weight = 100,
		},
		['WEAPON_HUNTERKNIFE'] = {        
			label = 'Hunter Knife',
			weight = 149,
		},
		['WEAPON_ICECLIMBER'] = {    
			label = 'Ice Climber',
			weight = 350,
		}, 
		['WEAPON_MACE'] = {   
			label = 'MACE',
			weight = 750,
		}, 
		['WEAPON_SHOVEL'] = {   
			label = 'Shovel',
			weight = 550,
		}, 
		['WEAPON_SPIKEDKNUCKLES'] = {
			label = 'Spiked Knuckles',
			weight = 250,
		}, 
		['WEAPON_CRUTCH'] = {   
			label = 'Crutch',
			weight = 350,
		},
		['WEAPON_BROWNMACHETE'] = {  
			label = 'BH Machete',
			weight = 200,
		},
		['WEAPON_BLACKKATANA'] = { 
			label = 'Black Katana',
			weight = 550,
		},
		['WEAPON_KUKRI'] = {
			label = 'Kukri',
			weight = 350,
		},
		
		['WEAPON_STOPSIGN'] = {
			label = 'Stop Sign',
			weight = 600,
		},
		['WEAPON_THORSHAMMER'] = {
			label = 'Thors Hammer',
			weight = 1000,
		},
		['WEAPON_AXE'] = {
			label = 'Axe',
			weight = 800,
		},
		['WEAPON_CHAIR'] = {
			label = 'Chair',
			weight = 450,
		},
		['WEAPON_ZK'] = {
			label = 'Zombie Knife',
			weight = 400,
		},
		['WEAPON_REDZK'] = {
			label = 'Red Zombie Knife',
			weight = 400,
		},
		['WEAPON_BLUEZK'] = {
			label = 'Blue Zombie Knife',
			weight = 400,
		},
		['WEAPON_PINKZK'] = {
			label = 'Pink Zombie Knife',
			weight = 400,
		},
		['WEAPON_SPIKEYBAT'] = {
			label = 'Spikey Bat',
			weight = 800,
		},
		['WEAPON_KATANA'] = {
			label = 'Katana Sword',
			weight = 800,
		},
		['WEAPON_LONGMACHETE'] = {
			label = 'Long Machete',
			weight = 500,
		},
		['WEAPON_TACTICALHATCHET'] = {
			label = 'Tactical Hatchet',
			weight = 450,
		},
		['WEAPON_FIREWORKSINGLE'] = {
			label = 'Firework Spray',
			weight = 1000,
			durability = 0.5,
			ammoname = 'ammo-firework'
		},
		['WEAPON_SPRAYPAINT'] = {           
			label = '200ML Spray Paint',
			weight = 200,
			ammoname = 'ammo-spraypaint'
		},
		
		-------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
███████╗███████╗ ██████╗ ██████╗ ███╗   ██╗██████╗      ██████╗ ██████╗ ██████╗ ██╗   ██╗    ██████╗  █████╗ ███████╗████████╗███████╗
██╔════╝██╔════╝██╔════╝██╔═══██╗████╗  ██║██╔══██╗    ██╔════╝██╔═══██╗██╔══██╗╚██╗ ██╔╝    ██╔══██╗██╔══██╗██╔════╝╚══██╔══╝██╔════╝
███████╗█████╗  ██║     ██║   ██║██╔██╗ ██║██║  ██║    ██║     ██║   ██║██████╔╝ ╚████╔╝     ██████╔╝███████║███████╗   ██║   █████╗  
╚════██║██╔══╝  ██║     ██║   ██║██║╚██╗██║██║  ██║    ██║     ██║   ██║██╔═══╝   ╚██╔╝      ██╔═══╝ ██╔══██║╚════██║   ██║   ██╔══╝  
███████║███████╗╚██████╗╚██████╔╝██║ ╚████║██████╔╝    ╚██████╗╚██████╔╝██║        ██║       ██║     ██║  ██║███████║   ██║   ███████╗
╚══════╝╚══════╝ ╚═════╝ ╚═════╝ ╚═╝  ╚═══╝╚═════╝      ╚═════╝ ╚═════╝ ╚═╝        ╚═╝       ╚═╝     ╚═╝  ╚═╝╚══════╝   ╚═╝   ╚══════╝




	PUT THIS IN OX_INVENTORY > DATA > WEAPONS.LUA AND PUT IT IN THE AMMO SECTION

	['ammo-acidspray'] = {
			label = '1Ml acid ammo',
			weight = 1,
		},
	['ammo-pepperspray'] = {
			label = '1Ml pepper ammo',
			weight = 1,
		},
	['ammo-spraypaint'] = {
			label = '1Ml Spray Paint',
			weight = 1,
		},	