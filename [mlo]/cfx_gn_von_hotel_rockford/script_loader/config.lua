Config = {}
Config.Locale = 'en' -- You can check/edit languages in 'locales.lua'
Config.OpenMenuKey = 38 -- Default: 38 (E key)
Config.enableLobbyMap = true -- Set to true if you are running the Lobby map
Config.showMarker = true
Config.DrawDistance = 10.0

Config.Zones = {
    Lobby01 = { -- Lobby 1 / 4
        Marker  = { x = -1215.897 , y = -204.1510, z = 38.3251 },
        Spawn   = { x = -1215.897 , y = -204.1510, z = 39.3251 },
        Size    = { x = 2.0, y = 2.0, z = 1.0 },
        Color   = { r = 102, g = 204, b = 255 },
        Type    = 27,
        Heading = 62.8135,
        canGoTo = {"Etage11","Etage21","Etage31","Etage41","Etage51","Etage61","Etage71"}
    },

	Lobby02 = { -- Lobby 2 / 4
		Marker  = { x = -1209.965 , y = -193.0415, z = 38.3251  },
		Spawn   = { x = -1209.965 , y = -193.0415, z = 39.3251  },
		Size    = { x = 2.0, y = 2.0, z = 1.0 },
        Color   = { r = 102, g = 204, b = 255 },
		Type    = 27,
		Heading = 63.5532,
		canGoTo = {"Etage12","Etage22","Etage32","Etage42","Etage52","Etage61","Etage72"}
	},

	Lobby03 = { -- Lobby 3 / 4
		Marker  = { x = -1220.981 , y = -170.5399, z = 38.3251  },
		Spawn   = { x = -1220.981 , y = -170.5399, z = 39.3251  },
		Size    = { x = 2.0, y = 2.0, z = 1.0 },
        Color   = { r = 102, g = 204, b = 255 },
		Type    = 27,
		Heading = 144.4608,
		canGoTo = {"Etage13","Etage23","Etage33","Etage43","Etage53","Etage63","Etage73"}
	},

    Etage11 = { -- Etage1 1 / 4
        Marker  = {x=-1203.1069335938,y=-190.87379455566,z=46.79},
        Spawn   = {x=-1203.1069335938,y=-190.87379455566,z=47.79},
        Size    = { x = 2.0, y = 2.0, z = 1.0 },
        Color   = { r = 102, g = 204, b = 255 },
        Type    = 27,
        Heading = 169.59108,
        canGoTo = {"Lobby01","Etage21","Etage31","Etage41","Etage51","Etage61","Etage71"}
    },

    Etage12 = { -- Etage1 2 / 4
        Marker  = {x=-1204.8363037109, y=-188.37803649902, z=46.79},
        Spawn   = {x=-1204.8363037109, y=-188.37803649902, z=47.79},
        Size    = { x = 2.0, y = 2.0, z = 1.0 },
        Color   = { r = 102, g = 204, b = 255 },
        Type    = 27,
        Heading = 169.59108,
        canGoTo = {"Lobby02","Etage22","Etage32","Etage42","Etage52","Etage62","Etage72"}
    },

    Etage13 = { -- Etage1 3 / 4
        Marker  = {x=-1199.1802978516, y=-184.08113098145, z=46.79},
        Spawn   = {x=-1199.1802978516, y=-184.08113098145, z=47.79},
        Size    = { x = 2.0, y = 2.0, z = 1.0 },
        Color   = { r = 102, g = 204, b = 255 },
        Type    = 27,
        Heading = 169.59108,
        canGoTo = {"Lobby03","Etage23","Etage33","Etage43","Etage53","Etage63","Etage73"}
    },

    Etage14 = { -- Etage1 4 / 4
        Marker  = {x=-1197.4893798828, y=-186.58154296875, z=46.79},
        Spawn   = {x=-1197.4893798828, y=-186.58154296875, z=47.79},
        Size    = { x = 2.0, y = 2.0, z = 1.0 },
        Color   = { r = 102, g = 204, b = 255 },
        Type    = 27,
        Heading = 169.59108,
        canGoTo = {"Lobby04","Etage24","Etage34","Etage44","Etage54","Etage64","Etage74"}
    },

    Etage21 = { -- Etage1 1 / 4
        Marker  = {x=-1203.1069335938,y=-190.87379455566,z=50.79},
        Spawn   = {x=-1203.1069335938,y=-190.87379455566,z=51.79},
        Size    = { x = 2.0, y = 2.0, z = 1.0 },
        Color   = { r = 102, g = 204, b = 255 },
        Type    = 27,
        Heading = 169.59108,
        canGoTo = {"Lobby01","Etage11","Etage31","Etage41","Etage51","Etage61","Etage71"}
    },

    Etage22 = { -- Etage1 2 / 4
        Marker  = {x=-1204.8363037109, y=-188.37803649902, z=50.79},
        Spawn   = {x=-1204.8363037109, y=-188.37803649902, z=51.79},
        Size    = { x = 2.0, y = 2.0, z = 1.0 },
        Color   = { r = 102, g = 204, b = 255 },
        Type    = 27,
        Heading = 169.59108,
        canGoTo = {"Lobby02","Etage12","Etage32","Etage42","Etage52","Etage62","Etage72"}
    },

    Etage23 = { -- Etage1 3 / 4
        Marker  = {x=-1199.1802978516, y=-184.08113098145, z=50.79},
        Spawn   = {x=-1199.1802978516, y=-184.08113098145, z=51.79},
        Size    = { x = 2.0, y = 2.0, z = 1.0 },
        Color   = { r = 102, g = 204, b = 255 },
        Type    = 27,
        Heading = 169.59108,
        canGoTo = {"Lobby03","Etage13","Etage33","Etage43","Etage53","Etage63","Etage73"}
    },

    Etage24 = { -- Etage1 4 / 4
        Marker  = {x=-1197.4893798828, y=-186.58154296875, z=50.79},
        Spawn   = {x=-1197.4893798828, y=-186.58154296875, z=51.79},
        Size    = { x = 2.0, y = 2.0, z = 1.0 },
        Color   = { r = 102, g = 204, b = 255 },
        Type    = 27,
        Heading = 169.59108,
        canGoTo = {"Lobby04","Etage14","Etage34","Etage44","Etage54","Etage64","Etage74"}
    },

    Etage31 = { -- Etage1 1 / 4
        Marker  = {x=-1203.1069335938,y=-190.87379455566,z=54.79},
        Spawn   = {x=-1203.1069335938,y=-190.87379455566,z=55.79},
        Size    = { x = 2.0, y = 2.0, z = 1.0 },
        Color   = { r = 102, g = 204, b = 255 },
        Type    = 27,
        Heading = 169.59108,
        canGoTo = {"Lobby01","Etage11","Etage21","Etage41","Etage51","Etage61","Etage71"}
    },

    Etage32 = { -- Etage1 2 / 4
        Marker  = {x=-1204.8363037109, y=-188.37803649902, z=54.79},
        Spawn   = {x=-1204.8363037109, y=-188.37803649902, z=55.79},
        Size    = { x = 2.0, y = 2.0, z = 1.0 },
        Color   = { r = 102, g = 204, b = 255 },
        Type    = 27,
        Heading = 169.59108,
        canGoTo = {"Lobby02","Etage12","Etage22","Etage42","Etage52","Etage62","Etage72"}
    },

    Etage33 = { -- Etage1 3 / 4
        Marker  = {x=-1199.1802978516, y=-184.08113098145, z=54.79},
        Spawn   = {x=-1199.1802978516, y=-184.08113098145, z=55.79},
        Size    = { x = 2.0, y = 2.0, z = 1.0 },
        Color   = { r = 102, g = 204, b = 255 },
        Type    = 27,
        Heading = 169.59108,
        canGoTo = {"Lobby03","Etage13","Etage23","Etage43","Etage53","Etage63","Etage73"}
    },

    Etage34 = { -- Etage1 4 / 4
        Marker  = {x=-1197.4893798828, y=-186.58154296875, z=54.79},
        Spawn   = {x=-1197.4893798828, y=-186.58154296875, z=55.79},
        Size    = { x = 2.0, y = 2.0, z = 1.0 },
        Color   = { r = 102, g = 204, b = 255 },
        Type    = 27,
        Heading = 169.59108,
        canGoTo = {"Lobby04","Etage14","Etage24","Etage44","Etage54","Etage64","Etage74"}
    },

    Etage41 = { -- Etage1 1 / 4
        Marker  = {x=-1203.1069335938,y=-190.87379455566,z=58.79},
        Spawn   = {x=-1203.1069335938,y=-190.87379455566,z=59.79},
        Size    = { x = 2.0, y = 2.0, z = 1.0 },
        Color   = { r = 102, g = 204, b = 255 },
        Type    = 27,
        Heading = 169.59108,
        canGoTo = {"Lobby01","Etage11","Etage21","Etage31","Etage51","Etage61","Etage71"}
    },

    Etage42 = { -- Etage1 2 / 4
        Marker  = {x=-1204.8363037109, y=-188.37803649902, z=58.79},
        Spawn   = {x=-1204.8363037109, y=-188.37803649902, z=59.79},
        Size    = { x = 2.0, y = 2.0, z = 1.0 },
        Color   = { r = 102, g = 204, b = 255 },
        Type    = 27,
        Heading = 169.59108,
        canGoTo = {"Lobby02","Etage12","Etage22","Etage32","Etage52","Etage62","Etage72"}
    },

    Etage43 = { -- Etage1 3 / 4
        Marker  = {x=-1199.1802978516, y=-184.08113098145, z=58.79},
        Spawn   = {x=-1199.1802978516, y=-184.08113098145, z=59.79},
        Size    = { x = 2.0, y = 2.0, z = 1.0 },
        Color   = { r = 102, g = 204, b = 255 },
        Type    = 27,
        Heading = 169.59108,
        canGoTo = {"Lobby03","Etage13","Etage23","Etage33","Etage53","Etage63","Etage73"}
    },

    Etage44 = { -- Etage1 4 / 4
        Marker  = {x=-1197.4893798828, y=-186.58154296875, z=58.79},
        Spawn   = {x=-1197.4893798828, y=-186.58154296875, z=59.79},
        Size    = { x = 2.0, y = 2.0, z = 1.0 },
        Color   = { r = 102, g = 204, b = 255 },
        Type    = 27,
        Heading = 169.59108,
        canGoTo = {"Lobby04","Etage14","Etage24","Etage34","Etage54","Etage64","Etage74"}
    },

    Etage51 = { -- Etage1 1 / 4
        Marker  = {x=-1203.1069335938,y=-190.87379455566,z=62.79},
        Spawn   = {x=-1203.1069335938,y=-190.87379455566,z=63.79},
        Size    = { x = 2.0, y = 2.0, z = 1.0 },
        Color   = { r = 102, g = 204, b = 255 },
        Type    = 27,
        Heading = 169.59108,
        canGoTo = {"Lobby01","Etage11","Etage21","Etage31","Etage41","Etage61","Etage71"}
    },

    Etage52 = { -- Etage1 2 / 4
        Marker  = {x=-1204.8363037109, y=-188.37803649902, z=62.79},
        Spawn   = {x=-1204.8363037109, y=-188.37803649902, z=63.79},
        Size    = { x = 2.0, y = 2.0, z = 1.0 },
        Color   = { r = 102, g = 204, b = 255 },
        Type    = 27,
        Heading = 169.59108,
        canGoTo = {"Lobby02","Etage12","Etage22","Etage32","Etage42","Etage62","Etage72"}
    },

    Etage53 = { -- Etage1 3 / 4
        Marker  = {x=-1199.1802978516, y=-184.08113098145, z=62.79},
        Spawn   = {x=-1199.1802978516, y=-184.08113098145, z=63.79},
        Size    = { x = 2.0, y = 2.0, z = 1.0 },
        Color   = { r = 102, g = 204, b = 255 },
        Type    = 27,
        Heading = 169.59108,
        canGoTo = {"Lobby03","Etage13","Etage23","Etage33","Etage43","Etage63","Etage73"}
    },

    Etage54 = { -- Etage1 4 / 4
        Marker  = {x=-1197.4893798828, y=-186.58154296875, z=62.79},
        Spawn   = {x=-1197.4893798828, y=-186.58154296875, z=63.79},
        Size    = { x = 2.0, y = 2.0, z = 1.0 },
        Color   = { r = 102, g = 204, b = 255 },
        Type    = 27,
        Heading = 169.59108,
        canGoTo = {"Lobby04","Etage14","Etage24","Etage34","Etage44","Etage64","Etage74"}
    },

    Etage61 = { -- Etage1 1 / 4
        Marker  = {x=-1203.1069335938,y=-190.87379455566,z=66.79},
        Spawn   = {x=-1203.1069335938,y=-190.87379455566,z=67.79},
        Size    = { x = 2.0, y = 2.0, z = 1.0 },
        Color   = { r = 102, g = 204, b = 255 },
        Type    = 27,
        Heading = 169.59108,
        canGoTo = {"Lobby01","Etage11","Etage21","Etage31","Etage41","Etage51","Etage71"}
    },

    Etage62 = { -- Etage1 2 / 4
        Marker  = {x=-1204.8363037109, y=-188.37803649902, z=66.79},
        Spawn   = {x=-1204.8363037109, y=-188.37803649902, z=67.79},
        Size    = { x = 2.0, y = 2.0, z = 1.0 },
        Color   = { r = 102, g = 204, b = 255 },
        Type    = 27,
        Heading = 169.59108,
        canGoTo = {"Lobby02","Etage12","Etage22","Etage32","Etage42","Etage52","Etage72"}
    },

    Etage63 = { -- Etage1 3 / 4
        Marker  = {x=-1199.1802978516, y=-184.08113098145, z=66.79},
        Spawn   = {x=-1199.1802978516, y=-184.08113098145, z=67.79},
        Size    = { x = 2.0, y = 2.0, z = 1.0 },
        Color   = { r = 102, g = 204, b = 255 },
        Type    = 27,
        Heading = 169.59108,
        canGoTo = {"Lobby03","Etage13","Etage23","Etage33","Etage43","Etage53","Etage73"}
    },

    Etage64 = { -- Etage1 4 / 4
        Marker  = {x=-1197.4893798828, y=-186.58154296875, z=66.79},
        Spawn   = {x=-1197.4893798828, y=-186.58154296875, z=67.79},
        Size    = { x = 2.0, y = 2.0, z = 1.0 },
        Color   = { r = 102, g = 204, b = 255 },
        Type    = 27,
        Heading = 169.59108,
        canGoTo = {"Lobby04","Etage14","Etage24","Etage34","Etage44","Etage54","Etage74"}
    },

    Etage71 = { -- Etage1 1 / 4
        Marker  = {x=-1203.1069335938,y=-190.87379455566,z=70.79},
        Spawn   = {x=-1203.1069335938,y=-190.87379455566,z=71.79},
        Size    = { x = 2.0, y = 2.0, z = 1.0 },
        Color   = { r = 102, g = 204, b = 255 },
        Type    = 27,
        Heading = 169.59108,
        canGoTo = {"Lobby01","Etage11","Etage21","Etage31","Etage41","Etage51","Etage61"}
    },

    Etage72 = { -- Etage1 2 / 4
        Marker  = {x=-1204.8363037109, y=-188.37803649902, z=70.79},
        Spawn   = {x=-1204.8363037109, y=-188.37803649902, z=71.79},
        Size    = { x = 2.0, y = 2.0, z = 1.0 },
        Color   = { r = 102, g = 204, b = 255 },
        Type    = 27,
        Heading = 169.59108,
        canGoTo = {"Lobby02","Etage12","Etage22","Etage32","Etage42","Etage52","Etage62"}
    },

    Etage73 = { -- Etage1 3 / 4
        Marker  = {x=-1199.1802978516, y=-184.08113098145, z=70.79},
        Spawn   = {x=-1199.1802978516, y=-184.08113098145, z=71.79},
        Size    = { x = 2.0, y = 2.0, z = 1.0 },
        Color   = { r = 102, g = 204, b = 255 },
        Type    = 27,
        Heading = 169.59108,
        canGoTo = {"Lobby03","Etage13","Etage23","Etage33","Etage43","Etage53","Etage63"}
    },

    Etage74 = { -- Etage1 4 / 4
        Marker  = {x=-1197.4893798828, y=-186.58154296875, z=70.79},
        Spawn   = {x=-1197.4893798828, y=-186.58154296875, z=71.79},
        Size    = { x = 2.0, y = 2.0, z = 1.0 },
        Color   = { r = 102, g = 204, b = 255 },
        Type    = 27,
        Heading = 169.59108,
        canGoTo = {"Lobby04","Etage14","Etage24","Etage34","Etage44","Etage54","Etage64"}
    }
}

if Config.enableLobbyMap then
	Config.Zones.Lobby01.Marker = { x = -1196.69, y = -173.2, z = 38.3 }
	Config.Zones.Lobby01.Spawn = { x = -1196.69, y = -173.2, z = 39.3 }

	Config.Zones.Lobby02.Marker = { x = -1195.37, y = -170.59, z = 38.3 }
	Config.Zones.Lobby02.Spawn = { x = -1195.37, y = -170.59, z = 39.3 }

	Config.Zones.Lobby03.Marker = { x = -1189.12, y = -173.94, z = 38.3 }
	Config.Zones.Lobby03.Spawn = { x = -1189.12, y = -173.94, z = 39.3 }

	Config.Zones.Lobby04 = {
		Marker = { x = -1190.58, y = -176.5, z = 38.3 },
		Spawn   = { x = -1190.58, y = -176.5, z = 39.3 },
		Size    = { x = 2.0, y = 2.0, z = 1.0 },
		Color   = { r = 255, g = 187, b = 255 },
		Type    = 27,
		Heading = 169.59108,
		canGoTo = { "Etage14","Etage24","Etage34","Etage44","Etage54","Etage64","Etage74" }
	}
end