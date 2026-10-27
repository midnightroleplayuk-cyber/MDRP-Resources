// Scene names and player labels are rendered as text, never HTML.
const sceneApp=document.createElement('div');sceneApp.id='sceneApp';sceneApp.hidden=true;document.body.append(sceneApp);
const sceneCss=document.createElement('style');sceneCss.textContent=`#sceneApp[hidden]{display:none}#sceneApp{position:absolute;inset:0;display:grid;place-items:center}.scene-panel{width:min(1080px,95vw)}.scene-tools{display:flex;gap:8px;align-items:center;flex-wrap:wrap}.scene-tools input{margin:0;flex:1;min-width:160px}.scene-tools button,.scene-row button,.scene-row select{background:#263443;color:#fff;border:1px solid #4b5e72;border-radius:6px;padding:8px}.scene-list{overflow:auto;min-height:100px;margin-top:18px}.scene-row{padding:16px;background:#17212d;border:1px solid #344151;border-radius:10px;margin-bottom:10px}.scene-row h2{font-size:16px;margin:0 0 6px}.scene-row p{margin:0 0 12px;font-size:12px}.scene-row .actions{display:flex;gap:8px;flex-wrap:wrap}.scene-row input{width:160px;margin:0;padding:8px}.scene-row .expiry{width:85px}.scene-status{min-height:22px;margin:10px 0 0;color:#e6c05d}.danger-button{border-color:#b96c6c!important}.scene-row.active{border-color:#e6c05d}`;document.head.append(sceneCss);
let sceneData={scenes:[],styles:{}},sceneBusy=false,sceneArmed='';
function sceneElement(tag,text,className){const el=document.createElement(tag);if(text!==undefined)el.textContent=uiText(text);if(className)el.className=className;return el;}
function sceneButton(label,action,parent,className){const el=sceneElement('button',label,className);el.type='button';el.onclick=action;parent.append(el);return el;}
async function sceneSend(action,payload={}){
 if(sceneBusy)return;sceneBusy=true;
 const status=document.getElementById('sceneStatus');if(status)status.textContent=uiText('Updating…');
 try{const response=await post('sceneAction',{action,...payload});const result=await response.json();if(status)status.textContent=uiText(result.ok?'Updated.':'Action rejected. Check the game notification.');}
 catch(error){if(status)status.textContent=uiText('Request failed. Try again.');}
 finally{sceneBusy=false;}
}
function sceneConfirm(action,id){const key=action+':'+id;if(sceneArmed===key){sceneArmed='';sceneSend(action,{sceneId:id});}else{sceneArmed=key;sceneRender();}}
function sceneRender(){
 sceneApp.replaceChildren();
 const panel=sceneElement('section',undefined,'panel scene-panel');panel.setAttribute('role','dialog');panel.setAttribute('aria-modal','true');panel.setAttribute('aria-label','Tape scenes');
 const header=sceneElement('header'),titles=sceneElement('div');titles.append(sceneElement('div','APEX / SCENE CONTROL','eyebrow'),sceneElement('h1',sceneData.admin?'Admin scene panel':'My tape scenes'));
 header.append(titles);sceneButton('×',sceneClose,header,'close').setAttribute('aria-label','Close scenes');panel.append(header);
 panel.append(sceneElement('p',`${uiText('Active scene:')} ${sceneData.active||uiText('none')} · ${uiText(sceneData.admin?'Showing scenes across all buckets.':'Showing scenes you can manage in this bucket.')}`));
 const tools=sceneElement('div',undefined,'scene-tools'),name=sceneElement('input');name.placeholder=uiText('New scene name');name.maxLength=48;name.setAttribute('aria-label','New scene name');tools.append(name);
 sceneButton('Create',()=>sceneSend('new',{name:name.value}),tools);sceneButton('Refresh',()=>sceneSend('refresh'),tools);sceneButton('Undo last clear',()=>sceneSend('recover'),tools);panel.append(tools);
 const status=sceneElement('div','','scene-status');status.id='sceneStatus';status.setAttribute('role','status');panel.append(status);
 const list=sceneElement('div',undefined,'scene-list');
 for(const scene of sceneData.scenes){
  const row=sceneElement('article',undefined,'scene-row'+(scene.id===sceneData.active?' active':''));
  row.append(sceneElement('h2',`#${scene.id} · ${scene.name}`));
  const age=Math.max(0,Math.floor((Date.now()/1000-scene.createdAt)/60));
  const expiry=scene.expiresAt?`${Math.max(0,Math.ceil((scene.expiresAt-Date.now()/1000)/60))} ${uiText('min left')}`:uiText('no scene expiry');
  row.append(sceneElement('p',`${scene.ownerName||uiText('Offline')}${scene.department?' / '+scene.department:''} · ${uiText('bucket')} ${scene.bucket} · ${scene.count} ${uiText('spans')} / ${scene.broken} ${uiText('torn')} · ${age} ${uiText('min old')} · ${expiry}`));
  const actions=sceneElement('div',undefined,'actions');
  sceneButton('Select',()=>sceneSend('select',{sceneId:scene.id}),actions);
  sceneButton('Waypoint',()=>sceneSend('waypoint',{sceneId:scene.id}),actions).disabled=!scene.center;
  const rename=sceneElement('input');rename.value=scene.name;rename.maxLength=48;rename.setAttribute('aria-label','Scene name');actions.append(rename);
  sceneButton('Rename',()=>sceneSend('rename',{sceneId:scene.id,name:rename.value}),actions);
  const styles=sceneElement('select');styles.setAttribute('aria-label','Scene tape design');
  for(const [id,style] of Object.entries(sceneData.styles)){if(style.enabled===false)continue;const option=sceneElement('option',style.label);option.value=id;styles.append(option);}actions.append(styles);
  sceneButton('Restyle',()=>sceneSend('style',{sceneId:scene.id,style:styles.value}),actions);
  const minutes=sceneElement('input',undefined,'expiry');minutes.type='number';minutes.min='0';minutes.max='10080';minutes.value='0';minutes.setAttribute('aria-label','Expiry in minutes; zero disables');actions.append(minutes);
  sceneButton('Set expiry',()=>sceneSend('expiry',{sceneId:scene.id,minutes:Number(minutes.value)}),actions);
  sceneButton(sceneArmed===`clear:${scene.id}`?'Confirm clear':'Clear tape',()=>sceneConfirm('clear',scene.id),actions,'danger-button');
  sceneButton(sceneArmed===`delete:${scene.id}`?'Confirm delete':'Delete scene',()=>sceneConfirm('delete',scene.id),actions,'danger-button');
  const recipient=sceneElement('input');recipient.placeholder=uiText('Player ID / department');recipient.maxLength=32;recipient.setAttribute('aria-label','Handover player ID or department');actions.append(recipient);
  sceneButton('Hand over',()=>{const value=recipient.value.trim();sceneSend('handover',{sceneId:scene.id,target:/^\d+$/.test(value)?Number(value):undefined,department:/^\d+$/.test(value)?undefined:value});},actions);
  row.append(actions);list.append(row);
 }
 if(!sceneData.scenes.length)list.append(sceneElement('p','No scenes to display. Create a scene, select it, then place tape or a perimeter.'));
 panel.append(list);sceneApp.append(panel);
}
async function sceneClose(){try{await post('closeScenes');sceneApp.hidden=true;}catch(e){}}
window.addEventListener('message',event=>{
 const data=event.data;if(!data||typeof data!=='object')return;
 if(data.action==='scenes'){uiLocale=data.locale||{};sceneData=data;sceneArmed='';sceneRender();sceneApp.hidden=false;sceneApp.querySelector('button').focus();}
 if(data.action==='closeScenes')sceneApp.hidden=true;
});
window.addEventListener('keydown',event=>{
 if(sceneApp.hidden)return;
 if(event.key==='Escape'){event.preventDefault();sceneClose();}
 if(event.key==='Tab'){
  const focusable=[...sceneApp.querySelectorAll('button,input,select')].filter(el=>!el.disabled),first=focusable[0],last=focusable[focusable.length-1];
  if(event.shiftKey&&document.activeElement===first){event.preventDefault();last.focus();}
  else if(!event.shiftKey&&document.activeElement===last){event.preventDefault();first.focus();}
 }
});
