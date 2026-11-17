-- GoodCiv training quiz shown at the sign-up NPC (ox_lib dialogs). The server marks it.
local open = false

RegisterNetEvent('goodciv:client:startTraining', function(questions, passMark)
    if open or type(questions) ~= 'table' then return end
    open = true

    local intro = lib.alertDialog({
        header = L('training_title'),
        content = L('training_intro', #questions, passMark),
        centered = true,
        cancel = true,
        labels = { confirm = L('training_start'), cancel = L('training_cancel') },
    })
    if intro ~= 'confirm' then
        open = false
        return TriggerServerEvent('goodciv:server:trainingCancelled')
    end

    local fields = {}
    for i, q in ipairs(questions) do
        local opts = {}
        for n, text in ipairs(q.options) do
            opts[n] = { value = tostring(n), label = text }
        end
        fields[i] = {
            type = 'select',
            label = ('%d. %s'):format(i, q.question),
            options = opts,
            required = true,
        }
    end

    local result = lib.inputDialog(L('training_title'), fields, { allowCancel = true })
    open = false
    if not result then
        return TriggerServerEvent('goodciv:server:trainingCancelled')
    end

    local answers = {}
    for i = 1, #questions do answers[i] = tonumber(result[i]) end
    TriggerServerEvent('goodciv:server:submitTraining', answers)
end)
