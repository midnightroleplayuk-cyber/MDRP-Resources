-- Any animations you put in here will be converted to the right format use this if you are to lazy to format your animations from dpemotes/rpemotes

Config.Convert = {
    Dances = {},
    Emotes = {},
    Shared = {

        ["hug"] = {
            "mp_ped_interaction",
            "kisses_guy_a",
            "Hug",
            "hug2",
            AnimationOptions = {
                EmoteMoving = false,
                EmoteDuration = 5000,
                SyncOffsetFront = 1.05
            }
        },
        ["hug2"] = {
            "mp_ped_interaction",
            "kisses_guy_b",
            "Hug 2",
            "hug",
            AnimationOptions = {
                EmoteMoving = false,
                EmoteDuration = 5000,
                SyncOffsetFront = 1.18
            }
        },
        ["hugr"] = {
            "misscarsteal2chad_goodbye",
            "chad_armsaround_chad",
            "Hug Romantic 1",
            "hugr2",
            AnimationOptions = {
                EmoteMoving = false,
                EmoteLoop = true,
                SyncOffsetSide = -0.05,
                SyncOffsetFront = 0.52
            }
        },
        ["hugr2"] = {
            "misscarsteal2chad_goodbye",
            "chad_armsaround_girl",
            "Hug Romantic 2",
            "hugr",
            AnimationOptions = {
                EmoteMoving = false,
                EmoteLoop = true,
                SyncOffsetSide = -0.05,
                SyncOffsetFront = 0.52
            }
        },
        ["bro"] = {
            "mp_ped_interaction",
            "hugs_guy_a",
            "Bro",
            "bro2",
            AnimationOptions = {
                SyncOffsetFront = 1.14
            }
        },
        ["bro2"] = {
            "mp_ped_interaction",
            "hugs_guy_b",
            "Bro 2",
            "bro",
            AnimationOptions = {
                SyncOffsetFront = 1.14
            }
        },
        ["give"] = {
            "mp_common",
            "givetake1_a",
            "Give",
            "give2",
            AnimationOptions = {
                EmoteMoving = true,
                EmoteDuration = 2000
            }
        },
        ["give2"] = {
            "mp_common",
            "givetake1_b",
            "Give 2",
            "give",
            AnimationOptions = {
                EmoteMoving = true,
                EmoteDuration = 2000
            }
        },
        ["baseball"] = {
            "anim@arena@celeb@flat@paired@no_props@",
            "baseball_a_player_a",
            "Baseball",
            "baseballthrow"
        },
        ["baseballthrow"] = {
            "anim@arena@celeb@flat@paired@no_props@",
            "baseball_a_player_b",
            "Baseball Throw",
            "baseball"
        },
        ["stickup"] = {
            "random@countryside_gang_fight",
            "biker_02_stickup_loop",
            "Stick Up",
            "stickupscared",
            AnimationOptions = {
                EmoteLoop = true,
                EmoteMoving = true
            }
        },
        ["stickupscared"] = {
            "missminuteman_1ig_2",
            "handsup_base",
            "Stickup Scared",
            "stickup",
            AnimationOptions = {
                EmoteMoving = true,
                EmoteLoop = true
            }
        },
        ["punch"] = {
            "melee@unarmed@streamed_variations",
            "plyr_takedown_rear_lefthook",
            "Punch",
            "punched"
        },
        ["punched"] = {
            "melee@unarmed@streamed_variations",
            "victim_takedown_front_cross_r",
            "Punched",
            "punch"
        },
        ["headbutt"] = {
            "melee@unarmed@streamed_variations",
            "plyr_takedown_front_headbutt",
            "Headbutt",
            "headbutted"
        },
        ["headbutted"] = {
            "melee@unarmed@streamed_variations",
            "victim_takedown_front_headbutt",
            "Headbutted",
            "headbutt"
        },
        ["slap2"] = {
            "melee@unarmed@streamed_variations",
            "plyr_takedown_front_backslap",
            "Slap 2",
            "slapped2",
            AnimationOptions = {
                EmoteLoop = true,
                EmoteMoving = true,
                EmoteDuration = 2000
            }
        },
        ["slap"] = {
            "melee@unarmed@streamed_variations",
            "plyr_takedown_front_slap",
            "Slap",
            "slapped",
            AnimationOptions = {
                EmoteLoop = true,
                EmoteMoving = true,
                EmoteDuration = 2000
            }
        },
        ["slapped"] = {
            "melee@unarmed@streamed_variations",
            "victim_takedown_front_slap",
            "Slapped",
            "slap"
        },
        ["slapped2"] = {
            "melee@unarmed@streamed_variations",
            "victim_takedown_front_backslap",
            "Slapped 2",
            "slap2"
        },
        ["carry"] = {
            "missfinale_c2mcs_1",
            "fin_c2_mcs_1_camman",
            "Carry",
            "carry2",
            AnimationOptions = {
                EmoteMoving = true,
                EmoteLoop = true,
                SkipRequest = true
            }
        },
        ["carry2"] = {
            "nm",
            "firemans_carry",
            "Be carried",
            "carry",
            AnimationOptions = {
                EmoteMoving = false,
                EmoteLoop = true,
                Attachto = true,
                bone = 40269,
                xPos = -0.14,
                yPos = 0.15,
                zPos = 0.14,
                xRot = 0.0,
                yRot = -59.0,
                SkipRequest = true,
                zRot = -4.5
            }
        },
        ["carry3"] = {
            "anim@heists@box_carry@",
            "idle",
            "Carry 2",
            "carry4",
            AnimationOptions = {
                EmoteMoving = true,
                EmoteLoop = true
            }
        },
        ["carry4"] = {
            "amb@code_human_in_car_idles@generic@ps@base",
            "base",
            "Be carried 2",
            "carry3",
            AnimationOptions = {
                EmoteMoving = false,
                EmoteLoop = true,
                Attachto = true,
                bone = 28252,
                xPos = 0.350,
                yPos = 0.15,
                zPos = -0.15,
                xRot = -42.50,
                yRot = -22.50,
                zRot = 22.50
            }
        },
        ["csdog"] = {
            "anim@heists@box_carry@",
            "idle",
            "Carry Small Dog",
            "csdog2",
            AnimationOptions = {
                EmoteMoving = true,
                EmoteLoop = true
            },
            AnimalEmote = true
        },
        ["csdog2"] = { -- Emote by MissSnowie
            "misssnowie@little_doggy_lying_down",
            "base",
            "Small Dog Carried",
            "csdog",
            AnimationOptions = {
                EmoteMoving = false,
                EmoteLoop = true,
                Attachto = true,
                xPos = -0.040,
                yPos = 0.330,
                zPos = 0.280,
                xRot = 0.0,
                yRot = 0.0,
                zRot = 80.0,
            },
            AnimalEmote = true
        },
        ["cbdog"] = {
            "anim@heists@box_carry@",
            "idle",
            "Carry Big Dog",
            "cbdog2",
            AnimationOptions = {
                EmoteMoving = true,
                EmoteLoop = true
            },
            AnimalEmote = true
        },
        ["cbdog2"] = {
            "creatures@rottweiler@amb@sleep_in_kennel@",
            "sleep_in_kennel",
            "Big Dog Carried",
            "cbdog",
            AnimationOptions = {
                EmoteMoving = false,
                EmoteLoop = true,
                Attachto = true,
                xPos = -0.100,
                yPos = 0.650,
                zPos = 0.430,
                xRot = 0.0,
                yRot = 0.0,
                zRot = -100.00,
            },
            AnimalEmote = true
        },
        ["cprs"] = {
            "mini@cpr@char_a@cpr_str",
            "cpr_pumpchest",
            "Give CPR",
            "cprs2",
            AnimationOptions = {
                EmoteLoop = true,
                StartDelay = 250,
                Skip = true
            }
        },
        ["cprs2"] = {
            "mini@cpr@char_b@cpr_str",
            "cpr_pumpchest",
            "Get CPR",
            "cprs",
            AnimationOptions = {
                EmoteLoop = true,
                Skip = true,
                Attachto = true,
                xPos = 0.35,
                yPos = 0.8,
                zPos = 0.0,
                xRot = 0.0,
                yRot = 0.0,
                zRot = 270.0
            }
        },
        ["cprs3"] = {
            "missheistfbi3b_ig8_2",
            "cpr_loop_paramedic",
            "Give CPR 2",
            "cprs4",
            AnimationOptions = {
                EmoteLoop = true,
                StartDelay = 250
            }
        },
        ["cprs4"] = {
            "missheistfbi3b_ig8_2",
            "cpr_loop_victim",
            "Get CPR 2",
            "cprs3",
            AnimationOptions = {
                EmoteLoop = true,
                Attachto = true,
                xPos = 0.35,
                yPos = 0.65,
                zPos = 0.0,
                xRot = 0.0,
                yRot = 0.0,
                zRot = 270.0
            }
        },
        ["hostage"] = {
            "anim@gangops@hostage@",
            "perp_idle",
            "Take hostage",
            "hostage2",
            AnimationOptions = {
                EmoteMoving = true,
                EmoteLoop = true
            }
        },
        ["hostage2"] = {
            "anim@gangops@hostage@",
            "victim_idle",
            "Be hostage",
            "hostage",
            AnimationOptions = {
                EmoteLoop = true,
                Attachto = true,
                xPos = -0.3,
                yPos = 0.1,
                zPos = 0.0,
                xRot = 0.0,
                yRot = 0.0,
                zRot = 0.0
            }
        },
        ["kiss"] = {
            "hs3_ext-20",
            "cs_lestercrest_3_dual-20",
            "Kiss",
            "kiss2",
            AnimationOptions = {
                EmoteMoving = false,
                EmoteDuration = 10000,
                SyncOffsetFront = 0.08
            }
        },
        ["kiss2"] = {
            "hs3_ext-20",
            "csb_georginacheng_dual-20",
            "Kiss 2",
            "kiss",
            AnimationOptions = {
                EmoteMoving = false,
                EmoteDuration = 10000,
                SyncOffsetFront = 0.08
            }
        },
        ["kiss3"] = {
            "hs3_ext-19",
            "cs_lestercrest_3_dual-19",
            "Kiss 3",
            "kiss4",
            AnimationOptions = {
                EmoteMoving = false,
                EmoteDuration = 10000,
                SyncOffsetFront = 0.08
            }
        },
        ["kiss4"] = {
            "hs3_ext-19",
            "csb_georginacheng_dual-19",
            "Kiss 4",
            "kiss3",
            AnimationOptions = {
                EmoteMoving = false,
                EmoteDuration = 10000,
                SyncOffsetFront = 0.08
            }
        },
        ["coupleanim"] = {
            "anim@scripted@robbery@tun_prep_uni_ig1_couple@",
            "action_var_01_bank_manager",
            "Couple Drinking (Wine Glasses)",
            "coupleanim2",
            AnimationOptions = {
                Prop = 'p_wine_glass_s',
                PropBone = 60309,
                PropPlacement = {
                    -0.0500,
                    -0.0100,
                    -0.1700,
                    0.0,
                    0.0,
                    0.0,
                },
                EmoteMoving = false,
                EmoteLoop = true
            }
        },
        ["coupleanim2"] = {
            "anim@scripted@robbery@tun_prep_uni_ig1_couple@",
            "action_var_01_female",
            "Couple Drinking F (Wine Glasses)",
            "coupleanim",
            AnimationOptions = {
                Prop = 'p_wine_glass_s',
                PropBone = 28422,
                PropPlacement = {
                    0.0,
                    0.0,
                    0.0,
                    0.0,
                    0.0,
                    0.0,
                },
                SyncOffsetSide = -0.04125,
                SyncOffsetFront = 0.11,
                EmoteMoving = false,
                EmoteLoop = true


            }
        },

        ["poutinggfsas"] = {
            "poutinggirlfriend@sasdragonxbablo@animation",
            "poutinggfsas_clip",
            "Pouting GF F",
            "poutinggfbfsas",
            AnimationOptions = {
                EmoteMoving = false,
                EmoteLoop = true,
            }
        },
        ["poutinggfbfsas"] = {
            "poutinggirlfriend@sasdragonxbablo@animation",
            "poutingbfsas_clip",
            "Pouting GF M",
            "poutinggfsas",
            AnimationOptions = {
                EmoteMoving = false,
                EmoteLoop = true,
                Attachto = true,
                xPos = -0.491054,
                yPos = 0.173146,
                zPos = 0.0,
                xRot = 0.0,
                yRot = 0.0,
                zRot = 0.0,
            }
        },

        ["lovepowerfsas"] = {
            "lovepower@sasdragonxbablo@animation",
            "lovepowerf_clip",
            "Love Power F",
            "lovepowermsas",
            AnimationOptions = {
                EmoteMoving = false,
                EmoteLoop = true,
            }
        },
        ["lovepowermsas"] = {
            "lovepower@sasdragonxbablo@animation",
            "lovepowerm_clip",
            "Love Power M",
            "lovepowerfsas",
            AnimationOptions = {
                EmoteMoving = false,
                EmoteLoop = true,
                Attachto = true,
                xPos = 1.02275,
                yPos = 0.0,
                zPos = 0.0,
                xRot = 0.0,
                yRot = 0.0,
                zRot = 0.0,
            }
        },

        ["goofylegsas"] = {
            "goofyleghold@sasdragonxbablo@animation",
            "goofylegsas_clip",
            "GoofyLeg Hold F",
            "goofylegmsas",
            AnimationOptions = {
                EmoteMoving = false,
                EmoteLoop = true,
            }
        },
        ["goofylegmsas"] = {
            "goofyleghold@sasdragonxbablo@animation",
            "goofylegmsas_clip",
            "GoofyLeg Hold M",
            "goofylegsas",
            AnimationOptions = {
                EmoteMoving = false,
                EmoteLoop = true,
                Attachto = true,
                xPos = 0.772748,
                yPos = 0.0,
                zPos = 0.0,
                xRot = 0.0,
                yRot = 0.0,
                zRot = 0.0,
            }
        },


        ["itcouplesas"] = {
            "itcouple@sasdragonxbablo@animation",
            "itcouplesas_clip",
            "It Couple F",
            "itcouplesasm",
            AnimationOptions = {
                EmoteMoving = false,
                EmoteLoop = true,
            }
        },
        ["itcouplesasm"] = {
            "itcouple@sasdragonxbablo@animation",
            "itcouplesasm_clip",
            "It Couple M",
            "itcouplesas",
            AnimationOptions = {
                EmoteMoving = false,
                EmoteLoop = true,
                Attachto = true,
                xPos = 0.556901,
                yPos = 0.0,
                zPos = 0.0,
                xRot = 0.0,
                yRot = 0.0,
                zRot = 0.0,
            }
        },

        ["loversdancesas"] = {
            "loversdance@sasdragonxbablo@animation",
            "loversdancesas_clip",
            "Lovers Dance Finale F",
            "loversdancesasm",
            AnimationOptions = {
                EmoteMoving = false,
                EmoteLoop = true,
            }
        },
        ["loversdancesasm"] = {
            "loversdance@sasdragonxbablo@animation",
            "loversdancesasm_clip",
            "Lovers Dance Finale M",
            "loversdancesas",
            AnimationOptions = {
                EmoteMoving = false,
                EmoteLoop = true,
                Attachto = true,
                xPos = -0.6284,
                yPos = 0.0,
                zPos = 0.0,
                xRot = 0.0,
                yRot = 0.0,
                zRot = 0.0,
            }
        },

        ["neckkissessas"] = {
            "neckkisses@sasdragonxbablo@animation",
            "neckkisses_clip",
            "Neck Kisses F",
            "neckkissessasm",
            AnimationOptions = {
                EmoteMoving = false,
                EmoteLoop = true,
            }
        },
        ["neckkissessasm"] = {
            "neckkisses@sasdragonxbablo@animation",
            "neckkissesm_clip",
            "Neck Kisses M",
            "neckkissessas",
            AnimationOptions = {
                EmoteMoving = false,
                EmoteLoop = true,
                Attachto = true,
                xPos = 0.252782,
                yPos = 0.0,
                zPos = 0.0,
                xRot = 0.0,
                yRot = 0.0,
                zRot = 0.0,
            }
        },

        ["holdhertightsas"] = {
            "holdhertight@sasdragonxbablo@animation",
            "holdhertightsas_clip",
            "Hold Her Tight F",
            "holdhertightsasm",
            AnimationOptions = {
                EmoteMoving = false,
                EmoteLoop = true,
            }
        },
        ["holdhertightsasm"] = {
            "holdhertight@sasdragonxbablo@animation",
            "holdhertightsasm_clip",
            "Hold Her Tight M",
            "holdhertightsas",
            AnimationOptions = {
                EmoteMoving = false,
                EmoteLoop = true,
                Attachto = true,
                xPos = -0.067081,
                yPos = 0.298921,
                zPos = 0.0,
                xRot = 0.0,
                yRot = 0.0,
                zRot = 0.0,
            }
        },

        ["holdhimtightsas"] = {
            "holdhimtight@sasdragonxbablo@animation",
            "holdhimtightsas_clip",
            "Hold Him Tight F",
            "holdhimtightsasm",
            AnimationOptions = {
                EmoteMoving = false,
                EmoteLoop = true,
            }
        },
        ["holdhimtightsasm"] = {
            "holdhimtight@sasdragonxbablo@animation",
            "holdhimtightsasm_clip",
            "Hold Him Tight M",
            "holdhimtightsas",
            AnimationOptions = {
                EmoteMoving = false,
                EmoteLoop = true,
                Attachto = true,
                xPos = -0.617181,
                yPos = 0.0,
                zPos = 0.0,
                xRot = 0.0,
                yRot = 0.0,
                zRot = 0.0,
            }
        },

        ["spicygrabsas"] = {
            "spicygrab@sasdragonxbablo@animation",
            "spicygrabsas_clip",
            "Spicy Grab F",
            "spicygrabsasm",
            AnimationOptions = {
                EmoteMoving = false,
                EmoteLoop = true,
            }
        },
        ["spicygrabsasm"] = {
            "spicygrab@sasdragonxbablo@animation",
            "spicygrabsasm_clip",
            "Spicy Grab M",
            "spicygrabsas",
            AnimationOptions = {
                EmoteMoving = false,
                EmoteLoop = true,
                Attachto = true,
                xPos = -0.525408,
                yPos = 0.0,
                zPos = 0.0,
                xRot = 0.0,
                yRot = 0.0,
                zRot = 0.0,
            }
        },

        ["llaysas"] = {
            "loverslay@sasdragonxbablo@animation",
            "llaysas_clip",
            "Lovers Lay F",
            "llaysasm",
            AnimationOptions = {
                EmoteMoving = false,
                EmoteLoop = true,
            }
        },
        ["llaysasm"] = {
            "loverslay@sasdragonxbablo@animation",
            "llaysasm_clip",
            "Lovers Lay M",
            "llaysas",
            AnimationOptions = {
                EmoteMoving = false,
                EmoteLoop = true,
                Attachto = true,
                xPos = 0.0,
                yPos = 0.212782,
                zPos = 0.0,
                xRot = 0.0,
                yRot = 0.0,
                zRot = 0.0,
            }
        },

        ["cpeiffelsas"] = {
            "cardposeeiffeltower@sasdragonxbablo@animation",
            "cpeiffelsas_clip",
            "Card Pose Eiffel F",
            "cpeiffelsasm",
            AnimationOptions = {
                EmoteMoving = false,
                EmoteLoop = true,
            }
        },
        ["cpeiffelsasm"] = {
            "cardposeeiffeltower@sasdragonxbablo@animation",
            "cpeiffelsasm_clip",
            "Card Pose Eiffel M",
            "cpeiffelsas",
            AnimationOptions = {
                EmoteMoving = false,
                EmoteLoop = true,
                Attachto = true,
                xPos = 0.0,
                yPos = -0.505851,
                zPos = 0.0,
                xRot = 0.0,
                yRot = 0.0,
                zRot = 180.0,
            }
        },

        ["cpairplanesas"] = {
            "cardposeairplane@sasdragonxbablo@animation",
            "cpairplanesas_clip",
            "Card Pose Airplane F",
            "cpairplanesasm",
            AnimationOptions = {
                EmoteMoving = false,
                EmoteLoop = true,
            }

        },
        ["cpairplanesasm"] = {
            "cardposeairplane@sasdragonxbablo@animation",
            "cpairplanesasm_clip",
            "Card Pose Airplane M",
            "cpairplanesas",
            AnimationOptions = {
                EmoteMoving = false,
                EmoteLoop = true,
                Attachto = true,
                xPos = 0.151894,
                yPos = 0.0,
                zPos = 0.0,
                xRot = 0.0,
                yRot = 0.0,
                zRot = 0.0,
            }
        },

        ["rohtsas"] = {
            "ronherthigh@sasdragonxbablo@animation",
            "rohtsas_clip",
            "Rest On Her Thigh F",
            "rohtsasm",
            AnimationOptions = {
                EmoteMoving = false,
                EmoteLoop = true,
            }
        },
        ["rohtsasm"] = {
            "ronherthigh@sasdragonxbablo@animation",
            "rohtsasm_clip",
            "Rest On Her Thigh M",
            "rohtsas",
            AnimationOptions = {
                EmoteMoving = false,
                EmoteLoop = true,
                Attachto = true,
                xPos = -0.167593,
                yPos = 0.0,
                zPos = 0.0,
                xRot = 0.0,
                yRot = 0.0,
                zRot = 0.0,
            }
        },

        ["llayllsas"] = {
            "loverslayll@sasdragonxbablo@animation",
            "llayllsas_clip",
            "LoversLay 2 F",
            "llayllsasm",
            AnimationOptions = {
                EmoteMoving = false,
                EmoteLoop = true,
            }
        },
        ["llayllsasm"] = {
            "loverslayll@sasdragonxbablo@animation",
            "llayllsasm_clip",
            "LoversLay 2 M",
            "llayllsas",
            AnimationOptions = {
                EmoteMoving = false,
                EmoteLoop = true,
                Attachto = true,
                xPos = 0.278459,
                yPos = 0.258153,
                zPos = 0.0,
                xRot = 0.0,
                yRot = 0.0,
                zRot = 0.0,
            }
        },

        ["legreachsas"] = {
            "legreach@sasdragonxbablo@animation",
            "legreachsas_clip",
            "Leg Reach F",
            "legreachsasm",
            AnimationOptions = {
                EmoteMoving = false,
                EmoteLoop = true,
            }
        },
        ["legreachsasm"] = {
            "legreach@sasdragonxbablo@animation",
            "legreachsasm_clip",
            "Leg Reach M",
            "legreachsas",
            AnimationOptions = {
                EmoteMoving = false,
                EmoteLoop = true,
                Attachto = true,
                xPos = 0.0,
                yPos = 0.27515,
                zPos = 0.0,
                xRot = 0.0,
                yRot = 0.0,
                zRot = 0.0,
            }
        },

        ["dnsas"] = {
            "baddiekneel@sasdragonxbablo@animation",
            "dnsas_clip",
            "Baddie Kneel F",
            "dnsasm",
            AnimationOptions = {
                EmoteMoving = false,
                EmoteLoop = true,
            }
        },
        ["dnsasm"] = {
            "baddiekneel@sasdragonxbablo@animation",
            "dnsasm_clip",
            "Baddie Kneel M",
            "dnsas",
            AnimationOptions = {
                EmoteMoving = false,
                EmoteLoop = true,
                Attachto = true,
                xPos = -0.284929,
                yPos = 0.0,
                zPos = 0.0,
                xRot = 0.0,
                yRot = 0.0,
                zRot = 0.0,
            }
        },

        ["loversdancellsas"] = {
            "loversdancell@sasdragonxbablo@animation",
            "loversdancellsas_clip",
            "Lovers Dance 2 F",
            "loversdancellsasm",
            AnimationOptions = {
                EmoteMoving = false,
                EmoteLoop = true,
            }
        },
        ["loversdancellsasm"] = {
            "loversdancell@sasdragonxbablo@animation",
            "loversdancellsasm_clip",
            "Lovers Dance 2 M",
            "loversdancellsas",
            AnimationOptions = {
                EmoteMoving = false,
                EmoteLoop = true,
                Attachto = true,
                xPos = -0.403997,
                yPos = 0.0,
                zPos = 0.0,
                xRot = 0.0,
                yRot = 0.0,
                zRot = 0.0,
            }
        },

        ["loversdancelllsas"] = {
            "loversdancelll@sasdragonxbablo@animation",
            "loversdancelllsas_clip",
            "Lovers Dance 3 F",
            "loversdancelllsasm",
            AnimationOptions = {
                EmoteMoving = false,
                EmoteLoop = true,
            }
        },
        ["loversdancelllsasm"] = {
            "loversdancelll@sasdragonxbablo@animation",
            "loversdancelllsasm_clip",
            "Lovers Dance 3 M",
            "loversdancelllsas",
            AnimationOptions = {
                EmoteMoving = false,
                EmoteLoop = true,
                Attachto = true,
                xPos = -0.416657,
                yPos = 0.209217,
                zPos = 0.0,
                xRot = 0.0,
                yRot = 0.0,
                zRot = 0.0,
            }
        },

        ["goofyheartsas"] = {
            "goofyheart@sasdragonxbablo@animation",
            "goofyheartsas_clip",
            "Goofy Heart F",
            "goofyheartsasm",
            AnimationOptions = {
                EmoteMoving = false,
                EmoteLoop = true,
            }
        },
        ["goofyheartsasm"] = {
            "goofyheart@sasdragonxbablo@animation",
            "goofyheartsasm_clip",
            "Goofy Heart M",
            "goofyheartsas",
            AnimationOptions = {
                EmoteMoving = false,
                EmoteLoop = true,
                Attachto = true,
                xPos = 0.0,
                yPos = 0.0,
                zPos = 0.0,
                xRot = 0.0,
                yRot = 0.0,
                zRot = 180.0,
            }
        },

        ["sassas"] = {
            "sitandstare@sasdragonxbablo@animation",
            "sassas_clip",
            "Sit & Stare F",
            "sassasm",
            AnimationOptions = {
                EmoteMoving = false,
                EmoteLoop = true,
            }
        },
        ["sassasm"] = {
            "sitandstare@sasdragonxbablo@animation",
            "sassasm_clip",
            "Sit & Stare M",
            "sassas",
            AnimationOptions = {
                EmoteMoving = false,
                EmoteLoop = true,
                Attachto = true,
                xPos = 0.0,
                yPos = 0.0,
                zPos = 0.0,
                xRot = 0.0,
                yRot = 0.0,
                zRot = 0.0,
            }
        },

        ["latsas"] = {
            "lookathim@sasdragonxbablo@animation",
            "latsas_clip",
            "Look at Him F",
            "latsasm",
            AnimationOptions = {
                EmoteMoving = false,
                EmoteLoop = true,
            }
        },
        ["latsasm"] = {
            "lookathim@sasdragonxbablo@animation",
            "latsasm_clip",
            "Look at Him M",
            "latsas",
            AnimationOptions = {
                EmoteMoving = false,
                EmoteLoop = true,
                Attachto = true,
                xPos = 0.525149,
                yPos = 0.0,
                zPos = 0.0,
                xRot = 0.0,
                yRot = 0.0,
                zRot = 0.0,
            }
        },

        ["shssas"] = {
            "shouldersit@sasdragonxbablo@animation",
            "shssas_clip",
            "Shoulder Sit F",
            "shssasm",
            AnimationOptions = {
                EmoteMoving = false,
                EmoteLoop = true,
            }
        },
        ["shssasm"] = {
            "shouldersit@sasdragonxbablo@animation",
            "shssasm_clip",
            "Shoulder Sit M",
            "shssas",
            AnimationOptions = {
                EmoteMoving = false,
                EmoteLoop = true,
                Attachto = true,
                xPos = -0.443024,
                yPos = 0.014,
                zPos = 0.0,
                xRot = 0.0,
                yRot = 0.0,
                zRot = 0.0,
            }
        },

        ["gpsas"] = {
            "goofyplank@sasdragonxbablo@animation",
            "gpsas_clip",
            "Goofy Plank F",
            "gpsasm",
            AnimationOptions = {
                EmoteMoving = false,
                EmoteLoop = true,
            }
        },
        ["gpsasm"] = {
            "goofyplank@sasdragonxbablo@animation",
            "gpsasm_clip",
            "Goofy Plank M",
            "gpsas",
            AnimationOptions = {
                EmoteMoving = false,
                EmoteLoop = true,
                Attachto = true,
                xPos = -0.285735,
                yPos = -0.704881,
                zPos = 0.0,
                xRot = 0.0,
                yRot = 0.0,
                zRot = 0.0,
            }
        },

        ["letslsas"] = {
            "letslay@sasdragonxbablo@animation",
            "letslsas_clip",
            "Lets Lay F",
            "letslsasm",
            AnimationOptions = {
                EmoteMoving = false,
                EmoteLoop = true,
            }
        },
        ["letslsasm"] = {
            "letslay@sasdragonxbablo@animation",
            "letslsasm_clip",
            "Lets Lay M",
            "letslsas",
            AnimationOptions = {
                EmoteMoving = false,
                EmoteLoop = true,
                Attachto = true,
                xPos = 0.0,
                yPos = 0.0,
                zPos = 0.0,
                xRot = 0.0,
                yRot = 0.0,
                zRot = 180.0,
            }
        },

        ["couchcsas"] = {
            "couchcouple@sasdragonxbablo@animation",
            "couchcsas_clip",
            "Couch Couple F",
            "couchcsasm",
            AnimationOptions = {
                EmoteMoving = false,
                EmoteLoop = true,
            }
        },
        ["couchcsasm"] = {
            "couchcouple@sasdragonxbablo@animation",
            "couchcsasm_clip",
            "Couch Couple M",
            "couchcsas",
            AnimationOptions = {
                EmoteMoving = false,
                EmoteLoop = true,
                Attachto = true,
                xPos = 0.562083,
                yPos = -0.332175,
                zPos = 0.0,
                xRot = 0.0,
                yRot = 0.0,
                zRot = 0.0,
            }
        },

        ["iylapsas"] = {
            "inyourlap@sasdragonxbablo@animation",
            "iylapsas_clip",
            "In Your Lap F",
            "iylapsasm",
            AnimationOptions = {
                EmoteMoving = false,
                EmoteLoop = true,
            }
        },
        ["iylapsasm"] = {
            "inyourlap@sasdragonxbablo@animation",
            "iylapsasm_clip",
            "In Your Lap M",
            "iylapsas",
            AnimationOptions = {
                EmoteMoving = false,
                EmoteLoop = true,
                Attachto = true,
                xPos = 0.0,
                yPos = 0.0,
                zPos = 0.0,
                xRot = 0.0,
                yRot = 0.0,
                zRot = 286.252,
            }
        },

        ["linysas"] = {
            "lostinyyou@sasdragonxbablo@animation",
            "linysas_clip",
            "Lost In You F",
            "linysasm",
            AnimationOptions = {
                EmoteMoving = false,
                EmoteLoop = true,
            }
        },
        ["linysasm"] = {
            "lostinyyou@sasdragonxbablo@animation",
            "linysasm_clip",
            "Lost In You M",
            "linysas",
            AnimationOptions = {
                EmoteMoving = false,
                EmoteLoop = true,
                Attachto = true,
                xPos = 0.0,
                yPos = -0.570852,
                zPos = 0.0,
                xRot = 0.0,
                yRot = 0.0,
                zRot = 180.0,
            }
        },

        ["ccsas2"] = {
            "couchcouplell@sasdragonxbablo@animation",
            "ccsasii_clip",
            "Couch Couple 2 F",
            "ccsas2m",
            AnimationOptions = {
                EmoteMoving = false,
                EmoteLoop = true,
            }
        },
        ["ccsas2m"] = {
            "couchcouplell@sasdragonxbablo@animation",
            "ccsasiim_clip",
            "Couch Couple 2 M",
            "ccsas2",
            AnimationOptions = {
                EmoteMoving = false,
                EmoteLoop = true,
                Attachto = true,
                xPos = -0.477062,
                yPos = -0.447345,
                zPos = 0.0,
                xRot = 0.0,
                yRot = 0.0,
                zRot = 270.0,
            }
        },

        ["phusas"] = {
            "pickherupcarry@sasdragonxbablo@animation",
            "phucsas_clip",
            "Pick Her UpF",
            "phusasm",
            AnimationOptions = {
                EmoteLoop = true,
            }
        },
        ["phusasm"] = {
            "pickherupcarry@sasdragonxbablo@animation",
            "phucsasm_clip",
            "Pick Her Up M",
            "phusas",
            AnimationOptions = {
                EmoteMoving = false,
                EmoteLoop = true,
                Attachto = true,
                xPos = -0.237809,
                yPos = 0.0,
                zPos = 0.0,
                xRot = 0.0,
                yRot = 0.0,
                zRot = 0.0,
            }
        },

        ["spsas"] = {
            "spoiledprincess@sasdragonxbablo@animation",
            "spsas_clip",
            "Spoiled Princess F",
            "spsasm",
            animationOptions = {
                emoteMoving = false,
                emoteLoop = true
            }
        },
        ["spsasm"] = {
            "spoiledprincess@sasdragonxbablo@animation",
            "spsasm_clip",
            "Spoiled Princess M",
            "spsas",
            animationOptions = {
                emoteMoving = false,
                emoteLoop = true,
                attachTo = true,
                xPos = 0.200871,
                yPos = 0.136111,
                zPos = 0.0,
                xRot = 0.0,
                yRot = 0.0,
                zRot = 0.0,
            }
        },


        ["cuddlecmsas"] = {
            "cuddlecarry@sasdragonslabxbablo@animation",
            "sdlcuddlecm_clip",
            "CuddleC M",
            "cuddlecfsas",
            AnimationOptions = {
                EmoteMoving = true,
                EmoteLoop = true,
            }
        },
        ["cuddlecfsas"] = {
            "cuddlecarry@sasdragonslabxbablo@animation",
            "sdlcuddlecf_clip",
            "CuddleC F",
            "cuddlecmsas",
            AnimationOptions = {
                EmoteMoving = false,
                EmoteLoop = true,
                Attachto = true,
                bone = 24818,
                xPos = -0.3100,
                yPos = 0.0100,
                zPos = 0.1900,
                xRot = 0.0,
                yRot = 81.0,
                zRot = 0.0,
            }
        },

        -- overshoulder carry

        ["oscmsas"] = {
            "overshouldercarry@sasdragonslabxbablo@animation",
            "sdlovscm_clip",
            "Over Shoulder Carry M",
            "oscfsas",
            AnimationOptions = {
                EmoteMoving = true,
                EmoteLoop = true,
            }
        },
        ["oscfsas"] = {
            "overshouldercarry@sasdragonslabxbablo@animation",
            "sdlovscf_clip",
            "Over Shoulder Carry F",
            "oscmsas",
            AnimationOptions = {
                EmoteMoving = false,
                EmoteLoop = true,
                Attachto = true,
                bone = 24818,
                xPos = -0.3300,
                yPos = -0.2300,
                zPos = 0.0000,
                xRot = 0.0,
                yRot = 90.0,
                zRot = 0.0,
            }
        },
        -- onwards carry

        ["onwcmsas"] = {
            "onwardscarry@sasdragonslabxbablo@animation",
            "sdlonwcm_clip",
            "Onwards Carry M",
            "onwfsas",
            AnimationOptions = {
                EmoteMoving = true,
                EmoteLoop = true,
            }
        },
        ["onwfsas"] = {
            "onwardscarry@sasdragonslabxbablo@animation",
            "sdlonwcf_clip",
            "Onwards Carry F",
            "onwcmsas",
            AnimationOptions = {
                EmoteMoving = false,
                EmoteLoop = true,
                Attachto = true,
                bone = 24818,
                xPos = -0.3100,
                yPos = -0.1100,
                zPos = 0.0100,
                xRot = 0.0,
                yRot = 90.0,
                zRot = 0.0,
            }
        },

        -- princesscuddle carry

        ["pccmsas"] = {
            "princesscuddlecarry@sasdragonslabxbablo@animation",
            "sdlpccm_clip",
            "Princess Cuddle Carry M",
            "pccfsas",
            AnimationOptions = {
                EmoteMoving = true,
                EmoteLoop = true,
            }
        },
        ["pccfsas"] = {
            "princesscuddlecarry@sasdragonslabxbablo@animation",
            "sdlpccf_clip",
            "Princess Cuddle Carry F",
            "pccmsas",
            AnimationOptions = {
                EmoteMoving = false,
                EmoteLoop = true,
                Attachto = true,
                bone = 24818,
                xPos = -0.2700,
                yPos = 0.2500,
                zPos = -0.0100,
                xRot = 0.0,
                yRot = 90.0,
                zRot = 0.0,
            }
        },

        -- float carry

        ["flcmsas"] = {
            "floatingcarry@sasdragonslabxbablo@animation",
            "sdlflcm_clip",
            "Floating Carry M",
            "flcfsas",
            AnimationOptions = {
                EmoteMoving = true,
                EmoteLoop = true,
            }
        },
        ["flcfsas"] = {
            "floatingcarry@sasdragonslabxbablo@animation",
            "sdlflcf_clip",
            "Floating Carry F",
            "flcmsas",
            AnimationOptions = {
                EmoteMoving = false,
                EmoteLoop = true,
                Attachto = true,
                bone = 24818,
                xPos = -0.2400,
                yPos = -0.2000,
                zPos = 0.0000,
                xRot = 0.0,
                yRot = 90.0,
                zRot = 0.0,
            }
        },

        ---------------------------------------------------------------------------------------------------------------------
        -- kneelingkiss

        ["kneelkisssas"] = {
            "kneelingkiss@sasdragonslabxbablo@animation",
            "sdlkneelkissf_clip",
            "Kneel Kiss F",
            "kneelkisssasm",
            AnimationOptions = {
                EmoteMoving = false,
                EmoteLoop = true,
            }
        },
        ["kneelkisssasm"] = {
            "kneelingkiss@sasdragonslabxbablo@animation",
            "sdlkneelkissM_clip",
            "Kneel Kiss M",
            "kneelkisssas",
            AnimationOptions = {
                EmoteMoving = false,
                EmoteLoop = true,
                Attachto = true,
                xPos = 0.0,
                yPos = 0.570287,
                zPos = 0.0,
                xRot = 0.0,
                yRot = 0.0,
                zRot = 0.0,
            }
        },

        -- straddlekiss

        ["sksasf"] = {
            "straddlekiss@sasdragonslabxbablo@animation",
            "sksasf_clip",
            "Straddle Kiss F",
            "sksasm",
            AnimationOptions = {
                EmoteMoving = false,
                EmoteLoop = true,
            }
        },
        ["sksasm"] = {
            "straddlekiss@sasdragonslabxbablo@animation",
            "sksasm_clip",
            "Straddle Kiss M",
            "sksasf",
            AnimationOptions = {
                EmoteMoving = false,
                EmoteLoop = true,
                Attachto = true,
                xPos = 0.0,
                yPos = 0.0,
                zPos = 0.0,
                xRot = 0.0,
                yRot = 0.0,
                zRot = 0.0,
            }
        },

        -- lapkiss

        ["lksasf"] = {
            "lapkiss@sasdragonslabxbablo@animation",
            "lksasf_clip",
            "Lap Kiss F",
            "lksasm",
            AnimationOptions = {
                EmoteMoving = false,
                EmoteLoop = true,
            }
        },
        ["lksasm"] = {
            "lapkiss@sasdragonslabxbablo@animation",
            "lksasm_clip",
            "Lap Kiss M",
            "lksasf",
            AnimationOptions = {
                EmoteMoving = false,
                EmoteLoop = true,
                Attachto = true,
                xPos = 0.0,
                yPos = 0.0,
                zPos = 0.0,
                xRot = 0.0,
                yRot = 0.0,
                zRot = 0.0,
            }
        },

        -- highsitkiss

        ["hsksasf"] = {
            "highsitkiss@sasdragonslabxbablo@animation",
            "hsksasf_clip",
            "HighSit Kiss F",
            "hsksasm",
            AnimationOptions = {
                EmoteMoving = false,
                EmoteLoop = true,
            }
        },
        ["hsksasm"] = {
            "highsitkiss@sasdragonslabxbablo@animation",
            "hsksasm_clip",
            "HighSit Kiss M",
            "hsksasf",
            AnimationOptions = {
                EmoteMoving = false,
                EmoteLoop = true,
                Attachto = true,
                xPos = 0.0,
                yPos = -0.21165,
                zPos = 0.0,
                xRot = 0.0,
                yRot = 0.0,
                zRot = 0.0,
            }
        },

        -- tabletopkiss

        ["ttsasf"] = {
            "tabletopkiss@sasdragonslabxbablo@animation",
            "ttsasf_clip",
            "TableTop Kiss F",
            "ttsasm",
            AnimationOptions = {
                EmoteMoving = false,
                EmoteLoop = true,
            }
        },
        ["ttsasm"] = {
            "tabletopkiss@sasdragonslabxbablo@animation",
            "ttsasm_clip",
            "TableTop Kiss M",
            "ttsasf",
            AnimationOptions = {
                EmoteMoving = false,
                EmoteLoop = true,
                Attachto = true,
                xPos = 0.0,
                yPos = 0.0,
                zPos = 0.0,
                xRot = 0.0,
                yRot = 0.0,
                zRot = 0.0,
            }
        },

        -- floorkiss

        ["fksasf"] = {
            "floorkiss@sasdragonslabxbablo@animation",
            "fksasf_clip",
            "Floor Kiss F",
            "fksasm",
            AnimationOptions = {
                EmoteMoving = false,
                EmoteLoop = true,
            }
        },
        ["fksasm"] = {
            "floorkiss@sasdragonslabxbablo@animation",
            "fksasm_clip",
            "Floor Kiss M",
            "fksasf",
            AnimationOptions = {
                EmoteMoving = false,
                EmoteLoop = true,
                Attachto = true,
                xPos = 0.0,
                yPos = 0.0,
                zPos = 0.0,
                xRot = 0.0,
                yRot = 0.0,
                zRot = 0.0,
            }
        },

        -- chinkiss

        ["cksasf"] = {
            "chinkiss@sasdragonslabxbablo@animation",
            "cksasf_clip",
            "Chin Kiss F",
            "cksasm",
            AnimationOptions = {
                EmoteMoving = false,
                EmoteLoop = true,
            }
        },
        ["cksasm"] = {
            "chinkiss@sasdragonslabxbablo@animation",
            "cksasm_clip",
            "Chin Kiss M",
            "cksasf",
            AnimationOptions = {
                EmoteMoving = false,
                EmoteLoop = true,
                Attachto = true,
                xPos = 0.0,
                yPos = -0.276884,
                zPos = 0.0,
                xRot = 0.0,
                yRot = 0.0,
                zRot = 0.0,
            }
        },

        -- neckkissesb

        ["nkbsasf"] = {
            "neckkissesb@sasdragonslabxbablo@animation",
            "nkbsasf_clip",
            "Neck Kissesb F",
            "nkbsasm",
            AnimationOptions = {
                EmoteMoving = false,
                EmoteLoop = true,
            }
        },
        ["nkbsasm"] = {
            "neckkissesb@sasdragonslabxbablo@animation",
            "nkbsasm_clip",
            "Neck Kissesb M",
            "nkbsasf",
            AnimationOptions = {
                EmoteMoving = false,
                EmoteLoop = true,
                Attachto = true,
                xPos = 0.0,
                yPos = -0.191081,
                zPos = 0.0,
                xRot = 0.0,
                yRot = 0.0,
                zRot = 0.0,
            }
        },

        -- neckbendkiss

        ["nbkisasf"] = {
            "neckbendkiss@sasdragonslabxbablo@animation",
            "nbkisasf_clip",
            "NeckBendKiss F",
            "nbkisasm",
            AnimationOptions = {
                EmoteMoving = false,
                EmoteLoop = true,
            }
        },
        ["nbkisasm"] = {
            "neckbendkiss@sasdragonslabxbablo@animation",
            "nbkisasm_clip",
            "NeckBendKiss M",
            "nbkisasf",
            AnimationOptions = {
                EmoteMoving = false,
                EmoteLoop = true,
                Attachto = true,
                xPos = 0.0,
                yPos = -0.386509,
                zPos = 0.0,
                xRot = 0.0,
                yRot = 0.0,
                zRot = 0.0,
            }
        },

        -- sitkneelkissb

        ["skkbsasf"] = {
            "sitkneelkissb@sasdragonslabxbablo@animation",
            "skkbsasf_clip",
            "SitKneelKiss F",
            "skkbsasm",
            AnimationOptions = {
                EmoteMoving = false,
                EmoteLoop = true,
            }
        },
        ["skkbsasm"] = {
            "sitkneelkissb@sasdragonslabxbablo@animation",
            "skkbsasm_clip",
            "SitKneelKiss M",
            "skkbsasf",
            AnimationOptions = {
                EmoteMoving = false,
                EmoteLoop = true,
                Attachto = true,
                xPos = 0.429891,
                yPos = 0.0,
                zPos = 0.0,
                xRot = 0.0,
                yRot = 0.0,
                zRot = 0.0,
            }
        },
    },
}
