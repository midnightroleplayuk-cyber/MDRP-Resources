if not Config then Config = {} end

Config.RecommendedApps = { -- We have some pre-defined by us, you can also add more apps in here
    -- {
    --     appId = 'racing',
    --     bannerImage = 'https://upload.devhub.gg/dh_upload/laptop/appStore/racingBannerLaptop2.webp',
    -- },
}

Config.AppCategories = {
    ['system'] = { -- required [if removed system will add it]
        label = "System",
        order = 1,
    },
    ['premium'] = { -- required [if removed system will add it]
        label = "Premium",
        order = 99,
    },
    ['other'] = { -- required [if removed system will add it]
        label = "Other", 
        order = 100,
    },
}

Config.Apps = {
    ['cmd'] = {
        label = "CMD",
        img = "https://cfx-nui-devhub_laptop/html/images/apps/cmd.png",
        path = "app_cmd",
        category = "system",
        rating = 4,
        description = "Command Line Interface",
        longDescription = "A command line tool for executing system commands, running scripts, and performing administrative tasks directly from the terminal.",
        author = "DEVHUB",
        size = 122,
        downloads = 1000,
        class = 'regular',
        galleryImages = {
            'https://cfx-nui-devhub_laptop/html/images/appGallery/cmd.webp',
        },
        reviews = {
            {
                user = "TechUser123",
                rating = 5,
                comment = "Perfect command line tool! Very responsive and easy to use.",
                date = "2025-08-10"
            },
            {
                user = "DevMaster",
                rating = 4,
                comment = "Great for system administration tasks. Could use more features.",
                date = "2025-08-08"
            },
        },
    },
    ['calculator'] = {
        label = "Calculator",
        img = "https://cfx-nui-devhub_laptop/html/images/apps/calculator.png",
        path = "app_calculator",
        category = "system",
        rating = 5,
        description = "Basic Calculator, perform calculations",
        longDescription = "A simple yet reliable calculator for performing basic arithmetic operations quickly and efficiently.",
        author = "DEVHUB",
        size = 15,
        downloads = 1000,
        class = 'regular',
        galleryImages = {
            'https://cfx-nui-devhub_laptop/html/images/appGallery/calculator.webp',
        },
        reviews = {
            {
                user = "MathStudent",
                rating = 5,
                comment = "Simple and effective! Does exactly what I need for basic calculations.",
                date = "2025-08-11"
            },
            {
                user = "QuickCalc",
                rating = 5,
                comment = "Fast and accurate. Perfect for everyday use.",
                date = "2025-08-09"
            },
        },
    },
    ['notepad'] = {
        label = "Notepad",
        img = "https://cfx-nui-devhub_laptop/html/images/apps/notepad.png",
        path = "app_notepad",
        category = "system",
        rating = 5,
        description = "Text editor for writing and editing text files",
        longDescription = "A lightweight text editor designed for creating and editing plain text documents with ease.",
        author = "DEVHUB",
        size = 44,
        downloads = 1000,
        class = 'regular',
        galleryImages = {
            'https://cfx-nui-devhub_laptop/html/images/appGallery/notepad.webp',
        },
        reviews = {
            {
                user = "Writer2025",
                rating = 5,
                comment = "Perfect for taking notes and writing documents. Very lightweight!",
                date = "2025-08-12"
            },
            {
                user = "CodeEditor",
                rating = 5,
                comment = "Great text editor for quick edits. Clean and simple interface.",
                date = "2025-08-10"
            },
        },
    },
    ['browser'] = {
        label = "Browser",
        img = "https://cfx-nui-devhub_laptop/html/images/apps/browser.png",
        path = "app_browser",
        category = "system",
        rating = 5,
        description = "Web browser for browsing the internet",
        longDescription = "A fast and secure web browser for exploring websites, watching videos, and accessing online services.",
        author = "DEVHUB",
        size = 33,
        downloads = 1000,
        class = 'regular',
        fullScreen = true,
        galleryImages = {
            'https://cfx-nui-devhub_laptop/html/images/appGallery/browser_1.webp',
            'https://cfx-nui-devhub_laptop/html/images/appGallery/browser_2.webp',
        },
        reviews = {
            {
                user = "WebSurfer",
                rating = 5,
                comment = "Excellent browser! Fast loading and great security features.",
                date = "2025-08-13"
            },
            {
                user = "InternetUser",
                rating = 5,
                comment = "Very reliable and user-friendly. Love the clean interface.",
                date = "2025-08-11"
            },
        },
    },
    ['appStore'] = {
        label = "App Store",
        img = "https://cfx-nui-devhub_laptop/html/images/apps/appstore.png",
        path = "app_appStore",
        category = "system",
        rating = 5,
        description = "Browse and install applications",
        longDescription = "A central hub for discovering, downloading, and managing applications on your device.",
        author = "DEVHUB",
        size = 22,
        class = 'regular',
        downloads = 1000,
        galleryImages = {
            'https://cfx-nui-devhub_laptop/html/images/appGallery/appStore.webp',
        },
        dontAllowUninstall = true,
        reviews = {
            {
                user = "AppLover",
                rating = 5,
                comment = "Essential app for finding and installing new applications. Great selection!",
                date = "2025-08-12"
            },
            {
                user = "DigitalNomad",
                rating = 5,
                comment = "Easy to use and well organized. Makes app discovery simple.",
                date = "2025-08-10"
            },
        },
    },
    ['clock'] = {
        label = "Clock",
        img = "https://cfx-nui-devhub_laptop/html/images/apps/clock.png",
        path = "app_clock",
        category = "system",
        rating = 5,
        description = "Clock application to check the time",
        longDescription = "A clock utility that allows you to view the current time at your location and in different time zones.",
        author = "DEVHUB",
        size = 52,
        downloads = 1000,
        class = 'regular',
        galleryImages = {
            'https://cfx-nui-devhub_laptop/html/images/appGallery/clock.webp',
        },
        reviews = {
            {
                user = "TimeKeeper",
                rating = 5,
                comment = "Beautiful clock app with multiple time zones. Very useful!",
                date = "2025-08-13"
            },
            {
                user = "GlobalTraveler",
                rating = 5,
                comment = "Perfect for tracking time across different locations. Clean design.",
                date = "2025-08-11"
            },
        },
    },
    ['crimeTraders'] = {
        label = "Crime Traders",
        img = "https://cfx-nui-devhub_laptop/html/images/apps/crimeTraders.png",
        path = "app_crimeTraders",
        category = "premium",
        rating = 5,
        description = "Crime tracking application",
        longDescription = "A comprehensive platform for monitoring crime activities in your area.",
        author = "DEVHUB",
        size = 52,
        downloads = 1000,
        class = 'premium',
        developerLogo = "https://upload.devhub.gg/dh_upload/devhubLogo.webp",
        galleryImages = {
            'https://cfx-nui-devhub_laptop/html/images/appGallery/crimeTraders.webp',
            'https://cfx-nui-devhub_laptop/html/images/appGallery/crimeTraders2.webp',
            'https://cfx-nui-devhub_laptop/html/images/appGallery/crimeTraders3.webp',
        },
        reviews = {
            {
                user = "CrimeWatcher",
                rating = 5,
                comment = "Invaluable tool for staying informed about local crime. Highly recommend!",
                date = "2025-08-13"
            },
            {
                user = "SafetyFirst",
                rating = 5,
                comment = "Essential app for anyone 'concerned' about crime in their area.",
                date = "2025-08-11"
            },
        },
    },

}