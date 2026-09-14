if not Config then Config = {} end

-- Discord Webhook for logging all license activities
-- Set to false or "" to disable logging

Config.LogsWebhook = "https://discord.com/api/webhooks/YOUR_WEBHOOK_HERE"

local skinColors = {
    ['0'] = "Caucasian",
    ['1'] = "Caucasian",
    ['2'] = "Black",
    ['3'] = "Black",
    ['4'] = "Brown",
    ['5'] = "Brown",
    ['6'] = "Light brown",
    ['7'] = "Light brown",
    ['8'] = "Brown",
    ['9'] = "Brown",
    ['10'] = "Light brown",
    ['11'] = "Brown",
    ['12'] = "Caucasian",
    ['13'] = "Caucasian",
    ['14'] = "Black",
    ['15'] = "Black",
    ['16'] = "Mixed",
    ['17'] = "Light brown",
    ['18'] = "Light brown",
    ['19'] = "Mixed",
    ['20'] = "Mixed",
    ['21'] = "Caucasian",
    ['22'] = "Caucasian",
    ['23'] = "Black",
} 

local eyesColors = {
    ['0'] = "Olive",
    ['1'] = "Green",
    ['2'] = "Blue",
    ['3'] = "Blue",
    ['4'] = "Brown",
    ['5'] = "Brown",
    ['6'] = "Brown",
    ['7'] = "Gray",
    ['8'] = "Gray",
    ['9'] = "Pink",
    ['10'] = "Yellow",
    ['11'] = "Purple",
    ['12'] = "Black",
    ['13'] = "Gray",
    ['14'] = "Brown",
    ['15'] = "Yellow",
    ['16'] = "Black&White",
    ['17'] = "Red",
    ['18'] = "Mixed",
    ['19'] = "Black&White",
    ['20'] = "Red&White",
    ['21'] = "Green",
    ['22'] = "Orange",
    ['23'] = "Blue",
    ['24'] = "Yellow",
    ['25'] = "Yellow",
    ['26'] = "Black",
    ['27'] = "Red",
    ['28'] = "Red",
    ['29'] = "Blue",
    ['30'] = "White",
    ['31'] = "White",
}

