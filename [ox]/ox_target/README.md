
# add to ox cfg

##################
### OX TARGET ###
##################

# 1 = grab NUI focus when target options appear (default)
# 0 = left-click while targeting to focus first
setr ox_target:autoFocus 0

# Toggle targeting when pressing the hotkey, instead of holding it down.
setr ox_target:toggleHotkey 0

# Change the key to enable targeting (https://docs.fivem.net/docs/game-references/input-mapper-parameter-ids/keyboard)
setr ox_target:defaultHotkey LMENU

# Draw a sprite (circle) at the centroid of a zone.
setr ox_target:drawSprite 1

# Enable built-in targeting options, e.g. toggling vehicle doors.
setr ox_target:defaults 1

# Enable debugging / testing options, entity outlines, and a raycast indicator.
setr ox_target:debug 0

# Enable / Disable leftclick to select options
setr ox_target:leftClick 1

# ox_target



![](https://img.shields.io/github/downloads/overextended/ox_target/total?logo=github)
![](https://img.shields.io/github/downloads/overextended/ox_target/latest/total?logo=github)
![](https://img.shields.io/github/contributors/overextended/ox_target?logo=github)
![](https://img.shields.io/github/v/release/overextended/ox_target?logo=github) 


A performant and flexible standalone "third-eye" targeting resource, with additional functionality for supported frameworks.

ox_target is the successor to qtarget, which was a mostly-compatible fork of bt-target.
To improve many design flaws, ox_target has been written from scratch and drops support for bt-target/qtarget standards, though partial compatibility is being implemented where possible.


## 📚 Documentation

https://overextended.dev/ox_target

## 💾 Download

https://github.com/overextended/ox_target/releases/latest/download/ox_target.zip

## ✨ Features

- Improved entity and world collision than its predecessor.
- Improved error handling when running external code.
- Menus for nested target options.
- Partial compatibility for qtarget (the thing qb-target is based on, I made the original idiots).
- Registering options no longer overrides existing options.
- Groups and items checking for supported frameworks.
