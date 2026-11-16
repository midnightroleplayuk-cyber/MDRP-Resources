--[[
    apex_strategy, shared/locale.lua
    Traduções. L('chave', ...) devolve a frase na língua de
    Config.locale, com string.format se houver argumentos.

    Se uma chave faltar na língua escolhida, cai para o inglês; se
    faltar nas duas, devolve a própria chave, para se ver logo o que
    ficou por traduzir em vez de aparecer vazio.

    Para acrescentar uma língua: cria locales/<codigo>.lua com
    Locales['<codigo>'] = { ... }, declara-o no fxmanifest e põe
    Config.locale = '<codigo>'.
]]

Locales = Locales or {}

function L(key, ...)
    local lang = (Config and Config.locale) or 'en'
    local pack = Locales[lang] or Locales.en or {}
    local s = pack[key]
    if s == nil and lang ~= 'en' then
        s = (Locales.en or {})[key]
    end
    if s == nil then return key end
    if select('#', ...) > 0 then
        local ok, out = pcall(string.format, s, ...)
        return ok and out or s
    end
    return s
end

--- Bloco inteiro de uma língua, para mandar de uma vez para a NUI.
--- O inglês entra por baixo, para que uma chave em falta na tradução
--- apareça em inglês em vez de aparecer vazia na interface.
function LocaleTable()
    local lang = (Config and Config.locale) or 'en'
    local out = {}
    for k, v in pairs(Locales.en or {}) do out[k] = v end
    if lang ~= 'en' then
        for k, v in pairs(Locales[lang] or {}) do out[k] = v end
    end
    return out
end
