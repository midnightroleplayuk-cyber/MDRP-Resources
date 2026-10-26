Logs = {}

-- General webhook configurations
Logs.Name = 'Laundering Logs' -- Name for the webhook
Logs.Image = 'https://i.imgur.com/ILTkWBh.png' -- Image for the webhook
Logs.Footer = 'https://i.imgur.com/ILTkWBh.png' -- Footer image for the webhook

-- Specific log type configurations
Logs.Types = {
    -- Do you want logs of users leveling up?
    levelUp = {
        enabled = false,
        webhook = '',
    },
    -- Do you want logs of users completing contracts?
    contracts = {
        enabled = false,
        webhook = '',
    },
    -- Do you want logs of users completing washes in warehouse?
    warehouse = {
        enabled = false,
        webhook = ''
    },
    -- Do you want logs of users counting money?
    counting = {
        enabled = false,
        webhook = ''
    },
    -- Do you want logs of users negotiating contracts?
    negotiate = {
        enabled = false,
        webhook = ''
    },
    -- Do you want logs of users being rejected during contracts?
    rejected = {
        enabled = false,
        webhook = ''
    },
    -- Do you want logs of users purchasing warehouse keys?
    warehouseKey = {
        enabled = false,
        webhook = ''
    }
}