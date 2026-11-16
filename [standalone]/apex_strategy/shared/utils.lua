--[[
    apex_strategy, shared/utils.lua
    Matemática do painel: espaço local da prop ↔ mundo.
]]

Utils = Utils or {}

function Utils.round(v, n)
    local m = 10 ^ (n or 0)
    return math.floor((tonumber(v) or 0) * m + 0.5) / m
end

function Utils.clamp(v, lo, hi)
    if v < lo then return lo end
    if v > hi then return hi end
    return v
end

--- Vector local do eixo pedido ('+x' '-x' '+y' '-y' '+z' '-z').
local AXIS = {
    ['+x'] = vector3( 1.0,  0.0,  0.0),
    ['-x'] = vector3(-1.0,  0.0,  0.0),
    ['+y'] = vector3( 0.0,  1.0,  0.0),
    ['-y'] = vector3( 0.0, -1.0,  0.0),
    ['+z'] = vector3( 0.0,  0.0,  1.0),
    ['-z'] = vector3( 0.0,  0.0, -1.0),
}

function Utils.Axis(name)
    return AXIS[name] or AXIS['-y']
end

--- Base do painel em espaço LOCAL da prop.
--- right = up × normal, com up = +Z. Dá sempre um triedro directo:
---   normal '-y' → right +x   ·   normal '+x' → right +y
---   normal '+y' → right -x   ·   normal '-x' → right -y
function Utils.PanelBasis(normalName)
    local n  = Utils.Axis(normalName)
    local up = vector3(0.0, 0.0, 1.0)
    local r  = vector3(
        up.y * n.z - up.z * n.y,
        up.z * n.x - up.x * n.z,
        up.x * n.y - up.y * n.x
    )
    return n, r, up
end

--- Quantos graus é que a face do painel está adiantada em relação ao
--- heading da prop. O heading aponta o LOCAL +Y; o LOCAL +X está 90°
--- no sentido dos ponteiros (que em GTA é heading a DESCER).
---   face para +Y → heading      (turn   0)
---   face para -Y → heading+180  (turn 180)
---   face para +X → heading-90   (turn -90)
---   face para -X → heading+90   (turn  90)
local FACE_TURN = { ['+y'] = 0.0, ['-y'] = 180.0, ['+x'] = -90.0, ['-x'] = 90.0 }

function Utils.FaceTurn(normalName)
    return FACE_TURN[normalName] or 180.0
end

--- Para onde a face está virada, em graus de bússola, dada a prop.
function Utils.FaceHeading(normalName, entityHeading)
    return (entityHeading + Utils.FaceTurn(normalName)) % 360.0
end

--- O inverso: que heading dar à prop para a face apontar para ali.
function Utils.HeadingForFace(normalName, faceHeading)
    return (faceHeading - Utils.FaceTurn(normalName)) % 360.0
end

--- rotZOffset que põe o scaleform virado para a face do painel.
--- Derivado do comportamento do apex_obd: com offset 0 o scaleform
--- olha para o LOCAL -Y da prop, ou seja para heading+180. Como a
--- face está em heading+turn, o desvio é 180-turn.
function Utils.DefaultRotZOffset(normalName)
    local v = (180.0 - Utils.FaceTurn(normalName)) % 360.0
    if v > 180.0 then v = v - 360.0 end
    return v
end

--- Direcção (x,y) → heading de bússola. Em GTA um heading h aponta
--- para (-sin h, cos h), por isso o inverso é atan2(-x, y).
function Utils.DirToHeading(x, y)
    return math.deg(math.atan(-x, y)) % 360.0
end

--- Base da entidade no mundo, sem depender da ordem de retorno do
--- GetEntityMatrix (que é uma armadilha conhecida em Lua).
--- Devolve origem, right(+X), forward(+Y), up(+Z).
function Utils.EntityBasis(ent)
    local o = GetEntityCoords(ent)
    local r = GetOffsetFromEntityInWorldCoords(ent, 1.0, 0.0, 0.0) - o
    local f = GetOffsetFromEntityInWorldCoords(ent, 0.0, 1.0, 0.0) - o
    local u = GetOffsetFromEntityInWorldCoords(ent, 0.0, 0.0, 1.0) - o
    return o, r, f, u
end

--- Ponto local (x,y,z) → mundo.
function Utils.LocalToWorld(ent, x, y, z)
    return GetOffsetFromEntityInWorldCoords(ent, x + 0.0, y + 0.0, z + 0.0)
end

--- Direcção local → direcção no mundo (sem translação).
function Utils.LocalDirToWorld(ent, v)
    local o, r, f, u = Utils.EntityBasis(ent)
    return r * v.x + f * v.y + u * v.z
end

--- Percent-encoding para meter JSON num URL. Trabalha byte a byte,
--- o que é exactamente o que o decodeURIComponent do lado do browser
--- espera para UTF-8.
function Utils.UrlEncode(s)
    return (tostring(s):gsub('[^%w%-%._~]', function(c)
        return ('%%%02X'):format(string.byte(c))
    end))
end

--- Texto 3D ancorado num ponto do mundo (cliente).
function Utils.Text3D(pos, text, scale)
    scale = scale or 0.35
    SetTextScale(scale, scale)
    SetTextFont(4)
    SetTextCentre(true)
    SetTextColour(255, 255, 255, 225)
    SetTextOutline()
    SetTextEntry('STRING')
    AddTextComponentSubstringPlayerName(text)
    SetDrawOrigin(pos.x, pos.y, pos.z, 0)
    DrawText(0.0, 0.0)
    ClearDrawOrigin()
end

--- O ponto local onde o (dx,dy,dz) do ecrã tem de ficar para o
--- rectângulo assentar no painel. A calibração mostrou que o
--- DrawScaleformMovie_3dNonAdditive ancora no canto superior
--- esquerdo do quadro (visto de frente), não no centro.
function Utils.PanelAnchor(panel, anchor, push)
    local n, r, up = Utils.PanelBasis(panel.normal)
    local c = vector3(panel.cx, panel.cy, panel.cz) + n * (push or 0.0)
    if anchor == 'center' then return c end
    return c - r * (panel.w * 0.5) + up * (panel.h * 0.5)
end

--- O inverso: dado o ponto de âncora e o tamanho em metros, onde fica
--- o centro do rectângulo. Serve para o desenhar.
function Utils.AnchorToCentre(anchorPos, normalName, w, h, anchor)
    if anchor == 'center' then return anchorPos end
    local n, r, up = Utils.PanelBasis(normalName)
    return anchorPos + r * (w * 0.5) - up * (h * 0.5)
end

--- Os 4 cantos do rectângulo, no mundo.
---   centre : vector3 local do centro
---   normalName : face
---   w, h   : metros
---   push   : quanto o rectângulo salta para a frente da face (m)
--- Devolve bl, br, tr, tl (a mesma ordem que o DrawSpritePoly espera).
function Utils.RectCorners(ent, centre, normalName, w, h, push)
    local n, r, up = Utils.PanelBasis(normalName)
    local c  = centre + n * (push or 0.0)
    local hw, hh = w * 0.5, h * 0.5
    local lbl = c - r * hw - up * hh
    local lbr = c + r * hw - up * hh
    local ltr = c + r * hw + up * hh
    local ltl = c - r * hw + up * hh
    return
        Utils.LocalToWorld(ent, lbl.x, lbl.y, lbl.z),
        Utils.LocalToWorld(ent, lbr.x, lbr.y, lbr.z),
        Utils.LocalToWorld(ent, ltr.x, ltr.y, ltr.z),
        Utils.LocalToWorld(ent, ltl.x, ltl.y, ltl.z)
end
