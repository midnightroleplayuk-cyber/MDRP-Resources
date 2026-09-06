## INSTALLATION GUIDE

### Dependencies:
Install our KQ_LINK resource if you don't have it installed already
- If you do have it installed, make sure its up-to-date (^1.28.0)

Follow the detailed guide here: https://docs.kuzquality.com/kq-link/kq-link-or-installation-guide

Github: https://github.com/Kuzkay/kq_link

⚠ Make sure that `kq_link` is started **before** this resource and named exactly `kq_link` !
___

### Step 1:
Put the folder into your resources folder

### Step 2:
Add the items to  your inventory/framework of choice.

If you want to use items which already exist on your server.
Feel free to do so by changing the item names in the config file

You can find the item templates and icons within the `_INSTALLATION` folder

### Step 3:
To allow our script to create dynamic doors, you must add

```
setr game_enableDynamicDoorCreation "true"
```

to your server.cfg

### Step 4:
Ensure the script in your `server.cfg` file.
```
ensure kq_link
ensure kq_weed
```

### Step 5: (optional)
Modify the default locations of the containers, pre-placed pots, tables, presses etc.
You can easily do so via our easy-to-read configuration files

### Done
Enjoy the script

### Tips:
- Disable all the blips via the config to keep the lockups hidden from your players.
  Make it a fun challenge to find them
- Base the weed price for each item off the growth time and difficulty of growth
- Make certain grow ops only available for certain jobs, such as gangs, cartel or mafia
- For job whitelisted locations, whitelist all your police jobs as well, to enable them to perform raids

___

- https://docs.kuzquality.com/
- https://kuzquality.com/
- https://discord.gg/fZsyam7Rvz
