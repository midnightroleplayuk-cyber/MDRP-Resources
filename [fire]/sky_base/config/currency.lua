Config.Currency = {
    defaultFormatter = "money",
    defaultCurrency = "money",

    -- Helpers are passed into formatter and currency functions.
    -- You can override them here if your server needs different rounding,
    -- grouping, time conversion, or clock output behavior.
    helpers = {
        round = function(value, precision)
            precision = tonumber(precision) or 0
            local multiplier = 10 ^ precision
            return math.floor(((tonumber(value) or 0) * multiplier) + 0.5) / multiplier
        end,
        groupDigits = function(value, separator)
            local grouped = tostring(value or "0")
            separator = separator or ","

            while true do
                local nextValue, replacements = grouped:gsub("^(-?%d+)(%d%d%d)", "%1" .. separator .. "%2")
                grouped = nextValue
                if replacements == 0 then break end
            end

            return grouped
        end,
        toSeconds = function(value, input)
            local amount = math.max(0, math.floor((tonumber(value) or 0) + 0.5))

            if input == "minutes" then
                return amount * 60
            elseif input == "hours" then
                return amount * 3600
            end

            return amount
        end,
        formatClock = function(seconds, output)
            local amount = math.max(0, math.floor((tonumber(seconds) or 0) + 0.5))
            local hours = math.floor(amount / 3600)
            local minutes = math.floor((amount % 3600) / 60)
            local remainingSeconds = amount % 60

            if output == "mm:ss" then
                return string.format("%02d:%02d", math.floor(amount / 60), remainingSeconds)
            end

            return string.format("%02d:%02d:%02d", hours, minutes, remainingSeconds)
        end
    },

    -- Formatters only control how an amount is displayed.
    -- They do not add/remove/check money by themselves.
    formatters = {
        money = {
            type = "money",
            symbol = "$",
            symbolPosition = "before", -- before, after
            spaceBetween = false,
            thousandsSeparator = ",",
            decimalSeparator = ".",
            precision = 0
        },
        bank = {
            type = "money",
            symbol = "$",
            symbolPosition = "before", -- before, after
            spaceBetween = false,
            thousandsSeparator = ",",
            decimalSeparator = ".",
            precision = 0
        },
        black_money = {
            type = "money",
            symbol = "$",
            symbolPosition = "before", -- before, after
            spaceBetween = false,
            thousandsSeparator = ",",
            decimalSeparator = ".",
            precision = 0
        },

        -- Example template for a custom seconds-based formatter.
        -- Add your formatter here, then reference it from a currency below.
        --
        -- playtime = {
        --     type = "time",
        --     input = "seconds",
        --     output = "hh:mm:ss",
        --     format = function(value, helpers, formatter)
        --         return helpers.formatClock(helpers.toSeconds(value, formatter.input), formatter.output)
        --     end,
        --     nui = {
        --         type = "time",
        --         input = "seconds",
        --         output = "hh:mm:ss"
        --     }
        -- }
    },

    -- Currencies control the actual account/wallet behavior.
    -- get/add/remove/has can be fully custom code and may call exports from
    -- other resources, databases, items, metadata, etc.
    currencies = {
        money = {
            formatter = "money",
            get = function(source)
                if not IsDuplicityVersion() then return 0 end
                return Sky.FW.GetAccountMoney(source, "money") or 0
            end,
            add = function(source, amount)
                if not IsDuplicityVersion() then return false end
                return Sky.FW.AddAccountMoney(source, "money", amount) ~= false
            end,
            remove = function(source, amount)
                if not IsDuplicityVersion() then return false end
                return Sky.FW.RemoveAccountMoney(source, "money", amount)
            end,
            has = function(source, amount, helpers, currency)
                local balance = currency.get(source) or 0
                return balance >= amount
            end
        },
        bank = {
            formatter = "bank",
            get = function(source)
                if not IsDuplicityVersion() then return 0 end
                return Sky.FW.GetAccountMoney(source, "bank") or 0
            end,
            add = function(source, amount)
                if not IsDuplicityVersion() then return false end
                return Sky.FW.AddAccountMoney(source, "bank", amount) ~= false
            end,
            remove = function(source, amount)
                if not IsDuplicityVersion() then return false end
                return Sky.FW.RemoveAccountMoney(source, "bank", amount)
            end
        },
        black_money = {
            formatter = "black_money",
            get = function(source)
                if not IsDuplicityVersion() then return 0 end
                return Sky.FW.GetAccountMoney(source, "black_money") or 0
            end,
            add = function(source, amount)
                if not IsDuplicityVersion() then return false end
                return Sky.FW.AddAccountMoney(source, "black_money", amount) ~= false
            end,
            remove = function(source, amount)
                if not IsDuplicityVersion() then return false end
                return Sky.FW.RemoveAccountMoney(source, "black_money", amount)
            end
        },

        -- Example template for a custom seconds-based currency.
        -- Requires a matching formatter above, e.g. `formatters.playtime`.
        -- Uncomment and replace `my_time_resource` with your own resource/API.
        --
        -- playtime = {
        --     formatter = "playtime",
        --     get = function(source, helpers, currency)
        --         if not IsDuplicityVersion() then return 0 end
        --         return math.floor(tonumber(exports["my_time_resource"]:GetSeconds(source)) or 0)
        --     end,
        --     add = function(source, amount, helpers, currency)
        --         if not IsDuplicityVersion() then return false end
        --         local seconds = helpers.toSeconds(amount, currency.formatterConfig.input)
        --         return exports["my_time_resource"]:AddSeconds(source, seconds) ~= false
        --     end,
        --     remove = function(source, amount, helpers, currency)
        --         if not IsDuplicityVersion() then return false end
        --         local seconds = helpers.toSeconds(amount, currency.formatterConfig.input)
        --         return exports["my_time_resource"]:RemoveSeconds(source, seconds)
        --     end,
        --     has = function(source, amount, helpers, currency)
        --         local seconds = helpers.toSeconds(amount, currency.formatterConfig.input)
        --         return (currency.get(source, helpers, currency) or 0) >= seconds
        --     end
        -- }
    }
}
