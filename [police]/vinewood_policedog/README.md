# vinewood_policedog

The Vinewood police dog, `vw_policedog`, used by vinewood_police (`Config.Dogs.Model`).

- Put it in your resources and `ensure vinewood_policedog` **before** `ensure vinewood_police`.
- Only restart it with a **full server restart**, and reconnect afterwards. Restarting it while players are connected reloads the dog's ped data and crashes their game the next time a dog spawns. Restarting `vinewood_police` on its own is safe.
- Without this resource, set `Config.Dogs.Model = 'a_c_shepherd'` in vinewood_police to use the game's own shepherd.
- `data/peds.meta` uses the game's own German shepherd settings, so it moves and behaves like a dog.
- To swap in a different dog model, export it from CodeWalker or OpenIV **as** `vw_policedog`. Renaming the files isn't enough, because the `.yft` stores the model's name inside it.
