const app = document.getElementById('app');
const grid = document.getElementById('grid');
const bonus = document.getElementById('bonus');
const statusEl = document.getElementById('status');
const priceEl = document.getElementById('price');
let card = null;
let panels = [];
let scratchReported = false;

const REVEAL_THRESHOLD = 0.58;
const resource = typeof GetParentResourceName === 'function' ? GetParentResourceName() : 'hf1_scratchcard';
const post = (name, data={}) => fetch(`https://${resource}/${name}`, {method:'POST',headers:{'Content-Type':'application/json'},body:JSON.stringify(data)});
const pounds = n => `£${Number(n).toLocaleString('en-GB')}`;

function silver(ctx,w,h){
  ctx.clearRect(0,0,w,h);
  const g=ctx.createLinearGradient(0,0,w,h);g.addColorStop(0,'#b8bec5');g.addColorStop(.5,'#e8ecef');g.addColorStop(1,'#9ba3aa');ctx.fillStyle=g;ctx.fillRect(0,0,w,h);
  ctx.fillStyle='rgba(70,80,90,.25)';for(let i=0;i<90;i++){ctx.fillRect(Math.random()*w,Math.random()*h,Math.random()*10+2,1)}
  ctx.fillStyle='rgba(25,35,50,.65)';ctx.font='bold 13px Arial';ctx.textAlign='center';ctx.fillText('SCRATCH',w/2,h/2+5);
}

function reportComplete(){
  if (scratchReported || !panels.every(Boolean) || !card) return;
  scratchReported = true;
  statusEl.textContent='Card revealed. Take it to a scratchcard stand and choose Claim Winnings.';
  post('markScratched', { slot: card.slot, cardId: card.cardId });
}

function makeScratch(el,index){
  const canvas=el.querySelector('canvas'); const rect=el.getBoundingClientRect(); const ratio=window.devicePixelRatio||1;
  canvas.width=Math.round(rect.width*ratio);canvas.height=Math.round(rect.height*ratio);
  const ctx=canvas.getContext('2d');ctx.scale(ratio,ratio);silver(ctx,rect.width,rect.height);ctx.globalCompositeOperation='destination-out';ctx.lineWidth=28;ctx.lineCap='round';
  let down=false,last=null,thresholdReached=false;

  const check=()=>{
    if (thresholdReached) return;
    const raw=ctx.getImageData(0,0,canvas.width,canvas.height).data;
    let clear=0,sampled=0;
    for(let i=3;i<raw.length;i+=16){sampled++;if(raw[i]<40)clear++;}
    if(sampled && (clear/sampled)>=REVEAL_THRESHOLD){
      thresholdReached=true;
      panels[index]=true;
      reportComplete();
    }
  };

  // Reaching 58% only marks this panel as revealed. It deliberately does not
  // clear the canvas or stop scratching, so the remaining foil never "pops" away.
  const scratch=e=>{if(!down)return;const r=canvas.getBoundingClientRect();const p=e.touches?e.touches[0]:e;const x=p.clientX-r.left,y=p.clientY-r.top;ctx.beginPath();if(last)ctx.moveTo(last.x,last.y);else ctx.moveTo(x,y);ctx.lineTo(x,y);ctx.stroke();last={x,y};check();};
  canvas.addEventListener('pointerdown',e=>{down=true;last=null;canvas.setPointerCapture(e.pointerId);scratch(e)});
  canvas.addEventListener('pointermove',scratch);
  canvas.addEventListener('pointerup',()=>{down=false;last=null});
  canvas.addEventListener('pointercancel',()=>{down=false;last=null});
}

function openCard(data){
  card=data;scratchReported=false;panels=new Array(10).fill(false);grid.innerHTML='';priceEl.textContent=pounds(data.price);statusEl.textContent='Scratch every panel, then claim the physical card at a scratchcard stand.';
  data.grid.forEach((amount,i)=>{const el=document.createElement('div');el.className='scratch';el.innerHTML=`<span class="value">${pounds(amount)}</span><canvas></canvas>`;grid.appendChild(el);requestAnimationFrame(()=>makeScratch(el,i));});
  bonus.querySelector('.value').textContent=data.bonus;requestAnimationFrame(()=>makeScratch(bonus,9));app.classList.remove('hidden');
}
window.addEventListener('message',e=>{const d=e.data;if(d.action==='open')openCard(d.card);if(d.action==='close')app.classList.add('hidden');});
document.getElementById('close').addEventListener('click',()=>post('close'));
document.addEventListener('keydown',e=>{if(e.key==='Escape')post('close')});
