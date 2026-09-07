# Credits: Item images by https://github.com/McKleans-Scripts, https://github.com/Griefa/gfa-items, https://github.com/TankieTwitch/FREE-FiveM-Image-Library, https://github.com/TankieTwitch/FREE-RedM-Image-Library/

# CHECK OUT OUR ITEM GALLERY AT (https://items.overflow5m.com/)

# CUSTOM INVENTORY (Implement it in server/custom/inventory.lua) :: Feel free to share it in our https://discord.gg/overflow
# OX_INVENTORY (ox_inventory/data/items.lua) Drop images: (ox_inventory/web/images)
  ['place_poster'] = {
      label = 'Poster',
      server = {
        export = "of_whiteboard.place_image"  
      },
      weight = 100,
  },
  ['edit_poster'] = {
      label = 'Marker set',
      server = {
        export = "of_whiteboard.edit_image"  
      },
      weight = 100,
  },
  ['remove_poster'] = {
      label = 'Clean tools',
      server = {
        export = "of_whiteboard.remove_image"  
      },
      weight = 100,
  },

# QB_INVENTORY (qb-core/shared/items.lua) Drop images: (qb-inventory/html/images)

  place_poster = { 
      name = 'place_poster',
      label = 'place_poster',
      weight = 1,
      type = 'item',
      image = 'place_poster.png',
      unique = false,
      useable = true,
      shouldClose = true,
      combinable = nil,
      description = 'place_poster'
  },
  edit_poster = { 
      name = 'edit_poster',
      label = 'edit_poster',
      weight = 1,
      type = 'item',
      image = 'edit_poster.png',
      unique = false,
      useable = true,
      shouldClose = true,
      combinable = nil,
      description = 'edit_poster'
  },
  remove_poster = { 
      name = 'remove_poster',
      label = 'remove_poster',
      weight = 1,
      type = 'item',
      image = 'remove_poster.png',
      unique = false,
      useable = true,
      shouldClose = true,
      combinable = nil,
      description = 'remove_poster
  }

# NOTE: edit_poster is not consumed on use -- it reopens the nearest poster you own
