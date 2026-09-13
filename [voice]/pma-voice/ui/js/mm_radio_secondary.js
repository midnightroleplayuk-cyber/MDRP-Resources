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

    // Play the exact pma-voice click assets independently of Primary radio state.
    // pma's standard UI lives in this same resource, so these resolve to ui/audio_on.ogg
    // and ui/audio_off.ogg just like its normal radio clicks.
    if(d.mmSecondaryClick==='audio_on' || d.mmSecondaryClick==='audio_off'){
      try {
        const click = new Audio(`${d.mmSecondaryClick}.ogg`);
        const vol = Number(d.mmSecondaryClickVolume);
        click.volume = Number.isFinite(vol) ? Math.max(0, Math.min(1, vol)) : (d.mmSecondaryClick==='audio_on' ? 0.10 : 0.03);
        click.play().catch(()=>{});
      } catch (_) {}
    }
    render();
  });
  setInterval(render,500);
})();