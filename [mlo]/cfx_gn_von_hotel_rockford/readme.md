# This hotel requires an IPL loader (ymap)
in order to load only 1 floor of rooms/corridors for your players.

It is not possible to load more than 1 floor simultaneously, as this would cause a crash (pull size 400).
 -> This crash is due to too many portals if you load 2 or more floors.
    Don't worry about your optimization/performance, these portals are designed to optimize your game and increase fps and stability.

# We therefore propose a script that loads floors according to the player's choice of floor teleportation in the elevator:
 - client.lua
 - config.lua
 - locales.lua
 -> Request and call : NativeUI (Can be removed if you use another script, remember to remove the dependencies in the fxmanifest in this case)

# Another necessary script: "remove_ipl.lua".
 This one unloads all floors by default, optimizing the entire area around the hotel.
 It also checks the position when the player connects, and loads the necessary floor if necessary, so that your player isn't in a vacuum.
 If this doesn't work, check your OneSynch settings.


 You can, of course, delete all our scripts and remake them to your preferences.


 # Other script loader by G&N's community :

    QBCore - qb_target-von_rockford-loader
     -> https://github.com/gn-studio-mods/qb_target-von_rockford-loader

    ox_ - ox_target-von_rockford_loader
     -> https://github.com/gn-studio-mods/ox_target-von_rockford_loader


 # Optional :
   Optional - [corridor_door_lock_static]
	-> Modification of parameter to make your hallway/room doors static.

	   To do this change the file "int_hotel_corridor.ytyp" in : "cfx_gn_von_hotel_rockford\stream\ytyp"