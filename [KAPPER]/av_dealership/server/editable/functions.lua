function Notify(src, message, ntype)
	TriggerClientEvent("av_laptop:notification", src, "Dealership", message, ntype or "info")
end

function GetIdentifier(src)
	return exports["av_laptop"]:getIdentifier(src)
end

local cashAccount = nil
function GetCashAccount()
	if cashAccount then
		return cashAccount
	end
	cashAccount = "cash"
	local ok, framework = pcall(function()
		return exports["av_laptop"]:getFramework()
	end)
	if ok and framework == "esx" then
		cashAccount = "money"
	end
	return cashAccount
end

local function resolveAccount(account)
	account = account or Config.BankAccount
	if account == "cash" then
		return GetCashAccount()
	end
	return account
end

function GetMoney(src, account)
	if account == "tokens" then
		local ok, tokens = pcall(function()
			return exports["av_vip"]:getTokens(src)
		end)
		return (ok and tonumber(tokens)) or 0
	end
	local ok, amount = pcall(function()
		return exports["av_laptop"]:getMoney(src, resolveAccount(account))
	end)
	if ok and type(amount) == "number" then
		return amount
	end
	return 0
end

function AddMoney(src, account, amount, reason)
	if not amount or amount <= 0 then
		return false
	end
	if account == "tokens" then
		local ok, res = pcall(function()
			return exports["av_vip"]:addTokens(src, amount)
		end)
		return ok and res ~= false
	end
	local ok, res = pcall(function()
		return exports["av_laptop"]:addMoney(src, resolveAccount(account), amount, reason)
	end)
	return ok and res ~= false
end

function RemoveMoney(src, account, amount, reason)
	if not amount or amount <= 0 then
		return false
	end
	if GetMoney(src, account) < amount then
		return false
	end
	if account == "tokens" then
		local ok, res = pcall(function()
			return exports["av_vip"]:removeTokens(src, amount)
		end)
		return ok and res ~= false
	end
	local ok, res = pcall(function()
		return exports["av_laptop"]:removeMoney(src, resolveAccount(account), amount, reason)
	end)
	return ok and res ~= false
end

function GetJob(src)
	local ok, job = pcall(function()
		return exports["av_laptop"]:getJob(src)
	end)
	if ok and job then
		if type(job) == "table" then
			return job.name or job.job or ""
		end
		return job
	end
	return ""
end

function GetJobData(src)
	local ok, job = pcall(function()
		return exports["av_laptop"]:getJob(src)
	end)
	if ok and type(job) == "table" then
		return job
	end
	return nil
end

function HasJob(src, job)
	local ok, res = pcall(function()
		return exports["av_laptop"]:hasJob(src, job)
	end)
	return ok and res == true
end

function IsBoss(src)
	local ok, res = pcall(function()
		return exports["av_laptop"]:isBoss(src)
	end)
	return ok and res == true
end

function GetName(src)
	local ok, name = pcall(function()
		return exports["av_laptop"]:getName(src)
	end)
	if ok and name then
		return name
	end
	return GetPlayerName(src) or ""
end

function GetJobPlayers(job)
	local ok, players = pcall(function()
		return exports["av_laptop"]:getJobPlayers(job)
	end)
	if ok and type(players) == "table" then
		return players
	end
	return {}
end

function SetJob(src, job, grade)
	local ok, res = pcall(function()
		return exports["av_laptop"]:setJob(src, job, grade)
	end)
	return ok and res ~= false
end

function SetJobGrade(identifier, job, grade)
	local ok, res = pcall(function()
		return exports["av_laptop"]:setJobGrade(identifier, job, grade)
	end)
	return ok and res ~= false
end

function GetJobGrades(job)
	local ok, grades = pcall(function()
		return exports["av_laptop"]:getJobGrades(job)
	end)
	if ok and type(grades) == "table" then
		return grades
	end
	return {}
end

function GetSociety(job)
	local ok, amount = pcall(function()
		return exports["av_laptop"]:getSociety(job)
	end)
	if ok then
		return amount
	end
	return false
end

function AddSociety(src, job, amount, name, description)
	local ok, res = pcall(function()
		return exports["av_laptop"]:addSociety(src, job, amount, name, description)
	end)
	return ok and res ~= false
end

function RemoveSociety(src, job, amount, name, description)
	local ok, res = pcall(function()
		return exports["av_laptop"]:removeSociety(src, job, amount, name, description)
	end)
	return ok and res ~= false
end

function GetSourceByIdentifier(identifier)
	local ok, src = pcall(function()
		return exports["av_laptop"]:getSourceByIdentifier(identifier)
	end)
	if ok then
		return src
	end
	return nil
end

function Discord(webhook, message)
	pcall(function()
		exports["av_laptop"]:Discord(webhook, message)
	end)
end

function GetPlayerDealerships(src)
	local job = GetJob(src)
	if not job or job == "" then
		return {}
	end
	local list = {}
	Dealerships = Dealerships or {}
	for name, dealer in pairs(Dealerships) do
		if dealer.job == job then
			list[#list + 1] = name
		end
	end
	table.sort(list)
	return list
end

function GetAllJobs()
	local ok, jobs = pcall(function()
		return exports["av_laptop"]:getAllJobs()
	end)
	if ok and type(jobs) == "table" then
		return jobs
	end
	return {}
end

function IsPlayerVIP(src)
	if GetResourceState("av_vip") == "started" then
		return exports["av_vip"]:getVIP(src) == true
	end
	return false
end

--- Runs before a customers vehicle is accepted by a dealership
--- Return false to block it
---@param suggested number the value the blue book calculated
---@param data table { plates, model, basePrice, events, owner, playerId, mods }
--- `owner` is the owner identifier, `playerId` their server id when online, `mods`
--- the stored vehicle properties (engine/brake/transmission levels live in there).
---@return number the final value, return `suggested` unchanged to keep the default
function AdjustBookValue(suggested, data)
	return suggested
end

function CanTradeVehicle(playerId, plates, row)
	return true
end

--- Fired when something happens for a player that may not be looking at the laptop:
--- outbid or won an auction, a vehicle request got a quote, a financed vehicle was repossessed
function SendPhoneNotification(playerId, title, message, kind)
	Notify(playerId, message, kind or "info")
end

function RefundPlayer(identifier, amount, reason)
	if not identifier or (tonumber(amount) or 0) <= 0 then
		return
	end
	local src = exports["av_laptop"]:getSourceByIdentifier(identifier)
	local player = src and exports["av_laptop"]:getPlayer(src)
	if player then
		exports["av_laptop"]:addMoney(src, "bank", amount, reason or "av_dealership")
		return
	end
	exports["av_laptop"]:addMoneyOffline(identifier, "bank", amount, reason or "av_dealership")
end
