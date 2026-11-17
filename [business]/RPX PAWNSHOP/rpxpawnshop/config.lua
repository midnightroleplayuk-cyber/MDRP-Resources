Config = {}

-- Pay type:
-- Qbox/QBCore: cash | bank 
-- ESX: bank
Config.PayType = "cash"

-- Discord webhook (leave empty to disable)
Config.Webhook = ""

Config.Blip = {
  Enabled = true,
  Sprite = 431,
  Color = 5,
  Scale = 0.85,
  Name = "Pawn Shop",
}

Config.Target = "auto" --ox or qb

Config.Pawnshops = {
  {
    id = "legion_pawn",
    coords = vector4(412.32, 315.18, 103.13, 210.0),
    model = "s_m_m_highsec_01",
    scenario = "WORLD_HUMAN_CLIPBOARD",
    label = "Pawn Shop",
    icon = "fa-solid fa-sack-dollar",
    distance = 2.0,
  },
}

Config.ImageBaseQB = "nui://qb-inventory/html/images/"
Config.ImageBaseQS = "nui://qs-inventory/html/images/"
Config.ImageBaseOX = "nui://ox_inventory/web/images/"

Config.SellItems = {
  goldchain = { price = 250, label = "Gold Necklace" },
  diamond   = { price = 500, label = "Diamond" },
  rolex     = { price = 1000, label = "Luxury Watch" },
  camera    = { price = 600, label = "Camera" },
  tablet    = { price = 350, label = "Tablet" },
}

Config.UITitle = "SELL ITEMS"
Config.UISubtitle = "Sell your items for cash."
