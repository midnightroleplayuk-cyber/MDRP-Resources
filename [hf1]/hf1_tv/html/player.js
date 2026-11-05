const screen=document.getElementById('screen'), status=document.getElementById('status');
let media=null, volume=35, youtubeFrame=null, youtubeReady=false, youtubeQueue=[];
let youtubeRetry=null, audioRequested=true;
// Prefer audible autoplay. Browsers may still deny it; the menu retains manual unmute.
function attemptYoutubeSound(){
  if(!youtubeFrame || !audioRequested)return;
  ytCommand('setVolume',[volume]);
  ytCommand('unMute');
  ytCommand('playVideo');
}
function ytCommand(func,args=[]){
  if(!youtubeFrame)return;
  const command=JSON.stringify({event:'command',func,args});
  try { youtubeFrame.contentWindow.postMessage(command,'https://www.youtube.com'); }
  catch(e){show('YouTube command failed: '+e.message)}
}
function ytAudio(enable){
  if(!youtubeFrame)return;
  ytCommand('setVolume',[Math.max(0,Math.min(100,volume))]);
  ytCommand(enable?'unMute':'mute');
  if(enable)ytCommand('playVideo');
}
window.addEventListener('message', e=>{
  if(e.origin!=='https://www.youtube.com' && e.origin!=='https://www.youtube-nocookie.com')return;
  let data=e.data;
  try{if(typeof data==='string')data=JSON.parse(data)}catch{return}
  if(data?.event==='onReady'||data?.event==='initialDelivery'){
    youtubeReady=true;
    if(youtubeFrame){attemptYoutubeSound();show('YouTube loaded • attempting audio automatically (use TV menu if silent)');}
  }
});
function show(text){status.textContent=text;status.style.display='block'}
function iframe(src,allow='autoplay; encrypted-media; fullscreen; picture-in-picture'){const f=document.createElement('iframe');f.src=src;f.allow=allow;f.referrerPolicy='strict-origin-when-cross-origin';f.allowFullscreen=true;screen.append(f);media=f;return f}
function youtubeId(url){try{const u=new URL(url);let id=u.hostname==='youtu.be'?u.pathname.slice(1):u.searchParams.get('v');if(!id){const m=u.pathname.match(/^\/(?:shorts|live|embed)\/([^/?]+)/);id=m?.[1]}return /^[\w-]{11}$/.test(id||'')?id:null}catch{return null}}
function play(d){if(youtubeRetry)clearInterval(youtubeRetry);youtubeRetry=null;youtubeFrame=null;youtubeReady=false;screen.replaceChildren();media=null;volume=Number(d.volume??35);audioRequested=true;if(d.kind==='test'){const t=document.createElement('div');t.className='bars';t.innerHTML='<b>HF1 TV TEST OK</b>';screen.append(t);show('Test pattern');return}
try{
const u=new URL(d.url);if(u.protocol!=='https:')throw Error('HTTPS only');
if(d.kind==='youtube'){
const id=youtubeId(d.url);if(!id)throw Error('Invalid YouTube video URL');
// Use the server-provided wall clock, not the browser clock (which may differ).
const now=Number(d.now), started=Number(d.started);
const elapsed=Number.isFinite(now)&&Number.isFinite(started)?Math.max(0,Math.floor(now-started)):0;
// FiveM's cfx-nui:// origin is not a public YouTube embed origin. Avoid passing it
// as the origin parameter. The youtube.com embed is the supported iframe endpoint.
const p=new URLSearchParams({autoplay:'1',mute:'0',controls:'1',playsinline:'1',start:String(elapsed),rel:'0',enablejsapi:'1'});
const f=iframe(`https://www.youtube.com/embed/${id}?${p}`);
youtubeFrame=f;
// The iframe API accepts postMessage commands even when the full JS API script
// cannot be loaded in FiveM CEF. Retry while the embed initializes.
let attempts=0;
youtubeRetry=setInterval(()=>{
  if(youtubeFrame!==f||++attempts>12){clearInterval(youtubeRetry);youtubeRetry=null;return}
  ytCommand('addEventListener',['onReady']);
  attemptYoutubeSound();
},1000);
show('YouTube: loading video '+id+' (sound requested)');
f.addEventListener('load',()=>show('YouTube embed loaded — if blank, video may block embedding or FiveM CEF playback'));
f.addEventListener('error',()=>show('YouTube iframe failed to load'));
}else if(d.kind==='video'){
const v=document.createElement('video');v.autoplay=true;v.controls=false;v.playsInline=true;v.src=d.url;v.volume=Math.max(0,Math.min(1,volume/100));screen.append(v);media=v;
v.addEventListener('loadedmetadata',()=>{if(Number.isFinite(v.duration)&&v.duration>0){const elapsed=Math.max(0,Number(d.now||0)-Number(d.started||0));v.currentTime=Math.min(elapsed,Math.max(0,v.duration-.2))}v.play().catch(()=>{v.muted=true;v.play().catch(()=>show('Autoplay blocked by browser'))})});v.addEventListener('error',()=>show('Direct video failed: check CORS, codec and URL'));show('Direct video');
}else if(d.kind==='twitch'){
let parts=u.pathname.split('/').filter(Boolean), channel=parts[0];if(!channel)throw Error('Invalid Twitch URL');
const parent=location.hostname;
const params=new URLSearchParams({parent,autoplay:'true',muted:'true'});
if(parts[0]==='videos'&&parts[1])params.set('video',parts[1]);else params.set('channel',channel);
iframe('https://player.twitch.tv/?'+params);show('Twitch • requires accepted embed parent domain');
}else if(d.kind==='tiktok'){
const match=u.pathname.match(/\/video\/(\d+)/);
if(match){iframe(`https://www.tiktok.com/embed/v2/${match[1]}`);show('TikTok video • embed restrictions may apply')}
else {iframe(d.url);show('TikTok Live • may be blocked by TikTok')}
}else if(d.kind==='website'){iframe(d.url);show('Website • sites may deny iframe embedding')}
else throw Error('Unsupported type');
}catch(e){show('Cannot load: '+e.message)}
}
window.addEventListener('message',e=>{let d=e.data||{};if(d.action==='play')play(d);if(d.action==='volume'){volume=Math.max(0,Math.min(100,Number(d.volume||0)));if(media?.tagName==='VIDEO')media.volume=volume/100;if(youtubeFrame)ytCommand('setVolume',[volume])}if(d.action==='audio'){if(Number.isFinite(Number(d.volume)))volume=Math.max(0,Math.min(100,Number(d.volume)));if(youtubeFrame){audioRequested=d.enabled!==false;ytAudio(audioRequested);show(d.enabled!==false?'YouTube: audio requested • if silent, CEF may block autoplay sound':'YouTube: muted')}else if(media?.tagName==='VIDEO'){media.volume=volume/100;media.muted=d.enabled===false;media.play().catch(()=>{})}}});

// Load the initial command after the document script is ready, avoiding DUI message races.
try {
  const initial = decodeURIComponent(location.hash.slice(1));
  if (initial) {
    const data = JSON.parse(initial);
    if (data.action === 'play') play(data);
  }
} catch (e) { show('Player initialization error: ' + e.message); }
