Config = Config or {}
Config.ShellModels = {
    -- This is a list of shell models by category, is used for the admin panel > shells and when u modify a gang property :))
    -- value is the shell model (make sure is a valid model)
    ['labs'] = {
        {value = 'k4mb1_acid2_shell', label = 'Acid Shell', preview = "https://r2.fivemanage.com/QmVAYSlqeAlD4IxVbdvu5/acid.jpg"},
        {value = 'k4weed_shell', label = 'Weed Shell', preview = "https://dunb17ur4ymx4.cloudfront.net/wysiwyg/1027823/a3e2807967ae87239c24c7d1686384bd80c4b37b.jpg"},
        {value = 'k4meth_shell', label = 'Meth Shell', preview = "https://dunb17ur4ymx4.cloudfront.net/wysiwyg/1027823/2776d84ac66023cb1f1366b246f5bb45078c73da.jpg"},
        {value = 'k4coke_shell', label = 'Coke Shell', preview = "https://dunb17ur4ymx4.cloudfront.net/wysiwyg/1027823/81867d88cc5c076fe39676fcb1e836de30301912.jpg"},
        {value = 'k4mb1_laundry_shell', label = 'Laundry Shell', preview = "https://r2.fivemanage.com/QmVAYSlqeAlD4IxVbdvu5/laundromat.png"},
    },
    ['offices'] = {
        {value = "k4mb1_furnishedoffice1_shell", label = "Office 1", preview = "https://dunb17ur4ymx4.cloudfront.net/wysiwyg/1027823/3c65f6fddb48aba7b2a2356d465ee7ba30aa819e.jpg"},
        {value = "k4mb1_furnishedoffice2_shell", label = "Office 2", preview = "https://dunb17ur4ymx4.cloudfront.net/wysiwyg/1027823/0d983bf42c2d454b2a7b06264a923ca790c04bb8.jpg"},
        {value = "k4mb1_furnishedoffice4_shell", label = "Office 3", preview = "https://dunb17ur4ymx4.cloudfront.net/wysiwyg/1027823/255068e8e47468f60725f7cc17749b6c3b8b1499.jpg"},
        {value = "k4mb1_furnishedoffice5_shell", label = "Office 4", preview = "https://dunb17ur4ymx4.cloudfront.net/wysiwyg/1027823/982586ea46febfd68fa59ab66df266b346c1f537.jpg"},
    },
    ['warehouse'] = {
        {value = "container2_shell", label = "Container", preview = "https://dunb17ur4ymx4.cloudfront.net/wysiwyg/1027823/156c04ac052c92914eaad5de5c0af6b190e3be2f.jpg"},
        {value = "stashhouse3_shell", label = "Small Warehouse", preview = "https://dunb17ur4ymx4.cloudfront.net/wysiwyg/1027823/667f243c847f4dc45672ecfc760c6c09c9f647f6.jpg"},
        {value = "stashhouse1_shell", label = "Big Warehouse", preview = "https://dunb17ur4ymx4.cloudfront.net/wysiwyg/1027823/4799957bdce82616dec7ad77b9987d10bb11157d.jpg"},
    },
}

-- List of animations used for Shells Manager > Peds
-- For a list (and preview) of animations u can visit: https://forge.plebmasters.de/animations/
Config.ShellAnimations = {
    {dict = "anim@amb@board_room@diagram_blueprints@", animation = "idle_01_amy_skater_01", label = "Table idle"},
    {dict = "mp_fbi_heist", animation = "loop", label = "keyboard loop"},
    {dict = "amb@prop_human_movie_bulb@idle_a", animation = "idle_b", label = "High Harvest"},
    {dict = 'amb@prop_human_bum_shopping_cart@male@idle_a', animation = 'idle_c', label ="Shopping cart"},
    {dict = 'anim@amb@business@cfm@cfm_cut_sheets@', animation = 'load_guillotine_billcutter', label = "Load Guillotine"},
    {dict = 'anim@amb@business@coc@coc_unpack_cut@', animation = 'fullcut_cycle_v3_cokepacker', label = "Coke Packaging v3"},
    {dict = 'anim@amb@business@coc@coc_unpack_cut@', animation = 'fullcut_cycle_v6_cokepacker', label = "Coke Packaging v6"},
    {dict = 'anim@amb@business@coc@coc_unpack_cut@', animation = 'fullcut_cycle_v7_cokepacker', label = "Coke Packaging v7"},
}

-- List of ped models for Shells Manager > Ped
-- Ped list: https://docs.fivem.net/docs/game-references/ped-models/
Config.ShellPeds = {
    {model = 's_m_m_scientist_01', label = 'Scientist 01'},
    {model = 'mp_f_weed_01', label = 'MP F Weed'},
    {model = 'mp_m_weed_01', label = 'MP M Weed'},
    {model = 'mp_f_meth_01', label = 'MP F Meth'},
    {model = 'mp_m_meth_01', label = 'MP M Meth'},
    {model = 'mp_f_cocaine_01', label = 'MP F Cocaine'},
    {model = 'mp_m_cocaine_01', label = 'MP M Cocaine'},
    {model = 'g_m_m_chicold_01', label = 'Mask Ped'},
}

-- List of events for Shells Manager > Zones
-- Only client side events
Config.ShellEvents = {
    { value = "av_gangs:ingredients", label = "Lab Ingredients" },
    { value = "av_gangs:product", label = "Lab Product" },
    { value = "av_gangs:stash", label = "Stash" },
}