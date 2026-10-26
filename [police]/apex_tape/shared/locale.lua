TapeLocale={}
local L=TapeLocale
local cache,cacheCount={},0
local function dictionary()
    return TapeMessages[Config.Locale] or TapeMessages.en
end
function L.Text(key)
    return Config.LocaleOverrides[key] or dictionary()[key] or TapeMessages.en[key] or key
end
local function escape(s) return (s:gsub('([%^%$%(%)%%%.%[%]%*%+%-%?])','%%%1')) end
local function plain(s)return escape((s:gsub('%%%%',function()return '%'end)))end
local templates={}
for key in pairs(TapeMessages.en) do
    if key:find('%%[%d%.]*[sdf]') then
        local cursor,parts,kinds=1,{},{}
        while true do
            local a,b=key:find('%%[%d%.]*[sdf]',cursor)
            if not a then parts[#parts+1]=plain(key:sub(cursor));break end
            parts[#parts+1]=plain(key:sub(cursor,a-1));parts[#parts+1]='(.+)';kinds[#kinds+1]=key:sub(b,b);cursor=b+1
        end
        templates[#templates+1]={key=key,pattern='^'..table.concat(parts)..'$',kinds=kinds}
    end
end
function L.Render(text)
    if type(text)~='string' then return text end
    if cache[text] then return cache[text] end
    local result=L.Text(text)
    if result==text and (Config.Locale~='en' or next(Config.LocaleOverrides)) then
        for _,template in ipairs(templates) do
            local values={text:match(template.pattern)}
            if #values==#template.kinds then
                local valid=true
                for i,kind in ipairs(template.kinds) do if kind~='s' then values[i]=tonumber(values[i]);if not values[i] then valid=false end end end
                if valid then local ok,value=pcall(string.format,L.Text(template.key),table.unpack(values));if ok then result=value;break end end
            end
        end
    end
    result=TapeCommands.text(result)
    if cacheCount>=256 then cache={};cacheCount=0 end
    cache[text]=result;cacheCount=cacheCount+1
    return result
end
function L.UI()
    local result={}
    for key in pairs(TapeMessages.en) do result[key]=TapeCommands.text(L.Text(key)) end
    for key,value in pairs(Config.LocaleOverrides) do result[key]=TapeCommands.text(value) end
    return result
end
