const screen=document.getElementById('screen'), status=document.getElementById('status');
let media=null, volume=35, youtubeFrame=null, youtubeReady=false, youtubeQueue=[];
let youtubeRetry=null, audioRequested=true, youtubeAudioInitialized=false, mutedByController=false;
let twitchFrame=null, twitchTimeout=null;
const TWITCH_HOST='https://hf1-tv-twitch.pages.dev';
function twitchCommand(){
  if(!twitchFrame)return;
  const desired=Math.max(0,Math.min(100,volume));
  const muted=mutedByController || !audioRequested || desired===0;
  try{twitchFrame.contentWindow.postMessage({hf1tv:'audio',volume:desired,muted},TWITCH_HOST)}catch(e){show('Twitch audio command error: '+e.message)}
}

let hlsInstance=null, hlsLoadPromise=null;
function destroyHls(){if(hlsInstance){try{hlsInstance.destroy()}catch(e){} hlsInstance=null}}
function loadHls(){
  if(window.Hls)return Promise.resolve(window.Hls);
  if(hlsLoadPromise)return hlsLoadPromise;
  // This test uses an external library CDN; it must be reachable from FiveM CEF.
  hlsLoadPromise=new Promise((resolve,reject)=>{
    const tag=document.createElement('script');
    const timeout=setTimeout(()=>reject(Error('HLS.js CDN timed out (CEF network or CSP)')),12000);
    tag.src='https://cdn.jsdelivr.net/npm/hls.js@1.6.13/dist/hls.min.js';
    tag.onload=()=>{clearTimeout(timeout);window.Hls?resolve(window.Hls):reject(Error('HLS.js loaded but unavailable'))};
    tag.onerror=()=>{clearTimeout(timeout);reject(Error('Cannot load HLS.js CDN in CEF'))};
    document.head.appendChild(tag);
  }).catch(err=>{hlsLoadPromise=null;throw err});
  return hlsLoadPromise;
}
function playHlsVideo(v,d){
  show('HLS.js: loading library...');
  loadHls().then(Hls=>{
    if(media!==v)return;
    if(!Hls.isSupported()){
      show('HLS.js: MediaSource unsupported in this FiveM CEF build');
      return;
    }
    show('HLS.js: MSE supported, loading playlist...');
    const hls=new Hls({enableWorker:false,lowLatencyMode:true});hlsInstance=hls;
    hls.on(Hls.Events.ERROR,(_,data)=>{
      if(media!==v)return;
      const reason=(data.details||data.type||'unknown');
      show('HLS.js: '+reason+(data.fatal?' (fatal)':'')+' • check CORS/URL/codec');
      if(data.fatal){if(data.type===Hls.ErrorTypes.MEDIA_ERROR){try{hls.recoverMediaError()}catch(e){}}else{hls.destroy();if(hlsInstance===hls)hlsInstance=null}}
    });
    hls.on(Hls.Events.MANIFEST_PARSED,()=>{
      if(media!==v)return;
      show('HLS.js: playlist parsed; starting video');
      v.play().catch(e=>show('HLS.js: play blocked: '+e.message));
    });
    hls.attachMedia(v);
    hls.on(Hls.Events.MEDIA_ATTACHED,()=>{if(media===v)hls.loadSource(d.url)});
  }).catch(e=>{if(media===v)show('HLS.js unavailable: '+e.message)});
}
// Prefer audible autoplay. Browsers may still deny it; the menu retains manual unmute.
function attemptYoutubeSound(){
  if(!youtubeFrame)return;
  // Never allow the iframe's default 100% audio to escape: embed starts muted.
  // Apply desired volume first, then unmute, then play.
  ytCommand('setVolume',[Math.max(0,Math.min(100,volume))]);
  ytCommand(volume===0 || mutedByController || !audioRequested ? 'mute' : 'unMute');
  ytCommand('playVideo');
  youtubeAudioInitialized=true;
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
function play(d){destroyHls();if(youtubeRetry)clearInterval(youtubeRetry);if(twitchTimeout)clearTimeout(twitchTimeout);twitchTimeout=null;twitchFrame=null;youtubeRetry=null;youtubeFrame=null;youtubeReady=false;youtubeAudioInitialized=false;screen.replaceChildren();media=null;volume=Math.max(0,Math.min(100,Number(d.initialVolume ?? d.volume ?? 35)||0));audioRequested=true;mutedByController=d.initialMuted===true || volume===0;if(d.kind==='test'){const t=document.createElement('div');t.className='bars';t.innerHTML='<b>HF1 TV TEST OK</b>';screen.append(t);show('Test pattern');return}
try{
const u=new URL(d.url);if(u.protocol!=='https:')throw Error('HTTPS only');
if(d.kind==='youtube'){
const id=youtubeId(d.url);if(!id)throw Error('Invalid YouTube video URL');
// Use the server-provided wall clock, not the browser clock (which may differ).
const now=Number(d.now), started=Number(d.started);
const elapsed=Number.isFinite(now)&&Number.isFinite(started)?Math.max(0,Math.floor(now-started)):0;
// FiveM's cfx-nui:// origin is not a public YouTube embed origin. Avoid passing it
// as the origin parameter. The youtube.com embed is the supported iframe endpoint.
const p=new URLSearchParams({autoplay:'1',mute:'1',controls:'1',playsinline:'1',start:String(elapsed),rel:'0',enablejsapi:'1'});
const f=iframe(`https://www.youtube.com/embed/${id}?${p}`);
youtubeFrame=f;
// The iframe API accepts postMessage commands even when the full JS API script
// cannot be loaded in FiveM CEF. Retry while the embed initializes.
let attempts=0;
youtubeRetry=setInterval(()=>{
  if(youtubeFrame!==f||++attempts>12){clearInterval(youtubeRetry);youtubeRetry=null;return}
  ytCommand('addEventListener',['onReady']);
  // Repeat the requested state while the iframe initializes. Early postMessages can be lost.
  attemptYoutubeSound();
},1000);
show('YouTube: loading video '+id+' (sound requested)');
f.addEventListener('load',()=>show('YouTube embed loaded — if blank, video may block embedding or FiveM CEF playback'));
f.addEventListener('error',()=>show('YouTube iframe failed to load'));
}else if(d.kind==='video'||d.kind==='hls'){
const v=document.createElement('video');v.autoplay=true;v.controls=false;v.playsInline=true;v.volume=0;v.muted=true;if(d.kind!=='hls')v.src=d.url;screen.append(v);media=v;
v.addEventListener('loadedmetadata',()=>{if(Number.isFinite(v.duration)&&v.duration>0){const elapsed=Math.max(0,Number(d.now||0)-Number(d.started||0));v.currentTime=Math.min(elapsed,Math.max(0,v.duration-.2))}v.play().catch(()=>{v.muted=true;v.play().catch(()=>show('Autoplay blocked by browser'))})});v.addEventListener('error',()=>{const code=v.error?.code||'unknown';show((d.kind==='hls'?'HLS':'Direct video')+' failed: media error '+code+' • check CEF HLS support, CORS, codec and authorization')});v.addEventListener('stalled',()=>show('Video stalled • check network and playlist segments'));v.addEventListener('playing',()=>{v.volume=volume/100;v.muted=mutedByController;show((d.kind==='hls'?'HLS.js':'Direct video')+' playing')});if(d.kind==='hls')playHlsVideo(v,d);else show('Direct video');
 }else if(d.kind==='twitch'){
// Twitch is hosted on the real HTTPS origin; the hosted page owns the Twitch API.
const host=u.hostname.toLowerCase();
if(!['twitch.tv','www.twitch.tv','m.twitch.tv'].includes(host))throw Error('Use a twitch.tv channel or VOD URL');
const parts=u.pathname.split('/').filter(Boolean);
const params=new URLSearchParams();
if(parts[0]==='videos' && /^\d+$/.test(parts[1]||''))params.set('video',parts[1]);
else if(parts[0] && /^[a-zA-Z0-9_]{2,25}$/.test(parts[0]))params.set('channel',parts[0]);
else throw Error('Invalid Twitch channel or VOD URL');
params.set('volume',String(volume));
params.set('muted',String(mutedByController || volume===0));
const f=iframe(TWITCH_HOST+'/?'+params.toString());
twitchFrame=f;
show('Twitch: loading hosted HTTPS player • waiting for playback');
f.addEventListener('load',()=>{if(twitchFrame===f){show('Twitch: hosted page loaded • requesting audio');twitchCommand();}});
f.addEventListener('error',()=>show('Twitch hosted page failed to load'));
// Retry during initialization: the Twitch API can take time to become ready.
let retries=0;
const retry=setInterval(()=>{if(twitchFrame!==f || ++retries>30){clearInterval(retry);return}twitchCommand()},1000);
twitchTimeout=setTimeout(()=>{if(twitchFrame===f)show('Twitch: hosted page loaded; if video is blank, nested embed may be blocked by Twitch')},16000);
}else if(d.kind==='tiktok'){
const match=u.pathname.match(/\/video\/(\d+)/);
if(match){iframe(`https://www.tiktok.com/embed/v2/${match[1]}`);show('TikTok video • embed restrictions may apply')}
else {iframe(d.url);show('TikTok Live • may be blocked by TikTok')}
}else if(d.kind==='website'){iframe(d.url);show('Website • sites may deny iframe embedding')}
else throw Error('Unsupported type');
}catch(e){show('Cannot load: '+e.message)}
}
window.addEventListener('message',e=>{if(e.origin===TWITCH_HOST && e.data?.hf1tv==='status' && twitchFrame){show('Twitch: '+String(e.data.message||'ready').slice(0,160));return}let d=e.data||{};if(d.action==='play')play(d);if(d.action==='volume'){volume=Math.max(0,Math.min(100,Number(d.volume||0)));mutedByController=d.muted===true;if(media?.tagName==='VIDEO'){media.volume=volume/100;media.muted=mutedByController;}if(youtubeFrame){attemptYoutubeSound()}if(twitchFrame)twitchCommand()}if(d.action==='audio'){if(Number.isFinite(Number(d.volume)))volume=Math.max(0,Math.min(100,Number(d.volume)));if(twitchFrame){audioRequested=d.enabled!==false;twitchCommand()}if(youtubeFrame){audioRequested=d.enabled!==false;ytAudio(audioRequested && !mutedByController && volume>0);show(d.enabled!==false?'YouTube: audio requested • if silent, CEF may block autoplay sound':'YouTube: muted')}else if(media?.tagName==='VIDEO'){media.volume=volume/100;media.muted=d.enabled===false;media.play().catch(()=>{})}}});

// Load the initial command after the document script is ready, avoiding DUI message races.
try {
  const initial = decodeURIComponent(location.hash.slice(1));
  if (initial) {
    const data = JSON.parse(initial);
    if (data.action === 'play') play(data);
  }
} catch (e) { show('Player initialization error: ' + e.message); }
