-- Configuration
local Config = require("config.main")
local Functions = require("config.functions")

-- Locales
local locales = lib.loadJson(("locales.%s"):format(Config.Locale))

---@param shopData table
---@return boolean
local function checkJob(shopData)
	local jobName, jobGrade = lib.callback.await("cloud-shop:getJobData", false)
	log.debug(("[checkJob] Job Name: %s, Job Grade: %s"):format(jobName, jobGrade))

	local jobLabels = {}

	for i = 1, #shopData.Requirement.Job.jobs do
		local jobData = shopData.Requirement.Job.jobs[i]

		table.insert(jobLabels, jobData.label)

		if jobName == jobData.name then
			if jobGrade >= jobData.grade then
				return true
			else
				Functions.Notify.Client({
					title = locales.notify.requirement.job_grade.title,
					description = locales.notify.requirement.job_grade.description,
					type = locales.notify.requirement.job_grade.type,
				})
				return false
			end
		end
	end

	Functions.Notify.Client({
		title = locales.notify.requirement.job.title,
		description = locales.notify.requirement.job.description:format(table.concat(jobLabels, "/")),
		type = locales.notify.requirement.job.type,
	})
	return false
end

return checkJob