Config.DataFields = {
    {
        name = 'fullName',
        label = 'Full Name',
        default = 'John Doe',
        getData = function(source)
            if not Core.GetFullName then return "Unknown" end
            return Core.GetFullName(source)
        end,
        showInProfile = true, -- If set to true, this data field will be shown in the profile view
        liveProfileDisplay = true, -- If set to true, and the user is on the server, their data will be retrieved using the `getData` function by looking up their profile. Otherwise, the data will be taken from the latest issued license. USE FULL ONLY FOR DATA THAT CAN CHANGE OFTEN OR IS IMPORTANT (e.g. job)
    },
    {
        name = 'firstName',
        label = 'First Name',
        default = 'John',
        getData = function(source)
            if not Core.GetFullName then return "Unknown" end
            local fullName = Core.GetFullName(source)
            if fullName then
                return fullName:match("^(%S+)")
            end
            return "Unknown"
        end,
        fakeFields = {"James", "Mary", "Robert", "Patricia", "John", "Jennifer", "Michael", "Linda", "William", "Elizabeth", "David", "Barbara", "Richard", "Susan", "Joseph"},
    },
    {
        name = 'lastName',
        label = 'Last Name',
        default = 'Doe',
        getData = function(source)
            if not Core.GetFullName then return "Unknown" end
            local fullName = Core.GetFullName(source)
            if fullName then
                return fullName:match("%S+$")
            end
            return "Unknown"
        end,
        fakeFields = {"Smith", "Johnson", "Williams", "Brown", "Jones", "Garcia", "Miller", "Davis", "Rodriguez", "Martinez", "Hernandez", "Lopez", "Gonzalez", "Wilson", "Anderson"},
    },
    {
        name = 'dateOfBirth',
        label = 'Date of Birth',
        default = '01/01/1990',
        getData = function(source)
            if not Core.GetUserInfo then return "Unknown" end
            return Core.GetUserInfo(source).dateOfBirth
        end,
        fakeFields = {"01/01/1980", "02/14/1992", "03/30/1985", "04/25/1995", "05/10/1988", "06/20/1991", "07/15/1983", "08/05/1993", "09/12/1987", "10/31/1994", "11/22/1982", "12/18/1990"},
        showInProfile = true, -- If set to true, this data field will be shown in the profile view
    },
    {
        name = 'Sex',
        label = 'Sex',
        default = 'Male',
        getData = function(source)
            if not Core.GetUserInfo then return "Unknown" end
            return Core.GetUserInfo(source).sex
        end,
        fakeFields = {"Male", "Female"},
        showInProfile = true, -- If set to true, this data field will be shown in the profile view
    },
    {
        name = 'Nationality',
        label = 'Nationality',
        default = 'American',
        getData = function(source)
            if not Core.GetUserInfo then return "Unknown" end
            return Core.GetUserInfo(source).nationality
        end,
        fakeFields = {"American", "Canadian", "British", "Australian", "French", "German", "Italian", "Spanish", "Mexican", "Brazilian", "Chinese", "Japanese", "Indian", "Russian", "South African"},
        showInProfile = true, -- If set to true, this data field will be shown in the profile view
    },
    {
        name = 'height',
        label = 'Height',
        default = '180 cm',
        getData = function(source)
            if not Core.GetUserInfo then return "Unknown" end
            return Core.GetUserInfo(source).height
        end,
        fakeFields = {"160 cm", "165 cm", "170 cm", "175 cm", "180 cm", "185 cm", "190 cm", "195 cm", "200 cm"},
        showInProfile = true, -- If set to true, this data field will be shown in the profile view
    },
    {
        name = 'jobLabel',
        label = 'Job',
        default = 'Unemployed',
        getData = function(source)
            if not Core.GetJob then return "Unknown" end
            return Core.GetJob(source).label
        end,
        fakeFields = {"Unemployed", "Police Officer", "Doctor", "Mechanic", "Taxi Driver", "Chef", "Firefighter", "Teacher", "Lawyer", "Farmer", "Construction Worker", "Artist", "Musician", "Programmer"},
        showInProfile = true, -- If set to true, this data field will be shown in the profile view
        liveProfileDisplay = true, -- If set to true, and the user is on the server, their data will be retrieved using the `getData` function by looking up their profile. Otherwise, the data will be taken from the latest issued license. USE FULL ONLY FOR DATA THAT CAN CHANGE OFTEN OR IS IMPORTANT (e.g. job)
    },
    {
        name = 'jobGrade',
        label = 'Job Grade',
        default = 'Entry Level',
        getData = function(source)
            if not Core.GetJob then return "Unknown" end
            return Core.GetJob(source).gradeLabel
        end,
        fakeFields = {"Entry Level", "Junior", "Mid-Level", "Senior", "Lead", "Manager", "Director", "Executive"},
        showInProfile = true, -- If set to true, this data field will be shown in the profile view
        liveProfileDisplay = true, -- If set to true, and the user is on the server, their data will be retrieved using the `getData` function by looking up their profile. Otherwise, the data will be taken from the latest issued license. USE FULL ONLY FOR DATA THAT CAN CHANGE OFTEN OR IS IMPORTANT (e.g. job)
    },
    {
        name = 'issueDate',
        label = 'Issue Date',
        default = '01/01/2024',
        getData = function(source, other)
            return os.date("%Y-%m-%d %H:%M:%S", other.issueDate)
        end,
    },
    {
        name = 'expirationDate',
        label = 'Expiration Date',
        default = '01/01/2029',
        getData = function(source, other)
            return os.date("%Y-%m-%d", other.expirationDate)
        end,
    },
    {
        name = 'licenseNumber',
        label = 'License Number',
        default = 'LIC-000000',
        getData = function(source, other)
            return other.licenseNumber
        end,
    },
    {
        name = 'skinColor',
        label = 'Skin Color',
        default = 'Fair',
        getData = function(source)
            local userSkin = Core.GetUserSkin(source)
            local skinColor = userSkin and userSkin.skinColor
            return skinColors[tostring(skinColor)] or "Unknown"
        end,
        fakeFields = {"Fair", "Light", "Medium", "Olive", "Brown", "Dark Brown", "Black"},
        showInProfile = true, -- If set to true, this data field will be shown in the profile view
    },
    {
        name = 'eyeColor',
        label = 'Eye Color',
        default = 'Brown',
        getData = function(source)
            local userSkin = Core.GetUserSkin(source)
            local eyesColor = userSkin and userSkin.eyesColor
            return eyesColors[tostring(eyesColor)] or "Unknown"
        end,
        fakeFields = {"Brown", "Blue", "Green", "Hazel", "Gray", "Amber", "Red", "Violet"},
        showInProfile = true, -- If set to true, this data field will be shown in the profile view
    },
}