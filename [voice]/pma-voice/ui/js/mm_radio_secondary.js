(() => {
  let channel = 0, talking = false;
  let el;
  function ensure(){
    const voiceInfo=document.querySelector('.voiceInfo');
    if(!voiceInfo) return null;
    if(!el){
      el=document.createElement('p'); el.id='mm-secondary-radio';
      voiceInfo.appendChild(el);
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