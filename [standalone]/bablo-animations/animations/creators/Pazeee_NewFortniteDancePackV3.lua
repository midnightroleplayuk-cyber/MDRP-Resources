Citizen.CreateThread(function()
    if not Config.Creators['Pazeee_NewFortniteDancePackV3'] then return end
    
    local musicEnabled = false
    local Animations = {
        Emotes = {},

        Dances = {
            ["pfmikulive"] = {
                "pfmikulive@animations",
                "pfmikuliveclip",
                "Fortnite Miku Live",
                animationOptions = {
                    emoteLoop = true,
                    musicURL = musicEnabled and "https://www.youtube.com/watch?v=NeqUoCCVca0" or nil,
                }
            },
            ["pffeelit"] = {
                "pffeelit@animations",
                "pffeelitclip",
                "Fortnite Feel It",
                animationOptions = {
                    emoteLoop = true,
                    musicURL = musicEnabled and "https://www.youtube.com/watch?v=0viN_8L-wuk" or nil,
                }
            },
            ["pfstartingprance"] = {
                "pfstartingprance@animations",
                "pfstartingpranceclip",
                "Fortnite Starting Prance",
                animationOptions = {
                    emoteLoop = true,
                    musicURL = musicEnabled and "https://www.youtube.com/watch?v=Id8vb-AENrA" or nil,
                }
            },
            ["pfskyward"] = {
                "pfskyward@animations",
                "pfskywardclip",
                "Fortnite Skyward",
                animationOptions = {
                    emoteLoop = true,
                    musicURL = musicEnabled and "https://www.youtube.com/watch?v=IKFk4KlEGC4" or nil,
                }
            },
            ["pfsmoothoperator"] = {
                "pfsmoothoperator@animations",
                "pfsmoothoperatorclip",
                "Fortnite Smooth Operator",
                animationOptions = {
                    emoteLoop = true,
                    musicURL = musicEnabled and "https://www.youtube.com/watch?v=N1MRD_NbL4U" or nil,
                }
            },
            ["pfbratty"] = {
                "pfbratty@animations",
                "pfbrattyclip",
                "Fortnite Bratty",
                animationOptions = {
                    emoteLoop = true,
                    musicURL = musicEnabled and "https://www.youtube.com/watch?v=nqimN3DhOxw" or nil,
                }
            },
            ["pfinhamood"] = {
                "pfinhamood@animations",
                "pfinhamoodclip",
                "Fortnite In Ha Mood",
                animationOptions = {
                    emoteLoop = true,
                    musicURL = musicEnabled and "https://www.youtube.com/watch?v=PgN4eui05Aw" or nil,
                }
            },
            ["pfspicystart"] = {
                "pfspicystart@animations",
                "pfspicystartclip",
                "Fortnite Spicy Start",
                animationOptions = {
                    emoteLoop = true,
                    musicURL = musicEnabled and "https://www.youtube.com/watch?v=uNBAwRuZdv4" or nil,
                }
            },
            ["pfdeepexplorer"] = {
                "pfdeepexplorer@animations",
                "pfdeepexplorerclip",
                "Fortnite Deep Explorer",
                animationOptions = {
                    emoteLoop = true,
                    musicURL = musicEnabled and "https://www.youtube.com/watch?v=ihTYSap5Bxk" or nil,
                }
            },
            ["pfwhatyouwant"] = {
                "pfwhatyouwant@animations",
                "pfwhatyouwantclip",
                "Fortnite What You Want",
                animationOptions = {
                    emoteLoop = true,
                    musicURL = musicEnabled and "https://www.youtube.com/watch?v=NrvAktOBvc4" or nil,
                }
            },
            ["pflinedancin"] = {
                "pflinedancin@animations",
                "pflinedancinclip",
                "Fortnite Line Dancin",
                animationOptions = {
                    emoteLoop = true,
                    musicURL = musicEnabled and "https://www.youtube.com/watch?v=ywSUUAU-LtA" or nil,
                }
            },
            ["pfindependence"] = {
                "pfindependence@animations",
                "pfindependenceclip",
                "Fortnite Independence",
                animationOptions = {
                    emoteLoop = true,
                    musicURL = musicEnabled and "https://www.youtube.com/watch?v=hkZVfncWCNk" or nil,
                }
            },
            ["pfcairo"] = {
                "pfcairo@animations",
                "pfcairoclip",
                "Fortnite Cairo",
                animationOptions = {
                    emoteLoop = true,
                    musicURL = musicEnabled and "https://www.youtube.com/watch?v=ouYh2SU2G_g" or nil,
                }
            },
            ["pfokidoki"] = {
                "pfokidoki@animations",
                "pfokidokiclip",
                "Fortnite Oki Doki",
                animationOptions = {
                    emoteLoop = true,
                    musicURL = musicEnabled and "https://www.youtube.com/watch?v=4_t1jqGHB2o" or nil,
                }
            },
            ["pfoutlaw"] = {
                "pfoutlaw@animations",
                "pfoutlawclip",
                "Fortnite Outlaw",
                animationOptions = {
                    emoteLoop = true,
                    musicURL = musicEnabled and "https://www.youtube.com/watch?v=3jinO-3ANGU" or nil,
                }
            },
            ["pfnotears"] = {
                "pfnotears@animations",
                "pfnotearsclip",
                "Fortnite No Tears",
                animationOptions = {
                    emoteLoop = true,
                    musicURL = musicEnabled and "https://www.youtube.com/watch?v=DkMIVl8ih4U" or nil,
                }
            },
            ["pfmine"] = {
                "pfmine@animations",
                "pfmineclip",
                "Fortnite Mine",
                animationOptions = {
                    emoteLoop = true,
                    musicURL = musicEnabled and "https://www.youtube.com/watch?v=nyjQkwJFo08" or nil,
                }
            },
            ["pflookinggood"] = {
                "pflookinggood@animations",
                "pflookinggoodclip",
                "Fortnite Looking Good",
                animationOptions = {
                    emoteLoop = true,
                    musicURL = musicEnabled and "https://www.youtube.com/watch?v=f4cSsA7G_fY" or nil,
                }
            },
            ["pfheelclickbreakdown"] = {
                "pfheelclickbreakdown@animations",
                "pfheelclickbreakdownclip",
                "Fortnite Heel Click Breakdown",
                animationOptions = {
                    emoteLoop = true,
                    musicURL = musicEnabled and "https://www.youtube.com/watch?v=x5kti63J1pM" or nil,
                }
            },
            ["pfentranced"] = {
                "pfentranced@animations",
                "pfentrancedclip",
                "Fortnite Entranced",
                animationOptions = {
                    emoteLoop = true,
                    musicURL = musicEnabled and "https://www.youtube.com/watch?v=CQz0Z8Ag2F8" or nil,
                }
            },
            ["pffeelitfly"] = {
                "pffeelitfly@animations",
                "pffeelitflyclip",
                "Fortnite Feel It Fly",
                animationOptions = {
                    emoteLoop = true,
                    musicURL = musicEnabled and "https://www.youtube.com/watch?v=0viN_8L-wuk" or nil,
                }
            },
        }
    }

    while not Config.Custom do Wait(0) end

    for arrayName, array in pairs(Animations) do
        if Config.Custom[arrayName] then
            for emoteName, emoteData in pairs(array) do
                Config.Custom[arrayName][emoteName] = emoteData
            end
        end
    end
end)