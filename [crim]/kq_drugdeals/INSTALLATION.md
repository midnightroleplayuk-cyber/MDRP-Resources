## INSTALLATION GUIDE

### Dependencies:
Install our KQ_LINK resource if you don't have it installed already
- If you do have it installed, make sure its up-to-date (^1.30.0)

Follow the detailed guide here: https://docs.kuzquality.com/kq-link/kq-link-or-installation-guide

Github: https://github.com/Kuzkay/kq_link

⚠ Make sure that `kq_link` is started **before** this resource and named exactly `kq_link` !
___

### Step 1:
Put the folder into your resources folder

### Step 2:
Add the items to your inventory/framework of choice

If you want to use items which already exist on your server, feel free to do so by changing the item names in the config files

You can find the item templates and icons within the `_installation` folder

- `kq_plugphone` - the Plug smartphone (usable)
- `kq_trapphone` - the burner phone (usable)
- `kq_stingphone` - the police sting terminal (usable)
- `kq_drugpackage` - handed over during package favours (no use action)

On ox_inventory keep the `server.export` hooks exactly as in the template

### Step 3:
Ensure the script in your `server.cfg` file
```
ensure kq_link
ensure kq_drugdeals
```

### Step 4:
Grant yourself access to the admin panel (ACE permission) in your `server.cfg` file.
```
add_ace group.admin command.drugdeals:admin allow
```

The database tables create themselves on first start

### Step 5:
Run `/drugdeals:admin` in game and create your drugs in the **Drugs** tab.
Optionally add hotspots, organizations, corners, delivery spots and vehicle spots

### Done
Enjoy the script

___

- https://docs.kuzquality.com/
- https://kuzquality.com/
- https://discord.gg/fZsyam7Rvz
