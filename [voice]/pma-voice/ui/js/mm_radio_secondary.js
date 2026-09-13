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
  // Dedicated Secondary-only mic-click fallback. This is used when Primary is
  // disconnected, because pma-voice may have its normal radio UI path disabled.
  const secondaryClickAudio = {
    audio_on: new Audio('audio_on.ogg'),
    audio_off: new Audio('audio_off.ogg')
  };
  function playSecondaryClick(kind, volume){
    const base = secondaryClickAudio[kind];
    if(!base) return;
    try {
      const audio = base.cloneNode(true);
      audio.volume = Math.max(0, Math.min(1, Number(volume) || 0));
      audio.play().catch(()=>{});
    } catch(_) {}
  }
  window.addEventListener('message',e=>{
    const d=e.data||{};
    if(d.secondaryRadioChannel!==undefined) channel=Number(d.secondaryRadioChannel)||0;
    if(d.usingSecondaryRadio!==undefined) talking=!!d.usingSecondaryRadio;
    if(d.mmSecondaryMicClick) playSecondaryClick(d.mmSecondaryMicClick, d.mmSecondaryMicClickVolume);
    render();
  });
  setInterval(render,500);
})();