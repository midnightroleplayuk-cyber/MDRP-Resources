TapeCustomTextServer={}
local C=TapeCustomTextServer
local selections={}
local function validate(value)
 if type(value)~='string' or #value>Config.CustomText.MaxLength*4+32 or value:find('%c') then return nil,'Use plain text without control characters.' end
 value=value:match('^%s*(.-)%s*$'):gsub(' +',' ')
 local count=utf8.len(value)
 if not count or count<1 or count>Config.CustomText.MaxLength then return nil,('Use 1–%d characters.'):format(Config.CustomText.MaxLength) end
 return value
end
local function fits(text,exclude)
 local unique={};local count=0
 for _,t in pairs(TapeRuntime.tapes) do
  if t.id~=exclude and t.customText and not unique[t.customText] then unique[t.customText]=true;count=count+1 end
 end
 return unique[text] or count<Config.CustomText.MaxUnique
end
function C.forPlacement(src)
 if not Config.CustomText.Enabled then return nil end
 if Config.CustomText.StaffOnly and not TapeRuntime.admin(src) then return nil end
 local text=selections[src]
 if text and not fits(text) then return nil,'Custom wording limit reached. Reuse existing wording or clear a custom span.' end
 return text
end
function C.handle(src,p)
 local R=TapeRuntime
 local function fail(error)return {success=false,error=error}end
 if p.mode=='off' then selections[src]=nil;return {success=true} end
 if not Config.CustomText.Enabled or not R.canUse(src) or Config.CustomText.StaffOnly and not R.admin(src) then return fail('Custom tape wording is not available to you.') end
 local text,err
 if p.mode~='clear' then text,err=validate(p.text);if not text then return fail(err) end end
 if p.mode=='select' and text and not fits(text) then return fail('Custom wording limit reached. Reuse existing wording or clear a custom span.') end
 if p.mode=='select' then selections[src]=text;return {success=true,text=text} end
 if p.mode~='apply' and p.mode~='clear' then return fail('Unknown custom wording action.') end
 local t=R.tapes[tonumber(p.id)]
 if not t or not R.editable(src,t) or t.brokenAt then return fail('Move close to intact tape you may edit.') end
 if text and not fits(text,t.id) then return fail('Custom wording limit reached. Reuse existing wording or clear a custom span.') end
 t.customText=text;t.revision=(t.revision or 0)+1
 R.dirty();R.emit(t.bucket,'apex_policetape:add',R.public(t))
 TapeServices.audit('custom_wording',src,{id=t.id,cleared=text==nil})
 return {success=true,text=text}
end
AddEventHandler('playerDropped',function()selections[source]=nil end)
