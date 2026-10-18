--[[
    Apex Minimap Studio — chave do assistente de AI
    ────────────────────────────────────────────────────────────
    PÕE A CHAVE AQUI. É este o sítio certo.

    Porquê aqui e não no shared/config.lua: o config é um `shared_script`,
    ou seja, é DESCARREGADO POR TODOS OS CLIENTES que entram no servidor.
    Uma chave escrita lá viaja dentro de cada cópia do resource e qualquer
    pessoa a pode ler e gastar. Este ficheiro só corre no SERVIDOR, por
    isso a chave nunca sai daqui.

    Chave gratuita do Gemini: https://aistudio.google.com/apikey

    Alternativas (por ordem de preferência do código):
      1. este ficheiro
      2. Config.ai.apiKey em shared/config.lua   (funciona, mas expõe)
      3. convar:  set apex_minimap_ai_key "..."  no server.cfg
         (as chaves do apex_mapbuilder / apex_clothing também servem)
]]

AiKey = ''
