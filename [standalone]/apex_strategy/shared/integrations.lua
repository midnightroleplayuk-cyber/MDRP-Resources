--[[
    apex_strategy, shared/integrations.lua
    Ficheiro para ligares o quadro ao resto do servidor. Todos os
    hooks podem ficar como estão: o script usa os valores por defeito.
]]

Integrations = Integrations or {}

-- ═══════════════════════════════════════════════════════════
-- CLIENTE
-- ═══════════════════════════════════════════════════════════

--- Substitui o sistema de avisos. Devolve true se trataste tu da
--- mensagem, nesse caso o script não faz mais nada.
---
---   function Integrations.Notify(msg, kind, title, duration)
---       exports.ox_lib:notify({ title = title, description = msg, type = kind })
---       return true
---   end
function Integrations.Notify(message, kind, title, duration) return false end

--- Dispara quando alguém abre / fecha o quadro.
---   payload = { open = boolean, boardId = number }
function Integrations.OnBoardToggle(payload) end

-- ═══════════════════════════════════════════════════════════
-- SERVIDOR
-- ═══════════════════════════════════════════════════════════

--- Registo de tudo o que mexe no quadro. Bom sítio para mandar para
--- um Discord webhook ou para o teu colector de logs.
---   payload = { action, boardId, actor = { src, identifier, name, job }, details }
function Integrations.OnLog(payload) end

--- Chamado ANTES de aceitar uma alteração. Devolve false para
--- bloquear. Serve, por exemplo, para trancar um quadro durante uma
--- operação a decorrer.
---   payload = { action, boardId, src, job }
function Integrations.OnBeforeChange(payload) return true end

return Integrations
