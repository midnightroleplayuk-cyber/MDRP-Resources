Citizen.CreateThread(function()
    if not Config.Creators['Pazeee_Dances'] then return end
    
    local Animations = {
        Dances = {
            ["zdance1"] = {
                "zdance1@animations",
                "zdance1_clip",
                "ZDance 1",
                animationOptions = {
                    emoteLoop = true,
                }
            },
            ["zdance2"] = {
                "zdance2@animations",
                "zdance2_clip",
                "ZDance 2",
                animationOptions = {
                    emoteLoop = true,
                }
            },
            ["zdance3"] = {
                "zdance3@animations",
                "zdance3_clip",
                "ZDance 3",
                animationOptions = {
                    emoteLoop = true,
                }
            },
            ["zdance4"] = {
                "zdance4@animations",
                "zdance4_clip",
                "ZDance 4",
                animationOptions = {
                    emoteLoop = true,
                }
            },
            ["zdance5"] = {
                "zdance5@animations",
                "zdance5_clip",
                "ZDance 5",
                animationOptions = {
                    emoteLoop = true,
                }
            },
            ["zdance6"] = {
                "zdance6@animations",
                "zdance6_clip",
                "ZDance 6",
                animationOptions = {
                    emoteLoop = true,
                }
            },
            ["zdance7"] = {
                "zdance7@animations",
                "zdance7_clip",
                "ZDance 7",
                animationOptions = {
                    emoteLoop = true,
                }
            },
            ["zdance8"] = {
                "zdance8@animations",
                "zdance8_clip",
                "ZDance 8",
                animationOptions = {
                    emoteLoop = true,
                }
            },
            ["zdance9"] = {
                "zdance9@animations",
                "zdance9_clip",
                "ZDance 9",
                animationOptions = {
                    emoteLoop = true,
                }
            },
            ["zdance10"] = {
                "zdance10@animations",
                "zdance10_clip",
                "ZDance 10",
                animationOptions = {
                    emoteLoop = true,
                }
            },
            ["zdance11"] = {
                "zdance11@animations",
                "zdance11_clip",
                "ZDance 11",
                animationOptions = {
                    emoteLoop = true,
                }
            },
            ["zdance12"] = {
                "zdance12@animations",
                "zdance12_clip",
                "ZDance 12",
                animationOptions = {
                    emoteLoop = true,
                }
            },
            ["zdance13"] = {
                "zdance13@animations",
                "zdance13_clip",
                "ZDance 13",
                animationOptions = {
                    emoteLoop = true,
                }
            },
            ["zdance14"] = {
                "zdance14@animations",
                "zdance14_clip",
                "ZDance 14",
                animationOptions = {
                    emoteLoop = true,
                }
            },
            ["zdance15"] = {
                "zdance15@animations",
                "zdance15_clip",
                "ZDance 15",
                animationOptions = {
                    emoteLoop = true,
                }
            },
            ["zdance16"] = {
                "zdance16@animations",
                "zdance16_clip",
                "ZDance 16",
                animationOptions = {
                    emoteLoop = true,
                }
            },
            ["zdance17"] = {
                "zdance17@animations",
                "zdance17_clip",
                "ZDance 17",
                animationOptions = {
                    emoteLoop = true,
                }
            },
            ["zdance18"] = {
                "zdance18@animations",
                "zdance18_clip",
                "ZDance 18",
                animationOptions = {
                    emoteLoop = true,
                }
            },
            ["zdance19"] = {
                "zdance19@animations",
                "zdance19_clip",
                "ZDance 19",
                animationOptions = {
                    emoteLoop = true,
                }
            },
            ["zdance20"] = {
                "zdance20@animations",
                "zdance20_clip",
                "ZDance 20",
                animationOptions = {
                    emoteLoop = true,
                }
            },
            ["zdance21"] = {
                "zdance21@animations",
                "zdance21_clip",
                "ZDance 21",
                animationOptions = {
                    emoteLoop = true,
                }
            },
            ["zdance22"] = {
                "zdance22@animations",
                "zdance22_clip",
                "ZDance 22",
                animationOptions = {
                    emoteLoop = true,
                }
            },
            ["waitdance"] = {
                "waitdance@animations",
                "waitdanceclip",
                "Wait Dance Trend",
                animationOptions = {
                    emoteLoop = true,
                }
            },
            ["terminatordance"] = {
                "terminatordance@animations",
                "terminatordanceclip",
                "Terminator Dance",
                animationOptions = {
                    emoteLoop = true,
                }
            },
            ["segadance"] = {
                "segadance@animations",
                "segadance_clip",
                "Sega Dance",
                animationOptions = {
                    emoteLoop = true,
                }
            },
            ["robloxardance"] = {
                "robloxardance@animations",
                "robloxardanceclip",
                "Roblox Ar Dance",
                animationOptions = {
                    emoteLoop = true,
                }
            },
            ["pubghaidilaodance"] = {
                "pubghaidilaodance@animations",
                "pubghaidilaodance_clip",
                "PUBG Haidilao Dance",
                animationOptions = {
                    emoteLoop = true,
                }
            },
            ["danceitsmylife"] = {
                "danceitsmylife@animations",
                "danceitsmylife_clip",
                "PUBG It's My Life Dance",
                animationOptions = {
                    emoteLoop = true,
                }
            },
            ["pubgnastygirl"] = {
                "nastygirl@animations",
                "nastygirlclip",
                "PUBG Nasty Girl",
                animationOptions = {
                    emoteLoop = true,
                }
            },
            ["pkdapopstars"] = {
                "pkdapopstars@animations",
                "pkdapopstarsclip",
                "KDA Pop Stars Dance",
                animationOptions = {
                    emoteLoop = true,
                }
            },
            ["plingaguliguli"] = {
                "plingaguliguli@animations",
                "plingaguliguliclip",
                "Linga Guli Guli Dance Doodle",
                animationOptions = {
                    emoteLoop = true,
                }
            },
            ["plumbairibilangbos"] = {
                "plumbairibilangbos@animations",
                "plumbairibilangbosclip",
                "Goyang Lumba Iri Bilang Bos",
                animationOptions = {
                    emoteLoop = true,
                }
            },
            ["plumbalumbajoget"] = {
                "plumbalumbajoget@animations",
                "plumbalumbajogetclip",
                "Goyang Lumba Lumba Joget",
                animationOptions = {
                    emoteLoop = true,
                }
            },
            ["pkawaikutegomen"] = {
                "pkawaikutegomen@animations",
                "pkawaikutegomenclip",
                "Kawaikute Gomen Dance",
                animationOptions = {
                    emoteLoop = true,
                }
            },
            ["ppokedance"] = {
                "ppokedance@animations",
                "ppokedanceclip",
                "Poke Dance",
                animationOptions = {
                    emoteLoop = true,
                }
            },
            ["psadbor1"] = {
                "psadbor1@animations",
                "psadbor1clip",
                "Joget Sadbor",
                animationOptions = {
                    emoteLoop = true,
                }
            },
            ["psadbor2"] = {
                "psadbor2@animations",
                "psadbor2clip",
                "Joget Sadbor Awal",
                animationOptions = {
                    emoteLoop = true,
                }
            },
            ["pfriches"] = {
                "pfriches@animations",
                "pfrichesclip",
                "Fortnite Riches",
                animationOptions = {
                    emoteLoop = true,
                }
            },
            ["pfdesirable"] = {
                "pfdesirable@animations",
                "pfdesirableclip",
                "Fortnite Desirable",
                animationOptions = {
                    emoteLoop = true,
                }
            },
            ["pftakeitslow"] = {
                "pftakeitslow@animations",
                "pftakeitslowclip",
                "Fortnite Take It Slow",
                animationOptions = {
                    emoteLoop = true,
                }
            },
            ["pfthedog"] = {
                "pfthedog@animations",
                "pfthedogclip",
                "Fortnite The Dog",
                animationOptions = {
                    emoteLoop = true,
                }
            },
            ["pfsnoopswalk"] = {
                "pfsnoopswalk@animations",
                "pfsnoopswalkclip",
                "Fortnite Snoop's Walk",
                animationOptions = {
                    emoteLoop = true,
                }
            },
            ["pfrhythmofchaos"] = {
                "pfrhythmofchaos@animations",
                "pfrhythmofchaosclip",
                "Fortnite Rhythm of Chaos",
                animationOptions = {
                    emoteLoop = true,
                }
            },
            ["pfmoongazer"] = {
                "pfmoongazer@animations",
                "pfmoongazerclip",
                "Fortnite Moongazer",
                animationOptions = {
                    emoteLoop = true,
                }
            },
            ["pfcaffeinated"] = {
                "pfcaffeinated@animations",
                "pfcaffeinatedclip",
                "Fortnite Caffeinated",
                animationOptions = {
                    emoteLoop = true,
                }
            },
            ["pfcaffeinatedold"] = {
                "pfcaffeinatedold@animations",
                "pfcaffeinatedoldclip",
                "Fortnite Caffeinated Old",
                animationOptions = {
                    emoteLoop = true,
                }
            },
            ["pfcommitted"] = {
                "pfcommitted@animations",
                "pfcommittedclip",
                "Fortnite Committed",
                animationOptions = {
                    emoteLoop = true,
                }
            },
            ["pfdimensional"] = {
                "pfdimensional@animations",
                "pfdimensionalclip",
                "Fortnite Dimensional",
                animationOptions = {
                    emoteLoop = true,
                }
            },
            ["pfflytotokyo"] = {
                "pfflytotokyo@animations",
                "pfflytotokyoclip",
                "Fortnite Fly To Tokyo",
                animationOptions = {
                    emoteLoop = true,
                }
            },
            ["pfattraction"] = {
                "pfattraction@animations",
                "pfattractionclip",
                "Fortnite Attraction",
                animationOptions = {
                    emoteLoop = true,
                }
            },
            ["pfluciddreams"] = {
                "pfluciddreams@animations",
                "pfluciddreamsclip",
                "Fortnite Lucid Dreams",
                animationOptions = {
                    emoteLoop = true,
                }
            },
            ["pfskeledance"] = {
                "pfskeledance@animations",
                "pfskeledanceclip",
                "Fortnite Skele Dance",
                animationOptions = {
                    emoteLoop = true,
                }
            },
            ["pftheviper"] = {
                "pftheviper@animations",
                "pftheviperclip",
                "Fortnite The Viper",
                animationOptions = {
                    emoteLoop = true,
                }
            },
            ["pfgethot"] = {
                "pfgethot@animations",
                "pfgethotclip",
                "Fortnite Get Hot",
                animationOptions = {
                    emoteLoop = true,
                }
            },
            ["pfemptyoutyourpockets"] = {
                "pfemptyoutyourpockets@animations",
                "pfemptyoutyourpocketsclip",
                "Fortnite Empty Out Your Pockets",
                animationOptions = {
                    emoteLoop = true,
                }
            },
            ["pfrapmonster"] = {
                "pfrapmonster@animations",
                "pfrapmonsterclip",
                "Fortnite Rap Monster",
                animationOptions = {
                    emoteLoop = true,
                }
            },
            ["pfmaskoff"] = {
                "pfmaskoff@animations",
                "pfmaskoffclip",
                "Fortnite Mask Off",
                animationOptions = {
                    emoteLoop = true,
                }
            },
            ["pfnuthinbutagthang"] = {
                "pfnuthinbutagthang@animations",
                "pfnuthinbutagthangclip",
                "Fortnite Nuthin' But A G Thang",
                animationOptions = {
                    emoteLoop = true,
                }
            },
            ["pfcoffin"] = {
                "pfcoffin@animations",
                "pfcoffinclip",
                "Fortnite Coffin",
                animationOptions = {
                    emoteLoop = true,
                }
            },
            ["pfcoffinmove"] = {
                "pfcoffinmove@animations",
                "pfcoffinmoveclip",
                "Fortnite Coffin Move",
                animationOptions = {
                    emoteLoop = true,
                }
            },
            ["pfcalifornialove"] = {
                "pfcalifornialove@animations",
                "pfcalifornialoveclip",
                "Fortnite California Love",
                animationOptions = {
                    emoteLoop = true,
                }
            },
            ["pfbyebyebye"] = {
                "pfbyebyebye@animations",
                "pfbyebyebyeclip",
                "Fortnite Bye Bye Bye",
                animationOptions = {
                    emoteLoop = true,
                }
            },
            ["pfsoarabove"] = {
                "pfsoarabove@animations",
                "pfsoaraboveclip",
                "Fortnite Soar Above",
                animationOptions = {
                    emoteLoop = true,
                }
            },
            ["pfalliwantforchristmas"] = {
                "pfalliwantforchristmas@animations",
                "pfalliwantforchristmasclip",
                "Fortnite All I Want For Christmas",
                animationOptions = {
                    emoteLoop = true,
                }
            },
            ["ptrump"] = {
                "ptrump@animations",
                "ptrumpclip",
                "Trump Dance",
                animationOptions = {
                    emoteLoop = true,
                }
            },
            ["ptrumpsup"] = {
                "ptrumpsup@animations",
                "ptrumpsupclip",
                "Trump Supporters Dance",
                animationOptions = {
                    emoteLoop = true,
                }
            },
            ["jktdance"] = {
                "jktdance@animations",
                "jktdance_clip",
                "JKT48 Hisatsu Teleport Dance",
                animationOptions = {
                    emoteLoop = true,
                }
            },
            ["jktdance2"] = {
                "jktdance2@animations",
                "jktdance2_clip",
                "JKT48 Heavy Rotation Dance",
                animationOptions = {
                    emoteLoop = true,
                }
            },
            ["jktdance3"] = {
                "jktdance3@animations",
                "jktdance3_clip",
                "JKT48 Fortune Cookie Dance",
                animationOptions = {
                    emoteLoop = true,
                }
            },
            ["dancepaham"] = {
                "dancepaham@animations",
                "dancepaham_clip",
                "Kak Gem Paham",
                animationOptions = {
                    emoteLoop = true,
                }
            },
            ["danceshikanoko"] = {
                "danceshikanoko@animations",
                "danceshikanoko_clip",
                "Shikanoko Dance",
                animationOptions = {
                    emoteLoop = true,
                }
            },
            ["njditto"] = {
                "njditto@animations",
                "njdittoclip",
                "New Jeans Ditto Dance",
                animationOptions = {
                    emoteLoop = true,
                }
            },
            ["letmeseedance"] = {
                "letmeseedance@animations",
                "letmeseedanceclip",
                "NBA 2K25 Let Me See Dance",
                animationOptions = {
                    emoteLoop = true,
                }
            },
            ["lolidanceslow"] = {
                "lolidanceslow@animations",
                "lolidanceslow",
                "Loli Dance Slow",
                animationOptions = {
                    emoteLoop = true,
                }
            },
            ["lolidancefast"] = {
                "lolidancefast@animations",
                "lolidancefast",
                "Loli Dance Fast",
                animationOptions = {
                    emoteLoop = true,
                }
            },
            ["thickofit"] = {
                "thickofitdance@animations",
                "thickofitdanceclip",
                "Thick Of It 1950s Dance",
                animationOptions = {
                    emoteLoop = true,
                }
            },
            ["ishowspeeddance"] = {
                "ishowspeedcrispeyspraydance@animations",
                "ishowspeedcrispeyspraydanceclip",
                "IShowSpeed Dance",
                animationOptions = {
                    emoteLoop = true,
                }
            },
            ["ifyoudance1"] = {
                "ifyoudancep1@animations",
                "ifyoudancep1_clip",
                "If You Dance Player 1",
                animationOptions = {
                    emoteLoop = true,
                }
            },
            ["ifyoudance2"] = {
                "ifyoudancep2@animations",
                "ifyoudancep2_clip",
                "If You Dance Player 2",
                animationOptions = {
                    emoteLoop = true,
                }
            },
            ["chipichapa"] = {
                "chipichapa@animations",
                "chipichapaclip",
                "Chipi Chipi Chapa Chapa Dance",
                animationOptions = {
                    emoteLoop = true,
                }
            },
        },
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