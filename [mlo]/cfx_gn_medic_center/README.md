# cfx_gn_medic_center

For any support request, please refer to `Support Forum` of our **Discord**.

https://discord.gg/gnstudio



1. This resource requires :

    cfx_gn_collection
    cfx_gn_medical_assets
    cfx_gn_ambulance_garage

2. How to uninstall LSMC medical center?

    -> Delete **cfx_gn_medic_center\stream\lsmc** file

3. How to uninstall Pillbox medical center?

    -> Delete **cfx_gn_medic_center\stream\pillbox** file
    -> Disable the main.lua script in the fxmanifest.lua file :

        --client_script {
        --"main.lua"
        --}

# Props Movement
You can realize your script to animate the table of the IRM or the arms of the xray.
Here is the necessary information
---------------------------------------------------------
-> Name and hash for MRI table movement:
Name : gn_med_irm_3_prop - 0x14182433 - 337126451

So you just have to move the object from A to B coordinates
For example here are the coordinates :

Pillbox Medical Center : 
- Coord A : X:338,2207 Y:-589,0605 Z:43,37001
- to Coord B : X:336,5335 Y:-588,4464 Z:43,37001

Central Los Santos Medical Center
- Coord A: X:378.7411 Y:-1416.182 Z:32.60954
- to Coord B: X:377,5937 Y:-1415,219 Z:32,60954
---------------------------------------------------------
-> Name and hash for xray arm movement:
- gn_med_xray_1_prop - 0x73386CB7 - 1933077687
- gn_med_xray_2_prop - 0x34789039 - 880316473

Pillbox Medical Center : 
- Coord A : X:340,3254 Y:-581,8901 Z:43,18989
- to Coord B : X:341,4034 Y:-582,2825 Z:43,18989

Central Los Santos Medical Center
- Coord A: X:383,4349 Y:-1410,385 Z:32,42942
- to Coord B: X:384,3041 Y:-1411,114 Z:32,42942

The coordinates are the same for "gn_med_xray_1_prop"&"gn_med_xray_2_prop"
You can however change the "Z" position of "gn_med_xray_1_prop" slightly so that the head of the arm goes up and down slightly
---------------------------------------------------------




Both hospitals are based on the same MLO. If a modification is made on one, the second will be automatically modified.

It is also possible to make this interior in teleportation under the map. It will be necessary to make a simple modification of the entrance door. For this you can make a request on our Discord 
-> https://discord.gg/gnstudio

Please do not rename or modify any resource!