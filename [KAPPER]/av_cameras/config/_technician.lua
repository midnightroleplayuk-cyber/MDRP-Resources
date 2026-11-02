Config = Config or {}
Config.UseTechnician = true -- If true, restricts camera installation strictly to technicians. If false, anyone can install them
Config.TechnicianJobName = 'technician' -- The job name that is considered a technician, used if Config.UseTechnician is true
Config.RepairTool = 'cam_kit' -- The item name for the repair tool that technicians will use to fix cameras
Config.BatteryItem = 'cam_battery' -- The item name for the battery that technicians will use to replace camera batteries
Config.FixingPayment = 100 -- The amount technicians are paid for fixing a camera or false if you don't want them to be paid for it
Config.MoneyAccount = "bank" -- Money account to receive payment
Config.RemoveToolOnUse = true -- Whether the repair tool should be removed from the technician's inventory when used
-- Will only register APP if UseTechnician is true
Config.TechnicianApp = {
    name = "technician",
    label = "TechPro", -- You can rename the app by editing this field
    isEnabled = function()
        local job = exports['av_laptop']:getJob()
        local state = job.name == Config.TechnicianJobName
        dbug("Checking if Technician App should be enabled for job " .. tostring(job.name) .. ": " .. tostring(state))
        return state
    end
}