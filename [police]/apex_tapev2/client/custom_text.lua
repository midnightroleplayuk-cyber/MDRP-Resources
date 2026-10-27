TapeCustomTextClient={}
local C=TapeCustomTextClient
local selected,slots=nil,{}
function C.selected()return selected end
local function nearest()
 local pos=GetEntityCoords(PlayerPedId());local best,distance=nil,Config.EditReach
 for id,t in pairs(TapeClient.tapes()) do
  if not t.brokenAt then
   local a,b=TapeClient.liveEnds(t);local q=TapeContactMath.nearest(pos,a,b)
   local d=TapeGeometry.distance(pos,q)
   if d<distance then best,distance=id,d end
  end
 end
 return best
end
local function keyboard()
 if TapeClient.closePanels then TapeClient.closePanels() end
 AddTextEntry('APEX_CUSTOM_WORDING',('Custom tape wording (max %d characters)'):format(Config.CustomText.MaxLength))
 DisplayOnscreenKeyboard(1,'APEX_CUSTOM_WORDING','',selected or '','','','',Config.CustomText.MaxLength)
 while UpdateOnscreenKeyboard()==0 do DisableAllControlActions(0);Wait(0) end
 if UpdateOnscreenKeyboard()==1 then return GetOnscreenKeyboardResult() end
end
function C.command(args,quiet)
 if not Config.CustomText.Enabled and args[1]~='off' then TapeClient.notify('Custom wording is disabled.','error');return end
 local first=args[1];local mode='select';local text
 if first=='off' then mode='off'
 elseif first=='clear' then mode='clear'
 elseif first=='apply' then mode='apply';text=table.concat(args,' ',2)
 else text=table.concat(args,' ') end
 local id
 if mode=='apply' or mode=='clear' then
  id=nearest();if not id then TapeClient.notify('Move beside intact tape to edit its wording.','error');return end
 end
 if mode=='select' or mode=='apply' then
  if text=='' then text=keyboard() end
  if not text or text=='' then return end
 end
 local result=TapeClient.accessAction('custom_text',{mode=mode,text=text,id=id})
 if result then
  if mode=='select' then selected=result.text elseif mode=='off' then selected=nil end
  if not quiet then TapeClient.notify(mode=='select' and 'Custom text tape selected. Choosing a standard design restores its UK print.' or mode=='off' and 'New tape uses standard designs.' or 'Tape wording updated.') end
  if result.text then TapeClient.notify('Custom wording is live gameplay text; use a shipped design for Rockstar Editor recording.','inform') end
  return true
 end
 return false
end
function C.texture(text)
 if type(text)~='string' then return end
 local now=GetGameTimer()
 for _,r in pairs(slots) do if r.text==text then r.used=now;if r.ready then DrawSprite(r.dict,'wording',0,0,.001,.001,0,255,255,255,1);return r.dict,'wording' end;return end end
 local index
 for i=1,Config.CustomText.MaxUnique+1 do
  if not slots[i] then index=i;break end
  if now-slots[i].used>10000 then DestroyDui(slots[i].dui);slots[i]=nil;index=i;break end
 end
 if not index then return end
 local dict='apex_custom_wording_'..index
 local dui=CreateDui(('https://cfx-nui-%s/html/custom_tape.html'):format(GetCurrentResourceName()),2048,128)
 if not dui or dui==0 then return end
 slots[index]={dui=dui,text=text,dict=dict,txd=CreateRuntimeTxd(dict),used=now,sent=-1000}
end
CreateThread(function()
 while true do
  local now=GetGameTimer()
  for i,r in pairs(slots) do
   if now-r.used>15000 then DestroyDui(r.dui);slots[i]=nil
   elseif IsDuiAvailable(r.dui) then
    if not r.ready then local handle=CreateRuntimeTextureFromDuiHandle(r.txd,'wording',GetDuiHandle(r.dui));r.ready=handle~=nil and handle~=false and handle~=0 end
    if now-r.sent>=1000 then
     SendDuiMessage(r.dui,json.encode({text=r.text,background=Config.CustomText.Background,foreground=Config.CustomText.Foreground}));r.sent=now
    end
   end
  end
  Wait(200)
 end
end)
AddEventHandler('onResourceStop',function(name)
 if name==GetCurrentResourceName() then for _,r in pairs(slots) do DestroyDui(r.dui) end;slots={} end
end)
