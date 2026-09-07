function findTableValue(tbl, path)
  if not tbl or not path or path == "" then
      return nil
  end

  local value = tbl

  for field in string.gmatch(path, "[^%.]+") do
      if type(value) ~= "table" or value[field] == nil then
          return nil
      end
      value = value[field]
  end
  return value
end


function splitBase64IntoChunks(base64String, chunkSize)
  chunkSize = chunkSize or 8000
  local chunks = {}
  local totalLength = string.len(base64String)
  local totalChunks = math.ceil(totalLength / chunkSize)
  
  for i = 1, totalChunks do
    local startPos = (i - 1) * chunkSize + 1
    local endPos = math.min(i * chunkSize, totalLength)
    local chunk = string.sub(base64String, startPos, endPos)
    
    table.insert(chunks, {
      index = i,
      data = chunk,
      total = totalChunks,
      isLast = (i == totalChunks)
    })
  end
  
  return chunks
end

function joinChunks(chunks)
  local result = ""
  for i = 1, #chunks do
    result = result .. chunks[i].data
  end
  return result
end

local b='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'  
function base64decode(data)
    data = string.gsub(data, '[^'..b..'=]', '')
    return (data:gsub('.', function(x)
        if x == '=' then return '' end
        local r,f='', (b:find(x)-1)
        for i=6,1,-1 do r=r..(f%2^i - f%2^(i-1) > 0 and '1' or '0') end
        return r
    end):gsub('%d%d%d%d%d%d%d%d', function(x)
        return string.char(tonumber(x,2))
    end))
end