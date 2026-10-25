Config.Shared = {
    {
        category = "shared",
        type = "shared",
        name = "slapsomeone",
        label = "Slap",
        requester = {
            lib = "melee@unarmed@streamed_variations",
            animation = "victim_takedown_front_slap",
            flag = 2,
            ragdoll = true
        },
        accepter = {
            lib = "melee@unarmed@streamed_variations",
            animation = "plyr_takedown_front_slap",
            label = "",
            skip = true,
            flag = 11,
            attach = {
                bone = 9816,
                xPosition = 0.0,
                yPosition = 1.0,
                zPosition = 0.0,
                xRotation = 0.0,
                yRotation = 0.0,
                zRotation = 180.0,
            }
        }
    },
    {
        category = "shared",
        type = "shared",
        name = "headbuttsomeone",
        label = "Headbutt",
        requester = {
            lib = "melee@unarmed@streamed_variations",
            animation = "victim_takedown_front_headbutt",
            flag = 2,
            ragdoll = true
        },
        accepter = {
            lib = "melee@unarmed@streamed_variations",
            animation = "plyr_takedown_front_headbutt",
            label = "",
            skip = false,
            flag = 11,
            attach = {
                bone = 9816,
                xPosition = 0.0,
                yPosition = 1.0,
                zPosition = 0.0,
                xRotation = 0.0,
                yRotation = 0.0,
                zRotation = 180.0,
            }
        }
    },
    {
        category = "shared",
        type = "shared",
        name = "givehug",
        label = "Hug",
        requester = {
            lib = "mp_ped_interaction",
            animation = "kisses_guy_a",
            flag = 0,
            ragdoll = false
        },
        accepter = {
            lib = "mp_ped_interaction",
            animation = "kisses_guy_b",
            label = "Hug the person",
            skip = false,
            flag = 0,
            attach = {
                bone = 9816,
                xPosition = 0.05,
                yPosition = 1.15,
                zPosition = -0.05,
                xRotation = 0.0,
                yRotation = 0.0,
                zRotation = 180.0,
            }
        }
    },

    {
        category = "shared",
        type = "shared",
        name = "highfive",
        label = "High five",
        requester = {
            lib = "mp_ped_interaction",
            animation = "highfive_guy_a",
            flag = 0
        },
        accepter = {
            lib = "mp_ped_interaction",
            animation = "highfive_guy_b",
            label = "Do a high five with the person",
            flag = 0,
            attach = {
                bone = 9816,
                xPosition = -0.5,
                yPosition = 1.25,
                zPosition = 0.0,
                xRotation = 0.9,
                yRotation = 0.3,
                zRotation = 180.0,
            }
        }
    },

    {
        category = "shared",
        type = "shared",
        name = "brotherlyhug",
        label = "Brotherly Hug",
        requester = {
            lib = "mp_ped_interaction",
            animation = "hugs_guy_a",
            flag = 0
        },
        accepter = {
            lib = "mp_ped_interaction",
            animation = "hugs_guy_b",
            label = "Do a brotherly hug with the person",
            flag = 0,
            attach = {
                bone = 9816,
                xPosition = -0.025,
                yPosition = 1.15,
                zPosition = 0.0,
                xRotation = 0.0,
                yRotation = 0.0,
                zRotation = 180.0,
            }
        }
    },
    {
        category = "shared",
        type = "shared",
        name = "fistbump",
        label = "Fistbump",
        requester = {
            lib = "anim@mp_player_intcelebrationpaired@f_f_fist_bump",
            animation = "fist_bump_left",
            flag = 0
        },
        accepter = {
            lib = "anim@mp_player_intcelebrationpaired@f_f_fist_bump",
            animation = "fist_bump_right",
            label = "Fistbump with the person",
            flag = 0,
            attach = {
                bone = 9816,
                xPosition = -0.6,
                yPosition = 0.9,
                zPosition = 0.0,
                xRotation = 0.0,
                yRotation = 0.0,
                zRotation = 270.0,
            }
        }
    },

    {
        category = "shared",
        type = "shared",
        name = "handshakesomeone",
        label = "Shake Hand",
        requester = {
            lib = "mp_ped_interaction",
            animation = "handshake_guy_a",
            flag = 0
        },
        accepter = {
            lib = "mp_ped_interaction",
            animation = "handshake_guy_b",
            label = "Shake hand with the person",
            flag = 0,
            attach = {
                bone = 9816,
                xPosition = 0.0,
                yPosition = 1.2,
                zPosition = 0.0,
                xRotation = 0.0,
                yRotation = 0.0,
                zRotation = 180.0,
            }
        }
    },
    {
        category = "shared",
        type = "shared",
        name = "formalhandshake",
        label = "Shake Hand (Formal)",
        requester = {
            lib = "mp_common",
            animation = "givetake1_a",
            flag = 0
        },
        accepter = {
            lib = "mp_common",
            animation = "givetake1_b",
            label = "Shake hand with the person",
            flag = 0,
            attach = {
                bone = 9816,
                xPosition = 0.075,
                yPosition = 1.0,
                zPosition = 0.0,
                xRotation = 0.0,
                yRotation = 0.0,
                zRotation = 180.0,
            }
        }
    },
}
