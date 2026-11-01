const s=n=>{const r=n.map(e=>({...e}));r.sort((e,o)=>{const a=Number(e.elo),t=Number(o.elo);return(isNaN(t)?0:t)-(isNaN(a)?0:a)});for(let e=0;e<r.length;e++)r[e].ranking=e+1;return r};export{s as g};
