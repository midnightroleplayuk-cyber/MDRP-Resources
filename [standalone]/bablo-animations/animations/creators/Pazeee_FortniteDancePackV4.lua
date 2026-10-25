Citizen.CreateThread(function()
    if not Config.Creators['Pazeee_FortniteDancePackV4'] then return end
    
    local musicEnabled = false
    local Animations = {
        Emotes = {
            ["pfstarlit"] = {
                "pazeeefortnitestarlit@animations",
                "pazeeefortnitestarlitclip",
                "Fortnite Starlit",
                animationOptions = {
                    emoteLoop = true,
                    musicURL = musicEnabled and "https://www.youtube.com/watch?v=wi4IpPjF75s" or nil,
                }
            },
            ["pfboneybounce"] = {
                "pazeeefortniteboneybounce@animations",
                "pazeeefortniteboneybounceclip",
                "Fortnite Boney Bounce",
                animationOptions = {
                    emoteLoop = true,
                    musicURL = musicEnabled and "https://www.youtube.com/watch?v=4RZWahkEixU" or nil,
                }
            },
            ["pfevilplan"] = {
                "pazeeefortniteevilplan@animations",
                "pazeeefortniteevilplanclip",
                "Fortnite Evil Plan",
                animationOptions = {
                    emoteLoop = true,
                    musicURL = musicEnabled and "https://www.youtube.com/watch?v=fCy5-G6ksBU" or nil,
                }
            },
            ["pfdancindomino"] = {
                "pazeeefortnitedancindomino@animations",
                "pazeeefortnitedancindominoclip",
                "Fortnite Dancin' Domino",
                animationOptions = {
                    emoteLoop = true,
                    musicURL = musicEnabled and "https://www.youtube.com/watch?v=JmVtkfXf9KM" or nil,
                }
            },
            ["pfpointandstrut"] = {
                "pazeeefortnitepointandstrut@animations",
                "pazeeefortnitepointandstrutclip",
                "Fortnite Point And Strut",
                animationOptions = {
                    emoteLoop = true,
                    musicURL = musicEnabled and "https://www.youtube.com/watch?v=caIBpZ8Yrtw" or nil,
                }
            },
            ["pfthedancelaroi"] = {
                "pazeeefortnitethedancelaroi@animations",
                "pazeeefortnitethedancelaroiclip",
                "Fortnite The Dance Laroi",
                animationOptions = {
                    emoteLoop = true,
                    musicURL = musicEnabled and "https://www.youtube.com/watch?v=gVv4AvmP-IE" or nil,
                }
            },
            ["pfcopines"] = {
                "pazeeefortnitecopines@animations",
                "pazeeefortnitecopinesclip",
                "Fortnite Copines",
                animationOptions = {
                    emoteLoop = true,
                    musicURL = musicEnabled and "https://www.youtube.com/watch?v=_ZDuz9MH_rM" or nil,
                }
            },
            ["pfmikubeam"] = {
                "pazeeefortnitemikubeam@animations",
                "pazeeefortnitemikubeamclip",
                "Fortnite Miku Miku Beam",
                animationOptions = {
                    emoteLoop = true,
                    musicURL = musicEnabled and "https://www.youtube.com/watch?v=imJaDUg8WPo" or nil,
                }
            },
            ["pfitstrue"] = {
                "pazeeefortniteitstrue@animations",
                "pazeeefortniteitstrueclip",
                "Fortnite It's True",
                animationOptions = {
                    emoteLoop = true,
                    musicURL = musicEnabled and "https://www.youtube.com/watch?v=8CEUbNfUzoE" or nil,
                }
            },
            ["pfimout"] = {
                "pazeeefortniteimout@animations",
                "pazeeefortniteimoutclip",
                "Fortnite I'm Out",
                animationOptions = {
                    emoteLoop = true,
                    musicURL = musicEnabled and "https://www.youtube.com/watch?v=2j-oHDBv19U" or nil,
                }
            },
            ["pfscenario"] = {
                "pazeeefortnitescenario@animations",
                "pazeeefortnitescenarioclip",
                "Fortnite Scenario",
                animationOptions = {
                    emoteLoop = true,
                    musicURL = musicEnabled and "https://www.youtube.com/watch?v=2xHYqQZEQ6U" or nil,
                }
            },
            ["pfjabbaswitchway"] = {
                "pazeeefortnitejabbaswitchway@animations",
                "pazeeefortnitejabbaswitchwayclip",
                "Fortnite Jabba Switchway",
                animationOptions = {
                    emoteLoop = true,
                    musicURL = musicEnabled and "https://www.youtube.com/watch?v=GiROufLzUo8" or nil,
                }
            },
            ["pfgomufasa"] = {
                "pazeeefortnitegomufasa@animations",
                "pazeeefortnitegomufasaclip",
                "Fortnite Go Mufasa",
                animationOptions = {
                    emoteLoop = true,
                    musicURL = musicEnabled and "https://www.youtube.com/watch?v=5uGDwqpfckg" or nil,
                }
            },
            ["pfgomufasamove"] = {
                "pazeeefortnitegomufasamove@animations",
                "pazeeefortnitegomufasamoveclip",
                "Fortnite Go Mufasa Move",
                animationOptions = {
                    emoteLoop = true,
                    musicURL = musicEnabled and "https://www.youtube.com/watch?v=5uGDwqpfckg" or nil,
                }
            },
            ["pfeverybodylovesme"] = {
                "pazeeefortniteeverybodylovesme@animations",
                "pazeeefortniteeverybodylovesmeclip",
                "Fortnite Everybody Loves Me",
                animationOptions = {
                    emoteLoop = true,
                    musicURL = musicEnabled and "https://www.youtube.com/watch?v=XaUlyDGWMQ8" or nil,
                }
            },
            ["pfgetgriddy"] = {
                "pazeeefortnitegetgriddy@animations",
                "pazeeefortnitegetgriddyclip",
                "Fortnite Get Griddy",
                animationOptions = {
                    emoteLoop = true,
                    musicURL = musicEnabled and "https://www.youtube.com/watch?v=BngqQS-IhNY" or nil,
                }
            },
            ["pfgetgriddymove"] = {
                "pazeeefortnitegetgriddymove@animations",
                "pazeeefortnitegetgriddymoveclip",
                "Fortnite Get Griddy Move",
                animationOptions = {
                    emoteLoop = true,
                    musicURL = musicEnabled and "https://www.youtube.com/watch?v=BngqQS-IhNY" or nil,
                }
            },
            ["pflofiheadbang"] = {
                "pazeeefortnitelofiheadbang@animations",
                "pazeeefortnitelofiheadbangclip",
                "Fortnite Lo-Fi Headbang",
                animationOptions = {
                    emoteLoop = true,
                    musicURL = musicEnabled and "https://www.youtube.com/watch?v=TXyQH7VvaCs" or nil,
                }
            },
            ["pfrebellious"] = {
                "pazeeefortniterebellious@animations",
                "pazeeefortniterebelliousclip",
                "Fortnite Rebellious",
                animationOptions = {
                    emoteLoop = true,
                    musicURL = musicEnabled and "https://www.youtube.com/watch?v=mLQWgHPmJrQ" or nil,
                }
            },
            ["pfbackon74"] = {
                "pazeeefortnitebackon74@animations",
                "pazeeefortnitebackon74clip",
                "Fortnite Back On 74",
                animationOptions = {
                    emoteLoop = true,
                    musicURL = musicEnabled and "https://www.youtube.com/watch?v=-4cdDdn_6DA" or nil,
                }
            },
            ["pfbackon74move"] = {
                "pazeeefortnitebackon74move@animations",
                "pazeeefortnitebackon74moveclip",
                "Fortnite Back On 74 Move",
                animationOptions = {
                    emoteLoop = true,
                    musicURL = musicEnabled and "https://www.youtube.com/watch?v=-4cdDdn_6DA" or nil,
                }
            },
        },

        -- Emotes = {}
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