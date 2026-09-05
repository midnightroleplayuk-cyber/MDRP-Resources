Strings = {
   CommandDesc = {
      seatbelt         = "Toggle Seatbelt",
      engine           = "Toggle Engine",
      doorLock         = "Toggle Vehicle Lock",
      lights           = "Toggle Headlights",
      indicatorLeft    = "Toggle Left Blinker",
      indicatorRight   = "Toggle Right Blinker",
      hazard           = "Toggle Hazard Lights",
      togglePlayerInfo = "Toggle Player Info HUD"
   },
   Notifications = {
      SeatbeltDisabled = {
         title = "Seatbelt Unavailable",
         description = "You cannot use a seatbelt in this vehicle."
      },
      SeatbeltCooldown = {
         title = "Slow Down",
         description = "Wait %s seconds to use seatbelt..."
      }
   },
   Editor = {
      Title       = "EDITOR MODE",
      Description = "Customize the hud elements to your liking",
      Drag        = "Drag to Reposition",
      Menu        = "Right Click Menu",
      ESC         = "ESC to Go Back",
      GridTitle   = "GRID & ALIGNMENT",
      Grid        = "Grid",
      Snap        = "Snap",
      Center      = "Center",
      Spacing     = "Spacing",
      Minimize    = "Minimize",
      Expand      = "Expand",
      Exit        = "Exit",
      ContextMenu = {
         Subtitle       = "Right Click Options",
         Title          = "Editor Settings",
         Resize         = "Resize Element",
         Horizontal3D   = "3D Horizontal",
         Vertical3D     = "3D Vertical",
         Rotate         = "Rotate Element",
         ResetPosition  = "Reset Position"
      }
   },
   Settings = {
      Title       = "Hud Settings",
      Description = "Customize the hud settings to your liking",
      Category    = {
         general     = "General",
         speedometer = "Speedometer",
         status      = "Status Icons & Player Info"
      },
      ResetModal  = {
         title       = "Reset Everything",
         description = "Are you sure you want to reset the entire hud all of your saved settings will be reverted back to default settings !",
         cancel      = "Cancel",
         confirm     = "Confirm"
      },
      General     = {
         Editor = {
            title       = "Open Editor Mode",
            description = "Customize the hud elements size & positions to your liking",
            reset       = "Reset",
            edit        = "Edit"
         },
         Performance = {
            title       = "Performance Mode",
            description = "Customize the hud fps to match your performance"
         },
         Map = {
            title       = "Map Visibility",
            description = "Customize the visibility of the map",
            ALWAYS      = "Always",
            CAR         = "Only In Car",
            NEVER       = "Never",
            always      = "Always",
            car         = "Only In Car",
            never       = "Never"
         },
         MapType = {
            title       = "Map Type",
            description = "Choose between the rectangle and circle minimap",
            SQUARE      = "Rectangle",
            CIRCLE      = "Circle"
         },
         Compass = {
            title       = "Compass Visibility",
            description = "Choose when the compass should be visible",
            CAR         = "Only In Car",
            FOOT        = "Only On Foot",
            ALWAYS      = "Always",
            NEVER       = "Never"
         },
         Waypoint = {
            title       = "Waypoint Settings",
            description = "Choose when the waypoint should be visible",
            ALWAYS      = "Always",
            CAR         = "Only In Car",
            FOOT        = "Only On Foot",
            NEVER       = "Never",
            show        = "Always",
            hide        = "Never"
         },
         Cinematic = {
            title       = "Enable Cinematics",
            description = "Enable or Disable the cinematics bar"
         },
         Postal = {
            title       = "Nearest Postal",
            description = "Choose when the nearest postal code display should be visible.",
            ALWAYS      = "Always",
            CAR         = "Only In Car",
            FOOT        = "Only On Foot",
            NEVER       = "Never",
            show        = "Always",
            hide        = "Never"
         }
      },
      Speedometer = {
         Speedometers = {
            title       = "Select Speedometer Style",
            description = "Choose the speedometer to your liking",
            choose      = "Choose Speedometer",
            back        = "Go Back",
            select      = "Select",
            selected    = "Selected",
            stylePrefix = "Style",
            One         = { name = "Style 1" },
            Two         = { name = "Style 2" },
            Three       = { name = "Style 3" },
            Four        = { name = "Style 4" },
            Five        = { name = "Style 5" },
            Six         = { name = "Style 6" },
            Seven       = { name = "Style 7" },
            Eight       = { name = "Style 8" },
            Nine        = { name = "Style 9" },
            Ten         = { name = "Style 10" },
            Eleven      = { name = "Style 11" }
         },
         ColorEditor  = {
            title        = "Edit Colors — Style %s",
            description  = "Hover over a component to highlight it",
            editColor    = "Edit Color",
            reset        = "Reset",
            back         = "Go Back",
            pasteBlocked = "FiveM blocks paste.",
            components   = {
               progress    = "RPM / Progress",
               speedText   = "Speed Text",
               speed       = "Speed Bar",
               gearText    = "Gear Text",
               gearBg      = "Gear Background",
               fuel        = "Fuel Bar",
               fuelIcon    = "Fuel Icon",
               background  = "Background",
               redline     = "Redline",
               needle      = "Needle",
               accent      = "Accent Details",
               gradient    = "Gradient",
               text        = "Text"
            }
         },
         SpeedUnit = {
            title       = "Set Speed Unit",
            description = "Customize the speedometer unit"
         },
         HideSpeedometer = {
            title       = "Hide Speedometer",
            description = "Hide or Show the entire speedometer"
         },
         SeatbeltAlert = {
            title       = "Enable Seatbelt Alert",
            description = "Enable or Disable alert when seatbelt is not attached"
         },
         LowFuelAlert = {
            title       = "Enable Low Fuel Alert",
            description = "Enable or Disable alert when fuel level is low"
         }
      },
      Status      = {
         ShowPlayerInfo = {
            title       = "Show Player Info",
            description = "Hide or Show the player info"
         },
         StatusStyle = {
            title       = "Status Icons Style",
            description = "Choose the shape of status icons",
            choose      = "Choose",
            back        = "Go Back"
         },
         PlayerInfoStyle = {
            title       = "Player Info Style",
            description = "Choose different style for player info",
            style       = "Style "
         },
         EditPlayerInfo = {
            title       = "Edit Player Info",
            description = "Hide or show specific player info",
            reset       = "Reset",
            edit        = "Edit",
            locked      = "Locked",
            Medal       = {
               title             = "Edit Player Info",
               description       = "Hide or show specific player info",
               lockedDescription = "This section is managed by the server owner",
               serverLogo        = "Server Logo",
               playerID          = "Player ID",
               time              = "Time",
               date              = "Date",
               bank              = "Bank",
               cash              = "Cash",
               blackMoney        = "Black Money",
               job               = "Job",
               gang              = "Gang",
               ammo              = "Ammo"
            }
         },
         HideStatusIcon = {
            title       = "Hide Status Icons",
            description = "Hide or Show the status icons"
         },
         IconsVisibility = {
            title         = "Status Icons Visibility",
            description   = "Show icons when their value is below or equal to the set %.",
            reset         = "Reset",
            edit          = "Edit",
            collapse      = "Collapse",
            expand        = "Expand",
            Medal         = {
               title       = "Edit Status Icons Visibility",
               description = "Hide or show specific icons"
            },
            showWhenBelow = "Show when below or equal",
            showWhenAbove = "Show when above or equal",
            items         = {
               HEALTH  = "Health",
               ARMOR   = "Armor",
               FOOD    = "Hunger",
               WATER   = "Thirst",
               OXYGEN  = "Oxygen",
               STRESS  = "Stress",
               STAMINA = "Stamina"
            }
         },
         EditStatusIconsColors = {
            title       = "Edit Status Icons Colors",
            description = "Customize the status icons colors",
            reset       = "Reset"
         }
      }
   }
}
return Strings
