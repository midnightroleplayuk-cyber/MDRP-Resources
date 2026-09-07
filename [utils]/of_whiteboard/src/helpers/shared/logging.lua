local currentResourceName = GetCurrentResourceName()

debugC = function(...)
  if not Config.Debug then return end
  local args <const> = { ... }

  local appendStr = ''
  for _, v in ipairs(args) do
  appendStr = appendStr .. ' ' .. tostring(v)
  end
  local msgTemplate = '^3[%s]^0%s'
  local finalMsg = msgTemplate:format(currentResourceName, appendStr)
  print(finalMsg)
end

info = function(...)
  local args <const> = { ... }

  local appendStr = ''
  for _, v in ipairs(args) do
  appendStr = appendStr .. ' ' .. tostring(v)
  end
  local msgTemplate = '^3[%s]^0%s'
  local finalMsg = msgTemplate:format(currentResourceName, appendStr)
  print(finalMsg)
end

error = function(...)
  local args <const> = { ... }

  local appendStr = ''
  for _, v in ipairs(args) do
  appendStr = appendStr .. ' ' .. tostring(v)
  end
  local msgTemplate = '^3[ERROR]^0%s'
  local finalMsg = msgTemplate:format(appendStr)
  print(finalMsg)
end
