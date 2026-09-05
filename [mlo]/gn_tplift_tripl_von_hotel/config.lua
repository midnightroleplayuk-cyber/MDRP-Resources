ELEVATOR_MENU_TITLE = "Elevator"
ELEVATOR_MENU_DESCRIPTION = "The world fastest elevator!"
MARKER_NOTIFICATION = "Press ~INPUT_CONTEXT~ to access ~b~elevator menu"

ZONES = {
    --Little Soul B1--
    ['lts_b1_lobby'] = {
        label = "Lobby",
        coords = vec4(-658.6233, -1110.5697, 15.0633, 65.7738),
        interactDistance = 1.5,
        renderDistance = 5.0,
        directions = {
            'lts_b1_f1',
            'lts_b1_f2',
            'lts_b1_f3',
            'lts_b1_f4',
            'lts_b1_f5',
            'lts_b1_f6'
        }
    },
    ['lts_b1_f1'] = {
        label = "Floor 1",
        coords = vec4(-655.2101, -1110.6490, 21.8344, 65.7468),
        interactDistance = 1.5,
        renderDistance = 5.0,
        directions = {
            'lts_b1_lobby',
            'lts_b1_f2',
            'lts_b1_f3',
            'lts_b1_f4',
            'lts_b1_f5',
            'lts_b1_f6'
        }
    },
    ['lts_b1_f2'] = {
        label = "Floor 2",
        coords = vec4(-655.7173, -1110.5150, 26.6028, 64.3021),
        interactDistance = 1.5,
        renderDistance = 5.0,
        directions = {
            'lts_b1_lobby',
            'lts_b1_f1',
            'lts_b1_f3',
            'lts_b1_f4',
            'lts_b1_f5',
            'lts_b1_f6'
        }
    },
    ['lts_b1_f3'] = {
        label = "Floor 3",
        coords = vec4(-655.5388, -1110.5977, 31.3720, 65.2601),
        interactDistance = 1.5,
        renderDistance = 5.0,
        directions = {
            'lts_b1_lobby',
            'lts_b1_f1',
            'lts_b1_f2',
            'lts_b1_f4',
            'lts_b1_f5',
            'lts_b1_f6'
        }
    },
    ['lts_b1_f4'] = {
        label = "Floor 4",
        coords = vec4(-655.7173, -1110.5150, 36.1360, 68.2547),
        interactDistance = 1.5,
        renderDistance = 5.0,
        directions = {
            'lts_b1_lobby',
            'lts_b1_f1',
            'lts_b1_f2',
            'lts_b1_f3',
            'lts_b1_f5',
            'lts_b1_f6'
        }
    },
    ['lts_b1_f5'] = {
        label = "Floor 5",
        coords = vec4(-655.7173, -1110.5150, 40.9058, 63.5000),
        interactDistance = 1.5,
        renderDistance = 5.0,
        directions = {
            'lts_b1_lobby',
            'lts_b1_f1',
            'lts_b1_f2',
            'lts_b1_f3',
            'lts_b1_f4',
            'lts_b1_f6'
        }
    },
    ['lts_b1_f6'] = {
        label = "Floor 6",
        coords = vec4(-655.7173, -1110.5150, 45.6744, 71.3211),
        interactDistance = 1.5,
        renderDistance = 5.0,
        directions = {
            'lts_b1_lobby',
            'lts_b1_f1',
            'lts_b1_f2',
            'lts_b1_f3',
            'lts_b1_f4',
            'lts_b1_f5'
        }
    },
    --Little Soul B2--
    ['lts_b2_lobby'] = {
        label = "Lobby",
        coords = vec4(-680.2057, -1127.1042, 12.3536, 335.0984),
        interactDistance = 1.5,
        renderDistance = 5.0,
        directions = {
            'lts_b2_f1',
            'lts_b2_f2',
            'lts_b2_f3',
            'lts_b2_f4',
            'lts_b2_f5',
            'lts_b2_f6'
        }
    },
    ['lts_b2_f1'] = {
        label = "Floor 1",
        coords = vec4(-680.1530, -1130.2096, 19.12, 331.6523),
        interactDistance = 1.5,
        renderDistance = 5.0,
        directions = {
            'lts_b2_lobby',
            'lts_b2_f2',
            'lts_b2_f3',
            'lts_b2_f4',
            'lts_b2_f5',
            'lts_b2_f6'
        }
    },
    ['lts_b2_f2'] = {
        label = "Floor 2",
        coords = vec4(-680.1530, -1130.2096, 23.8995, 331.6523),
        interactDistance = 1.5,
        renderDistance = 5.0,
        directions = {
            'lts_b2_lobby',
            'lts_b2_f1',
            'lts_b2_f3',
            'lts_b2_f4',
            'lts_b2_f5',
            'lts_b2_f6'
        }
    },
    ['lts_b2_f3'] = {
        label = "Floor 3",
        coords = vec4(-680.1530, -1130.2097, 28.6598, 331.7902),
        interactDistance = 1.5,
        renderDistance = 5.0,
        directions = {
            'lts_b2_lobby',
            'lts_b2_f1',
            'lts_b2_f2',
            'lts_b2_f4',
            'lts_b2_f5',
            'lts_b2_f6'
        }
    },
    ['lts_b2_f4'] = {
        label = "Floor 4",
        coords = vec4(-680.1763, -1130.2544, 33.4311, 331.0419),
        interactDistance = 1.5,
        renderDistance = 5.0,
        directions = {
            'lts_b2_lobby',
            'lts_b2_f1',
            'lts_b2_f2',
            'lts_b2_f3',
            'lts_b2_f5',
            'lts_b2_f6'
        }
    },
    ['lts_b2_f5'] = {
        label = "Floor 5",
        coords = vec4(-680.1929, -1130.2889, 38.2022, 331.7857),
        interactDistance = 1.5,
        renderDistance = 5.0,
        directions = {
            'lts_b2_lobby',
            'lts_b2_f1',
            'lts_b2_f2',
            'lts_b2_f3',
            'lts_b2_f4',
            'lts_b2_f6'
        }
    },
    ['lts_b2_f6'] = {
        label = "Floor 6",
        coords = vec4(-680.2668, -1130.4414, 42.9706, 332.0739),
        interactDistance = 1.5,
        renderDistance = 5.0,
        directions = {
            'lts_b2_lobby',
            'lts_b2_f1',
            'lts_b2_f2',
            'lts_b2_f3',
            'lts_b2_f4',
            'lts_b2_f5'
        }
    },
    --DelPerro--
    ['delperro_lobby'] = {
        label = "Lobby",
        coords = vec4(-1540.6304, -539.0617, 36.1562, 32.2984),
        interactDistance = 1.5,
        renderDistance = 5.0,
        directions = {
            'delperro_f1',
            'delperro_f2',
            'delperro_f3',
            'delperro_f4',
            'delperro_f5',
            'delperro_f6'
        }
    },
    ['delperro_f1'] = {
        label = "Floor 1",
        coords = vec4(-1537.7495, -541.0699, 42.9286, 30.1595),
        interactDistance = 1.5,
        renderDistance = 5.0,
        directions = {
            'delperro_lobby',
            'delperro_f2',
            'delperro_f3',
            'delperro_f4',
            'delperro_f5',
            'delperro_f6'
        }
    },
    ['delperro_f2'] = {
        label = "Floor 2",
        coords = vec4(-1537.7471, -541.0703, 47.6918, 44.0076),
        interactDistance = 1.5,
        renderDistance = 5.0,
        directions = {
            'delperro_lobby',
            'delperro_f1',
            'delperro_f3',
            'delperro_f4',
            'delperro_f5',
            'delperro_f6'
        }
    },
    ['delperro_f3'] = {
        label = "Floor 3",
        coords = vec4(-1537.7471, -541.0703, 52.4610, 33.1409),
        interactDistance = 1.5,
        renderDistance = 5.0,
        directions = {
            'delperro_lobby',
            'delperro_f1',
            'delperro_f2',
            'delperro_f4',
            'delperro_f5',
            'delperro_f6'
        }
    },
    ['delperro_f4'] = {
        label = "Floor 4",
        coords = vec4(-1537.7705, -541.0319, 57.2354, 32.3554),
        interactDistance = 1.5,
        renderDistance = 5.0,
        directions = {
            'delperro_lobby',
            'delperro_f1',
            'delperro_f2',
            'delperro_f3',
            'delperro_f5',
            'delperro_f6'
        }
    },
    ['delperro_f5'] = {
        label = "Floor 5",
        coords = vec4(-1537.8542, -540.9023, 62.0042, 35.8650),
        interactDistance = 1.5,
        renderDistance = 5.0,
        directions = {
            'delperro_lobby',
            'delperro_f1',
            'delperro_f2',
            'delperro_f3',
            'delperro_f4',
            'delperro_f6'
        }
    },
    ['delperro_f6'] = {
        label = "Floor 6",
        coords = vec4(-1537.8075, -541.0804, 66.7784, 33.9374),
        interactDistance = 1.5,
        renderDistance = 5.0,
        directions = {
            'delperro_lobby',
            'delperro_f1',
            'delperro_f2',
            'delperro_f3',
            'delperro_f4',
            'delperro_f5'
        }
    }
}