Config.Shop = {
    enabled = true,

    -- Items members can buy from the tablet's Shop tab. They go straight into the buyer's inventory.
    --   item        inventory item name (must exist in your inventory)
    --   price       per item
    --   pay         'cash' or 'bank' (the buyer's own money), or 'clean' / 'dirty' (the gang treasury,
    --               needs the treasury withdrawal permission and shows in the gang's history)
    --   max         most that can be bought at once
    --   image       file in web/images, or a full nui:// or https:// link
    --   tier        optional: gang tier needed (see config/progression.lua)
    --   permission  optional: rank permission needed (see config/ranks.lua)
    --   needs       optional: only listed when that part of the script is in use
    --               ('graffiti', 'informants' or 'tabletItem')
    items = {
        { item = 'spraycan', label = 'Spray can', price = 50, pay = 'cash', max = 10, image = 'spraycan.png',
          description = 'One can sprays a tag or crosses out a rival\'s.', needs = 'graffiti' },

        -- Paid from the buyer's own cash on purpose: a treasury purchase would show up in the gang's history.
        { item = 'burner_phone', label = 'Burner phone', price = 500, pay = 'cash', max = 1, image = 'burner_phone.png',
          description = 'A cheap phone nobody can trace back to you.', needs = 'informants' },

        { item = 'gang_tablet', label = 'Gang tablet', price = 1000, pay = 'cash', max = 1, image = 'gang_tablet.png',
          description = 'A spare tablet for a new member.', needs = 'tabletItem' },

        -- Examples of your own items:
        -- { item = 'lockpick', label = 'Lockpick', price = 250, pay = 'cash', max = 5, image = 'nui://ox_inventory/web/images/lockpick.png', tier = 2 },
        -- { item = 'armour', label = 'Body armour', price = 2500, pay = 'dirty', max = 2, image = 'nui://ox_inventory/web/images/armour.png', tier = 3, permission = 'treasury_withdraw' },
    },
}
