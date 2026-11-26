-- Ten-pin scoring from a flat list of rolls (pins knocked per ball).

Scoring = {}

-- Where the player is up to: which frame and ball comes next, and whether
-- that ball is thrown at a full rack.
function Scoring.next(rolls)
    local i = 1
    for f = 1, 9 do
        local r1 = rolls[i]
        if not r1 then return { frame = f, ball = 1, fresh = true } end
        if r1 == 10 then
            i = i + 1
        else
            if not rolls[i + 1] then return { frame = f, ball = 2, fresh = false } end
            i = i + 2
        end
    end

    local r1, r2, r3 = rolls[i], rolls[i + 1], rolls[i + 2]
    if not r1 then return { frame = 10, ball = 1, fresh = true } end
    if not r2 then return { frame = 10, ball = 2, fresh = r1 == 10 } end
    if (r1 == 10 or r1 + r2 == 10) and not r3 then
        local fresh = (r1 == 10 and r2 == 10) or (r1 ~= 10 and r1 + r2 == 10)
        return { frame = 10, ball = 3, fresh = fresh }
    end
    return { finished = true, frame = 10, ball = 1, fresh = true }
end

local function mark(n)
    if n == 0 then return '-' end
    if n == 10 then return 'X' end
    return tostring(n)
end

-- Ten frames ready for the scoresheet: marks per ball and the running total
-- once a frame can be scored.
function Scoring.sheet(rolls)
    local frames, total, i = {}, 0, 1

    for f = 1, 9 do
        local fr = { marks = {} }
        local r1, r2 = rolls[i], rolls[i + 1]
        if r1 == 10 then
            fr.marks = { '', 'X' }
            if r2 and rolls[i + 2] then
                total = total + 10 + r2 + rolls[i + 2]
                fr.score = total
            end
            i = i + 1
        elseif r1 then
            fr.marks[1] = mark(r1)
            if r2 then
                if r1 + r2 == 10 then
                    fr.marks[2] = '/'
                    if rolls[i + 2] then
                        total = total + 10 + rolls[i + 2]
                        fr.score = total
                    end
                else
                    fr.marks[2] = mark(r2)
                    total = total + r1 + r2
                    fr.score = total
                end
            end
            i = i + 2
        end
        frames[f] = fr
    end

    local fr = { marks = {} }
    local r1, r2, r3 = rolls[i], rolls[i + 1], rolls[i + 2]
    if r1 then
        fr.marks[1] = mark(r1)
        if r2 then
            if r1 ~= 10 and r1 + r2 == 10 then fr.marks[2] = '/' else fr.marks[2] = mark(r2) end
            local bonus = r1 == 10 or r1 + r2 == 10
            if r3 then
                if r1 == 10 and r2 ~= 10 and r2 + r3 == 10 then fr.marks[3] = '/' else fr.marks[3] = mark(r3) end
            end
            if not bonus or r3 then
                total = total + r1 + r2 + (bonus and r3 or 0)
                fr.score = total
            end
        end
    end
    frames[10] = fr

    return frames, total
end

function Scoring.total(rolls)
    local _, total = Scoring.sheet(rolls)
    return total
end
