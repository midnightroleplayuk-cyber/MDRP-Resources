-- QBCore only. Choose one representation; balances are never combined.
Config.QBBlackMoney = {
    mode = "account", -- account: PlayerData.money.black; item: one item per dollar; markedbills: unique bags with worth metadata.
    item = "black_money", -- item mode; use "markedbills" for markedbills mode.
    worthKey = "worth", -- markedbills mode only.
}
