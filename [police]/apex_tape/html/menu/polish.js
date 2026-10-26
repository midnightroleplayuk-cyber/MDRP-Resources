// Accessibility prompt is separate from the existing tape/scene panel layout.
const tapePrompt=document.createElement('div');
tapePrompt.hidden=true;
tapePrompt.setAttribute('role','status');tapePrompt.setAttribute('aria-live','polite');
Object.assign(tapePrompt.style,{position:'fixed',right:'3vw',top:'40vh',maxWidth:'36vw',padding:'12px 16px',borderRadius:'10px',background:'rgba(13,19,27,.96)',color:'#fff',fontFamily:'Segoe UI,sans-serif',lineHeight:'1.5',pointerEvents:'none',whiteSpace:'pre-wrap',transformOrigin:'right center'});
document.body.append(tapePrompt);
window.addEventListener('message',event=>{const d=event.data;if(d?.action!=='polishPrompt')return;tapePrompt.textContent=typeof d.text==='string'?d.text:'';tapePrompt.hidden=!d.text;const scale=Math.max(1,Math.min(1.6,Number(d.scale)||1));tapePrompt.style.fontSize=`${14*scale}px`;});
