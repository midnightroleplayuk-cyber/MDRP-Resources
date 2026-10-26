-- Command identifiers stay stable internally; only the registered chat names change.
TapeCommands={}
function TapeCommands.name(id)
 local name=Config.Commands[id]
 return type(name)=='string' and #name<=40 and name:match('^[%w_%-]+$') and name or id
end
function TapeCommands.text(text)
 if type(text)~='string' then return text end
 return (text:gsub('/([%w_%-]+)',function(id)return '/'..TapeCommands.name(id)end))
end
