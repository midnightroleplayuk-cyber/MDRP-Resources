-- ============================================================
-- SQL NULL parameters
-- ------------------------------------------------------------
-- A Lua table cannot hold nil. { a, b, nil, d, nil } reaches oxmysql
-- as four values (or two), while the query has five placeholders.
-- Some oxmysql builds pad the gap with NULL — 2.14.1 does, by
-- accident, into the wrong slot — and others send the query as it is,
-- so MariaDB answers "error in your SQL syntax ... near '?)'". That is
-- what apex_staff_log hit on a customer's server for every action
-- logged without a details text (remove_member, save_group, …).
--
-- Rather than trust 140 call sites, every query this resource sends
-- passes through here first: each `?` whose value is nil becomes a
-- literal NULL in the SQL and leaves the parameter list, so the list
-- is always complete and gap-free. Binding NULL and writing NULL mean
-- the same thing to MySQL, so no query changes behaviour.
--
-- It edits oxmysql's method tables in place (MySQL.query, .await, the
-- Async/Sync aliases all point at them), so it holds for every file no
-- matter the load order, and only inside this resource's own Lua state.
-- The `aa_` name just makes it load first where the order is alphabetic.
-- ============================================================

-- Positions of the `?` placeholders, skipping anything inside quotes.
local function placeholderPositions(sql)
    local out, i, n, quote = {}, 1, #sql, nil
    while i <= n do
        local c = sql:sub(i, i)
        if quote then
            if c == '\\' then
                i = i + 1
            elseif c == quote then
                quote = nil
            end
        elseif c == "'" or c == '"' or c == '`' then
            quote = c
        elseif c == '?' then
            out[#out + 1] = i
        end
        i = i + 1
    end
    return out
end

local function fillNulls(sql, params)
    if type(sql) ~= 'string' or type(params) ~= 'table' or params.__cfx_functionReference then
        return sql, params
    end
    -- `??` is an identifier placeholder with rules of its own: leave it.
    if sql:find('??', 1, true) then return sql, params end
    -- Named parameters, and batches (a list of rows), are not ours either.
    for k, v in pairs(params) do
        if type(k) ~= 'number' then return sql, params end
        if k == 1 and type(v) == 'table' then return sql, params end
    end

    local marks = placeholderPositions(sql)
    local gap = false
    for i = 1, #marks do
        if params[i] == nil then gap = true; break end
    end
    if not gap then return sql, params end

    local parts, values, last = {}, {}, 1
    for i = 1, #marks do
        if params[i] == nil then
            parts[#parts + 1] = sql:sub(last, marks[i] - 1)
            parts[#parts + 1] = 'NULL'
            last = marks[i] + 1
        else
            values[#values + 1] = params[i]
        end
    end
    parts[#parts + 1] = sql:sub(last)
    return table.concat(parts), values
end

local function wrap(method)
    if type(MySQL) ~= 'table' then return end
    -- rawget: the MySQL table's __index turns any unknown key into an export call.
    local m = rawget(MySQL, method)

    if type(m) == 'function' then
        MySQL[method] = function(query, parameters, ...)
            query, parameters = fillNulls(query, parameters)
            return m(query, parameters, ...)
        end
        return
    end
    if type(m) ~= 'table' then return end

    local await = rawget(m, 'await')
    if type(await) == 'function' then
        m.await = function(query, parameters, ...)
            query, parameters = fillNulls(query, parameters)
            return await(query, parameters, ...)
        end
    end

    -- MySQL.query(...) goes through the metatable. oxmysql shares one
    -- metatable between all methods, so each gets its own copy.
    local mt = getmetatable(m)
    local call = type(mt) == 'table' and mt.__call
    if type(call) == 'function' then
        local own = {}
        for k, v in pairs(mt) do own[k] = v end
        own.__call = function(self, query, parameters, ...)
            query, parameters = fillNulls(query, parameters)
            return call(self, query, parameters, ...)
        end
        setmetatable(m, own)
    end
end

for _, method in ipairs({ 'query', 'insert', 'update', 'scalar', 'single', 'prepare', 'rawExecute' }) do
    wrap(method)
end
