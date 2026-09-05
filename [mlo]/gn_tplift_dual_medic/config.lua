ELEVATOR_MENU_TITLE = "Elevator"
ELEVATOR_MENU_DESCRIPTION = "The world fastest elevator!"
MARKER_NOTIFICATION = "Press ~INPUT_CONTEXT~ to access ~b~elevator menu"

ZONES = {
    --Cls Medical Center--
    ['cls_mainfloor_01'] = {
        label = "Main floor",
        coords = vec4(348.3742, -1407.8934, 32.5106, 50.0029),
        interactDistance = 1.5,
        renderDistance = 5.0,
        directions = {
            'cls_upperfloor_01',
            'cls_helipad_01'
        }
    },
    ['cls_upperfloor_01'] = {
        label = "Upper floor",
        coords = vec4(348.3742, -1407.8934, 36.5160, 50.0029),
        interactDistance = 1.5,
        renderDistance = 5.0,
        directions = {
            'cls_mainfloor_01',
            'cls_helipad_01'
        }
    },
    ['cls_helipad_01'] = {
        label = "Helipad access (roof)",
        coords = vec4(340.0480, -1424.2227, 46.5092, 135.9567),
        interactDistance = 1.5,
        renderDistance = 5.0,
        directions = {
            'cls_mainfloor_01',
            'cls_upperfloor_01',
            'cls_corridor_01',
            'cls_corridorupper_01',
            'cls_garage_01'
        }
    },
    ['cls_mainfloor_02'] = {
        label = "Main floor",
        coords = vec4(346.0339, -1409.8420, 32.5105, 37.6612 ),
        interactDistance = 1.5,
        renderDistance = 5.0,
        directions = {
            'cls_upperfloor_02',
            'cls_helipad_02'
        }
    },
    ['cls_upperfloor_02'] = {
        label = "Upper floor",
        coords = vec4(346.0339, -1409.8420, 36.5160, 37.661),
        interactDistance = 1.5,
        renderDistance = 5.0,
        directions = {
            'cls_mainfloor_02',
            'cls_helipad_02'
        }
    },
    ['cls_helipad_02'] = {
        label = "Helipad access (roof)",
        coords = vec4(341.9863, -1425.9000, 46.5092, 137.7412),
        interactDistance = 1.5,
        renderDistance = 5.0,
        directions = {
            'cls_mainfloor_02',
            'cls_upperfloor_02',
            'cls_corridor_02',
            'cls_corridorupper_02',
            'cls_garage_02'
        }
    },
    ['cls_corridor_01'] = {
        label = "Main corridor floor",
        coords = vec4(367.5895, -1394.2286, 32.5106, 144.9694),
        interactDistance = 1.5,
        renderDistance = 5.0,
        directions = {
            'cls_corridorupper_01',
            'cls_helipad_01',
            'cls_garage_01'
        }
    },
    ['cls_corridorupper_01'] = {
        label = "Upper corridor floor",
        coords = vec4(367.5437, -1394.2816, 36.5163, 147.7407),
        interactDistance = 1.5,
        renderDistance = 5.0,
        directions = {
            'cls_corridor_01',
            'cls_helipad_01',
            'cls_garage_01'
        }
    },
    ['cls_corridor_02'] = {
        label = "Main corridor floor",
        coords = vec4(365.4745, -1392.3898, 32.5106, 135.1358),
        interactDistance = 1.5,
        renderDistance = 5.0,
        directions = {
            'cls_corridorupper_02',
            'cls_helipad_02';
            'cls_garage_02'
        }
    },
    ['cls_corridorupper_02'] = {
        label = "Upper corridor floor",
        coords = vec4(365.4745, -1392.3898, 36.5160, 135.1358),
        interactDistance = 1.5,
        renderDistance = 5.0,
        directions = {
            'cls_corridor_02',
            'cls_helipad_02',
            'cls_garage_02'
        }
    },
    ['cls_garage_02'] = {
        label = "Ambulance Garage",
        coords = vec4(319.5897, -1420.9695, 29.9190, 135.7127),
        interactDistance = 1.5,
        renderDistance = 5.0,
        directions = {
            'cls_mainfloor_02',
            'cls_upperfloor_02',
            'cls_helipad_02',
            'cls_corridor_02',
            'cls_corridorupper_02'
        }
    },
    ['cls_garage_01'] = {
        label = "Ambulance Garage",
        coords = vec4(322.7091, -1423.7128, 29.9190, 135.7127),
        interactDistance = 1.5,
        renderDistance = 5.0,
        directions = {
            'cls_mainfloor_01',
            'cls_upperfloor_01',
            'cls_helipad_01',
            'cls_corridor_01',
            'cls_corridorupper_01'
        }
    },
    --Pillbox Medical Center--
    ['pillbox_mainfloor_01'] = {
        label = "Main floor",
        coords = vec4(306.0391, -591.3965, 43.2710, 68.5739),
        interactDistance = 1.5,
        renderDistance = 5.0,
        directions = {
            'pillbox_upperfloor_01',
            'pillbox_helipad_01'
        }
    },
    ['pillbox_upperfloor_01'] = {
        label = "Upper floor",
        coords = vec4(306.0391, -591.3965, 47.2765, 68.5739),
        interactDistance = 1.5,
        renderDistance = 5.0,
        directions = {
            'pillbox_mainfloor_01',
            'pillbox_helipad_01'
        }
    },
    ['pillbox_helipad_01'] = {
        label = "Helipad access (roof)",
        coords = vec4(329.4629, -581.8510, 74.1804, 252.3860),
        interactDistance = 1.5,
        renderDistance = 5.0,
        directions = {
            'pillbox_mainfloor_01',
            'pillbox_upperfloor_01',
            'pillbox_corridor_01',
            'pillbox_corridorupper_01',
            'pillbox_garage_01'
        }
    },
    ['pillbox_mainfloor_02'] = {
        label = "Main floor",
        coords = vec4(305.3037, -594.1699, 43.2710, 65.4393),
        interactDistance = 1.5,
        renderDistance = 5.0,
        directions = {
            'pillbox_upperfloor_02',
            'pillbox_helipad_02'
        }
    },
    ['pillbox_upperfloor_02'] = {
        label = "Upper floor",
        coords = vec4(305.3037, -594.1699,  47.2765, 65.4393),
        interactDistance = 1.5,
        renderDistance = 5.0,
        directions = {
            'pillbox_mainfloor_02',
            'pillbox_helipad_02'
        }
    },
    ['pillbox_helipad_02'] = {
        label = "Helipad access (roof)",
        coords = vec4(330.5120, -579.1201, 74.1804, 254.2052),
        interactDistance = 1.5,
        renderDistance = 5.0,
        directions = {
            'pillbox_mainfloor_02',
            'pillbox_upperfloor_02',
            'pillbox_corridor_02',
            'pillbox_corridorupper_02',
            'pillbox_garage_02'
        }
    },
    ['pillbox_corridor_01'] = {
        label = "Main corridor floor",
        coords = vec4(317.2557, -571.3168, 43.2710, 159.6572),
        interactDistance = 1.5,
        renderDistance = 5.0,
        directions = {
            'pillbox_corridorupper_01',
            'pillbox_helipad_01',
            'pillbox_garage_01'
        }
    },
    ['pillbox_corridorupper_01'] = {
        label = "Upper corridor floor",
        coords = vec4(317.2557, -571.3168,  47.2765, 159.6572),
        interactDistance = 1.5,
        renderDistance = 5.0,
        directions = {
            'pillbox_corridor_01',
            'pillbox_helipad_01',
            'pillbox_garage_01'
        }
    },
    ['pillbox_corridor_02'] = {
        label = "Main corridor floor",
        coords = vec4(319.9084, -572.1806, 43.2710, 160.5744),
        interactDistance = 1.5,
        renderDistance = 5.0,
        directions = {
            'pillbox_corridorupper_02',
            'pillbox_helipad_02',
            'pillbox_garage_02'
        }
    },
    ['pillbox_corridorupper_02'] = {
        label = "Upper corridor floor",
        coords = vec4(319.9084, -572.1806,  47.2765, 160.5744),
        interactDistance = 1.5,
        renderDistance = 5.0,
        directions = {
            'pillbox_corridor_02',
            'pillbox_helipad_02',
            'pillbox_garage_02'
        }
    },
    ['pillbox_garage_02'] = {
        label = "Ambulance Garage",
        coords = vec4(326.7982, -578.6495, 28.7597, 345.4604),
        interactDistance = 1.5,
        renderDistance = 5.0,
        directions = {
            'pillbox_mainfloor_02',
            'pillbox_upperfloor_02',
            'pillbox_helipad_02',
            'pillbox_corridor_02',
            'pillbox_corridorupper_02'
        }
    },
    ['pillbox_garage_01'] = {
        label = "Ambulance Garage",
        coords = vec4(322.9979, -577.3111, 28.7597, 345.2372),
        interactDistance = 1.5,
        renderDistance = 5.0,
        directions = {
            'pillbox_mainfloor_01',
            'pillbox_upperfloor_01',
            'pillbox_helipad_01',
            'pillbox_corridor_01',
            'pillbox_corridorupper_01'
        }
    }
}