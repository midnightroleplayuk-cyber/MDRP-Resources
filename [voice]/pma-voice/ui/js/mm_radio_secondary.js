(() => {
  let channel = 0, talking = false;
  let el;
  function ensure(){
    const voiceInfo=document.querySelector('.voiceInfo');
    if(!voiceInfo) return null;
    if(!el){
      el=document.createElement('p'); el.id='mm-secondary-radio';
    }
    // Keep Secondary directly above Primary Radio (and therefore above Local Proximity).
    // Vue can recreate its own <p> nodes, so this is deliberately re-applied on render.
    const children=[...voiceInfo.querySelectorAll(':scope > p:not(#mm-secondary-radio)')];
    const primary=children.find(p=>/\[Radio\]/i.test(p.textContent||''));
    const proximity=children.find(p=>/\[Range\]/i.test(p.textContent||''));
    const anchor=primary || proximity || children[0] || null;
    if(el.parentElement!==voiceInfo || el.nextSibling!==anchor){
      voiceInfo.insertBefore(el, anchor);
    }
    return el;
  }
  function render(){
    const node=ensure(); if(!node) return;
    node.style.display=channel>0?'block':'none';
    node.classList.toggle('talking',talking);
    node.textContent=channel>0?`${channel} Mhz [Secondary]`:'';
  }
  window.addEventListener('message',e=>{
    const d=e.data||{};
    if(d.secondaryRadioChannel!==undefined) channel=Number(d.secondaryRadioChannel)||0;
    if(d.usingSecondaryRadio!==undefined) talking=!!d.usingSecondaryRadio;
    render();
  });
  setInterval(render,500);
})();