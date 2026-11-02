local function migratedAccount(name)
	if type(name) ~= "string" or name == "" then
		return nil
	end
	local target = MySQL.scalar.await(
		"SELECT target FROM av_banking_migrations WHERE source = 'renewed' AND kind = 'account' AND source_id = ?",
		{ name }
	)
	if not target then
		return nil
	end
	return Banking.getAccount(tonumber(target))
end

local function getAccountMoney(account)
	local migrated = migratedAccount(account)
	if migrated then
		return tonumber(migrated.balance) or 0
	end
	return Society.money(account)
end

local function addAccountMoney(account, amount)
	amount = math.floor(tonumber(amount) or 0)
	if amount <= 0 then
		return false
	end
	local migrated = migratedAccount(account)
	if migrated then
		local balance = Banking.updateBalance(migrated.id, amount)
		if not balance then
			return false
		end
		Banking.addTransaction(
			migrated.id,
			"deposit",
			amount,
			balance,
			L("tx_external_deposit"),
			"system",
			L("bank_name"),
			nil,
			"EXT"
		)
		Banking.notifyAccount(migrated)
		return true
	end
	return Society.add(account, amount, L("bank_name"), L("tx_external_deposit"))
end

local function removeAccountMoney(account, amount)
	amount = math.floor(tonumber(amount) or 0)
	if amount <= 0 then
		return false
	end
	local migrated = migratedAccount(account)
	if migrated then
		local balance = Banking.updateBalance(migrated.id, -amount)
		if not balance then
			return false
		end
		Banking.addTransaction(
			migrated.id,
			"payment",
			-amount,
			balance,
			L("tx_external_charge"),
			"system",
			L("bank_name"),
			nil,
			"EXT"
		)
		Banking.notifyAccount(migrated)
		return true
	end
	return Society.remove(account, amount, L("bank_name"), L("tx_external_charge"))
end

local function handleTransaction(account, title, amount, message, issuer, receiver, transType, transID)
	return {
		trans_id = transID or Banking.genRef("EXT"),
		title = title,
		amount = amount,
		trans_type = transType,
		receiver = receiver,
		message = message,
		issuer = issuer,
		time = os.time(),
	}
end

local function getAccountTransactions(account)
	local migrated = migratedAccount(account)
	if not migrated then
		return {}
	end
	local rows = MySQL.query.await(
		"SELECT amount, description, actor_name, reference, UNIX_TIMESTAMP(created_at) AS at FROM av_banking_transactions WHERE account_id = ? ORDER BY id DESC LIMIT 50",
		{ migrated.id }
	) or {}
	local list = {}
	for _, row in ipairs(rows) do
		local amount = tonumber(row.amount) or 0
		list[#list + 1] = {
			trans_id = row.reference,
			title = migrated.label,
			amount = math.abs(amount),
			trans_type = amount >= 0 and "deposit" or "withdraw",
			receiver = migrated.label,
			message = row.description,
			issuer = row.actor_name,
			time = tonumber(row.at) or os.time(),
		}
	end
	return list
end

local function getJobAccount(job)
	local money = Society.money(job)
	if not money then
		return nil
	end
	return {
		id = job,
		name = Society.label(job),
		type = "org",
		frozen = 0,
		amount = money,
		transactions = {},
		auth = {},
	}
end

local function createJobAccount(job, initialBalance)
	if type(job) ~= "table" or type(job.name) ~= "string" or job.name == "" then
		return nil
	end
	if Society.mode() == "banking" then
		Society.account(job.name, true)
	end
	local initial = math.floor(tonumber(initialBalance) or 0)
	if initial > 0 and not Society.money(job.name) then
		Society.add(job.name, initial, L("bank_name"), L("tx_account_opened"))
	end
	return getJobAccount(job.name)
end

local function unsupported(name)
	return function()
		print(
			("[av_banking] exports['Renewed-Banking']:%s is not available, manage that from the av_banking app instead"):format(
				name
			)
		)
		return false
	end
end

local function answerFor(resource, exportsList)
	local state = GetResourceState(resource)
	if state == "started" or state == "starting" then
		print(("[av_banking] %s is running, the compatibility bridge stays off for it"):format(resource))
		return
	end
	for name, fn in pairs(exportsList) do
		AddEventHandler(("__cfx_export_%s_%s"):format(resource, name), function(setCB)
			setCB(fn)
		end)
	end
end

answerFor("Renewed-Banking", {
	getAccountMoney = getAccountMoney,
	addAccountMoney = addAccountMoney,
	removeAccountMoney = removeAccountMoney,
	handleTransaction = handleTransaction,
	getAccountTransactions = getAccountTransactions,
	GetJobAccount = getJobAccount,
	CreateJobAccount = createJobAccount,
	addAccountMember = unsupported("addAccountMember"),
	removeAccountMember = unsupported("removeAccountMember"),
	changeAccountName = unsupported("changeAccountName"),
})

answerFor("qb-management", {
	GetAccount = getAccountMoney,
	GetGangAccount = getAccountMoney,
	AddMoney = addAccountMoney,
	AddGangMoney = addAccountMoney,
	RemoveMoney = removeAccountMoney,
	RemoveGangMoney = removeAccountMoney,
})

answerFor("esx_society", {
	GetSociety = getAccountMoney,
})
