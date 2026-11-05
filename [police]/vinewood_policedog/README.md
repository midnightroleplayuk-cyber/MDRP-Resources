# vinewood_policedog

The Vinewood police dog, `vw_policedog`, used by vinewood_police (`Config.Dogs.Model`).

- Put it in your resources and `ensure vinewood_policedog` **before** `ensure vinewood_police`.
- Only restart it with a **full server restart**, and reconnect afterwards. Restarting it while players are connected reloads the dog's ped data and crashes their game the next time a dog spawns. Restarting `vinewood_police` on its own is safe.
- Without this resource, set `Config.Dogs.Model = 'a_c_shepherd'` in vinewood_police to use the game's own shepherd.
- `data/peds.meta` uses the game's own German shepherd settings, so it moves and behaves like a dog.
- File names: the skeleton and variations are `vw_policedog.yft` and `vw_policedog.ymt`. Every body part and texture must be named with a caret, e.g. `vw_policedog^head_000_r.ydd` and `vw_policedog^head_diff_000_a_whi.ytd`. FiveM only attaches parts named `pedname^part` to that ped; without the caret the dog spawns invisible.
- To swap in a different dog model, export it from CodeWalker or OpenIV **as** `vw_policedog` (the `.yft` stores the model's name inside it), and name its parts as above.

## 1.0.2
- All textures resized: every file is well under FiveM's 16 MiB limit, and the whole dog is about 12 MB instead of 51 MB. Any head and coat texture can be used, including random.

## 1.0.3
- Fixed: invisible dog. Body parts and textures are now named `vw_policedog^...`, which FiveM needs to attach them to the ped.
