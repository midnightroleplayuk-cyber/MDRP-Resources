function xc(n){const e=Object.create(null);for(const t of n.split(","))e[t]=1;return t=>t in e}const ot={},Cr=[],Gn=()=>{},ih=()=>!1,$o=n=>n.charCodeAt(0)===111&&n.charCodeAt(1)===110&&(n.charCodeAt(2)>122||n.charCodeAt(2)<97),Jo=n=>n.startsWith("onUpdate:"),wt=Object.assign,vc=(n,e)=>{const t=n.indexOf(e);t>-1&&n.splice(t,1)},Sp=Object.prototype.hasOwnProperty,at=(n,e)=>Sp.call(n,e),Oe=Array.isArray,Pr=n=>Rs(n)==="[object Map]",Qo=n=>Rs(n)==="[object Set]",ou=n=>Rs(n)==="[object Date]",Ge=n=>typeof n=="function",xt=n=>typeof n=="string",hn=n=>typeof n=="symbol",ct=n=>n!==null&&typeof n=="object",rh=n=>(ct(n)||Ge(n))&&Ge(n.then)&&Ge(n.catch),sh=Object.prototype.toString,Rs=n=>sh.call(n),Ep=n=>Rs(n).slice(8,-1),oh=n=>Rs(n)==="[object Object]",ea=n=>xt(n)&&n!=="NaN"&&n[0]!=="-"&&""+parseInt(n,10)===n,fs=xc(",key,ref,ref_for,ref_key,onVnodeBeforeMount,onVnodeMounted,onVnodeBeforeUpdate,onVnodeUpdated,onVnodeBeforeUnmount,onVnodeUnmounted"),ta=n=>{const e=Object.create(null);return(t=>e[t]||(e[t]=n(t)))},yp=/-\w/g,Zt=ta(n=>n.replace(yp,e=>e.slice(1).toUpperCase())),bp=/\B([A-Z])/g,di=ta(n=>n.replace(bp,"-$1").toLowerCase()),na=ta(n=>n.charAt(0).toUpperCase()+n.slice(1)),vo=ta(n=>n?`on${na(n)}`:""),Yt=(n,e)=>!Object.is(n,e),Mo=(n,...e)=>{for(let t=0;t<n.length;t++)n[t](...e)},ah=(n,e,t,i=!1)=>{Object.defineProperty(n,e,{configurable:!0,enumerable:!1,writable:i,value:t})},Mc=n=>{const e=parseFloat(n);return isNaN(e)?n:e},Tp=n=>{const e=xt(n)?Number(n):NaN;return isNaN(e)?n:e};let au;const ia=()=>au||(au=typeof globalThis<"u"?globalThis:typeof self<"u"?self:typeof window<"u"?window:typeof global<"u"?global:{});function ra(n){if(Oe(n)){const e={};for(let t=0;t<n.length;t++){const i=n[t],r=xt(i)?Cp(i):ra(i);if(r)for(const s in r)e[s]=r[s]}return e}else if(xt(n)||ct(n))return n}const Ap=/;(?![^(]*\))/g,wp=/:([^]+)/,Rp=/\/\*[^]*?\*\//g;function Cp(n){const e={};return n.replace(Rp,"").split(Ap).forEach(t=>{if(t){const i=t.split(wp);i.length>1&&(e[i[0].trim()]=i[1].trim())}}),e}function sa(n){let e="";if(xt(n))e=n;else if(Oe(n))for(let t=0;t<n.length;t++){const i=sa(n[t]);i&&(e+=i+" ")}else if(ct(n))for(const t in n)n[t]&&(e+=t+" ");return e.trim()}function WE(n){if(!n)return null;let{class:e,style:t}=n;return e&&!xt(e)&&(n.class=sa(e)),t&&(n.style=ra(t)),n}const Pp="itemscope,allowfullscreen,formnovalidate,ismap,nomodule,novalidate,readonly",Dp=xc(Pp);function lh(n){return!!n||n===""}function Ip(n,e){if(n.length!==e.length)return!1;let t=!0;for(let i=0;t&&i<n.length;i++)t=Cs(n[i],e[i]);return t}function Cs(n,e){if(n===e)return!0;let t=ou(n),i=ou(e);if(t||i)return t&&i?n.getTime()===e.getTime():!1;if(t=hn(n),i=hn(e),t||i)return n===e;if(t=Oe(n),i=Oe(e),t||i)return t&&i?Ip(n,e):!1;if(t=ct(n),i=ct(e),t||i){if(!t||!i)return!1;const r=Object.keys(n).length,s=Object.keys(e).length;if(r!==s)return!1;for(const o in n){const a=n.hasOwnProperty(o),l=e.hasOwnProperty(o);if(a&&!l||!a&&l||!Cs(n[o],e[o]))return!1}}return String(n)===String(e)}function ch(n,e){return n.findIndex(t=>Cs(t,e))}const uh=n=>!!(n&&n.__v_isRef===!0),Lp=n=>xt(n)?n:n==null?"":Oe(n)||ct(n)&&(n.toString===sh||!Ge(n.toString))?uh(n)?Lp(n.value):JSON.stringify(n,fh,2):String(n),fh=(n,e)=>uh(e)?fh(n,e.value):Pr(e)?{[`Map(${e.size})`]:[...e.entries()].reduce((t,[i,r],s)=>(t[Ma(i,s)+" =>"]=r,t),{})}:Qo(e)?{[`Set(${e.size})`]:[...e.values()].map(t=>Ma(t))}:hn(e)?Ma(e):ct(e)&&!Oe(e)&&!oh(e)?String(e):e,Ma=(n,e="")=>{var t;return hn(n)?`Symbol(${(t=n.description)!=null?t:e})`:n};let Pt;class hh{constructor(e=!1){this.detached=e,this._active=!0,this._on=0,this.effects=[],this.cleanups=[],this._isPaused=!1,this._warnOnRun=!0,this.__v_skip=!0,!e&&Pt&&(Pt.active?(this.parent=Pt,this.index=(Pt.scopes||(Pt.scopes=[])).push(this)-1):(this._active=!1,this._warnOnRun=!1))}get active(){return this._active}pause(){if(this._active){this._isPaused=!0;let e,t;if(this.scopes)for(e=0,t=this.scopes.length;e<t;e++)this.scopes[e].pause();for(e=0,t=this.effects.length;e<t;e++)this.effects[e].pause()}}resume(){if(this._active&&this._isPaused){this._isPaused=!1;let e,t;if(this.scopes)for(e=0,t=this.scopes.length;e<t;e++)this.scopes[e].resume();for(e=0,t=this.effects.length;e<t;e++)this.effects[e].resume()}}run(e){if(this._active){const t=Pt;try{return Pt=this,e()}finally{Pt=t}}}on(){++this._on===1&&(this.prevScope=Pt,Pt=this)}off(){if(this._on>0&&--this._on===0){if(Pt===this)Pt=this.prevScope;else{let e=Pt;for(;e;){if(e.prevScope===this){e.prevScope=this.prevScope;break}e=e.prevScope}}this.prevScope=void 0}}stop(e){if(this._active){this._active=!1;let t,i;for(t=0,i=this.effects.length;t<i;t++)this.effects[t].stop();for(this.effects.length=0,t=0,i=this.cleanups.length;t<i;t++)this.cleanups[t]();if(this.cleanups.length=0,this.scopes){for(t=0,i=this.scopes.length;t<i;t++)this.scopes[t].stop(!0);this.scopes.length=0}if(!this.detached&&this.parent&&!e){const r=this.parent.scopes.pop();r&&r!==this&&(this.parent.scopes[this.index]=r,r.index=this.index)}this.parent=void 0}}}function XE(n){return new hh(n)}function Up(){return Pt}function YE(n,e=!1){Pt&&Pt.cleanups.push(n)}let _t;const Sa=new WeakSet;class dh{constructor(e){this.fn=e,this.deps=void 0,this.depsTail=void 0,this.flags=5,this.next=void 0,this.cleanup=void 0,this.scheduler=void 0,Pt&&(Pt.active?Pt.effects.push(this):this.flags&=-2)}pause(){this.flags|=64}resume(){this.flags&64&&(this.flags&=-65,Sa.has(this)&&(Sa.delete(this),this.trigger()))}notify(){this.flags&2&&!(this.flags&32)||this.flags&8||mh(this)}run(){if(!(this.flags&1))return this.fn();this.flags|=2,lu(this),gh(this);const e=_t,t=An;_t=this,An=!0;try{return this.fn()}finally{_h(this),_t=e,An=t,this.flags&=-3}}stop(){if(this.flags&1){for(let e=this.deps;e;e=e.nextDep)yc(e);this.deps=this.depsTail=void 0,lu(this),this.onStop&&this.onStop(),this.flags&=-2}}trigger(){this.flags&64?Sa.add(this):this.scheduler?this.scheduler():this.runIfDirty()}runIfDirty(){hl(this)&&this.run()}get dirty(){return hl(this)}}let ph=0,hs,ds;function mh(n,e=!1){if(n.flags|=8,e){n.next=ds,ds=n;return}n.next=hs,hs=n}function Sc(){ph++}function Ec(){if(--ph>0)return;if(ds){let e=ds;for(ds=void 0;e;){const t=e.next;e.next=void 0,e.flags&=-9,e=t}}let n;for(;hs;){let e=hs;for(hs=void 0;e;){const t=e.next;if(e.next=void 0,e.flags&=-9,e.flags&1)try{e.trigger()}catch(i){n||(n=i)}e=t}}if(n)throw n}function gh(n){for(let e=n.deps;e;e=e.nextDep)e.version=-1,e.prevActiveLink=e.dep.activeLink,e.dep.activeLink=e}function _h(n){let e,t=n.depsTail,i=t;for(;i;){const r=i.prevDep;i.version===-1?(i===t&&(t=r),yc(i),Np(i)):e=i,i.dep.activeLink=i.prevActiveLink,i.prevActiveLink=void 0,i=r}n.deps=e,n.depsTail=t}function hl(n){for(let e=n.deps;e;e=e.nextDep)if(e.dep.version!==e.version||e.dep.computed&&(xh(e.dep.computed)||e.dep.version!==e.version))return!0;return!!n._dirty}function xh(n){if(n.flags&4&&!(n.flags&16)||(n.flags&=-17,n.globalVersion===vs)||(n.globalVersion=vs,!n.isSSR&&n.flags&128&&(!n.deps&&!n._dirty||!hl(n))))return;n.flags|=2;const e=n.dep,t=_t,i=An;_t=n,An=!0;try{gh(n);const r=n.fn(n._value);(e.version===0||Yt(r,n._value))&&(n.flags|=128,n._value=r,e.version++)}catch(r){throw e.version++,r}finally{_t=t,An=i,_h(n),n.flags&=-3}}function yc(n,e=!1){const{dep:t,prevSub:i,nextSub:r}=n;if(i&&(i.nextSub=r,n.prevSub=void 0),r&&(r.prevSub=i,n.nextSub=void 0),t.subs===n&&(t.subs=i,!i&&t.computed)){t.computed.flags&=-5;for(let s=t.computed.deps;s;s=s.nextDep)yc(s,!0)}!e&&!--t.sc&&t.map&&t.map.delete(t.key)}function Np(n){const{prevDep:e,nextDep:t}=n;e&&(e.nextDep=t,n.prevDep=void 0),t&&(t.prevDep=e,n.nextDep=void 0)}let An=!0;const vh=[];function li(){vh.push(An),An=!1}function ci(){const n=vh.pop();An=n===void 0?!0:n}function lu(n){const{cleanup:e}=n;if(n.cleanup=void 0,e){const t=_t;_t=void 0;try{e()}finally{_t=t}}}let vs=0;class Fp{constructor(e,t){this.sub=e,this.dep=t,this.version=t.version,this.nextDep=this.prevDep=this.nextSub=this.prevSub=this.prevActiveLink=void 0}}class oa{constructor(e){this.computed=e,this.version=0,this.activeLink=void 0,this.subs=void 0,this.map=void 0,this.key=void 0,this.sc=0,this.__v_skip=!0}track(e){if(!_t||!An||_t===this.computed)return;let t=this.activeLink;if(t===void 0||t.sub!==_t)t=this.activeLink=new Fp(_t,this),_t.deps?(t.prevDep=_t.depsTail,_t.depsTail.nextDep=t,_t.depsTail=t):_t.deps=_t.depsTail=t,Mh(t);else if(t.version===-1&&(t.version=this.version,t.nextDep)){const i=t.nextDep;i.prevDep=t.prevDep,t.prevDep&&(t.prevDep.nextDep=i),t.prevDep=_t.depsTail,t.nextDep=void 0,_t.depsTail.nextDep=t,_t.depsTail=t,_t.deps===t&&(_t.deps=i)}return t}trigger(e){this.version++,vs++,this.notify(e)}notify(e){Sc();try{for(let t=this.subs;t;t=t.prevSub)t.sub.notify()&&t.sub.dep.notify()}finally{Ec()}}}function Mh(n){if(n.dep.sc++,n.sub.flags&4){const e=n.dep.computed;if(e&&!n.dep.subs){e.flags|=20;for(let i=e.deps;i;i=i.nextDep)Mh(i)}const t=n.dep.subs;t!==n&&(n.prevSub=t,t&&(t.nextSub=n)),n.dep.subs=n}}const Do=new WeakMap,nr=Symbol(""),dl=Symbol(""),Ms=Symbol("");function qt(n,e,t){if(An&&_t){let i=Do.get(n);i||Do.set(n,i=new Map);let r=i.get(t);r||(i.set(t,r=new oa),r.map=i,r.key=t),r.track()}}function ii(n,e,t,i,r,s){const o=Do.get(n);if(!o){vs++;return}const a=l=>{l&&l.trigger()};if(Sc(),e==="clear")o.forEach(a);else{const l=Oe(n),c=l&&ea(t);if(l&&t==="length"){const u=Number(i);o.forEach((h,f)=>{(f==="length"||f===Ms||!hn(f)&&f>=u)&&a(h)})}else switch((t!==void 0||o.has(void 0))&&a(o.get(t)),c&&a(o.get(Ms)),e){case"add":l?c&&a(o.get("length")):(a(o.get(nr)),Pr(n)&&a(o.get(dl)));break;case"delete":l||(a(o.get(nr)),Pr(n)&&a(o.get(dl)));break;case"set":Pr(n)&&a(o.get(nr));break}}Ec()}function Op(n,e){const t=Do.get(n);return t&&t.get(e)}function fr(n){const e=it(n);return e===n?e:(qt(e,"iterate",Ms),fn(n)?e:e.map(wn))}function aa(n){return qt(n=it(n),"iterate",Ms),n}function Fn(n,e){return ui(n)?Fr(ir(n)?wn(e):e):wn(e)}const Bp={__proto__:null,[Symbol.iterator](){return Ea(this,Symbol.iterator,n=>Fn(this,n))},concat(...n){return fr(this).concat(...n.map(e=>Oe(e)?fr(e):e))},entries(){return Ea(this,"entries",n=>(n[1]=Fn(this,n[1]),n))},every(n,e){return jn(this,"every",n,e,void 0,arguments)},filter(n,e){return jn(this,"filter",n,e,t=>t.map(i=>Fn(this,i)),arguments)},find(n,e){return jn(this,"find",n,e,t=>Fn(this,t),arguments)},findIndex(n,e){return jn(this,"findIndex",n,e,void 0,arguments)},findLast(n,e){return jn(this,"findLast",n,e,t=>Fn(this,t),arguments)},findLastIndex(n,e){return jn(this,"findLastIndex",n,e,void 0,arguments)},forEach(n,e){return jn(this,"forEach",n,e,void 0,arguments)},includes(...n){return ya(this,"includes",n)},indexOf(...n){return ya(this,"indexOf",n)},join(n){return fr(this).join(n)},lastIndexOf(...n){return ya(this,"lastIndexOf",n)},map(n,e){return jn(this,"map",n,e,void 0,arguments)},pop(){return Xr(this,"pop")},push(...n){return Xr(this,"push",n)},reduce(n,...e){return cu(this,"reduce",n,e)},reduceRight(n,...e){return cu(this,"reduceRight",n,e)},shift(){return Xr(this,"shift")},some(n,e){return jn(this,"some",n,e,void 0,arguments)},splice(...n){return Xr(this,"splice",n)},toReversed(){return fr(this).toReversed()},toSorted(n){return fr(this).toSorted(n)},toSpliced(...n){return fr(this).toSpliced(...n)},unshift(...n){return Xr(this,"unshift",n)},values(){return Ea(this,"values",n=>Fn(this,n))}};function Ea(n,e,t){const i=aa(n),r=i[e]();return i!==n&&!fn(n)&&(r._next=r.next,r.next=()=>{const s=r._next();return s.done||(s.value=t(s.value)),s}),r}const zp=Array.prototype;function jn(n,e,t,i,r,s){const o=aa(n),a=o!==n&&!fn(n),l=o[e];if(l!==zp[e]){const h=l.apply(n,s);return a?wn(h):h}let c=t;o!==n&&(a?c=function(h,f){return t.call(this,Fn(n,h),f,n)}:t.length>2&&(c=function(h,f){return t.call(this,h,f,n)}));const u=l.call(o,c,i);return a&&r?r(u):u}function cu(n,e,t,i){const r=aa(n),s=r!==n&&!fn(n);let o=t,a=!1;r!==n&&(s?(a=i.length===0,o=function(c,u,h){return a&&(a=!1,c=Fn(n,c)),t.call(this,c,Fn(n,u),h,n)}):t.length>3&&(o=function(c,u,h){return t.call(this,c,u,h,n)}));const l=r[e](o,...i);return a?Fn(n,l):l}function ya(n,e,t){const i=it(n);qt(i,"iterate",Ms);const r=i[e](...t);return(r===-1||r===!1)&&la(t[0])?(t[0]=it(t[0]),i[e](...t)):r}function Xr(n,e,t=[]){li(),Sc();const i=it(n)[e].apply(n,t);return Ec(),ci(),i}const Hp=xc("__proto__,__v_isRef,__isVue"),Sh=new Set(Object.getOwnPropertyNames(Symbol).filter(n=>n!=="arguments"&&n!=="caller").map(n=>Symbol[n]).filter(hn));function Vp(n){hn(n)||(n=String(n));const e=it(this);return qt(e,"has",n),e.hasOwnProperty(n)}class Eh{constructor(e=!1,t=!1){this._isReadonly=e,this._isShallow=t}get(e,t,i){if(t==="__v_skip")return e.__v_skip;const r=this._isReadonly,s=this._isShallow;if(t==="__v_isReactive")return!r;if(t==="__v_isReadonly")return r;if(t==="__v_isShallow")return s;if(t==="__v_raw")return i===(r?s?$p:Ah:s?Th:bh).get(e)||Object.getPrototypeOf(e)===Object.getPrototypeOf(i)?e:void 0;const o=Oe(e);if(!r){let l;if(o&&(l=Bp[t]))return l;if(t==="hasOwnProperty")return Vp}const a=Reflect.get(e,t,Nt(e)?e:i);if((hn(t)?Sh.has(t):Hp(t))||(r||qt(e,"get",t),s))return a;if(Nt(a)){const l=o&&ea(t)?a:a.value;return r&&ct(l)?ml(l):l}return ct(a)?r?ml(a):Tc(a):a}}class yh extends Eh{constructor(e=!1){super(!1,e)}set(e,t,i,r){let s=e[t];const o=Oe(e)&&ea(t);if(!this._isShallow){const c=ui(s);if(!fn(i)&&!ui(i)&&(s=it(s),i=it(i)),!o&&Nt(s)&&!Nt(i))return c||(s.value=i),!0}const a=o?Number(t)<e.length:at(e,t),l=Reflect.set(e,t,i,Nt(e)?e:r);return e===it(r)&&(a?Yt(i,s)&&ii(e,"set",t,i):ii(e,"add",t,i)),l}deleteProperty(e,t){const i=at(e,t);e[t];const r=Reflect.deleteProperty(e,t);return r&&i&&ii(e,"delete",t,void 0),r}has(e,t){const i=Reflect.has(e,t);return(!hn(t)||!Sh.has(t))&&qt(e,"has",t),i}ownKeys(e){return qt(e,"iterate",Oe(e)?"length":nr),Reflect.ownKeys(e)}}class Gp extends Eh{constructor(e=!1){super(!0,e)}set(e,t){return!0}deleteProperty(e,t){return!0}}const kp=new yh,Wp=new Gp,Xp=new yh(!0);const pl=n=>n,zs=n=>Reflect.getPrototypeOf(n);function Yp(n,e,t){return function(...i){const r=this.__v_raw,s=it(r),o=Pr(s),a=n==="entries"||n===Symbol.iterator&&o,l=n==="keys"&&o,c=r[n](...i),u=t?pl:e?Fr:wn;return!e&&qt(s,"iterate",l?dl:nr),wt(Object.create(c),{next(){const{value:h,done:f}=c.next();return f?{value:h,done:f}:{value:a?[u(h[0]),u(h[1])]:u(h),done:f}}})}}function Hs(n){return function(...e){return n==="delete"?!1:n==="clear"?void 0:this}}function qp(n,e){const t={get(r){const s=this.__v_raw,o=it(s),a=it(r);n||(Yt(r,a)&&qt(o,"get",r),qt(o,"get",a));const{has:l}=zs(o),c=e?pl:n?Fr:wn;if(l.call(o,r))return c(s.get(r));if(l.call(o,a))return c(s.get(a));s!==o&&s.get(r)},get size(){const r=this.__v_raw;return!n&&qt(it(r),"iterate",nr),r.size},has(r){const s=this.__v_raw,o=it(s),a=it(r);return n||(Yt(r,a)&&qt(o,"has",r),qt(o,"has",a)),r===a?s.has(r):s.has(r)||s.has(a)},forEach(r,s){const o=this,a=o.__v_raw,l=it(a),c=e?pl:n?Fr:wn;return!n&&qt(l,"iterate",nr),a.forEach((u,h)=>r.call(s,c(u),c(h),o))}};return wt(t,n?{add:Hs("add"),set:Hs("set"),delete:Hs("delete"),clear:Hs("clear")}:{add(r){const s=it(this),o=zs(s),a=it(r),l=!e&&!fn(r)&&!ui(r)?a:r;return o.has.call(s,l)||Yt(r,l)&&o.has.call(s,r)||Yt(a,l)&&o.has.call(s,a)||(s.add(l),ii(s,"add",l,l)),this},set(r,s){!e&&!fn(s)&&!ui(s)&&(s=it(s));const o=it(this),{has:a,get:l}=zs(o);let c=a.call(o,r);c||(r=it(r),c=a.call(o,r));const u=l.call(o,r);return o.set(r,s),c?Yt(s,u)&&ii(o,"set",r,s):ii(o,"add",r,s),this},delete(r){const s=it(this),{has:o,get:a}=zs(s);let l=o.call(s,r);l||(r=it(r),l=o.call(s,r)),a&&a.call(s,r);const c=s.delete(r);return l&&ii(s,"delete",r,void 0),c},clear(){const r=it(this),s=r.size!==0,o=r.clear();return s&&ii(r,"clear",void 0,void 0),o}}),["keys","values","entries",Symbol.iterator].forEach(r=>{t[r]=Yp(r,n,e)}),t}function bc(n,e){const t=qp(n,e);return(i,r,s)=>r==="__v_isReactive"?!n:r==="__v_isReadonly"?n:r==="__v_raw"?i:Reflect.get(at(t,r)&&r in i?t:i,r,s)}const Kp={get:bc(!1,!1)},jp={get:bc(!1,!0)},Zp={get:bc(!0,!1)};const bh=new WeakMap,Th=new WeakMap,Ah=new WeakMap,$p=new WeakMap;function Jp(n){switch(n){case"Object":case"Array":return 1;case"Map":case"Set":case"WeakMap":case"WeakSet":return 2;default:return 0}}function Tc(n){return ui(n)?n:Ac(n,!1,kp,Kp,bh)}function Qp(n){return Ac(n,!1,Xp,jp,Th)}function ml(n){return Ac(n,!0,Wp,Zp,Ah)}function Ac(n,e,t,i,r){if(!ct(n)||n.__v_raw&&!(e&&n.__v_isReactive)||n.__v_skip||!Object.isExtensible(n))return n;const s=r.get(n);if(s)return s;const o=Jp(Ep(n));if(o===0)return n;const a=new Proxy(n,o===2?i:t);return r.set(n,a),a}function ir(n){return ui(n)?ir(n.__v_raw):!!(n&&n.__v_isReactive)}function ui(n){return!!(n&&n.__v_isReadonly)}function fn(n){return!!(n&&n.__v_isShallow)}function la(n){return n?!!n.__v_raw:!1}function it(n){const e=n&&n.__v_raw;return e?it(e):n}function em(n){return!at(n,"__v_skip")&&Object.isExtensible(n)&&ah(n,"__v_skip",!0),n}const wn=n=>ct(n)?Tc(n):n,Fr=n=>ct(n)?ml(n):n;function Nt(n){return n?n.__v_isRef===!0:!1}function ba(n){return wh(n,!1)}function qE(n){return wh(n,!0)}function wh(n,e){return Nt(n)?n:new tm(n,e)}class tm{constructor(e,t){this.dep=new oa,this.__v_isRef=!0,this.__v_isShallow=!1,this._rawValue=t?e:it(e),this._value=t?e:wn(e),this.__v_isShallow=t}get value(){return this.dep.track(),this._value}set value(e){const t=this._rawValue,i=this.__v_isShallow||fn(e)||ui(e);e=i?e:it(e),Yt(e,t)&&(this._rawValue=e,this._value=i?e:wn(e),this.dep.trigger())}}function Rh(n){return Nt(n)?n.value:n}const nm={get:(n,e,t)=>e==="__v_raw"?n:Rh(Reflect.get(n,e,t)),set:(n,e,t,i)=>{const r=n[e];return Nt(r)&&!Nt(t)?(r.value=t,!0):Reflect.set(n,e,t,i)}};function Ch(n){return ir(n)?n:new Proxy(n,nm)}class im{constructor(e){this.__v_isRef=!0,this._value=void 0;const t=this.dep=new oa,{get:i,set:r}=e(t.track.bind(t),t.trigger.bind(t));this._get=i,this._set=r}get value(){return this._value=this._get()}set value(e){this._set(e)}}function rm(n){return new im(n)}function KE(n){const e=Oe(n)?new Array(n.length):{};for(const t in n)e[t]=om(n,t);return e}class sm{constructor(e,t,i){this._object=e,this._defaultValue=i,this.__v_isRef=!0,this._value=void 0,this._key=hn(t)?t:String(t),this._raw=it(e);let r=!0,s=e;if(!Oe(e)||hn(this._key)||!ea(this._key))do r=!la(s)||fn(s);while(r&&(s=s.__v_raw));this._shallow=r}get value(){let e=this._object[this._key];return this._shallow&&(e=Rh(e)),this._value=e===void 0?this._defaultValue:e}set value(e){if(this._shallow&&Nt(this._raw[this._key])){const t=this._object[this._key];if(Nt(t)){t.value=e;return}}this._object[this._key]=e}get dep(){return Op(this._raw,this._key)}}function om(n,e,t){return new sm(n,e,t)}class am{constructor(e,t,i){this.fn=e,this.setter=t,this._value=void 0,this.dep=new oa(this),this.__v_isRef=!0,this.deps=void 0,this.depsTail=void 0,this.flags=16,this.globalVersion=vs-1,this.next=void 0,this.effect=this,this.__v_isReadonly=!t,this.isSSR=i}notify(){if(this.flags|=16,!(this.flags&8)&&_t!==this)return mh(this,!0),!0}get value(){const e=this.dep.track();return xh(this),e&&(e.version=this.dep.version),this._value}set value(e){this.setter&&this.setter(e)}}function lm(n,e,t=!1){let i,r;return Ge(n)?i=n:(i=n.get,r=n.set),new am(i,r,t)}const Vs={},Io=new WeakMap;let Xi;function cm(n,e=!1,t=Xi){if(t){let i=Io.get(t);i||Io.set(t,i=[]),i.push(n)}}function um(n,e,t=ot){const{immediate:i,deep:r,once:s,scheduler:o,augmentJob:a,call:l}=t,c=S=>r?S:fn(S)||r===!1||r===0?ri(S,1):ri(S);let u,h,f,p,g=!1,M=!1;if(Nt(n)?(h=()=>n.value,g=fn(n)):ir(n)?(h=()=>c(n),g=!0):Oe(n)?(M=!0,g=n.some(S=>ir(S)||fn(S)),h=()=>n.map(S=>{if(Nt(S))return S.value;if(ir(S))return c(S);if(Ge(S))return l?l(S,2):S()})):Ge(n)?e?h=l?()=>l(n,2):n:h=()=>{if(f){li();try{f()}finally{ci()}}const S=Xi;Xi=u;try{return l?l(n,3,[p]):n(p)}finally{Xi=S}}:h=Gn,e&&r){const S=h,C=r===!0?1/0:r;h=()=>ri(S(),C)}const m=Up(),d=()=>{u.stop(),m&&m.active&&vc(m.effects,u)};if(s&&e){const S=e;e=(...C)=>{S(...C),d()}}let x=M?new Array(n.length).fill(Vs):Vs;const y=S=>{if(!(!(u.flags&1)||!u.dirty&&!S))if(e){const C=u.run();if(r||g||(M?C.some((A,P)=>Yt(A,x[P])):Yt(C,x))){f&&f();const A=Xi;Xi=u;try{const P=[C,x===Vs?void 0:M&&x[0]===Vs?[]:x,p];x=C,l?l(e,3,P):e(...P)}finally{Xi=A}}}else u.run()};return a&&a(y),u=new dh(h),u.scheduler=o?()=>o(y,!1):y,p=S=>cm(S,!1,u),f=u.onStop=()=>{const S=Io.get(u);if(S){if(l)l(S,4);else for(const C of S)C();Io.delete(u)}},e?i?y(!0):x=u.run():o?o(y.bind(null,!0),!0):u.run(),d.pause=u.pause.bind(u),d.resume=u.resume.bind(u),d.stop=d,d}function ri(n,e=1/0,t){if(e<=0||!ct(n)||n.__v_skip||(t=t||new Map,(t.get(n)||0)>=e))return n;if(t.set(n,e),e--,Nt(n))ri(n.value,e,t);else if(Oe(n))for(let i=0;i<n.length;i++)ri(n[i],e,t);else if(Qo(n)||Pr(n))n.forEach(i=>{ri(i,e,t)});else if(oh(n)){for(const i in n)ri(n[i],e,t);for(const i of Object.getOwnPropertySymbols(n))Object.prototype.propertyIsEnumerable.call(n,i)&&ri(n[i],e,t)}return n}function Ps(n,e,t,i){try{return i?n(...i):n()}catch(r){Ds(r,e,t)}}function vn(n,e,t,i){if(Ge(n)){const r=Ps(n,e,t,i);return r&&rh(r)&&r.catch(s=>{Ds(s,e,t)}),r}if(Oe(n)){const r=[];for(let s=0;s<n.length;s++)r.push(vn(n[s],e,t,i));return r}}function Ds(n,e,t,i=!0){const r=e?e.vnode:null,{errorHandler:s,throwUnhandledErrorInProduction:o}=e&&e.appContext.config||ot;if(e){let a=e.parent;const l=e.proxy,c=`https://vuejs.org/error-reference/#runtime-${t}`;for(;a;){const u=a.ec;if(u){for(let h=0;h<u.length;h++)if(u[h](n,l,c)===!1)return}a=a.parent}if(s){li(),Ps(s,null,10,[n,l,c]),ci();return}}fm(n,t,r,i,o)}function fm(n,e,t,i=!0,r=!1){if(r)throw n;console.error(n)}const nn=[];let Nn=-1;const Dr=[];let Ci=null,Ar=0;const Ph=Promise.resolve();let Lo=null;function hm(n){const e=Lo||Ph;return n?e.then(this?n.bind(this):n):e}function dm(n){let e=Nn+1,t=nn.length;for(;e<t;){const i=e+t>>>1,r=nn[i],s=Ss(r);s<n||s===n&&r.flags&2?e=i+1:t=i}return e}function wc(n){if(!(n.flags&1)){const e=Ss(n),t=nn[nn.length-1];!t||!(n.flags&2)&&e>=Ss(t)?nn.push(n):nn.splice(dm(e),0,n),n.flags|=1,Dh()}}function Dh(){Lo||(Lo=Ph.then(Lh))}function pm(n){Oe(n)?Dr.push(...n):Ci&&n.id===-1?Ci.splice(Ar+1,0,n):n.flags&1||(Dr.push(n),n.flags|=1),Dh()}function uu(n,e,t=Nn+1){for(;t<nn.length;t++){const i=nn[t];if(i&&i.flags&2){if(n&&i.id!==n.uid)continue;nn.splice(t,1),t--,i.flags&4&&(i.flags&=-2),i(),i.flags&4||(i.flags&=-2)}}}function Ih(n){if(Dr.length){const e=[...new Set(Dr)].sort((t,i)=>Ss(t)-Ss(i));if(Dr.length=0,Ci){Ci.push(...e);return}for(Ci=e,Ar=0;Ar<Ci.length;Ar++){const t=Ci[Ar];t.flags&4&&(t.flags&=-2),t.flags&8||t(),t.flags&=-2}Ci=null,Ar=0}}const Ss=n=>n.id==null?n.flags&2?-1:1/0:n.id;function Lh(n){try{for(Nn=0;Nn<nn.length;Nn++){const e=nn[Nn];e&&!(e.flags&8)&&(e.flags&4&&(e.flags&=-2),Ps(e,e.i,e.i?15:14),e.flags&4||(e.flags&=-2))}}finally{for(;Nn<nn.length;Nn++){const e=nn[Nn];e&&(e.flags&=-2)}Nn=-1,nn.length=0,Ih(),Lo=null,(nn.length||Dr.length)&&Lh()}}let Bt=null,Uh=null;function Uo(n){const e=Bt;return Bt=n,Uh=n&&n.type.__scopeId||null,e}function mm(n,e=Bt,t){if(!e||n._n)return n;const i=(...r)=>{i._d&&Bo(-1);const s=Uo(e);let o;try{o=n(...r)}finally{Uo(s),i._d&&Bo(1)}return o};return i._n=!0,i._c=!0,i._d=!0,i}function jE(n,e){if(Bt===null)return n;const t=ha(Bt),i=n.dirs||(n.dirs=[]);for(let r=0;r<e.length;r++){let[s,o,a,l=ot]=e[r];s&&(Ge(s)&&(s={mounted:s,updated:s}),s.deep&&ri(o),i.push({dir:s,instance:t,value:o,oldValue:void 0,arg:a,modifiers:l}))}return n}function Oi(n,e,t,i){const r=n.dirs,s=e&&e.dirs;for(let o=0;o<r.length;o++){const a=r[o];s&&(a.oldValue=s[o].value);let l=a.dir[i];l&&(li(),vn(l,t,8,[n.el,a,n,e]),ci())}}function gm(n,e){if(Ot){let t=Ot.provides;const i=Ot.parent&&Ot.parent.provides;i===t&&(t=Ot.provides=Object.create(i)),t[n]=e}}function So(n,e,t=!1){const i=lr();if(i||rr){let r=rr?rr._context.provides:i?i.parent==null||i.ce?i.vnode.appContext&&i.vnode.appContext.provides:i.parent.provides:void 0;if(r&&n in r)return r[n];if(arguments.length>1)return t&&Ge(e)?e.call(i&&i.proxy):e}}function ZE(){return!!(lr()||rr)}const _m=Symbol.for("v-scx"),xm=()=>So(_m);function vm(n,e){return Rc(n,null,{flush:"sync"})}function Ta(n,e,t){return Rc(n,e,t)}function Rc(n,e,t=ot){const{immediate:i,deep:r,flush:s,once:o}=t,a=wt({},t),l=e&&i||!e&&s!=="post";let c;if(Or){if(s==="sync"){const p=xm();c=p.__watcherHandles||(p.__watcherHandles=[])}else if(!l){const p=()=>{};return p.stop=Gn,p.resume=Gn,p.pause=Gn,p}}const u=Ot;a.call=(p,g,M)=>vn(p,u,g,M);let h=!1;s==="post"?a.scheduler=p=>{tn(p,u&&u.suspense)}:s!=="sync"&&(h=!0,a.scheduler=(p,g)=>{g?p():wc(p)}),a.augmentJob=p=>{e&&(p.flags|=4),h&&(p.flags|=2,u&&(p.id=u.uid,p.i=u))};const f=um(n,e,a);return Or&&(c?c.push(f):l&&f()),f}function Mm(n,e,t){const i=this.proxy,r=xt(n)?n.includes(".")?Nh(i,n):()=>i[n]:n.bind(i,i);let s;Ge(e)?s=e:(s=e.handler,t=e);const o=Ls(this),a=Rc(r,s.bind(i),t);return o(),a}function Nh(n,e){const t=e.split(".");return()=>{let i=n;for(let r=0;r<t.length&&i;r++)i=i[t[r]];return i}}const wi=new WeakMap,Fh=Symbol("_vte"),Oh=n=>n.__isTeleport,Ki=n=>n&&(n.disabled||n.disabled===""),Sm=n=>n&&(n.defer||n.defer===""),fu=n=>typeof SVGElement<"u"&&n instanceof SVGElement,hu=n=>typeof MathMLElement=="function"&&n instanceof MathMLElement,gl=(n,e)=>{const t=n&&n.to;return xt(t)?e?e(t):null:t},Em={name:"Teleport",__isTeleport:!0,process(n,e,t,i,r,s,o,a,l,c){const{mc:u,pc:h,pbc:f,o:{insert:p,querySelector:g,createText:M,createComment:m,parentNode:d}}=c,x=Ki(e.props);let{dynamicChildren:y}=e;const S=(P,v,T)=>{P.shapeFlag&16&&u(P.children,v,T,r,s,o,a,l)},C=(P=e)=>{const v=Ki(P.props),T=P.target=gl(P.props,g),L=_l(T,P,M,p);T&&(o!=="svg"&&fu(T)?o="svg":o!=="mathml"&&hu(T)&&(o="mathml"),r&&r.isCE&&(r.ce._teleportTargets||(r.ce._teleportTargets=new Set)).add(T),v||(S(P,T,L),rs(P,!1)))},A=P=>{const v=()=>{if(wi.get(P)===v){if(wi.delete(P),Ki(P.props)){const T=d(P.el)||t;S(P,T,P.anchor),rs(P,!0)}C(P)}};wi.set(P,v),tn(v,s)};if(n==null){const P=e.el=M(""),v=e.anchor=M("");if(p(P,t,i),p(v,t,i),Sm(e.props)||s&&s.pendingBranch){A(e);return}x&&(S(e,t,v),rs(e,!0)),C()}else{e.el=n.el;const P=e.anchor=n.anchor,v=wi.get(n);if(v){v.flags|=8,wi.delete(n),A(e);return}e.targetStart=n.targetStart;const T=e.target=n.target,L=e.targetAnchor=n.targetAnchor,D=Ki(n.props),I=D?t:T,k=D?P:L;if(o==="svg"||fu(T)?o="svg":(o==="mathml"||hu(T))&&(o="mathml"),y?(f(n.dynamicChildren,y,I,r,s,o,a),Nc(n,e,!0)):l||h(n,e,I,k,r,s,o,a,!1),x)D?e.props&&n.props&&e.props.to!==n.props.to&&(e.props.to=n.props.to):Gs(e,t,P,c,1);else if((e.props&&e.props.to)!==(n.props&&n.props.to)){const G=e.target=gl(e.props,g);G&&Gs(e,G,null,c,0)}else D&&Gs(e,T,L,c,1);rs(e,x)}},remove(n,e,t,{um:i,o:{remove:r}},s){const{shapeFlag:o,children:a,anchor:l,targetStart:c,targetAnchor:u,target:h,props:f}=n,p=s||!Ki(f),g=wi.get(n);if(g&&(g.flags|=8,wi.delete(n)),h&&(r(c),r(u)),s&&r(l),!g&&o&16)for(let M=0;M<a.length;M++){const m=a[M];i(m,e,t,p,!!m.dynamicChildren)}},move:Gs,hydrate:ym};function Gs(n,e,t,{o:{insert:i},m:r},s=2){s===0&&i(n.targetAnchor,e,t);const{el:o,anchor:a,shapeFlag:l,children:c,props:u}=n,h=s===2;if(h&&i(o,e,t),!wi.has(n)&&(!h||Ki(u))&&l&16)for(let f=0;f<c.length;f++)r(c[f],e,t,2);h&&i(a,e,t)}function ym(n,e,t,i,r,s,{o:{nextSibling:o,parentNode:a,querySelector:l,insert:c,createText:u}},h){function f(m,d){let x=d;for(;x;){if(x&&x.nodeType===8){if(x.data==="teleport start anchor")e.targetStart=x;else if(x.data==="teleport anchor"){e.targetAnchor=x,m._lpa=e.targetAnchor&&o(e.targetAnchor);break}}x=o(x)}}function p(m,d){d.anchor=h(o(m),d,a(m),t,i,r,s)}const g=e.target=gl(e.props,l),M=Ki(e.props);if(g){const m=g._lpa||g.firstChild;e.shapeFlag&16&&(M?(p(n,e),f(g,m),e.targetAnchor||_l(g,e,u,c,a(n)===g?n:null)):(e.anchor=o(n),f(g,m),e.targetAnchor||_l(g,e,u,c),h(m&&o(m),e,g,t,i,r,s))),rs(e,M)}else M&&e.shapeFlag&16&&(p(n,e),e.targetStart=n,e.targetAnchor=o(n));return e.anchor&&o(e.anchor)}const $E=Em;function rs(n,e){const t=n.ctx;if(t&&t.ut){let i,r;for(e?(i=n.el,r=n.anchor):(i=n.targetStart,r=n.targetAnchor);i&&i!==r;)i.nodeType===1&&i.setAttribute("data-v-owner",t.uid),i=i.nextSibling;t.ut()}}function _l(n,e,t,i,r=null){const s=e.targetStart=t(""),o=e.targetAnchor=t("");return s[Fh]=o,n&&(i(s,n,r),i(o,n,r)),o}const gn=Symbol("_leaveCb"),Yr=Symbol("_enterCb");function Bh(){const n={isMounted:!1,isLeaving:!1,isUnmounting:!1,leavingVNodes:new Map};return Wh(()=>{n.isMounted=!0}),Yh(()=>{n.isUnmounting=!0}),n}const pn=[Function,Array],zh={mode:String,appear:Boolean,persisted:Boolean,onBeforeEnter:pn,onEnter:pn,onAfterEnter:pn,onEnterCancelled:pn,onBeforeLeave:pn,onLeave:pn,onAfterLeave:pn,onLeaveCancelled:pn,onBeforeAppear:pn,onAppear:pn,onAfterAppear:pn,onAppearCancelled:pn},Hh=n=>{const e=n.subTree;return e.component?Hh(e.component):e},bm={name:"BaseTransition",props:zh,setup(n,{slots:e}){const t=lr(),i=Bh();return()=>{const r=e.default&&Cc(e.default(),!0),s=r&&r.length?Vh(r):t.subTree?dg():void 0;if(!s)return;const o=it(n),{mode:a}=o;if(i.isLeaving)return Aa(s);const l=du(s);if(!l)return Aa(s);let c=Es(l,o,i,t,h=>c=h);l.type!==Kt&&sr(l,c);let u=t.subTree&&du(t.subTree);if(u&&u.type!==Kt&&!ji(u,l)&&Hh(t).type!==Kt){let h=Es(u,o,i,t);if(sr(u,h),a==="out-in"&&l.type!==Kt)return i.isLeaving=!0,h.afterLeave=()=>{i.isLeaving=!1,t.job.flags&8||t.update(),delete h.afterLeave,u=void 0},Aa(s);a==="in-out"&&l.type!==Kt?h.delayLeave=(f,p,g)=>{const M=Gh(i,u);M[String(u.key)]=u,f[gn]=()=>{p(),f[gn]=void 0,delete c.delayedLeave,u=void 0},c.delayedLeave=()=>{g(),delete c.delayedLeave,u=void 0}}:u=void 0}else u&&(u=void 0);return s}}};function Vh(n){let e=n[0];if(n.length>1){for(const t of n)if(t.type!==Kt){e=t;break}}return e}const Tm=bm;function Gh(n,e){const{leavingVNodes:t}=n;let i=t.get(e.type);return i||(i=Object.create(null),t.set(e.type,i)),i}function Es(n,e,t,i,r){const{appear:s,mode:o,persisted:a=!1,onBeforeEnter:l,onEnter:c,onAfterEnter:u,onEnterCancelled:h,onBeforeLeave:f,onLeave:p,onAfterLeave:g,onLeaveCancelled:M,onBeforeAppear:m,onAppear:d,onAfterAppear:x,onAppearCancelled:y}=e,S=String(n.key),C=Gh(t,n),A=(T,L)=>{T&&vn(T,i,9,L)},P=(T,L)=>{const D=L[1];A(T,L),Oe(T)?T.every(I=>I.length<=1)&&D():T.length<=1&&D()},v={mode:o,persisted:a,beforeEnter(T){let L=l;if(!t.isMounted)if(s)L=m||l;else return;T[gn]&&T[gn](!0);const D=C[S];D&&ji(n,D)&&D.el[gn]&&D.el[gn](),A(L,[T])},enter(T){if(C[S]===n)return;let L=c,D=u,I=h;if(!t.isMounted)if(s)L=d||c,D=x||u,I=y||h;else return;let k=!1;T[Yr]=O=>{k||(k=!0,O?A(I,[T]):A(D,[T]),v.delayedLeave&&v.delayedLeave(),T[Yr]=void 0)};const G=T[Yr].bind(null,!1);L?P(L,[T,G]):G()},leave(T,L){const D=String(n.key);if(T[Yr]&&T[Yr](!0),t.isUnmounting)return L();A(f,[T]);let I=!1;T[gn]=G=>{I||(I=!0,L(),G?A(M,[T]):A(g,[T]),T[gn]=void 0,C[D]===n&&delete C[D])};const k=T[gn].bind(null,!1);C[D]=n,p?P(p,[T,k]):k()},clone(T){const L=Es(T,e,t,i,r);return r&&r(L),L}};return v}function Aa(n){if(Is(n))return n=Ii(n),n.children=null,n}function du(n){if(!Is(n))return Oh(n.type)&&n.children?Vh(n.children):n;if(n.component)return n.component.subTree;const{shapeFlag:e,children:t}=n;if(t){if(e&16)return t[0];if(e&32&&Ge(t.default))return t.default()}}function sr(n,e){n.shapeFlag&6&&n.component?(n.transition=e,sr(n.component.subTree,e)):n.shapeFlag&128?(n.ssContent.transition=e.clone(n.ssContent),n.ssFallback.transition=e.clone(n.ssFallback)):n.transition=e}function Cc(n,e=!1,t){let i=[],r=0;for(let s=0;s<n.length;s++){let o=n[s];const a=t==null?o.key:String(t)+String(o.key!=null?o.key:s);o.type===sn?(o.patchFlag&128&&r++,i=i.concat(Cc(o.children,e,a))):(e||o.type!==Kt)&&i.push(a!=null?Ii(o,{key:a}):o)}if(r>1)for(let s=0;s<i.length;s++)i[s].patchFlag=-2;return i}function Am(n,e){return Ge(n)?wt({name:n.name},e,{setup:n}):n}function JE(){const n=lr();return n?(n.appContext.config.idPrefix||"v")+"-"+n.ids[0]+n.ids[1]++:""}function Pc(n){n.ids=[n.ids[0]+n.ids[2]+++"-",0,0]}function pu(n,e){let t;return!!((t=Object.getOwnPropertyDescriptor(n,e))&&!t.configurable)}const No=new WeakMap;function ps(n,e,t,i,r=!1){if(Oe(n)){n.forEach((M,m)=>ps(M,e&&(Oe(e)?e[m]:e),t,i,r));return}if(Ir(i)&&!r){i.shapeFlag&512&&i.type.__asyncResolved&&i.component.subTree.component&&ps(n,e,t,i.component.subTree);return}const s=i.shapeFlag&4?ha(i.component):i.el,o=r?null:s,{i:a,r:l}=n,c=e&&e.r,u=a.refs===ot?a.refs={}:a.refs,h=a.setupState,f=it(h),p=h===ot?ih:M=>pu(u,M)?!1:at(f,M),g=(M,m)=>!(m&&pu(u,m));if(c!=null&&c!==l){if(mu(e),xt(c))u[c]=null,p(c)&&(h[c]=null);else if(Nt(c)){const M=e;g(c,M.k)&&(c.value=null),M.k&&(u[M.k]=null)}}if(Ge(l))Ps(l,a,12,[o,u]);else{const M=xt(l),m=Nt(l);if(M||m){const d=()=>{if(n.f){const x=M?p(l)?h[l]:u[l]:g()||!n.k?l.value:u[n.k];if(r)Oe(x)&&vc(x,s);else if(Oe(x))x.includes(s)||x.push(s);else if(M)u[l]=[s],p(l)&&(h[l]=u[l]);else{const y=[s];g(l,n.k)&&(l.value=y),n.k&&(u[n.k]=y)}}else M?(u[l]=o,p(l)&&(h[l]=o)):m&&(g(l,n.k)&&(l.value=o),n.k&&(u[n.k]=o))};if(o){const x=()=>{d(),No.delete(n)};x.id=-1,No.set(n,x),tn(x,t)}else mu(n),d()}}}function mu(n){const e=No.get(n);e&&(e.flags|=8,No.delete(n))}const gu=n=>n.nodeType===8;ia().requestIdleCallback;ia().cancelIdleCallback;function wm(n,e){if(gu(n)&&n.data==="["){let t=1,i=n.nextSibling;for(;i;){if(i.nodeType===1){if(e(i)===!1)break}else if(gu(i))if(i.data==="]"){if(--t===0)break}else i.data==="["&&t++;i=i.nextSibling}}else e(n)}const Ir=n=>!!n.type.__asyncLoader;function QE(n){Ge(n)&&(n={loader:n});const{loader:e,loadingComponent:t,errorComponent:i,delay:r=200,hydrate:s,timeout:o,suspensible:a=!0,onError:l}=n;let c=null,u,h=0;const f=()=>(h++,c=null,p()),p=()=>{let g;return c||(g=c=e().catch(M=>{if(M=M instanceof Error?M:new Error(String(M)),l)return new Promise((m,d)=>{l(M,()=>m(f()),()=>d(M),h+1)});throw M}).then(M=>g!==c&&c?c:(M&&(M.__esModule||M[Symbol.toStringTag]==="Module")&&(M=M.default),u=M,M)))};return Am({name:"AsyncComponentWrapper",__asyncLoader:p,__asyncHydrate(g,M,m){let d=!1;(M.bu||(M.bu=[])).push(()=>d=!0);const x=()=>{d||m()},y=s?()=>{const S=s(x,C=>wm(g,C));S&&(M.bum||(M.bum=[])).push(S)}:x;u?y():p().then(()=>!M.isUnmounted&&y())},get __asyncResolved(){return u},setup(){const g=Ot;if(Pc(g),u)return()=>ks(u,g);const M=y=>{c=null,Ds(y,g,13,!i)};if(a&&g.suspense||Or)return p().then(y=>()=>ks(y,g)).catch(y=>(M(y),()=>i?Dt(i,{error:y}):null));const m=ba(!1),d=ba(),x=ba(!!r);return r&&setTimeout(()=>{x.value=!1},r),o!=null&&setTimeout(()=>{if(!m.value&&!d.value){const y=new Error(`Async component timed out after ${o}ms.`);M(y),d.value=y}},o),p().then(()=>{m.value=!0,g.parent&&Is(g.parent.vnode)&&g.parent.update()}).catch(y=>{M(y),d.value=y}),()=>{if(m.value&&u)return ks(u,g);if(d.value&&i)return Dt(i,{error:d.value});if(t&&!x.value)return ks(t,g)}}})}function ks(n,e){const{ref:t,props:i,children:r,ce:s}=e.vnode,o=Dt(n,i,r);return o.ref=t,o.ce=s,delete e.vnode.ce,o}const Is=n=>n.type.__isKeepAlive;function Rm(n,e){kh(n,"a",e)}function Cm(n,e){kh(n,"da",e)}function kh(n,e,t=Ot){const i=n.__wdc||(n.__wdc=()=>{let r=t;for(;r;){if(r.isDeactivated)return;r=r.parent}return n()});if(ca(e,i,t),t){let r=t.parent;for(;r&&r.parent;)Is(r.parent.vnode)&&Pm(i,e,t,r),r=r.parent}}function Pm(n,e,t,i){const r=ca(e,n,i,!0);qh(()=>{vc(i[e],r)},t)}function ca(n,e,t=Ot,i=!1){if(t){const r=t[n]||(t[n]=[]),s=e.__weh||(e.__weh=(...o)=>{li();const a=Ls(t),l=vn(e,t,n,o);return a(),ci(),l});return i?r.unshift(s):r.push(s),s}}const pi=n=>(e,t=Ot)=>{(!Or||n==="sp")&&ca(n,(...i)=>e(...i),t)},Dm=pi("bm"),Wh=pi("m"),Im=pi("bu"),Xh=pi("u"),Yh=pi("bum"),qh=pi("um"),Lm=pi("sp"),Um=pi("rtg"),Nm=pi("rtc");function Fm(n,e=Ot){ca("ec",n,e)}const Dc="components",Om="directives";function ey(n,e){return Ic(Dc,n,!0,e)||n}const Kh=Symbol.for("v-ndc");function ty(n){return xt(n)?Ic(Dc,n,!1)||n:n||Kh}function ny(n){return Ic(Om,n)}function Ic(n,e,t=!0,i=!1){const r=Bt||Ot;if(r){const s=r.type;if(n===Dc){const a=Sg(s,!1);if(a&&(a===e||a===Zt(e)||a===na(Zt(e))))return s}const o=_u(r[n]||s[n],e)||_u(r.appContext[n],e);return!o&&i?s:o}}function _u(n,e){return n&&(n[e]||n[Zt(e)]||n[na(Zt(e))])}function iy(n,e,t,i){let r;const s=t,o=Oe(n);if(o||xt(n)){const a=o&&ir(n);let l=!1,c=!1;a&&(l=!fn(n),c=ui(n),n=aa(n)),r=new Array(n.length);for(let u=0,h=n.length;u<h;u++)r[u]=e(l?c?Fr(wn(n[u])):wn(n[u]):n[u],u,void 0,s)}else if(typeof n=="number"){r=new Array(n);for(let a=0;a<n;a++)r[a]=e(a+1,a,void 0,s)}else if(ct(n))if(n[Symbol.iterator])r=Array.from(n,(a,l)=>e(a,l,void 0,s));else{const a=Object.keys(n);r=new Array(a.length);for(let l=0,c=a.length;l<c;l++){const u=a[l];r[l]=e(n[u],u,l,s)}}else r=[];return r}function ry(n,e,t={},i,r){if(Bt.ce||Bt.parent&&Ir(Bt.parent)&&Bt.parent.ce){const c=Object.keys(t).length>0;return e!=="default"&&(t.name=e),El(),yl(sn,null,[Dt("slot",t,i&&i())],c?-2:64)}let s=n[e];s&&s._c&&(s._d=!1),El();const o=s&&jh(s(t)),a=t.key||o&&o.key,l=yl(sn,{key:(a&&!hn(a)?a:`_${e}`)+(!o&&i?"_fb":"")},o||(i?i():[]),o&&n._===1?64:-2);return!r&&l.scopeId&&(l.slotScopeIds=[l.scopeId+"-s"]),s&&s._c&&(s._d=!0),l}function jh(n){return n.some(e=>bs(e)?!(e.type===Kt||e.type===sn&&!jh(e.children)):!0)?n:null}function sy(n,e){const t={};for(const i in n)t[vo(i)]=n[i];return t}const xl=n=>n?_d(n)?ha(n):xl(n.parent):null,ms=wt(Object.create(null),{$:n=>n,$el:n=>n.vnode.el,$data:n=>n.data,$props:n=>n.props,$attrs:n=>n.attrs,$slots:n=>n.slots,$refs:n=>n.refs,$parent:n=>xl(n.parent),$root:n=>xl(n.root),$host:n=>n.ce,$emit:n=>n.emit,$options:n=>Jh(n),$forceUpdate:n=>n.f||(n.f=()=>{wc(n.update)}),$nextTick:n=>n.n||(n.n=hm.bind(n.proxy)),$watch:n=>Mm.bind(n)}),wa=(n,e)=>n!==ot&&!n.__isScriptSetup&&at(n,e),Bm={get({_:n},e){if(e==="__v_skip")return!0;const{ctx:t,setupState:i,data:r,props:s,accessCache:o,type:a,appContext:l}=n;if(e[0]!=="$"){const f=o[e];if(f!==void 0)switch(f){case 1:return i[e];case 2:return r[e];case 4:return t[e];case 3:return s[e]}else{if(wa(i,e))return o[e]=1,i[e];if(r!==ot&&at(r,e))return o[e]=2,r[e];if(at(s,e))return o[e]=3,s[e];if(t!==ot&&at(t,e))return o[e]=4,t[e];vl&&(o[e]=0)}}const c=ms[e];let u,h;if(c)return e==="$attrs"&&qt(n.attrs,"get",""),c(n);if((u=a.__cssModules)&&(u=u[e]))return u;if(t!==ot&&at(t,e))return o[e]=4,t[e];if(h=l.config.globalProperties,at(h,e))return h[e]},set({_:n},e,t){const{data:i,setupState:r,ctx:s}=n;return wa(r,e)?(r[e]=t,!0):i!==ot&&at(i,e)?(i[e]=t,!0):at(n.props,e)||e[0]==="$"&&e.slice(1)in n?!1:(s[e]=t,!0)},has({_:{data:n,setupState:e,accessCache:t,ctx:i,appContext:r,props:s,type:o}},a){let l;return!!(t[a]||n!==ot&&a[0]!=="$"&&at(n,a)||wa(e,a)||at(s,a)||at(i,a)||at(ms,a)||at(r.config.globalProperties,a)||(l=o.__cssModules)&&l[a])},defineProperty(n,e,t){return t.get!=null?n._.accessCache[e]=0:at(t,"value")&&this.set(n,e,t.value,null),Reflect.defineProperty(n,e,t)}};function oy(){return Zh().slots}function ay(){return Zh().attrs}function Zh(n){const e=lr();return e.setupContext||(e.setupContext=vd(e))}function Fo(n){return Oe(n)?n.reduce((e,t)=>(e[t]=null,e),{}):n}function ly(n,e){return!n||!e?n||e:Oe(n)&&Oe(e)?n.concat(e):wt({},Fo(n),Fo(e))}let vl=!0;function zm(n){const e=Jh(n),t=n.proxy,i=n.ctx;vl=!1,e.beforeCreate&&xu(e.beforeCreate,n,"bc");const{data:r,computed:s,methods:o,watch:a,provide:l,inject:c,created:u,beforeMount:h,mounted:f,beforeUpdate:p,updated:g,activated:M,deactivated:m,beforeDestroy:d,beforeUnmount:x,destroyed:y,unmounted:S,render:C,renderTracked:A,renderTriggered:P,errorCaptured:v,serverPrefetch:T,expose:L,inheritAttrs:D,components:I,directives:k,filters:G}=e;if(c&&Hm(c,i,null),o)for(const H in o){const $=o[H];Ge($)&&(i[H]=$.bind(t))}if(r){const H=r.call(t,t);ct(H)&&(n.data=Tc(H))}if(vl=!0,s)for(const H in s){const $=s[H],oe=Ge($)?$.bind(t,t):Ge($.get)?$.get.bind(t,t):Gn,ve=!Ge($)&&Ge($.set)?$.set.bind(t):Gn,be=yg({get:oe,set:ve});Object.defineProperty(i,H,{enumerable:!0,configurable:!0,get:()=>be.value,set:we=>be.value=we})}if(a)for(const H in a)$h(a[H],i,t,H);if(l){const H=Ge(l)?l.call(t):l;Reflect.ownKeys(H).forEach($=>{gm($,H[$])})}u&&xu(u,n,"c");function V(H,$){Oe($)?$.forEach(oe=>H(oe.bind(t))):$&&H($.bind(t))}if(V(Dm,h),V(Wh,f),V(Im,p),V(Xh,g),V(Rm,M),V(Cm,m),V(Fm,v),V(Nm,A),V(Um,P),V(Yh,x),V(qh,S),V(Lm,T),Oe(L))if(L.length){const H=n.exposed||(n.exposed={});L.forEach($=>{Object.defineProperty(H,$,{get:()=>t[$],set:oe=>t[$]=oe,enumerable:!0})})}else n.exposed||(n.exposed={});C&&n.render===Gn&&(n.render=C),D!=null&&(n.inheritAttrs=D),I&&(n.components=I),k&&(n.directives=k),T&&Pc(n)}function Hm(n,e,t=Gn){Oe(n)&&(n=Ml(n));for(const i in n){const r=n[i];let s;ct(r)?"default"in r?s=So(r.from||i,r.default,!0):s=So(r.from||i):s=So(r),Nt(s)?Object.defineProperty(e,i,{enumerable:!0,configurable:!0,get:()=>s.value,set:o=>s.value=o}):e[i]=s}}function xu(n,e,t){vn(Oe(n)?n.map(i=>i.bind(e.proxy)):n.bind(e.proxy),e,t)}function $h(n,e,t,i){let r=i.includes(".")?Nh(t,i):()=>t[i];if(xt(n)){const s=e[n];Ge(s)&&Ta(r,s)}else if(Ge(n))Ta(r,n.bind(t));else if(ct(n))if(Oe(n))n.forEach(s=>$h(s,e,t,i));else{const s=Ge(n.handler)?n.handler.bind(t):e[n.handler];Ge(s)&&Ta(r,s,n)}}function Jh(n){const e=n.type,{mixins:t,extends:i}=e,{mixins:r,optionsCache:s,config:{optionMergeStrategies:o}}=n.appContext,a=s.get(e);let l;return a?l=a:!r.length&&!t&&!i?l=e:(l={},r.length&&r.forEach(c=>Oo(l,c,o,!0)),Oo(l,e,o)),ct(e)&&s.set(e,l),l}function Oo(n,e,t,i=!1){const{mixins:r,extends:s}=e;s&&Oo(n,s,t,!0),r&&r.forEach(o=>Oo(n,o,t,!0));for(const o in e)if(!(i&&o==="expose")){const a=Vm[o]||t&&t[o];n[o]=a?a(n[o],e[o]):e[o]}return n}const Vm={data:vu,props:Mu,emits:Mu,methods:ss,computed:ss,beforeCreate:Jt,created:Jt,beforeMount:Jt,mounted:Jt,beforeUpdate:Jt,updated:Jt,beforeDestroy:Jt,beforeUnmount:Jt,destroyed:Jt,unmounted:Jt,activated:Jt,deactivated:Jt,errorCaptured:Jt,serverPrefetch:Jt,components:ss,directives:ss,watch:km,provide:vu,inject:Gm};function vu(n,e){return e?n?function(){return wt(Ge(n)?n.call(this,this):n,Ge(e)?e.call(this,this):e)}:e:n}function Gm(n,e){return ss(Ml(n),Ml(e))}function Ml(n){if(Oe(n)){const e={};for(let t=0;t<n.length;t++)e[n[t]]=n[t];return e}return n}function Jt(n,e){return n?[...new Set([].concat(n,e))]:e}function ss(n,e){return n?wt(Object.create(null),n,e):e}function Mu(n,e){return n?Oe(n)&&Oe(e)?[...new Set([...n,...e])]:wt(Object.create(null),Fo(n),Fo(e??{})):e}function km(n,e){if(!n)return e;if(!e)return n;const t=wt(Object.create(null),n);for(const i in e)t[i]=Jt(n[i],e[i]);return t}function Qh(){return{app:null,config:{isNativeTag:ih,performance:!1,globalProperties:{},optionMergeStrategies:{},errorHandler:void 0,warnHandler:void 0,compilerOptions:{}},mixins:[],components:{},directives:{},provides:Object.create(null),optionsCache:new WeakMap,propsCache:new WeakMap,emitsCache:new WeakMap}}let Wm=0;function Xm(n,e){return function(i,r=null){Ge(i)||(i=wt({},i)),r!=null&&!ct(r)&&(r=null);const s=Qh(),o=new WeakSet,a=[];let l=!1;const c=s.app={_uid:Wm++,_component:i,_props:r,_container:null,_context:s,_instance:null,version:Tg,get config(){return s.config},set config(u){},use(u,...h){return o.has(u)||(u&&Ge(u.install)?(o.add(u),u.install(c,...h)):Ge(u)&&(o.add(u),u(c,...h))),c},mixin(u){return s.mixins.includes(u)||s.mixins.push(u),c},component(u,h){return h?(s.components[u]=h,c):s.components[u]},directive(u,h){return h?(s.directives[u]=h,c):s.directives[u]},mount(u,h,f){if(!l){const p=c._ceVNode||Dt(i,r);return p.appContext=s,f===!0?f="svg":f===!1&&(f=void 0),n(p,u,f),l=!0,c._container=u,u.__vue_app__=c,ha(p.component)}},onUnmount(u){a.push(u)},unmount(){l&&(vn(a,c._instance,16),n(null,c._container),delete c._container.__vue_app__)},provide(u,h){return s.provides[u]=h,c},runWithContext(u){const h=rr;rr=c;try{return u()}finally{rr=h}}};return c}}let rr=null;function cy(n,e,t=ot){const i=lr(),r=Zt(e),s=di(e),o=ed(n,r),a=rm((l,c)=>{let u,h=ot,f;return vm(()=>{const p=n[r];Yt(u,p)&&(u=p,c())}),{get(){return l(),t.get?t.get(u):u},set(p){const g=t.set?t.set(p):p;if(!Yt(g,u)&&!(h!==ot&&Yt(p,h)))return;const M=i.vnode.props;M&&(e in M||r in M||s in M)&&(`onUpdate:${e}`in M||`onUpdate:${r}`in M||`onUpdate:${s}`in M)||(u=p,c()),i.emit(`update:${e}`,g),Yt(p,g)&&Yt(p,h)&&!Yt(g,f)&&c(),h=p,f=g}}});return a[Symbol.iterator]=()=>{let l=0;return{next(){return l<2?{value:l++?o||ot:a,done:!1}:{done:!0}}}},a}const ed=(n,e)=>e==="modelValue"||e==="model-value"?n.modelModifiers:n[`${e}Modifiers`]||n[`${Zt(e)}Modifiers`]||n[`${di(e)}Modifiers`];function Ym(n,e,...t){if(n.isUnmounted)return;const i=n.vnode.props||ot;let r=t;const s=e.startsWith("update:"),o=s&&ed(i,e.slice(7));o&&(o.trim&&(r=t.map(u=>xt(u)?u.trim():u)),o.number&&(r=t.map(Mc)));let a,l=i[a=vo(e)]||i[a=vo(Zt(e))];!l&&s&&(l=i[a=vo(di(e))]),l&&vn(l,n,6,r);const c=i[a+"Once"];if(c){if(!n.emitted)n.emitted={};else if(n.emitted[a])return;n.emitted[a]=!0,vn(c,n,6,r)}}const qm=new WeakMap;function td(n,e,t=!1){const i=t?qm:e.emitsCache,r=i.get(n);if(r!==void 0)return r;const s=n.emits;let o={},a=!1;if(!Ge(n)){const l=c=>{const u=td(c,e,!0);u&&(a=!0,wt(o,u))};!t&&e.mixins.length&&e.mixins.forEach(l),n.extends&&l(n.extends),n.mixins&&n.mixins.forEach(l)}return!s&&!a?(ct(n)&&i.set(n,null),null):(Oe(s)?s.forEach(l=>o[l]=null):wt(o,s),ct(n)&&i.set(n,o),o)}function ua(n,e){return!n||!$o(e)?!1:(e=e.slice(2).replace(/Once$/,""),at(n,e[0].toLowerCase()+e.slice(1))||at(n,di(e))||at(n,e))}function Su(n){const{type:e,vnode:t,proxy:i,withProxy:r,propsOptions:[s],slots:o,attrs:a,emit:l,render:c,renderCache:u,props:h,data:f,setupState:p,ctx:g,inheritAttrs:M}=n,m=Uo(n);let d,x;try{if(t.shapeFlag&4){const S=r||i,C=S;d=On(c.call(C,S,u,h,p,f,g)),x=a}else{const S=e;d=On(S.length>1?S(h,{attrs:a,slots:o,emit:l}):S(h,null)),x=e.props?a:Km(a)}}catch(S){gs.length=0,Ds(S,n,1),d=Dt(Kt)}let y=d;if(x&&M!==!1){const S=Object.keys(x),{shapeFlag:C}=y;S.length&&C&7&&(s&&S.some(Jo)&&(x=jm(x,s)),y=Ii(y,x,!1,!0))}return t.dirs&&(y=Ii(y,null,!1,!0),y.dirs=y.dirs?y.dirs.concat(t.dirs):t.dirs),t.transition&&sr(y,t.transition),d=y,Uo(m),d}const Km=n=>{let e;for(const t in n)(t==="class"||t==="style"||$o(t))&&((e||(e={}))[t]=n[t]);return e},jm=(n,e)=>{const t={};for(const i in n)(!Jo(i)||!(i.slice(9)in e))&&(t[i]=n[i]);return t};function Zm(n,e,t){const{props:i,children:r,component:s}=n,{props:o,children:a,patchFlag:l}=e,c=s.emitsOptions;if(e.dirs||e.transition)return!0;if(t&&l>=0){if(l&1024)return!0;if(l&16)return i?Eu(i,o,c):!!o;if(l&8){const u=e.dynamicProps;for(let h=0;h<u.length;h++){const f=u[h];if(nd(o,i,f)&&!ua(c,f))return!0}}}else return(r||a)&&(!a||!a.$stable)?!0:i===o?!1:i?o?Eu(i,o,c):!0:!!o;return!1}function Eu(n,e,t){const i=Object.keys(e);if(i.length!==Object.keys(n).length)return!0;for(let r=0;r<i.length;r++){const s=i[r];if(nd(e,n,s)&&!ua(t,s))return!0}return!1}function nd(n,e,t){const i=n[t],r=e[t];return t==="style"&&ct(i)&&ct(r)?!Cs(i,r):i!==r}function $m({vnode:n,parent:e,suspense:t},i){for(;e;){const r=e.subTree;if(r.suspense&&r.suspense.activeBranch===n&&(r.suspense.vnode.el=r.el=i,n=r),r===n)(n=e.vnode).el=i,e=e.parent;else break}t&&t.activeBranch===n&&(t.vnode.el=i)}const id={},rd=()=>Object.create(id),sd=n=>Object.getPrototypeOf(n)===id;function Jm(n,e,t,i=!1){const r={},s=rd();n.propsDefaults=Object.create(null),od(n,e,r,s);for(const o in n.propsOptions[0])o in r||(r[o]=void 0);t?n.props=i?r:Qp(r):n.type.props?n.props=r:n.props=s,n.attrs=s}function Qm(n,e,t,i){const{props:r,attrs:s,vnode:{patchFlag:o}}=n,a=it(r),[l]=n.propsOptions;let c=!1;if((i||o>0)&&!(o&16)){if(o&8){const u=n.vnode.dynamicProps;for(let h=0;h<u.length;h++){let f=u[h];if(ua(n.emitsOptions,f))continue;const p=e[f];if(l)if(at(s,f))p!==s[f]&&(s[f]=p,c=!0);else{const g=Zt(f);r[g]=Sl(l,a,g,p,n,!1)}else p!==s[f]&&(s[f]=p,c=!0)}}}else{od(n,e,r,s)&&(c=!0);let u;for(const h in a)(!e||!at(e,h)&&((u=di(h))===h||!at(e,u)))&&(l?t&&(t[h]!==void 0||t[u]!==void 0)&&(r[h]=Sl(l,a,h,void 0,n,!0)):delete r[h]);if(s!==a)for(const h in s)(!e||!at(e,h))&&(delete s[h],c=!0)}c&&ii(n.attrs,"set","")}function od(n,e,t,i){const[r,s]=n.propsOptions;let o=!1,a;if(e)for(let l in e){if(fs(l))continue;const c=e[l];let u;r&&at(r,u=Zt(l))?!s||!s.includes(u)?t[u]=c:(a||(a={}))[u]=c:ua(n.emitsOptions,l)||(!(l in i)||c!==i[l])&&(i[l]=c,o=!0)}if(s){const l=it(t),c=a||ot;for(let u=0;u<s.length;u++){const h=s[u];t[h]=Sl(r,l,h,c[h],n,!at(c,h))}}return o}function Sl(n,e,t,i,r,s){const o=n[t];if(o!=null){const a=at(o,"default");if(a&&i===void 0){const l=o.default;if(o.type!==Function&&!o.skipFactory&&Ge(l)){const{propsDefaults:c}=r;if(t in c)i=c[t];else{const u=Ls(r);i=c[t]=l.call(null,e),u()}}else i=l;r.ce&&r.ce._setProp(t,i)}o[0]&&(s&&!a?i=!1:o[1]&&(i===""||i===di(t))&&(i=!0))}return i}const eg=new WeakMap;function ad(n,e,t=!1){const i=t?eg:e.propsCache,r=i.get(n);if(r)return r;const s=n.props,o={},a=[];let l=!1;if(!Ge(n)){const u=h=>{l=!0;const[f,p]=ad(h,e,!0);wt(o,f),p&&a.push(...p)};!t&&e.mixins.length&&e.mixins.forEach(u),n.extends&&u(n.extends),n.mixins&&n.mixins.forEach(u)}if(!s&&!l)return ct(n)&&i.set(n,Cr),Cr;if(Oe(s))for(let u=0;u<s.length;u++){const h=Zt(s[u]);yu(h)&&(o[h]=ot)}else if(s)for(const u in s){const h=Zt(u);if(yu(h)){const f=s[u],p=o[h]=Oe(f)||Ge(f)?{type:f}:wt({},f),g=p.type;let M=!1,m=!0;if(Oe(g))for(let d=0;d<g.length;++d){const x=g[d],y=Ge(x)&&x.name;if(y==="Boolean"){M=!0;break}else y==="String"&&(m=!1)}else M=Ge(g)&&g.name==="Boolean";p[0]=M,p[1]=m,(M||at(p,"default"))&&a.push(h)}}const c=[o,a];return ct(n)&&i.set(n,c),c}function yu(n){return n[0]!=="$"&&!fs(n)}const Lc=n=>n==="_"||n==="_ctx"||n==="$stable",Uc=n=>Oe(n)?n.map(On):[On(n)],tg=(n,e,t)=>{if(e._n)return e;const i=mm((...r)=>Uc(e(...r)),t);return i._c=!1,i},ld=(n,e,t)=>{const i=n._ctx;for(const r in n){if(Lc(r))continue;const s=n[r];if(Ge(s))e[r]=tg(r,s,i);else if(s!=null){const o=Uc(s);e[r]=()=>o}}},cd=(n,e)=>{const t=Uc(e);n.slots.default=()=>t},ud=(n,e,t)=>{for(const i in e)(t||!Lc(i))&&(n[i]=e[i])},ng=(n,e,t)=>{const i=n.slots=rd();if(n.vnode.shapeFlag&32){const r=e._;r?(ud(i,e,t),t&&ah(i,"_",r,!0)):ld(e,i)}else e&&cd(n,e)},ig=(n,e,t)=>{const{vnode:i,slots:r}=n;let s=!0,o=ot;if(i.shapeFlag&32){const a=e._;a?t&&a===1?s=!1:ud(r,e,t):(s=!e.$stable,ld(e,r)),o=e}else e&&(cd(n,e),o={default:1});if(s)for(const a in r)!Lc(a)&&o[a]==null&&delete r[a]},tn=lg;function rg(n){return sg(n)}function sg(n,e){const t=ia();t.__VUE__=!0;const{insert:i,remove:r,patchProp:s,createElement:o,createText:a,createComment:l,setText:c,setElementText:u,parentNode:h,nextSibling:f,setScopeId:p=Gn,insertStaticContent:g}=n,M=(R,U,W,ee=null,K=null,Q=null,le=void 0,fe=null,w=!!U.dynamicChildren)=>{if(R===U)return;R&&!ji(R,U)&&(ee=Se(R),we(R,K,Q,!0),R=null),U.patchFlag===-2&&(w=!1,U.dynamicChildren=null);const{type:ne,ref:pe,shapeFlag:ce}=U;switch(ne){case fa:m(R,U,W,ee);break;case Kt:d(R,U,W,ee);break;case Eo:R==null&&x(U,W,ee,le);break;case sn:I(R,U,W,ee,K,Q,le,fe,w);break;default:ce&1?C(R,U,W,ee,K,Q,le,fe,w):ce&6?k(R,U,W,ee,K,Q,le,fe,w):(ce&64||ce&128)&&ne.process(R,U,W,ee,K,Q,le,fe,w,He)}pe!=null&&K?ps(pe,R&&R.ref,Q,U||R,!U):pe==null&&R&&R.ref!=null&&ps(R.ref,null,Q,R,!0)},m=(R,U,W,ee)=>{if(R==null)i(U.el=a(U.children),W,ee);else{const K=U.el=R.el;U.children!==R.children&&c(K,U.children)}},d=(R,U,W,ee)=>{R==null?i(U.el=l(U.children||""),W,ee):U.el=R.el},x=(R,U,W,ee)=>{[R.el,R.anchor]=g(R.children,U,W,ee,R.el,R.anchor)},y=({el:R,anchor:U},W,ee)=>{let K;for(;R&&R!==U;)K=f(R),i(R,W,ee),R=K;i(U,W,ee)},S=({el:R,anchor:U})=>{let W;for(;R&&R!==U;)W=f(R),r(R),R=W;r(U)},C=(R,U,W,ee,K,Q,le,fe,w)=>{if(U.type==="svg"?le="svg":U.type==="math"&&(le="mathml"),R==null)A(U,W,ee,K,Q,le,fe,w);else{const ne=R.el&&R.el._isVueCE?R.el:null;try{ne&&ne._beginPatch(),T(R,U,K,Q,le,fe,w)}finally{ne&&ne._endPatch()}}},A=(R,U,W,ee,K,Q,le,fe)=>{let w,ne;const{props:pe,shapeFlag:ce,transition:J,dirs:Re}=R;if(w=R.el=o(R.type,Q,pe&&pe.is,pe),ce&8?u(w,R.children):ce&16&&v(R.children,w,null,ee,K,Ra(R,Q),le,fe),Re&&Oi(R,null,ee,"created"),P(w,R,R.scopeId,le,ee),pe){for(const _ in pe)_!=="value"&&!fs(_)&&s(w,_,null,pe[_],Q,ee);"value"in pe&&s(w,"value",null,pe.value,Q),(ne=pe.onVnodeBeforeMount)&&Pn(ne,ee,R)}Re&&Oi(R,null,ee,"beforeMount");const b=og(K,J);b&&J.beforeEnter(w),i(w,U,W),((ne=pe&&pe.onVnodeMounted)||b||Re)&&tn(()=>{ne&&Pn(ne,ee,R),b&&J.enter(w),Re&&Oi(R,null,ee,"mounted")},K)},P=(R,U,W,ee,K)=>{if(W&&p(R,W),ee)for(let Q=0;Q<ee.length;Q++)p(R,ee[Q]);if(K){let Q=K.subTree;if(U===Q||dd(Q.type)&&(Q.ssContent===U||Q.ssFallback===U)){const le=K.vnode;P(R,le,le.scopeId,le.slotScopeIds,K.parent)}}},v=(R,U,W,ee,K,Q,le,fe,w=0)=>{for(let ne=w;ne<R.length;ne++){const pe=R[ne]=fe?ni(R[ne]):On(R[ne]);M(null,pe,U,W,ee,K,Q,le,fe)}},T=(R,U,W,ee,K,Q,le)=>{const fe=U.el=R.el;let{patchFlag:w,dynamicChildren:ne,dirs:pe}=U;w|=R.patchFlag&16;const ce=R.props||ot,J=U.props||ot;let Re;if(W&&Bi(W,!1),(Re=J.onVnodeBeforeUpdate)&&Pn(Re,W,U,R),pe&&Oi(U,R,W,"beforeUpdate"),W&&Bi(W,!0),(ce.innerHTML&&J.innerHTML==null||ce.textContent&&J.textContent==null)&&u(fe,""),ne?L(R.dynamicChildren,ne,fe,W,ee,Ra(U,K),Q):le||$(R,U,fe,null,W,ee,Ra(U,K),Q,!1),w>0){if(w&16)D(fe,ce,J,W,K);else if(w&2&&ce.class!==J.class&&s(fe,"class",null,J.class,K),w&4&&s(fe,"style",ce.style,J.style,K),w&8){const b=U.dynamicProps;for(let _=0;_<b.length;_++){const B=b[_],j=ce[B],ie=J[B];(ie!==j||B==="value")&&s(fe,B,j,ie,K,W)}}w&1&&R.children!==U.children&&u(fe,U.children)}else!le&&ne==null&&D(fe,ce,J,W,K);((Re=J.onVnodeUpdated)||pe)&&tn(()=>{Re&&Pn(Re,W,U,R),pe&&Oi(U,R,W,"updated")},ee)},L=(R,U,W,ee,K,Q,le)=>{for(let fe=0;fe<U.length;fe++){const w=R[fe],ne=U[fe],pe=w.el&&(w.type===sn||!ji(w,ne)||w.shapeFlag&198)?h(w.el):W;M(w,ne,pe,null,ee,K,Q,le,!0)}},D=(R,U,W,ee,K)=>{if(U!==W){if(U!==ot)for(const Q in U)!fs(Q)&&!(Q in W)&&s(R,Q,U[Q],null,K,ee);for(const Q in W){if(fs(Q))continue;const le=W[Q],fe=U[Q];le!==fe&&Q!=="value"&&s(R,Q,fe,le,K,ee)}"value"in W&&s(R,"value",U.value,W.value,K)}},I=(R,U,W,ee,K,Q,le,fe,w)=>{const ne=U.el=R?R.el:a(""),pe=U.anchor=R?R.anchor:a("");let{patchFlag:ce,dynamicChildren:J,slotScopeIds:Re}=U;Re&&(fe=fe?fe.concat(Re):Re),R==null?(i(ne,W,ee),i(pe,W,ee),v(U.children||[],W,pe,K,Q,le,fe,w)):ce>0&&ce&64&&J&&R.dynamicChildren&&R.dynamicChildren.length===J.length?(L(R.dynamicChildren,J,W,K,Q,le,fe),(U.key!=null||K&&U===K.subTree)&&Nc(R,U,!0)):$(R,U,W,pe,K,Q,le,fe,w)},k=(R,U,W,ee,K,Q,le,fe,w)=>{U.slotScopeIds=fe,R==null?U.shapeFlag&512?K.ctx.activate(U,W,ee,le,w):G(U,W,ee,K,Q,le,w):O(R,U,w)},G=(R,U,W,ee,K,Q,le)=>{const fe=R.component=_g(R,ee,K);if(Is(R)&&(fe.ctx.renderer=He),xg(fe,!1,le),fe.asyncDep){if(K&&K.registerDep(fe,V,le),!R.el){const w=fe.subTree=Dt(Kt);d(null,w,U,W),R.placeholder=w.el}}else V(fe,R,U,W,K,Q,le)},O=(R,U,W)=>{const ee=U.component=R.component;if(Zm(R,U,W))if(ee.asyncDep&&!ee.asyncResolved){H(ee,U,W);return}else ee.next=U,ee.update();else U.el=R.el,ee.vnode=U},V=(R,U,W,ee,K,Q,le)=>{const fe=()=>{if(R.isMounted){let{next:ce,bu:J,u:Re,parent:b,vnode:_}=R;{const he=fd(R);if(he){ce&&(ce.el=_.el,H(R,ce,le)),he.asyncDep.then(()=>{tn(()=>{R.isUnmounted||ne()},K)});return}}let B=ce,j;Bi(R,!1),ce?(ce.el=_.el,H(R,ce,le)):ce=_,J&&Mo(J),(j=ce.props&&ce.props.onVnodeBeforeUpdate)&&Pn(j,b,ce,_),Bi(R,!0);const ie=Su(R),ue=R.subTree;R.subTree=ie,M(ue,ie,h(ue.el),Se(ue),R,K,Q),ce.el=ie.el,B===null&&$m(R,ie.el),Re&&tn(Re,K),(j=ce.props&&ce.props.onVnodeUpdated)&&tn(()=>Pn(j,b,ce,_),K)}else{let ce;const{el:J,props:Re}=U,{bm:b,m:_,parent:B,root:j,type:ie}=R,ue=Ir(U);Bi(R,!1),b&&Mo(b),!ue&&(ce=Re&&Re.onVnodeBeforeMount)&&Pn(ce,B,U),Bi(R,!0);{j.ce&&j.ce._hasShadowRoot()&&j.ce._injectChildStyle(ie,R.parent?R.parent.type:void 0);const he=R.subTree=Su(R);M(null,he,W,ee,R,K,Q),U.el=he.el}if(_&&tn(_,K),!ue&&(ce=Re&&Re.onVnodeMounted)){const he=U;tn(()=>Pn(ce,B,he),K)}(U.shapeFlag&256||B&&Ir(B.vnode)&&B.vnode.shapeFlag&256)&&R.a&&tn(R.a,K),R.isMounted=!0,U=W=ee=null}};R.scope.on();const w=R.effect=new dh(fe);R.scope.off();const ne=R.update=w.run.bind(w),pe=R.job=w.runIfDirty.bind(w);pe.i=R,pe.id=R.uid,w.scheduler=()=>wc(pe),Bi(R,!0),ne()},H=(R,U,W)=>{U.component=R;const ee=R.vnode.props;R.vnode=U,R.next=null,Qm(R,U.props,ee,W),ig(R,U.children,W),li(),uu(R),ci()},$=(R,U,W,ee,K,Q,le,fe,w=!1)=>{const ne=R&&R.children,pe=R?R.shapeFlag:0,ce=U.children,{patchFlag:J,shapeFlag:Re}=U;if(J>0){if(J&128){ve(ne,ce,W,ee,K,Q,le,fe,w);return}else if(J&256){oe(ne,ce,W,ee,K,Q,le,fe,w);return}}Re&8?(pe&16&&se(ne,K,Q),ce!==ne&&u(W,ce)):pe&16?Re&16?ve(ne,ce,W,ee,K,Q,le,fe,w):se(ne,K,Q,!0):(pe&8&&u(W,""),Re&16&&v(ce,W,ee,K,Q,le,fe,w))},oe=(R,U,W,ee,K,Q,le,fe,w)=>{R=R||Cr,U=U||Cr;const ne=R.length,pe=U.length,ce=Math.min(ne,pe);let J;for(J=0;J<ce;J++){const Re=U[J]=w?ni(U[J]):On(U[J]);M(R[J],Re,W,null,K,Q,le,fe,w)}ne>pe?se(R,K,Q,!0,!1,ce):v(U,W,ee,K,Q,le,fe,w,ce)},ve=(R,U,W,ee,K,Q,le,fe,w)=>{let ne=0;const pe=U.length;let ce=R.length-1,J=pe-1;for(;ne<=ce&&ne<=J;){const Re=R[ne],b=U[ne]=w?ni(U[ne]):On(U[ne]);if(ji(Re,b))M(Re,b,W,null,K,Q,le,fe,w);else break;ne++}for(;ne<=ce&&ne<=J;){const Re=R[ce],b=U[J]=w?ni(U[J]):On(U[J]);if(ji(Re,b))M(Re,b,W,null,K,Q,le,fe,w);else break;ce--,J--}if(ne>ce){if(ne<=J){const Re=J+1,b=Re<pe?U[Re].el:ee;for(;ne<=J;)M(null,U[ne]=w?ni(U[ne]):On(U[ne]),W,b,K,Q,le,fe,w),ne++}}else if(ne>J)for(;ne<=ce;)we(R[ne],K,Q,!0),ne++;else{const Re=ne,b=ne,_=new Map;for(ne=b;ne<=J;ne++){const ge=U[ne]=w?ni(U[ne]):On(U[ne]);ge.key!=null&&_.set(ge.key,ne)}let B,j=0;const ie=J-b+1;let ue=!1,he=0;const Z=new Array(ie);for(ne=0;ne<ie;ne++)Z[ne]=0;for(ne=Re;ne<=ce;ne++){const ge=R[ne];if(j>=ie){we(ge,K,Q,!0);continue}let Ee;if(ge.key!=null)Ee=_.get(ge.key);else for(B=b;B<=J;B++)if(Z[B-b]===0&&ji(ge,U[B])){Ee=B;break}Ee===void 0?we(ge,K,Q,!0):(Z[Ee-b]=ne+1,Ee>=he?he=Ee:ue=!0,M(ge,U[Ee],W,null,K,Q,le,fe,w),j++)}const re=ue?ag(Z):Cr;for(B=re.length-1,ne=ie-1;ne>=0;ne--){const ge=b+ne,Ee=U[ge],_e=U[ge+1],de=ge+1<pe?_e.el||hd(_e):ee;Z[ne]===0?M(null,Ee,W,de,K,Q,le,fe,w):ue&&(B<0||ne!==re[B]?be(Ee,W,de,2):B--)}}},be=(R,U,W,ee,K=null)=>{const{el:Q,type:le,transition:fe,children:w,shapeFlag:ne}=R;if(ne&6){be(R.component.subTree,U,W,ee);return}if(ne&128){R.suspense.move(U,W,ee);return}if(ne&64){le.move(R,U,W,He);return}if(le===sn){i(Q,U,W);for(let ce=0;ce<w.length;ce++)be(w[ce],U,W,ee);i(R.anchor,U,W);return}if(le===Eo){y(R,U,W);return}if(ee!==2&&ne&1&&fe)if(ee===0)fe.persisted&&!Q[gn]?i(Q,U,W):(fe.beforeEnter(Q),i(Q,U,W),tn(()=>fe.enter(Q),K));else{const{leave:ce,delayLeave:J,afterLeave:Re}=fe,b=()=>{R.ctx.isUnmounted?r(Q):i(Q,U,W)},_=()=>{const B=Q._isLeaving||!!Q[gn];Q._isLeaving&&Q[gn](!0),fe.persisted&&!B?b():ce(Q,()=>{b(),Re&&Re()})};J?J(Q,b,_):_()}else i(Q,U,W)},we=(R,U,W,ee=!1,K=!1)=>{const{type:Q,props:le,ref:fe,children:w,dynamicChildren:ne,shapeFlag:pe,patchFlag:ce,dirs:J,cacheIndex:Re,memo:b}=R;if(ce===-2&&(K=!1),fe!=null&&(li(),ps(fe,null,W,R,!0),ci()),Re!=null&&(U.renderCache[Re]=void 0),pe&256){U.ctx.deactivate(R);return}const _=pe&1&&J,B=!Ir(R);let j;if(B&&(j=le&&le.onVnodeBeforeUnmount)&&Pn(j,U,R),pe&6)We(R.component,W,ee);else{if(pe&128){R.suspense.unmount(W,ee);return}_&&Oi(R,null,U,"beforeUnmount"),pe&64?R.type.remove(R,U,W,He,ee):ne&&!ne.hasOnce&&(Q!==sn||ce>0&&ce&64)?se(ne,U,W,!1,!0):(Q===sn&&ce&384||!K&&pe&16)&&se(w,U,W),ee&&$e(R)}const ie=b!=null&&Re==null;(B&&(j=le&&le.onVnodeUnmounted)||_||ie)&&tn(()=>{j&&Pn(j,U,R),_&&Oi(R,null,U,"unmounted"),ie&&(R.el=null)},W)},$e=R=>{const{type:U,el:W,anchor:ee,transition:K}=R;if(U===sn){tt(W,ee);return}if(U===Eo){S(R);return}const Q=()=>{r(W),K&&!K.persisted&&K.afterLeave&&K.afterLeave()};if(R.shapeFlag&1&&K&&!K.persisted){const{leave:le,delayLeave:fe}=K,w=()=>le(W,Q);fe?fe(R.el,Q,w):w()}else Q()},tt=(R,U)=>{let W;for(;R!==U;)W=f(R),r(R),R=W;r(U)},We=(R,U,W)=>{const{bum:ee,scope:K,job:Q,subTree:le,um:fe,m:w,a:ne}=R;bu(w),bu(ne),ee&&Mo(ee),K.stop(),Q&&(Q.flags|=8,we(le,R,U,W)),fe&&tn(fe,U),tn(()=>{R.isUnmounted=!0},U)},se=(R,U,W,ee=!1,K=!1,Q=0)=>{for(let le=Q;le<R.length;le++)we(R[le],U,W,ee,K)},Se=R=>{if(R.shapeFlag&6)return Se(R.component.subTree);if(R.shapeFlag&128)return R.suspense.next();const U=f(R.anchor||R.el),W=U&&U[Fh];return W?f(W):U};let me=!1;const Be=(R,U,W)=>{let ee;R==null?U._vnode&&(we(U._vnode,null,null,!0),ee=U._vnode.component):M(U._vnode||null,R,U,null,null,null,W),U._vnode=R,me||(me=!0,uu(ee),Ih(),me=!1)},He={p:M,um:we,m:be,r:$e,mt:G,mc:v,pc:$,pbc:L,n:Se,o:n};return{render:Be,hydrate:void 0,createApp:Xm(Be)}}function Ra({type:n,props:e},t){return t==="svg"&&n==="foreignObject"||t==="mathml"&&n==="annotation-xml"&&e&&e.encoding&&e.encoding.includes("html")?void 0:t}function Bi({effect:n,job:e},t){t?(n.flags|=32,e.flags|=4):(n.flags&=-33,e.flags&=-5)}function og(n,e){return(!n||n&&!n.pendingBranch)&&e&&!e.persisted}function Nc(n,e,t=!1){const i=n.children,r=e.children;if(Oe(i)&&Oe(r))for(let s=0;s<i.length;s++){const o=i[s];let a=r[s];a.shapeFlag&1&&!a.dynamicChildren&&((a.patchFlag<=0||a.patchFlag===32)&&(a=r[s]=ni(r[s]),a.el=o.el),!t&&a.patchFlag!==-2&&Nc(o,a)),a.type===fa&&(a.patchFlag===-1&&(a=r[s]=ni(a)),a.el=o.el),a.type===Kt&&!a.el&&(a.el=o.el)}}function ag(n){const e=n.slice(),t=[0];let i,r,s,o,a;const l=n.length;for(i=0;i<l;i++){const c=n[i];if(c!==0){if(r=t[t.length-1],n[r]<c){e[i]=r,t.push(i);continue}for(s=0,o=t.length-1;s<o;)a=s+o>>1,n[t[a]]<c?s=a+1:o=a;c<n[t[s]]&&(s>0&&(e[i]=t[s-1]),t[s]=i)}}for(s=t.length,o=t[s-1];s-- >0;)t[s]=o,o=e[o];return t}function fd(n){const e=n.subTree.component;if(e)return e.asyncDep&&!e.asyncResolved?e:fd(e)}function bu(n){if(n)for(let e=0;e<n.length;e++)n[e].flags|=8}function hd(n){if(n.placeholder)return n.placeholder;const e=n.component;return e?hd(e.subTree):null}const dd=n=>n.__isSuspense;function lg(n,e){e&&e.pendingBranch?Oe(n)?e.effects.push(...n):e.effects.push(n):pm(n)}const sn=Symbol.for("v-fgt"),fa=Symbol.for("v-txt"),Kt=Symbol.for("v-cmt"),Eo=Symbol.for("v-stc"),gs=[];let un=null;function El(n=!1){gs.push(un=n?null:[])}function cg(){gs.pop(),un=gs[gs.length-1]||null}let ys=1;function Bo(n,e=!1){ys+=n,n<0&&un&&e&&(un.hasOnce=!0)}function pd(n){return n.dynamicChildren=ys>0?un||Cr:null,cg(),ys>0&&un&&un.push(n),n}function uy(n,e,t,i,r,s){return pd(gd(n,e,t,i,r,s,!0))}function yl(n,e,t,i,r){return pd(Dt(n,e,t,i,r,!0))}function bs(n){return n?n.__v_isVNode===!0:!1}function ji(n,e){return n.type===e.type&&n.key===e.key}const md=({key:n})=>n??null,yo=({ref:n,ref_key:e,ref_for:t})=>(typeof n=="number"&&(n=""+n),n!=null?xt(n)||Nt(n)||Ge(n)?{i:Bt,r:n,k:e,f:!!t}:n:null);function gd(n,e=null,t=null,i=0,r=null,s=n===sn?0:1,o=!1,a=!1){const l={__v_isVNode:!0,__v_skip:!0,type:n,props:e,key:e&&md(e),ref:e&&yo(e),scopeId:Uh,slotScopeIds:null,children:t,component:null,suspense:null,ssContent:null,ssFallback:null,dirs:null,transition:null,el:null,anchor:null,target:null,targetStart:null,targetAnchor:null,staticCount:0,shapeFlag:s,patchFlag:i,dynamicProps:r,dynamicChildren:null,appContext:null,ctx:Bt};return a?(Fc(l,t),s&128&&n.normalize(l)):t&&(l.shapeFlag|=xt(t)?8:16),ys>0&&!o&&un&&(l.patchFlag>0||s&6)&&l.patchFlag!==32&&un.push(l),l}const Dt=ug;function ug(n,e=null,t=null,i=0,r=null,s=!1){if((!n||n===Kh)&&(n=Kt),bs(n)){const a=Ii(n,e,!0);return t&&Fc(a,t),ys>0&&!s&&un&&(a.shapeFlag&6?un[un.indexOf(n)]=a:un.push(a)),a.patchFlag=-2,a}if(Eg(n)&&(n=n.__vccOpts),e){e=fg(e);let{class:a,style:l}=e;a&&!xt(a)&&(e.class=sa(a)),ct(l)&&(la(l)&&!Oe(l)&&(l=wt({},l)),e.style=ra(l))}const o=xt(n)?1:dd(n)?128:Oh(n)?64:ct(n)?4:Ge(n)?2:0;return gd(n,e,t,i,r,o,s,!0)}function fg(n){return n?la(n)||sd(n)?wt({},n):n:null}function Ii(n,e,t=!1,i=!1){const{props:r,ref:s,patchFlag:o,children:a,transition:l}=n,c=e?pg(r||{},e):r,u={__v_isVNode:!0,__v_skip:!0,type:n.type,props:c,key:c&&md(c),ref:e&&e.ref?t&&s?Oe(s)?s.concat(yo(e)):[s,yo(e)]:yo(e):s,scopeId:n.scopeId,slotScopeIds:n.slotScopeIds,children:a,target:n.target,targetStart:n.targetStart,targetAnchor:n.targetAnchor,staticCount:n.staticCount,shapeFlag:n.shapeFlag,patchFlag:e&&n.type!==sn?o===-1?16:o|16:o,dynamicProps:n.dynamicProps,dynamicChildren:n.dynamicChildren,appContext:n.appContext,dirs:n.dirs,transition:l,component:n.component,suspense:n.suspense,ssContent:n.ssContent&&Ii(n.ssContent),ssFallback:n.ssFallback&&Ii(n.ssFallback),placeholder:n.placeholder,el:n.el,anchor:n.anchor,ctx:n.ctx,ce:n.ce};return l&&i&&sr(u,l.clone(u)),u}function hg(n=" ",e=0){return Dt(fa,null,n,e)}function fy(n,e){const t=Dt(Eo,null,n);return t.staticCount=e,t}function dg(n="",e=!1){return e?(El(),yl(Kt,null,n)):Dt(Kt,null,n)}function On(n){return n==null||typeof n=="boolean"?Dt(Kt):Oe(n)?Dt(sn,null,n.slice()):bs(n)?ni(n):Dt(fa,null,String(n))}function ni(n){return n.el===null&&n.patchFlag!==-1||n.memo?n:Ii(n)}function Fc(n,e){let t=0;const{shapeFlag:i}=n;if(e==null)e=null;else if(Oe(e))t=16;else if(typeof e=="object")if(i&65){const r=e.default;r&&(r._c&&(r._d=!1),Fc(n,r()),r._c&&(r._d=!0));return}else{t=32;const r=e._;!r&&!sd(e)?e._ctx=Bt:r===3&&Bt&&(Bt.slots._===1?e._=1:(e._=2,n.patchFlag|=1024))}else Ge(e)?(e={default:e,_ctx:Bt},t=32):(e=String(e),i&64?(t=16,e=[hg(e)]):t=8);n.children=e,n.shapeFlag|=t}function pg(...n){const e={};for(let t=0;t<n.length;t++){const i=n[t];for(const r in i)if(r==="class")e.class!==i.class&&(e.class=sa([e.class,i.class]));else if(r==="style")e.style=ra([e.style,i.style]);else if($o(r)){const s=e[r],o=i[r];o&&s!==o&&!(Oe(s)&&s.includes(o))?e[r]=s?[].concat(s,o):o:o==null&&s==null&&!Jo(r)&&(e[r]=o)}else r!==""&&(e[r]=i[r])}return e}function Pn(n,e,t,i=null){vn(n,e,7,[t,i])}const mg=Qh();let gg=0;function _g(n,e,t){const i=n.type,r=(e?e.appContext:n.appContext)||mg,s={uid:gg++,vnode:n,type:i,parent:e,appContext:r,root:null,next:null,subTree:null,effect:null,update:null,job:null,scope:new hh(!0),render:null,proxy:null,exposed:null,exposeProxy:null,withProxy:null,provides:e?e.provides:Object.create(r.provides),ids:e?e.ids:["",0,0],accessCache:null,renderCache:[],components:null,directives:null,propsOptions:ad(i,r),emitsOptions:td(i,r),emit:null,emitted:null,propsDefaults:ot,inheritAttrs:i.inheritAttrs,ctx:ot,data:ot,props:ot,attrs:ot,slots:ot,refs:ot,setupState:ot,setupContext:null,suspense:t,suspenseId:t?t.pendingId:0,asyncDep:null,asyncResolved:!1,isMounted:!1,isUnmounted:!1,isDeactivated:!1,bc:null,c:null,bm:null,m:null,bu:null,u:null,um:null,bum:null,da:null,a:null,rtg:null,rtc:null,ec:null,sp:null};return s.ctx={_:s},s.root=e?e.root:s,s.emit=Ym.bind(null,s),n.ce&&n.ce(s),s}let Ot=null;const lr=()=>Ot||Bt;let zo,bl;{const n=ia(),e=(t,i)=>{let r;return(r=n[t])||(r=n[t]=[]),r.push(i),s=>{r.length>1?r.forEach(o=>o(s)):r[0](s)}};zo=e("__VUE_INSTANCE_SETTERS__",t=>Ot=t),bl=e("__VUE_SSR_SETTERS__",t=>Or=t)}const Ls=n=>{const e=Ot;return zo(n),n.scope.on(),()=>{n.scope.off(),zo(e)}},Tu=()=>{Ot&&Ot.scope.off(),zo(null)};function _d(n){return n.vnode.shapeFlag&4}let Or=!1;function xg(n,e=!1,t=!1){e&&bl(e);const{props:i,children:r}=n.vnode,s=_d(n);Jm(n,i,s,e),ng(n,r,t||e);const o=s?vg(n,e):void 0;return e&&bl(!1),o}function vg(n,e){const t=n.type;n.accessCache=Object.create(null),n.proxy=new Proxy(n.ctx,Bm);const{setup:i}=t;if(i){li();const r=n.setupContext=i.length>1?vd(n):null,s=Ls(n),o=Ps(i,n,0,[n.props,r]),a=rh(o);if(ci(),s(),(a||n.sp)&&!Ir(n)&&Pc(n),a){if(o.then(Tu,Tu),e)return o.then(l=>{Au(n,l)}).catch(l=>{Ds(l,n,0)});n.asyncDep=o}else Au(n,o)}else xd(n)}function Au(n,e,t){Ge(e)?n.type.__ssrInlineRender?n.ssrRender=e:n.render=e:ct(e)&&(n.setupState=Ch(e)),xd(n)}function xd(n,e,t){const i=n.type;n.render||(n.render=i.render||Gn);{const r=Ls(n);li();try{zm(n)}finally{ci(),r()}}}const Mg={get(n,e){return qt(n,"get",""),n[e]}};function vd(n){const e=t=>{n.exposed=t||{}};return{attrs:new Proxy(n.attrs,Mg),slots:n.slots,emit:n.emit,expose:e}}function ha(n){return n.exposed?n.exposeProxy||(n.exposeProxy=new Proxy(Ch(em(n.exposed)),{get(e,t){if(t in e)return e[t];if(t in ms)return ms[t](n)},has(e,t){return t in e||t in ms}})):n.proxy}function Sg(n,e=!0){return Ge(n)?n.displayName||n.name:n.name||e&&n.__name}function Eg(n){return Ge(n)&&"__vccOpts"in n}const yg=(n,e)=>lm(n,e,Or);function bg(n,e,t){try{Bo(-1);const i=arguments.length;return i===2?ct(e)&&!Oe(e)?bs(e)?Dt(n,null,[e]):Dt(n,e):Dt(n,null,e):(i>3?t=Array.prototype.slice.call(arguments,2):i===3&&bs(t)&&(t=[t]),Dt(n,e,t))}finally{Bo(1)}}const Tg="3.5.35";let Tl;const wu=typeof window<"u"&&window.trustedTypes;if(wu)try{Tl=wu.createPolicy("vue",{createHTML:n=>n})}catch{}const Md=Tl?n=>Tl.createHTML(n):n=>n,Ag="http://www.w3.org/2000/svg",wg="http://www.w3.org/1998/Math/MathML",ti=typeof document<"u"?document:null,Ru=ti&&ti.createElement("template"),Rg={insert:(n,e,t)=>{e.insertBefore(n,t||null)},remove:n=>{const e=n.parentNode;e&&e.removeChild(n)},createElement:(n,e,t,i)=>{const r=e==="svg"?ti.createElementNS(Ag,n):e==="mathml"?ti.createElementNS(wg,n):t?ti.createElement(n,{is:t}):ti.createElement(n);return n==="select"&&i&&i.multiple!=null&&r.setAttribute("multiple",i.multiple),r},createText:n=>ti.createTextNode(n),createComment:n=>ti.createComment(n),setText:(n,e)=>{n.nodeValue=e},setElementText:(n,e)=>{n.textContent=e},parentNode:n=>n.parentNode,nextSibling:n=>n.nextSibling,querySelector:n=>ti.querySelector(n),setScopeId(n,e){n.setAttribute(e,"")},insertStaticContent(n,e,t,i,r,s){const o=t?t.previousSibling:e.lastChild;if(r&&(r===s||r.nextSibling))for(;e.insertBefore(r.cloneNode(!0),t),!(r===s||!(r=r.nextSibling)););else{Ru.innerHTML=Md(i==="svg"?`<svg>${n}</svg>`:i==="mathml"?`<math>${n}</math>`:n);const a=Ru.content;if(i==="svg"||i==="mathml"){const l=a.firstChild;for(;l.firstChild;)a.appendChild(l.firstChild);a.removeChild(l)}e.insertBefore(a,t)}return[o?o.nextSibling:e.firstChild,t?t.previousSibling:e.lastChild]}},xi="transition",qr="animation",Br=Symbol("_vtc"),Sd={name:String,type:String,css:{type:Boolean,default:!0},duration:[String,Number,Object],enterFromClass:String,enterActiveClass:String,enterToClass:String,appearFromClass:String,appearActiveClass:String,appearToClass:String,leaveFromClass:String,leaveActiveClass:String,leaveToClass:String},Ed=wt({},zh,Sd),Cg=n=>(n.displayName="Transition",n.props=Ed,n),hy=Cg((n,{slots:e})=>bg(Tm,yd(n),e)),zi=(n,e=[])=>{Oe(n)?n.forEach(t=>t(...e)):n&&n(...e)},Cu=n=>n?Oe(n)?n.some(e=>e.length>1):n.length>1:!1;function yd(n){const e={};for(const I in n)I in Sd||(e[I]=n[I]);if(n.css===!1)return e;const{name:t="v",type:i,duration:r,enterFromClass:s=`${t}-enter-from`,enterActiveClass:o=`${t}-enter-active`,enterToClass:a=`${t}-enter-to`,appearFromClass:l=s,appearActiveClass:c=o,appearToClass:u=a,leaveFromClass:h=`${t}-leave-from`,leaveActiveClass:f=`${t}-leave-active`,leaveToClass:p=`${t}-leave-to`}=n,g=Pg(r),M=g&&g[0],m=g&&g[1],{onBeforeEnter:d,onEnter:x,onEnterCancelled:y,onLeave:S,onLeaveCancelled:C,onBeforeAppear:A=d,onAppear:P=x,onAppearCancelled:v=y}=e,T=(I,k,G,O)=>{I._enterCancelled=O,Ri(I,k?u:a),Ri(I,k?c:o),G&&G()},L=(I,k)=>{I._isLeaving=!1,Ri(I,h),Ri(I,p),Ri(I,f),k&&k()},D=I=>(k,G)=>{const O=I?P:x,V=()=>T(k,I,G);zi(O,[k,V]),Pu(()=>{Ri(k,I?l:s),Un(k,I?u:a),Cu(O)||Du(k,i,M,V)})};return wt(e,{onBeforeEnter(I){zi(d,[I]),Un(I,s),Un(I,o)},onBeforeAppear(I){zi(A,[I]),Un(I,l),Un(I,c)},onEnter:D(!1),onAppear:D(!0),onLeave(I,k){I._isLeaving=!0;const G=()=>L(I,k);Un(I,h),I._enterCancelled?(Un(I,f),Al(I)):(Al(I),Un(I,f)),Pu(()=>{I._isLeaving&&(Ri(I,h),Un(I,p),Cu(S)||Du(I,i,m,G))}),zi(S,[I,G])},onEnterCancelled(I){T(I,!1,void 0,!0),zi(y,[I])},onAppearCancelled(I){T(I,!0,void 0,!0),zi(v,[I])},onLeaveCancelled(I){L(I),zi(C,[I])}})}function Pg(n){if(n==null)return null;if(ct(n))return[Ca(n.enter),Ca(n.leave)];{const e=Ca(n);return[e,e]}}function Ca(n){return Tp(n)}function Un(n,e){e.split(/\s+/).forEach(t=>t&&n.classList.add(t)),(n[Br]||(n[Br]=new Set)).add(e)}function Ri(n,e){e.split(/\s+/).forEach(i=>i&&n.classList.remove(i));const t=n[Br];t&&(t.delete(e),t.size||(n[Br]=void 0))}function Pu(n){requestAnimationFrame(()=>{requestAnimationFrame(n)})}let Dg=0;function Du(n,e,t,i){const r=n._endId=++Dg,s=()=>{r===n._endId&&i()};if(t!=null)return setTimeout(s,t);const{type:o,timeout:a,propCount:l}=bd(n,e);if(!o)return i();const c=o+"end";let u=0;const h=()=>{n.removeEventListener(c,f),s()},f=p=>{p.target===n&&++u>=l&&h()};setTimeout(()=>{u<l&&h()},a+1),n.addEventListener(c,f)}function bd(n,e){const t=window.getComputedStyle(n),i=g=>(t[g]||"").split(", "),r=i(`${xi}Delay`),s=i(`${xi}Duration`),o=Iu(r,s),a=i(`${qr}Delay`),l=i(`${qr}Duration`),c=Iu(a,l);let u=null,h=0,f=0;e===xi?o>0&&(u=xi,h=o,f=s.length):e===qr?c>0&&(u=qr,h=c,f=l.length):(h=Math.max(o,c),u=h>0?o>c?xi:qr:null,f=u?u===xi?s.length:l.length:0);const p=u===xi&&/\b(?:transform|all)(?:,|$)/.test(i(`${xi}Property`).toString());return{type:u,timeout:h,propCount:f,hasTransform:p}}function Iu(n,e){for(;n.length<e.length;)n=n.concat(n);return Math.max(...e.map((t,i)=>Lu(t)+Lu(n[i])))}function Lu(n){return n==="auto"?0:Number(n.slice(0,-1).replace(",","."))*1e3}function Al(n){return(n?n.ownerDocument:document).body.offsetHeight}function Ig(n,e,t){const i=n[Br];i&&(e=(e?[e,...i]:[...i]).join(" ")),e==null?n.removeAttribute("class"):t?n.setAttribute("class",e):n.className=e}const Ho=Symbol("_vod"),Td=Symbol("_vsh"),dy={name:"show",beforeMount(n,{value:e},{transition:t}){n[Ho]=n.style.display==="none"?"":n.style.display,t&&e?t.beforeEnter(n):Kr(n,e)},mounted(n,{value:e},{transition:t}){t&&e&&t.enter(n)},updated(n,{value:e,oldValue:t},{transition:i}){!e!=!t&&(i?e?(i.beforeEnter(n),Kr(n,!0),i.enter(n)):i.leave(n,()=>{Kr(n,!1)}):Kr(n,e))},beforeUnmount(n,{value:e}){Kr(n,e)}};function Kr(n,e){n.style.display=e?n[Ho]:"none",n[Td]=!e}const Lg=Symbol(""),Ug=/(?:^|;)\s*display\s*:/;function Ng(n,e,t){const i=n.style,r=xt(t);let s=!1;if(t&&!r){if(e)if(xt(e))for(const o of e.split(";")){const a=o.slice(0,o.indexOf(":")).trim();t[a]==null&&os(i,a,"")}else for(const o in e)t[o]==null&&os(i,o,"");for(const o in t){o==="display"&&(s=!0);const a=t[o];a!=null?Og(n,o,!xt(e)&&e?e[o]:void 0,a)||os(i,o,a):os(i,o,"")}}else if(r){if(e!==t){const o=i[Lg];o&&(t+=";"+o),i.cssText=t,s=Ug.test(t)}}else e&&n.removeAttribute("style");Ho in n&&(n[Ho]=s?i.display:"",n[Td]&&(i.display="none"))}const Uu=/\s*!important$/;function os(n,e,t){if(Oe(t))t.forEach(i=>os(n,e,i));else if(t==null&&(t=""),e.startsWith("--"))n.setProperty(e,t);else{const i=Fg(n,e);Uu.test(t)?n.setProperty(di(i),t.replace(Uu,""),"important"):n[i]=t}}const Nu=["Webkit","Moz","ms"],Pa={};function Fg(n,e){const t=Pa[e];if(t)return t;let i=Zt(e);if(i!=="filter"&&i in n)return Pa[e]=i;i=na(i);for(let r=0;r<Nu.length;r++){const s=Nu[r]+i;if(s in n)return Pa[e]=s}return e}function Og(n,e,t,i){return n.tagName==="TEXTAREA"&&(e==="width"||e==="height")&&xt(i)&&t===i}const Fu="http://www.w3.org/1999/xlink";function Ou(n,e,t,i,r,s=Dp(e)){i&&e.startsWith("xlink:")?t==null?n.removeAttributeNS(Fu,e.slice(6,e.length)):n.setAttributeNS(Fu,e,t):t==null||s&&!lh(t)?n.removeAttribute(e):n.setAttribute(e,s?"":hn(t)?String(t):t)}function Bu(n,e,t,i,r){if(e==="innerHTML"||e==="textContent"){t!=null&&(n[e]=e==="innerHTML"?Md(t):t);return}const s=n.tagName;if(e==="value"&&s!=="PROGRESS"&&!s.includes("-")){const a=s==="OPTION"?n.getAttribute("value")||"":n.value,l=t==null?n.type==="checkbox"?"on":"":String(t);(a!==l||!("_value"in n))&&(n.value=l),t==null&&n.removeAttribute(e),n._value=t;return}let o=!1;if(t===""||t==null){const a=typeof n[e];a==="boolean"?t=lh(t):t==null&&a==="string"?(t="",o=!0):a==="number"&&(t=0,o=!0)}try{n[e]=t}catch{}o&&n.removeAttribute(r||e)}function Zi(n,e,t,i){n.addEventListener(e,t,i)}function Bg(n,e,t,i){n.removeEventListener(e,t,i)}const zu=Symbol("_vei");function zg(n,e,t,i,r=null){const s=n[zu]||(n[zu]={}),o=s[e];if(i&&o)o.value=i;else{const[a,l]=Hg(e);if(i){const c=s[e]=kg(i,r);Zi(n,a,c,l)}else o&&(Bg(n,a,o,l),s[e]=void 0)}}const Hu=/(?:Once|Passive|Capture)$/;function Hg(n){let e;if(Hu.test(n)){e={};let i;for(;i=n.match(Hu);)n=n.slice(0,n.length-i[0].length),e[i[0].toLowerCase()]=!0}return[n[2]===":"?n.slice(3):di(n.slice(2)),e]}let Da=0;const Vg=Promise.resolve(),Gg=()=>Da||(Vg.then(()=>Da=0),Da=Date.now());function kg(n,e){const t=i=>{if(!i._vts)i._vts=Date.now();else if(i._vts<=t.attached)return;const r=t.value;if(Oe(r)){const s=i.stopImmediatePropagation;i.stopImmediatePropagation=()=>{s.call(i),i._stopped=!0};const o=r.slice(),a=[i];for(let l=0;l<o.length&&!i._stopped;l++){const c=o[l];c&&vn(c,e,5,a)}}else vn(r,e,5,[i])};return t.value=n,t.attached=Gg(),t}const Vu=n=>n.charCodeAt(0)===111&&n.charCodeAt(1)===110&&n.charCodeAt(2)>96&&n.charCodeAt(2)<123,Wg=(n,e,t,i,r,s)=>{const o=r==="svg";e==="class"?Ig(n,i,o):e==="style"?Ng(n,t,i):$o(e)?Jo(e)||zg(n,e,t,i,s):(e[0]==="."?(e=e.slice(1),!0):e[0]==="^"?(e=e.slice(1),!1):Xg(n,e,i,o))?(Bu(n,e,i),!n.tagName.includes("-")&&(e==="value"||e==="checked"||e==="selected")&&Ou(n,e,i,o,s,e!=="value")):n._isVueCE&&(Yg(n,e)||n._def.__asyncLoader&&(/[A-Z]/.test(e)||!xt(i)))?Bu(n,Zt(e),i,s,e):(e==="true-value"?n._trueValue=i:e==="false-value"&&(n._falseValue=i),Ou(n,e,i,o))};function Xg(n,e,t,i){if(i)return!!(e==="innerHTML"||e==="textContent"||e in n&&Vu(e)&&Ge(t));if(e==="spellcheck"||e==="draggable"||e==="translate"||e==="autocorrect"||e==="sandbox"&&n.tagName==="IFRAME"||e==="form"||e==="list"&&n.tagName==="INPUT"||e==="type"&&n.tagName==="TEXTAREA")return!1;if(e==="width"||e==="height"){const r=n.tagName;if(r==="IMG"||r==="VIDEO"||r==="CANVAS"||r==="SOURCE")return!1}return Vu(e)&&xt(t)?!1:e in n}function Yg(n,e){const t=n._def.props;if(!t)return!1;const i=Zt(e);return Array.isArray(t)?t.some(r=>Zt(r)===i):Object.keys(t).some(r=>Zt(r)===i)}const Ad=new WeakMap,wd=new WeakMap,Vo=Symbol("_moveCb"),Gu=Symbol("_enterCb"),qg=n=>(delete n.props.mode,n),Kg=qg({name:"TransitionGroup",props:wt({},Ed,{tag:String,moveClass:String}),setup(n,{slots:e}){const t=lr(),i=Bh();let r,s;return Xh(()=>{if(!r.length)return;const o=n.moveClass||`${n.name||"v"}-move`;if(!Jg(r[0].el,t.vnode.el,o)){r=[];return}r.forEach(jg),r.forEach(Zg);const a=r.filter($g);Al(t.vnode.el),a.forEach(l=>{const c=l.el,u=c.style;Un(c,o),u.transform=u.webkitTransform=u.transitionDuration="";const h=c[Vo]=f=>{f&&f.target!==c||(!f||f.propertyName.endsWith("transform"))&&(c.removeEventListener("transitionend",h),c[Vo]=null,Ri(c,o))};c.addEventListener("transitionend",h)}),r=[]}),()=>{const o=it(n),a=yd(o);let l=o.tag||sn;if(r=[],s)for(let c=0;c<s.length;c++){const u=s[c];u.el&&u.el instanceof Element&&(r.push(u),sr(u,Es(u,a,i,t)),Ad.set(u,Rd(u.el)))}s=e.default?Cc(e.default()):[];for(let c=0;c<s.length;c++){const u=s[c];u.key!=null&&sr(u,Es(u,a,i,t))}return Dt(l,null,s)}}}),py=Kg;function jg(n){const e=n.el;e[Vo]&&e[Vo](),e[Gu]&&e[Gu]()}function Zg(n){wd.set(n,Rd(n.el))}function $g(n){const e=Ad.get(n),t=wd.get(n),i=e.left-t.left,r=e.top-t.top;if(i||r){const s=n.el,o=s.style,a=s.getBoundingClientRect();let l=1,c=1;return s.offsetWidth&&(l=a.width/s.offsetWidth),s.offsetHeight&&(c=a.height/s.offsetHeight),(!Number.isFinite(l)||l===0)&&(l=1),(!Number.isFinite(c)||c===0)&&(c=1),Math.abs(l-1)<.01&&(l=1),Math.abs(c-1)<.01&&(c=1),o.transform=o.webkitTransform=`translate(${i/l}px,${r/c}px)`,o.transitionDuration="0s",n}}function Rd(n){const e=n.getBoundingClientRect();return{left:e.left,top:e.top}}function Jg(n,e,t){const i=n.cloneNode(),r=n[Br];r&&r.forEach(a=>{a.split(/\s+/).forEach(l=>l&&i.classList.remove(l))}),t.split(/\s+/).forEach(a=>a&&i.classList.add(a)),i.style.display="none";const s=e.nodeType===1?e:e.parentNode;s.appendChild(i);const{hasTransform:o}=bd(i);return s.removeChild(i),o}const Go=n=>{const e=n.props["onUpdate:modelValue"]||!1;return Oe(e)?t=>Mo(e,t):e};function Qg(n){n.target.composing=!0}function ku(n){const e=n.target;e.composing&&(e.composing=!1,e.dispatchEvent(new Event("input")))}const Lr=Symbol("_assign");function Wu(n,e,t){return e&&(n=n.trim()),t&&(n=Mc(n)),n}const my={created(n,{modifiers:{lazy:e,trim:t,number:i}},r){n[Lr]=Go(r);const s=i||r.props&&r.props.type==="number";Zi(n,e?"change":"input",o=>{o.target.composing||n[Lr](Wu(n.value,t,s))}),(t||s)&&Zi(n,"change",()=>{n.value=Wu(n.value,t,s)}),e||(Zi(n,"compositionstart",Qg),Zi(n,"compositionend",ku),Zi(n,"change",ku))},mounted(n,{value:e}){n.value=e??""},beforeUpdate(n,{value:e,oldValue:t,modifiers:{lazy:i,trim:r,number:s}},o){if(n[Lr]=Go(o),n.composing)return;const a=(s||n.type==="number")&&!/^0\d/.test(n.value)?Mc(n.value):n.value,l=e??"";if(a===l)return;const c=n.getRootNode();(c instanceof Document||c instanceof ShadowRoot)&&c.activeElement===n&&n.type!=="range"&&(i&&e===t||r&&n.value.trim()===l)||(n.value=l)}},gy={deep:!0,created(n,e,t){n[Lr]=Go(t),Zi(n,"change",()=>{const i=n._modelValue,r=e_(n),s=n.checked,o=n[Lr];if(Oe(i)){const a=ch(i,r),l=a!==-1;if(s&&!l)o(i.concat(r));else if(!s&&l){const c=[...i];c.splice(a,1),o(c)}}else if(Qo(i)){const a=new Set(i);s?a.add(r):a.delete(r),o(a)}else o(Cd(n,s))})},mounted:Xu,beforeUpdate(n,e,t){n[Lr]=Go(t),Xu(n,e,t)}};function Xu(n,{value:e,oldValue:t},i){n._modelValue=e;let r;if(Oe(e))r=ch(e,i.props.value)>-1;else if(Qo(e))r=e.has(i.props.value);else{if(e===t)return;r=Cs(e,Cd(n,!0))}n.checked!==r&&(n.checked=r)}function e_(n){return"_value"in n?n._value:n.value}function Cd(n,e){const t=e?"_trueValue":"_falseValue";return t in n?n[t]:e}const t_=["ctrl","shift","alt","meta"],n_={stop:n=>n.stopPropagation(),prevent:n=>n.preventDefault(),self:n=>n.target!==n.currentTarget,ctrl:n=>!n.ctrlKey,shift:n=>!n.shiftKey,alt:n=>!n.altKey,meta:n=>!n.metaKey,left:n=>"button"in n&&n.button!==0,middle:n=>"button"in n&&n.button!==1,right:n=>"button"in n&&n.button!==2,exact:(n,e)=>t_.some(t=>n[`${t}Key`]&&!e.includes(t))},_y=(n,e)=>{if(!n)return n;const t=n._withMods||(n._withMods={}),i=e.join(".");return t[i]||(t[i]=((r,...s)=>{for(let o=0;o<e.length;o++){const a=n_[e[o]];if(a&&a(r,e))return}return n(r,...s)}))},i_={esc:"escape",space:" ",up:"arrow-up",left:"arrow-left",right:"arrow-right",down:"arrow-down",delete:"backspace"},xy=(n,e)=>{const t=n._withKeys||(n._withKeys={}),i=e.join(".");return t[i]||(t[i]=(r=>{if(!("key"in r))return;const s=di(r.key);if(e.some(o=>o===s||i_[o]===s))return n(r)}))},r_=wt({patchProp:Wg},Rg);let Yu;function s_(){return Yu||(Yu=rg(r_))}const vy=((...n)=>{const e=s_().createApp(...n),{mount:t}=e;return e.mount=i=>{const r=a_(i);if(!r)return;const s=e._component;!Ge(s)&&!s.render&&!s.template&&(s.template=r.innerHTML),r.nodeType===1&&(r.textContent="");const o=t(r,!1,o_(r));return r instanceof Element&&(r.removeAttribute("v-cloak"),r.setAttribute("data-v-app","")),o},e});function o_(n){if(n instanceof SVGElement)return"svg";if(typeof MathMLElement=="function"&&n instanceof MathMLElement)return"mathml"}function a_(n){return xt(n)?document.querySelector(n):n}const Oc="184",l_=0,qu=1,c_=2,bo=1,u_=2,as=3,Li=0,on=1,zn=2,oi=0,Ur=1,Ku=2,ju=3,Zu=4,f_=5,$i=100,h_=101,d_=102,p_=103,m_=104,g_=200,__=201,x_=202,v_=203,wl=204,Rl=205,M_=206,S_=207,E_=208,y_=209,b_=210,T_=211,A_=212,w_=213,R_=214,Cl=0,Pl=1,Dl=2,zr=3,Il=4,Ll=5,Ul=6,Nl=7,Pd=0,C_=1,P_=2,kn=0,Dd=1,Id=2,Ld=3,Ud=4,Nd=5,Fd=6,Od=7,Bd=300,or=301,Hr=302,Ia=303,La=304,da=306,Fl=1e3,si=1001,Ol=1002,zt=1003,D_=1004,Ws=1005,jt=1006,Ua=1007,er=1008,xn=1009,zd=1010,Hd=1011,Ts=1012,Bc=1013,Yn=1014,Hn=1015,fi=1016,zc=1017,Hc=1018,As=1020,Vd=35902,Gd=35899,kd=1021,Wd=1022,Tn=1023,hi=1026,tr=1027,Xd=1028,Vc=1029,ar=1030,Gc=1031,kc=1033,To=33776,Ao=33777,wo=33778,Ro=33779,Bl=35840,zl=35841,Hl=35842,Vl=35843,Gl=36196,kl=37492,Wl=37496,Xl=37488,Yl=37489,ko=37490,ql=37491,Kl=37808,jl=37809,Zl=37810,$l=37811,Jl=37812,Ql=37813,ec=37814,tc=37815,nc=37816,ic=37817,rc=37818,sc=37819,oc=37820,ac=37821,lc=36492,cc=36494,uc=36495,fc=36283,hc=36284,Wo=36285,dc=36286,I_=3200,$u=0,L_=1,Pi="",_n="srgb",Xo="srgb-linear",Yo="linear",ut="srgb",hr=7680,Ju=519,U_=512,N_=513,F_=514,Wc=515,O_=516,B_=517,Xc=518,z_=519,Qu=35044,ef="300 es",Vn=2e3,qo=2001;function H_(n){for(let e=n.length-1;e>=0;--e)if(n[e]>=65535)return!0;return!1}function Ko(n){return document.createElementNS("http://www.w3.org/1999/xhtml",n)}function V_(){const n=Ko("canvas");return n.style.display="block",n}const tf={};function nf(...n){const e="THREE."+n.shift();console.log(e,...n)}function Yd(n){const e=n[0];if(typeof e=="string"&&e.startsWith("TSL:")){const t=n[1];t&&t.isStackTrace?n[0]+=" "+t.getLocation():n[1]='Stack trace not available. Enable "THREE.Node.captureStackTrace" to capture stack traces.'}return n}function ze(...n){n=Yd(n);const e="THREE."+n.shift();{const t=n[0];t&&t.isStackTrace?console.warn(t.getError(e)):console.warn(e,...n)}}function et(...n){n=Yd(n);const e="THREE."+n.shift();{const t=n[0];t&&t.isStackTrace?console.error(t.getError(e)):console.error(e,...n)}}function pc(...n){const e=n.join(" ");e in tf||(tf[e]=!0,ze(...n))}function G_(n,e,t){return new Promise(function(i,r){function s(){switch(n.clientWaitSync(e,n.SYNC_FLUSH_COMMANDS_BIT,0)){case n.WAIT_FAILED:r();break;case n.TIMEOUT_EXPIRED:setTimeout(s,t);break;default:i()}}setTimeout(s,t)})}const k_={[Cl]:Pl,[Dl]:Ul,[Il]:Nl,[zr]:Ll,[Pl]:Cl,[Ul]:Dl,[Nl]:Il,[Ll]:zr};class Ni{addEventListener(e,t){this._listeners===void 0&&(this._listeners={});const i=this._listeners;i[e]===void 0&&(i[e]=[]),i[e].indexOf(t)===-1&&i[e].push(t)}hasEventListener(e,t){const i=this._listeners;return i===void 0?!1:i[e]!==void 0&&i[e].indexOf(t)!==-1}removeEventListener(e,t){const i=this._listeners;if(i===void 0)return;const r=i[e];if(r!==void 0){const s=r.indexOf(t);s!==-1&&r.splice(s,1)}}dispatchEvent(e){const t=this._listeners;if(t===void 0)return;const i=t[e.type];if(i!==void 0){e.target=this;const r=i.slice(0);for(let s=0,o=r.length;s<o;s++)r[s].call(this,e);e.target=null}}}const Vt=["00","01","02","03","04","05","06","07","08","09","0a","0b","0c","0d","0e","0f","10","11","12","13","14","15","16","17","18","19","1a","1b","1c","1d","1e","1f","20","21","22","23","24","25","26","27","28","29","2a","2b","2c","2d","2e","2f","30","31","32","33","34","35","36","37","38","39","3a","3b","3c","3d","3e","3f","40","41","42","43","44","45","46","47","48","49","4a","4b","4c","4d","4e","4f","50","51","52","53","54","55","56","57","58","59","5a","5b","5c","5d","5e","5f","60","61","62","63","64","65","66","67","68","69","6a","6b","6c","6d","6e","6f","70","71","72","73","74","75","76","77","78","79","7a","7b","7c","7d","7e","7f","80","81","82","83","84","85","86","87","88","89","8a","8b","8c","8d","8e","8f","90","91","92","93","94","95","96","97","98","99","9a","9b","9c","9d","9e","9f","a0","a1","a2","a3","a4","a5","a6","a7","a8","a9","aa","ab","ac","ad","ae","af","b0","b1","b2","b3","b4","b5","b6","b7","b8","b9","ba","bb","bc","bd","be","bf","c0","c1","c2","c3","c4","c5","c6","c7","c8","c9","ca","cb","cc","cd","ce","cf","d0","d1","d2","d3","d4","d5","d6","d7","d8","d9","da","db","dc","dd","de","df","e0","e1","e2","e3","e4","e5","e6","e7","e8","e9","ea","eb","ec","ed","ee","ef","f0","f1","f2","f3","f4","f5","f6","f7","f8","f9","fa","fb","fc","fd","fe","ff"];let rf=1234567;const _s=Math.PI/180,ws=180/Math.PI;function kr(){const n=Math.random()*4294967295|0,e=Math.random()*4294967295|0,t=Math.random()*4294967295|0,i=Math.random()*4294967295|0;return(Vt[n&255]+Vt[n>>8&255]+Vt[n>>16&255]+Vt[n>>24&255]+"-"+Vt[e&255]+Vt[e>>8&255]+"-"+Vt[e>>16&15|64]+Vt[e>>24&255]+"-"+Vt[t&63|128]+Vt[t>>8&255]+"-"+Vt[t>>16&255]+Vt[t>>24&255]+Vt[i&255]+Vt[i>>8&255]+Vt[i>>16&255]+Vt[i>>24&255]).toLowerCase()}function Je(n,e,t){return Math.max(e,Math.min(t,n))}function Yc(n,e){return(n%e+e)%e}function W_(n,e,t,i,r){return i+(n-e)*(r-i)/(t-e)}function X_(n,e,t){return n!==e?(t-n)/(e-n):0}function xs(n,e,t){return(1-t)*n+t*e}function Y_(n,e,t,i){return xs(n,e,1-Math.exp(-t*i))}function q_(n,e=1){return e-Math.abs(Yc(n,e*2)-e)}function K_(n,e,t){return n<=e?0:n>=t?1:(n=(n-e)/(t-e),n*n*(3-2*n))}function j_(n,e,t){return n<=e?0:n>=t?1:(n=(n-e)/(t-e),n*n*n*(n*(n*6-15)+10))}function Z_(n,e){return n+Math.floor(Math.random()*(e-n+1))}function $_(n,e){return n+Math.random()*(e-n)}function J_(n){return n*(.5-Math.random())}function Q_(n){n!==void 0&&(rf=n);let e=rf+=1831565813;return e=Math.imul(e^e>>>15,e|1),e^=e+Math.imul(e^e>>>7,e|61),((e^e>>>14)>>>0)/4294967296}function e0(n){return n*_s}function t0(n){return n*ws}function n0(n){return(n&n-1)===0&&n!==0}function i0(n){return Math.pow(2,Math.ceil(Math.log(n)/Math.LN2))}function r0(n){return Math.pow(2,Math.floor(Math.log(n)/Math.LN2))}function s0(n,e,t,i,r){const s=Math.cos,o=Math.sin,a=s(t/2),l=o(t/2),c=s((e+i)/2),u=o((e+i)/2),h=s((e-i)/2),f=o((e-i)/2),p=s((i-e)/2),g=o((i-e)/2);switch(r){case"XYX":n.set(a*u,l*h,l*f,a*c);break;case"YZY":n.set(l*f,a*u,l*h,a*c);break;case"ZXZ":n.set(l*h,l*f,a*u,a*c);break;case"XZX":n.set(a*u,l*g,l*p,a*c);break;case"YXY":n.set(l*p,a*u,l*g,a*c);break;case"ZYZ":n.set(l*g,l*p,a*u,a*c);break;default:ze("MathUtils: .setQuaternionFromProperEuler() encountered an unknown order: "+r)}}function wr(n,e){switch(e.constructor){case Float32Array:return n;case Uint32Array:return n/4294967295;case Uint16Array:return n/65535;case Uint8Array:return n/255;case Int32Array:return Math.max(n/2147483647,-1);case Int16Array:return Math.max(n/32767,-1);case Int8Array:return Math.max(n/127,-1);default:throw new Error("Invalid component type.")}}function Qt(n,e){switch(e.constructor){case Float32Array:return n;case Uint32Array:return Math.round(n*4294967295);case Uint16Array:return Math.round(n*65535);case Uint8Array:return Math.round(n*255);case Int32Array:return Math.round(n*2147483647);case Int16Array:return Math.round(n*32767);case Int8Array:return Math.round(n*127);default:throw new Error("Invalid component type.")}}const My={DEG2RAD:_s,RAD2DEG:ws,generateUUID:kr,clamp:Je,euclideanModulo:Yc,mapLinear:W_,inverseLerp:X_,lerp:xs,damp:Y_,pingpong:q_,smoothstep:K_,smootherstep:j_,randInt:Z_,randFloat:$_,randFloatSpread:J_,seededRandom:Q_,degToRad:e0,radToDeg:t0,isPowerOfTwo:n0,ceilPowerOfTwo:i0,floorPowerOfTwo:r0,setQuaternionFromProperEuler:s0,normalize:Qt,denormalize:wr};class st{static{st.prototype.isVector2=!0}constructor(e=0,t=0){this.x=e,this.y=t}get width(){return this.x}set width(e){this.x=e}get height(){return this.y}set height(e){this.y=e}set(e,t){return this.x=e,this.y=t,this}setScalar(e){return this.x=e,this.y=e,this}setX(e){return this.x=e,this}setY(e){return this.y=e,this}setComponent(e,t){switch(e){case 0:this.x=t;break;case 1:this.y=t;break;default:throw new Error("index is out of range: "+e)}return this}getComponent(e){switch(e){case 0:return this.x;case 1:return this.y;default:throw new Error("index is out of range: "+e)}}clone(){return new this.constructor(this.x,this.y)}copy(e){return this.x=e.x,this.y=e.y,this}add(e){return this.x+=e.x,this.y+=e.y,this}addScalar(e){return this.x+=e,this.y+=e,this}addVectors(e,t){return this.x=e.x+t.x,this.y=e.y+t.y,this}addScaledVector(e,t){return this.x+=e.x*t,this.y+=e.y*t,this}sub(e){return this.x-=e.x,this.y-=e.y,this}subScalar(e){return this.x-=e,this.y-=e,this}subVectors(e,t){return this.x=e.x-t.x,this.y=e.y-t.y,this}multiply(e){return this.x*=e.x,this.y*=e.y,this}multiplyScalar(e){return this.x*=e,this.y*=e,this}divide(e){return this.x/=e.x,this.y/=e.y,this}divideScalar(e){return this.multiplyScalar(1/e)}applyMatrix3(e){const t=this.x,i=this.y,r=e.elements;return this.x=r[0]*t+r[3]*i+r[6],this.y=r[1]*t+r[4]*i+r[7],this}min(e){return this.x=Math.min(this.x,e.x),this.y=Math.min(this.y,e.y),this}max(e){return this.x=Math.max(this.x,e.x),this.y=Math.max(this.y,e.y),this}clamp(e,t){return this.x=Je(this.x,e.x,t.x),this.y=Je(this.y,e.y,t.y),this}clampScalar(e,t){return this.x=Je(this.x,e,t),this.y=Je(this.y,e,t),this}clampLength(e,t){const i=this.length();return this.divideScalar(i||1).multiplyScalar(Je(i,e,t))}floor(){return this.x=Math.floor(this.x),this.y=Math.floor(this.y),this}ceil(){return this.x=Math.ceil(this.x),this.y=Math.ceil(this.y),this}round(){return this.x=Math.round(this.x),this.y=Math.round(this.y),this}roundToZero(){return this.x=Math.trunc(this.x),this.y=Math.trunc(this.y),this}negate(){return this.x=-this.x,this.y=-this.y,this}dot(e){return this.x*e.x+this.y*e.y}cross(e){return this.x*e.y-this.y*e.x}lengthSq(){return this.x*this.x+this.y*this.y}length(){return Math.sqrt(this.x*this.x+this.y*this.y)}manhattanLength(){return Math.abs(this.x)+Math.abs(this.y)}normalize(){return this.divideScalar(this.length()||1)}angle(){return Math.atan2(-this.y,-this.x)+Math.PI}angleTo(e){const t=Math.sqrt(this.lengthSq()*e.lengthSq());if(t===0)return Math.PI/2;const i=this.dot(e)/t;return Math.acos(Je(i,-1,1))}distanceTo(e){return Math.sqrt(this.distanceToSquared(e))}distanceToSquared(e){const t=this.x-e.x,i=this.y-e.y;return t*t+i*i}manhattanDistanceTo(e){return Math.abs(this.x-e.x)+Math.abs(this.y-e.y)}setLength(e){return this.normalize().multiplyScalar(e)}lerp(e,t){return this.x+=(e.x-this.x)*t,this.y+=(e.y-this.y)*t,this}lerpVectors(e,t,i){return this.x=e.x+(t.x-e.x)*i,this.y=e.y+(t.y-e.y)*i,this}equals(e){return e.x===this.x&&e.y===this.y}fromArray(e,t=0){return this.x=e[t],this.y=e[t+1],this}toArray(e=[],t=0){return e[t]=this.x,e[t+1]=this.y,e}fromBufferAttribute(e,t){return this.x=e.getX(t),this.y=e.getY(t),this}rotateAround(e,t){const i=Math.cos(t),r=Math.sin(t),s=this.x-e.x,o=this.y-e.y;return this.x=s*i-o*r+e.x,this.y=s*r+o*i+e.y,this}random(){return this.x=Math.random(),this.y=Math.random(),this}*[Symbol.iterator](){yield this.x,yield this.y}}class Xt{constructor(e=0,t=0,i=0,r=1){this.isQuaternion=!0,this._x=e,this._y=t,this._z=i,this._w=r}static slerpFlat(e,t,i,r,s,o,a){let l=i[r+0],c=i[r+1],u=i[r+2],h=i[r+3],f=s[o+0],p=s[o+1],g=s[o+2],M=s[o+3];if(h!==M||l!==f||c!==p||u!==g){let m=l*f+c*p+u*g+h*M;m<0&&(f=-f,p=-p,g=-g,M=-M,m=-m);let d=1-a;if(m<.9995){const x=Math.acos(m),y=Math.sin(x);d=Math.sin(d*x)/y,a=Math.sin(a*x)/y,l=l*d+f*a,c=c*d+p*a,u=u*d+g*a,h=h*d+M*a}else{l=l*d+f*a,c=c*d+p*a,u=u*d+g*a,h=h*d+M*a;const x=1/Math.sqrt(l*l+c*c+u*u+h*h);l*=x,c*=x,u*=x,h*=x}}e[t]=l,e[t+1]=c,e[t+2]=u,e[t+3]=h}static multiplyQuaternionsFlat(e,t,i,r,s,o){const a=i[r],l=i[r+1],c=i[r+2],u=i[r+3],h=s[o],f=s[o+1],p=s[o+2],g=s[o+3];return e[t]=a*g+u*h+l*p-c*f,e[t+1]=l*g+u*f+c*h-a*p,e[t+2]=c*g+u*p+a*f-l*h,e[t+3]=u*g-a*h-l*f-c*p,e}get x(){return this._x}set x(e){this._x=e,this._onChangeCallback()}get y(){return this._y}set y(e){this._y=e,this._onChangeCallback()}get z(){return this._z}set z(e){this._z=e,this._onChangeCallback()}get w(){return this._w}set w(e){this._w=e,this._onChangeCallback()}set(e,t,i,r){return this._x=e,this._y=t,this._z=i,this._w=r,this._onChangeCallback(),this}clone(){return new this.constructor(this._x,this._y,this._z,this._w)}copy(e){return this._x=e.x,this._y=e.y,this._z=e.z,this._w=e.w,this._onChangeCallback(),this}setFromEuler(e,t=!0){const i=e._x,r=e._y,s=e._z,o=e._order,a=Math.cos,l=Math.sin,c=a(i/2),u=a(r/2),h=a(s/2),f=l(i/2),p=l(r/2),g=l(s/2);switch(o){case"XYZ":this._x=f*u*h+c*p*g,this._y=c*p*h-f*u*g,this._z=c*u*g+f*p*h,this._w=c*u*h-f*p*g;break;case"YXZ":this._x=f*u*h+c*p*g,this._y=c*p*h-f*u*g,this._z=c*u*g-f*p*h,this._w=c*u*h+f*p*g;break;case"ZXY":this._x=f*u*h-c*p*g,this._y=c*p*h+f*u*g,this._z=c*u*g+f*p*h,this._w=c*u*h-f*p*g;break;case"ZYX":this._x=f*u*h-c*p*g,this._y=c*p*h+f*u*g,this._z=c*u*g-f*p*h,this._w=c*u*h+f*p*g;break;case"YZX":this._x=f*u*h+c*p*g,this._y=c*p*h+f*u*g,this._z=c*u*g-f*p*h,this._w=c*u*h-f*p*g;break;case"XZY":this._x=f*u*h-c*p*g,this._y=c*p*h-f*u*g,this._z=c*u*g+f*p*h,this._w=c*u*h+f*p*g;break;default:ze("Quaternion: .setFromEuler() encountered an unknown order: "+o)}return t===!0&&this._onChangeCallback(),this}setFromAxisAngle(e,t){const i=t/2,r=Math.sin(i);return this._x=e.x*r,this._y=e.y*r,this._z=e.z*r,this._w=Math.cos(i),this._onChangeCallback(),this}setFromRotationMatrix(e){const t=e.elements,i=t[0],r=t[4],s=t[8],o=t[1],a=t[5],l=t[9],c=t[2],u=t[6],h=t[10],f=i+a+h;if(f>0){const p=.5/Math.sqrt(f+1);this._w=.25/p,this._x=(u-l)*p,this._y=(s-c)*p,this._z=(o-r)*p}else if(i>a&&i>h){const p=2*Math.sqrt(1+i-a-h);this._w=(u-l)/p,this._x=.25*p,this._y=(r+o)/p,this._z=(s+c)/p}else if(a>h){const p=2*Math.sqrt(1+a-i-h);this._w=(s-c)/p,this._x=(r+o)/p,this._y=.25*p,this._z=(l+u)/p}else{const p=2*Math.sqrt(1+h-i-a);this._w=(o-r)/p,this._x=(s+c)/p,this._y=(l+u)/p,this._z=.25*p}return this._onChangeCallback(),this}setFromUnitVectors(e,t){let i=e.dot(t)+1;return i<1e-8?(i=0,Math.abs(e.x)>Math.abs(e.z)?(this._x=-e.y,this._y=e.x,this._z=0,this._w=i):(this._x=0,this._y=-e.z,this._z=e.y,this._w=i)):(this._x=e.y*t.z-e.z*t.y,this._y=e.z*t.x-e.x*t.z,this._z=e.x*t.y-e.y*t.x,this._w=i),this.normalize()}angleTo(e){return 2*Math.acos(Math.abs(Je(this.dot(e),-1,1)))}rotateTowards(e,t){const i=this.angleTo(e);if(i===0)return this;const r=Math.min(1,t/i);return this.slerp(e,r),this}identity(){return this.set(0,0,0,1)}invert(){return this.conjugate()}conjugate(){return this._x*=-1,this._y*=-1,this._z*=-1,this._onChangeCallback(),this}dot(e){return this._x*e._x+this._y*e._y+this._z*e._z+this._w*e._w}lengthSq(){return this._x*this._x+this._y*this._y+this._z*this._z+this._w*this._w}length(){return Math.sqrt(this._x*this._x+this._y*this._y+this._z*this._z+this._w*this._w)}normalize(){let e=this.length();return e===0?(this._x=0,this._y=0,this._z=0,this._w=1):(e=1/e,this._x=this._x*e,this._y=this._y*e,this._z=this._z*e,this._w=this._w*e),this._onChangeCallback(),this}multiply(e){return this.multiplyQuaternions(this,e)}premultiply(e){return this.multiplyQuaternions(e,this)}multiplyQuaternions(e,t){const i=e._x,r=e._y,s=e._z,o=e._w,a=t._x,l=t._y,c=t._z,u=t._w;return this._x=i*u+o*a+r*c-s*l,this._y=r*u+o*l+s*a-i*c,this._z=s*u+o*c+i*l-r*a,this._w=o*u-i*a-r*l-s*c,this._onChangeCallback(),this}slerp(e,t){let i=e._x,r=e._y,s=e._z,o=e._w,a=this.dot(e);a<0&&(i=-i,r=-r,s=-s,o=-o,a=-a);let l=1-t;if(a<.9995){const c=Math.acos(a),u=Math.sin(c);l=Math.sin(l*c)/u,t=Math.sin(t*c)/u,this._x=this._x*l+i*t,this._y=this._y*l+r*t,this._z=this._z*l+s*t,this._w=this._w*l+o*t,this._onChangeCallback()}else this._x=this._x*l+i*t,this._y=this._y*l+r*t,this._z=this._z*l+s*t,this._w=this._w*l+o*t,this.normalize();return this}slerpQuaternions(e,t,i){return this.copy(e).slerp(t,i)}random(){const e=2*Math.PI*Math.random(),t=2*Math.PI*Math.random(),i=Math.random(),r=Math.sqrt(1-i),s=Math.sqrt(i);return this.set(r*Math.sin(e),r*Math.cos(e),s*Math.sin(t),s*Math.cos(t))}equals(e){return e._x===this._x&&e._y===this._y&&e._z===this._z&&e._w===this._w}fromArray(e,t=0){return this._x=e[t],this._y=e[t+1],this._z=e[t+2],this._w=e[t+3],this._onChangeCallback(),this}toArray(e=[],t=0){return e[t]=this._x,e[t+1]=this._y,e[t+2]=this._z,e[t+3]=this._w,e}fromBufferAttribute(e,t){return this._x=e.getX(t),this._y=e.getY(t),this._z=e.getZ(t),this._w=e.getW(t),this._onChangeCallback(),this}toJSON(){return this.toArray()}_onChange(e){return this._onChangeCallback=e,this}_onChangeCallback(){}*[Symbol.iterator](){yield this._x,yield this._y,yield this._z,yield this._w}}class N{static{N.prototype.isVector3=!0}constructor(e=0,t=0,i=0){this.x=e,this.y=t,this.z=i}set(e,t,i){return i===void 0&&(i=this.z),this.x=e,this.y=t,this.z=i,this}setScalar(e){return this.x=e,this.y=e,this.z=e,this}setX(e){return this.x=e,this}setY(e){return this.y=e,this}setZ(e){return this.z=e,this}setComponent(e,t){switch(e){case 0:this.x=t;break;case 1:this.y=t;break;case 2:this.z=t;break;default:throw new Error("index is out of range: "+e)}return this}getComponent(e){switch(e){case 0:return this.x;case 1:return this.y;case 2:return this.z;default:throw new Error("index is out of range: "+e)}}clone(){return new this.constructor(this.x,this.y,this.z)}copy(e){return this.x=e.x,this.y=e.y,this.z=e.z,this}add(e){return this.x+=e.x,this.y+=e.y,this.z+=e.z,this}addScalar(e){return this.x+=e,this.y+=e,this.z+=e,this}addVectors(e,t){return this.x=e.x+t.x,this.y=e.y+t.y,this.z=e.z+t.z,this}addScaledVector(e,t){return this.x+=e.x*t,this.y+=e.y*t,this.z+=e.z*t,this}sub(e){return this.x-=e.x,this.y-=e.y,this.z-=e.z,this}subScalar(e){return this.x-=e,this.y-=e,this.z-=e,this}subVectors(e,t){return this.x=e.x-t.x,this.y=e.y-t.y,this.z=e.z-t.z,this}multiply(e){return this.x*=e.x,this.y*=e.y,this.z*=e.z,this}multiplyScalar(e){return this.x*=e,this.y*=e,this.z*=e,this}multiplyVectors(e,t){return this.x=e.x*t.x,this.y=e.y*t.y,this.z=e.z*t.z,this}applyEuler(e){return this.applyQuaternion(sf.setFromEuler(e))}applyAxisAngle(e,t){return this.applyQuaternion(sf.setFromAxisAngle(e,t))}applyMatrix3(e){const t=this.x,i=this.y,r=this.z,s=e.elements;return this.x=s[0]*t+s[3]*i+s[6]*r,this.y=s[1]*t+s[4]*i+s[7]*r,this.z=s[2]*t+s[5]*i+s[8]*r,this}applyNormalMatrix(e){return this.applyMatrix3(e).normalize()}applyMatrix4(e){const t=this.x,i=this.y,r=this.z,s=e.elements,o=1/(s[3]*t+s[7]*i+s[11]*r+s[15]);return this.x=(s[0]*t+s[4]*i+s[8]*r+s[12])*o,this.y=(s[1]*t+s[5]*i+s[9]*r+s[13])*o,this.z=(s[2]*t+s[6]*i+s[10]*r+s[14])*o,this}applyQuaternion(e){const t=this.x,i=this.y,r=this.z,s=e.x,o=e.y,a=e.z,l=e.w,c=2*(o*r-a*i),u=2*(a*t-s*r),h=2*(s*i-o*t);return this.x=t+l*c+o*h-a*u,this.y=i+l*u+a*c-s*h,this.z=r+l*h+s*u-o*c,this}project(e){return this.applyMatrix4(e.matrixWorldInverse).applyMatrix4(e.projectionMatrix)}unproject(e){return this.applyMatrix4(e.projectionMatrixInverse).applyMatrix4(e.matrixWorld)}transformDirection(e){const t=this.x,i=this.y,r=this.z,s=e.elements;return this.x=s[0]*t+s[4]*i+s[8]*r,this.y=s[1]*t+s[5]*i+s[9]*r,this.z=s[2]*t+s[6]*i+s[10]*r,this.normalize()}divide(e){return this.x/=e.x,this.y/=e.y,this.z/=e.z,this}divideScalar(e){return this.multiplyScalar(1/e)}min(e){return this.x=Math.min(this.x,e.x),this.y=Math.min(this.y,e.y),this.z=Math.min(this.z,e.z),this}max(e){return this.x=Math.max(this.x,e.x),this.y=Math.max(this.y,e.y),this.z=Math.max(this.z,e.z),this}clamp(e,t){return this.x=Je(this.x,e.x,t.x),this.y=Je(this.y,e.y,t.y),this.z=Je(this.z,e.z,t.z),this}clampScalar(e,t){return this.x=Je(this.x,e,t),this.y=Je(this.y,e,t),this.z=Je(this.z,e,t),this}clampLength(e,t){const i=this.length();return this.divideScalar(i||1).multiplyScalar(Je(i,e,t))}floor(){return this.x=Math.floor(this.x),this.y=Math.floor(this.y),this.z=Math.floor(this.z),this}ceil(){return this.x=Math.ceil(this.x),this.y=Math.ceil(this.y),this.z=Math.ceil(this.z),this}round(){return this.x=Math.round(this.x),this.y=Math.round(this.y),this.z=Math.round(this.z),this}roundToZero(){return this.x=Math.trunc(this.x),this.y=Math.trunc(this.y),this.z=Math.trunc(this.z),this}negate(){return this.x=-this.x,this.y=-this.y,this.z=-this.z,this}dot(e){return this.x*e.x+this.y*e.y+this.z*e.z}lengthSq(){return this.x*this.x+this.y*this.y+this.z*this.z}length(){return Math.sqrt(this.x*this.x+this.y*this.y+this.z*this.z)}manhattanLength(){return Math.abs(this.x)+Math.abs(this.y)+Math.abs(this.z)}normalize(){return this.divideScalar(this.length()||1)}setLength(e){return this.normalize().multiplyScalar(e)}lerp(e,t){return this.x+=(e.x-this.x)*t,this.y+=(e.y-this.y)*t,this.z+=(e.z-this.z)*t,this}lerpVectors(e,t,i){return this.x=e.x+(t.x-e.x)*i,this.y=e.y+(t.y-e.y)*i,this.z=e.z+(t.z-e.z)*i,this}cross(e){return this.crossVectors(this,e)}crossVectors(e,t){const i=e.x,r=e.y,s=e.z,o=t.x,a=t.y,l=t.z;return this.x=r*l-s*a,this.y=s*o-i*l,this.z=i*a-r*o,this}projectOnVector(e){const t=e.lengthSq();if(t===0)return this.set(0,0,0);const i=e.dot(this)/t;return this.copy(e).multiplyScalar(i)}projectOnPlane(e){return Na.copy(this).projectOnVector(e),this.sub(Na)}reflect(e){return this.sub(Na.copy(e).multiplyScalar(2*this.dot(e)))}angleTo(e){const t=Math.sqrt(this.lengthSq()*e.lengthSq());if(t===0)return Math.PI/2;const i=this.dot(e)/t;return Math.acos(Je(i,-1,1))}distanceTo(e){return Math.sqrt(this.distanceToSquared(e))}distanceToSquared(e){const t=this.x-e.x,i=this.y-e.y,r=this.z-e.z;return t*t+i*i+r*r}manhattanDistanceTo(e){return Math.abs(this.x-e.x)+Math.abs(this.y-e.y)+Math.abs(this.z-e.z)}setFromSpherical(e){return this.setFromSphericalCoords(e.radius,e.phi,e.theta)}setFromSphericalCoords(e,t,i){const r=Math.sin(t)*e;return this.x=r*Math.sin(i),this.y=Math.cos(t)*e,this.z=r*Math.cos(i),this}setFromCylindrical(e){return this.setFromCylindricalCoords(e.radius,e.theta,e.y)}setFromCylindricalCoords(e,t,i){return this.x=e*Math.sin(t),this.y=i,this.z=e*Math.cos(t),this}setFromMatrixPosition(e){const t=e.elements;return this.x=t[12],this.y=t[13],this.z=t[14],this}setFromMatrixScale(e){const t=this.setFromMatrixColumn(e,0).length(),i=this.setFromMatrixColumn(e,1).length(),r=this.setFromMatrixColumn(e,2).length();return this.x=t,this.y=i,this.z=r,this}setFromMatrixColumn(e,t){return this.fromArray(e.elements,t*4)}setFromMatrix3Column(e,t){return this.fromArray(e.elements,t*3)}setFromEuler(e){return this.x=e._x,this.y=e._y,this.z=e._z,this}setFromColor(e){return this.x=e.r,this.y=e.g,this.z=e.b,this}equals(e){return e.x===this.x&&e.y===this.y&&e.z===this.z}fromArray(e,t=0){return this.x=e[t],this.y=e[t+1],this.z=e[t+2],this}toArray(e=[],t=0){return e[t]=this.x,e[t+1]=this.y,e[t+2]=this.z,e}fromBufferAttribute(e,t){return this.x=e.getX(t),this.y=e.getY(t),this.z=e.getZ(t),this}random(){return this.x=Math.random(),this.y=Math.random(),this.z=Math.random(),this}randomDirection(){const e=Math.random()*Math.PI*2,t=Math.random()*2-1,i=Math.sqrt(1-t*t);return this.x=i*Math.cos(e),this.y=t,this.z=i*Math.sin(e),this}*[Symbol.iterator](){yield this.x,yield this.y,yield this.z}}const Na=new N,sf=new Xt;class Xe{static{Xe.prototype.isMatrix3=!0}constructor(e,t,i,r,s,o,a,l,c){this.elements=[1,0,0,0,1,0,0,0,1],e!==void 0&&this.set(e,t,i,r,s,o,a,l,c)}set(e,t,i,r,s,o,a,l,c){const u=this.elements;return u[0]=e,u[1]=r,u[2]=a,u[3]=t,u[4]=s,u[5]=l,u[6]=i,u[7]=o,u[8]=c,this}identity(){return this.set(1,0,0,0,1,0,0,0,1),this}copy(e){const t=this.elements,i=e.elements;return t[0]=i[0],t[1]=i[1],t[2]=i[2],t[3]=i[3],t[4]=i[4],t[5]=i[5],t[6]=i[6],t[7]=i[7],t[8]=i[8],this}extractBasis(e,t,i){return e.setFromMatrix3Column(this,0),t.setFromMatrix3Column(this,1),i.setFromMatrix3Column(this,2),this}setFromMatrix4(e){const t=e.elements;return this.set(t[0],t[4],t[8],t[1],t[5],t[9],t[2],t[6],t[10]),this}multiply(e){return this.multiplyMatrices(this,e)}premultiply(e){return this.multiplyMatrices(e,this)}multiplyMatrices(e,t){const i=e.elements,r=t.elements,s=this.elements,o=i[0],a=i[3],l=i[6],c=i[1],u=i[4],h=i[7],f=i[2],p=i[5],g=i[8],M=r[0],m=r[3],d=r[6],x=r[1],y=r[4],S=r[7],C=r[2],A=r[5],P=r[8];return s[0]=o*M+a*x+l*C,s[3]=o*m+a*y+l*A,s[6]=o*d+a*S+l*P,s[1]=c*M+u*x+h*C,s[4]=c*m+u*y+h*A,s[7]=c*d+u*S+h*P,s[2]=f*M+p*x+g*C,s[5]=f*m+p*y+g*A,s[8]=f*d+p*S+g*P,this}multiplyScalar(e){const t=this.elements;return t[0]*=e,t[3]*=e,t[6]*=e,t[1]*=e,t[4]*=e,t[7]*=e,t[2]*=e,t[5]*=e,t[8]*=e,this}determinant(){const e=this.elements,t=e[0],i=e[1],r=e[2],s=e[3],o=e[4],a=e[5],l=e[6],c=e[7],u=e[8];return t*o*u-t*a*c-i*s*u+i*a*l+r*s*c-r*o*l}invert(){const e=this.elements,t=e[0],i=e[1],r=e[2],s=e[3],o=e[4],a=e[5],l=e[6],c=e[7],u=e[8],h=u*o-a*c,f=a*l-u*s,p=c*s-o*l,g=t*h+i*f+r*p;if(g===0)return this.set(0,0,0,0,0,0,0,0,0);const M=1/g;return e[0]=h*M,e[1]=(r*c-u*i)*M,e[2]=(a*i-r*o)*M,e[3]=f*M,e[4]=(u*t-r*l)*M,e[5]=(r*s-a*t)*M,e[6]=p*M,e[7]=(i*l-c*t)*M,e[8]=(o*t-i*s)*M,this}transpose(){let e;const t=this.elements;return e=t[1],t[1]=t[3],t[3]=e,e=t[2],t[2]=t[6],t[6]=e,e=t[5],t[5]=t[7],t[7]=e,this}getNormalMatrix(e){return this.setFromMatrix4(e).invert().transpose()}transposeIntoArray(e){const t=this.elements;return e[0]=t[0],e[1]=t[3],e[2]=t[6],e[3]=t[1],e[4]=t[4],e[5]=t[7],e[6]=t[2],e[7]=t[5],e[8]=t[8],this}setUvTransform(e,t,i,r,s,o,a){const l=Math.cos(s),c=Math.sin(s);return this.set(i*l,i*c,-i*(l*o+c*a)+o+e,-r*c,r*l,-r*(-c*o+l*a)+a+t,0,0,1),this}scale(e,t){return this.premultiply(Fa.makeScale(e,t)),this}rotate(e){return this.premultiply(Fa.makeRotation(-e)),this}translate(e,t){return this.premultiply(Fa.makeTranslation(e,t)),this}makeTranslation(e,t){return e.isVector2?this.set(1,0,e.x,0,1,e.y,0,0,1):this.set(1,0,e,0,1,t,0,0,1),this}makeRotation(e){const t=Math.cos(e),i=Math.sin(e);return this.set(t,-i,0,i,t,0,0,0,1),this}makeScale(e,t){return this.set(e,0,0,0,t,0,0,0,1),this}equals(e){const t=this.elements,i=e.elements;for(let r=0;r<9;r++)if(t[r]!==i[r])return!1;return!0}fromArray(e,t=0){for(let i=0;i<9;i++)this.elements[i]=e[i+t];return this}toArray(e=[],t=0){const i=this.elements;return e[t]=i[0],e[t+1]=i[1],e[t+2]=i[2],e[t+3]=i[3],e[t+4]=i[4],e[t+5]=i[5],e[t+6]=i[6],e[t+7]=i[7],e[t+8]=i[8],e}clone(){return new this.constructor().fromArray(this.elements)}}const Fa=new Xe,of=new Xe().set(.4123908,.3575843,.1804808,.212639,.7151687,.0721923,.0193308,.1191948,.9505322),af=new Xe().set(3.2409699,-1.5373832,-.4986108,-.9692436,1.8759675,.0415551,.0556301,-.203977,1.0569715);function o0(){const n={enabled:!0,workingColorSpace:Xo,spaces:{},convert:function(r,s,o){return this.enabled===!1||s===o||!s||!o||(this.spaces[s].transfer===ut&&(r.r=ai(r.r),r.g=ai(r.g),r.b=ai(r.b)),this.spaces[s].primaries!==this.spaces[o].primaries&&(r.applyMatrix3(this.spaces[s].toXYZ),r.applyMatrix3(this.spaces[o].fromXYZ)),this.spaces[o].transfer===ut&&(r.r=Nr(r.r),r.g=Nr(r.g),r.b=Nr(r.b))),r},workingToColorSpace:function(r,s){return this.convert(r,this.workingColorSpace,s)},colorSpaceToWorking:function(r,s){return this.convert(r,s,this.workingColorSpace)},getPrimaries:function(r){return this.spaces[r].primaries},getTransfer:function(r){return r===Pi?Yo:this.spaces[r].transfer},getToneMappingMode:function(r){return this.spaces[r].outputColorSpaceConfig.toneMappingMode||"standard"},getLuminanceCoefficients:function(r,s=this.workingColorSpace){return r.fromArray(this.spaces[s].luminanceCoefficients)},define:function(r){Object.assign(this.spaces,r)},_getMatrix:function(r,s,o){return r.copy(this.spaces[s].toXYZ).multiply(this.spaces[o].fromXYZ)},_getDrawingBufferColorSpace:function(r){return this.spaces[r].outputColorSpaceConfig.drawingBufferColorSpace},_getUnpackColorSpace:function(r=this.workingColorSpace){return this.spaces[r].workingColorSpaceConfig.unpackColorSpace},fromWorkingColorSpace:function(r,s){return pc("ColorManagement: .fromWorkingColorSpace() has been renamed to .workingToColorSpace()."),n.workingToColorSpace(r,s)},toWorkingColorSpace:function(r,s){return pc("ColorManagement: .toWorkingColorSpace() has been renamed to .colorSpaceToWorking()."),n.colorSpaceToWorking(r,s)}},e=[.64,.33,.3,.6,.15,.06],t=[.2126,.7152,.0722],i=[.3127,.329];return n.define({[Xo]:{primaries:e,whitePoint:i,transfer:Yo,toXYZ:of,fromXYZ:af,luminanceCoefficients:t,workingColorSpaceConfig:{unpackColorSpace:_n},outputColorSpaceConfig:{drawingBufferColorSpace:_n}},[_n]:{primaries:e,whitePoint:i,transfer:ut,toXYZ:of,fromXYZ:af,luminanceCoefficients:t,outputColorSpaceConfig:{drawingBufferColorSpace:_n}}}),n}const Qe=o0();function ai(n){return n<.04045?n*.0773993808:Math.pow(n*.9478672986+.0521327014,2.4)}function Nr(n){return n<.0031308?n*12.92:1.055*Math.pow(n,.41666)-.055}let dr;class a0{static getDataURL(e,t="image/png"){if(/^data:/i.test(e.src)||typeof HTMLCanvasElement>"u")return e.src;let i;if(e instanceof HTMLCanvasElement)i=e;else{dr===void 0&&(dr=Ko("canvas")),dr.width=e.width,dr.height=e.height;const r=dr.getContext("2d");e instanceof ImageData?r.putImageData(e,0,0):r.drawImage(e,0,0,e.width,e.height),i=dr}return i.toDataURL(t)}static sRGBToLinear(e){if(typeof HTMLImageElement<"u"&&e instanceof HTMLImageElement||typeof HTMLCanvasElement<"u"&&e instanceof HTMLCanvasElement||typeof ImageBitmap<"u"&&e instanceof ImageBitmap){const t=Ko("canvas");t.width=e.width,t.height=e.height;const i=t.getContext("2d");i.drawImage(e,0,0,e.width,e.height);const r=i.getImageData(0,0,e.width,e.height),s=r.data;for(let o=0;o<s.length;o++)s[o]=ai(s[o]/255)*255;return i.putImageData(r,0,0),t}else if(e.data){const t=e.data.slice(0);for(let i=0;i<t.length;i++)t instanceof Uint8Array||t instanceof Uint8ClampedArray?t[i]=Math.floor(ai(t[i]/255)*255):t[i]=ai(t[i]);return{data:t,width:e.width,height:e.height}}else return ze("ImageUtils.sRGBToLinear(): Unsupported image type. No color space conversion applied."),e}}let l0=0;class qc{constructor(e=null){this.isSource=!0,Object.defineProperty(this,"id",{value:l0++}),this.uuid=kr(),this.data=e,this.dataReady=!0,this.version=0}getSize(e){const t=this.data;return typeof HTMLVideoElement<"u"&&t instanceof HTMLVideoElement?e.set(t.videoWidth,t.videoHeight,0):typeof VideoFrame<"u"&&t instanceof VideoFrame?e.set(t.displayWidth,t.displayHeight,0):t!==null?e.set(t.width,t.height,t.depth||0):e.set(0,0,0),e}set needsUpdate(e){e===!0&&this.version++}toJSON(e){const t=e===void 0||typeof e=="string";if(!t&&e.images[this.uuid]!==void 0)return e.images[this.uuid];const i={uuid:this.uuid,url:""},r=this.data;if(r!==null){let s;if(Array.isArray(r)){s=[];for(let o=0,a=r.length;o<a;o++)r[o].isDataTexture?s.push(Oa(r[o].image)):s.push(Oa(r[o]))}else s=Oa(r);i.url=s}return t||(e.images[this.uuid]=i),i}}function Oa(n){return typeof HTMLImageElement<"u"&&n instanceof HTMLImageElement||typeof HTMLCanvasElement<"u"&&n instanceof HTMLCanvasElement||typeof ImageBitmap<"u"&&n instanceof ImageBitmap?a0.getDataURL(n):n.data?{data:Array.from(n.data),width:n.width,height:n.height,type:n.data.constructor.name}:(ze("Texture: Unable to serialize Texture."),{})}let c0=0;const Ba=new N;class rn extends Ni{constructor(e=rn.DEFAULT_IMAGE,t=rn.DEFAULT_MAPPING,i=si,r=si,s=jt,o=er,a=Tn,l=xn,c=rn.DEFAULT_ANISOTROPY,u=Pi){super(),this.isTexture=!0,Object.defineProperty(this,"id",{value:c0++}),this.uuid=kr(),this.name="",this.source=new qc(e),this.mipmaps=[],this.mapping=t,this.channel=0,this.wrapS=i,this.wrapT=r,this.magFilter=s,this.minFilter=o,this.anisotropy=c,this.format=a,this.internalFormat=null,this.type=l,this.offset=new st(0,0),this.repeat=new st(1,1),this.center=new st(0,0),this.rotation=0,this.matrixAutoUpdate=!0,this.matrix=new Xe,this.generateMipmaps=!0,this.premultiplyAlpha=!1,this.flipY=!0,this.unpackAlignment=4,this.colorSpace=u,this.userData={},this.updateRanges=[],this.version=0,this.onUpdate=null,this.renderTarget=null,this.isRenderTargetTexture=!1,this.isArrayTexture=!!(e&&e.depth&&e.depth>1),this.pmremVersion=0,this.normalized=!1}get width(){return this.source.getSize(Ba).x}get height(){return this.source.getSize(Ba).y}get depth(){return this.source.getSize(Ba).z}get image(){return this.source.data}set image(e){this.source.data=e}updateMatrix(){this.matrix.setUvTransform(this.offset.x,this.offset.y,this.repeat.x,this.repeat.y,this.rotation,this.center.x,this.center.y)}addUpdateRange(e,t){this.updateRanges.push({start:e,count:t})}clearUpdateRanges(){this.updateRanges.length=0}clone(){return new this.constructor().copy(this)}copy(e){return this.name=e.name,this.source=e.source,this.mipmaps=e.mipmaps.slice(0),this.mapping=e.mapping,this.channel=e.channel,this.wrapS=e.wrapS,this.wrapT=e.wrapT,this.magFilter=e.magFilter,this.minFilter=e.minFilter,this.anisotropy=e.anisotropy,this.format=e.format,this.internalFormat=e.internalFormat,this.type=e.type,this.normalized=e.normalized,this.offset.copy(e.offset),this.repeat.copy(e.repeat),this.center.copy(e.center),this.rotation=e.rotation,this.matrixAutoUpdate=e.matrixAutoUpdate,this.matrix.copy(e.matrix),this.generateMipmaps=e.generateMipmaps,this.premultiplyAlpha=e.premultiplyAlpha,this.flipY=e.flipY,this.unpackAlignment=e.unpackAlignment,this.colorSpace=e.colorSpace,this.renderTarget=e.renderTarget,this.isRenderTargetTexture=e.isRenderTargetTexture,this.isArrayTexture=e.isArrayTexture,this.userData=JSON.parse(JSON.stringify(e.userData)),this.needsUpdate=!0,this}setValues(e){for(const t in e){const i=e[t];if(i===void 0){ze(`Texture.setValues(): parameter '${t}' has value of undefined.`);continue}const r=this[t];if(r===void 0){ze(`Texture.setValues(): property '${t}' does not exist.`);continue}r&&i&&r.isVector2&&i.isVector2||r&&i&&r.isVector3&&i.isVector3||r&&i&&r.isMatrix3&&i.isMatrix3?r.copy(i):this[t]=i}}toJSON(e){const t=e===void 0||typeof e=="string";if(!t&&e.textures[this.uuid]!==void 0)return e.textures[this.uuid];const i={metadata:{version:4.7,type:"Texture",generator:"Texture.toJSON"},uuid:this.uuid,name:this.name,image:this.source.toJSON(e).uuid,mapping:this.mapping,channel:this.channel,repeat:[this.repeat.x,this.repeat.y],offset:[this.offset.x,this.offset.y],center:[this.center.x,this.center.y],rotation:this.rotation,wrap:[this.wrapS,this.wrapT],format:this.format,internalFormat:this.internalFormat,type:this.type,normalized:this.normalized,colorSpace:this.colorSpace,minFilter:this.minFilter,magFilter:this.magFilter,anisotropy:this.anisotropy,flipY:this.flipY,generateMipmaps:this.generateMipmaps,premultiplyAlpha:this.premultiplyAlpha,unpackAlignment:this.unpackAlignment};return Object.keys(this.userData).length>0&&(i.userData=this.userData),t||(e.textures[this.uuid]=i),i}dispose(){this.dispatchEvent({type:"dispose"})}transformUv(e){if(this.mapping!==Bd)return e;if(e.applyMatrix3(this.matrix),e.x<0||e.x>1)switch(this.wrapS){case Fl:e.x=e.x-Math.floor(e.x);break;case si:e.x=e.x<0?0:1;break;case Ol:Math.abs(Math.floor(e.x)%2)===1?e.x=Math.ceil(e.x)-e.x:e.x=e.x-Math.floor(e.x);break}if(e.y<0||e.y>1)switch(this.wrapT){case Fl:e.y=e.y-Math.floor(e.y);break;case si:e.y=e.y<0?0:1;break;case Ol:Math.abs(Math.floor(e.y)%2)===1?e.y=Math.ceil(e.y)-e.y:e.y=e.y-Math.floor(e.y);break}return this.flipY&&(e.y=1-e.y),e}set needsUpdate(e){e===!0&&(this.version++,this.source.needsUpdate=!0)}set needsPMREMUpdate(e){e===!0&&this.pmremVersion++}}rn.DEFAULT_IMAGE=null;rn.DEFAULT_MAPPING=Bd;rn.DEFAULT_ANISOTROPY=1;class At{static{At.prototype.isVector4=!0}constructor(e=0,t=0,i=0,r=1){this.x=e,this.y=t,this.z=i,this.w=r}get width(){return this.z}set width(e){this.z=e}get height(){return this.w}set height(e){this.w=e}set(e,t,i,r){return this.x=e,this.y=t,this.z=i,this.w=r,this}setScalar(e){return this.x=e,this.y=e,this.z=e,this.w=e,this}setX(e){return this.x=e,this}setY(e){return this.y=e,this}setZ(e){return this.z=e,this}setW(e){return this.w=e,this}setComponent(e,t){switch(e){case 0:this.x=t;break;case 1:this.y=t;break;case 2:this.z=t;break;case 3:this.w=t;break;default:throw new Error("index is out of range: "+e)}return this}getComponent(e){switch(e){case 0:return this.x;case 1:return this.y;case 2:return this.z;case 3:return this.w;default:throw new Error("index is out of range: "+e)}}clone(){return new this.constructor(this.x,this.y,this.z,this.w)}copy(e){return this.x=e.x,this.y=e.y,this.z=e.z,this.w=e.w!==void 0?e.w:1,this}add(e){return this.x+=e.x,this.y+=e.y,this.z+=e.z,this.w+=e.w,this}addScalar(e){return this.x+=e,this.y+=e,this.z+=e,this.w+=e,this}addVectors(e,t){return this.x=e.x+t.x,this.y=e.y+t.y,this.z=e.z+t.z,this.w=e.w+t.w,this}addScaledVector(e,t){return this.x+=e.x*t,this.y+=e.y*t,this.z+=e.z*t,this.w+=e.w*t,this}sub(e){return this.x-=e.x,this.y-=e.y,this.z-=e.z,this.w-=e.w,this}subScalar(e){return this.x-=e,this.y-=e,this.z-=e,this.w-=e,this}subVectors(e,t){return this.x=e.x-t.x,this.y=e.y-t.y,this.z=e.z-t.z,this.w=e.w-t.w,this}multiply(e){return this.x*=e.x,this.y*=e.y,this.z*=e.z,this.w*=e.w,this}multiplyScalar(e){return this.x*=e,this.y*=e,this.z*=e,this.w*=e,this}applyMatrix4(e){const t=this.x,i=this.y,r=this.z,s=this.w,o=e.elements;return this.x=o[0]*t+o[4]*i+o[8]*r+o[12]*s,this.y=o[1]*t+o[5]*i+o[9]*r+o[13]*s,this.z=o[2]*t+o[6]*i+o[10]*r+o[14]*s,this.w=o[3]*t+o[7]*i+o[11]*r+o[15]*s,this}divide(e){return this.x/=e.x,this.y/=e.y,this.z/=e.z,this.w/=e.w,this}divideScalar(e){return this.multiplyScalar(1/e)}setAxisAngleFromQuaternion(e){this.w=2*Math.acos(e.w);const t=Math.sqrt(1-e.w*e.w);return t<1e-4?(this.x=1,this.y=0,this.z=0):(this.x=e.x/t,this.y=e.y/t,this.z=e.z/t),this}setAxisAngleFromRotationMatrix(e){let t,i,r,s;const l=e.elements,c=l[0],u=l[4],h=l[8],f=l[1],p=l[5],g=l[9],M=l[2],m=l[6],d=l[10];if(Math.abs(u-f)<.01&&Math.abs(h-M)<.01&&Math.abs(g-m)<.01){if(Math.abs(u+f)<.1&&Math.abs(h+M)<.1&&Math.abs(g+m)<.1&&Math.abs(c+p+d-3)<.1)return this.set(1,0,0,0),this;t=Math.PI;const y=(c+1)/2,S=(p+1)/2,C=(d+1)/2,A=(u+f)/4,P=(h+M)/4,v=(g+m)/4;return y>S&&y>C?y<.01?(i=0,r=.707106781,s=.707106781):(i=Math.sqrt(y),r=A/i,s=P/i):S>C?S<.01?(i=.707106781,r=0,s=.707106781):(r=Math.sqrt(S),i=A/r,s=v/r):C<.01?(i=.707106781,r=.707106781,s=0):(s=Math.sqrt(C),i=P/s,r=v/s),this.set(i,r,s,t),this}let x=Math.sqrt((m-g)*(m-g)+(h-M)*(h-M)+(f-u)*(f-u));return Math.abs(x)<.001&&(x=1),this.x=(m-g)/x,this.y=(h-M)/x,this.z=(f-u)/x,this.w=Math.acos((c+p+d-1)/2),this}setFromMatrixPosition(e){const t=e.elements;return this.x=t[12],this.y=t[13],this.z=t[14],this.w=t[15],this}min(e){return this.x=Math.min(this.x,e.x),this.y=Math.min(this.y,e.y),this.z=Math.min(this.z,e.z),this.w=Math.min(this.w,e.w),this}max(e){return this.x=Math.max(this.x,e.x),this.y=Math.max(this.y,e.y),this.z=Math.max(this.z,e.z),this.w=Math.max(this.w,e.w),this}clamp(e,t){return this.x=Je(this.x,e.x,t.x),this.y=Je(this.y,e.y,t.y),this.z=Je(this.z,e.z,t.z),this.w=Je(this.w,e.w,t.w),this}clampScalar(e,t){return this.x=Je(this.x,e,t),this.y=Je(this.y,e,t),this.z=Je(this.z,e,t),this.w=Je(this.w,e,t),this}clampLength(e,t){const i=this.length();return this.divideScalar(i||1).multiplyScalar(Je(i,e,t))}floor(){return this.x=Math.floor(this.x),this.y=Math.floor(this.y),this.z=Math.floor(this.z),this.w=Math.floor(this.w),this}ceil(){return this.x=Math.ceil(this.x),this.y=Math.ceil(this.y),this.z=Math.ceil(this.z),this.w=Math.ceil(this.w),this}round(){return this.x=Math.round(this.x),this.y=Math.round(this.y),this.z=Math.round(this.z),this.w=Math.round(this.w),this}roundToZero(){return this.x=Math.trunc(this.x),this.y=Math.trunc(this.y),this.z=Math.trunc(this.z),this.w=Math.trunc(this.w),this}negate(){return this.x=-this.x,this.y=-this.y,this.z=-this.z,this.w=-this.w,this}dot(e){return this.x*e.x+this.y*e.y+this.z*e.z+this.w*e.w}lengthSq(){return this.x*this.x+this.y*this.y+this.z*this.z+this.w*this.w}length(){return Math.sqrt(this.x*this.x+this.y*this.y+this.z*this.z+this.w*this.w)}manhattanLength(){return Math.abs(this.x)+Math.abs(this.y)+Math.abs(this.z)+Math.abs(this.w)}normalize(){return this.divideScalar(this.length()||1)}setLength(e){return this.normalize().multiplyScalar(e)}lerp(e,t){return this.x+=(e.x-this.x)*t,this.y+=(e.y-this.y)*t,this.z+=(e.z-this.z)*t,this.w+=(e.w-this.w)*t,this}lerpVectors(e,t,i){return this.x=e.x+(t.x-e.x)*i,this.y=e.y+(t.y-e.y)*i,this.z=e.z+(t.z-e.z)*i,this.w=e.w+(t.w-e.w)*i,this}equals(e){return e.x===this.x&&e.y===this.y&&e.z===this.z&&e.w===this.w}fromArray(e,t=0){return this.x=e[t],this.y=e[t+1],this.z=e[t+2],this.w=e[t+3],this}toArray(e=[],t=0){return e[t]=this.x,e[t+1]=this.y,e[t+2]=this.z,e[t+3]=this.w,e}fromBufferAttribute(e,t){return this.x=e.getX(t),this.y=e.getY(t),this.z=e.getZ(t),this.w=e.getW(t),this}random(){return this.x=Math.random(),this.y=Math.random(),this.z=Math.random(),this.w=Math.random(),this}*[Symbol.iterator](){yield this.x,yield this.y,yield this.z,yield this.w}}class u0 extends Ni{constructor(e=1,t=1,i={}){super(),i=Object.assign({generateMipmaps:!1,internalFormat:null,minFilter:jt,depthBuffer:!0,stencilBuffer:!1,resolveDepthBuffer:!0,resolveStencilBuffer:!0,depthTexture:null,samples:0,count:1,depth:1,multiview:!1},i),this.isRenderTarget=!0,this.width=e,this.height=t,this.depth=i.depth,this.scissor=new At(0,0,e,t),this.scissorTest=!1,this.viewport=new At(0,0,e,t),this.textures=[];const r={width:e,height:t,depth:i.depth},s=new rn(r),o=i.count;for(let a=0;a<o;a++)this.textures[a]=s.clone(),this.textures[a].isRenderTargetTexture=!0,this.textures[a].renderTarget=this;this._setTextureOptions(i),this.depthBuffer=i.depthBuffer,this.stencilBuffer=i.stencilBuffer,this.resolveDepthBuffer=i.resolveDepthBuffer,this.resolveStencilBuffer=i.resolveStencilBuffer,this._depthTexture=null,this.depthTexture=i.depthTexture,this.samples=i.samples,this.multiview=i.multiview}_setTextureOptions(e={}){const t={minFilter:jt,generateMipmaps:!1,flipY:!1,internalFormat:null};e.mapping!==void 0&&(t.mapping=e.mapping),e.wrapS!==void 0&&(t.wrapS=e.wrapS),e.wrapT!==void 0&&(t.wrapT=e.wrapT),e.wrapR!==void 0&&(t.wrapR=e.wrapR),e.magFilter!==void 0&&(t.magFilter=e.magFilter),e.minFilter!==void 0&&(t.minFilter=e.minFilter),e.format!==void 0&&(t.format=e.format),e.type!==void 0&&(t.type=e.type),e.anisotropy!==void 0&&(t.anisotropy=e.anisotropy),e.colorSpace!==void 0&&(t.colorSpace=e.colorSpace),e.flipY!==void 0&&(t.flipY=e.flipY),e.generateMipmaps!==void 0&&(t.generateMipmaps=e.generateMipmaps),e.internalFormat!==void 0&&(t.internalFormat=e.internalFormat);for(let i=0;i<this.textures.length;i++)this.textures[i].setValues(t)}get texture(){return this.textures[0]}set texture(e){this.textures[0]=e}set depthTexture(e){this._depthTexture!==null&&(this._depthTexture.renderTarget=null),e!==null&&(e.renderTarget=this),this._depthTexture=e}get depthTexture(){return this._depthTexture}setSize(e,t,i=1){if(this.width!==e||this.height!==t||this.depth!==i){this.width=e,this.height=t,this.depth=i;for(let r=0,s=this.textures.length;r<s;r++)this.textures[r].image.width=e,this.textures[r].image.height=t,this.textures[r].image.depth=i,this.textures[r].isData3DTexture!==!0&&(this.textures[r].isArrayTexture=this.textures[r].image.depth>1);this.dispose()}this.viewport.set(0,0,e,t),this.scissor.set(0,0,e,t)}clone(){return new this.constructor().copy(this)}copy(e){this.width=e.width,this.height=e.height,this.depth=e.depth,this.scissor.copy(e.scissor),this.scissorTest=e.scissorTest,this.viewport.copy(e.viewport),this.textures.length=0;for(let t=0,i=e.textures.length;t<i;t++){this.textures[t]=e.textures[t].clone(),this.textures[t].isRenderTargetTexture=!0,this.textures[t].renderTarget=this;const r=Object.assign({},e.textures[t].image);this.textures[t].source=new qc(r)}return this.depthBuffer=e.depthBuffer,this.stencilBuffer=e.stencilBuffer,this.resolveDepthBuffer=e.resolveDepthBuffer,this.resolveStencilBuffer=e.resolveStencilBuffer,e.depthTexture!==null&&(this.depthTexture=e.depthTexture.clone()),this.samples=e.samples,this.multiview=e.multiview,this}dispose(){this.dispatchEvent({type:"dispose"})}}class Wn extends u0{constructor(e=1,t=1,i={}){super(e,t,i),this.isWebGLRenderTarget=!0}}class qd extends rn{constructor(e=null,t=1,i=1,r=1){super(null),this.isDataArrayTexture=!0,this.image={data:e,width:t,height:i,depth:r},this.magFilter=zt,this.minFilter=zt,this.wrapR=si,this.generateMipmaps=!1,this.flipY=!1,this.unpackAlignment=1,this.layerUpdates=new Set}addLayerUpdate(e){this.layerUpdates.add(e)}clearLayerUpdates(){this.layerUpdates.clear()}}class f0 extends rn{constructor(e=null,t=1,i=1,r=1){super(null),this.isData3DTexture=!0,this.image={data:e,width:t,height:i,depth:r},this.magFilter=zt,this.minFilter=zt,this.wrapR=si,this.generateMipmaps=!1,this.flipY=!1,this.unpackAlignment=1}}class Mt{static{Mt.prototype.isMatrix4=!0}constructor(e,t,i,r,s,o,a,l,c,u,h,f,p,g,M,m){this.elements=[1,0,0,0,0,1,0,0,0,0,1,0,0,0,0,1],e!==void 0&&this.set(e,t,i,r,s,o,a,l,c,u,h,f,p,g,M,m)}set(e,t,i,r,s,o,a,l,c,u,h,f,p,g,M,m){const d=this.elements;return d[0]=e,d[4]=t,d[8]=i,d[12]=r,d[1]=s,d[5]=o,d[9]=a,d[13]=l,d[2]=c,d[6]=u,d[10]=h,d[14]=f,d[3]=p,d[7]=g,d[11]=M,d[15]=m,this}identity(){return this.set(1,0,0,0,0,1,0,0,0,0,1,0,0,0,0,1),this}clone(){return new Mt().fromArray(this.elements)}copy(e){const t=this.elements,i=e.elements;return t[0]=i[0],t[1]=i[1],t[2]=i[2],t[3]=i[3],t[4]=i[4],t[5]=i[5],t[6]=i[6],t[7]=i[7],t[8]=i[8],t[9]=i[9],t[10]=i[10],t[11]=i[11],t[12]=i[12],t[13]=i[13],t[14]=i[14],t[15]=i[15],this}copyPosition(e){const t=this.elements,i=e.elements;return t[12]=i[12],t[13]=i[13],t[14]=i[14],this}setFromMatrix3(e){const t=e.elements;return this.set(t[0],t[3],t[6],0,t[1],t[4],t[7],0,t[2],t[5],t[8],0,0,0,0,1),this}extractBasis(e,t,i){return this.determinant()===0?(e.set(1,0,0),t.set(0,1,0),i.set(0,0,1),this):(e.setFromMatrixColumn(this,0),t.setFromMatrixColumn(this,1),i.setFromMatrixColumn(this,2),this)}makeBasis(e,t,i){return this.set(e.x,t.x,i.x,0,e.y,t.y,i.y,0,e.z,t.z,i.z,0,0,0,0,1),this}extractRotation(e){if(e.determinant()===0)return this.identity();const t=this.elements,i=e.elements,r=1/pr.setFromMatrixColumn(e,0).length(),s=1/pr.setFromMatrixColumn(e,1).length(),o=1/pr.setFromMatrixColumn(e,2).length();return t[0]=i[0]*r,t[1]=i[1]*r,t[2]=i[2]*r,t[3]=0,t[4]=i[4]*s,t[5]=i[5]*s,t[6]=i[6]*s,t[7]=0,t[8]=i[8]*o,t[9]=i[9]*o,t[10]=i[10]*o,t[11]=0,t[12]=0,t[13]=0,t[14]=0,t[15]=1,this}makeRotationFromEuler(e){const t=this.elements,i=e.x,r=e.y,s=e.z,o=Math.cos(i),a=Math.sin(i),l=Math.cos(r),c=Math.sin(r),u=Math.cos(s),h=Math.sin(s);if(e.order==="XYZ"){const f=o*u,p=o*h,g=a*u,M=a*h;t[0]=l*u,t[4]=-l*h,t[8]=c,t[1]=p+g*c,t[5]=f-M*c,t[9]=-a*l,t[2]=M-f*c,t[6]=g+p*c,t[10]=o*l}else if(e.order==="YXZ"){const f=l*u,p=l*h,g=c*u,M=c*h;t[0]=f+M*a,t[4]=g*a-p,t[8]=o*c,t[1]=o*h,t[5]=o*u,t[9]=-a,t[2]=p*a-g,t[6]=M+f*a,t[10]=o*l}else if(e.order==="ZXY"){const f=l*u,p=l*h,g=c*u,M=c*h;t[0]=f-M*a,t[4]=-o*h,t[8]=g+p*a,t[1]=p+g*a,t[5]=o*u,t[9]=M-f*a,t[2]=-o*c,t[6]=a,t[10]=o*l}else if(e.order==="ZYX"){const f=o*u,p=o*h,g=a*u,M=a*h;t[0]=l*u,t[4]=g*c-p,t[8]=f*c+M,t[1]=l*h,t[5]=M*c+f,t[9]=p*c-g,t[2]=-c,t[6]=a*l,t[10]=o*l}else if(e.order==="YZX"){const f=o*l,p=o*c,g=a*l,M=a*c;t[0]=l*u,t[4]=M-f*h,t[8]=g*h+p,t[1]=h,t[5]=o*u,t[9]=-a*u,t[2]=-c*u,t[6]=p*h+g,t[10]=f-M*h}else if(e.order==="XZY"){const f=o*l,p=o*c,g=a*l,M=a*c;t[0]=l*u,t[4]=-h,t[8]=c*u,t[1]=f*h+M,t[5]=o*u,t[9]=p*h-g,t[2]=g*h-p,t[6]=a*u,t[10]=M*h+f}return t[3]=0,t[7]=0,t[11]=0,t[12]=0,t[13]=0,t[14]=0,t[15]=1,this}makeRotationFromQuaternion(e){return this.compose(h0,e,d0)}lookAt(e,t,i){const r=this.elements;return ln.subVectors(e,t),ln.lengthSq()===0&&(ln.z=1),ln.normalize(),vi.crossVectors(i,ln),vi.lengthSq()===0&&(Math.abs(i.z)===1?ln.x+=1e-4:ln.z+=1e-4,ln.normalize(),vi.crossVectors(i,ln)),vi.normalize(),Xs.crossVectors(ln,vi),r[0]=vi.x,r[4]=Xs.x,r[8]=ln.x,r[1]=vi.y,r[5]=Xs.y,r[9]=ln.y,r[2]=vi.z,r[6]=Xs.z,r[10]=ln.z,this}multiply(e){return this.multiplyMatrices(this,e)}premultiply(e){return this.multiplyMatrices(e,this)}multiplyMatrices(e,t){const i=e.elements,r=t.elements,s=this.elements,o=i[0],a=i[4],l=i[8],c=i[12],u=i[1],h=i[5],f=i[9],p=i[13],g=i[2],M=i[6],m=i[10],d=i[14],x=i[3],y=i[7],S=i[11],C=i[15],A=r[0],P=r[4],v=r[8],T=r[12],L=r[1],D=r[5],I=r[9],k=r[13],G=r[2],O=r[6],V=r[10],H=r[14],$=r[3],oe=r[7],ve=r[11],be=r[15];return s[0]=o*A+a*L+l*G+c*$,s[4]=o*P+a*D+l*O+c*oe,s[8]=o*v+a*I+l*V+c*ve,s[12]=o*T+a*k+l*H+c*be,s[1]=u*A+h*L+f*G+p*$,s[5]=u*P+h*D+f*O+p*oe,s[9]=u*v+h*I+f*V+p*ve,s[13]=u*T+h*k+f*H+p*be,s[2]=g*A+M*L+m*G+d*$,s[6]=g*P+M*D+m*O+d*oe,s[10]=g*v+M*I+m*V+d*ve,s[14]=g*T+M*k+m*H+d*be,s[3]=x*A+y*L+S*G+C*$,s[7]=x*P+y*D+S*O+C*oe,s[11]=x*v+y*I+S*V+C*ve,s[15]=x*T+y*k+S*H+C*be,this}multiplyScalar(e){const t=this.elements;return t[0]*=e,t[4]*=e,t[8]*=e,t[12]*=e,t[1]*=e,t[5]*=e,t[9]*=e,t[13]*=e,t[2]*=e,t[6]*=e,t[10]*=e,t[14]*=e,t[3]*=e,t[7]*=e,t[11]*=e,t[15]*=e,this}determinant(){const e=this.elements,t=e[0],i=e[4],r=e[8],s=e[12],o=e[1],a=e[5],l=e[9],c=e[13],u=e[2],h=e[6],f=e[10],p=e[14],g=e[3],M=e[7],m=e[11],d=e[15],x=l*p-c*f,y=a*p-c*h,S=a*f-l*h,C=o*p-c*u,A=o*f-l*u,P=o*h-a*u;return t*(M*x-m*y+d*S)-i*(g*x-m*C+d*A)+r*(g*y-M*C+d*P)-s*(g*S-M*A+m*P)}transpose(){const e=this.elements;let t;return t=e[1],e[1]=e[4],e[4]=t,t=e[2],e[2]=e[8],e[8]=t,t=e[6],e[6]=e[9],e[9]=t,t=e[3],e[3]=e[12],e[12]=t,t=e[7],e[7]=e[13],e[13]=t,t=e[11],e[11]=e[14],e[14]=t,this}setPosition(e,t,i){const r=this.elements;return e.isVector3?(r[12]=e.x,r[13]=e.y,r[14]=e.z):(r[12]=e,r[13]=t,r[14]=i),this}invert(){const e=this.elements,t=e[0],i=e[1],r=e[2],s=e[3],o=e[4],a=e[5],l=e[6],c=e[7],u=e[8],h=e[9],f=e[10],p=e[11],g=e[12],M=e[13],m=e[14],d=e[15],x=t*a-i*o,y=t*l-r*o,S=t*c-s*o,C=i*l-r*a,A=i*c-s*a,P=r*c-s*l,v=u*M-h*g,T=u*m-f*g,L=u*d-p*g,D=h*m-f*M,I=h*d-p*M,k=f*d-p*m,G=x*k-y*I+S*D+C*L-A*T+P*v;if(G===0)return this.set(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0);const O=1/G;return e[0]=(a*k-l*I+c*D)*O,e[1]=(r*I-i*k-s*D)*O,e[2]=(M*P-m*A+d*C)*O,e[3]=(f*A-h*P-p*C)*O,e[4]=(l*L-o*k-c*T)*O,e[5]=(t*k-r*L+s*T)*O,e[6]=(m*S-g*P-d*y)*O,e[7]=(u*P-f*S+p*y)*O,e[8]=(o*I-a*L+c*v)*O,e[9]=(i*L-t*I-s*v)*O,e[10]=(g*A-M*S+d*x)*O,e[11]=(h*S-u*A-p*x)*O,e[12]=(a*T-o*D-l*v)*O,e[13]=(t*D-i*T+r*v)*O,e[14]=(M*y-g*C-m*x)*O,e[15]=(u*C-h*y+f*x)*O,this}scale(e){const t=this.elements,i=e.x,r=e.y,s=e.z;return t[0]*=i,t[4]*=r,t[8]*=s,t[1]*=i,t[5]*=r,t[9]*=s,t[2]*=i,t[6]*=r,t[10]*=s,t[3]*=i,t[7]*=r,t[11]*=s,this}getMaxScaleOnAxis(){const e=this.elements,t=e[0]*e[0]+e[1]*e[1]+e[2]*e[2],i=e[4]*e[4]+e[5]*e[5]+e[6]*e[6],r=e[8]*e[8]+e[9]*e[9]+e[10]*e[10];return Math.sqrt(Math.max(t,i,r))}makeTranslation(e,t,i){return e.isVector3?this.set(1,0,0,e.x,0,1,0,e.y,0,0,1,e.z,0,0,0,1):this.set(1,0,0,e,0,1,0,t,0,0,1,i,0,0,0,1),this}makeRotationX(e){const t=Math.cos(e),i=Math.sin(e);return this.set(1,0,0,0,0,t,-i,0,0,i,t,0,0,0,0,1),this}makeRotationY(e){const t=Math.cos(e),i=Math.sin(e);return this.set(t,0,i,0,0,1,0,0,-i,0,t,0,0,0,0,1),this}makeRotationZ(e){const t=Math.cos(e),i=Math.sin(e);return this.set(t,-i,0,0,i,t,0,0,0,0,1,0,0,0,0,1),this}makeRotationAxis(e,t){const i=Math.cos(t),r=Math.sin(t),s=1-i,o=e.x,a=e.y,l=e.z,c=s*o,u=s*a;return this.set(c*o+i,c*a-r*l,c*l+r*a,0,c*a+r*l,u*a+i,u*l-r*o,0,c*l-r*a,u*l+r*o,s*l*l+i,0,0,0,0,1),this}makeScale(e,t,i){return this.set(e,0,0,0,0,t,0,0,0,0,i,0,0,0,0,1),this}makeShear(e,t,i,r,s,o){return this.set(1,i,s,0,e,1,o,0,t,r,1,0,0,0,0,1),this}compose(e,t,i){const r=this.elements,s=t._x,o=t._y,a=t._z,l=t._w,c=s+s,u=o+o,h=a+a,f=s*c,p=s*u,g=s*h,M=o*u,m=o*h,d=a*h,x=l*c,y=l*u,S=l*h,C=i.x,A=i.y,P=i.z;return r[0]=(1-(M+d))*C,r[1]=(p+S)*C,r[2]=(g-y)*C,r[3]=0,r[4]=(p-S)*A,r[5]=(1-(f+d))*A,r[6]=(m+x)*A,r[7]=0,r[8]=(g+y)*P,r[9]=(m-x)*P,r[10]=(1-(f+M))*P,r[11]=0,r[12]=e.x,r[13]=e.y,r[14]=e.z,r[15]=1,this}decompose(e,t,i){const r=this.elements;e.x=r[12],e.y=r[13],e.z=r[14];const s=this.determinant();if(s===0)return i.set(1,1,1),t.identity(),this;let o=pr.set(r[0],r[1],r[2]).length();const a=pr.set(r[4],r[5],r[6]).length(),l=pr.set(r[8],r[9],r[10]).length();s<0&&(o=-o),Mn.copy(this);const c=1/o,u=1/a,h=1/l;return Mn.elements[0]*=c,Mn.elements[1]*=c,Mn.elements[2]*=c,Mn.elements[4]*=u,Mn.elements[5]*=u,Mn.elements[6]*=u,Mn.elements[8]*=h,Mn.elements[9]*=h,Mn.elements[10]*=h,t.setFromRotationMatrix(Mn),i.x=o,i.y=a,i.z=l,this}makePerspective(e,t,i,r,s,o,a=Vn,l=!1){const c=this.elements,u=2*s/(t-e),h=2*s/(i-r),f=(t+e)/(t-e),p=(i+r)/(i-r);let g,M;if(l)g=s/(o-s),M=o*s/(o-s);else if(a===Vn)g=-(o+s)/(o-s),M=-2*o*s/(o-s);else if(a===qo)g=-o/(o-s),M=-o*s/(o-s);else throw new Error("THREE.Matrix4.makePerspective(): Invalid coordinate system: "+a);return c[0]=u,c[4]=0,c[8]=f,c[12]=0,c[1]=0,c[5]=h,c[9]=p,c[13]=0,c[2]=0,c[6]=0,c[10]=g,c[14]=M,c[3]=0,c[7]=0,c[11]=-1,c[15]=0,this}makeOrthographic(e,t,i,r,s,o,a=Vn,l=!1){const c=this.elements,u=2/(t-e),h=2/(i-r),f=-(t+e)/(t-e),p=-(i+r)/(i-r);let g,M;if(l)g=1/(o-s),M=o/(o-s);else if(a===Vn)g=-2/(o-s),M=-(o+s)/(o-s);else if(a===qo)g=-1/(o-s),M=-s/(o-s);else throw new Error("THREE.Matrix4.makeOrthographic(): Invalid coordinate system: "+a);return c[0]=u,c[4]=0,c[8]=0,c[12]=f,c[1]=0,c[5]=h,c[9]=0,c[13]=p,c[2]=0,c[6]=0,c[10]=g,c[14]=M,c[3]=0,c[7]=0,c[11]=0,c[15]=1,this}equals(e){const t=this.elements,i=e.elements;for(let r=0;r<16;r++)if(t[r]!==i[r])return!1;return!0}fromArray(e,t=0){for(let i=0;i<16;i++)this.elements[i]=e[i+t];return this}toArray(e=[],t=0){const i=this.elements;return e[t]=i[0],e[t+1]=i[1],e[t+2]=i[2],e[t+3]=i[3],e[t+4]=i[4],e[t+5]=i[5],e[t+6]=i[6],e[t+7]=i[7],e[t+8]=i[8],e[t+9]=i[9],e[t+10]=i[10],e[t+11]=i[11],e[t+12]=i[12],e[t+13]=i[13],e[t+14]=i[14],e[t+15]=i[15],e}}const pr=new N,Mn=new Mt,h0=new N(0,0,0),d0=new N(1,1,1),vi=new N,Xs=new N,ln=new N,lf=new Mt,cf=new Xt;class Ui{constructor(e=0,t=0,i=0,r=Ui.DEFAULT_ORDER){this.isEuler=!0,this._x=e,this._y=t,this._z=i,this._order=r}get x(){return this._x}set x(e){this._x=e,this._onChangeCallback()}get y(){return this._y}set y(e){this._y=e,this._onChangeCallback()}get z(){return this._z}set z(e){this._z=e,this._onChangeCallback()}get order(){return this._order}set order(e){this._order=e,this._onChangeCallback()}set(e,t,i,r=this._order){return this._x=e,this._y=t,this._z=i,this._order=r,this._onChangeCallback(),this}clone(){return new this.constructor(this._x,this._y,this._z,this._order)}copy(e){return this._x=e._x,this._y=e._y,this._z=e._z,this._order=e._order,this._onChangeCallback(),this}setFromRotationMatrix(e,t=this._order,i=!0){const r=e.elements,s=r[0],o=r[4],a=r[8],l=r[1],c=r[5],u=r[9],h=r[2],f=r[6],p=r[10];switch(t){case"XYZ":this._y=Math.asin(Je(a,-1,1)),Math.abs(a)<.9999999?(this._x=Math.atan2(-u,p),this._z=Math.atan2(-o,s)):(this._x=Math.atan2(f,c),this._z=0);break;case"YXZ":this._x=Math.asin(-Je(u,-1,1)),Math.abs(u)<.9999999?(this._y=Math.atan2(a,p),this._z=Math.atan2(l,c)):(this._y=Math.atan2(-h,s),this._z=0);break;case"ZXY":this._x=Math.asin(Je(f,-1,1)),Math.abs(f)<.9999999?(this._y=Math.atan2(-h,p),this._z=Math.atan2(-o,c)):(this._y=0,this._z=Math.atan2(l,s));break;case"ZYX":this._y=Math.asin(-Je(h,-1,1)),Math.abs(h)<.9999999?(this._x=Math.atan2(f,p),this._z=Math.atan2(l,s)):(this._x=0,this._z=Math.atan2(-o,c));break;case"YZX":this._z=Math.asin(Je(l,-1,1)),Math.abs(l)<.9999999?(this._x=Math.atan2(-u,c),this._y=Math.atan2(-h,s)):(this._x=0,this._y=Math.atan2(a,p));break;case"XZY":this._z=Math.asin(-Je(o,-1,1)),Math.abs(o)<.9999999?(this._x=Math.atan2(f,c),this._y=Math.atan2(a,s)):(this._x=Math.atan2(-u,p),this._y=0);break;default:ze("Euler: .setFromRotationMatrix() encountered an unknown order: "+t)}return this._order=t,i===!0&&this._onChangeCallback(),this}setFromQuaternion(e,t,i){return lf.makeRotationFromQuaternion(e),this.setFromRotationMatrix(lf,t,i)}setFromVector3(e,t=this._order){return this.set(e.x,e.y,e.z,t)}reorder(e){return cf.setFromEuler(this),this.setFromQuaternion(cf,e)}equals(e){return e._x===this._x&&e._y===this._y&&e._z===this._z&&e._order===this._order}fromArray(e){return this._x=e[0],this._y=e[1],this._z=e[2],e[3]!==void 0&&(this._order=e[3]),this._onChangeCallback(),this}toArray(e=[],t=0){return e[t]=this._x,e[t+1]=this._y,e[t+2]=this._z,e[t+3]=this._order,e}_onChange(e){return this._onChangeCallback=e,this}_onChangeCallback(){}*[Symbol.iterator](){yield this._x,yield this._y,yield this._z,yield this._order}}Ui.DEFAULT_ORDER="XYZ";class Kc{constructor(){this.mask=1}set(e){this.mask=(1<<e|0)>>>0}enable(e){this.mask|=1<<e|0}enableAll(){this.mask=-1}toggle(e){this.mask^=1<<e|0}disable(e){this.mask&=~(1<<e|0)}disableAll(){this.mask=0}test(e){return(this.mask&e.mask)!==0}isEnabled(e){return(this.mask&(1<<e|0))!==0}}let p0=0;const uf=new N,mr=new Xt,Zn=new Mt,Ys=new N,jr=new N,m0=new N,g0=new Xt,ff=new N(1,0,0),hf=new N(0,1,0),df=new N(0,0,1),pf={type:"added"},_0={type:"removed"},gr={type:"childadded",child:null},za={type:"childremoved",child:null};class Ft extends Ni{constructor(){super(),this.isObject3D=!0,Object.defineProperty(this,"id",{value:p0++}),this.uuid=kr(),this.name="",this.type="Object3D",this.parent=null,this.children=[],this.up=Ft.DEFAULT_UP.clone();const e=new N,t=new Ui,i=new Xt,r=new N(1,1,1);function s(){i.setFromEuler(t,!1)}function o(){t.setFromQuaternion(i,void 0,!1)}t._onChange(s),i._onChange(o),Object.defineProperties(this,{position:{configurable:!0,enumerable:!0,value:e},rotation:{configurable:!0,enumerable:!0,value:t},quaternion:{configurable:!0,enumerable:!0,value:i},scale:{configurable:!0,enumerable:!0,value:r},modelViewMatrix:{value:new Mt},normalMatrix:{value:new Xe}}),this.matrix=new Mt,this.matrixWorld=new Mt,this.matrixAutoUpdate=Ft.DEFAULT_MATRIX_AUTO_UPDATE,this.matrixWorldAutoUpdate=Ft.DEFAULT_MATRIX_WORLD_AUTO_UPDATE,this.matrixWorldNeedsUpdate=!1,this.layers=new Kc,this.visible=!0,this.castShadow=!1,this.receiveShadow=!1,this.frustumCulled=!0,this.renderOrder=0,this.animations=[],this.customDepthMaterial=void 0,this.customDistanceMaterial=void 0,this.static=!1,this.userData={},this.pivot=null}onBeforeShadow(){}onAfterShadow(){}onBeforeRender(){}onAfterRender(){}applyMatrix4(e){this.matrixAutoUpdate&&this.updateMatrix(),this.matrix.premultiply(e),this.matrix.decompose(this.position,this.quaternion,this.scale)}applyQuaternion(e){return this.quaternion.premultiply(e),this}setRotationFromAxisAngle(e,t){this.quaternion.setFromAxisAngle(e,t)}setRotationFromEuler(e){this.quaternion.setFromEuler(e,!0)}setRotationFromMatrix(e){this.quaternion.setFromRotationMatrix(e)}setRotationFromQuaternion(e){this.quaternion.copy(e)}rotateOnAxis(e,t){return mr.setFromAxisAngle(e,t),this.quaternion.multiply(mr),this}rotateOnWorldAxis(e,t){return mr.setFromAxisAngle(e,t),this.quaternion.premultiply(mr),this}rotateX(e){return this.rotateOnAxis(ff,e)}rotateY(e){return this.rotateOnAxis(hf,e)}rotateZ(e){return this.rotateOnAxis(df,e)}translateOnAxis(e,t){return uf.copy(e).applyQuaternion(this.quaternion),this.position.add(uf.multiplyScalar(t)),this}translateX(e){return this.translateOnAxis(ff,e)}translateY(e){return this.translateOnAxis(hf,e)}translateZ(e){return this.translateOnAxis(df,e)}localToWorld(e){return this.updateWorldMatrix(!0,!1),e.applyMatrix4(this.matrixWorld)}worldToLocal(e){return this.updateWorldMatrix(!0,!1),e.applyMatrix4(Zn.copy(this.matrixWorld).invert())}lookAt(e,t,i){e.isVector3?Ys.copy(e):Ys.set(e,t,i);const r=this.parent;this.updateWorldMatrix(!0,!1),jr.setFromMatrixPosition(this.matrixWorld),this.isCamera||this.isLight?Zn.lookAt(jr,Ys,this.up):Zn.lookAt(Ys,jr,this.up),this.quaternion.setFromRotationMatrix(Zn),r&&(Zn.extractRotation(r.matrixWorld),mr.setFromRotationMatrix(Zn),this.quaternion.premultiply(mr.invert()))}add(e){if(arguments.length>1){for(let t=0;t<arguments.length;t++)this.add(arguments[t]);return this}return e===this?(et("Object3D.add: object can't be added as a child of itself.",e),this):(e&&e.isObject3D?(e.removeFromParent(),e.parent=this,this.children.push(e),e.dispatchEvent(pf),gr.child=e,this.dispatchEvent(gr),gr.child=null):et("Object3D.add: object not an instance of THREE.Object3D.",e),this)}remove(e){if(arguments.length>1){for(let i=0;i<arguments.length;i++)this.remove(arguments[i]);return this}const t=this.children.indexOf(e);return t!==-1&&(e.parent=null,this.children.splice(t,1),e.dispatchEvent(_0),za.child=e,this.dispatchEvent(za),za.child=null),this}removeFromParent(){const e=this.parent;return e!==null&&e.remove(this),this}clear(){return this.remove(...this.children)}attach(e){return this.updateWorldMatrix(!0,!1),Zn.copy(this.matrixWorld).invert(),e.parent!==null&&(e.parent.updateWorldMatrix(!0,!1),Zn.multiply(e.parent.matrixWorld)),e.applyMatrix4(Zn),e.removeFromParent(),e.parent=this,this.children.push(e),e.updateWorldMatrix(!1,!0),e.dispatchEvent(pf),gr.child=e,this.dispatchEvent(gr),gr.child=null,this}getObjectById(e){return this.getObjectByProperty("id",e)}getObjectByName(e){return this.getObjectByProperty("name",e)}getObjectByProperty(e,t){if(this[e]===t)return this;for(let i=0,r=this.children.length;i<r;i++){const o=this.children[i].getObjectByProperty(e,t);if(o!==void 0)return o}}getObjectsByProperty(e,t,i=[]){this[e]===t&&i.push(this);const r=this.children;for(let s=0,o=r.length;s<o;s++)r[s].getObjectsByProperty(e,t,i);return i}getWorldPosition(e){return this.updateWorldMatrix(!0,!1),e.setFromMatrixPosition(this.matrixWorld)}getWorldQuaternion(e){return this.updateWorldMatrix(!0,!1),this.matrixWorld.decompose(jr,e,m0),e}getWorldScale(e){return this.updateWorldMatrix(!0,!1),this.matrixWorld.decompose(jr,g0,e),e}getWorldDirection(e){this.updateWorldMatrix(!0,!1);const t=this.matrixWorld.elements;return e.set(t[8],t[9],t[10]).normalize()}raycast(){}traverse(e){e(this);const t=this.children;for(let i=0,r=t.length;i<r;i++)t[i].traverse(e)}traverseVisible(e){if(this.visible===!1)return;e(this);const t=this.children;for(let i=0,r=t.length;i<r;i++)t[i].traverseVisible(e)}traverseAncestors(e){const t=this.parent;t!==null&&(e(t),t.traverseAncestors(e))}updateMatrix(){this.matrix.compose(this.position,this.quaternion,this.scale);const e=this.pivot;if(e!==null){const t=e.x,i=e.y,r=e.z,s=this.matrix.elements;s[12]+=t-s[0]*t-s[4]*i-s[8]*r,s[13]+=i-s[1]*t-s[5]*i-s[9]*r,s[14]+=r-s[2]*t-s[6]*i-s[10]*r}this.matrixWorldNeedsUpdate=!0}updateMatrixWorld(e){this.matrixAutoUpdate&&this.updateMatrix(),(this.matrixWorldNeedsUpdate||e)&&(this.matrixWorldAutoUpdate===!0&&(this.parent===null?this.matrixWorld.copy(this.matrix):this.matrixWorld.multiplyMatrices(this.parent.matrixWorld,this.matrix)),this.matrixWorldNeedsUpdate=!1,e=!0);const t=this.children;for(let i=0,r=t.length;i<r;i++)t[i].updateMatrixWorld(e)}updateWorldMatrix(e,t){const i=this.parent;if(e===!0&&i!==null&&i.updateWorldMatrix(!0,!1),this.matrixAutoUpdate&&this.updateMatrix(),this.matrixWorldAutoUpdate===!0&&(this.parent===null?this.matrixWorld.copy(this.matrix):this.matrixWorld.multiplyMatrices(this.parent.matrixWorld,this.matrix)),t===!0){const r=this.children;for(let s=0,o=r.length;s<o;s++)r[s].updateWorldMatrix(!1,!0)}}toJSON(e){const t=e===void 0||typeof e=="string",i={};t&&(e={geometries:{},materials:{},textures:{},images:{},shapes:{},skeletons:{},animations:{},nodes:{}},i.metadata={version:4.7,type:"Object",generator:"Object3D.toJSON"});const r={};r.uuid=this.uuid,r.type=this.type,this.name!==""&&(r.name=this.name),this.castShadow===!0&&(r.castShadow=!0),this.receiveShadow===!0&&(r.receiveShadow=!0),this.visible===!1&&(r.visible=!1),this.frustumCulled===!1&&(r.frustumCulled=!1),this.renderOrder!==0&&(r.renderOrder=this.renderOrder),this.static!==!1&&(r.static=this.static),Object.keys(this.userData).length>0&&(r.userData=this.userData),r.layers=this.layers.mask,r.matrix=this.matrix.toArray(),r.up=this.up.toArray(),this.pivot!==null&&(r.pivot=this.pivot.toArray()),this.matrixAutoUpdate===!1&&(r.matrixAutoUpdate=!1),this.morphTargetDictionary!==void 0&&(r.morphTargetDictionary=Object.assign({},this.morphTargetDictionary)),this.morphTargetInfluences!==void 0&&(r.morphTargetInfluences=this.morphTargetInfluences.slice()),this.isInstancedMesh&&(r.type="InstancedMesh",r.count=this.count,r.instanceMatrix=this.instanceMatrix.toJSON(),this.instanceColor!==null&&(r.instanceColor=this.instanceColor.toJSON())),this.isBatchedMesh&&(r.type="BatchedMesh",r.perObjectFrustumCulled=this.perObjectFrustumCulled,r.sortObjects=this.sortObjects,r.drawRanges=this._drawRanges,r.reservedRanges=this._reservedRanges,r.geometryInfo=this._geometryInfo.map(a=>({...a,boundingBox:a.boundingBox?a.boundingBox.toJSON():void 0,boundingSphere:a.boundingSphere?a.boundingSphere.toJSON():void 0})),r.instanceInfo=this._instanceInfo.map(a=>({...a})),r.availableInstanceIds=this._availableInstanceIds.slice(),r.availableGeometryIds=this._availableGeometryIds.slice(),r.nextIndexStart=this._nextIndexStart,r.nextVertexStart=this._nextVertexStart,r.geometryCount=this._geometryCount,r.maxInstanceCount=this._maxInstanceCount,r.maxVertexCount=this._maxVertexCount,r.maxIndexCount=this._maxIndexCount,r.geometryInitialized=this._geometryInitialized,r.matricesTexture=this._matricesTexture.toJSON(e),r.indirectTexture=this._indirectTexture.toJSON(e),this._colorsTexture!==null&&(r.colorsTexture=this._colorsTexture.toJSON(e)),this.boundingSphere!==null&&(r.boundingSphere=this.boundingSphere.toJSON()),this.boundingBox!==null&&(r.boundingBox=this.boundingBox.toJSON()));function s(a,l){return a[l.uuid]===void 0&&(a[l.uuid]=l.toJSON(e)),l.uuid}if(this.isScene)this.background&&(this.background.isColor?r.background=this.background.toJSON():this.background.isTexture&&(r.background=this.background.toJSON(e).uuid)),this.environment&&this.environment.isTexture&&this.environment.isRenderTargetTexture!==!0&&(r.environment=this.environment.toJSON(e).uuid);else if(this.isMesh||this.isLine||this.isPoints){r.geometry=s(e.geometries,this.geometry);const a=this.geometry.parameters;if(a!==void 0&&a.shapes!==void 0){const l=a.shapes;if(Array.isArray(l))for(let c=0,u=l.length;c<u;c++){const h=l[c];s(e.shapes,h)}else s(e.shapes,l)}}if(this.isSkinnedMesh&&(r.bindMode=this.bindMode,r.bindMatrix=this.bindMatrix.toArray(),this.skeleton!==void 0&&(s(e.skeletons,this.skeleton),r.skeleton=this.skeleton.uuid)),this.material!==void 0)if(Array.isArray(this.material)){const a=[];for(let l=0,c=this.material.length;l<c;l++)a.push(s(e.materials,this.material[l]));r.material=a}else r.material=s(e.materials,this.material);if(this.children.length>0){r.children=[];for(let a=0;a<this.children.length;a++)r.children.push(this.children[a].toJSON(e).object)}if(this.animations.length>0){r.animations=[];for(let a=0;a<this.animations.length;a++){const l=this.animations[a];r.animations.push(s(e.animations,l))}}if(t){const a=o(e.geometries),l=o(e.materials),c=o(e.textures),u=o(e.images),h=o(e.shapes),f=o(e.skeletons),p=o(e.animations),g=o(e.nodes);a.length>0&&(i.geometries=a),l.length>0&&(i.materials=l),c.length>0&&(i.textures=c),u.length>0&&(i.images=u),h.length>0&&(i.shapes=h),f.length>0&&(i.skeletons=f),p.length>0&&(i.animations=p),g.length>0&&(i.nodes=g)}return i.object=r,i;function o(a){const l=[];for(const c in a){const u=a[c];delete u.metadata,l.push(u)}return l}}clone(e){return new this.constructor().copy(this,e)}copy(e,t=!0){if(this.name=e.name,this.up.copy(e.up),this.position.copy(e.position),this.rotation.order=e.rotation.order,this.quaternion.copy(e.quaternion),this.scale.copy(e.scale),this.pivot=e.pivot!==null?e.pivot.clone():null,this.matrix.copy(e.matrix),this.matrixWorld.copy(e.matrixWorld),this.matrixAutoUpdate=e.matrixAutoUpdate,this.matrixWorldAutoUpdate=e.matrixWorldAutoUpdate,this.matrixWorldNeedsUpdate=e.matrixWorldNeedsUpdate,this.layers.mask=e.layers.mask,this.visible=e.visible,this.castShadow=e.castShadow,this.receiveShadow=e.receiveShadow,this.frustumCulled=e.frustumCulled,this.renderOrder=e.renderOrder,this.static=e.static,this.animations=e.animations.slice(),this.userData=JSON.parse(JSON.stringify(e.userData)),t===!0)for(let i=0;i<e.children.length;i++){const r=e.children[i];this.add(r.clone())}return this}}Ft.DEFAULT_UP=new N(0,1,0);Ft.DEFAULT_MATRIX_AUTO_UPDATE=!0;Ft.DEFAULT_MATRIX_WORLD_AUTO_UPDATE=!0;class qs extends Ft{constructor(){super(),this.isGroup=!0,this.type="Group"}}const x0={type:"move"};class Ha{constructor(){this._targetRay=null,this._grip=null,this._hand=null}getHandSpace(){return this._hand===null&&(this._hand=new qs,this._hand.matrixAutoUpdate=!1,this._hand.visible=!1,this._hand.joints={},this._hand.inputState={pinching:!1}),this._hand}getTargetRaySpace(){return this._targetRay===null&&(this._targetRay=new qs,this._targetRay.matrixAutoUpdate=!1,this._targetRay.visible=!1,this._targetRay.hasLinearVelocity=!1,this._targetRay.linearVelocity=new N,this._targetRay.hasAngularVelocity=!1,this._targetRay.angularVelocity=new N),this._targetRay}getGripSpace(){return this._grip===null&&(this._grip=new qs,this._grip.matrixAutoUpdate=!1,this._grip.visible=!1,this._grip.hasLinearVelocity=!1,this._grip.linearVelocity=new N,this._grip.hasAngularVelocity=!1,this._grip.angularVelocity=new N,this._grip.eventsEnabled=!1),this._grip}dispatchEvent(e){return this._targetRay!==null&&this._targetRay.dispatchEvent(e),this._grip!==null&&this._grip.dispatchEvent(e),this._hand!==null&&this._hand.dispatchEvent(e),this}connect(e){if(e&&e.hand){const t=this._hand;if(t)for(const i of e.hand.values())this._getHandJoint(t,i)}return this.dispatchEvent({type:"connected",data:e}),this}disconnect(e){return this.dispatchEvent({type:"disconnected",data:e}),this._targetRay!==null&&(this._targetRay.visible=!1),this._grip!==null&&(this._grip.visible=!1),this._hand!==null&&(this._hand.visible=!1),this}update(e,t,i){let r=null,s=null,o=null;const a=this._targetRay,l=this._grip,c=this._hand;if(e&&t.session.visibilityState!=="visible-blurred"){if(c&&e.hand){o=!0;for(const M of e.hand.values()){const m=t.getJointPose(M,i),d=this._getHandJoint(c,M);m!==null&&(d.matrix.fromArray(m.transform.matrix),d.matrix.decompose(d.position,d.rotation,d.scale),d.matrixWorldNeedsUpdate=!0,d.jointRadius=m.radius),d.visible=m!==null}const u=c.joints["index-finger-tip"],h=c.joints["thumb-tip"],f=u.position.distanceTo(h.position),p=.02,g=.005;c.inputState.pinching&&f>p+g?(c.inputState.pinching=!1,this.dispatchEvent({type:"pinchend",handedness:e.handedness,target:this})):!c.inputState.pinching&&f<=p-g&&(c.inputState.pinching=!0,this.dispatchEvent({type:"pinchstart",handedness:e.handedness,target:this}))}else l!==null&&e.gripSpace&&(s=t.getPose(e.gripSpace,i),s!==null&&(l.matrix.fromArray(s.transform.matrix),l.matrix.decompose(l.position,l.rotation,l.scale),l.matrixWorldNeedsUpdate=!0,s.linearVelocity?(l.hasLinearVelocity=!0,l.linearVelocity.copy(s.linearVelocity)):l.hasLinearVelocity=!1,s.angularVelocity?(l.hasAngularVelocity=!0,l.angularVelocity.copy(s.angularVelocity)):l.hasAngularVelocity=!1,l.eventsEnabled&&l.dispatchEvent({type:"gripUpdated",data:e,target:this})));a!==null&&(r=t.getPose(e.targetRaySpace,i),r===null&&s!==null&&(r=s),r!==null&&(a.matrix.fromArray(r.transform.matrix),a.matrix.decompose(a.position,a.rotation,a.scale),a.matrixWorldNeedsUpdate=!0,r.linearVelocity?(a.hasLinearVelocity=!0,a.linearVelocity.copy(r.linearVelocity)):a.hasLinearVelocity=!1,r.angularVelocity?(a.hasAngularVelocity=!0,a.angularVelocity.copy(r.angularVelocity)):a.hasAngularVelocity=!1,this.dispatchEvent(x0)))}return a!==null&&(a.visible=r!==null),l!==null&&(l.visible=s!==null),c!==null&&(c.visible=o!==null),this}_getHandJoint(e,t){if(e.joints[t.jointName]===void 0){const i=new qs;i.matrixAutoUpdate=!1,i.visible=!1,e.joints[t.jointName]=i,e.add(i)}return e.joints[t.jointName]}}const Kd={aliceblue:15792383,antiquewhite:16444375,aqua:65535,aquamarine:8388564,azure:15794175,beige:16119260,bisque:16770244,black:0,blanchedalmond:16772045,blue:255,blueviolet:9055202,brown:10824234,burlywood:14596231,cadetblue:6266528,chartreuse:8388352,chocolate:13789470,coral:16744272,cornflowerblue:6591981,cornsilk:16775388,crimson:14423100,cyan:65535,darkblue:139,darkcyan:35723,darkgoldenrod:12092939,darkgray:11119017,darkgreen:25600,darkgrey:11119017,darkkhaki:12433259,darkmagenta:9109643,darkolivegreen:5597999,darkorange:16747520,darkorchid:10040012,darkred:9109504,darksalmon:15308410,darkseagreen:9419919,darkslateblue:4734347,darkslategray:3100495,darkslategrey:3100495,darkturquoise:52945,darkviolet:9699539,deeppink:16716947,deepskyblue:49151,dimgray:6908265,dimgrey:6908265,dodgerblue:2003199,firebrick:11674146,floralwhite:16775920,forestgreen:2263842,fuchsia:16711935,gainsboro:14474460,ghostwhite:16316671,gold:16766720,goldenrod:14329120,gray:8421504,green:32768,greenyellow:11403055,grey:8421504,honeydew:15794160,hotpink:16738740,indianred:13458524,indigo:4915330,ivory:16777200,khaki:15787660,lavender:15132410,lavenderblush:16773365,lawngreen:8190976,lemonchiffon:16775885,lightblue:11393254,lightcoral:15761536,lightcyan:14745599,lightgoldenrodyellow:16448210,lightgray:13882323,lightgreen:9498256,lightgrey:13882323,lightpink:16758465,lightsalmon:16752762,lightseagreen:2142890,lightskyblue:8900346,lightslategray:7833753,lightslategrey:7833753,lightsteelblue:11584734,lightyellow:16777184,lime:65280,limegreen:3329330,linen:16445670,magenta:16711935,maroon:8388608,mediumaquamarine:6737322,mediumblue:205,mediumorchid:12211667,mediumpurple:9662683,mediumseagreen:3978097,mediumslateblue:8087790,mediumspringgreen:64154,mediumturquoise:4772300,mediumvioletred:13047173,midnightblue:1644912,mintcream:16121850,mistyrose:16770273,moccasin:16770229,navajowhite:16768685,navy:128,oldlace:16643558,olive:8421376,olivedrab:7048739,orange:16753920,orangered:16729344,orchid:14315734,palegoldenrod:15657130,palegreen:10025880,paleturquoise:11529966,palevioletred:14381203,papayawhip:16773077,peachpuff:16767673,peru:13468991,pink:16761035,plum:14524637,powderblue:11591910,purple:8388736,rebeccapurple:6697881,red:16711680,rosybrown:12357519,royalblue:4286945,saddlebrown:9127187,salmon:16416882,sandybrown:16032864,seagreen:3050327,seashell:16774638,sienna:10506797,silver:12632256,skyblue:8900331,slateblue:6970061,slategray:7372944,slategrey:7372944,snow:16775930,springgreen:65407,steelblue:4620980,tan:13808780,teal:32896,thistle:14204888,tomato:16737095,turquoise:4251856,violet:15631086,wheat:16113331,white:16777215,whitesmoke:16119285,yellow:16776960,yellowgreen:10145074},Mi={h:0,s:0,l:0},Ks={h:0,s:0,l:0};function Va(n,e,t){return t<0&&(t+=1),t>1&&(t-=1),t<1/6?n+(e-n)*6*t:t<1/2?e:t<2/3?n+(e-n)*6*(2/3-t):n}class lt{constructor(e,t,i){return this.isColor=!0,this.r=1,this.g=1,this.b=1,this.set(e,t,i)}set(e,t,i){if(t===void 0&&i===void 0){const r=e;r&&r.isColor?this.copy(r):typeof r=="number"?this.setHex(r):typeof r=="string"&&this.setStyle(r)}else this.setRGB(e,t,i);return this}setScalar(e){return this.r=e,this.g=e,this.b=e,this}setHex(e,t=_n){return e=Math.floor(e),this.r=(e>>16&255)/255,this.g=(e>>8&255)/255,this.b=(e&255)/255,Qe.colorSpaceToWorking(this,t),this}setRGB(e,t,i,r=Qe.workingColorSpace){return this.r=e,this.g=t,this.b=i,Qe.colorSpaceToWorking(this,r),this}setHSL(e,t,i,r=Qe.workingColorSpace){if(e=Yc(e,1),t=Je(t,0,1),i=Je(i,0,1),t===0)this.r=this.g=this.b=i;else{const s=i<=.5?i*(1+t):i+t-i*t,o=2*i-s;this.r=Va(o,s,e+1/3),this.g=Va(o,s,e),this.b=Va(o,s,e-1/3)}return Qe.colorSpaceToWorking(this,r),this}setStyle(e,t=_n){function i(s){s!==void 0&&parseFloat(s)<1&&ze("Color: Alpha component of "+e+" will be ignored.")}let r;if(r=/^(\w+)\(([^\)]*)\)/.exec(e)){let s;const o=r[1],a=r[2];switch(o){case"rgb":case"rgba":if(s=/^\s*(\d+)\s*,\s*(\d+)\s*,\s*(\d+)\s*(?:,\s*(\d*\.?\d+)\s*)?$/.exec(a))return i(s[4]),this.setRGB(Math.min(255,parseInt(s[1],10))/255,Math.min(255,parseInt(s[2],10))/255,Math.min(255,parseInt(s[3],10))/255,t);if(s=/^\s*(\d+)\%\s*,\s*(\d+)\%\s*,\s*(\d+)\%\s*(?:,\s*(\d*\.?\d+)\s*)?$/.exec(a))return i(s[4]),this.setRGB(Math.min(100,parseInt(s[1],10))/100,Math.min(100,parseInt(s[2],10))/100,Math.min(100,parseInt(s[3],10))/100,t);break;case"hsl":case"hsla":if(s=/^\s*(\d*\.?\d+)\s*,\s*(\d*\.?\d+)\%\s*,\s*(\d*\.?\d+)\%\s*(?:,\s*(\d*\.?\d+)\s*)?$/.exec(a))return i(s[4]),this.setHSL(parseFloat(s[1])/360,parseFloat(s[2])/100,parseFloat(s[3])/100,t);break;default:ze("Color: Unknown color model "+e)}}else if(r=/^\#([A-Fa-f\d]+)$/.exec(e)){const s=r[1],o=s.length;if(o===3)return this.setRGB(parseInt(s.charAt(0),16)/15,parseInt(s.charAt(1),16)/15,parseInt(s.charAt(2),16)/15,t);if(o===6)return this.setHex(parseInt(s,16),t);ze("Color: Invalid hex color "+e)}else if(e&&e.length>0)return this.setColorName(e,t);return this}setColorName(e,t=_n){const i=Kd[e.toLowerCase()];return i!==void 0?this.setHex(i,t):ze("Color: Unknown color "+e),this}clone(){return new this.constructor(this.r,this.g,this.b)}copy(e){return this.r=e.r,this.g=e.g,this.b=e.b,this}copySRGBToLinear(e){return this.r=ai(e.r),this.g=ai(e.g),this.b=ai(e.b),this}copyLinearToSRGB(e){return this.r=Nr(e.r),this.g=Nr(e.g),this.b=Nr(e.b),this}convertSRGBToLinear(){return this.copySRGBToLinear(this),this}convertLinearToSRGB(){return this.copyLinearToSRGB(this),this}getHex(e=_n){return Qe.workingToColorSpace(Gt.copy(this),e),Math.round(Je(Gt.r*255,0,255))*65536+Math.round(Je(Gt.g*255,0,255))*256+Math.round(Je(Gt.b*255,0,255))}getHexString(e=_n){return("000000"+this.getHex(e).toString(16)).slice(-6)}getHSL(e,t=Qe.workingColorSpace){Qe.workingToColorSpace(Gt.copy(this),t);const i=Gt.r,r=Gt.g,s=Gt.b,o=Math.max(i,r,s),a=Math.min(i,r,s);let l,c;const u=(a+o)/2;if(a===o)l=0,c=0;else{const h=o-a;switch(c=u<=.5?h/(o+a):h/(2-o-a),o){case i:l=(r-s)/h+(r<s?6:0);break;case r:l=(s-i)/h+2;break;case s:l=(i-r)/h+4;break}l/=6}return e.h=l,e.s=c,e.l=u,e}getRGB(e,t=Qe.workingColorSpace){return Qe.workingToColorSpace(Gt.copy(this),t),e.r=Gt.r,e.g=Gt.g,e.b=Gt.b,e}getStyle(e=_n){Qe.workingToColorSpace(Gt.copy(this),e);const t=Gt.r,i=Gt.g,r=Gt.b;return e!==_n?`color(${e} ${t.toFixed(3)} ${i.toFixed(3)} ${r.toFixed(3)})`:`rgb(${Math.round(t*255)},${Math.round(i*255)},${Math.round(r*255)})`}offsetHSL(e,t,i){return this.getHSL(Mi),this.setHSL(Mi.h+e,Mi.s+t,Mi.l+i)}add(e){return this.r+=e.r,this.g+=e.g,this.b+=e.b,this}addColors(e,t){return this.r=e.r+t.r,this.g=e.g+t.g,this.b=e.b+t.b,this}addScalar(e){return this.r+=e,this.g+=e,this.b+=e,this}sub(e){return this.r=Math.max(0,this.r-e.r),this.g=Math.max(0,this.g-e.g),this.b=Math.max(0,this.b-e.b),this}multiply(e){return this.r*=e.r,this.g*=e.g,this.b*=e.b,this}multiplyScalar(e){return this.r*=e,this.g*=e,this.b*=e,this}lerp(e,t){return this.r+=(e.r-this.r)*t,this.g+=(e.g-this.g)*t,this.b+=(e.b-this.b)*t,this}lerpColors(e,t,i){return this.r=e.r+(t.r-e.r)*i,this.g=e.g+(t.g-e.g)*i,this.b=e.b+(t.b-e.b)*i,this}lerpHSL(e,t){this.getHSL(Mi),e.getHSL(Ks);const i=xs(Mi.h,Ks.h,t),r=xs(Mi.s,Ks.s,t),s=xs(Mi.l,Ks.l,t);return this.setHSL(i,r,s),this}setFromVector3(e){return this.r=e.x,this.g=e.y,this.b=e.z,this}applyMatrix3(e){const t=this.r,i=this.g,r=this.b,s=e.elements;return this.r=s[0]*t+s[3]*i+s[6]*r,this.g=s[1]*t+s[4]*i+s[7]*r,this.b=s[2]*t+s[5]*i+s[8]*r,this}equals(e){return e.r===this.r&&e.g===this.g&&e.b===this.b}fromArray(e,t=0){return this.r=e[t],this.g=e[t+1],this.b=e[t+2],this}toArray(e=[],t=0){return e[t]=this.r,e[t+1]=this.g,e[t+2]=this.b,e}fromBufferAttribute(e,t){return this.r=e.getX(t),this.g=e.getY(t),this.b=e.getZ(t),this}toJSON(){return this.getHex()}*[Symbol.iterator](){yield this.r,yield this.g,yield this.b}}const Gt=new lt;lt.NAMES=Kd;class Sy extends Ft{constructor(){super(),this.isScene=!0,this.type="Scene",this.background=null,this.environment=null,this.fog=null,this.backgroundBlurriness=0,this.backgroundIntensity=1,this.backgroundRotation=new Ui,this.environmentIntensity=1,this.environmentRotation=new Ui,this.overrideMaterial=null,typeof __THREE_DEVTOOLS__<"u"&&__THREE_DEVTOOLS__.dispatchEvent(new CustomEvent("observe",{detail:this}))}copy(e,t){return super.copy(e,t),e.background!==null&&(this.background=e.background.clone()),e.environment!==null&&(this.environment=e.environment.clone()),e.fog!==null&&(this.fog=e.fog.clone()),this.backgroundBlurriness=e.backgroundBlurriness,this.backgroundIntensity=e.backgroundIntensity,this.backgroundRotation.copy(e.backgroundRotation),this.environmentIntensity=e.environmentIntensity,this.environmentRotation.copy(e.environmentRotation),e.overrideMaterial!==null&&(this.overrideMaterial=e.overrideMaterial.clone()),this.matrixAutoUpdate=e.matrixAutoUpdate,this}toJSON(e){const t=super.toJSON(e);return this.fog!==null&&(t.object.fog=this.fog.toJSON()),this.backgroundBlurriness>0&&(t.object.backgroundBlurriness=this.backgroundBlurriness),this.backgroundIntensity!==1&&(t.object.backgroundIntensity=this.backgroundIntensity),t.object.backgroundRotation=this.backgroundRotation.toArray(),this.environmentIntensity!==1&&(t.object.environmentIntensity=this.environmentIntensity),t.object.environmentRotation=this.environmentRotation.toArray(),t}}const Sn=new N,$n=new N,Ga=new N,Jn=new N,_r=new N,xr=new N,mf=new N,ka=new N,Wa=new N,Xa=new N,Ya=new At,qa=new At,Ka=new At;class bn{constructor(e=new N,t=new N,i=new N){this.a=e,this.b=t,this.c=i}static getNormal(e,t,i,r){r.subVectors(i,t),Sn.subVectors(e,t),r.cross(Sn);const s=r.lengthSq();return s>0?r.multiplyScalar(1/Math.sqrt(s)):r.set(0,0,0)}static getBarycoord(e,t,i,r,s){Sn.subVectors(r,t),$n.subVectors(i,t),Ga.subVectors(e,t);const o=Sn.dot(Sn),a=Sn.dot($n),l=Sn.dot(Ga),c=$n.dot($n),u=$n.dot(Ga),h=o*c-a*a;if(h===0)return s.set(0,0,0),null;const f=1/h,p=(c*l-a*u)*f,g=(o*u-a*l)*f;return s.set(1-p-g,g,p)}static containsPoint(e,t,i,r){return this.getBarycoord(e,t,i,r,Jn)===null?!1:Jn.x>=0&&Jn.y>=0&&Jn.x+Jn.y<=1}static getInterpolation(e,t,i,r,s,o,a,l){return this.getBarycoord(e,t,i,r,Jn)===null?(l.x=0,l.y=0,"z"in l&&(l.z=0),"w"in l&&(l.w=0),null):(l.setScalar(0),l.addScaledVector(s,Jn.x),l.addScaledVector(o,Jn.y),l.addScaledVector(a,Jn.z),l)}static getInterpolatedAttribute(e,t,i,r,s,o){return Ya.setScalar(0),qa.setScalar(0),Ka.setScalar(0),Ya.fromBufferAttribute(e,t),qa.fromBufferAttribute(e,i),Ka.fromBufferAttribute(e,r),o.setScalar(0),o.addScaledVector(Ya,s.x),o.addScaledVector(qa,s.y),o.addScaledVector(Ka,s.z),o}static isFrontFacing(e,t,i,r){return Sn.subVectors(i,t),$n.subVectors(e,t),Sn.cross($n).dot(r)<0}set(e,t,i){return this.a.copy(e),this.b.copy(t),this.c.copy(i),this}setFromPointsAndIndices(e,t,i,r){return this.a.copy(e[t]),this.b.copy(e[i]),this.c.copy(e[r]),this}setFromAttributeAndIndices(e,t,i,r){return this.a.fromBufferAttribute(e,t),this.b.fromBufferAttribute(e,i),this.c.fromBufferAttribute(e,r),this}clone(){return new this.constructor().copy(this)}copy(e){return this.a.copy(e.a),this.b.copy(e.b),this.c.copy(e.c),this}getArea(){return Sn.subVectors(this.c,this.b),$n.subVectors(this.a,this.b),Sn.cross($n).length()*.5}getMidpoint(e){return e.addVectors(this.a,this.b).add(this.c).multiplyScalar(1/3)}getNormal(e){return bn.getNormal(this.a,this.b,this.c,e)}getPlane(e){return e.setFromCoplanarPoints(this.a,this.b,this.c)}getBarycoord(e,t){return bn.getBarycoord(e,this.a,this.b,this.c,t)}getInterpolation(e,t,i,r,s){return bn.getInterpolation(e,this.a,this.b,this.c,t,i,r,s)}containsPoint(e){return bn.containsPoint(e,this.a,this.b,this.c)}isFrontFacing(e){return bn.isFrontFacing(this.a,this.b,this.c,e)}intersectsBox(e){return e.intersectsTriangle(this)}closestPointToPoint(e,t){const i=this.a,r=this.b,s=this.c;let o,a;_r.subVectors(r,i),xr.subVectors(s,i),ka.subVectors(e,i);const l=_r.dot(ka),c=xr.dot(ka);if(l<=0&&c<=0)return t.copy(i);Wa.subVectors(e,r);const u=_r.dot(Wa),h=xr.dot(Wa);if(u>=0&&h<=u)return t.copy(r);const f=l*h-u*c;if(f<=0&&l>=0&&u<=0)return o=l/(l-u),t.copy(i).addScaledVector(_r,o);Xa.subVectors(e,s);const p=_r.dot(Xa),g=xr.dot(Xa);if(g>=0&&p<=g)return t.copy(s);const M=p*c-l*g;if(M<=0&&c>=0&&g<=0)return a=c/(c-g),t.copy(i).addScaledVector(xr,a);const m=u*g-p*h;if(m<=0&&h-u>=0&&p-g>=0)return mf.subVectors(s,r),a=(h-u)/(h-u+(p-g)),t.copy(r).addScaledVector(mf,a);const d=1/(m+M+f);return o=M*d,a=f*d,t.copy(i).addScaledVector(_r,o).addScaledVector(xr,a)}equals(e){return e.a.equals(this.a)&&e.b.equals(this.b)&&e.c.equals(this.c)}}class Us{constructor(e=new N(1/0,1/0,1/0),t=new N(-1/0,-1/0,-1/0)){this.isBox3=!0,this.min=e,this.max=t}set(e,t){return this.min.copy(e),this.max.copy(t),this}setFromArray(e){this.makeEmpty();for(let t=0,i=e.length;t<i;t+=3)this.expandByPoint(En.fromArray(e,t));return this}setFromBufferAttribute(e){this.makeEmpty();for(let t=0,i=e.count;t<i;t++)this.expandByPoint(En.fromBufferAttribute(e,t));return this}setFromPoints(e){this.makeEmpty();for(let t=0,i=e.length;t<i;t++)this.expandByPoint(e[t]);return this}setFromCenterAndSize(e,t){const i=En.copy(t).multiplyScalar(.5);return this.min.copy(e).sub(i),this.max.copy(e).add(i),this}setFromObject(e,t=!1){return this.makeEmpty(),this.expandByObject(e,t)}clone(){return new this.constructor().copy(this)}copy(e){return this.min.copy(e.min),this.max.copy(e.max),this}makeEmpty(){return this.min.x=this.min.y=this.min.z=1/0,this.max.x=this.max.y=this.max.z=-1/0,this}isEmpty(){return this.max.x<this.min.x||this.max.y<this.min.y||this.max.z<this.min.z}getCenter(e){return this.isEmpty()?e.set(0,0,0):e.addVectors(this.min,this.max).multiplyScalar(.5)}getSize(e){return this.isEmpty()?e.set(0,0,0):e.subVectors(this.max,this.min)}expandByPoint(e){return this.min.min(e),this.max.max(e),this}expandByVector(e){return this.min.sub(e),this.max.add(e),this}expandByScalar(e){return this.min.addScalar(-e),this.max.addScalar(e),this}expandByObject(e,t=!1){e.updateWorldMatrix(!1,!1);const i=e.geometry;if(i!==void 0){const s=i.getAttribute("position");if(t===!0&&s!==void 0&&e.isInstancedMesh!==!0)for(let o=0,a=s.count;o<a;o++)e.isMesh===!0?e.getVertexPosition(o,En):En.fromBufferAttribute(s,o),En.applyMatrix4(e.matrixWorld),this.expandByPoint(En);else e.boundingBox!==void 0?(e.boundingBox===null&&e.computeBoundingBox(),js.copy(e.boundingBox)):(i.boundingBox===null&&i.computeBoundingBox(),js.copy(i.boundingBox)),js.applyMatrix4(e.matrixWorld),this.union(js)}const r=e.children;for(let s=0,o=r.length;s<o;s++)this.expandByObject(r[s],t);return this}containsPoint(e){return e.x>=this.min.x&&e.x<=this.max.x&&e.y>=this.min.y&&e.y<=this.max.y&&e.z>=this.min.z&&e.z<=this.max.z}containsBox(e){return this.min.x<=e.min.x&&e.max.x<=this.max.x&&this.min.y<=e.min.y&&e.max.y<=this.max.y&&this.min.z<=e.min.z&&e.max.z<=this.max.z}getParameter(e,t){return t.set((e.x-this.min.x)/(this.max.x-this.min.x),(e.y-this.min.y)/(this.max.y-this.min.y),(e.z-this.min.z)/(this.max.z-this.min.z))}intersectsBox(e){return e.max.x>=this.min.x&&e.min.x<=this.max.x&&e.max.y>=this.min.y&&e.min.y<=this.max.y&&e.max.z>=this.min.z&&e.min.z<=this.max.z}intersectsSphere(e){return this.clampPoint(e.center,En),En.distanceToSquared(e.center)<=e.radius*e.radius}intersectsPlane(e){let t,i;return e.normal.x>0?(t=e.normal.x*this.min.x,i=e.normal.x*this.max.x):(t=e.normal.x*this.max.x,i=e.normal.x*this.min.x),e.normal.y>0?(t+=e.normal.y*this.min.y,i+=e.normal.y*this.max.y):(t+=e.normal.y*this.max.y,i+=e.normal.y*this.min.y),e.normal.z>0?(t+=e.normal.z*this.min.z,i+=e.normal.z*this.max.z):(t+=e.normal.z*this.max.z,i+=e.normal.z*this.min.z),t<=-e.constant&&i>=-e.constant}intersectsTriangle(e){if(this.isEmpty())return!1;this.getCenter(Zr),Zs.subVectors(this.max,Zr),vr.subVectors(e.a,Zr),Mr.subVectors(e.b,Zr),Sr.subVectors(e.c,Zr),Si.subVectors(Mr,vr),Ei.subVectors(Sr,Mr),Hi.subVectors(vr,Sr);let t=[0,-Si.z,Si.y,0,-Ei.z,Ei.y,0,-Hi.z,Hi.y,Si.z,0,-Si.x,Ei.z,0,-Ei.x,Hi.z,0,-Hi.x,-Si.y,Si.x,0,-Ei.y,Ei.x,0,-Hi.y,Hi.x,0];return!ja(t,vr,Mr,Sr,Zs)||(t=[1,0,0,0,1,0,0,0,1],!ja(t,vr,Mr,Sr,Zs))?!1:($s.crossVectors(Si,Ei),t=[$s.x,$s.y,$s.z],ja(t,vr,Mr,Sr,Zs))}clampPoint(e,t){return t.copy(e).clamp(this.min,this.max)}distanceToPoint(e){return this.clampPoint(e,En).distanceTo(e)}getBoundingSphere(e){return this.isEmpty()?e.makeEmpty():(this.getCenter(e.center),e.radius=this.getSize(En).length()*.5),e}intersect(e){return this.min.max(e.min),this.max.min(e.max),this.isEmpty()&&this.makeEmpty(),this}union(e){return this.min.min(e.min),this.max.max(e.max),this}applyMatrix4(e){return this.isEmpty()?this:(Qn[0].set(this.min.x,this.min.y,this.min.z).applyMatrix4(e),Qn[1].set(this.min.x,this.min.y,this.max.z).applyMatrix4(e),Qn[2].set(this.min.x,this.max.y,this.min.z).applyMatrix4(e),Qn[3].set(this.min.x,this.max.y,this.max.z).applyMatrix4(e),Qn[4].set(this.max.x,this.min.y,this.min.z).applyMatrix4(e),Qn[5].set(this.max.x,this.min.y,this.max.z).applyMatrix4(e),Qn[6].set(this.max.x,this.max.y,this.min.z).applyMatrix4(e),Qn[7].set(this.max.x,this.max.y,this.max.z).applyMatrix4(e),this.setFromPoints(Qn),this)}translate(e){return this.min.add(e),this.max.add(e),this}equals(e){return e.min.equals(this.min)&&e.max.equals(this.max)}toJSON(){return{min:this.min.toArray(),max:this.max.toArray()}}fromJSON(e){return this.min.fromArray(e.min),this.max.fromArray(e.max),this}}const Qn=[new N,new N,new N,new N,new N,new N,new N,new N],En=new N,js=new Us,vr=new N,Mr=new N,Sr=new N,Si=new N,Ei=new N,Hi=new N,Zr=new N,Zs=new N,$s=new N,Vi=new N;function ja(n,e,t,i,r){for(let s=0,o=n.length-3;s<=o;s+=3){Vi.fromArray(n,s);const a=r.x*Math.abs(Vi.x)+r.y*Math.abs(Vi.y)+r.z*Math.abs(Vi.z),l=e.dot(Vi),c=t.dot(Vi),u=i.dot(Vi);if(Math.max(-Math.max(l,c,u),Math.min(l,c,u))>a)return!1}return!0}const Rt=new N,Js=new st;let v0=0;class Xn extends Ni{constructor(e,t,i=!1){if(super(),Array.isArray(e))throw new TypeError("THREE.BufferAttribute: array should be a Typed Array.");this.isBufferAttribute=!0,Object.defineProperty(this,"id",{value:v0++}),this.name="",this.array=e,this.itemSize=t,this.count=e!==void 0?e.length/t:0,this.normalized=i,this.usage=Qu,this.updateRanges=[],this.gpuType=Hn,this.version=0}onUploadCallback(){}set needsUpdate(e){e===!0&&this.version++}setUsage(e){return this.usage=e,this}addUpdateRange(e,t){this.updateRanges.push({start:e,count:t})}clearUpdateRanges(){this.updateRanges.length=0}copy(e){return this.name=e.name,this.array=new e.array.constructor(e.array),this.itemSize=e.itemSize,this.count=e.count,this.normalized=e.normalized,this.usage=e.usage,this.gpuType=e.gpuType,this}copyAt(e,t,i){e*=this.itemSize,i*=t.itemSize;for(let r=0,s=this.itemSize;r<s;r++)this.array[e+r]=t.array[i+r];return this}copyArray(e){return this.array.set(e),this}applyMatrix3(e){if(this.itemSize===2)for(let t=0,i=this.count;t<i;t++)Js.fromBufferAttribute(this,t),Js.applyMatrix3(e),this.setXY(t,Js.x,Js.y);else if(this.itemSize===3)for(let t=0,i=this.count;t<i;t++)Rt.fromBufferAttribute(this,t),Rt.applyMatrix3(e),this.setXYZ(t,Rt.x,Rt.y,Rt.z);return this}applyMatrix4(e){for(let t=0,i=this.count;t<i;t++)Rt.fromBufferAttribute(this,t),Rt.applyMatrix4(e),this.setXYZ(t,Rt.x,Rt.y,Rt.z);return this}applyNormalMatrix(e){for(let t=0,i=this.count;t<i;t++)Rt.fromBufferAttribute(this,t),Rt.applyNormalMatrix(e),this.setXYZ(t,Rt.x,Rt.y,Rt.z);return this}transformDirection(e){for(let t=0,i=this.count;t<i;t++)Rt.fromBufferAttribute(this,t),Rt.transformDirection(e),this.setXYZ(t,Rt.x,Rt.y,Rt.z);return this}set(e,t=0){return this.array.set(e,t),this}getComponent(e,t){let i=this.array[e*this.itemSize+t];return this.normalized&&(i=wr(i,this.array)),i}setComponent(e,t,i){return this.normalized&&(i=Qt(i,this.array)),this.array[e*this.itemSize+t]=i,this}getX(e){let t=this.array[e*this.itemSize];return this.normalized&&(t=wr(t,this.array)),t}setX(e,t){return this.normalized&&(t=Qt(t,this.array)),this.array[e*this.itemSize]=t,this}getY(e){let t=this.array[e*this.itemSize+1];return this.normalized&&(t=wr(t,this.array)),t}setY(e,t){return this.normalized&&(t=Qt(t,this.array)),this.array[e*this.itemSize+1]=t,this}getZ(e){let t=this.array[e*this.itemSize+2];return this.normalized&&(t=wr(t,this.array)),t}setZ(e,t){return this.normalized&&(t=Qt(t,this.array)),this.array[e*this.itemSize+2]=t,this}getW(e){let t=this.array[e*this.itemSize+3];return this.normalized&&(t=wr(t,this.array)),t}setW(e,t){return this.normalized&&(t=Qt(t,this.array)),this.array[e*this.itemSize+3]=t,this}setXY(e,t,i){return e*=this.itemSize,this.normalized&&(t=Qt(t,this.array),i=Qt(i,this.array)),this.array[e+0]=t,this.array[e+1]=i,this}setXYZ(e,t,i,r){return e*=this.itemSize,this.normalized&&(t=Qt(t,this.array),i=Qt(i,this.array),r=Qt(r,this.array)),this.array[e+0]=t,this.array[e+1]=i,this.array[e+2]=r,this}setXYZW(e,t,i,r,s){return e*=this.itemSize,this.normalized&&(t=Qt(t,this.array),i=Qt(i,this.array),r=Qt(r,this.array),s=Qt(s,this.array)),this.array[e+0]=t,this.array[e+1]=i,this.array[e+2]=r,this.array[e+3]=s,this}onUpload(e){return this.onUploadCallback=e,this}clone(){return new this.constructor(this.array,this.itemSize).copy(this)}toJSON(){const e={itemSize:this.itemSize,type:this.array.constructor.name,array:Array.from(this.array),normalized:this.normalized};return this.name!==""&&(e.name=this.name),this.usage!==Qu&&(e.usage=this.usage),e}dispose(){this.dispatchEvent({type:"dispose"})}}class jd extends Xn{constructor(e,t,i){super(new Uint16Array(e),t,i)}}class Zd extends Xn{constructor(e,t,i){super(new Uint32Array(e),t,i)}}class St extends Xn{constructor(e,t,i){super(new Float32Array(e),t,i)}}const M0=new Us,$r=new N,Za=new N;class pa{constructor(e=new N,t=-1){this.isSphere=!0,this.center=e,this.radius=t}set(e,t){return this.center.copy(e),this.radius=t,this}setFromPoints(e,t){const i=this.center;t!==void 0?i.copy(t):M0.setFromPoints(e).getCenter(i);let r=0;for(let s=0,o=e.length;s<o;s++)r=Math.max(r,i.distanceToSquared(e[s]));return this.radius=Math.sqrt(r),this}copy(e){return this.center.copy(e.center),this.radius=e.radius,this}isEmpty(){return this.radius<0}makeEmpty(){return this.center.set(0,0,0),this.radius=-1,this}containsPoint(e){return e.distanceToSquared(this.center)<=this.radius*this.radius}distanceToPoint(e){return e.distanceTo(this.center)-this.radius}intersectsSphere(e){const t=this.radius+e.radius;return e.center.distanceToSquared(this.center)<=t*t}intersectsBox(e){return e.intersectsSphere(this)}intersectsPlane(e){return Math.abs(e.distanceToPoint(this.center))<=this.radius}clampPoint(e,t){const i=this.center.distanceToSquared(e);return t.copy(e),i>this.radius*this.radius&&(t.sub(this.center).normalize(),t.multiplyScalar(this.radius).add(this.center)),t}getBoundingBox(e){return this.isEmpty()?(e.makeEmpty(),e):(e.set(this.center,this.center),e.expandByScalar(this.radius),e)}applyMatrix4(e){return this.center.applyMatrix4(e),this.radius=this.radius*e.getMaxScaleOnAxis(),this}translate(e){return this.center.add(e),this}expandByPoint(e){if(this.isEmpty())return this.center.copy(e),this.radius=0,this;$r.subVectors(e,this.center);const t=$r.lengthSq();if(t>this.radius*this.radius){const i=Math.sqrt(t),r=(i-this.radius)*.5;this.center.addScaledVector($r,r/i),this.radius+=r}return this}union(e){return e.isEmpty()?this:this.isEmpty()?(this.copy(e),this):(this.center.equals(e.center)===!0?this.radius=Math.max(this.radius,e.radius):(Za.subVectors(e.center,this.center).setLength(e.radius),this.expandByPoint($r.copy(e.center).add(Za)),this.expandByPoint($r.copy(e.center).sub(Za))),this)}equals(e){return e.center.equals(this.center)&&e.radius===this.radius}clone(){return new this.constructor().copy(this)}toJSON(){return{radius:this.radius,center:this.center.toArray()}}fromJSON(e){return this.radius=e.radius,this.center.fromArray(e.center),this}}let S0=0;const mn=new Mt,$a=new Ft,Er=new N,cn=new Us,Jr=new Us,Ut=new N;class $t extends Ni{constructor(){super(),this.isBufferGeometry=!0,Object.defineProperty(this,"id",{value:S0++}),this.uuid=kr(),this.name="",this.type="BufferGeometry",this.index=null,this.indirect=null,this.indirectOffset=0,this.attributes={},this.morphAttributes={},this.morphTargetsRelative=!1,this.groups=[],this.boundingBox=null,this.boundingSphere=null,this.drawRange={start:0,count:1/0},this.userData={}}getIndex(){return this.index}setIndex(e){return Array.isArray(e)?this.index=new(H_(e)?Zd:jd)(e,1):this.index=e,this}setIndirect(e,t=0){return this.indirect=e,this.indirectOffset=t,this}getIndirect(){return this.indirect}getAttribute(e){return this.attributes[e]}setAttribute(e,t){return this.attributes[e]=t,this}deleteAttribute(e){return delete this.attributes[e],this}hasAttribute(e){return this.attributes[e]!==void 0}addGroup(e,t,i=0){this.groups.push({start:e,count:t,materialIndex:i})}clearGroups(){this.groups=[]}setDrawRange(e,t){this.drawRange.start=e,this.drawRange.count=t}applyMatrix4(e){const t=this.attributes.position;t!==void 0&&(t.applyMatrix4(e),t.needsUpdate=!0);const i=this.attributes.normal;if(i!==void 0){const s=new Xe().getNormalMatrix(e);i.applyNormalMatrix(s),i.needsUpdate=!0}const r=this.attributes.tangent;return r!==void 0&&(r.transformDirection(e),r.needsUpdate=!0),this.boundingBox!==null&&this.computeBoundingBox(),this.boundingSphere!==null&&this.computeBoundingSphere(),this}applyQuaternion(e){return mn.makeRotationFromQuaternion(e),this.applyMatrix4(mn),this}rotateX(e){return mn.makeRotationX(e),this.applyMatrix4(mn),this}rotateY(e){return mn.makeRotationY(e),this.applyMatrix4(mn),this}rotateZ(e){return mn.makeRotationZ(e),this.applyMatrix4(mn),this}translate(e,t,i){return mn.makeTranslation(e,t,i),this.applyMatrix4(mn),this}scale(e,t,i){return mn.makeScale(e,t,i),this.applyMatrix4(mn),this}lookAt(e){return $a.lookAt(e),$a.updateMatrix(),this.applyMatrix4($a.matrix),this}center(){return this.computeBoundingBox(),this.boundingBox.getCenter(Er).negate(),this.translate(Er.x,Er.y,Er.z),this}setFromPoints(e){const t=this.getAttribute("position");if(t===void 0){const i=[];for(let r=0,s=e.length;r<s;r++){const o=e[r];i.push(o.x,o.y,o.z||0)}this.setAttribute("position",new St(i,3))}else{const i=Math.min(e.length,t.count);for(let r=0;r<i;r++){const s=e[r];t.setXYZ(r,s.x,s.y,s.z||0)}e.length>t.count&&ze("BufferGeometry: Buffer size too small for points data. Use .dispose() and create a new geometry."),t.needsUpdate=!0}return this}computeBoundingBox(){this.boundingBox===null&&(this.boundingBox=new Us);const e=this.attributes.position,t=this.morphAttributes.position;if(e&&e.isGLBufferAttribute){et("BufferGeometry.computeBoundingBox(): GLBufferAttribute requires a manual bounding box.",this),this.boundingBox.set(new N(-1/0,-1/0,-1/0),new N(1/0,1/0,1/0));return}if(e!==void 0){if(this.boundingBox.setFromBufferAttribute(e),t)for(let i=0,r=t.length;i<r;i++){const s=t[i];cn.setFromBufferAttribute(s),this.morphTargetsRelative?(Ut.addVectors(this.boundingBox.min,cn.min),this.boundingBox.expandByPoint(Ut),Ut.addVectors(this.boundingBox.max,cn.max),this.boundingBox.expandByPoint(Ut)):(this.boundingBox.expandByPoint(cn.min),this.boundingBox.expandByPoint(cn.max))}}else this.boundingBox.makeEmpty();(isNaN(this.boundingBox.min.x)||isNaN(this.boundingBox.min.y)||isNaN(this.boundingBox.min.z))&&et('BufferGeometry.computeBoundingBox(): Computed min/max have NaN values. The "position" attribute is likely to have NaN values.',this)}computeBoundingSphere(){this.boundingSphere===null&&(this.boundingSphere=new pa);const e=this.attributes.position,t=this.morphAttributes.position;if(e&&e.isGLBufferAttribute){et("BufferGeometry.computeBoundingSphere(): GLBufferAttribute requires a manual bounding sphere.",this),this.boundingSphere.set(new N,1/0);return}if(e){const i=this.boundingSphere.center;if(cn.setFromBufferAttribute(e),t)for(let s=0,o=t.length;s<o;s++){const a=t[s];Jr.setFromBufferAttribute(a),this.morphTargetsRelative?(Ut.addVectors(cn.min,Jr.min),cn.expandByPoint(Ut),Ut.addVectors(cn.max,Jr.max),cn.expandByPoint(Ut)):(cn.expandByPoint(Jr.min),cn.expandByPoint(Jr.max))}cn.getCenter(i);let r=0;for(let s=0,o=e.count;s<o;s++)Ut.fromBufferAttribute(e,s),r=Math.max(r,i.distanceToSquared(Ut));if(t)for(let s=0,o=t.length;s<o;s++){const a=t[s],l=this.morphTargetsRelative;for(let c=0,u=a.count;c<u;c++)Ut.fromBufferAttribute(a,c),l&&(Er.fromBufferAttribute(e,c),Ut.add(Er)),r=Math.max(r,i.distanceToSquared(Ut))}this.boundingSphere.radius=Math.sqrt(r),isNaN(this.boundingSphere.radius)&&et('BufferGeometry.computeBoundingSphere(): Computed radius is NaN. The "position" attribute is likely to have NaN values.',this)}}computeTangents(){const e=this.index,t=this.attributes;if(e===null||t.position===void 0||t.normal===void 0||t.uv===void 0){et("BufferGeometry: .computeTangents() failed. Missing required attributes (index, position, normal or uv)");return}const i=t.position,r=t.normal,s=t.uv;this.hasAttribute("tangent")===!1&&this.setAttribute("tangent",new Xn(new Float32Array(4*i.count),4));const o=this.getAttribute("tangent"),a=[],l=[];for(let v=0;v<i.count;v++)a[v]=new N,l[v]=new N;const c=new N,u=new N,h=new N,f=new st,p=new st,g=new st,M=new N,m=new N;function d(v,T,L){c.fromBufferAttribute(i,v),u.fromBufferAttribute(i,T),h.fromBufferAttribute(i,L),f.fromBufferAttribute(s,v),p.fromBufferAttribute(s,T),g.fromBufferAttribute(s,L),u.sub(c),h.sub(c),p.sub(f),g.sub(f);const D=1/(p.x*g.y-g.x*p.y);isFinite(D)&&(M.copy(u).multiplyScalar(g.y).addScaledVector(h,-p.y).multiplyScalar(D),m.copy(h).multiplyScalar(p.x).addScaledVector(u,-g.x).multiplyScalar(D),a[v].add(M),a[T].add(M),a[L].add(M),l[v].add(m),l[T].add(m),l[L].add(m))}let x=this.groups;x.length===0&&(x=[{start:0,count:e.count}]);for(let v=0,T=x.length;v<T;++v){const L=x[v],D=L.start,I=L.count;for(let k=D,G=D+I;k<G;k+=3)d(e.getX(k+0),e.getX(k+1),e.getX(k+2))}const y=new N,S=new N,C=new N,A=new N;function P(v){C.fromBufferAttribute(r,v),A.copy(C);const T=a[v];y.copy(T),y.sub(C.multiplyScalar(C.dot(T))).normalize(),S.crossVectors(A,T);const D=S.dot(l[v])<0?-1:1;o.setXYZW(v,y.x,y.y,y.z,D)}for(let v=0,T=x.length;v<T;++v){const L=x[v],D=L.start,I=L.count;for(let k=D,G=D+I;k<G;k+=3)P(e.getX(k+0)),P(e.getX(k+1)),P(e.getX(k+2))}}computeVertexNormals(){const e=this.index,t=this.getAttribute("position");if(t!==void 0){let i=this.getAttribute("normal");if(i===void 0)i=new Xn(new Float32Array(t.count*3),3),this.setAttribute("normal",i);else for(let f=0,p=i.count;f<p;f++)i.setXYZ(f,0,0,0);const r=new N,s=new N,o=new N,a=new N,l=new N,c=new N,u=new N,h=new N;if(e)for(let f=0,p=e.count;f<p;f+=3){const g=e.getX(f+0),M=e.getX(f+1),m=e.getX(f+2);r.fromBufferAttribute(t,g),s.fromBufferAttribute(t,M),o.fromBufferAttribute(t,m),u.subVectors(o,s),h.subVectors(r,s),u.cross(h),a.fromBufferAttribute(i,g),l.fromBufferAttribute(i,M),c.fromBufferAttribute(i,m),a.add(u),l.add(u),c.add(u),i.setXYZ(g,a.x,a.y,a.z),i.setXYZ(M,l.x,l.y,l.z),i.setXYZ(m,c.x,c.y,c.z)}else for(let f=0,p=t.count;f<p;f+=3)r.fromBufferAttribute(t,f+0),s.fromBufferAttribute(t,f+1),o.fromBufferAttribute(t,f+2),u.subVectors(o,s),h.subVectors(r,s),u.cross(h),i.setXYZ(f+0,u.x,u.y,u.z),i.setXYZ(f+1,u.x,u.y,u.z),i.setXYZ(f+2,u.x,u.y,u.z);this.normalizeNormals(),i.needsUpdate=!0}}normalizeNormals(){const e=this.attributes.normal;for(let t=0,i=e.count;t<i;t++)Ut.fromBufferAttribute(e,t),Ut.normalize(),e.setXYZ(t,Ut.x,Ut.y,Ut.z)}toNonIndexed(){function e(a,l){const c=a.array,u=a.itemSize,h=a.normalized,f=new c.constructor(l.length*u);let p=0,g=0;for(let M=0,m=l.length;M<m;M++){a.isInterleavedBufferAttribute?p=l[M]*a.data.stride+a.offset:p=l[M]*u;for(let d=0;d<u;d++)f[g++]=c[p++]}return new Xn(f,u,h)}if(this.index===null)return ze("BufferGeometry.toNonIndexed(): BufferGeometry is already non-indexed."),this;const t=new $t,i=this.index.array,r=this.attributes;for(const a in r){const l=r[a],c=e(l,i);t.setAttribute(a,c)}const s=this.morphAttributes;for(const a in s){const l=[],c=s[a];for(let u=0,h=c.length;u<h;u++){const f=c[u],p=e(f,i);l.push(p)}t.morphAttributes[a]=l}t.morphTargetsRelative=this.morphTargetsRelative;const o=this.groups;for(let a=0,l=o.length;a<l;a++){const c=o[a];t.addGroup(c.start,c.count,c.materialIndex)}return t}toJSON(){const e={metadata:{version:4.7,type:"BufferGeometry",generator:"BufferGeometry.toJSON"}};if(e.uuid=this.uuid,e.type=this.type,this.name!==""&&(e.name=this.name),Object.keys(this.userData).length>0&&(e.userData=this.userData),this.parameters!==void 0){const l=this.parameters;for(const c in l)l[c]!==void 0&&(e[c]=l[c]);return e}e.data={attributes:{}};const t=this.index;t!==null&&(e.data.index={type:t.array.constructor.name,array:Array.prototype.slice.call(t.array)});const i=this.attributes;for(const l in i){const c=i[l];e.data.attributes[l]=c.toJSON(e.data)}const r={};let s=!1;for(const l in this.morphAttributes){const c=this.morphAttributes[l],u=[];for(let h=0,f=c.length;h<f;h++){const p=c[h];u.push(p.toJSON(e.data))}u.length>0&&(r[l]=u,s=!0)}s&&(e.data.morphAttributes=r,e.data.morphTargetsRelative=this.morphTargetsRelative);const o=this.groups;o.length>0&&(e.data.groups=JSON.parse(JSON.stringify(o)));const a=this.boundingSphere;return a!==null&&(e.data.boundingSphere=a.toJSON()),e}clone(){return new this.constructor().copy(this)}copy(e){this.index=null,this.attributes={},this.morphAttributes={},this.groups=[],this.boundingBox=null,this.boundingSphere=null;const t={};this.name=e.name;const i=e.index;i!==null&&this.setIndex(i.clone());const r=e.attributes;for(const c in r){const u=r[c];this.setAttribute(c,u.clone(t))}const s=e.morphAttributes;for(const c in s){const u=[],h=s[c];for(let f=0,p=h.length;f<p;f++)u.push(h[f].clone(t));this.morphAttributes[c]=u}this.morphTargetsRelative=e.morphTargetsRelative;const o=e.groups;for(let c=0,u=o.length;c<u;c++){const h=o[c];this.addGroup(h.start,h.count,h.materialIndex)}const a=e.boundingBox;a!==null&&(this.boundingBox=a.clone());const l=e.boundingSphere;return l!==null&&(this.boundingSphere=l.clone()),this.drawRange.start=e.drawRange.start,this.drawRange.count=e.drawRange.count,this.userData=e.userData,this}dispose(){this.dispatchEvent({type:"dispose"})}}let E0=0;class Ns extends Ni{constructor(){super(),this.isMaterial=!0,Object.defineProperty(this,"id",{value:E0++}),this.uuid=kr(),this.name="",this.type="Material",this.blending=Ur,this.side=Li,this.vertexColors=!1,this.opacity=1,this.transparent=!1,this.alphaHash=!1,this.blendSrc=wl,this.blendDst=Rl,this.blendEquation=$i,this.blendSrcAlpha=null,this.blendDstAlpha=null,this.blendEquationAlpha=null,this.blendColor=new lt(0,0,0),this.blendAlpha=0,this.depthFunc=zr,this.depthTest=!0,this.depthWrite=!0,this.stencilWriteMask=255,this.stencilFunc=Ju,this.stencilRef=0,this.stencilFuncMask=255,this.stencilFail=hr,this.stencilZFail=hr,this.stencilZPass=hr,this.stencilWrite=!1,this.clippingPlanes=null,this.clipIntersection=!1,this.clipShadows=!1,this.shadowSide=null,this.colorWrite=!0,this.precision=null,this.polygonOffset=!1,this.polygonOffsetFactor=0,this.polygonOffsetUnits=0,this.dithering=!1,this.alphaToCoverage=!1,this.premultipliedAlpha=!1,this.forceSinglePass=!1,this.allowOverride=!0,this.visible=!0,this.toneMapped=!0,this.userData={},this.version=0,this._alphaTest=0}get alphaTest(){return this._alphaTest}set alphaTest(e){this._alphaTest>0!=e>0&&this.version++,this._alphaTest=e}onBeforeRender(){}onBeforeCompile(){}customProgramCacheKey(){return this.onBeforeCompile.toString()}setValues(e){if(e!==void 0)for(const t in e){const i=e[t];if(i===void 0){ze(`Material: parameter '${t}' has value of undefined.`);continue}const r=this[t];if(r===void 0){ze(`Material: '${t}' is not a property of THREE.${this.type}.`);continue}r&&r.isColor?r.set(i):r&&r.isVector3&&i&&i.isVector3?r.copy(i):this[t]=i}}toJSON(e){const t=e===void 0||typeof e=="string";t&&(e={textures:{},images:{}});const i={metadata:{version:4.7,type:"Material",generator:"Material.toJSON"}};i.uuid=this.uuid,i.type=this.type,this.name!==""&&(i.name=this.name),this.color&&this.color.isColor&&(i.color=this.color.getHex()),this.roughness!==void 0&&(i.roughness=this.roughness),this.metalness!==void 0&&(i.metalness=this.metalness),this.sheen!==void 0&&(i.sheen=this.sheen),this.sheenColor&&this.sheenColor.isColor&&(i.sheenColor=this.sheenColor.getHex()),this.sheenRoughness!==void 0&&(i.sheenRoughness=this.sheenRoughness),this.emissive&&this.emissive.isColor&&(i.emissive=this.emissive.getHex()),this.emissiveIntensity!==void 0&&this.emissiveIntensity!==1&&(i.emissiveIntensity=this.emissiveIntensity),this.specular&&this.specular.isColor&&(i.specular=this.specular.getHex()),this.specularIntensity!==void 0&&(i.specularIntensity=this.specularIntensity),this.specularColor&&this.specularColor.isColor&&(i.specularColor=this.specularColor.getHex()),this.shininess!==void 0&&(i.shininess=this.shininess),this.clearcoat!==void 0&&(i.clearcoat=this.clearcoat),this.clearcoatRoughness!==void 0&&(i.clearcoatRoughness=this.clearcoatRoughness),this.clearcoatMap&&this.clearcoatMap.isTexture&&(i.clearcoatMap=this.clearcoatMap.toJSON(e).uuid),this.clearcoatRoughnessMap&&this.clearcoatRoughnessMap.isTexture&&(i.clearcoatRoughnessMap=this.clearcoatRoughnessMap.toJSON(e).uuid),this.clearcoatNormalMap&&this.clearcoatNormalMap.isTexture&&(i.clearcoatNormalMap=this.clearcoatNormalMap.toJSON(e).uuid,i.clearcoatNormalScale=this.clearcoatNormalScale.toArray()),this.sheenColorMap&&this.sheenColorMap.isTexture&&(i.sheenColorMap=this.sheenColorMap.toJSON(e).uuid),this.sheenRoughnessMap&&this.sheenRoughnessMap.isTexture&&(i.sheenRoughnessMap=this.sheenRoughnessMap.toJSON(e).uuid),this.dispersion!==void 0&&(i.dispersion=this.dispersion),this.iridescence!==void 0&&(i.iridescence=this.iridescence),this.iridescenceIOR!==void 0&&(i.iridescenceIOR=this.iridescenceIOR),this.iridescenceThicknessRange!==void 0&&(i.iridescenceThicknessRange=this.iridescenceThicknessRange),this.iridescenceMap&&this.iridescenceMap.isTexture&&(i.iridescenceMap=this.iridescenceMap.toJSON(e).uuid),this.iridescenceThicknessMap&&this.iridescenceThicknessMap.isTexture&&(i.iridescenceThicknessMap=this.iridescenceThicknessMap.toJSON(e).uuid),this.anisotropy!==void 0&&(i.anisotropy=this.anisotropy),this.anisotropyRotation!==void 0&&(i.anisotropyRotation=this.anisotropyRotation),this.anisotropyMap&&this.anisotropyMap.isTexture&&(i.anisotropyMap=this.anisotropyMap.toJSON(e).uuid),this.map&&this.map.isTexture&&(i.map=this.map.toJSON(e).uuid),this.matcap&&this.matcap.isTexture&&(i.matcap=this.matcap.toJSON(e).uuid),this.alphaMap&&this.alphaMap.isTexture&&(i.alphaMap=this.alphaMap.toJSON(e).uuid),this.lightMap&&this.lightMap.isTexture&&(i.lightMap=this.lightMap.toJSON(e).uuid,i.lightMapIntensity=this.lightMapIntensity),this.aoMap&&this.aoMap.isTexture&&(i.aoMap=this.aoMap.toJSON(e).uuid,i.aoMapIntensity=this.aoMapIntensity),this.bumpMap&&this.bumpMap.isTexture&&(i.bumpMap=this.bumpMap.toJSON(e).uuid,i.bumpScale=this.bumpScale),this.normalMap&&this.normalMap.isTexture&&(i.normalMap=this.normalMap.toJSON(e).uuid,i.normalMapType=this.normalMapType,i.normalScale=this.normalScale.toArray()),this.displacementMap&&this.displacementMap.isTexture&&(i.displacementMap=this.displacementMap.toJSON(e).uuid,i.displacementScale=this.displacementScale,i.displacementBias=this.displacementBias),this.roughnessMap&&this.roughnessMap.isTexture&&(i.roughnessMap=this.roughnessMap.toJSON(e).uuid),this.metalnessMap&&this.metalnessMap.isTexture&&(i.metalnessMap=this.metalnessMap.toJSON(e).uuid),this.emissiveMap&&this.emissiveMap.isTexture&&(i.emissiveMap=this.emissiveMap.toJSON(e).uuid),this.specularMap&&this.specularMap.isTexture&&(i.specularMap=this.specularMap.toJSON(e).uuid),this.specularIntensityMap&&this.specularIntensityMap.isTexture&&(i.specularIntensityMap=this.specularIntensityMap.toJSON(e).uuid),this.specularColorMap&&this.specularColorMap.isTexture&&(i.specularColorMap=this.specularColorMap.toJSON(e).uuid),this.envMap&&this.envMap.isTexture&&(i.envMap=this.envMap.toJSON(e).uuid,this.combine!==void 0&&(i.combine=this.combine)),this.envMapRotation!==void 0&&(i.envMapRotation=this.envMapRotation.toArray()),this.envMapIntensity!==void 0&&(i.envMapIntensity=this.envMapIntensity),this.reflectivity!==void 0&&(i.reflectivity=this.reflectivity),this.refractionRatio!==void 0&&(i.refractionRatio=this.refractionRatio),this.gradientMap&&this.gradientMap.isTexture&&(i.gradientMap=this.gradientMap.toJSON(e).uuid),this.transmission!==void 0&&(i.transmission=this.transmission),this.transmissionMap&&this.transmissionMap.isTexture&&(i.transmissionMap=this.transmissionMap.toJSON(e).uuid),this.thickness!==void 0&&(i.thickness=this.thickness),this.thicknessMap&&this.thicknessMap.isTexture&&(i.thicknessMap=this.thicknessMap.toJSON(e).uuid),this.attenuationDistance!==void 0&&this.attenuationDistance!==1/0&&(i.attenuationDistance=this.attenuationDistance),this.attenuationColor!==void 0&&(i.attenuationColor=this.attenuationColor.getHex()),this.size!==void 0&&(i.size=this.size),this.shadowSide!==null&&(i.shadowSide=this.shadowSide),this.sizeAttenuation!==void 0&&(i.sizeAttenuation=this.sizeAttenuation),this.blending!==Ur&&(i.blending=this.blending),this.side!==Li&&(i.side=this.side),this.vertexColors===!0&&(i.vertexColors=!0),this.opacity<1&&(i.opacity=this.opacity),this.transparent===!0&&(i.transparent=!0),this.blendSrc!==wl&&(i.blendSrc=this.blendSrc),this.blendDst!==Rl&&(i.blendDst=this.blendDst),this.blendEquation!==$i&&(i.blendEquation=this.blendEquation),this.blendSrcAlpha!==null&&(i.blendSrcAlpha=this.blendSrcAlpha),this.blendDstAlpha!==null&&(i.blendDstAlpha=this.blendDstAlpha),this.blendEquationAlpha!==null&&(i.blendEquationAlpha=this.blendEquationAlpha),this.blendColor&&this.blendColor.isColor&&(i.blendColor=this.blendColor.getHex()),this.blendAlpha!==0&&(i.blendAlpha=this.blendAlpha),this.depthFunc!==zr&&(i.depthFunc=this.depthFunc),this.depthTest===!1&&(i.depthTest=this.depthTest),this.depthWrite===!1&&(i.depthWrite=this.depthWrite),this.colorWrite===!1&&(i.colorWrite=this.colorWrite),this.stencilWriteMask!==255&&(i.stencilWriteMask=this.stencilWriteMask),this.stencilFunc!==Ju&&(i.stencilFunc=this.stencilFunc),this.stencilRef!==0&&(i.stencilRef=this.stencilRef),this.stencilFuncMask!==255&&(i.stencilFuncMask=this.stencilFuncMask),this.stencilFail!==hr&&(i.stencilFail=this.stencilFail),this.stencilZFail!==hr&&(i.stencilZFail=this.stencilZFail),this.stencilZPass!==hr&&(i.stencilZPass=this.stencilZPass),this.stencilWrite===!0&&(i.stencilWrite=this.stencilWrite),this.rotation!==void 0&&this.rotation!==0&&(i.rotation=this.rotation),this.polygonOffset===!0&&(i.polygonOffset=!0),this.polygonOffsetFactor!==0&&(i.polygonOffsetFactor=this.polygonOffsetFactor),this.polygonOffsetUnits!==0&&(i.polygonOffsetUnits=this.polygonOffsetUnits),this.linewidth!==void 0&&this.linewidth!==1&&(i.linewidth=this.linewidth),this.dashSize!==void 0&&(i.dashSize=this.dashSize),this.gapSize!==void 0&&(i.gapSize=this.gapSize),this.scale!==void 0&&(i.scale=this.scale),this.dithering===!0&&(i.dithering=!0),this.alphaTest>0&&(i.alphaTest=this.alphaTest),this.alphaHash===!0&&(i.alphaHash=!0),this.alphaToCoverage===!0&&(i.alphaToCoverage=!0),this.premultipliedAlpha===!0&&(i.premultipliedAlpha=!0),this.forceSinglePass===!0&&(i.forceSinglePass=!0),this.allowOverride===!1&&(i.allowOverride=!1),this.wireframe===!0&&(i.wireframe=!0),this.wireframeLinewidth>1&&(i.wireframeLinewidth=this.wireframeLinewidth),this.wireframeLinecap!=="round"&&(i.wireframeLinecap=this.wireframeLinecap),this.wireframeLinejoin!=="round"&&(i.wireframeLinejoin=this.wireframeLinejoin),this.flatShading===!0&&(i.flatShading=!0),this.visible===!1&&(i.visible=!1),this.toneMapped===!1&&(i.toneMapped=!1),this.fog===!1&&(i.fog=!1),Object.keys(this.userData).length>0&&(i.userData=this.userData);function r(s){const o=[];for(const a in s){const l=s[a];delete l.metadata,o.push(l)}return o}if(t){const s=r(e.textures),o=r(e.images);s.length>0&&(i.textures=s),o.length>0&&(i.images=o)}return i}clone(){return new this.constructor().copy(this)}copy(e){this.name=e.name,this.blending=e.blending,this.side=e.side,this.vertexColors=e.vertexColors,this.opacity=e.opacity,this.transparent=e.transparent,this.blendSrc=e.blendSrc,this.blendDst=e.blendDst,this.blendEquation=e.blendEquation,this.blendSrcAlpha=e.blendSrcAlpha,this.blendDstAlpha=e.blendDstAlpha,this.blendEquationAlpha=e.blendEquationAlpha,this.blendColor.copy(e.blendColor),this.blendAlpha=e.blendAlpha,this.depthFunc=e.depthFunc,this.depthTest=e.depthTest,this.depthWrite=e.depthWrite,this.stencilWriteMask=e.stencilWriteMask,this.stencilFunc=e.stencilFunc,this.stencilRef=e.stencilRef,this.stencilFuncMask=e.stencilFuncMask,this.stencilFail=e.stencilFail,this.stencilZFail=e.stencilZFail,this.stencilZPass=e.stencilZPass,this.stencilWrite=e.stencilWrite;const t=e.clippingPlanes;let i=null;if(t!==null){const r=t.length;i=new Array(r);for(let s=0;s!==r;++s)i[s]=t[s].clone()}return this.clippingPlanes=i,this.clipIntersection=e.clipIntersection,this.clipShadows=e.clipShadows,this.shadowSide=e.shadowSide,this.colorWrite=e.colorWrite,this.precision=e.precision,this.polygonOffset=e.polygonOffset,this.polygonOffsetFactor=e.polygonOffsetFactor,this.polygonOffsetUnits=e.polygonOffsetUnits,this.dithering=e.dithering,this.alphaTest=e.alphaTest,this.alphaHash=e.alphaHash,this.alphaToCoverage=e.alphaToCoverage,this.premultipliedAlpha=e.premultipliedAlpha,this.forceSinglePass=e.forceSinglePass,this.allowOverride=e.allowOverride,this.visible=e.visible,this.toneMapped=e.toneMapped,this.userData=JSON.parse(JSON.stringify(e.userData)),this}dispose(){this.dispatchEvent({type:"dispose"})}set needsUpdate(e){e===!0&&this.version++}}const ei=new N,Ja=new N,Qs=new N,yi=new N,Qa=new N,eo=new N,el=new N;class jc{constructor(e=new N,t=new N(0,0,-1)){this.origin=e,this.direction=t}set(e,t){return this.origin.copy(e),this.direction.copy(t),this}copy(e){return this.origin.copy(e.origin),this.direction.copy(e.direction),this}at(e,t){return t.copy(this.origin).addScaledVector(this.direction,e)}lookAt(e){return this.direction.copy(e).sub(this.origin).normalize(),this}recast(e){return this.origin.copy(this.at(e,ei)),this}closestPointToPoint(e,t){t.subVectors(e,this.origin);const i=t.dot(this.direction);return i<0?t.copy(this.origin):t.copy(this.origin).addScaledVector(this.direction,i)}distanceToPoint(e){return Math.sqrt(this.distanceSqToPoint(e))}distanceSqToPoint(e){const t=ei.subVectors(e,this.origin).dot(this.direction);return t<0?this.origin.distanceToSquared(e):(ei.copy(this.origin).addScaledVector(this.direction,t),ei.distanceToSquared(e))}distanceSqToSegment(e,t,i,r){Ja.copy(e).add(t).multiplyScalar(.5),Qs.copy(t).sub(e).normalize(),yi.copy(this.origin).sub(Ja);const s=e.distanceTo(t)*.5,o=-this.direction.dot(Qs),a=yi.dot(this.direction),l=-yi.dot(Qs),c=yi.lengthSq(),u=Math.abs(1-o*o);let h,f,p,g;if(u>0)if(h=o*l-a,f=o*a-l,g=s*u,h>=0)if(f>=-g)if(f<=g){const M=1/u;h*=M,f*=M,p=h*(h+o*f+2*a)+f*(o*h+f+2*l)+c}else f=s,h=Math.max(0,-(o*f+a)),p=-h*h+f*(f+2*l)+c;else f=-s,h=Math.max(0,-(o*f+a)),p=-h*h+f*(f+2*l)+c;else f<=-g?(h=Math.max(0,-(-o*s+a)),f=h>0?-s:Math.min(Math.max(-s,-l),s),p=-h*h+f*(f+2*l)+c):f<=g?(h=0,f=Math.min(Math.max(-s,-l),s),p=f*(f+2*l)+c):(h=Math.max(0,-(o*s+a)),f=h>0?s:Math.min(Math.max(-s,-l),s),p=-h*h+f*(f+2*l)+c);else f=o>0?-s:s,h=Math.max(0,-(o*f+a)),p=-h*h+f*(f+2*l)+c;return i&&i.copy(this.origin).addScaledVector(this.direction,h),r&&r.copy(Ja).addScaledVector(Qs,f),p}intersectSphere(e,t){ei.subVectors(e.center,this.origin);const i=ei.dot(this.direction),r=ei.dot(ei)-i*i,s=e.radius*e.radius;if(r>s)return null;const o=Math.sqrt(s-r),a=i-o,l=i+o;return l<0?null:a<0?this.at(l,t):this.at(a,t)}intersectsSphere(e){return e.radius<0?!1:this.distanceSqToPoint(e.center)<=e.radius*e.radius}distanceToPlane(e){const t=e.normal.dot(this.direction);if(t===0)return e.distanceToPoint(this.origin)===0?0:null;const i=-(this.origin.dot(e.normal)+e.constant)/t;return i>=0?i:null}intersectPlane(e,t){const i=this.distanceToPlane(e);return i===null?null:this.at(i,t)}intersectsPlane(e){const t=e.distanceToPoint(this.origin);return t===0||e.normal.dot(this.direction)*t<0}intersectBox(e,t){let i,r,s,o,a,l;const c=1/this.direction.x,u=1/this.direction.y,h=1/this.direction.z,f=this.origin;return c>=0?(i=(e.min.x-f.x)*c,r=(e.max.x-f.x)*c):(i=(e.max.x-f.x)*c,r=(e.min.x-f.x)*c),u>=0?(s=(e.min.y-f.y)*u,o=(e.max.y-f.y)*u):(s=(e.max.y-f.y)*u,o=(e.min.y-f.y)*u),i>o||s>r||((s>i||isNaN(i))&&(i=s),(o<r||isNaN(r))&&(r=o),h>=0?(a=(e.min.z-f.z)*h,l=(e.max.z-f.z)*h):(a=(e.max.z-f.z)*h,l=(e.min.z-f.z)*h),i>l||a>r)||((a>i||i!==i)&&(i=a),(l<r||r!==r)&&(r=l),r<0)?null:this.at(i>=0?i:r,t)}intersectsBox(e){return this.intersectBox(e,ei)!==null}intersectTriangle(e,t,i,r,s){Qa.subVectors(t,e),eo.subVectors(i,e),el.crossVectors(Qa,eo);let o=this.direction.dot(el),a;if(o>0){if(r)return null;a=1}else if(o<0)a=-1,o=-o;else return null;yi.subVectors(this.origin,e);const l=a*this.direction.dot(eo.crossVectors(yi,eo));if(l<0)return null;const c=a*this.direction.dot(Qa.cross(yi));if(c<0||l+c>o)return null;const u=-a*yi.dot(el);return u<0?null:this.at(u/o,s)}applyMatrix4(e){return this.origin.applyMatrix4(e),this.direction.transformDirection(e),this}equals(e){return e.origin.equals(this.origin)&&e.direction.equals(this.direction)}clone(){return new this.constructor().copy(this)}}class ma extends Ns{constructor(e){super(),this.isMeshBasicMaterial=!0,this.type="MeshBasicMaterial",this.color=new lt(16777215),this.map=null,this.lightMap=null,this.lightMapIntensity=1,this.aoMap=null,this.aoMapIntensity=1,this.specularMap=null,this.alphaMap=null,this.envMap=null,this.envMapRotation=new Ui,this.combine=Pd,this.reflectivity=1,this.refractionRatio=.98,this.wireframe=!1,this.wireframeLinewidth=1,this.wireframeLinecap="round",this.wireframeLinejoin="round",this.fog=!0,this.setValues(e)}copy(e){return super.copy(e),this.color.copy(e.color),this.map=e.map,this.lightMap=e.lightMap,this.lightMapIntensity=e.lightMapIntensity,this.aoMap=e.aoMap,this.aoMapIntensity=e.aoMapIntensity,this.specularMap=e.specularMap,this.alphaMap=e.alphaMap,this.envMap=e.envMap,this.envMapRotation.copy(e.envMapRotation),this.combine=e.combine,this.reflectivity=e.reflectivity,this.refractionRatio=e.refractionRatio,this.wireframe=e.wireframe,this.wireframeLinewidth=e.wireframeLinewidth,this.wireframeLinecap=e.wireframeLinecap,this.wireframeLinejoin=e.wireframeLinejoin,this.fog=e.fog,this}}const gf=new Mt,Gi=new jc,to=new pa,_f=new N,no=new N,io=new N,ro=new N,tl=new N,so=new N,xf=new N,oo=new N;class Pe extends Ft{constructor(e=new $t,t=new ma){super(),this.isMesh=!0,this.type="Mesh",this.geometry=e,this.material=t,this.morphTargetDictionary=void 0,this.morphTargetInfluences=void 0,this.count=1,this.updateMorphTargets()}copy(e,t){return super.copy(e,t),e.morphTargetInfluences!==void 0&&(this.morphTargetInfluences=e.morphTargetInfluences.slice()),e.morphTargetDictionary!==void 0&&(this.morphTargetDictionary=Object.assign({},e.morphTargetDictionary)),this.material=Array.isArray(e.material)?e.material.slice():e.material,this.geometry=e.geometry,this}updateMorphTargets(){const t=this.geometry.morphAttributes,i=Object.keys(t);if(i.length>0){const r=t[i[0]];if(r!==void 0){this.morphTargetInfluences=[],this.morphTargetDictionary={};for(let s=0,o=r.length;s<o;s++){const a=r[s].name||String(s);this.morphTargetInfluences.push(0),this.morphTargetDictionary[a]=s}}}}getVertexPosition(e,t){const i=this.geometry,r=i.attributes.position,s=i.morphAttributes.position,o=i.morphTargetsRelative;t.fromBufferAttribute(r,e);const a=this.morphTargetInfluences;if(s&&a){so.set(0,0,0);for(let l=0,c=s.length;l<c;l++){const u=a[l],h=s[l];u!==0&&(tl.fromBufferAttribute(h,e),o?so.addScaledVector(tl,u):so.addScaledVector(tl.sub(t),u))}t.add(so)}return t}raycast(e,t){const i=this.geometry,r=this.material,s=this.matrixWorld;r!==void 0&&(i.boundingSphere===null&&i.computeBoundingSphere(),to.copy(i.boundingSphere),to.applyMatrix4(s),Gi.copy(e.ray).recast(e.near),!(to.containsPoint(Gi.origin)===!1&&(Gi.intersectSphere(to,_f)===null||Gi.origin.distanceToSquared(_f)>(e.far-e.near)**2))&&(gf.copy(s).invert(),Gi.copy(e.ray).applyMatrix4(gf),!(i.boundingBox!==null&&Gi.intersectsBox(i.boundingBox)===!1)&&this._computeIntersections(e,t,Gi)))}_computeIntersections(e,t,i){let r;const s=this.geometry,o=this.material,a=s.index,l=s.attributes.position,c=s.attributes.uv,u=s.attributes.uv1,h=s.attributes.normal,f=s.groups,p=s.drawRange;if(a!==null)if(Array.isArray(o))for(let g=0,M=f.length;g<M;g++){const m=f[g],d=o[m.materialIndex],x=Math.max(m.start,p.start),y=Math.min(a.count,Math.min(m.start+m.count,p.start+p.count));for(let S=x,C=y;S<C;S+=3){const A=a.getX(S),P=a.getX(S+1),v=a.getX(S+2);r=ao(this,d,e,i,c,u,h,A,P,v),r&&(r.faceIndex=Math.floor(S/3),r.face.materialIndex=m.materialIndex,t.push(r))}}else{const g=Math.max(0,p.start),M=Math.min(a.count,p.start+p.count);for(let m=g,d=M;m<d;m+=3){const x=a.getX(m),y=a.getX(m+1),S=a.getX(m+2);r=ao(this,o,e,i,c,u,h,x,y,S),r&&(r.faceIndex=Math.floor(m/3),t.push(r))}}else if(l!==void 0)if(Array.isArray(o))for(let g=0,M=f.length;g<M;g++){const m=f[g],d=o[m.materialIndex],x=Math.max(m.start,p.start),y=Math.min(l.count,Math.min(m.start+m.count,p.start+p.count));for(let S=x,C=y;S<C;S+=3){const A=S,P=S+1,v=S+2;r=ao(this,d,e,i,c,u,h,A,P,v),r&&(r.faceIndex=Math.floor(S/3),r.face.materialIndex=m.materialIndex,t.push(r))}}else{const g=Math.max(0,p.start),M=Math.min(l.count,p.start+p.count);for(let m=g,d=M;m<d;m+=3){const x=m,y=m+1,S=m+2;r=ao(this,o,e,i,c,u,h,x,y,S),r&&(r.faceIndex=Math.floor(m/3),t.push(r))}}}}function y0(n,e,t,i,r,s,o,a){let l;if(e.side===on?l=i.intersectTriangle(o,s,r,!0,a):l=i.intersectTriangle(r,s,o,e.side===Li,a),l===null)return null;oo.copy(a),oo.applyMatrix4(n.matrixWorld);const c=t.ray.origin.distanceTo(oo);return c<t.near||c>t.far?null:{distance:c,point:oo.clone(),object:n}}function ao(n,e,t,i,r,s,o,a,l,c){n.getVertexPosition(a,no),n.getVertexPosition(l,io),n.getVertexPosition(c,ro);const u=y0(n,e,t,i,no,io,ro,xf);if(u){const h=new N;bn.getBarycoord(xf,no,io,ro,h),r&&(u.uv=bn.getInterpolatedAttribute(r,a,l,c,h,new st)),s&&(u.uv1=bn.getInterpolatedAttribute(s,a,l,c,h,new st)),o&&(u.normal=bn.getInterpolatedAttribute(o,a,l,c,h,new N),u.normal.dot(i.direction)>0&&u.normal.multiplyScalar(-1));const f={a,b:l,c,normal:new N,materialIndex:0};bn.getNormal(no,io,ro,f.normal),u.face=f,u.barycoord=h}return u}class b0 extends rn{constructor(e=null,t=1,i=1,r,s,o,a,l,c=zt,u=zt,h,f){super(null,o,a,l,c,u,r,s,h,f),this.isDataTexture=!0,this.image={data:e,width:t,height:i},this.generateMipmaps=!1,this.flipY=!1,this.unpackAlignment=1}}const nl=new N,T0=new N,A0=new Xe;class Yi{constructor(e=new N(1,0,0),t=0){this.isPlane=!0,this.normal=e,this.constant=t}set(e,t){return this.normal.copy(e),this.constant=t,this}setComponents(e,t,i,r){return this.normal.set(e,t,i),this.constant=r,this}setFromNormalAndCoplanarPoint(e,t){return this.normal.copy(e),this.constant=-t.dot(this.normal),this}setFromCoplanarPoints(e,t,i){const r=nl.subVectors(i,t).cross(T0.subVectors(e,t)).normalize();return this.setFromNormalAndCoplanarPoint(r,e),this}copy(e){return this.normal.copy(e.normal),this.constant=e.constant,this}normalize(){const e=1/this.normal.length();return this.normal.multiplyScalar(e),this.constant*=e,this}negate(){return this.constant*=-1,this.normal.negate(),this}distanceToPoint(e){return this.normal.dot(e)+this.constant}distanceToSphere(e){return this.distanceToPoint(e.center)-e.radius}projectPoint(e,t){return t.copy(e).addScaledVector(this.normal,-this.distanceToPoint(e))}intersectLine(e,t,i=!0){const r=e.delta(nl),s=this.normal.dot(r);if(s===0)return this.distanceToPoint(e.start)===0?t.copy(e.start):null;const o=-(e.start.dot(this.normal)+this.constant)/s;return i===!0&&(o<0||o>1)?null:t.copy(e.start).addScaledVector(r,o)}intersectsLine(e){const t=this.distanceToPoint(e.start),i=this.distanceToPoint(e.end);return t<0&&i>0||i<0&&t>0}intersectsBox(e){return e.intersectsPlane(this)}intersectsSphere(e){return e.intersectsPlane(this)}coplanarPoint(e){return e.copy(this.normal).multiplyScalar(-this.constant)}applyMatrix4(e,t){const i=t||A0.getNormalMatrix(e),r=this.coplanarPoint(nl).applyMatrix4(e),s=this.normal.applyMatrix3(i).normalize();return this.constant=-r.dot(s),this}translate(e){return this.constant-=e.dot(this.normal),this}equals(e){return e.normal.equals(this.normal)&&e.constant===this.constant}clone(){return new this.constructor().copy(this)}}const ki=new pa,w0=new st(.5,.5),lo=new N;class $d{constructor(e=new Yi,t=new Yi,i=new Yi,r=new Yi,s=new Yi,o=new Yi){this.planes=[e,t,i,r,s,o]}set(e,t,i,r,s,o){const a=this.planes;return a[0].copy(e),a[1].copy(t),a[2].copy(i),a[3].copy(r),a[4].copy(s),a[5].copy(o),this}copy(e){const t=this.planes;for(let i=0;i<6;i++)t[i].copy(e.planes[i]);return this}setFromProjectionMatrix(e,t=Vn,i=!1){const r=this.planes,s=e.elements,o=s[0],a=s[1],l=s[2],c=s[3],u=s[4],h=s[5],f=s[6],p=s[7],g=s[8],M=s[9],m=s[10],d=s[11],x=s[12],y=s[13],S=s[14],C=s[15];if(r[0].setComponents(c-o,p-u,d-g,C-x).normalize(),r[1].setComponents(c+o,p+u,d+g,C+x).normalize(),r[2].setComponents(c+a,p+h,d+M,C+y).normalize(),r[3].setComponents(c-a,p-h,d-M,C-y).normalize(),i)r[4].setComponents(l,f,m,S).normalize(),r[5].setComponents(c-l,p-f,d-m,C-S).normalize();else if(r[4].setComponents(c-l,p-f,d-m,C-S).normalize(),t===Vn)r[5].setComponents(c+l,p+f,d+m,C+S).normalize();else if(t===qo)r[5].setComponents(l,f,m,S).normalize();else throw new Error("THREE.Frustum.setFromProjectionMatrix(): Invalid coordinate system: "+t);return this}intersectsObject(e){if(e.boundingSphere!==void 0)e.boundingSphere===null&&e.computeBoundingSphere(),ki.copy(e.boundingSphere).applyMatrix4(e.matrixWorld);else{const t=e.geometry;t.boundingSphere===null&&t.computeBoundingSphere(),ki.copy(t.boundingSphere).applyMatrix4(e.matrixWorld)}return this.intersectsSphere(ki)}intersectsSprite(e){ki.center.set(0,0,0);const t=w0.distanceTo(e.center);return ki.radius=.7071067811865476+t,ki.applyMatrix4(e.matrixWorld),this.intersectsSphere(ki)}intersectsSphere(e){const t=this.planes,i=e.center,r=-e.radius;for(let s=0;s<6;s++)if(t[s].distanceToPoint(i)<r)return!1;return!0}intersectsBox(e){const t=this.planes;for(let i=0;i<6;i++){const r=t[i];if(lo.x=r.normal.x>0?e.max.x:e.min.x,lo.y=r.normal.y>0?e.max.y:e.min.y,lo.z=r.normal.z>0?e.max.z:e.min.z,r.distanceToPoint(lo)<0)return!1}return!0}containsPoint(e){const t=this.planes;for(let i=0;i<6;i++)if(t[i].distanceToPoint(e)<0)return!1;return!0}clone(){return new this.constructor().copy(this)}}class Jd extends Ns{constructor(e){super(),this.isLineBasicMaterial=!0,this.type="LineBasicMaterial",this.color=new lt(16777215),this.map=null,this.linewidth=1,this.linecap="round",this.linejoin="round",this.fog=!0,this.setValues(e)}copy(e){return super.copy(e),this.color.copy(e.color),this.map=e.map,this.linewidth=e.linewidth,this.linecap=e.linecap,this.linejoin=e.linejoin,this.fog=e.fog,this}}const jo=new N,Zo=new N,vf=new Mt,Qr=new jc,co=new pa,il=new N,Mf=new N;class bi extends Ft{constructor(e=new $t,t=new Jd){super(),this.isLine=!0,this.type="Line",this.geometry=e,this.material=t,this.morphTargetDictionary=void 0,this.morphTargetInfluences=void 0,this.updateMorphTargets()}copy(e,t){return super.copy(e,t),this.material=Array.isArray(e.material)?e.material.slice():e.material,this.geometry=e.geometry,this}computeLineDistances(){const e=this.geometry;if(e.index===null){const t=e.attributes.position,i=[0];for(let r=1,s=t.count;r<s;r++)jo.fromBufferAttribute(t,r-1),Zo.fromBufferAttribute(t,r),i[r]=i[r-1],i[r]+=jo.distanceTo(Zo);e.setAttribute("lineDistance",new St(i,1))}else ze("Line.computeLineDistances(): Computation only possible with non-indexed BufferGeometry.");return this}raycast(e,t){const i=this.geometry,r=this.matrixWorld,s=e.params.Line.threshold,o=i.drawRange;if(i.boundingSphere===null&&i.computeBoundingSphere(),co.copy(i.boundingSphere),co.applyMatrix4(r),co.radius+=s,e.ray.intersectsSphere(co)===!1)return;vf.copy(r).invert(),Qr.copy(e.ray).applyMatrix4(vf);const a=s/((this.scale.x+this.scale.y+this.scale.z)/3),l=a*a,c=this.isLineSegments?2:1,u=i.index,f=i.attributes.position;if(u!==null){const p=Math.max(0,o.start),g=Math.min(u.count,o.start+o.count);for(let M=p,m=g-1;M<m;M+=c){const d=u.getX(M),x=u.getX(M+1),y=uo(this,e,Qr,l,d,x,M);y&&t.push(y)}if(this.isLineLoop){const M=u.getX(g-1),m=u.getX(p),d=uo(this,e,Qr,l,M,m,g-1);d&&t.push(d)}}else{const p=Math.max(0,o.start),g=Math.min(f.count,o.start+o.count);for(let M=p,m=g-1;M<m;M+=c){const d=uo(this,e,Qr,l,M,M+1,M);d&&t.push(d)}if(this.isLineLoop){const M=uo(this,e,Qr,l,g-1,p,g-1);M&&t.push(M)}}}updateMorphTargets(){const t=this.geometry.morphAttributes,i=Object.keys(t);if(i.length>0){const r=t[i[0]];if(r!==void 0){this.morphTargetInfluences=[],this.morphTargetDictionary={};for(let s=0,o=r.length;s<o;s++){const a=r[s].name||String(s);this.morphTargetInfluences.push(0),this.morphTargetDictionary[a]=s}}}}}function uo(n,e,t,i,r,s,o){const a=n.geometry.attributes.position;if(jo.fromBufferAttribute(a,r),Zo.fromBufferAttribute(a,s),t.distanceSqToSegment(jo,Zo,il,Mf)>i)return;il.applyMatrix4(n.matrixWorld);const c=e.ray.origin.distanceTo(il);if(!(c<e.near||c>e.far))return{distance:c,point:Mf.clone().applyMatrix4(n.matrixWorld),index:o,face:null,faceIndex:null,barycoord:null,object:n}}class Qd extends rn{constructor(e=[],t=or,i,r,s,o,a,l,c,u){super(e,t,i,r,s,o,a,l,c,u),this.isCubeTexture=!0,this.flipY=!1}get images(){return this.image}set images(e){this.image=e}}class Vr extends rn{constructor(e,t,i=Yn,r,s,o,a=zt,l=zt,c,u=hi,h=1){if(u!==hi&&u!==tr)throw new Error("DepthTexture format must be either THREE.DepthFormat or THREE.DepthStencilFormat");const f={width:e,height:t,depth:h};super(f,r,s,o,a,l,u,i,c),this.isDepthTexture=!0,this.flipY=!1,this.generateMipmaps=!1,this.compareFunction=null}copy(e){return super.copy(e),this.source=new qc(Object.assign({},e.image)),this.compareFunction=e.compareFunction,this}toJSON(e){const t=super.toJSON(e);return this.compareFunction!==null&&(t.compareFunction=this.compareFunction),t}}class R0 extends Vr{constructor(e,t=Yn,i=or,r,s,o=zt,a=zt,l,c=hi){const u={width:e,height:e,depth:1},h=[u,u,u,u,u,u];super(e,e,t,i,r,s,o,a,l,c),this.image=h,this.isCubeDepthTexture=!0,this.isCubeTexture=!0}get images(){return this.image}set images(e){this.image=e}}class ep extends rn{constructor(e=null){super(),this.sourceTexture=e,this.isExternalTexture=!0}copy(e){return super.copy(e),this.sourceTexture=e.sourceTexture,this}}class Ct extends $t{constructor(e=1,t=1,i=1,r=1,s=1,o=1){super(),this.type="BoxGeometry",this.parameters={width:e,height:t,depth:i,widthSegments:r,heightSegments:s,depthSegments:o};const a=this;r=Math.floor(r),s=Math.floor(s),o=Math.floor(o);const l=[],c=[],u=[],h=[];let f=0,p=0;g("z","y","x",-1,-1,i,t,e,o,s,0),g("z","y","x",1,-1,i,t,-e,o,s,1),g("x","z","y",1,1,e,i,t,r,o,2),g("x","z","y",1,-1,e,i,-t,r,o,3),g("x","y","z",1,-1,e,t,i,r,s,4),g("x","y","z",-1,-1,e,t,-i,r,s,5),this.setIndex(l),this.setAttribute("position",new St(c,3)),this.setAttribute("normal",new St(u,3)),this.setAttribute("uv",new St(h,2));function g(M,m,d,x,y,S,C,A,P,v,T){const L=S/P,D=C/v,I=S/2,k=C/2,G=A/2,O=P+1,V=v+1;let H=0,$=0;const oe=new N;for(let ve=0;ve<V;ve++){const be=ve*D-k;for(let we=0;we<O;we++){const $e=we*L-I;oe[M]=$e*x,oe[m]=be*y,oe[d]=G,c.push(oe.x,oe.y,oe.z),oe[M]=0,oe[m]=0,oe[d]=A>0?1:-1,u.push(oe.x,oe.y,oe.z),h.push(we/P),h.push(1-ve/v),H+=1}}for(let ve=0;ve<v;ve++)for(let be=0;be<P;be++){const we=f+be+O*ve,$e=f+be+O*(ve+1),tt=f+(be+1)+O*(ve+1),We=f+(be+1)+O*ve;l.push(we,$e,We),l.push($e,tt,We),$+=6}a.addGroup(p,$,T),p+=$,f+=H}}copy(e){return super.copy(e),this.parameters=Object.assign({},e.parameters),this}static fromJSON(e){return new Ct(e.width,e.height,e.depth,e.widthSegments,e.heightSegments,e.depthSegments)}}class kt extends $t{constructor(e=1,t=1,i=1,r=32,s=1,o=!1,a=0,l=Math.PI*2){super(),this.type="CylinderGeometry",this.parameters={radiusTop:e,radiusBottom:t,height:i,radialSegments:r,heightSegments:s,openEnded:o,thetaStart:a,thetaLength:l};const c=this;r=Math.floor(r),s=Math.floor(s);const u=[],h=[],f=[],p=[];let g=0;const M=[],m=i/2;let d=0;x(),o===!1&&(e>0&&y(!0),t>0&&y(!1)),this.setIndex(u),this.setAttribute("position",new St(h,3)),this.setAttribute("normal",new St(f,3)),this.setAttribute("uv",new St(p,2));function x(){const S=new N,C=new N;let A=0;const P=(t-e)/i;for(let v=0;v<=s;v++){const T=[],L=v/s,D=L*(t-e)+e;for(let I=0;I<=r;I++){const k=I/r,G=k*l+a,O=Math.sin(G),V=Math.cos(G);C.x=D*O,C.y=-L*i+m,C.z=D*V,h.push(C.x,C.y,C.z),S.set(O,P,V).normalize(),f.push(S.x,S.y,S.z),p.push(k,1-L),T.push(g++)}M.push(T)}for(let v=0;v<r;v++)for(let T=0;T<s;T++){const L=M[T][v],D=M[T+1][v],I=M[T+1][v+1],k=M[T][v+1];(e>0||T!==0)&&(u.push(L,D,k),A+=3),(t>0||T!==s-1)&&(u.push(D,I,k),A+=3)}c.addGroup(d,A,0),d+=A}function y(S){const C=g,A=new st,P=new N;let v=0;const T=S===!0?e:t,L=S===!0?1:-1;for(let I=1;I<=r;I++)h.push(0,m*L,0),f.push(0,L,0),p.push(.5,.5),g++;const D=g;for(let I=0;I<=r;I++){const G=I/r*l+a,O=Math.cos(G),V=Math.sin(G);P.x=T*V,P.y=m*L,P.z=T*O,h.push(P.x,P.y,P.z),f.push(0,L,0),A.x=O*.5+.5,A.y=V*.5*L+.5,p.push(A.x,A.y),g++}for(let I=0;I<r;I++){const k=C+I,G=D+I;S===!0?u.push(G,G+1,k):u.push(G+1,G,k),v+=3}c.addGroup(d,v,S===!0?1:2),d+=v}}copy(e){return super.copy(e),this.parameters=Object.assign({},e.parameters),this}static fromJSON(e){return new kt(e.radiusTop,e.radiusBottom,e.height,e.radialSegments,e.heightSegments,e.openEnded,e.thetaStart,e.thetaLength)}}class Zc extends $t{constructor(e=[],t=[],i=1,r=0){super(),this.type="PolyhedronGeometry",this.parameters={vertices:e,indices:t,radius:i,detail:r};const s=[],o=[];a(r),c(i),u(),this.setAttribute("position",new St(s,3)),this.setAttribute("normal",new St(s.slice(),3)),this.setAttribute("uv",new St(o,2)),r===0?this.computeVertexNormals():this.normalizeNormals();function a(x){const y=new N,S=new N,C=new N;for(let A=0;A<t.length;A+=3)p(t[A+0],y),p(t[A+1],S),p(t[A+2],C),l(y,S,C,x)}function l(x,y,S,C){const A=C+1,P=[];for(let v=0;v<=A;v++){P[v]=[];const T=x.clone().lerp(S,v/A),L=y.clone().lerp(S,v/A),D=A-v;for(let I=0;I<=D;I++)I===0&&v===A?P[v][I]=T:P[v][I]=T.clone().lerp(L,I/D)}for(let v=0;v<A;v++)for(let T=0;T<2*(A-v)-1;T++){const L=Math.floor(T/2);T%2===0?(f(P[v][L+1]),f(P[v+1][L]),f(P[v][L])):(f(P[v][L+1]),f(P[v+1][L+1]),f(P[v+1][L]))}}function c(x){const y=new N;for(let S=0;S<s.length;S+=3)y.x=s[S+0],y.y=s[S+1],y.z=s[S+2],y.normalize().multiplyScalar(x),s[S+0]=y.x,s[S+1]=y.y,s[S+2]=y.z}function u(){const x=new N;for(let y=0;y<s.length;y+=3){x.x=s[y+0],x.y=s[y+1],x.z=s[y+2];const S=m(x)/2/Math.PI+.5,C=d(x)/Math.PI+.5;o.push(S,1-C)}g(),h()}function h(){for(let x=0;x<o.length;x+=6){const y=o[x+0],S=o[x+2],C=o[x+4],A=Math.max(y,S,C),P=Math.min(y,S,C);A>.9&&P<.1&&(y<.2&&(o[x+0]+=1),S<.2&&(o[x+2]+=1),C<.2&&(o[x+4]+=1))}}function f(x){s.push(x.x,x.y,x.z)}function p(x,y){const S=x*3;y.x=e[S+0],y.y=e[S+1],y.z=e[S+2]}function g(){const x=new N,y=new N,S=new N,C=new N,A=new st,P=new st,v=new st;for(let T=0,L=0;T<s.length;T+=9,L+=6){x.set(s[T+0],s[T+1],s[T+2]),y.set(s[T+3],s[T+4],s[T+5]),S.set(s[T+6],s[T+7],s[T+8]),A.set(o[L+0],o[L+1]),P.set(o[L+2],o[L+3]),v.set(o[L+4],o[L+5]),C.copy(x).add(y).add(S).divideScalar(3);const D=m(C);M(A,L+0,x,D),M(P,L+2,y,D),M(v,L+4,S,D)}}function M(x,y,S,C){C<0&&x.x===1&&(o[y]=x.x-1),S.x===0&&S.z===0&&(o[y]=C/2/Math.PI+.5)}function m(x){return Math.atan2(x.z,-x.x)}function d(x){return Math.atan2(-x.y,Math.sqrt(x.x*x.x+x.z*x.z))}}copy(e){return super.copy(e),this.parameters=Object.assign({},e.parameters),this}static fromJSON(e){return new Zc(e.vertices,e.indices,e.radius,e.detail)}}class Rr extends Zc{constructor(e=1,t=0){const i=[1,0,0,-1,0,0,0,1,0,0,-1,0,0,0,1,0,0,-1],r=[0,2,4,0,4,3,0,3,5,0,5,2,1,2,5,1,5,3,1,3,4,1,4,2];super(i,r,e,t),this.type="OctahedronGeometry",this.parameters={radius:e,detail:t}}static fromJSON(e){return new Rr(e.radius,e.detail)}}class Fs extends $t{constructor(e=1,t=1,i=1,r=1){super(),this.type="PlaneGeometry",this.parameters={width:e,height:t,widthSegments:i,heightSegments:r};const s=e/2,o=t/2,a=Math.floor(i),l=Math.floor(r),c=a+1,u=l+1,h=e/a,f=t/l,p=[],g=[],M=[],m=[];for(let d=0;d<u;d++){const x=d*f-o;for(let y=0;y<c;y++){const S=y*h-s;g.push(S,-x,0),M.push(0,0,1),m.push(y/a),m.push(1-d/l)}}for(let d=0;d<l;d++)for(let x=0;x<a;x++){const y=x+c*d,S=x+c*(d+1),C=x+1+c*(d+1),A=x+1+c*d;p.push(y,S,A),p.push(S,C,A)}this.setIndex(p),this.setAttribute("position",new St(g,3)),this.setAttribute("normal",new St(M,3)),this.setAttribute("uv",new St(m,2))}copy(e){return super.copy(e),this.parameters=Object.assign({},e.parameters),this}static fromJSON(e){return new Fs(e.width,e.height,e.widthSegments,e.heightSegments)}}class $c extends $t{constructor(e=1,t=32,i=16,r=0,s=Math.PI*2,o=0,a=Math.PI){super(),this.type="SphereGeometry",this.parameters={radius:e,widthSegments:t,heightSegments:i,phiStart:r,phiLength:s,thetaStart:o,thetaLength:a},t=Math.max(3,Math.floor(t)),i=Math.max(2,Math.floor(i));const l=Math.min(o+a,Math.PI);let c=0;const u=[],h=new N,f=new N,p=[],g=[],M=[],m=[];for(let d=0;d<=i;d++){const x=[],y=d/i;let S=0;d===0&&o===0?S=.5/t:d===i&&l===Math.PI&&(S=-.5/t);for(let C=0;C<=t;C++){const A=C/t;h.x=-e*Math.cos(r+A*s)*Math.sin(o+y*a),h.y=e*Math.cos(o+y*a),h.z=e*Math.sin(r+A*s)*Math.sin(o+y*a),g.push(h.x,h.y,h.z),f.copy(h).normalize(),M.push(f.x,f.y,f.z),m.push(A+S,1-y),x.push(c++)}u.push(x)}for(let d=0;d<i;d++)for(let x=0;x<t;x++){const y=u[d][x+1],S=u[d][x],C=u[d+1][x],A=u[d+1][x+1];(d!==0||o>0)&&p.push(y,S,A),(d!==i-1||l<Math.PI)&&p.push(S,C,A)}this.setIndex(p),this.setAttribute("position",new St(g,3)),this.setAttribute("normal",new St(M,3)),this.setAttribute("uv",new St(m,2))}copy(e){return super.copy(e),this.parameters=Object.assign({},e.parameters),this}static fromJSON(e){return new $c(e.radius,e.widthSegments,e.heightSegments,e.phiStart,e.phiLength,e.thetaStart,e.thetaLength)}}class Ji extends $t{constructor(e=1,t=.4,i=12,r=48,s=Math.PI*2,o=0,a=Math.PI*2){super(),this.type="TorusGeometry",this.parameters={radius:e,tube:t,radialSegments:i,tubularSegments:r,arc:s,thetaStart:o,thetaLength:a},i=Math.floor(i),r=Math.floor(r);const l=[],c=[],u=[],h=[],f=new N,p=new N,g=new N;for(let M=0;M<=i;M++){const m=o+M/i*a;for(let d=0;d<=r;d++){const x=d/r*s;p.x=(e+t*Math.cos(m))*Math.cos(x),p.y=(e+t*Math.cos(m))*Math.sin(x),p.z=t*Math.sin(m),c.push(p.x,p.y,p.z),f.x=e*Math.cos(x),f.y=e*Math.sin(x),g.subVectors(p,f).normalize(),u.push(g.x,g.y,g.z),h.push(d/r),h.push(M/i)}}for(let M=1;M<=i;M++)for(let m=1;m<=r;m++){const d=(r+1)*M+m-1,x=(r+1)*(M-1)+m-1,y=(r+1)*(M-1)+m,S=(r+1)*M+m;l.push(d,x,S),l.push(x,y,S)}this.setIndex(l),this.setAttribute("position",new St(c,3)),this.setAttribute("normal",new St(u,3)),this.setAttribute("uv",new St(h,2))}copy(e){return super.copy(e),this.parameters=Object.assign({},e.parameters),this}static fromJSON(e){return new Ji(e.radius,e.tube,e.radialSegments,e.tubularSegments,e.arc)}}function Gr(n){const e={};for(const t in n){e[t]={};for(const i in n[t]){const r=n[t][i];if(Sf(r))r.isRenderTargetTexture?(ze("UniformsUtils: Textures of render targets cannot be cloned via cloneUniforms() or mergeUniforms()."),e[t][i]=null):e[t][i]=r.clone();else if(Array.isArray(r))if(Sf(r[0])){const s=[];for(let o=0,a=r.length;o<a;o++)s[o]=r[o].clone();e[t][i]=s}else e[t][i]=r.slice();else e[t][i]=r}}return e}function en(n){const e={};for(let t=0;t<n.length;t++){const i=Gr(n[t]);for(const r in i)e[r]=i[r]}return e}function Sf(n){return n&&(n.isColor||n.isMatrix3||n.isMatrix4||n.isVector2||n.isVector3||n.isVector4||n.isTexture||n.isQuaternion)}function C0(n){const e=[];for(let t=0;t<n.length;t++)e.push(n[t].clone());return e}function tp(n){const e=n.getRenderTarget();return e===null?n.outputColorSpace:e.isXRRenderTarget===!0?e.texture.colorSpace:Qe.workingColorSpace}const P0={clone:Gr,merge:en};var D0=`void main() {
	gl_Position = projectionMatrix * modelViewMatrix * vec4( position, 1.0 );
}`,I0=`void main() {
	gl_FragColor = vec4( 1.0, 0.0, 0.0, 1.0 );
}`;class qn extends Ns{constructor(e){super(),this.isShaderMaterial=!0,this.type="ShaderMaterial",this.defines={},this.uniforms={},this.uniformsGroups=[],this.vertexShader=D0,this.fragmentShader=I0,this.linewidth=1,this.wireframe=!1,this.wireframeLinewidth=1,this.fog=!1,this.lights=!1,this.clipping=!1,this.forceSinglePass=!0,this.extensions={clipCullDistance:!1,multiDraw:!1},this.defaultAttributeValues={color:[1,1,1],uv:[0,0],uv1:[0,0]},this.index0AttributeName=void 0,this.uniformsNeedUpdate=!1,this.glslVersion=null,e!==void 0&&this.setValues(e)}copy(e){return super.copy(e),this.fragmentShader=e.fragmentShader,this.vertexShader=e.vertexShader,this.uniforms=Gr(e.uniforms),this.uniformsGroups=C0(e.uniformsGroups),this.defines=Object.assign({},e.defines),this.wireframe=e.wireframe,this.wireframeLinewidth=e.wireframeLinewidth,this.fog=e.fog,this.lights=e.lights,this.clipping=e.clipping,this.extensions=Object.assign({},e.extensions),this.glslVersion=e.glslVersion,this.defaultAttributeValues=Object.assign({},e.defaultAttributeValues),this.index0AttributeName=e.index0AttributeName,this.uniformsNeedUpdate=e.uniformsNeedUpdate,this}toJSON(e){const t=super.toJSON(e);t.glslVersion=this.glslVersion,t.uniforms={};for(const r in this.uniforms){const o=this.uniforms[r].value;o&&o.isTexture?t.uniforms[r]={type:"t",value:o.toJSON(e).uuid}:o&&o.isColor?t.uniforms[r]={type:"c",value:o.getHex()}:o&&o.isVector2?t.uniforms[r]={type:"v2",value:o.toArray()}:o&&o.isVector3?t.uniforms[r]={type:"v3",value:o.toArray()}:o&&o.isVector4?t.uniforms[r]={type:"v4",value:o.toArray()}:o&&o.isMatrix3?t.uniforms[r]={type:"m3",value:o.toArray()}:o&&o.isMatrix4?t.uniforms[r]={type:"m4",value:o.toArray()}:t.uniforms[r]={value:o}}Object.keys(this.defines).length>0&&(t.defines=this.defines),t.vertexShader=this.vertexShader,t.fragmentShader=this.fragmentShader,t.lights=this.lights,t.clipping=this.clipping;const i={};for(const r in this.extensions)this.extensions[r]===!0&&(i[r]=!0);return Object.keys(i).length>0&&(t.extensions=i),t}}class L0 extends qn{constructor(e){super(e),this.isRawShaderMaterial=!0,this.type="RawShaderMaterial"}}class U0 extends Ns{constructor(e){super(),this.isMeshDepthMaterial=!0,this.type="MeshDepthMaterial",this.depthPacking=I_,this.map=null,this.alphaMap=null,this.displacementMap=null,this.displacementScale=1,this.displacementBias=0,this.wireframe=!1,this.wireframeLinewidth=1,this.setValues(e)}copy(e){return super.copy(e),this.depthPacking=e.depthPacking,this.map=e.map,this.alphaMap=e.alphaMap,this.displacementMap=e.displacementMap,this.displacementScale=e.displacementScale,this.displacementBias=e.displacementBias,this.wireframe=e.wireframe,this.wireframeLinewidth=e.wireframeLinewidth,this}}class N0 extends Ns{constructor(e){super(),this.isMeshDistanceMaterial=!0,this.type="MeshDistanceMaterial",this.map=null,this.alphaMap=null,this.displacementMap=null,this.displacementScale=1,this.displacementBias=0,this.setValues(e)}copy(e){return super.copy(e),this.map=e.map,this.alphaMap=e.alphaMap,this.displacementMap=e.displacementMap,this.displacementScale=e.displacementScale,this.displacementBias=e.displacementBias,this}}class F0 extends Ft{constructor(e,t=1){super(),this.isLight=!0,this.type="Light",this.color=new lt(e),this.intensity=t}dispose(){this.dispatchEvent({type:"dispose"})}copy(e,t){return super.copy(e,t),this.color.copy(e.color),this.intensity=e.intensity,this}toJSON(e){const t=super.toJSON(e);return t.object.color=this.color.getHex(),t.object.intensity=this.intensity,t}}const fo=new N,ho=new Xt,Dn=new N;class np extends Ft{constructor(){super(),this.isCamera=!0,this.type="Camera",this.matrixWorldInverse=new Mt,this.projectionMatrix=new Mt,this.projectionMatrixInverse=new Mt,this.coordinateSystem=Vn,this._reversedDepth=!1}get reversedDepth(){return this._reversedDepth}copy(e,t){return super.copy(e,t),this.matrixWorldInverse.copy(e.matrixWorldInverse),this.projectionMatrix.copy(e.projectionMatrix),this.projectionMatrixInverse.copy(e.projectionMatrixInverse),this.coordinateSystem=e.coordinateSystem,this}getWorldDirection(e){return super.getWorldDirection(e).negate()}updateMatrixWorld(e){super.updateMatrixWorld(e),this.matrixWorld.decompose(fo,ho,Dn),Dn.x===1&&Dn.y===1&&Dn.z===1?this.matrixWorldInverse.copy(this.matrixWorld).invert():this.matrixWorldInverse.compose(fo,ho,Dn.set(1,1,1)).invert()}updateWorldMatrix(e,t){super.updateWorldMatrix(e,t),this.matrixWorld.decompose(fo,ho,Dn),Dn.x===1&&Dn.y===1&&Dn.z===1?this.matrixWorldInverse.copy(this.matrixWorld).invert():this.matrixWorldInverse.compose(fo,ho,Dn.set(1,1,1)).invert()}clone(){return new this.constructor().copy(this)}}const Ti=new N,Ef=new st,yf=new st;class yn extends np{constructor(e=50,t=1,i=.1,r=2e3){super(),this.isPerspectiveCamera=!0,this.type="PerspectiveCamera",this.fov=e,this.zoom=1,this.near=i,this.far=r,this.focus=10,this.aspect=t,this.view=null,this.filmGauge=35,this.filmOffset=0,this.updateProjectionMatrix()}copy(e,t){return super.copy(e,t),this.fov=e.fov,this.zoom=e.zoom,this.near=e.near,this.far=e.far,this.focus=e.focus,this.aspect=e.aspect,this.view=e.view===null?null:Object.assign({},e.view),this.filmGauge=e.filmGauge,this.filmOffset=e.filmOffset,this}setFocalLength(e){const t=.5*this.getFilmHeight()/e;this.fov=ws*2*Math.atan(t),this.updateProjectionMatrix()}getFocalLength(){const e=Math.tan(_s*.5*this.fov);return .5*this.getFilmHeight()/e}getEffectiveFOV(){return ws*2*Math.atan(Math.tan(_s*.5*this.fov)/this.zoom)}getFilmWidth(){return this.filmGauge*Math.min(this.aspect,1)}getFilmHeight(){return this.filmGauge/Math.max(this.aspect,1)}getViewBounds(e,t,i){Ti.set(-1,-1,.5).applyMatrix4(this.projectionMatrixInverse),t.set(Ti.x,Ti.y).multiplyScalar(-e/Ti.z),Ti.set(1,1,.5).applyMatrix4(this.projectionMatrixInverse),i.set(Ti.x,Ti.y).multiplyScalar(-e/Ti.z)}getViewSize(e,t){return this.getViewBounds(e,Ef,yf),t.subVectors(yf,Ef)}setViewOffset(e,t,i,r,s,o){this.aspect=e/t,this.view===null&&(this.view={enabled:!0,fullWidth:1,fullHeight:1,offsetX:0,offsetY:0,width:1,height:1}),this.view.enabled=!0,this.view.fullWidth=e,this.view.fullHeight=t,this.view.offsetX=i,this.view.offsetY=r,this.view.width=s,this.view.height=o,this.updateProjectionMatrix()}clearViewOffset(){this.view!==null&&(this.view.enabled=!1),this.updateProjectionMatrix()}updateProjectionMatrix(){const e=this.near;let t=e*Math.tan(_s*.5*this.fov)/this.zoom,i=2*t,r=this.aspect*i,s=-.5*r;const o=this.view;if(this.view!==null&&this.view.enabled){const l=o.fullWidth,c=o.fullHeight;s+=o.offsetX*r/l,t-=o.offsetY*i/c,r*=o.width/l,i*=o.height/c}const a=this.filmOffset;a!==0&&(s+=e*a/this.getFilmWidth()),this.projectionMatrix.makePerspective(s,s+r,t,t-i,e,this.far,this.coordinateSystem,this.reversedDepth),this.projectionMatrixInverse.copy(this.projectionMatrix).invert()}toJSON(e){const t=super.toJSON(e);return t.object.fov=this.fov,t.object.zoom=this.zoom,t.object.near=this.near,t.object.far=this.far,t.object.focus=this.focus,t.object.aspect=this.aspect,this.view!==null&&(t.object.view=Object.assign({},this.view)),t.object.filmGauge=this.filmGauge,t.object.filmOffset=this.filmOffset,t}}class ip extends np{constructor(e=-1,t=1,i=1,r=-1,s=.1,o=2e3){super(),this.isOrthographicCamera=!0,this.type="OrthographicCamera",this.zoom=1,this.view=null,this.left=e,this.right=t,this.top=i,this.bottom=r,this.near=s,this.far=o,this.updateProjectionMatrix()}copy(e,t){return super.copy(e,t),this.left=e.left,this.right=e.right,this.top=e.top,this.bottom=e.bottom,this.near=e.near,this.far=e.far,this.zoom=e.zoom,this.view=e.view===null?null:Object.assign({},e.view),this}setViewOffset(e,t,i,r,s,o){this.view===null&&(this.view={enabled:!0,fullWidth:1,fullHeight:1,offsetX:0,offsetY:0,width:1,height:1}),this.view.enabled=!0,this.view.fullWidth=e,this.view.fullHeight=t,this.view.offsetX=i,this.view.offsetY=r,this.view.width=s,this.view.height=o,this.updateProjectionMatrix()}clearViewOffset(){this.view!==null&&(this.view.enabled=!1),this.updateProjectionMatrix()}updateProjectionMatrix(){const e=(this.right-this.left)/(2*this.zoom),t=(this.top-this.bottom)/(2*this.zoom),i=(this.right+this.left)/2,r=(this.top+this.bottom)/2;let s=i-e,o=i+e,a=r+t,l=r-t;if(this.view!==null&&this.view.enabled){const c=(this.right-this.left)/this.view.fullWidth/this.zoom,u=(this.top-this.bottom)/this.view.fullHeight/this.zoom;s+=c*this.view.offsetX,o=s+c*this.view.width,a-=u*this.view.offsetY,l=a-u*this.view.height}this.projectionMatrix.makeOrthographic(s,o,a,l,this.near,this.far,this.coordinateSystem,this.reversedDepth),this.projectionMatrixInverse.copy(this.projectionMatrix).invert()}toJSON(e){const t=super.toJSON(e);return t.object.zoom=this.zoom,t.object.left=this.left,t.object.right=this.right,t.object.top=this.top,t.object.bottom=this.bottom,t.object.near=this.near,t.object.far=this.far,this.view!==null&&(t.object.view=Object.assign({},this.view)),t}}class Ey extends F0{constructor(e,t){super(e,t),this.isAmbientLight=!0,this.type="AmbientLight"}}const yr=-90,br=1;class O0 extends Ft{constructor(e,t,i){super(),this.type="CubeCamera",this.renderTarget=i,this.coordinateSystem=null,this.activeMipmapLevel=0;const r=new yn(yr,br,e,t);r.layers=this.layers,this.add(r);const s=new yn(yr,br,e,t);s.layers=this.layers,this.add(s);const o=new yn(yr,br,e,t);o.layers=this.layers,this.add(o);const a=new yn(yr,br,e,t);a.layers=this.layers,this.add(a);const l=new yn(yr,br,e,t);l.layers=this.layers,this.add(l);const c=new yn(yr,br,e,t);c.layers=this.layers,this.add(c)}updateCoordinateSystem(){const e=this.coordinateSystem,t=this.children.concat(),[i,r,s,o,a,l]=t;for(const c of t)this.remove(c);if(e===Vn)i.up.set(0,1,0),i.lookAt(1,0,0),r.up.set(0,1,0),r.lookAt(-1,0,0),s.up.set(0,0,-1),s.lookAt(0,1,0),o.up.set(0,0,1),o.lookAt(0,-1,0),a.up.set(0,1,0),a.lookAt(0,0,1),l.up.set(0,1,0),l.lookAt(0,0,-1);else if(e===qo)i.up.set(0,-1,0),i.lookAt(-1,0,0),r.up.set(0,-1,0),r.lookAt(1,0,0),s.up.set(0,0,1),s.lookAt(0,1,0),o.up.set(0,0,-1),o.lookAt(0,-1,0),a.up.set(0,-1,0),a.lookAt(0,0,1),l.up.set(0,-1,0),l.lookAt(0,0,-1);else throw new Error("THREE.CubeCamera.updateCoordinateSystem(): Invalid coordinate system: "+e);for(const c of t)this.add(c),c.updateMatrixWorld()}update(e,t){this.parent===null&&this.updateMatrixWorld();const{renderTarget:i,activeMipmapLevel:r}=this;this.coordinateSystem!==e.coordinateSystem&&(this.coordinateSystem=e.coordinateSystem,this.updateCoordinateSystem());const[s,o,a,l,c,u]=this.children,h=e.getRenderTarget(),f=e.getActiveCubeFace(),p=e.getActiveMipmapLevel(),g=e.xr.enabled;e.xr.enabled=!1;const M=i.texture.generateMipmaps;i.texture.generateMipmaps=!1;let m=!1;e.isWebGLRenderer===!0?m=e.state.buffers.depth.getReversed():m=e.reversedDepthBuffer,e.setRenderTarget(i,0,r),m&&e.autoClear===!1&&e.clearDepth(),e.render(t,s),e.setRenderTarget(i,1,r),m&&e.autoClear===!1&&e.clearDepth(),e.render(t,o),e.setRenderTarget(i,2,r),m&&e.autoClear===!1&&e.clearDepth(),e.render(t,a),e.setRenderTarget(i,3,r),m&&e.autoClear===!1&&e.clearDepth(),e.render(t,l),e.setRenderTarget(i,4,r),m&&e.autoClear===!1&&e.clearDepth(),e.render(t,c),i.texture.generateMipmaps=M,e.setRenderTarget(i,5,r),m&&e.autoClear===!1&&e.clearDepth(),e.render(t,u),e.setRenderTarget(h,f,p),e.xr.enabled=g,i.texture.needsPMREMUpdate=!0}}class B0 extends yn{constructor(e=[]){super(),this.isArrayCamera=!0,this.isMultiViewCamera=!1,this.cameras=e}}const bf=new Mt;class z0{constructor(e,t,i=0,r=1/0){this.ray=new jc(e,t),this.near=i,this.far=r,this.camera=null,this.layers=new Kc,this.params={Mesh:{},Line:{threshold:1},LOD:{},Points:{threshold:1},Sprite:{}}}set(e,t){this.ray.set(e,t)}setFromCamera(e,t){t.isPerspectiveCamera?(this.ray.origin.setFromMatrixPosition(t.matrixWorld),this.ray.direction.set(e.x,e.y,.5).unproject(t).sub(this.ray.origin).normalize(),this.camera=t):t.isOrthographicCamera?(this.ray.origin.set(e.x,e.y,(t.near+t.far)/(t.near-t.far)).unproject(t),this.ray.direction.set(0,0,-1).transformDirection(t.matrixWorld),this.camera=t):et("Raycaster: Unsupported camera type: "+t.type)}setFromXRController(e){return bf.identity().extractRotation(e.matrixWorld),this.ray.origin.setFromMatrixPosition(e.matrixWorld),this.ray.direction.set(0,0,-1).applyMatrix4(bf),this}intersectObject(e,t=!0,i=[]){return mc(e,this,i,t),i.sort(Tf),i}intersectObjects(e,t=!0,i=[]){for(let r=0,s=e.length;r<s;r++)mc(e[r],this,i,t);return i.sort(Tf),i}}function Tf(n,e){return n.distance-e.distance}function mc(n,e,t,i){let r=!0;if(n.layers.test(e.layers)&&n.raycast(e,t)===!1&&(r=!1),r===!0&&i===!0){const s=n.children;for(let o=0,a=s.length;o<a;o++)mc(s[o],e,t,!0)}}class rp{static{rp.prototype.isMatrix2=!0}constructor(e,t,i,r){this.elements=[1,0,0,1],e!==void 0&&this.set(e,t,i,r)}identity(){return this.set(1,0,0,1),this}fromArray(e,t=0){for(let i=0;i<4;i++)this.elements[i]=e[i+t];return this}set(e,t,i,r){const s=this.elements;return s[0]=e,s[2]=t,s[1]=i,s[3]=r,this}}class H0 extends Ni{constructor(e,t=null){super(),this.object=e,this.domElement=t,this.enabled=!0,this.state=-1,this.keys={},this.mouseButtons={LEFT:null,MIDDLE:null,RIGHT:null},this.touches={ONE:null,TWO:null}}connect(e){if(e===void 0){ze("Controls: connect() now requires an element.");return}this.domElement!==null&&this.disconnect(),this.domElement=e}disconnect(){}dispose(){}update(){}}function Af(n,e,t,i){const r=V0(i);switch(t){case kd:return n*e;case Xd:return n*e/r.components*r.byteLength;case Vc:return n*e/r.components*r.byteLength;case ar:return n*e*2/r.components*r.byteLength;case Gc:return n*e*2/r.components*r.byteLength;case Wd:return n*e*3/r.components*r.byteLength;case Tn:return n*e*4/r.components*r.byteLength;case kc:return n*e*4/r.components*r.byteLength;case To:case Ao:return Math.floor((n+3)/4)*Math.floor((e+3)/4)*8;case wo:case Ro:return Math.floor((n+3)/4)*Math.floor((e+3)/4)*16;case zl:case Vl:return Math.max(n,16)*Math.max(e,8)/4;case Bl:case Hl:return Math.max(n,8)*Math.max(e,8)/2;case Gl:case kl:case Xl:case Yl:return Math.floor((n+3)/4)*Math.floor((e+3)/4)*8;case Wl:case ko:case ql:return Math.floor((n+3)/4)*Math.floor((e+3)/4)*16;case Kl:return Math.floor((n+3)/4)*Math.floor((e+3)/4)*16;case jl:return Math.floor((n+4)/5)*Math.floor((e+3)/4)*16;case Zl:return Math.floor((n+4)/5)*Math.floor((e+4)/5)*16;case $l:return Math.floor((n+5)/6)*Math.floor((e+4)/5)*16;case Jl:return Math.floor((n+5)/6)*Math.floor((e+5)/6)*16;case Ql:return Math.floor((n+7)/8)*Math.floor((e+4)/5)*16;case ec:return Math.floor((n+7)/8)*Math.floor((e+5)/6)*16;case tc:return Math.floor((n+7)/8)*Math.floor((e+7)/8)*16;case nc:return Math.floor((n+9)/10)*Math.floor((e+4)/5)*16;case ic:return Math.floor((n+9)/10)*Math.floor((e+5)/6)*16;case rc:return Math.floor((n+9)/10)*Math.floor((e+7)/8)*16;case sc:return Math.floor((n+9)/10)*Math.floor((e+9)/10)*16;case oc:return Math.floor((n+11)/12)*Math.floor((e+9)/10)*16;case ac:return Math.floor((n+11)/12)*Math.floor((e+11)/12)*16;case lc:case cc:case uc:return Math.ceil(n/4)*Math.ceil(e/4)*16;case fc:case hc:return Math.ceil(n/4)*Math.ceil(e/4)*8;case Wo:case dc:return Math.ceil(n/4)*Math.ceil(e/4)*16}throw new Error(`Unable to determine texture byte length for ${t} format.`)}function V0(n){switch(n){case xn:case zd:return{byteLength:1,components:1};case Ts:case Hd:case fi:return{byteLength:2,components:1};case zc:case Hc:return{byteLength:2,components:4};case Yn:case Bc:case Hn:return{byteLength:4,components:1};case Vd:case Gd:return{byteLength:4,components:3}}throw new Error(`Unknown texture type ${n}.`)}typeof __THREE_DEVTOOLS__<"u"&&__THREE_DEVTOOLS__.dispatchEvent(new CustomEvent("register",{detail:{revision:Oc}}));typeof window<"u"&&(window.__THREE__?ze("WARNING: Multiple instances of Three.js being imported."):window.__THREE__=Oc);function sp(){let n=null,e=!1,t=null,i=null;function r(s,o){t(s,o),i=n.requestAnimationFrame(r)}return{start:function(){e!==!0&&t!==null&&n!==null&&(i=n.requestAnimationFrame(r),e=!0)},stop:function(){n!==null&&n.cancelAnimationFrame(i),e=!1},setAnimationLoop:function(s){t=s},setContext:function(s){n=s}}}function G0(n){const e=new WeakMap;function t(a,l){const c=a.array,u=a.usage,h=c.byteLength,f=n.createBuffer();n.bindBuffer(l,f),n.bufferData(l,c,u),a.onUploadCallback();let p;if(c instanceof Float32Array)p=n.FLOAT;else if(typeof Float16Array<"u"&&c instanceof Float16Array)p=n.HALF_FLOAT;else if(c instanceof Uint16Array)a.isFloat16BufferAttribute?p=n.HALF_FLOAT:p=n.UNSIGNED_SHORT;else if(c instanceof Int16Array)p=n.SHORT;else if(c instanceof Uint32Array)p=n.UNSIGNED_INT;else if(c instanceof Int32Array)p=n.INT;else if(c instanceof Int8Array)p=n.BYTE;else if(c instanceof Uint8Array)p=n.UNSIGNED_BYTE;else if(c instanceof Uint8ClampedArray)p=n.UNSIGNED_BYTE;else throw new Error("THREE.WebGLAttributes: Unsupported buffer data format: "+c);return{buffer:f,type:p,bytesPerElement:c.BYTES_PER_ELEMENT,version:a.version,size:h}}function i(a,l,c){const u=l.array,h=l.updateRanges;if(n.bindBuffer(c,a),h.length===0)n.bufferSubData(c,0,u);else{h.sort((p,g)=>p.start-g.start);let f=0;for(let p=1;p<h.length;p++){const g=h[f],M=h[p];M.start<=g.start+g.count+1?g.count=Math.max(g.count,M.start+M.count-g.start):(++f,h[f]=M)}h.length=f+1;for(let p=0,g=h.length;p<g;p++){const M=h[p];n.bufferSubData(c,M.start*u.BYTES_PER_ELEMENT,u,M.start,M.count)}l.clearUpdateRanges()}l.onUploadCallback()}function r(a){return a.isInterleavedBufferAttribute&&(a=a.data),e.get(a)}function s(a){a.isInterleavedBufferAttribute&&(a=a.data);const l=e.get(a);l&&(n.deleteBuffer(l.buffer),e.delete(a))}function o(a,l){if(a.isInterleavedBufferAttribute&&(a=a.data),a.isGLBufferAttribute){const u=e.get(a);(!u||u.version<a.version)&&e.set(a,{buffer:a.buffer,type:a.type,bytesPerElement:a.elementSize,version:a.version});return}const c=e.get(a);if(c===void 0)e.set(a,t(a,l));else if(c.version<a.version){if(c.size!==a.array.byteLength)throw new Error("THREE.WebGLAttributes: The size of the buffer attribute's array buffer does not match the original size. Resizing buffer attributes is not supported.");i(c.buffer,a,l),c.version=a.version}}return{get:r,remove:s,update:o}}var k0=`#ifdef USE_ALPHAHASH
	if ( diffuseColor.a < getAlphaHashThreshold( vPosition ) ) discard;
#endif`,W0=`#ifdef USE_ALPHAHASH
	const float ALPHA_HASH_SCALE = 0.05;
	float hash2D( vec2 value ) {
		return fract( 1.0e4 * sin( 17.0 * value.x + 0.1 * value.y ) * ( 0.1 + abs( sin( 13.0 * value.y + value.x ) ) ) );
	}
	float hash3D( vec3 value ) {
		return hash2D( vec2( hash2D( value.xy ), value.z ) );
	}
	float getAlphaHashThreshold( vec3 position ) {
		float maxDeriv = max(
			length( dFdx( position.xyz ) ),
			length( dFdy( position.xyz ) )
		);
		float pixScale = 1.0 / ( ALPHA_HASH_SCALE * maxDeriv );
		vec2 pixScales = vec2(
			exp2( floor( log2( pixScale ) ) ),
			exp2( ceil( log2( pixScale ) ) )
		);
		vec2 alpha = vec2(
			hash3D( floor( pixScales.x * position.xyz ) ),
			hash3D( floor( pixScales.y * position.xyz ) )
		);
		float lerpFactor = fract( log2( pixScale ) );
		float x = ( 1.0 - lerpFactor ) * alpha.x + lerpFactor * alpha.y;
		float a = min( lerpFactor, 1.0 - lerpFactor );
		vec3 cases = vec3(
			x * x / ( 2.0 * a * ( 1.0 - a ) ),
			( x - 0.5 * a ) / ( 1.0 - a ),
			1.0 - ( ( 1.0 - x ) * ( 1.0 - x ) / ( 2.0 * a * ( 1.0 - a ) ) )
		);
		float threshold = ( x < ( 1.0 - a ) )
			? ( ( x < a ) ? cases.x : cases.y )
			: cases.z;
		return clamp( threshold , 1.0e-6, 1.0 );
	}
#endif`,X0=`#ifdef USE_ALPHAMAP
	diffuseColor.a *= texture2D( alphaMap, vAlphaMapUv ).g;
#endif`,Y0=`#ifdef USE_ALPHAMAP
	uniform sampler2D alphaMap;
#endif`,q0=`#ifdef USE_ALPHATEST
	#ifdef ALPHA_TO_COVERAGE
	diffuseColor.a = smoothstep( alphaTest, alphaTest + fwidth( diffuseColor.a ), diffuseColor.a );
	if ( diffuseColor.a == 0.0 ) discard;
	#else
	if ( diffuseColor.a < alphaTest ) discard;
	#endif
#endif`,K0=`#ifdef USE_ALPHATEST
	uniform float alphaTest;
#endif`,j0=`#ifdef USE_AOMAP
	float ambientOcclusion = ( texture2D( aoMap, vAoMapUv ).r - 1.0 ) * aoMapIntensity + 1.0;
	reflectedLight.indirectDiffuse *= ambientOcclusion;
	#if defined( USE_CLEARCOAT ) 
		clearcoatSpecularIndirect *= ambientOcclusion;
	#endif
	#if defined( USE_SHEEN ) 
		sheenSpecularIndirect *= ambientOcclusion;
	#endif
	#if defined( USE_ENVMAP ) && defined( STANDARD )
		float dotNV = saturate( dot( geometryNormal, geometryViewDir ) );
		reflectedLight.indirectSpecular *= computeSpecularOcclusion( dotNV, ambientOcclusion, material.roughness );
	#endif
#endif`,Z0=`#ifdef USE_AOMAP
	uniform sampler2D aoMap;
	uniform float aoMapIntensity;
#endif`,$0=`#ifdef USE_BATCHING
	#if ! defined( GL_ANGLE_multi_draw )
	#define gl_DrawID _gl_DrawID
	uniform int _gl_DrawID;
	#endif
	uniform highp sampler2D batchingTexture;
	uniform highp usampler2D batchingIdTexture;
	mat4 getBatchingMatrix( const in float i ) {
		int size = textureSize( batchingTexture, 0 ).x;
		int j = int( i ) * 4;
		int x = j % size;
		int y = j / size;
		vec4 v1 = texelFetch( batchingTexture, ivec2( x, y ), 0 );
		vec4 v2 = texelFetch( batchingTexture, ivec2( x + 1, y ), 0 );
		vec4 v3 = texelFetch( batchingTexture, ivec2( x + 2, y ), 0 );
		vec4 v4 = texelFetch( batchingTexture, ivec2( x + 3, y ), 0 );
		return mat4( v1, v2, v3, v4 );
	}
	float getIndirectIndex( const in int i ) {
		int size = textureSize( batchingIdTexture, 0 ).x;
		int x = i % size;
		int y = i / size;
		return float( texelFetch( batchingIdTexture, ivec2( x, y ), 0 ).r );
	}
#endif
#ifdef USE_BATCHING_COLOR
	uniform sampler2D batchingColorTexture;
	vec4 getBatchingColor( const in float i ) {
		int size = textureSize( batchingColorTexture, 0 ).x;
		int j = int( i );
		int x = j % size;
		int y = j / size;
		return texelFetch( batchingColorTexture, ivec2( x, y ), 0 );
	}
#endif`,J0=`#ifdef USE_BATCHING
	mat4 batchingMatrix = getBatchingMatrix( getIndirectIndex( gl_DrawID ) );
#endif`,Q0=`vec3 transformed = vec3( position );
#ifdef USE_ALPHAHASH
	vPosition = vec3( position );
#endif`,ex=`vec3 objectNormal = vec3( normal );
#ifdef USE_TANGENT
	vec3 objectTangent = vec3( tangent.xyz );
#endif`,tx=`float G_BlinnPhong_Implicit( ) {
	return 0.25;
}
float D_BlinnPhong( const in float shininess, const in float dotNH ) {
	return RECIPROCAL_PI * ( shininess * 0.5 + 1.0 ) * pow( dotNH, shininess );
}
vec3 BRDF_BlinnPhong( const in vec3 lightDir, const in vec3 viewDir, const in vec3 normal, const in vec3 specularColor, const in float shininess ) {
	vec3 halfDir = normalize( lightDir + viewDir );
	float dotNH = saturate( dot( normal, halfDir ) );
	float dotVH = saturate( dot( viewDir, halfDir ) );
	vec3 F = F_Schlick( specularColor, 1.0, dotVH );
	float G = G_BlinnPhong_Implicit( );
	float D = D_BlinnPhong( shininess, dotNH );
	return F * ( G * D );
} // validated`,nx=`#ifdef USE_IRIDESCENCE
	const mat3 XYZ_TO_REC709 = mat3(
		 3.2404542, -0.9692660,  0.0556434,
		-1.5371385,  1.8760108, -0.2040259,
		-0.4985314,  0.0415560,  1.0572252
	);
	vec3 Fresnel0ToIor( vec3 fresnel0 ) {
		vec3 sqrtF0 = sqrt( fresnel0 );
		return ( vec3( 1.0 ) + sqrtF0 ) / ( vec3( 1.0 ) - sqrtF0 );
	}
	vec3 IorToFresnel0( vec3 transmittedIor, float incidentIor ) {
		return pow2( ( transmittedIor - vec3( incidentIor ) ) / ( transmittedIor + vec3( incidentIor ) ) );
	}
	float IorToFresnel0( float transmittedIor, float incidentIor ) {
		return pow2( ( transmittedIor - incidentIor ) / ( transmittedIor + incidentIor ));
	}
	vec3 evalSensitivity( float OPD, vec3 shift ) {
		float phase = 2.0 * PI * OPD * 1.0e-9;
		vec3 val = vec3( 5.4856e-13, 4.4201e-13, 5.2481e-13 );
		vec3 pos = vec3( 1.6810e+06, 1.7953e+06, 2.2084e+06 );
		vec3 var = vec3( 4.3278e+09, 9.3046e+09, 6.6121e+09 );
		vec3 xyz = val * sqrt( 2.0 * PI * var ) * cos( pos * phase + shift ) * exp( - pow2( phase ) * var );
		xyz.x += 9.7470e-14 * sqrt( 2.0 * PI * 4.5282e+09 ) * cos( 2.2399e+06 * phase + shift[ 0 ] ) * exp( - 4.5282e+09 * pow2( phase ) );
		xyz /= 1.0685e-7;
		vec3 rgb = XYZ_TO_REC709 * xyz;
		return rgb;
	}
	vec3 evalIridescence( float outsideIOR, float eta2, float cosTheta1, float thinFilmThickness, vec3 baseF0 ) {
		vec3 I;
		float iridescenceIOR = mix( outsideIOR, eta2, smoothstep( 0.0, 0.03, thinFilmThickness ) );
		float sinTheta2Sq = pow2( outsideIOR / iridescenceIOR ) * ( 1.0 - pow2( cosTheta1 ) );
		float cosTheta2Sq = 1.0 - sinTheta2Sq;
		if ( cosTheta2Sq < 0.0 ) {
			return vec3( 1.0 );
		}
		float cosTheta2 = sqrt( cosTheta2Sq );
		float R0 = IorToFresnel0( iridescenceIOR, outsideIOR );
		float R12 = F_Schlick( R0, 1.0, cosTheta1 );
		float T121 = 1.0 - R12;
		float phi12 = 0.0;
		if ( iridescenceIOR < outsideIOR ) phi12 = PI;
		float phi21 = PI - phi12;
		vec3 baseIOR = Fresnel0ToIor( clamp( baseF0, 0.0, 0.9999 ) );		vec3 R1 = IorToFresnel0( baseIOR, iridescenceIOR );
		vec3 R23 = F_Schlick( R1, 1.0, cosTheta2 );
		vec3 phi23 = vec3( 0.0 );
		if ( baseIOR[ 0 ] < iridescenceIOR ) phi23[ 0 ] = PI;
		if ( baseIOR[ 1 ] < iridescenceIOR ) phi23[ 1 ] = PI;
		if ( baseIOR[ 2 ] < iridescenceIOR ) phi23[ 2 ] = PI;
		float OPD = 2.0 * iridescenceIOR * thinFilmThickness * cosTheta2;
		vec3 phi = vec3( phi21 ) + phi23;
		vec3 R123 = clamp( R12 * R23, 1e-5, 0.9999 );
		vec3 r123 = sqrt( R123 );
		vec3 Rs = pow2( T121 ) * R23 / ( vec3( 1.0 ) - R123 );
		vec3 C0 = R12 + Rs;
		I = C0;
		vec3 Cm = Rs - T121;
		for ( int m = 1; m <= 2; ++ m ) {
			Cm *= r123;
			vec3 Sm = 2.0 * evalSensitivity( float( m ) * OPD, float( m ) * phi );
			I += Cm * Sm;
		}
		return max( I, vec3( 0.0 ) );
	}
#endif`,ix=`#ifdef USE_BUMPMAP
	uniform sampler2D bumpMap;
	uniform float bumpScale;
	vec2 dHdxy_fwd() {
		vec2 dSTdx = dFdx( vBumpMapUv );
		vec2 dSTdy = dFdy( vBumpMapUv );
		float Hll = bumpScale * texture2D( bumpMap, vBumpMapUv ).x;
		float dBx = bumpScale * texture2D( bumpMap, vBumpMapUv + dSTdx ).x - Hll;
		float dBy = bumpScale * texture2D( bumpMap, vBumpMapUv + dSTdy ).x - Hll;
		return vec2( dBx, dBy );
	}
	vec3 perturbNormalArb( vec3 surf_pos, vec3 surf_norm, vec2 dHdxy, float faceDirection ) {
		vec3 vSigmaX = normalize( dFdx( surf_pos.xyz ) );
		vec3 vSigmaY = normalize( dFdy( surf_pos.xyz ) );
		vec3 vN = surf_norm;
		vec3 R1 = cross( vSigmaY, vN );
		vec3 R2 = cross( vN, vSigmaX );
		float fDet = dot( vSigmaX, R1 ) * faceDirection;
		vec3 vGrad = sign( fDet ) * ( dHdxy.x * R1 + dHdxy.y * R2 );
		return normalize( abs( fDet ) * surf_norm - vGrad );
	}
#endif`,rx=`#if NUM_CLIPPING_PLANES > 0
	vec4 plane;
	#ifdef ALPHA_TO_COVERAGE
		float distanceToPlane, distanceGradient;
		float clipOpacity = 1.0;
		#pragma unroll_loop_start
		for ( int i = 0; i < UNION_CLIPPING_PLANES; i ++ ) {
			plane = clippingPlanes[ i ];
			distanceToPlane = - dot( vClipPosition, plane.xyz ) + plane.w;
			distanceGradient = fwidth( distanceToPlane ) / 2.0;
			clipOpacity *= smoothstep( - distanceGradient, distanceGradient, distanceToPlane );
			if ( clipOpacity == 0.0 ) discard;
		}
		#pragma unroll_loop_end
		#if UNION_CLIPPING_PLANES < NUM_CLIPPING_PLANES
			float unionClipOpacity = 1.0;
			#pragma unroll_loop_start
			for ( int i = UNION_CLIPPING_PLANES; i < NUM_CLIPPING_PLANES; i ++ ) {
				plane = clippingPlanes[ i ];
				distanceToPlane = - dot( vClipPosition, plane.xyz ) + plane.w;
				distanceGradient = fwidth( distanceToPlane ) / 2.0;
				unionClipOpacity *= 1.0 - smoothstep( - distanceGradient, distanceGradient, distanceToPlane );
			}
			#pragma unroll_loop_end
			clipOpacity *= 1.0 - unionClipOpacity;
		#endif
		diffuseColor.a *= clipOpacity;
		if ( diffuseColor.a == 0.0 ) discard;
	#else
		#pragma unroll_loop_start
		for ( int i = 0; i < UNION_CLIPPING_PLANES; i ++ ) {
			plane = clippingPlanes[ i ];
			if ( dot( vClipPosition, plane.xyz ) > plane.w ) discard;
		}
		#pragma unroll_loop_end
		#if UNION_CLIPPING_PLANES < NUM_CLIPPING_PLANES
			bool clipped = true;
			#pragma unroll_loop_start
			for ( int i = UNION_CLIPPING_PLANES; i < NUM_CLIPPING_PLANES; i ++ ) {
				plane = clippingPlanes[ i ];
				clipped = ( dot( vClipPosition, plane.xyz ) > plane.w ) && clipped;
			}
			#pragma unroll_loop_end
			if ( clipped ) discard;
		#endif
	#endif
#endif`,sx=`#if NUM_CLIPPING_PLANES > 0
	varying vec3 vClipPosition;
	uniform vec4 clippingPlanes[ NUM_CLIPPING_PLANES ];
#endif`,ox=`#if NUM_CLIPPING_PLANES > 0
	varying vec3 vClipPosition;
#endif`,ax=`#if NUM_CLIPPING_PLANES > 0
	vClipPosition = - mvPosition.xyz;
#endif`,lx=`#if defined( USE_COLOR ) || defined( USE_COLOR_ALPHA )
	diffuseColor *= vColor;
#endif`,cx=`#if defined( USE_COLOR ) || defined( USE_COLOR_ALPHA )
	varying vec4 vColor;
#endif`,ux=`#if defined( USE_COLOR ) || defined( USE_COLOR_ALPHA ) || defined( USE_INSTANCING_COLOR ) || defined( USE_BATCHING_COLOR )
	varying vec4 vColor;
#endif`,fx=`#if defined( USE_COLOR ) || defined( USE_COLOR_ALPHA ) || defined( USE_INSTANCING_COLOR ) || defined( USE_BATCHING_COLOR )
	vColor = vec4( 1.0 );
#endif
#ifdef USE_COLOR_ALPHA
	vColor *= color;
#elif defined( USE_COLOR )
	vColor.rgb *= color;
#endif
#ifdef USE_INSTANCING_COLOR
	vColor.rgb *= instanceColor.rgb;
#endif
#ifdef USE_BATCHING_COLOR
	vColor *= getBatchingColor( getIndirectIndex( gl_DrawID ) );
#endif`,hx=`#define PI 3.141592653589793
#define PI2 6.283185307179586
#define PI_HALF 1.5707963267948966
#define RECIPROCAL_PI 0.3183098861837907
#define RECIPROCAL_PI2 0.15915494309189535
#define EPSILON 1e-6
#ifndef saturate
#define saturate( a ) clamp( a, 0.0, 1.0 )
#endif
#define whiteComplement( a ) ( 1.0 - saturate( a ) )
float pow2( const in float x ) { return x*x; }
vec3 pow2( const in vec3 x ) { return x*x; }
float pow3( const in float x ) { return x*x*x; }
float pow4( const in float x ) { float x2 = x*x; return x2*x2; }
float max3( const in vec3 v ) { return max( max( v.x, v.y ), v.z ); }
float average( const in vec3 v ) { return dot( v, vec3( 0.3333333 ) ); }
highp float rand( const in vec2 uv ) {
	const highp float a = 12.9898, b = 78.233, c = 43758.5453;
	highp float dt = dot( uv.xy, vec2( a,b ) ), sn = mod( dt, PI );
	return fract( sin( sn ) * c );
}
#ifdef HIGH_PRECISION
	float precisionSafeLength( vec3 v ) { return length( v ); }
#else
	float precisionSafeLength( vec3 v ) {
		float maxComponent = max3( abs( v ) );
		return length( v / maxComponent ) * maxComponent;
	}
#endif
struct IncidentLight {
	vec3 color;
	vec3 direction;
	bool visible;
};
struct ReflectedLight {
	vec3 directDiffuse;
	vec3 directSpecular;
	vec3 indirectDiffuse;
	vec3 indirectSpecular;
};
#ifdef USE_ALPHAHASH
	varying vec3 vPosition;
#endif
vec3 transformDirection( in vec3 dir, in mat4 matrix ) {
	return normalize( ( matrix * vec4( dir, 0.0 ) ).xyz );
}
vec3 inverseTransformDirection( in vec3 dir, in mat4 matrix ) {
	return normalize( ( vec4( dir, 0.0 ) * matrix ).xyz );
}
bool isPerspectiveMatrix( mat4 m ) {
	return m[ 2 ][ 3 ] == - 1.0;
}
vec2 equirectUv( in vec3 dir ) {
	float u = atan( dir.z, dir.x ) * RECIPROCAL_PI2 + 0.5;
	float v = asin( clamp( dir.y, - 1.0, 1.0 ) ) * RECIPROCAL_PI + 0.5;
	return vec2( u, v );
}
vec3 BRDF_Lambert( const in vec3 diffuseColor ) {
	return RECIPROCAL_PI * diffuseColor;
}
vec3 F_Schlick( const in vec3 f0, const in float f90, const in float dotVH ) {
	float fresnel = exp2( ( - 5.55473 * dotVH - 6.98316 ) * dotVH );
	return f0 * ( 1.0 - fresnel ) + ( f90 * fresnel );
}
float F_Schlick( const in float f0, const in float f90, const in float dotVH ) {
	float fresnel = exp2( ( - 5.55473 * dotVH - 6.98316 ) * dotVH );
	return f0 * ( 1.0 - fresnel ) + ( f90 * fresnel );
} // validated`,dx=`#ifdef ENVMAP_TYPE_CUBE_UV
	#define cubeUV_minMipLevel 4.0
	#define cubeUV_minTileSize 16.0
	float getFace( vec3 direction ) {
		vec3 absDirection = abs( direction );
		float face = - 1.0;
		if ( absDirection.x > absDirection.z ) {
			if ( absDirection.x > absDirection.y )
				face = direction.x > 0.0 ? 0.0 : 3.0;
			else
				face = direction.y > 0.0 ? 1.0 : 4.0;
		} else {
			if ( absDirection.z > absDirection.y )
				face = direction.z > 0.0 ? 2.0 : 5.0;
			else
				face = direction.y > 0.0 ? 1.0 : 4.0;
		}
		return face;
	}
	vec2 getUV( vec3 direction, float face ) {
		vec2 uv;
		if ( face == 0.0 ) {
			uv = vec2( direction.z, direction.y ) / abs( direction.x );
		} else if ( face == 1.0 ) {
			uv = vec2( - direction.x, - direction.z ) / abs( direction.y );
		} else if ( face == 2.0 ) {
			uv = vec2( - direction.x, direction.y ) / abs( direction.z );
		} else if ( face == 3.0 ) {
			uv = vec2( - direction.z, direction.y ) / abs( direction.x );
		} else if ( face == 4.0 ) {
			uv = vec2( - direction.x, direction.z ) / abs( direction.y );
		} else {
			uv = vec2( direction.x, direction.y ) / abs( direction.z );
		}
		return 0.5 * ( uv + 1.0 );
	}
	vec3 bilinearCubeUV( sampler2D envMap, vec3 direction, float mipInt ) {
		float face = getFace( direction );
		float filterInt = max( cubeUV_minMipLevel - mipInt, 0.0 );
		mipInt = max( mipInt, cubeUV_minMipLevel );
		float faceSize = exp2( mipInt );
		highp vec2 uv = getUV( direction, face ) * ( faceSize - 2.0 ) + 1.0;
		if ( face > 2.0 ) {
			uv.y += faceSize;
			face -= 3.0;
		}
		uv.x += face * faceSize;
		uv.x += filterInt * 3.0 * cubeUV_minTileSize;
		uv.y += 4.0 * ( exp2( CUBEUV_MAX_MIP ) - faceSize );
		uv.x *= CUBEUV_TEXEL_WIDTH;
		uv.y *= CUBEUV_TEXEL_HEIGHT;
		#ifdef texture2DGradEXT
			return texture2DGradEXT( envMap, uv, vec2( 0.0 ), vec2( 0.0 ) ).rgb;
		#else
			return texture2D( envMap, uv ).rgb;
		#endif
	}
	#define cubeUV_r0 1.0
	#define cubeUV_m0 - 2.0
	#define cubeUV_r1 0.8
	#define cubeUV_m1 - 1.0
	#define cubeUV_r4 0.4
	#define cubeUV_m4 2.0
	#define cubeUV_r5 0.305
	#define cubeUV_m5 3.0
	#define cubeUV_r6 0.21
	#define cubeUV_m6 4.0
	float roughnessToMip( float roughness ) {
		float mip = 0.0;
		if ( roughness >= cubeUV_r1 ) {
			mip = ( cubeUV_r0 - roughness ) * ( cubeUV_m1 - cubeUV_m0 ) / ( cubeUV_r0 - cubeUV_r1 ) + cubeUV_m0;
		} else if ( roughness >= cubeUV_r4 ) {
			mip = ( cubeUV_r1 - roughness ) * ( cubeUV_m4 - cubeUV_m1 ) / ( cubeUV_r1 - cubeUV_r4 ) + cubeUV_m1;
		} else if ( roughness >= cubeUV_r5 ) {
			mip = ( cubeUV_r4 - roughness ) * ( cubeUV_m5 - cubeUV_m4 ) / ( cubeUV_r4 - cubeUV_r5 ) + cubeUV_m4;
		} else if ( roughness >= cubeUV_r6 ) {
			mip = ( cubeUV_r5 - roughness ) * ( cubeUV_m6 - cubeUV_m5 ) / ( cubeUV_r5 - cubeUV_r6 ) + cubeUV_m5;
		} else {
			mip = - 2.0 * log2( 1.16 * roughness );		}
		return mip;
	}
	vec4 textureCubeUV( sampler2D envMap, vec3 sampleDir, float roughness ) {
		float mip = clamp( roughnessToMip( roughness ), cubeUV_m0, CUBEUV_MAX_MIP );
		float mipF = fract( mip );
		float mipInt = floor( mip );
		vec3 color0 = bilinearCubeUV( envMap, sampleDir, mipInt );
		if ( mipF == 0.0 ) {
			return vec4( color0, 1.0 );
		} else {
			vec3 color1 = bilinearCubeUV( envMap, sampleDir, mipInt + 1.0 );
			return vec4( mix( color0, color1, mipF ), 1.0 );
		}
	}
#endif`,px=`vec3 transformedNormal = objectNormal;
#ifdef USE_TANGENT
	vec3 transformedTangent = objectTangent;
#endif
#ifdef USE_BATCHING
	mat3 bm = mat3( batchingMatrix );
	transformedNormal /= vec3( dot( bm[ 0 ], bm[ 0 ] ), dot( bm[ 1 ], bm[ 1 ] ), dot( bm[ 2 ], bm[ 2 ] ) );
	transformedNormal = bm * transformedNormal;
	#ifdef USE_TANGENT
		transformedTangent = bm * transformedTangent;
	#endif
#endif
#ifdef USE_INSTANCING
	mat3 im = mat3( instanceMatrix );
	transformedNormal /= vec3( dot( im[ 0 ], im[ 0 ] ), dot( im[ 1 ], im[ 1 ] ), dot( im[ 2 ], im[ 2 ] ) );
	transformedNormal = im * transformedNormal;
	#ifdef USE_TANGENT
		transformedTangent = im * transformedTangent;
	#endif
#endif
transformedNormal = normalMatrix * transformedNormal;
#ifdef FLIP_SIDED
	transformedNormal = - transformedNormal;
#endif
#ifdef USE_TANGENT
	transformedTangent = ( modelViewMatrix * vec4( transformedTangent, 0.0 ) ).xyz;
	#ifdef FLIP_SIDED
		transformedTangent = - transformedTangent;
	#endif
#endif`,mx=`#ifdef USE_DISPLACEMENTMAP
	uniform sampler2D displacementMap;
	uniform float displacementScale;
	uniform float displacementBias;
#endif`,gx=`#ifdef USE_DISPLACEMENTMAP
	transformed += normalize( objectNormal ) * ( texture2D( displacementMap, vDisplacementMapUv ).x * displacementScale + displacementBias );
#endif`,_x=`#ifdef USE_EMISSIVEMAP
	vec4 emissiveColor = texture2D( emissiveMap, vEmissiveMapUv );
	#ifdef DECODE_VIDEO_TEXTURE_EMISSIVE
		emissiveColor = sRGBTransferEOTF( emissiveColor );
	#endif
	totalEmissiveRadiance *= emissiveColor.rgb;
#endif`,xx=`#ifdef USE_EMISSIVEMAP
	uniform sampler2D emissiveMap;
#endif`,vx="gl_FragColor = linearToOutputTexel( gl_FragColor );",Mx=`vec4 LinearTransferOETF( in vec4 value ) {
	return value;
}
vec4 sRGBTransferEOTF( in vec4 value ) {
	return vec4( mix( pow( value.rgb * 0.9478672986 + vec3( 0.0521327014 ), vec3( 2.4 ) ), value.rgb * 0.0773993808, vec3( lessThanEqual( value.rgb, vec3( 0.04045 ) ) ) ), value.a );
}
vec4 sRGBTransferOETF( in vec4 value ) {
	return vec4( mix( pow( value.rgb, vec3( 0.41666 ) ) * 1.055 - vec3( 0.055 ), value.rgb * 12.92, vec3( lessThanEqual( value.rgb, vec3( 0.0031308 ) ) ) ), value.a );
}`,Sx=`#ifdef USE_ENVMAP
	#ifdef ENV_WORLDPOS
		vec3 cameraToFrag;
		if ( isOrthographic ) {
			cameraToFrag = normalize( vec3( - viewMatrix[ 0 ][ 2 ], - viewMatrix[ 1 ][ 2 ], - viewMatrix[ 2 ][ 2 ] ) );
		} else {
			cameraToFrag = normalize( vWorldPosition - cameraPosition );
		}
		vec3 worldNormal = inverseTransformDirection( normal, viewMatrix );
		#ifdef ENVMAP_MODE_REFLECTION
			vec3 reflectVec = reflect( cameraToFrag, worldNormal );
		#else
			vec3 reflectVec = refract( cameraToFrag, worldNormal, refractionRatio );
		#endif
	#else
		vec3 reflectVec = vReflect;
	#endif
	#ifdef ENVMAP_TYPE_CUBE
		vec4 envColor = textureCube( envMap, envMapRotation * reflectVec );
		#ifdef ENVMAP_BLENDING_MULTIPLY
			outgoingLight = mix( outgoingLight, outgoingLight * envColor.xyz, specularStrength * reflectivity );
		#elif defined( ENVMAP_BLENDING_MIX )
			outgoingLight = mix( outgoingLight, envColor.xyz, specularStrength * reflectivity );
		#elif defined( ENVMAP_BLENDING_ADD )
			outgoingLight += envColor.xyz * specularStrength * reflectivity;
		#endif
	#endif
#endif`,Ex=`#ifdef USE_ENVMAP
	uniform float envMapIntensity;
	uniform mat3 envMapRotation;
	#ifdef ENVMAP_TYPE_CUBE
		uniform samplerCube envMap;
	#else
		uniform sampler2D envMap;
	#endif
#endif`,yx=`#ifdef USE_ENVMAP
	uniform float reflectivity;
	#if defined( USE_BUMPMAP ) || defined( USE_NORMALMAP ) || defined( PHONG ) || defined( LAMBERT )
		#define ENV_WORLDPOS
	#endif
	#ifdef ENV_WORLDPOS
		varying vec3 vWorldPosition;
		uniform float refractionRatio;
	#else
		varying vec3 vReflect;
	#endif
#endif`,bx=`#ifdef USE_ENVMAP
	#if defined( USE_BUMPMAP ) || defined( USE_NORMALMAP ) || defined( PHONG ) || defined( LAMBERT )
		#define ENV_WORLDPOS
	#endif
	#ifdef ENV_WORLDPOS
		
		varying vec3 vWorldPosition;
	#else
		varying vec3 vReflect;
		uniform float refractionRatio;
	#endif
#endif`,Tx=`#ifdef USE_ENVMAP
	#ifdef ENV_WORLDPOS
		vWorldPosition = worldPosition.xyz;
	#else
		vec3 cameraToVertex;
		if ( isOrthographic ) {
			cameraToVertex = normalize( vec3( - viewMatrix[ 0 ][ 2 ], - viewMatrix[ 1 ][ 2 ], - viewMatrix[ 2 ][ 2 ] ) );
		} else {
			cameraToVertex = normalize( worldPosition.xyz - cameraPosition );
		}
		vec3 worldNormal = inverseTransformDirection( transformedNormal, viewMatrix );
		#ifdef ENVMAP_MODE_REFLECTION
			vReflect = reflect( cameraToVertex, worldNormal );
		#else
			vReflect = refract( cameraToVertex, worldNormal, refractionRatio );
		#endif
	#endif
#endif`,Ax=`#ifdef USE_FOG
	vFogDepth = - mvPosition.z;
#endif`,wx=`#ifdef USE_FOG
	varying float vFogDepth;
#endif`,Rx=`#ifdef USE_FOG
	#ifdef FOG_EXP2
		float fogFactor = 1.0 - exp( - fogDensity * fogDensity * vFogDepth * vFogDepth );
	#else
		float fogFactor = smoothstep( fogNear, fogFar, vFogDepth );
	#endif
	gl_FragColor.rgb = mix( gl_FragColor.rgb, fogColor, fogFactor );
#endif`,Cx=`#ifdef USE_FOG
	uniform vec3 fogColor;
	varying float vFogDepth;
	#ifdef FOG_EXP2
		uniform float fogDensity;
	#else
		uniform float fogNear;
		uniform float fogFar;
	#endif
#endif`,Px=`#ifdef USE_GRADIENTMAP
	uniform sampler2D gradientMap;
#endif
vec3 getGradientIrradiance( vec3 normal, vec3 lightDirection ) {
	float dotNL = dot( normal, lightDirection );
	vec2 coord = vec2( dotNL * 0.5 + 0.5, 0.0 );
	#ifdef USE_GRADIENTMAP
		return vec3( texture2D( gradientMap, coord ).r );
	#else
		vec2 fw = fwidth( coord ) * 0.5;
		return mix( vec3( 0.7 ), vec3( 1.0 ), smoothstep( 0.7 - fw.x, 0.7 + fw.x, coord.x ) );
	#endif
}`,Dx=`#ifdef USE_LIGHTMAP
	uniform sampler2D lightMap;
	uniform float lightMapIntensity;
#endif`,Ix=`LambertMaterial material;
material.diffuseColor = diffuseColor.rgb;
material.specularStrength = specularStrength;`,Lx=`varying vec3 vViewPosition;
struct LambertMaterial {
	vec3 diffuseColor;
	float specularStrength;
};
void RE_Direct_Lambert( const in IncidentLight directLight, const in vec3 geometryPosition, const in vec3 geometryNormal, const in vec3 geometryViewDir, const in vec3 geometryClearcoatNormal, const in LambertMaterial material, inout ReflectedLight reflectedLight ) {
	float dotNL = saturate( dot( geometryNormal, directLight.direction ) );
	vec3 irradiance = dotNL * directLight.color;
	reflectedLight.directDiffuse += irradiance * BRDF_Lambert( material.diffuseColor );
}
void RE_IndirectDiffuse_Lambert( const in vec3 irradiance, const in vec3 geometryPosition, const in vec3 geometryNormal, const in vec3 geometryViewDir, const in vec3 geometryClearcoatNormal, const in LambertMaterial material, inout ReflectedLight reflectedLight ) {
	reflectedLight.indirectDiffuse += irradiance * BRDF_Lambert( material.diffuseColor );
}
#define RE_Direct				RE_Direct_Lambert
#define RE_IndirectDiffuse		RE_IndirectDiffuse_Lambert`,Ux=`uniform bool receiveShadow;
uniform vec3 ambientLightColor;
#if defined( USE_LIGHT_PROBES )
	uniform vec3 lightProbe[ 9 ];
#endif
vec3 shGetIrradianceAt( in vec3 normal, in vec3 shCoefficients[ 9 ] ) {
	float x = normal.x, y = normal.y, z = normal.z;
	vec3 result = shCoefficients[ 0 ] * 0.886227;
	result += shCoefficients[ 1 ] * 2.0 * 0.511664 * y;
	result += shCoefficients[ 2 ] * 2.0 * 0.511664 * z;
	result += shCoefficients[ 3 ] * 2.0 * 0.511664 * x;
	result += shCoefficients[ 4 ] * 2.0 * 0.429043 * x * y;
	result += shCoefficients[ 5 ] * 2.0 * 0.429043 * y * z;
	result += shCoefficients[ 6 ] * ( 0.743125 * z * z - 0.247708 );
	result += shCoefficients[ 7 ] * 2.0 * 0.429043 * x * z;
	result += shCoefficients[ 8 ] * 0.429043 * ( x * x - y * y );
	return result;
}
vec3 getLightProbeIrradiance( const in vec3 lightProbe[ 9 ], const in vec3 normal ) {
	vec3 worldNormal = inverseTransformDirection( normal, viewMatrix );
	vec3 irradiance = shGetIrradianceAt( worldNormal, lightProbe );
	return irradiance;
}
vec3 getAmbientLightIrradiance( const in vec3 ambientLightColor ) {
	vec3 irradiance = ambientLightColor;
	return irradiance;
}
float getDistanceAttenuation( const in float lightDistance, const in float cutoffDistance, const in float decayExponent ) {
	float distanceFalloff = 1.0 / max( pow( lightDistance, decayExponent ), 0.01 );
	if ( cutoffDistance > 0.0 ) {
		distanceFalloff *= pow2( saturate( 1.0 - pow4( lightDistance / cutoffDistance ) ) );
	}
	return distanceFalloff;
}
float getSpotAttenuation( const in float coneCosine, const in float penumbraCosine, const in float angleCosine ) {
	return smoothstep( coneCosine, penumbraCosine, angleCosine );
}
#if NUM_DIR_LIGHTS > 0
	struct DirectionalLight {
		vec3 direction;
		vec3 color;
	};
	uniform DirectionalLight directionalLights[ NUM_DIR_LIGHTS ];
	void getDirectionalLightInfo( const in DirectionalLight directionalLight, out IncidentLight light ) {
		light.color = directionalLight.color;
		light.direction = directionalLight.direction;
		light.visible = true;
	}
#endif
#if NUM_POINT_LIGHTS > 0
	struct PointLight {
		vec3 position;
		vec3 color;
		float distance;
		float decay;
	};
	uniform PointLight pointLights[ NUM_POINT_LIGHTS ];
	void getPointLightInfo( const in PointLight pointLight, const in vec3 geometryPosition, out IncidentLight light ) {
		vec3 lVector = pointLight.position - geometryPosition;
		light.direction = normalize( lVector );
		float lightDistance = length( lVector );
		light.color = pointLight.color;
		light.color *= getDistanceAttenuation( lightDistance, pointLight.distance, pointLight.decay );
		light.visible = ( light.color != vec3( 0.0 ) );
	}
#endif
#if NUM_SPOT_LIGHTS > 0
	struct SpotLight {
		vec3 position;
		vec3 direction;
		vec3 color;
		float distance;
		float decay;
		float coneCos;
		float penumbraCos;
	};
	uniform SpotLight spotLights[ NUM_SPOT_LIGHTS ];
	void getSpotLightInfo( const in SpotLight spotLight, const in vec3 geometryPosition, out IncidentLight light ) {
		vec3 lVector = spotLight.position - geometryPosition;
		light.direction = normalize( lVector );
		float angleCos = dot( light.direction, spotLight.direction );
		float spotAttenuation = getSpotAttenuation( spotLight.coneCos, spotLight.penumbraCos, angleCos );
		if ( spotAttenuation > 0.0 ) {
			float lightDistance = length( lVector );
			light.color = spotLight.color * spotAttenuation;
			light.color *= getDistanceAttenuation( lightDistance, spotLight.distance, spotLight.decay );
			light.visible = ( light.color != vec3( 0.0 ) );
		} else {
			light.color = vec3( 0.0 );
			light.visible = false;
		}
	}
#endif
#if NUM_RECT_AREA_LIGHTS > 0
	struct RectAreaLight {
		vec3 color;
		vec3 position;
		vec3 halfWidth;
		vec3 halfHeight;
	};
	uniform sampler2D ltc_1;	uniform sampler2D ltc_2;
	uniform RectAreaLight rectAreaLights[ NUM_RECT_AREA_LIGHTS ];
#endif
#if NUM_HEMI_LIGHTS > 0
	struct HemisphereLight {
		vec3 direction;
		vec3 skyColor;
		vec3 groundColor;
	};
	uniform HemisphereLight hemisphereLights[ NUM_HEMI_LIGHTS ];
	vec3 getHemisphereLightIrradiance( const in HemisphereLight hemiLight, const in vec3 normal ) {
		float dotNL = dot( normal, hemiLight.direction );
		float hemiDiffuseWeight = 0.5 * dotNL + 0.5;
		vec3 irradiance = mix( hemiLight.groundColor, hemiLight.skyColor, hemiDiffuseWeight );
		return irradiance;
	}
#endif
#include <lightprobes_pars_fragment>`,Nx=`#ifdef USE_ENVMAP
	vec3 getIBLIrradiance( const in vec3 normal ) {
		#ifdef ENVMAP_TYPE_CUBE_UV
			vec3 worldNormal = inverseTransformDirection( normal, viewMatrix );
			vec4 envMapColor = textureCubeUV( envMap, envMapRotation * worldNormal, 1.0 );
			return PI * envMapColor.rgb * envMapIntensity;
		#else
			return vec3( 0.0 );
		#endif
	}
	vec3 getIBLRadiance( const in vec3 viewDir, const in vec3 normal, const in float roughness ) {
		#ifdef ENVMAP_TYPE_CUBE_UV
			vec3 reflectVec = reflect( - viewDir, normal );
			reflectVec = normalize( mix( reflectVec, normal, pow4( roughness ) ) );
			reflectVec = inverseTransformDirection( reflectVec, viewMatrix );
			vec4 envMapColor = textureCubeUV( envMap, envMapRotation * reflectVec, roughness );
			return envMapColor.rgb * envMapIntensity;
		#else
			return vec3( 0.0 );
		#endif
	}
	#ifdef USE_ANISOTROPY
		vec3 getIBLAnisotropyRadiance( const in vec3 viewDir, const in vec3 normal, const in float roughness, const in vec3 bitangent, const in float anisotropy ) {
			#ifdef ENVMAP_TYPE_CUBE_UV
				vec3 bentNormal = cross( bitangent, viewDir );
				bentNormal = normalize( cross( bentNormal, bitangent ) );
				bentNormal = normalize( mix( bentNormal, normal, pow2( pow2( 1.0 - anisotropy * ( 1.0 - roughness ) ) ) ) );
				return getIBLRadiance( viewDir, bentNormal, roughness );
			#else
				return vec3( 0.0 );
			#endif
		}
	#endif
#endif`,Fx=`ToonMaterial material;
material.diffuseColor = diffuseColor.rgb;`,Ox=`varying vec3 vViewPosition;
struct ToonMaterial {
	vec3 diffuseColor;
};
void RE_Direct_Toon( const in IncidentLight directLight, const in vec3 geometryPosition, const in vec3 geometryNormal, const in vec3 geometryViewDir, const in vec3 geometryClearcoatNormal, const in ToonMaterial material, inout ReflectedLight reflectedLight ) {
	vec3 irradiance = getGradientIrradiance( geometryNormal, directLight.direction ) * directLight.color;
	reflectedLight.directDiffuse += irradiance * BRDF_Lambert( material.diffuseColor );
}
void RE_IndirectDiffuse_Toon( const in vec3 irradiance, const in vec3 geometryPosition, const in vec3 geometryNormal, const in vec3 geometryViewDir, const in vec3 geometryClearcoatNormal, const in ToonMaterial material, inout ReflectedLight reflectedLight ) {
	reflectedLight.indirectDiffuse += irradiance * BRDF_Lambert( material.diffuseColor );
}
#define RE_Direct				RE_Direct_Toon
#define RE_IndirectDiffuse		RE_IndirectDiffuse_Toon`,Bx=`BlinnPhongMaterial material;
material.diffuseColor = diffuseColor.rgb;
material.specularColor = specular;
material.specularShininess = shininess;
material.specularStrength = specularStrength;`,zx=`varying vec3 vViewPosition;
struct BlinnPhongMaterial {
	vec3 diffuseColor;
	vec3 specularColor;
	float specularShininess;
	float specularStrength;
};
void RE_Direct_BlinnPhong( const in IncidentLight directLight, const in vec3 geometryPosition, const in vec3 geometryNormal, const in vec3 geometryViewDir, const in vec3 geometryClearcoatNormal, const in BlinnPhongMaterial material, inout ReflectedLight reflectedLight ) {
	float dotNL = saturate( dot( geometryNormal, directLight.direction ) );
	vec3 irradiance = dotNL * directLight.color;
	reflectedLight.directDiffuse += irradiance * BRDF_Lambert( material.diffuseColor );
	reflectedLight.directSpecular += irradiance * BRDF_BlinnPhong( directLight.direction, geometryViewDir, geometryNormal, material.specularColor, material.specularShininess ) * material.specularStrength;
}
void RE_IndirectDiffuse_BlinnPhong( const in vec3 irradiance, const in vec3 geometryPosition, const in vec3 geometryNormal, const in vec3 geometryViewDir, const in vec3 geometryClearcoatNormal, const in BlinnPhongMaterial material, inout ReflectedLight reflectedLight ) {
	reflectedLight.indirectDiffuse += irradiance * BRDF_Lambert( material.diffuseColor );
}
#define RE_Direct				RE_Direct_BlinnPhong
#define RE_IndirectDiffuse		RE_IndirectDiffuse_BlinnPhong`,Hx=`PhysicalMaterial material;
material.diffuseColor = diffuseColor.rgb;
material.diffuseContribution = diffuseColor.rgb * ( 1.0 - metalnessFactor );
material.metalness = metalnessFactor;
vec3 dxy = max( abs( dFdx( nonPerturbedNormal ) ), abs( dFdy( nonPerturbedNormal ) ) );
float geometryRoughness = max( max( dxy.x, dxy.y ), dxy.z );
material.roughness = max( roughnessFactor, 0.0525 );material.roughness += geometryRoughness;
material.roughness = min( material.roughness, 1.0 );
#ifdef IOR
	material.ior = ior;
	#ifdef USE_SPECULAR
		float specularIntensityFactor = specularIntensity;
		vec3 specularColorFactor = specularColor;
		#ifdef USE_SPECULAR_COLORMAP
			specularColorFactor *= texture2D( specularColorMap, vSpecularColorMapUv ).rgb;
		#endif
		#ifdef USE_SPECULAR_INTENSITYMAP
			specularIntensityFactor *= texture2D( specularIntensityMap, vSpecularIntensityMapUv ).a;
		#endif
		material.specularF90 = mix( specularIntensityFactor, 1.0, metalnessFactor );
	#else
		float specularIntensityFactor = 1.0;
		vec3 specularColorFactor = vec3( 1.0 );
		material.specularF90 = 1.0;
	#endif
	material.specularColor = min( pow2( ( material.ior - 1.0 ) / ( material.ior + 1.0 ) ) * specularColorFactor, vec3( 1.0 ) ) * specularIntensityFactor;
	material.specularColorBlended = mix( material.specularColor, diffuseColor.rgb, metalnessFactor );
#else
	material.specularColor = vec3( 0.04 );
	material.specularColorBlended = mix( material.specularColor, diffuseColor.rgb, metalnessFactor );
	material.specularF90 = 1.0;
#endif
#ifdef USE_CLEARCOAT
	material.clearcoat = clearcoat;
	material.clearcoatRoughness = clearcoatRoughness;
	material.clearcoatF0 = vec3( 0.04 );
	material.clearcoatF90 = 1.0;
	#ifdef USE_CLEARCOATMAP
		material.clearcoat *= texture2D( clearcoatMap, vClearcoatMapUv ).x;
	#endif
	#ifdef USE_CLEARCOAT_ROUGHNESSMAP
		material.clearcoatRoughness *= texture2D( clearcoatRoughnessMap, vClearcoatRoughnessMapUv ).y;
	#endif
	material.clearcoat = saturate( material.clearcoat );	material.clearcoatRoughness = max( material.clearcoatRoughness, 0.0525 );
	material.clearcoatRoughness += geometryRoughness;
	material.clearcoatRoughness = min( material.clearcoatRoughness, 1.0 );
#endif
#ifdef USE_DISPERSION
	material.dispersion = dispersion;
#endif
#ifdef USE_IRIDESCENCE
	material.iridescence = iridescence;
	material.iridescenceIOR = iridescenceIOR;
	#ifdef USE_IRIDESCENCEMAP
		material.iridescence *= texture2D( iridescenceMap, vIridescenceMapUv ).r;
	#endif
	#ifdef USE_IRIDESCENCE_THICKNESSMAP
		material.iridescenceThickness = (iridescenceThicknessMaximum - iridescenceThicknessMinimum) * texture2D( iridescenceThicknessMap, vIridescenceThicknessMapUv ).g + iridescenceThicknessMinimum;
	#else
		material.iridescenceThickness = iridescenceThicknessMaximum;
	#endif
#endif
#ifdef USE_SHEEN
	material.sheenColor = sheenColor;
	#ifdef USE_SHEEN_COLORMAP
		material.sheenColor *= texture2D( sheenColorMap, vSheenColorMapUv ).rgb;
	#endif
	material.sheenRoughness = clamp( sheenRoughness, 0.0001, 1.0 );
	#ifdef USE_SHEEN_ROUGHNESSMAP
		material.sheenRoughness *= texture2D( sheenRoughnessMap, vSheenRoughnessMapUv ).a;
	#endif
#endif
#ifdef USE_ANISOTROPY
	#ifdef USE_ANISOTROPYMAP
		mat2 anisotropyMat = mat2( anisotropyVector.x, anisotropyVector.y, - anisotropyVector.y, anisotropyVector.x );
		vec3 anisotropyPolar = texture2D( anisotropyMap, vAnisotropyMapUv ).rgb;
		vec2 anisotropyV = anisotropyMat * normalize( 2.0 * anisotropyPolar.rg - vec2( 1.0 ) ) * anisotropyPolar.b;
	#else
		vec2 anisotropyV = anisotropyVector;
	#endif
	material.anisotropy = length( anisotropyV );
	if( material.anisotropy == 0.0 ) {
		anisotropyV = vec2( 1.0, 0.0 );
	} else {
		anisotropyV /= material.anisotropy;
		material.anisotropy = saturate( material.anisotropy );
	}
	material.alphaT = mix( pow2( material.roughness ), 1.0, pow2( material.anisotropy ) );
	material.anisotropyT = tbn[ 0 ] * anisotropyV.x + tbn[ 1 ] * anisotropyV.y;
	material.anisotropyB = tbn[ 1 ] * anisotropyV.x - tbn[ 0 ] * anisotropyV.y;
#endif`,Vx=`uniform sampler2D dfgLUT;
struct PhysicalMaterial {
	vec3 diffuseColor;
	vec3 diffuseContribution;
	vec3 specularColor;
	vec3 specularColorBlended;
	float roughness;
	float metalness;
	float specularF90;
	float dispersion;
	#ifdef USE_CLEARCOAT
		float clearcoat;
		float clearcoatRoughness;
		vec3 clearcoatF0;
		float clearcoatF90;
	#endif
	#ifdef USE_IRIDESCENCE
		float iridescence;
		float iridescenceIOR;
		float iridescenceThickness;
		vec3 iridescenceFresnel;
		vec3 iridescenceF0;
		vec3 iridescenceFresnelDielectric;
		vec3 iridescenceFresnelMetallic;
	#endif
	#ifdef USE_SHEEN
		vec3 sheenColor;
		float sheenRoughness;
	#endif
	#ifdef IOR
		float ior;
	#endif
	#ifdef USE_TRANSMISSION
		float transmission;
		float transmissionAlpha;
		float thickness;
		float attenuationDistance;
		vec3 attenuationColor;
	#endif
	#ifdef USE_ANISOTROPY
		float anisotropy;
		float alphaT;
		vec3 anisotropyT;
		vec3 anisotropyB;
	#endif
};
vec3 clearcoatSpecularDirect = vec3( 0.0 );
vec3 clearcoatSpecularIndirect = vec3( 0.0 );
vec3 sheenSpecularDirect = vec3( 0.0 );
vec3 sheenSpecularIndirect = vec3(0.0 );
vec3 Schlick_to_F0( const in vec3 f, const in float f90, const in float dotVH ) {
    float x = clamp( 1.0 - dotVH, 0.0, 1.0 );
    float x2 = x * x;
    float x5 = clamp( x * x2 * x2, 0.0, 0.9999 );
    return ( f - vec3( f90 ) * x5 ) / ( 1.0 - x5 );
}
float V_GGX_SmithCorrelated( const in float alpha, const in float dotNL, const in float dotNV ) {
	float a2 = pow2( alpha );
	float gv = dotNL * sqrt( a2 + ( 1.0 - a2 ) * pow2( dotNV ) );
	float gl = dotNV * sqrt( a2 + ( 1.0 - a2 ) * pow2( dotNL ) );
	return 0.5 / max( gv + gl, EPSILON );
}
float D_GGX( const in float alpha, const in float dotNH ) {
	float a2 = pow2( alpha );
	float denom = pow2( dotNH ) * ( a2 - 1.0 ) + 1.0;
	return RECIPROCAL_PI * a2 / pow2( denom );
}
#ifdef USE_ANISOTROPY
	float V_GGX_SmithCorrelated_Anisotropic( const in float alphaT, const in float alphaB, const in float dotTV, const in float dotBV, const in float dotTL, const in float dotBL, const in float dotNV, const in float dotNL ) {
		float gv = dotNL * length( vec3( alphaT * dotTV, alphaB * dotBV, dotNV ) );
		float gl = dotNV * length( vec3( alphaT * dotTL, alphaB * dotBL, dotNL ) );
		return 0.5 / max( gv + gl, EPSILON );
	}
	float D_GGX_Anisotropic( const in float alphaT, const in float alphaB, const in float dotNH, const in float dotTH, const in float dotBH ) {
		float a2 = alphaT * alphaB;
		highp vec3 v = vec3( alphaB * dotTH, alphaT * dotBH, a2 * dotNH );
		highp float v2 = dot( v, v );
		float w2 = a2 / v2;
		return RECIPROCAL_PI * a2 * pow2 ( w2 );
	}
#endif
#ifdef USE_CLEARCOAT
	vec3 BRDF_GGX_Clearcoat( const in vec3 lightDir, const in vec3 viewDir, const in vec3 normal, const in PhysicalMaterial material) {
		vec3 f0 = material.clearcoatF0;
		float f90 = material.clearcoatF90;
		float roughness = material.clearcoatRoughness;
		float alpha = pow2( roughness );
		vec3 halfDir = normalize( lightDir + viewDir );
		float dotNL = saturate( dot( normal, lightDir ) );
		float dotNV = saturate( dot( normal, viewDir ) );
		float dotNH = saturate( dot( normal, halfDir ) );
		float dotVH = saturate( dot( viewDir, halfDir ) );
		vec3 F = F_Schlick( f0, f90, dotVH );
		float V = V_GGX_SmithCorrelated( alpha, dotNL, dotNV );
		float D = D_GGX( alpha, dotNH );
		return F * ( V * D );
	}
#endif
vec3 BRDF_GGX( const in vec3 lightDir, const in vec3 viewDir, const in vec3 normal, const in PhysicalMaterial material ) {
	vec3 f0 = material.specularColorBlended;
	float f90 = material.specularF90;
	float roughness = material.roughness;
	float alpha = pow2( roughness );
	vec3 halfDir = normalize( lightDir + viewDir );
	float dotNL = saturate( dot( normal, lightDir ) );
	float dotNV = saturate( dot( normal, viewDir ) );
	float dotNH = saturate( dot( normal, halfDir ) );
	float dotVH = saturate( dot( viewDir, halfDir ) );
	vec3 F = F_Schlick( f0, f90, dotVH );
	#ifdef USE_IRIDESCENCE
		F = mix( F, material.iridescenceFresnel, material.iridescence );
	#endif
	#ifdef USE_ANISOTROPY
		float dotTL = dot( material.anisotropyT, lightDir );
		float dotTV = dot( material.anisotropyT, viewDir );
		float dotTH = dot( material.anisotropyT, halfDir );
		float dotBL = dot( material.anisotropyB, lightDir );
		float dotBV = dot( material.anisotropyB, viewDir );
		float dotBH = dot( material.anisotropyB, halfDir );
		float V = V_GGX_SmithCorrelated_Anisotropic( material.alphaT, alpha, dotTV, dotBV, dotTL, dotBL, dotNV, dotNL );
		float D = D_GGX_Anisotropic( material.alphaT, alpha, dotNH, dotTH, dotBH );
	#else
		float V = V_GGX_SmithCorrelated( alpha, dotNL, dotNV );
		float D = D_GGX( alpha, dotNH );
	#endif
	return F * ( V * D );
}
vec2 LTC_Uv( const in vec3 N, const in vec3 V, const in float roughness ) {
	const float LUT_SIZE = 64.0;
	const float LUT_SCALE = ( LUT_SIZE - 1.0 ) / LUT_SIZE;
	const float LUT_BIAS = 0.5 / LUT_SIZE;
	float dotNV = saturate( dot( N, V ) );
	vec2 uv = vec2( roughness, sqrt( 1.0 - dotNV ) );
	uv = uv * LUT_SCALE + LUT_BIAS;
	return uv;
}
float LTC_ClippedSphereFormFactor( const in vec3 f ) {
	float l = length( f );
	return max( ( l * l + f.z ) / ( l + 1.0 ), 0.0 );
}
vec3 LTC_EdgeVectorFormFactor( const in vec3 v1, const in vec3 v2 ) {
	float x = dot( v1, v2 );
	float y = abs( x );
	float a = 0.8543985 + ( 0.4965155 + 0.0145206 * y ) * y;
	float b = 3.4175940 + ( 4.1616724 + y ) * y;
	float v = a / b;
	float theta_sintheta = ( x > 0.0 ) ? v : 0.5 * inversesqrt( max( 1.0 - x * x, 1e-7 ) ) - v;
	return cross( v1, v2 ) * theta_sintheta;
}
vec3 LTC_Evaluate( const in vec3 N, const in vec3 V, const in vec3 P, const in mat3 mInv, const in vec3 rectCoords[ 4 ] ) {
	vec3 v1 = rectCoords[ 1 ] - rectCoords[ 0 ];
	vec3 v2 = rectCoords[ 3 ] - rectCoords[ 0 ];
	vec3 lightNormal = cross( v1, v2 );
	if( dot( lightNormal, P - rectCoords[ 0 ] ) < 0.0 ) return vec3( 0.0 );
	vec3 T1, T2;
	T1 = normalize( V - N * dot( V, N ) );
	T2 = - cross( N, T1 );
	mat3 mat = mInv * transpose( mat3( T1, T2, N ) );
	vec3 coords[ 4 ];
	coords[ 0 ] = mat * ( rectCoords[ 0 ] - P );
	coords[ 1 ] = mat * ( rectCoords[ 1 ] - P );
	coords[ 2 ] = mat * ( rectCoords[ 2 ] - P );
	coords[ 3 ] = mat * ( rectCoords[ 3 ] - P );
	coords[ 0 ] = normalize( coords[ 0 ] );
	coords[ 1 ] = normalize( coords[ 1 ] );
	coords[ 2 ] = normalize( coords[ 2 ] );
	coords[ 3 ] = normalize( coords[ 3 ] );
	vec3 vectorFormFactor = vec3( 0.0 );
	vectorFormFactor += LTC_EdgeVectorFormFactor( coords[ 0 ], coords[ 1 ] );
	vectorFormFactor += LTC_EdgeVectorFormFactor( coords[ 1 ], coords[ 2 ] );
	vectorFormFactor += LTC_EdgeVectorFormFactor( coords[ 2 ], coords[ 3 ] );
	vectorFormFactor += LTC_EdgeVectorFormFactor( coords[ 3 ], coords[ 0 ] );
	float result = LTC_ClippedSphereFormFactor( vectorFormFactor );
	return vec3( result );
}
#if defined( USE_SHEEN )
float D_Charlie( float roughness, float dotNH ) {
	float alpha = pow2( roughness );
	float invAlpha = 1.0 / alpha;
	float cos2h = dotNH * dotNH;
	float sin2h = max( 1.0 - cos2h, 0.0078125 );
	return ( 2.0 + invAlpha ) * pow( sin2h, invAlpha * 0.5 ) / ( 2.0 * PI );
}
float V_Neubelt( float dotNV, float dotNL ) {
	return saturate( 1.0 / ( 4.0 * ( dotNL + dotNV - dotNL * dotNV ) ) );
}
vec3 BRDF_Sheen( const in vec3 lightDir, const in vec3 viewDir, const in vec3 normal, vec3 sheenColor, const in float sheenRoughness ) {
	vec3 halfDir = normalize( lightDir + viewDir );
	float dotNL = saturate( dot( normal, lightDir ) );
	float dotNV = saturate( dot( normal, viewDir ) );
	float dotNH = saturate( dot( normal, halfDir ) );
	float D = D_Charlie( sheenRoughness, dotNH );
	float V = V_Neubelt( dotNV, dotNL );
	return sheenColor * ( D * V );
}
#endif
float IBLSheenBRDF( const in vec3 normal, const in vec3 viewDir, const in float roughness ) {
	float dotNV = saturate( dot( normal, viewDir ) );
	float r2 = roughness * roughness;
	float rInv = 1.0 / ( roughness + 0.1 );
	float a = -1.9362 + 1.0678 * roughness + 0.4573 * r2 - 0.8469 * rInv;
	float b = -0.6014 + 0.5538 * roughness - 0.4670 * r2 - 0.1255 * rInv;
	float DG = exp( a * dotNV + b );
	return saturate( DG );
}
vec3 EnvironmentBRDF( const in vec3 normal, const in vec3 viewDir, const in vec3 specularColor, const in float specularF90, const in float roughness ) {
	float dotNV = saturate( dot( normal, viewDir ) );
	vec2 fab = texture2D( dfgLUT, vec2( roughness, dotNV ) ).rg;
	return specularColor * fab.x + specularF90 * fab.y;
}
#ifdef USE_IRIDESCENCE
void computeMultiscatteringIridescence( const in vec3 normal, const in vec3 viewDir, const in vec3 specularColor, const in float specularF90, const in float iridescence, const in vec3 iridescenceF0, const in float roughness, inout vec3 singleScatter, inout vec3 multiScatter ) {
#else
void computeMultiscattering( const in vec3 normal, const in vec3 viewDir, const in vec3 specularColor, const in float specularF90, const in float roughness, inout vec3 singleScatter, inout vec3 multiScatter ) {
#endif
	float dotNV = saturate( dot( normal, viewDir ) );
	vec2 fab = texture2D( dfgLUT, vec2( roughness, dotNV ) ).rg;
	#ifdef USE_IRIDESCENCE
		vec3 Fr = mix( specularColor, iridescenceF0, iridescence );
	#else
		vec3 Fr = specularColor;
	#endif
	vec3 FssEss = Fr * fab.x + specularF90 * fab.y;
	float Ess = fab.x + fab.y;
	float Ems = 1.0 - Ess;
	vec3 Favg = Fr + ( 1.0 - Fr ) * 0.047619;	vec3 Fms = FssEss * Favg / ( 1.0 - Ems * Favg );
	singleScatter += FssEss;
	multiScatter += Fms * Ems;
}
vec3 BRDF_GGX_Multiscatter( const in vec3 lightDir, const in vec3 viewDir, const in vec3 normal, const in PhysicalMaterial material ) {
	vec3 singleScatter = BRDF_GGX( lightDir, viewDir, normal, material );
	float dotNL = saturate( dot( normal, lightDir ) );
	float dotNV = saturate( dot( normal, viewDir ) );
	vec2 dfgV = texture2D( dfgLUT, vec2( material.roughness, dotNV ) ).rg;
	vec2 dfgL = texture2D( dfgLUT, vec2( material.roughness, dotNL ) ).rg;
	vec3 FssEss_V = material.specularColorBlended * dfgV.x + material.specularF90 * dfgV.y;
	vec3 FssEss_L = material.specularColorBlended * dfgL.x + material.specularF90 * dfgL.y;
	float Ess_V = dfgV.x + dfgV.y;
	float Ess_L = dfgL.x + dfgL.y;
	float Ems_V = 1.0 - Ess_V;
	float Ems_L = 1.0 - Ess_L;
	vec3 Favg = material.specularColorBlended + ( 1.0 - material.specularColorBlended ) * 0.047619;
	vec3 Fms = FssEss_V * FssEss_L * Favg / ( 1.0 - Ems_V * Ems_L * Favg + EPSILON );
	float compensationFactor = Ems_V * Ems_L;
	vec3 multiScatter = Fms * compensationFactor;
	return singleScatter + multiScatter;
}
#if NUM_RECT_AREA_LIGHTS > 0
	void RE_Direct_RectArea_Physical( const in RectAreaLight rectAreaLight, const in vec3 geometryPosition, const in vec3 geometryNormal, const in vec3 geometryViewDir, const in vec3 geometryClearcoatNormal, const in PhysicalMaterial material, inout ReflectedLight reflectedLight ) {
		vec3 normal = geometryNormal;
		vec3 viewDir = geometryViewDir;
		vec3 position = geometryPosition;
		vec3 lightPos = rectAreaLight.position;
		vec3 halfWidth = rectAreaLight.halfWidth;
		vec3 halfHeight = rectAreaLight.halfHeight;
		vec3 lightColor = rectAreaLight.color;
		float roughness = material.roughness;
		vec3 rectCoords[ 4 ];
		rectCoords[ 0 ] = lightPos + halfWidth - halfHeight;		rectCoords[ 1 ] = lightPos - halfWidth - halfHeight;
		rectCoords[ 2 ] = lightPos - halfWidth + halfHeight;
		rectCoords[ 3 ] = lightPos + halfWidth + halfHeight;
		vec2 uv = LTC_Uv( normal, viewDir, roughness );
		vec4 t1 = texture2D( ltc_1, uv );
		vec4 t2 = texture2D( ltc_2, uv );
		mat3 mInv = mat3(
			vec3( t1.x, 0, t1.y ),
			vec3(    0, 1,    0 ),
			vec3( t1.z, 0, t1.w )
		);
		vec3 fresnel = ( material.specularColorBlended * t2.x + ( material.specularF90 - material.specularColorBlended ) * t2.y );
		reflectedLight.directSpecular += lightColor * fresnel * LTC_Evaluate( normal, viewDir, position, mInv, rectCoords );
		reflectedLight.directDiffuse += lightColor * material.diffuseContribution * LTC_Evaluate( normal, viewDir, position, mat3( 1.0 ), rectCoords );
		#ifdef USE_CLEARCOAT
			vec3 Ncc = geometryClearcoatNormal;
			vec2 uvClearcoat = LTC_Uv( Ncc, viewDir, material.clearcoatRoughness );
			vec4 t1Clearcoat = texture2D( ltc_1, uvClearcoat );
			vec4 t2Clearcoat = texture2D( ltc_2, uvClearcoat );
			mat3 mInvClearcoat = mat3(
				vec3( t1Clearcoat.x, 0, t1Clearcoat.y ),
				vec3(             0, 1,             0 ),
				vec3( t1Clearcoat.z, 0, t1Clearcoat.w )
			);
			vec3 fresnelClearcoat = material.clearcoatF0 * t2Clearcoat.x + ( material.clearcoatF90 - material.clearcoatF0 ) * t2Clearcoat.y;
			clearcoatSpecularDirect += lightColor * fresnelClearcoat * LTC_Evaluate( Ncc, viewDir, position, mInvClearcoat, rectCoords );
		#endif
	}
#endif
void RE_Direct_Physical( const in IncidentLight directLight, const in vec3 geometryPosition, const in vec3 geometryNormal, const in vec3 geometryViewDir, const in vec3 geometryClearcoatNormal, const in PhysicalMaterial material, inout ReflectedLight reflectedLight ) {
	float dotNL = saturate( dot( geometryNormal, directLight.direction ) );
	vec3 irradiance = dotNL * directLight.color;
	#ifdef USE_CLEARCOAT
		float dotNLcc = saturate( dot( geometryClearcoatNormal, directLight.direction ) );
		vec3 ccIrradiance = dotNLcc * directLight.color;
		clearcoatSpecularDirect += ccIrradiance * BRDF_GGX_Clearcoat( directLight.direction, geometryViewDir, geometryClearcoatNormal, material );
	#endif
	#ifdef USE_SHEEN
 
 		sheenSpecularDirect += irradiance * BRDF_Sheen( directLight.direction, geometryViewDir, geometryNormal, material.sheenColor, material.sheenRoughness );
 
 		float sheenAlbedoV = IBLSheenBRDF( geometryNormal, geometryViewDir, material.sheenRoughness );
 		float sheenAlbedoL = IBLSheenBRDF( geometryNormal, directLight.direction, material.sheenRoughness );
 
 		float sheenEnergyComp = 1.0 - max3( material.sheenColor ) * max( sheenAlbedoV, sheenAlbedoL );
 
 		irradiance *= sheenEnergyComp;
 
 	#endif
	reflectedLight.directSpecular += irradiance * BRDF_GGX_Multiscatter( directLight.direction, geometryViewDir, geometryNormal, material );
	reflectedLight.directDiffuse += irradiance * BRDF_Lambert( material.diffuseContribution );
}
void RE_IndirectDiffuse_Physical( const in vec3 irradiance, const in vec3 geometryPosition, const in vec3 geometryNormal, const in vec3 geometryViewDir, const in vec3 geometryClearcoatNormal, const in PhysicalMaterial material, inout ReflectedLight reflectedLight ) {
	vec3 diffuse = irradiance * BRDF_Lambert( material.diffuseContribution );
	#ifdef USE_SHEEN
		float sheenAlbedo = IBLSheenBRDF( geometryNormal, geometryViewDir, material.sheenRoughness );
		float sheenEnergyComp = 1.0 - max3( material.sheenColor ) * sheenAlbedo;
		diffuse *= sheenEnergyComp;
	#endif
	reflectedLight.indirectDiffuse += diffuse;
}
void RE_IndirectSpecular_Physical( const in vec3 radiance, const in vec3 irradiance, const in vec3 clearcoatRadiance, const in vec3 geometryPosition, const in vec3 geometryNormal, const in vec3 geometryViewDir, const in vec3 geometryClearcoatNormal, const in PhysicalMaterial material, inout ReflectedLight reflectedLight) {
	#ifdef USE_CLEARCOAT
		clearcoatSpecularIndirect += clearcoatRadiance * EnvironmentBRDF( geometryClearcoatNormal, geometryViewDir, material.clearcoatF0, material.clearcoatF90, material.clearcoatRoughness );
	#endif
	#ifdef USE_SHEEN
		sheenSpecularIndirect += irradiance * material.sheenColor * IBLSheenBRDF( geometryNormal, geometryViewDir, material.sheenRoughness ) * RECIPROCAL_PI;
 	#endif
	vec3 singleScatteringDielectric = vec3( 0.0 );
	vec3 multiScatteringDielectric = vec3( 0.0 );
	vec3 singleScatteringMetallic = vec3( 0.0 );
	vec3 multiScatteringMetallic = vec3( 0.0 );
	#ifdef USE_IRIDESCENCE
		computeMultiscatteringIridescence( geometryNormal, geometryViewDir, material.specularColor, material.specularF90, material.iridescence, material.iridescenceFresnelDielectric, material.roughness, singleScatteringDielectric, multiScatteringDielectric );
		computeMultiscatteringIridescence( geometryNormal, geometryViewDir, material.diffuseColor, material.specularF90, material.iridescence, material.iridescenceFresnelMetallic, material.roughness, singleScatteringMetallic, multiScatteringMetallic );
	#else
		computeMultiscattering( geometryNormal, geometryViewDir, material.specularColor, material.specularF90, material.roughness, singleScatteringDielectric, multiScatteringDielectric );
		computeMultiscattering( geometryNormal, geometryViewDir, material.diffuseColor, material.specularF90, material.roughness, singleScatteringMetallic, multiScatteringMetallic );
	#endif
	vec3 singleScattering = mix( singleScatteringDielectric, singleScatteringMetallic, material.metalness );
	vec3 multiScattering = mix( multiScatteringDielectric, multiScatteringMetallic, material.metalness );
	vec3 totalScatteringDielectric = singleScatteringDielectric + multiScatteringDielectric;
	vec3 diffuse = material.diffuseContribution * ( 1.0 - totalScatteringDielectric );
	vec3 cosineWeightedIrradiance = irradiance * RECIPROCAL_PI;
	vec3 indirectSpecular = radiance * singleScattering;
	indirectSpecular += multiScattering * cosineWeightedIrradiance;
	vec3 indirectDiffuse = diffuse * cosineWeightedIrradiance;
	#ifdef USE_SHEEN
		float sheenAlbedo = IBLSheenBRDF( geometryNormal, geometryViewDir, material.sheenRoughness );
		float sheenEnergyComp = 1.0 - max3( material.sheenColor ) * sheenAlbedo;
		indirectSpecular *= sheenEnergyComp;
		indirectDiffuse *= sheenEnergyComp;
	#endif
	reflectedLight.indirectSpecular += indirectSpecular;
	reflectedLight.indirectDiffuse += indirectDiffuse;
}
#define RE_Direct				RE_Direct_Physical
#define RE_Direct_RectArea		RE_Direct_RectArea_Physical
#define RE_IndirectDiffuse		RE_IndirectDiffuse_Physical
#define RE_IndirectSpecular		RE_IndirectSpecular_Physical
float computeSpecularOcclusion( const in float dotNV, const in float ambientOcclusion, const in float roughness ) {
	return saturate( pow( dotNV + ambientOcclusion, exp2( - 16.0 * roughness - 1.0 ) ) - 1.0 + ambientOcclusion );
}`,Gx=`
vec3 geometryPosition = - vViewPosition;
vec3 geometryNormal = normal;
vec3 geometryViewDir = ( isOrthographic ) ? vec3( 0, 0, 1 ) : normalize( vViewPosition );
vec3 geometryClearcoatNormal = vec3( 0.0 );
#ifdef USE_CLEARCOAT
	geometryClearcoatNormal = clearcoatNormal;
#endif
#ifdef USE_IRIDESCENCE
	float dotNVi = saturate( dot( normal, geometryViewDir ) );
	if ( material.iridescenceThickness == 0.0 ) {
		material.iridescence = 0.0;
	} else {
		material.iridescence = saturate( material.iridescence );
	}
	if ( material.iridescence > 0.0 ) {
		material.iridescenceFresnelDielectric = evalIridescence( 1.0, material.iridescenceIOR, dotNVi, material.iridescenceThickness, material.specularColor );
		material.iridescenceFresnelMetallic = evalIridescence( 1.0, material.iridescenceIOR, dotNVi, material.iridescenceThickness, material.diffuseColor );
		material.iridescenceFresnel = mix( material.iridescenceFresnelDielectric, material.iridescenceFresnelMetallic, material.metalness );
		material.iridescenceF0 = Schlick_to_F0( material.iridescenceFresnel, 1.0, dotNVi );
	}
#endif
IncidentLight directLight;
#if ( NUM_POINT_LIGHTS > 0 ) && defined( RE_Direct )
	PointLight pointLight;
	#if defined( USE_SHADOWMAP ) && NUM_POINT_LIGHT_SHADOWS > 0
	PointLightShadow pointLightShadow;
	#endif
	#pragma unroll_loop_start
	for ( int i = 0; i < NUM_POINT_LIGHTS; i ++ ) {
		pointLight = pointLights[ i ];
		getPointLightInfo( pointLight, geometryPosition, directLight );
		#if defined( USE_SHADOWMAP ) && ( UNROLLED_LOOP_INDEX < NUM_POINT_LIGHT_SHADOWS ) && ( defined( SHADOWMAP_TYPE_PCF ) || defined( SHADOWMAP_TYPE_BASIC ) )
		pointLightShadow = pointLightShadows[ i ];
		directLight.color *= ( directLight.visible && receiveShadow ) ? getPointShadow( pointShadowMap[ i ], pointLightShadow.shadowMapSize, pointLightShadow.shadowIntensity, pointLightShadow.shadowBias, pointLightShadow.shadowRadius, vPointShadowCoord[ i ], pointLightShadow.shadowCameraNear, pointLightShadow.shadowCameraFar ) : 1.0;
		#endif
		RE_Direct( directLight, geometryPosition, geometryNormal, geometryViewDir, geometryClearcoatNormal, material, reflectedLight );
	}
	#pragma unroll_loop_end
#endif
#if ( NUM_SPOT_LIGHTS > 0 ) && defined( RE_Direct )
	SpotLight spotLight;
	vec4 spotColor;
	vec3 spotLightCoord;
	bool inSpotLightMap;
	#if defined( USE_SHADOWMAP ) && NUM_SPOT_LIGHT_SHADOWS > 0
	SpotLightShadow spotLightShadow;
	#endif
	#pragma unroll_loop_start
	for ( int i = 0; i < NUM_SPOT_LIGHTS; i ++ ) {
		spotLight = spotLights[ i ];
		getSpotLightInfo( spotLight, geometryPosition, directLight );
		#if ( UNROLLED_LOOP_INDEX < NUM_SPOT_LIGHT_SHADOWS_WITH_MAPS )
		#define SPOT_LIGHT_MAP_INDEX UNROLLED_LOOP_INDEX
		#elif ( UNROLLED_LOOP_INDEX < NUM_SPOT_LIGHT_SHADOWS )
		#define SPOT_LIGHT_MAP_INDEX NUM_SPOT_LIGHT_MAPS
		#else
		#define SPOT_LIGHT_MAP_INDEX ( UNROLLED_LOOP_INDEX - NUM_SPOT_LIGHT_SHADOWS + NUM_SPOT_LIGHT_SHADOWS_WITH_MAPS )
		#endif
		#if ( SPOT_LIGHT_MAP_INDEX < NUM_SPOT_LIGHT_MAPS )
			spotLightCoord = vSpotLightCoord[ i ].xyz / vSpotLightCoord[ i ].w;
			inSpotLightMap = all( lessThan( abs( spotLightCoord * 2. - 1. ), vec3( 1.0 ) ) );
			spotColor = texture2D( spotLightMap[ SPOT_LIGHT_MAP_INDEX ], spotLightCoord.xy );
			directLight.color = inSpotLightMap ? directLight.color * spotColor.rgb : directLight.color;
		#endif
		#undef SPOT_LIGHT_MAP_INDEX
		#if defined( USE_SHADOWMAP ) && ( UNROLLED_LOOP_INDEX < NUM_SPOT_LIGHT_SHADOWS )
		spotLightShadow = spotLightShadows[ i ];
		directLight.color *= ( directLight.visible && receiveShadow ) ? getShadow( spotShadowMap[ i ], spotLightShadow.shadowMapSize, spotLightShadow.shadowIntensity, spotLightShadow.shadowBias, spotLightShadow.shadowRadius, vSpotLightCoord[ i ] ) : 1.0;
		#endif
		RE_Direct( directLight, geometryPosition, geometryNormal, geometryViewDir, geometryClearcoatNormal, material, reflectedLight );
	}
	#pragma unroll_loop_end
#endif
#if ( NUM_DIR_LIGHTS > 0 ) && defined( RE_Direct )
	DirectionalLight directionalLight;
	#if defined( USE_SHADOWMAP ) && NUM_DIR_LIGHT_SHADOWS > 0
	DirectionalLightShadow directionalLightShadow;
	#endif
	#pragma unroll_loop_start
	for ( int i = 0; i < NUM_DIR_LIGHTS; i ++ ) {
		directionalLight = directionalLights[ i ];
		getDirectionalLightInfo( directionalLight, directLight );
		#if defined( USE_SHADOWMAP ) && ( UNROLLED_LOOP_INDEX < NUM_DIR_LIGHT_SHADOWS )
		directionalLightShadow = directionalLightShadows[ i ];
		directLight.color *= ( directLight.visible && receiveShadow ) ? getShadow( directionalShadowMap[ i ], directionalLightShadow.shadowMapSize, directionalLightShadow.shadowIntensity, directionalLightShadow.shadowBias, directionalLightShadow.shadowRadius, vDirectionalShadowCoord[ i ] ) : 1.0;
		#endif
		RE_Direct( directLight, geometryPosition, geometryNormal, geometryViewDir, geometryClearcoatNormal, material, reflectedLight );
	}
	#pragma unroll_loop_end
#endif
#if ( NUM_RECT_AREA_LIGHTS > 0 ) && defined( RE_Direct_RectArea )
	RectAreaLight rectAreaLight;
	#pragma unroll_loop_start
	for ( int i = 0; i < NUM_RECT_AREA_LIGHTS; i ++ ) {
		rectAreaLight = rectAreaLights[ i ];
		RE_Direct_RectArea( rectAreaLight, geometryPosition, geometryNormal, geometryViewDir, geometryClearcoatNormal, material, reflectedLight );
	}
	#pragma unroll_loop_end
#endif
#if defined( RE_IndirectDiffuse )
	vec3 iblIrradiance = vec3( 0.0 );
	vec3 irradiance = getAmbientLightIrradiance( ambientLightColor );
	#if defined( USE_LIGHT_PROBES )
		irradiance += getLightProbeIrradiance( lightProbe, geometryNormal );
	#endif
	#if ( NUM_HEMI_LIGHTS > 0 )
		#pragma unroll_loop_start
		for ( int i = 0; i < NUM_HEMI_LIGHTS; i ++ ) {
			irradiance += getHemisphereLightIrradiance( hemisphereLights[ i ], geometryNormal );
		}
		#pragma unroll_loop_end
	#endif
	#ifdef USE_LIGHT_PROBES_GRID
		vec3 probeWorldPos = ( ( vec4( geometryPosition, 1.0 ) - viewMatrix[ 3 ] ) * viewMatrix ).xyz;
		vec3 probeWorldNormal = inverseTransformDirection( geometryNormal, viewMatrix );
		irradiance += getLightProbeGridIrradiance( probeWorldPos, probeWorldNormal );
	#endif
#endif
#if defined( RE_IndirectSpecular )
	vec3 radiance = vec3( 0.0 );
	vec3 clearcoatRadiance = vec3( 0.0 );
#endif`,kx=`#if defined( RE_IndirectDiffuse )
	#ifdef USE_LIGHTMAP
		vec4 lightMapTexel = texture2D( lightMap, vLightMapUv );
		vec3 lightMapIrradiance = lightMapTexel.rgb * lightMapIntensity;
		irradiance += lightMapIrradiance;
	#endif
	#if defined( USE_ENVMAP ) && defined( ENVMAP_TYPE_CUBE_UV )
		#if defined( STANDARD ) || defined( LAMBERT ) || defined( PHONG )
			iblIrradiance += getIBLIrradiance( geometryNormal );
		#endif
	#endif
#endif
#if defined( USE_ENVMAP ) && defined( RE_IndirectSpecular )
	#ifdef USE_ANISOTROPY
		radiance += getIBLAnisotropyRadiance( geometryViewDir, geometryNormal, material.roughness, material.anisotropyB, material.anisotropy );
	#else
		radiance += getIBLRadiance( geometryViewDir, geometryNormal, material.roughness );
	#endif
	#ifdef USE_CLEARCOAT
		clearcoatRadiance += getIBLRadiance( geometryViewDir, geometryClearcoatNormal, material.clearcoatRoughness );
	#endif
#endif`,Wx=`#if defined( RE_IndirectDiffuse )
	#if defined( LAMBERT ) || defined( PHONG )
		irradiance += iblIrradiance;
	#endif
	RE_IndirectDiffuse( irradiance, geometryPosition, geometryNormal, geometryViewDir, geometryClearcoatNormal, material, reflectedLight );
#endif
#if defined( RE_IndirectSpecular )
	RE_IndirectSpecular( radiance, iblIrradiance, clearcoatRadiance, geometryPosition, geometryNormal, geometryViewDir, geometryClearcoatNormal, material, reflectedLight );
#endif`,Xx=`#ifdef USE_LIGHT_PROBES_GRID
uniform highp sampler3D probesSH;
uniform vec3 probesMin;
uniform vec3 probesMax;
uniform vec3 probesResolution;
vec3 getLightProbeGridIrradiance( vec3 worldPos, vec3 worldNormal ) {
	vec3 res = probesResolution;
	vec3 gridRange = probesMax - probesMin;
	vec3 resMinusOne = res - 1.0;
	vec3 probeSpacing = gridRange / resMinusOne;
	vec3 samplePos = worldPos + worldNormal * probeSpacing * 0.5;
	vec3 uvw = clamp( ( samplePos - probesMin ) / gridRange, 0.0, 1.0 );
	uvw = uvw * resMinusOne / res + 0.5 / res;
	float nz          = res.z;
	float paddedSlices = nz + 2.0;
	float atlasDepth  = 7.0 * paddedSlices;
	float uvZBase     = uvw.z * nz + 1.0;
	vec4 s0 = texture( probesSH, vec3( uvw.xy, ( uvZBase                       ) / atlasDepth ) );
	vec4 s1 = texture( probesSH, vec3( uvw.xy, ( uvZBase +       paddedSlices   ) / atlasDepth ) );
	vec4 s2 = texture( probesSH, vec3( uvw.xy, ( uvZBase + 2.0 * paddedSlices   ) / atlasDepth ) );
	vec4 s3 = texture( probesSH, vec3( uvw.xy, ( uvZBase + 3.0 * paddedSlices   ) / atlasDepth ) );
	vec4 s4 = texture( probesSH, vec3( uvw.xy, ( uvZBase + 4.0 * paddedSlices   ) / atlasDepth ) );
	vec4 s5 = texture( probesSH, vec3( uvw.xy, ( uvZBase + 5.0 * paddedSlices   ) / atlasDepth ) );
	vec4 s6 = texture( probesSH, vec3( uvw.xy, ( uvZBase + 6.0 * paddedSlices   ) / atlasDepth ) );
	vec3 c0 = s0.xyz;
	vec3 c1 = vec3( s0.w, s1.xy );
	vec3 c2 = vec3( s1.zw, s2.x );
	vec3 c3 = s2.yzw;
	vec3 c4 = s3.xyz;
	vec3 c5 = vec3( s3.w, s4.xy );
	vec3 c6 = vec3( s4.zw, s5.x );
	vec3 c7 = s5.yzw;
	vec3 c8 = s6.xyz;
	float x = worldNormal.x, y = worldNormal.y, z = worldNormal.z;
	vec3 result = c0 * 0.886227;
	result += c1 * 2.0 * 0.511664 * y;
	result += c2 * 2.0 * 0.511664 * z;
	result += c3 * 2.0 * 0.511664 * x;
	result += c4 * 2.0 * 0.429043 * x * y;
	result += c5 * 2.0 * 0.429043 * y * z;
	result += c6 * ( 0.743125 * z * z - 0.247708 );
	result += c7 * 2.0 * 0.429043 * x * z;
	result += c8 * 0.429043 * ( x * x - y * y );
	return max( result, vec3( 0.0 ) );
}
#endif`,Yx=`#if defined( USE_LOGARITHMIC_DEPTH_BUFFER )
	gl_FragDepth = vIsPerspective == 0.0 ? gl_FragCoord.z : log2( vFragDepth ) * logDepthBufFC * 0.5;
#endif`,qx=`#if defined( USE_LOGARITHMIC_DEPTH_BUFFER )
	uniform float logDepthBufFC;
	varying float vFragDepth;
	varying float vIsPerspective;
#endif`,Kx=`#ifdef USE_LOGARITHMIC_DEPTH_BUFFER
	varying float vFragDepth;
	varying float vIsPerspective;
#endif`,jx=`#ifdef USE_LOGARITHMIC_DEPTH_BUFFER
	vFragDepth = 1.0 + gl_Position.w;
	vIsPerspective = float( isPerspectiveMatrix( projectionMatrix ) );
#endif`,Zx=`#ifdef USE_MAP
	vec4 sampledDiffuseColor = texture2D( map, vMapUv );
	#ifdef DECODE_VIDEO_TEXTURE
		sampledDiffuseColor = sRGBTransferEOTF( sampledDiffuseColor );
	#endif
	diffuseColor *= sampledDiffuseColor;
#endif`,$x=`#ifdef USE_MAP
	uniform sampler2D map;
#endif`,Jx=`#if defined( USE_MAP ) || defined( USE_ALPHAMAP )
	#if defined( USE_POINTS_UV )
		vec2 uv = vUv;
	#else
		vec2 uv = ( uvTransform * vec3( gl_PointCoord.x, 1.0 - gl_PointCoord.y, 1 ) ).xy;
	#endif
#endif
#ifdef USE_MAP
	diffuseColor *= texture2D( map, uv );
#endif
#ifdef USE_ALPHAMAP
	diffuseColor.a *= texture2D( alphaMap, uv ).g;
#endif`,Qx=`#if defined( USE_POINTS_UV )
	varying vec2 vUv;
#else
	#if defined( USE_MAP ) || defined( USE_ALPHAMAP )
		uniform mat3 uvTransform;
	#endif
#endif
#ifdef USE_MAP
	uniform sampler2D map;
#endif
#ifdef USE_ALPHAMAP
	uniform sampler2D alphaMap;
#endif`,ev=`float metalnessFactor = metalness;
#ifdef USE_METALNESSMAP
	vec4 texelMetalness = texture2D( metalnessMap, vMetalnessMapUv );
	metalnessFactor *= texelMetalness.b;
#endif`,tv=`#ifdef USE_METALNESSMAP
	uniform sampler2D metalnessMap;
#endif`,nv=`#ifdef USE_INSTANCING_MORPH
	float morphTargetInfluences[ MORPHTARGETS_COUNT ];
	float morphTargetBaseInfluence = texelFetch( morphTexture, ivec2( 0, gl_InstanceID ), 0 ).r;
	for ( int i = 0; i < MORPHTARGETS_COUNT; i ++ ) {
		morphTargetInfluences[i] =  texelFetch( morphTexture, ivec2( i + 1, gl_InstanceID ), 0 ).r;
	}
#endif`,iv=`#if defined( USE_MORPHCOLORS )
	vColor *= morphTargetBaseInfluence;
	for ( int i = 0; i < MORPHTARGETS_COUNT; i ++ ) {
		#if defined( USE_COLOR_ALPHA )
			if ( morphTargetInfluences[ i ] != 0.0 ) vColor += getMorph( gl_VertexID, i, 2 ) * morphTargetInfluences[ i ];
		#elif defined( USE_COLOR )
			if ( morphTargetInfluences[ i ] != 0.0 ) vColor += getMorph( gl_VertexID, i, 2 ).rgb * morphTargetInfluences[ i ];
		#endif
	}
#endif`,rv=`#ifdef USE_MORPHNORMALS
	objectNormal *= morphTargetBaseInfluence;
	for ( int i = 0; i < MORPHTARGETS_COUNT; i ++ ) {
		if ( morphTargetInfluences[ i ] != 0.0 ) objectNormal += getMorph( gl_VertexID, i, 1 ).xyz * morphTargetInfluences[ i ];
	}
#endif`,sv=`#ifdef USE_MORPHTARGETS
	#ifndef USE_INSTANCING_MORPH
		uniform float morphTargetBaseInfluence;
		uniform float morphTargetInfluences[ MORPHTARGETS_COUNT ];
	#endif
	uniform sampler2DArray morphTargetsTexture;
	uniform ivec2 morphTargetsTextureSize;
	vec4 getMorph( const in int vertexIndex, const in int morphTargetIndex, const in int offset ) {
		int texelIndex = vertexIndex * MORPHTARGETS_TEXTURE_STRIDE + offset;
		int y = texelIndex / morphTargetsTextureSize.x;
		int x = texelIndex - y * morphTargetsTextureSize.x;
		ivec3 morphUV = ivec3( x, y, morphTargetIndex );
		return texelFetch( morphTargetsTexture, morphUV, 0 );
	}
#endif`,ov=`#ifdef USE_MORPHTARGETS
	transformed *= morphTargetBaseInfluence;
	for ( int i = 0; i < MORPHTARGETS_COUNT; i ++ ) {
		if ( morphTargetInfluences[ i ] != 0.0 ) transformed += getMorph( gl_VertexID, i, 0 ).xyz * morphTargetInfluences[ i ];
	}
#endif`,av=`float faceDirection = gl_FrontFacing ? 1.0 : - 1.0;
#ifdef FLAT_SHADED
	vec3 fdx = dFdx( vViewPosition );
	vec3 fdy = dFdy( vViewPosition );
	vec3 normal = normalize( cross( fdx, fdy ) );
#else
	vec3 normal = normalize( vNormal );
	#ifdef DOUBLE_SIDED
		normal *= faceDirection;
	#endif
#endif
#if defined( USE_NORMALMAP_TANGENTSPACE ) || defined( USE_CLEARCOAT_NORMALMAP ) || defined( USE_ANISOTROPY )
	#ifdef USE_TANGENT
		mat3 tbn = mat3( normalize( vTangent ), normalize( vBitangent ), normal );
	#else
		mat3 tbn = getTangentFrame( - vViewPosition, normal,
		#if defined( USE_NORMALMAP )
			vNormalMapUv
		#elif defined( USE_CLEARCOAT_NORMALMAP )
			vClearcoatNormalMapUv
		#else
			vUv
		#endif
		);
	#endif
	#if defined( DOUBLE_SIDED ) && ! defined( FLAT_SHADED )
		tbn[0] *= faceDirection;
		tbn[1] *= faceDirection;
	#endif
#endif
#ifdef USE_CLEARCOAT_NORMALMAP
	#ifdef USE_TANGENT
		mat3 tbn2 = mat3( normalize( vTangent ), normalize( vBitangent ), normal );
	#else
		mat3 tbn2 = getTangentFrame( - vViewPosition, normal, vClearcoatNormalMapUv );
	#endif
	#if defined( DOUBLE_SIDED ) && ! defined( FLAT_SHADED )
		tbn2[0] *= faceDirection;
		tbn2[1] *= faceDirection;
	#endif
#endif
vec3 nonPerturbedNormal = normal;`,lv=`#ifdef USE_NORMALMAP_OBJECTSPACE
	normal = texture2D( normalMap, vNormalMapUv ).xyz * 2.0 - 1.0;
	#ifdef FLIP_SIDED
		normal = - normal;
	#endif
	#ifdef DOUBLE_SIDED
		normal = normal * faceDirection;
	#endif
	normal = normalize( normalMatrix * normal );
#elif defined( USE_NORMALMAP_TANGENTSPACE )
	vec3 mapN = texture2D( normalMap, vNormalMapUv ).xyz * 2.0 - 1.0;
	#if defined( USE_PACKED_NORMALMAP )
		mapN = vec3( mapN.xy, sqrt( saturate( 1.0 - dot( mapN.xy, mapN.xy ) ) ) );
	#endif
	mapN.xy *= normalScale;
	normal = normalize( tbn * mapN );
#elif defined( USE_BUMPMAP )
	normal = perturbNormalArb( - vViewPosition, normal, dHdxy_fwd(), faceDirection );
#endif`,cv=`#ifndef FLAT_SHADED
	varying vec3 vNormal;
	#ifdef USE_TANGENT
		varying vec3 vTangent;
		varying vec3 vBitangent;
	#endif
#endif`,uv=`#ifndef FLAT_SHADED
	varying vec3 vNormal;
	#ifdef USE_TANGENT
		varying vec3 vTangent;
		varying vec3 vBitangent;
	#endif
#endif`,fv=`#ifndef FLAT_SHADED
	vNormal = normalize( transformedNormal );
	#ifdef USE_TANGENT
		vTangent = normalize( transformedTangent );
		vBitangent = normalize( cross( vNormal, vTangent ) * tangent.w );
	#endif
#endif`,hv=`#ifdef USE_NORMALMAP
	uniform sampler2D normalMap;
	uniform vec2 normalScale;
#endif
#ifdef USE_NORMALMAP_OBJECTSPACE
	uniform mat3 normalMatrix;
#endif
#if ! defined ( USE_TANGENT ) && ( defined ( USE_NORMALMAP_TANGENTSPACE ) || defined ( USE_CLEARCOAT_NORMALMAP ) || defined( USE_ANISOTROPY ) )
	mat3 getTangentFrame( vec3 eye_pos, vec3 surf_norm, vec2 uv ) {
		vec3 q0 = dFdx( eye_pos.xyz );
		vec3 q1 = dFdy( eye_pos.xyz );
		vec2 st0 = dFdx( uv.st );
		vec2 st1 = dFdy( uv.st );
		vec3 N = surf_norm;
		vec3 q1perp = cross( q1, N );
		vec3 q0perp = cross( N, q0 );
		vec3 T = q1perp * st0.x + q0perp * st1.x;
		vec3 B = q1perp * st0.y + q0perp * st1.y;
		float det = max( dot( T, T ), dot( B, B ) );
		float scale = ( det == 0.0 ) ? 0.0 : inversesqrt( det );
		return mat3( T * scale, B * scale, N );
	}
#endif`,dv=`#ifdef USE_CLEARCOAT
	vec3 clearcoatNormal = nonPerturbedNormal;
#endif`,pv=`#ifdef USE_CLEARCOAT_NORMALMAP
	vec3 clearcoatMapN = texture2D( clearcoatNormalMap, vClearcoatNormalMapUv ).xyz * 2.0 - 1.0;
	clearcoatMapN.xy *= clearcoatNormalScale;
	clearcoatNormal = normalize( tbn2 * clearcoatMapN );
#endif`,mv=`#ifdef USE_CLEARCOATMAP
	uniform sampler2D clearcoatMap;
#endif
#ifdef USE_CLEARCOAT_NORMALMAP
	uniform sampler2D clearcoatNormalMap;
	uniform vec2 clearcoatNormalScale;
#endif
#ifdef USE_CLEARCOAT_ROUGHNESSMAP
	uniform sampler2D clearcoatRoughnessMap;
#endif`,gv=`#ifdef USE_IRIDESCENCEMAP
	uniform sampler2D iridescenceMap;
#endif
#ifdef USE_IRIDESCENCE_THICKNESSMAP
	uniform sampler2D iridescenceThicknessMap;
#endif`,_v=`#ifdef OPAQUE
diffuseColor.a = 1.0;
#endif
#ifdef USE_TRANSMISSION
diffuseColor.a *= material.transmissionAlpha;
#endif
gl_FragColor = vec4( outgoingLight, diffuseColor.a );`,xv=`vec3 packNormalToRGB( const in vec3 normal ) {
	return normalize( normal ) * 0.5 + 0.5;
}
vec3 unpackRGBToNormal( const in vec3 rgb ) {
	return 2.0 * rgb.xyz - 1.0;
}
const float PackUpscale = 256. / 255.;const float UnpackDownscale = 255. / 256.;const float ShiftRight8 = 1. / 256.;
const float Inv255 = 1. / 255.;
const vec4 PackFactors = vec4( 1.0, 256.0, 256.0 * 256.0, 256.0 * 256.0 * 256.0 );
const vec2 UnpackFactors2 = vec2( UnpackDownscale, 1.0 / PackFactors.g );
const vec3 UnpackFactors3 = vec3( UnpackDownscale / PackFactors.rg, 1.0 / PackFactors.b );
const vec4 UnpackFactors4 = vec4( UnpackDownscale / PackFactors.rgb, 1.0 / PackFactors.a );
vec4 packDepthToRGBA( const in float v ) {
	if( v <= 0.0 )
		return vec4( 0., 0., 0., 0. );
	if( v >= 1.0 )
		return vec4( 1., 1., 1., 1. );
	float vuf;
	float af = modf( v * PackFactors.a, vuf );
	float bf = modf( vuf * ShiftRight8, vuf );
	float gf = modf( vuf * ShiftRight8, vuf );
	return vec4( vuf * Inv255, gf * PackUpscale, bf * PackUpscale, af );
}
vec3 packDepthToRGB( const in float v ) {
	if( v <= 0.0 )
		return vec3( 0., 0., 0. );
	if( v >= 1.0 )
		return vec3( 1., 1., 1. );
	float vuf;
	float bf = modf( v * PackFactors.b, vuf );
	float gf = modf( vuf * ShiftRight8, vuf );
	return vec3( vuf * Inv255, gf * PackUpscale, bf );
}
vec2 packDepthToRG( const in float v ) {
	if( v <= 0.0 )
		return vec2( 0., 0. );
	if( v >= 1.0 )
		return vec2( 1., 1. );
	float vuf;
	float gf = modf( v * 256., vuf );
	return vec2( vuf * Inv255, gf );
}
float unpackRGBAToDepth( const in vec4 v ) {
	return dot( v, UnpackFactors4 );
}
float unpackRGBToDepth( const in vec3 v ) {
	return dot( v, UnpackFactors3 );
}
float unpackRGToDepth( const in vec2 v ) {
	return v.r * UnpackFactors2.r + v.g * UnpackFactors2.g;
}
vec4 pack2HalfToRGBA( const in vec2 v ) {
	vec4 r = vec4( v.x, fract( v.x * 255.0 ), v.y, fract( v.y * 255.0 ) );
	return vec4( r.x - r.y / 255.0, r.y, r.z - r.w / 255.0, r.w );
}
vec2 unpackRGBATo2Half( const in vec4 v ) {
	return vec2( v.x + ( v.y / 255.0 ), v.z + ( v.w / 255.0 ) );
}
float viewZToOrthographicDepth( const in float viewZ, const in float near, const in float far ) {
	return ( viewZ + near ) / ( near - far );
}
float orthographicDepthToViewZ( const in float depth, const in float near, const in float far ) {
	#ifdef USE_REVERSED_DEPTH_BUFFER
	
		return depth * ( far - near ) - far;
	#else
		return depth * ( near - far ) - near;
	#endif
}
float viewZToPerspectiveDepth( const in float viewZ, const in float near, const in float far ) {
	return ( ( near + viewZ ) * far ) / ( ( far - near ) * viewZ );
}
float perspectiveDepthToViewZ( const in float depth, const in float near, const in float far ) {
	
	#ifdef USE_REVERSED_DEPTH_BUFFER
		return ( near * far ) / ( ( near - far ) * depth - near );
	#else
		return ( near * far ) / ( ( far - near ) * depth - far );
	#endif
}`,vv=`#ifdef PREMULTIPLIED_ALPHA
	gl_FragColor.rgb *= gl_FragColor.a;
#endif`,Mv=`vec4 mvPosition = vec4( transformed, 1.0 );
#ifdef USE_BATCHING
	mvPosition = batchingMatrix * mvPosition;
#endif
#ifdef USE_INSTANCING
	mvPosition = instanceMatrix * mvPosition;
#endif
mvPosition = modelViewMatrix * mvPosition;
gl_Position = projectionMatrix * mvPosition;`,Sv=`#ifdef DITHERING
	gl_FragColor.rgb = dithering( gl_FragColor.rgb );
#endif`,Ev=`#ifdef DITHERING
	vec3 dithering( vec3 color ) {
		float grid_position = rand( gl_FragCoord.xy );
		vec3 dither_shift_RGB = vec3( 0.25 / 255.0, -0.25 / 255.0, 0.25 / 255.0 );
		dither_shift_RGB = mix( 2.0 * dither_shift_RGB, -2.0 * dither_shift_RGB, grid_position );
		return color + dither_shift_RGB;
	}
#endif`,yv=`float roughnessFactor = roughness;
#ifdef USE_ROUGHNESSMAP
	vec4 texelRoughness = texture2D( roughnessMap, vRoughnessMapUv );
	roughnessFactor *= texelRoughness.g;
#endif`,bv=`#ifdef USE_ROUGHNESSMAP
	uniform sampler2D roughnessMap;
#endif`,Tv=`#if NUM_SPOT_LIGHT_COORDS > 0
	varying vec4 vSpotLightCoord[ NUM_SPOT_LIGHT_COORDS ];
#endif
#if NUM_SPOT_LIGHT_MAPS > 0
	uniform sampler2D spotLightMap[ NUM_SPOT_LIGHT_MAPS ];
#endif
#ifdef USE_SHADOWMAP
	#if NUM_DIR_LIGHT_SHADOWS > 0
		#if defined( SHADOWMAP_TYPE_PCF )
			uniform sampler2DShadow directionalShadowMap[ NUM_DIR_LIGHT_SHADOWS ];
		#else
			uniform sampler2D directionalShadowMap[ NUM_DIR_LIGHT_SHADOWS ];
		#endif
		varying vec4 vDirectionalShadowCoord[ NUM_DIR_LIGHT_SHADOWS ];
		struct DirectionalLightShadow {
			float shadowIntensity;
			float shadowBias;
			float shadowNormalBias;
			float shadowRadius;
			vec2 shadowMapSize;
		};
		uniform DirectionalLightShadow directionalLightShadows[ NUM_DIR_LIGHT_SHADOWS ];
	#endif
	#if NUM_SPOT_LIGHT_SHADOWS > 0
		#if defined( SHADOWMAP_TYPE_PCF )
			uniform sampler2DShadow spotShadowMap[ NUM_SPOT_LIGHT_SHADOWS ];
		#else
			uniform sampler2D spotShadowMap[ NUM_SPOT_LIGHT_SHADOWS ];
		#endif
		struct SpotLightShadow {
			float shadowIntensity;
			float shadowBias;
			float shadowNormalBias;
			float shadowRadius;
			vec2 shadowMapSize;
		};
		uniform SpotLightShadow spotLightShadows[ NUM_SPOT_LIGHT_SHADOWS ];
	#endif
	#if NUM_POINT_LIGHT_SHADOWS > 0
		#if defined( SHADOWMAP_TYPE_PCF )
			uniform samplerCubeShadow pointShadowMap[ NUM_POINT_LIGHT_SHADOWS ];
		#elif defined( SHADOWMAP_TYPE_BASIC )
			uniform samplerCube pointShadowMap[ NUM_POINT_LIGHT_SHADOWS ];
		#endif
		varying vec4 vPointShadowCoord[ NUM_POINT_LIGHT_SHADOWS ];
		struct PointLightShadow {
			float shadowIntensity;
			float shadowBias;
			float shadowNormalBias;
			float shadowRadius;
			vec2 shadowMapSize;
			float shadowCameraNear;
			float shadowCameraFar;
		};
		uniform PointLightShadow pointLightShadows[ NUM_POINT_LIGHT_SHADOWS ];
	#endif
	#if defined( SHADOWMAP_TYPE_PCF )
		float interleavedGradientNoise( vec2 position ) {
			return fract( 52.9829189 * fract( dot( position, vec2( 0.06711056, 0.00583715 ) ) ) );
		}
		vec2 vogelDiskSample( int sampleIndex, int samplesCount, float phi ) {
			const float goldenAngle = 2.399963229728653;
			float r = sqrt( ( float( sampleIndex ) + 0.5 ) / float( samplesCount ) );
			float theta = float( sampleIndex ) * goldenAngle + phi;
			return vec2( cos( theta ), sin( theta ) ) * r;
		}
	#endif
	#if defined( SHADOWMAP_TYPE_PCF )
		float getShadow( sampler2DShadow shadowMap, vec2 shadowMapSize, float shadowIntensity, float shadowBias, float shadowRadius, vec4 shadowCoord ) {
			float shadow = 1.0;
			shadowCoord.xyz /= shadowCoord.w;
			shadowCoord.z += shadowBias;
			bool inFrustum = shadowCoord.x >= 0.0 && shadowCoord.x <= 1.0 && shadowCoord.y >= 0.0 && shadowCoord.y <= 1.0;
			bool frustumTest = inFrustum && shadowCoord.z <= 1.0;
			if ( frustumTest ) {
				vec2 texelSize = vec2( 1.0 ) / shadowMapSize;
				float radius = shadowRadius * texelSize.x;
				float phi = interleavedGradientNoise( gl_FragCoord.xy ) * PI2;
				shadow = (
					texture( shadowMap, vec3( shadowCoord.xy + vogelDiskSample( 0, 5, phi ) * radius, shadowCoord.z ) ) +
					texture( shadowMap, vec3( shadowCoord.xy + vogelDiskSample( 1, 5, phi ) * radius, shadowCoord.z ) ) +
					texture( shadowMap, vec3( shadowCoord.xy + vogelDiskSample( 2, 5, phi ) * radius, shadowCoord.z ) ) +
					texture( shadowMap, vec3( shadowCoord.xy + vogelDiskSample( 3, 5, phi ) * radius, shadowCoord.z ) ) +
					texture( shadowMap, vec3( shadowCoord.xy + vogelDiskSample( 4, 5, phi ) * radius, shadowCoord.z ) )
				) * 0.2;
			}
			return mix( 1.0, shadow, shadowIntensity );
		}
	#elif defined( SHADOWMAP_TYPE_VSM )
		float getShadow( sampler2D shadowMap, vec2 shadowMapSize, float shadowIntensity, float shadowBias, float shadowRadius, vec4 shadowCoord ) {
			float shadow = 1.0;
			shadowCoord.xyz /= shadowCoord.w;
			#ifdef USE_REVERSED_DEPTH_BUFFER
				shadowCoord.z -= shadowBias;
			#else
				shadowCoord.z += shadowBias;
			#endif
			bool inFrustum = shadowCoord.x >= 0.0 && shadowCoord.x <= 1.0 && shadowCoord.y >= 0.0 && shadowCoord.y <= 1.0;
			bool frustumTest = inFrustum && shadowCoord.z <= 1.0;
			if ( frustumTest ) {
				vec2 distribution = texture2D( shadowMap, shadowCoord.xy ).rg;
				float mean = distribution.x;
				float variance = distribution.y * distribution.y;
				#ifdef USE_REVERSED_DEPTH_BUFFER
					float hard_shadow = step( mean, shadowCoord.z );
				#else
					float hard_shadow = step( shadowCoord.z, mean );
				#endif
				
				if ( hard_shadow == 1.0 ) {
					shadow = 1.0;
				} else {
					variance = max( variance, 0.0000001 );
					float d = shadowCoord.z - mean;
					float p_max = variance / ( variance + d * d );
					p_max = clamp( ( p_max - 0.3 ) / 0.65, 0.0, 1.0 );
					shadow = max( hard_shadow, p_max );
				}
			}
			return mix( 1.0, shadow, shadowIntensity );
		}
	#else
		float getShadow( sampler2D shadowMap, vec2 shadowMapSize, float shadowIntensity, float shadowBias, float shadowRadius, vec4 shadowCoord ) {
			float shadow = 1.0;
			shadowCoord.xyz /= shadowCoord.w;
			#ifdef USE_REVERSED_DEPTH_BUFFER
				shadowCoord.z -= shadowBias;
			#else
				shadowCoord.z += shadowBias;
			#endif
			bool inFrustum = shadowCoord.x >= 0.0 && shadowCoord.x <= 1.0 && shadowCoord.y >= 0.0 && shadowCoord.y <= 1.0;
			bool frustumTest = inFrustum && shadowCoord.z <= 1.0;
			if ( frustumTest ) {
				float depth = texture2D( shadowMap, shadowCoord.xy ).r;
				#ifdef USE_REVERSED_DEPTH_BUFFER
					shadow = step( depth, shadowCoord.z );
				#else
					shadow = step( shadowCoord.z, depth );
				#endif
			}
			return mix( 1.0, shadow, shadowIntensity );
		}
	#endif
	#if NUM_POINT_LIGHT_SHADOWS > 0
	#if defined( SHADOWMAP_TYPE_PCF )
	float getPointShadow( samplerCubeShadow shadowMap, vec2 shadowMapSize, float shadowIntensity, float shadowBias, float shadowRadius, vec4 shadowCoord, float shadowCameraNear, float shadowCameraFar ) {
		float shadow = 1.0;
		vec3 lightToPosition = shadowCoord.xyz;
		vec3 bd3D = normalize( lightToPosition );
		vec3 absVec = abs( lightToPosition );
		float viewSpaceZ = max( max( absVec.x, absVec.y ), absVec.z );
		if ( viewSpaceZ - shadowCameraFar <= 0.0 && viewSpaceZ - shadowCameraNear >= 0.0 ) {
			#ifdef USE_REVERSED_DEPTH_BUFFER
				float dp = ( shadowCameraNear * ( shadowCameraFar - viewSpaceZ ) ) / ( viewSpaceZ * ( shadowCameraFar - shadowCameraNear ) );
				dp -= shadowBias;
			#else
				float dp = ( shadowCameraFar * ( viewSpaceZ - shadowCameraNear ) ) / ( viewSpaceZ * ( shadowCameraFar - shadowCameraNear ) );
				dp += shadowBias;
			#endif
			float texelSize = shadowRadius / shadowMapSize.x;
			vec3 absDir = abs( bd3D );
			vec3 tangent = absDir.x > absDir.z ? vec3( 0.0, 1.0, 0.0 ) : vec3( 1.0, 0.0, 0.0 );
			tangent = normalize( cross( bd3D, tangent ) );
			vec3 bitangent = cross( bd3D, tangent );
			float phi = interleavedGradientNoise( gl_FragCoord.xy ) * PI2;
			vec2 sample0 = vogelDiskSample( 0, 5, phi );
			vec2 sample1 = vogelDiskSample( 1, 5, phi );
			vec2 sample2 = vogelDiskSample( 2, 5, phi );
			vec2 sample3 = vogelDiskSample( 3, 5, phi );
			vec2 sample4 = vogelDiskSample( 4, 5, phi );
			shadow = (
				texture( shadowMap, vec4( bd3D + ( tangent * sample0.x + bitangent * sample0.y ) * texelSize, dp ) ) +
				texture( shadowMap, vec4( bd3D + ( tangent * sample1.x + bitangent * sample1.y ) * texelSize, dp ) ) +
				texture( shadowMap, vec4( bd3D + ( tangent * sample2.x + bitangent * sample2.y ) * texelSize, dp ) ) +
				texture( shadowMap, vec4( bd3D + ( tangent * sample3.x + bitangent * sample3.y ) * texelSize, dp ) ) +
				texture( shadowMap, vec4( bd3D + ( tangent * sample4.x + bitangent * sample4.y ) * texelSize, dp ) )
			) * 0.2;
		}
		return mix( 1.0, shadow, shadowIntensity );
	}
	#elif defined( SHADOWMAP_TYPE_BASIC )
	float getPointShadow( samplerCube shadowMap, vec2 shadowMapSize, float shadowIntensity, float shadowBias, float shadowRadius, vec4 shadowCoord, float shadowCameraNear, float shadowCameraFar ) {
		float shadow = 1.0;
		vec3 lightToPosition = shadowCoord.xyz;
		vec3 absVec = abs( lightToPosition );
		float viewSpaceZ = max( max( absVec.x, absVec.y ), absVec.z );
		if ( viewSpaceZ - shadowCameraFar <= 0.0 && viewSpaceZ - shadowCameraNear >= 0.0 ) {
			float dp = ( shadowCameraFar * ( viewSpaceZ - shadowCameraNear ) ) / ( viewSpaceZ * ( shadowCameraFar - shadowCameraNear ) );
			dp += shadowBias;
			vec3 bd3D = normalize( lightToPosition );
			float depth = textureCube( shadowMap, bd3D ).r;
			#ifdef USE_REVERSED_DEPTH_BUFFER
				depth = 1.0 - depth;
			#endif
			shadow = step( dp, depth );
		}
		return mix( 1.0, shadow, shadowIntensity );
	}
	#endif
	#endif
#endif`,Av=`#if NUM_SPOT_LIGHT_COORDS > 0
	uniform mat4 spotLightMatrix[ NUM_SPOT_LIGHT_COORDS ];
	varying vec4 vSpotLightCoord[ NUM_SPOT_LIGHT_COORDS ];
#endif
#ifdef USE_SHADOWMAP
	#if NUM_DIR_LIGHT_SHADOWS > 0
		uniform mat4 directionalShadowMatrix[ NUM_DIR_LIGHT_SHADOWS ];
		varying vec4 vDirectionalShadowCoord[ NUM_DIR_LIGHT_SHADOWS ];
		struct DirectionalLightShadow {
			float shadowIntensity;
			float shadowBias;
			float shadowNormalBias;
			float shadowRadius;
			vec2 shadowMapSize;
		};
		uniform DirectionalLightShadow directionalLightShadows[ NUM_DIR_LIGHT_SHADOWS ];
	#endif
	#if NUM_SPOT_LIGHT_SHADOWS > 0
		struct SpotLightShadow {
			float shadowIntensity;
			float shadowBias;
			float shadowNormalBias;
			float shadowRadius;
			vec2 shadowMapSize;
		};
		uniform SpotLightShadow spotLightShadows[ NUM_SPOT_LIGHT_SHADOWS ];
	#endif
	#if NUM_POINT_LIGHT_SHADOWS > 0
		uniform mat4 pointShadowMatrix[ NUM_POINT_LIGHT_SHADOWS ];
		varying vec4 vPointShadowCoord[ NUM_POINT_LIGHT_SHADOWS ];
		struct PointLightShadow {
			float shadowIntensity;
			float shadowBias;
			float shadowNormalBias;
			float shadowRadius;
			vec2 shadowMapSize;
			float shadowCameraNear;
			float shadowCameraFar;
		};
		uniform PointLightShadow pointLightShadows[ NUM_POINT_LIGHT_SHADOWS ];
	#endif
#endif`,wv=`#if ( defined( USE_SHADOWMAP ) && ( NUM_DIR_LIGHT_SHADOWS > 0 || NUM_POINT_LIGHT_SHADOWS > 0 ) ) || ( NUM_SPOT_LIGHT_COORDS > 0 )
	#ifdef HAS_NORMAL
		vec3 shadowWorldNormal = inverseTransformDirection( transformedNormal, viewMatrix );
	#else
		vec3 shadowWorldNormal = vec3( 0.0 );
	#endif
	vec4 shadowWorldPosition;
#endif
#if defined( USE_SHADOWMAP )
	#if NUM_DIR_LIGHT_SHADOWS > 0
		#pragma unroll_loop_start
		for ( int i = 0; i < NUM_DIR_LIGHT_SHADOWS; i ++ ) {
			shadowWorldPosition = worldPosition + vec4( shadowWorldNormal * directionalLightShadows[ i ].shadowNormalBias, 0 );
			vDirectionalShadowCoord[ i ] = directionalShadowMatrix[ i ] * shadowWorldPosition;
		}
		#pragma unroll_loop_end
	#endif
	#if NUM_POINT_LIGHT_SHADOWS > 0
		#pragma unroll_loop_start
		for ( int i = 0; i < NUM_POINT_LIGHT_SHADOWS; i ++ ) {
			shadowWorldPosition = worldPosition + vec4( shadowWorldNormal * pointLightShadows[ i ].shadowNormalBias, 0 );
			vPointShadowCoord[ i ] = pointShadowMatrix[ i ] * shadowWorldPosition;
		}
		#pragma unroll_loop_end
	#endif
#endif
#if NUM_SPOT_LIGHT_COORDS > 0
	#pragma unroll_loop_start
	for ( int i = 0; i < NUM_SPOT_LIGHT_COORDS; i ++ ) {
		shadowWorldPosition = worldPosition;
		#if ( defined( USE_SHADOWMAP ) && UNROLLED_LOOP_INDEX < NUM_SPOT_LIGHT_SHADOWS )
			shadowWorldPosition.xyz += shadowWorldNormal * spotLightShadows[ i ].shadowNormalBias;
		#endif
		vSpotLightCoord[ i ] = spotLightMatrix[ i ] * shadowWorldPosition;
	}
	#pragma unroll_loop_end
#endif`,Rv=`float getShadowMask() {
	float shadow = 1.0;
	#ifdef USE_SHADOWMAP
	#if NUM_DIR_LIGHT_SHADOWS > 0
	DirectionalLightShadow directionalLight;
	#pragma unroll_loop_start
	for ( int i = 0; i < NUM_DIR_LIGHT_SHADOWS; i ++ ) {
		directionalLight = directionalLightShadows[ i ];
		shadow *= receiveShadow ? getShadow( directionalShadowMap[ i ], directionalLight.shadowMapSize, directionalLight.shadowIntensity, directionalLight.shadowBias, directionalLight.shadowRadius, vDirectionalShadowCoord[ i ] ) : 1.0;
	}
	#pragma unroll_loop_end
	#endif
	#if NUM_SPOT_LIGHT_SHADOWS > 0
	SpotLightShadow spotLight;
	#pragma unroll_loop_start
	for ( int i = 0; i < NUM_SPOT_LIGHT_SHADOWS; i ++ ) {
		spotLight = spotLightShadows[ i ];
		shadow *= receiveShadow ? getShadow( spotShadowMap[ i ], spotLight.shadowMapSize, spotLight.shadowIntensity, spotLight.shadowBias, spotLight.shadowRadius, vSpotLightCoord[ i ] ) : 1.0;
	}
	#pragma unroll_loop_end
	#endif
	#if NUM_POINT_LIGHT_SHADOWS > 0 && ( defined( SHADOWMAP_TYPE_PCF ) || defined( SHADOWMAP_TYPE_BASIC ) )
	PointLightShadow pointLight;
	#pragma unroll_loop_start
	for ( int i = 0; i < NUM_POINT_LIGHT_SHADOWS; i ++ ) {
		pointLight = pointLightShadows[ i ];
		shadow *= receiveShadow ? getPointShadow( pointShadowMap[ i ], pointLight.shadowMapSize, pointLight.shadowIntensity, pointLight.shadowBias, pointLight.shadowRadius, vPointShadowCoord[ i ], pointLight.shadowCameraNear, pointLight.shadowCameraFar ) : 1.0;
	}
	#pragma unroll_loop_end
	#endif
	#endif
	return shadow;
}`,Cv=`#ifdef USE_SKINNING
	mat4 boneMatX = getBoneMatrix( skinIndex.x );
	mat4 boneMatY = getBoneMatrix( skinIndex.y );
	mat4 boneMatZ = getBoneMatrix( skinIndex.z );
	mat4 boneMatW = getBoneMatrix( skinIndex.w );
#endif`,Pv=`#ifdef USE_SKINNING
	uniform mat4 bindMatrix;
	uniform mat4 bindMatrixInverse;
	uniform highp sampler2D boneTexture;
	mat4 getBoneMatrix( const in float i ) {
		int size = textureSize( boneTexture, 0 ).x;
		int j = int( i ) * 4;
		int x = j % size;
		int y = j / size;
		vec4 v1 = texelFetch( boneTexture, ivec2( x, y ), 0 );
		vec4 v2 = texelFetch( boneTexture, ivec2( x + 1, y ), 0 );
		vec4 v3 = texelFetch( boneTexture, ivec2( x + 2, y ), 0 );
		vec4 v4 = texelFetch( boneTexture, ivec2( x + 3, y ), 0 );
		return mat4( v1, v2, v3, v4 );
	}
#endif`,Dv=`#ifdef USE_SKINNING
	vec4 skinVertex = bindMatrix * vec4( transformed, 1.0 );
	vec4 skinned = vec4( 0.0 );
	skinned += boneMatX * skinVertex * skinWeight.x;
	skinned += boneMatY * skinVertex * skinWeight.y;
	skinned += boneMatZ * skinVertex * skinWeight.z;
	skinned += boneMatW * skinVertex * skinWeight.w;
	transformed = ( bindMatrixInverse * skinned ).xyz;
#endif`,Iv=`#ifdef USE_SKINNING
	mat4 skinMatrix = mat4( 0.0 );
	skinMatrix += skinWeight.x * boneMatX;
	skinMatrix += skinWeight.y * boneMatY;
	skinMatrix += skinWeight.z * boneMatZ;
	skinMatrix += skinWeight.w * boneMatW;
	skinMatrix = bindMatrixInverse * skinMatrix * bindMatrix;
	objectNormal = vec4( skinMatrix * vec4( objectNormal, 0.0 ) ).xyz;
	#ifdef USE_TANGENT
		objectTangent = vec4( skinMatrix * vec4( objectTangent, 0.0 ) ).xyz;
	#endif
#endif`,Lv=`float specularStrength;
#ifdef USE_SPECULARMAP
	vec4 texelSpecular = texture2D( specularMap, vSpecularMapUv );
	specularStrength = texelSpecular.r;
#else
	specularStrength = 1.0;
#endif`,Uv=`#ifdef USE_SPECULARMAP
	uniform sampler2D specularMap;
#endif`,Nv=`#if defined( TONE_MAPPING )
	gl_FragColor.rgb = toneMapping( gl_FragColor.rgb );
#endif`,Fv=`#ifndef saturate
#define saturate( a ) clamp( a, 0.0, 1.0 )
#endif
uniform float toneMappingExposure;
vec3 LinearToneMapping( vec3 color ) {
	return saturate( toneMappingExposure * color );
}
vec3 ReinhardToneMapping( vec3 color ) {
	color *= toneMappingExposure;
	return saturate( color / ( vec3( 1.0 ) + color ) );
}
vec3 CineonToneMapping( vec3 color ) {
	color *= toneMappingExposure;
	color = max( vec3( 0.0 ), color - 0.004 );
	return pow( ( color * ( 6.2 * color + 0.5 ) ) / ( color * ( 6.2 * color + 1.7 ) + 0.06 ), vec3( 2.2 ) );
}
vec3 RRTAndODTFit( vec3 v ) {
	vec3 a = v * ( v + 0.0245786 ) - 0.000090537;
	vec3 b = v * ( 0.983729 * v + 0.4329510 ) + 0.238081;
	return a / b;
}
vec3 ACESFilmicToneMapping( vec3 color ) {
	const mat3 ACESInputMat = mat3(
		vec3( 0.59719, 0.07600, 0.02840 ),		vec3( 0.35458, 0.90834, 0.13383 ),
		vec3( 0.04823, 0.01566, 0.83777 )
	);
	const mat3 ACESOutputMat = mat3(
		vec3(  1.60475, -0.10208, -0.00327 ),		vec3( -0.53108,  1.10813, -0.07276 ),
		vec3( -0.07367, -0.00605,  1.07602 )
	);
	color *= toneMappingExposure / 0.6;
	color = ACESInputMat * color;
	color = RRTAndODTFit( color );
	color = ACESOutputMat * color;
	return saturate( color );
}
const mat3 LINEAR_REC2020_TO_LINEAR_SRGB = mat3(
	vec3( 1.6605, - 0.1246, - 0.0182 ),
	vec3( - 0.5876, 1.1329, - 0.1006 ),
	vec3( - 0.0728, - 0.0083, 1.1187 )
);
const mat3 LINEAR_SRGB_TO_LINEAR_REC2020 = mat3(
	vec3( 0.6274, 0.0691, 0.0164 ),
	vec3( 0.3293, 0.9195, 0.0880 ),
	vec3( 0.0433, 0.0113, 0.8956 )
);
vec3 agxDefaultContrastApprox( vec3 x ) {
	vec3 x2 = x * x;
	vec3 x4 = x2 * x2;
	return + 15.5 * x4 * x2
		- 40.14 * x4 * x
		+ 31.96 * x4
		- 6.868 * x2 * x
		+ 0.4298 * x2
		+ 0.1191 * x
		- 0.00232;
}
vec3 AgXToneMapping( vec3 color ) {
	const mat3 AgXInsetMatrix = mat3(
		vec3( 0.856627153315983, 0.137318972929847, 0.11189821299995 ),
		vec3( 0.0951212405381588, 0.761241990602591, 0.0767994186031903 ),
		vec3( 0.0482516061458583, 0.101439036467562, 0.811302368396859 )
	);
	const mat3 AgXOutsetMatrix = mat3(
		vec3( 1.1271005818144368, - 0.1413297634984383, - 0.14132976349843826 ),
		vec3( - 0.11060664309660323, 1.157823702216272, - 0.11060664309660294 ),
		vec3( - 0.016493938717834573, - 0.016493938717834257, 1.2519364065950405 )
	);
	const float AgxMinEv = - 12.47393;	const float AgxMaxEv = 4.026069;
	color *= toneMappingExposure;
	color = LINEAR_SRGB_TO_LINEAR_REC2020 * color;
	color = AgXInsetMatrix * color;
	color = max( color, 1e-10 );	color = log2( color );
	color = ( color - AgxMinEv ) / ( AgxMaxEv - AgxMinEv );
	color = clamp( color, 0.0, 1.0 );
	color = agxDefaultContrastApprox( color );
	color = AgXOutsetMatrix * color;
	color = pow( max( vec3( 0.0 ), color ), vec3( 2.2 ) );
	color = LINEAR_REC2020_TO_LINEAR_SRGB * color;
	color = clamp( color, 0.0, 1.0 );
	return color;
}
vec3 NeutralToneMapping( vec3 color ) {
	const float StartCompression = 0.8 - 0.04;
	const float Desaturation = 0.15;
	color *= toneMappingExposure;
	float x = min( color.r, min( color.g, color.b ) );
	float offset = x < 0.08 ? x - 6.25 * x * x : 0.04;
	color -= offset;
	float peak = max( color.r, max( color.g, color.b ) );
	if ( peak < StartCompression ) return color;
	float d = 1. - StartCompression;
	float newPeak = 1. - d * d / ( peak + d - StartCompression );
	color *= newPeak / peak;
	float g = 1. - 1. / ( Desaturation * ( peak - newPeak ) + 1. );
	return mix( color, vec3( newPeak ), g );
}
vec3 CustomToneMapping( vec3 color ) { return color; }`,Ov=`#ifdef USE_TRANSMISSION
	material.transmission = transmission;
	material.transmissionAlpha = 1.0;
	material.thickness = thickness;
	material.attenuationDistance = attenuationDistance;
	material.attenuationColor = attenuationColor;
	#ifdef USE_TRANSMISSIONMAP
		material.transmission *= texture2D( transmissionMap, vTransmissionMapUv ).r;
	#endif
	#ifdef USE_THICKNESSMAP
		material.thickness *= texture2D( thicknessMap, vThicknessMapUv ).g;
	#endif
	vec3 pos = vWorldPosition;
	vec3 v = normalize( cameraPosition - pos );
	vec3 n = inverseTransformDirection( normal, viewMatrix );
	vec4 transmitted = getIBLVolumeRefraction(
		n, v, material.roughness, material.diffuseContribution, material.specularColorBlended, material.specularF90,
		pos, modelMatrix, viewMatrix, projectionMatrix, material.dispersion, material.ior, material.thickness,
		material.attenuationColor, material.attenuationDistance );
	material.transmissionAlpha = mix( material.transmissionAlpha, transmitted.a, material.transmission );
	totalDiffuse = mix( totalDiffuse, transmitted.rgb, material.transmission );
#endif`,Bv=`#ifdef USE_TRANSMISSION
	uniform float transmission;
	uniform float thickness;
	uniform float attenuationDistance;
	uniform vec3 attenuationColor;
	#ifdef USE_TRANSMISSIONMAP
		uniform sampler2D transmissionMap;
	#endif
	#ifdef USE_THICKNESSMAP
		uniform sampler2D thicknessMap;
	#endif
	uniform vec2 transmissionSamplerSize;
	uniform sampler2D transmissionSamplerMap;
	uniform mat4 modelMatrix;
	uniform mat4 projectionMatrix;
	varying vec3 vWorldPosition;
	float w0( float a ) {
		return ( 1.0 / 6.0 ) * ( a * ( a * ( - a + 3.0 ) - 3.0 ) + 1.0 );
	}
	float w1( float a ) {
		return ( 1.0 / 6.0 ) * ( a *  a * ( 3.0 * a - 6.0 ) + 4.0 );
	}
	float w2( float a ){
		return ( 1.0 / 6.0 ) * ( a * ( a * ( - 3.0 * a + 3.0 ) + 3.0 ) + 1.0 );
	}
	float w3( float a ) {
		return ( 1.0 / 6.0 ) * ( a * a * a );
	}
	float g0( float a ) {
		return w0( a ) + w1( a );
	}
	float g1( float a ) {
		return w2( a ) + w3( a );
	}
	float h0( float a ) {
		return - 1.0 + w1( a ) / ( w0( a ) + w1( a ) );
	}
	float h1( float a ) {
		return 1.0 + w3( a ) / ( w2( a ) + w3( a ) );
	}
	vec4 bicubic( sampler2D tex, vec2 uv, vec4 texelSize, float lod ) {
		uv = uv * texelSize.zw + 0.5;
		vec2 iuv = floor( uv );
		vec2 fuv = fract( uv );
		float g0x = g0( fuv.x );
		float g1x = g1( fuv.x );
		float h0x = h0( fuv.x );
		float h1x = h1( fuv.x );
		float h0y = h0( fuv.y );
		float h1y = h1( fuv.y );
		vec2 p0 = ( vec2( iuv.x + h0x, iuv.y + h0y ) - 0.5 ) * texelSize.xy;
		vec2 p1 = ( vec2( iuv.x + h1x, iuv.y + h0y ) - 0.5 ) * texelSize.xy;
		vec2 p2 = ( vec2( iuv.x + h0x, iuv.y + h1y ) - 0.5 ) * texelSize.xy;
		vec2 p3 = ( vec2( iuv.x + h1x, iuv.y + h1y ) - 0.5 ) * texelSize.xy;
		return g0( fuv.y ) * ( g0x * textureLod( tex, p0, lod ) + g1x * textureLod( tex, p1, lod ) ) +
			g1( fuv.y ) * ( g0x * textureLod( tex, p2, lod ) + g1x * textureLod( tex, p3, lod ) );
	}
	vec4 textureBicubic( sampler2D sampler, vec2 uv, float lod ) {
		vec2 fLodSize = vec2( textureSize( sampler, int( lod ) ) );
		vec2 cLodSize = vec2( textureSize( sampler, int( lod + 1.0 ) ) );
		vec2 fLodSizeInv = 1.0 / fLodSize;
		vec2 cLodSizeInv = 1.0 / cLodSize;
		vec4 fSample = bicubic( sampler, uv, vec4( fLodSizeInv, fLodSize ), floor( lod ) );
		vec4 cSample = bicubic( sampler, uv, vec4( cLodSizeInv, cLodSize ), ceil( lod ) );
		return mix( fSample, cSample, fract( lod ) );
	}
	vec3 getVolumeTransmissionRay( const in vec3 n, const in vec3 v, const in float thickness, const in float ior, const in mat4 modelMatrix ) {
		vec3 refractionVector = refract( - v, normalize( n ), 1.0 / ior );
		vec3 modelScale;
		modelScale.x = length( vec3( modelMatrix[ 0 ].xyz ) );
		modelScale.y = length( vec3( modelMatrix[ 1 ].xyz ) );
		modelScale.z = length( vec3( modelMatrix[ 2 ].xyz ) );
		return normalize( refractionVector ) * thickness * modelScale;
	}
	float applyIorToRoughness( const in float roughness, const in float ior ) {
		return roughness * clamp( ior * 2.0 - 2.0, 0.0, 1.0 );
	}
	vec4 getTransmissionSample( const in vec2 fragCoord, const in float roughness, const in float ior ) {
		float lod = log2( transmissionSamplerSize.x ) * applyIorToRoughness( roughness, ior );
		return textureBicubic( transmissionSamplerMap, fragCoord.xy, lod );
	}
	vec3 volumeAttenuation( const in float transmissionDistance, const in vec3 attenuationColor, const in float attenuationDistance ) {
		if ( isinf( attenuationDistance ) ) {
			return vec3( 1.0 );
		} else {
			vec3 attenuationCoefficient = -log( attenuationColor ) / attenuationDistance;
			vec3 transmittance = exp( - attenuationCoefficient * transmissionDistance );			return transmittance;
		}
	}
	vec4 getIBLVolumeRefraction( const in vec3 n, const in vec3 v, const in float roughness, const in vec3 diffuseColor,
		const in vec3 specularColor, const in float specularF90, const in vec3 position, const in mat4 modelMatrix,
		const in mat4 viewMatrix, const in mat4 projMatrix, const in float dispersion, const in float ior, const in float thickness,
		const in vec3 attenuationColor, const in float attenuationDistance ) {
		vec4 transmittedLight;
		vec3 transmittance;
		#ifdef USE_DISPERSION
			float halfSpread = ( ior - 1.0 ) * 0.025 * dispersion;
			vec3 iors = vec3( ior - halfSpread, ior, ior + halfSpread );
			for ( int i = 0; i < 3; i ++ ) {
				vec3 transmissionRay = getVolumeTransmissionRay( n, v, thickness, iors[ i ], modelMatrix );
				vec3 refractedRayExit = position + transmissionRay;
				vec4 ndcPos = projMatrix * viewMatrix * vec4( refractedRayExit, 1.0 );
				vec2 refractionCoords = ndcPos.xy / ndcPos.w;
				refractionCoords += 1.0;
				refractionCoords /= 2.0;
				vec4 transmissionSample = getTransmissionSample( refractionCoords, roughness, iors[ i ] );
				transmittedLight[ i ] = transmissionSample[ i ];
				transmittedLight.a += transmissionSample.a;
				transmittance[ i ] = diffuseColor[ i ] * volumeAttenuation( length( transmissionRay ), attenuationColor, attenuationDistance )[ i ];
			}
			transmittedLight.a /= 3.0;
		#else
			vec3 transmissionRay = getVolumeTransmissionRay( n, v, thickness, ior, modelMatrix );
			vec3 refractedRayExit = position + transmissionRay;
			vec4 ndcPos = projMatrix * viewMatrix * vec4( refractedRayExit, 1.0 );
			vec2 refractionCoords = ndcPos.xy / ndcPos.w;
			refractionCoords += 1.0;
			refractionCoords /= 2.0;
			transmittedLight = getTransmissionSample( refractionCoords, roughness, ior );
			transmittance = diffuseColor * volumeAttenuation( length( transmissionRay ), attenuationColor, attenuationDistance );
		#endif
		vec3 attenuatedColor = transmittance * transmittedLight.rgb;
		vec3 F = EnvironmentBRDF( n, v, specularColor, specularF90, roughness );
		float transmittanceFactor = ( transmittance.r + transmittance.g + transmittance.b ) / 3.0;
		return vec4( ( 1.0 - F ) * attenuatedColor, 1.0 - ( 1.0 - transmittedLight.a ) * transmittanceFactor );
	}
#endif`,zv=`#if defined( USE_UV ) || defined( USE_ANISOTROPY )
	varying vec2 vUv;
#endif
#ifdef USE_MAP
	varying vec2 vMapUv;
#endif
#ifdef USE_ALPHAMAP
	varying vec2 vAlphaMapUv;
#endif
#ifdef USE_LIGHTMAP
	varying vec2 vLightMapUv;
#endif
#ifdef USE_AOMAP
	varying vec2 vAoMapUv;
#endif
#ifdef USE_BUMPMAP
	varying vec2 vBumpMapUv;
#endif
#ifdef USE_NORMALMAP
	varying vec2 vNormalMapUv;
#endif
#ifdef USE_EMISSIVEMAP
	varying vec2 vEmissiveMapUv;
#endif
#ifdef USE_METALNESSMAP
	varying vec2 vMetalnessMapUv;
#endif
#ifdef USE_ROUGHNESSMAP
	varying vec2 vRoughnessMapUv;
#endif
#ifdef USE_ANISOTROPYMAP
	varying vec2 vAnisotropyMapUv;
#endif
#ifdef USE_CLEARCOATMAP
	varying vec2 vClearcoatMapUv;
#endif
#ifdef USE_CLEARCOAT_NORMALMAP
	varying vec2 vClearcoatNormalMapUv;
#endif
#ifdef USE_CLEARCOAT_ROUGHNESSMAP
	varying vec2 vClearcoatRoughnessMapUv;
#endif
#ifdef USE_IRIDESCENCEMAP
	varying vec2 vIridescenceMapUv;
#endif
#ifdef USE_IRIDESCENCE_THICKNESSMAP
	varying vec2 vIridescenceThicknessMapUv;
#endif
#ifdef USE_SHEEN_COLORMAP
	varying vec2 vSheenColorMapUv;
#endif
#ifdef USE_SHEEN_ROUGHNESSMAP
	varying vec2 vSheenRoughnessMapUv;
#endif
#ifdef USE_SPECULARMAP
	varying vec2 vSpecularMapUv;
#endif
#ifdef USE_SPECULAR_COLORMAP
	varying vec2 vSpecularColorMapUv;
#endif
#ifdef USE_SPECULAR_INTENSITYMAP
	varying vec2 vSpecularIntensityMapUv;
#endif
#ifdef USE_TRANSMISSIONMAP
	uniform mat3 transmissionMapTransform;
	varying vec2 vTransmissionMapUv;
#endif
#ifdef USE_THICKNESSMAP
	uniform mat3 thicknessMapTransform;
	varying vec2 vThicknessMapUv;
#endif`,Hv=`#if defined( USE_UV ) || defined( USE_ANISOTROPY )
	varying vec2 vUv;
#endif
#ifdef USE_MAP
	uniform mat3 mapTransform;
	varying vec2 vMapUv;
#endif
#ifdef USE_ALPHAMAP
	uniform mat3 alphaMapTransform;
	varying vec2 vAlphaMapUv;
#endif
#ifdef USE_LIGHTMAP
	uniform mat3 lightMapTransform;
	varying vec2 vLightMapUv;
#endif
#ifdef USE_AOMAP
	uniform mat3 aoMapTransform;
	varying vec2 vAoMapUv;
#endif
#ifdef USE_BUMPMAP
	uniform mat3 bumpMapTransform;
	varying vec2 vBumpMapUv;
#endif
#ifdef USE_NORMALMAP
	uniform mat3 normalMapTransform;
	varying vec2 vNormalMapUv;
#endif
#ifdef USE_DISPLACEMENTMAP
	uniform mat3 displacementMapTransform;
	varying vec2 vDisplacementMapUv;
#endif
#ifdef USE_EMISSIVEMAP
	uniform mat3 emissiveMapTransform;
	varying vec2 vEmissiveMapUv;
#endif
#ifdef USE_METALNESSMAP
	uniform mat3 metalnessMapTransform;
	varying vec2 vMetalnessMapUv;
#endif
#ifdef USE_ROUGHNESSMAP
	uniform mat3 roughnessMapTransform;
	varying vec2 vRoughnessMapUv;
#endif
#ifdef USE_ANISOTROPYMAP
	uniform mat3 anisotropyMapTransform;
	varying vec2 vAnisotropyMapUv;
#endif
#ifdef USE_CLEARCOATMAP
	uniform mat3 clearcoatMapTransform;
	varying vec2 vClearcoatMapUv;
#endif
#ifdef USE_CLEARCOAT_NORMALMAP
	uniform mat3 clearcoatNormalMapTransform;
	varying vec2 vClearcoatNormalMapUv;
#endif
#ifdef USE_CLEARCOAT_ROUGHNESSMAP
	uniform mat3 clearcoatRoughnessMapTransform;
	varying vec2 vClearcoatRoughnessMapUv;
#endif
#ifdef USE_SHEEN_COLORMAP
	uniform mat3 sheenColorMapTransform;
	varying vec2 vSheenColorMapUv;
#endif
#ifdef USE_SHEEN_ROUGHNESSMAP
	uniform mat3 sheenRoughnessMapTransform;
	varying vec2 vSheenRoughnessMapUv;
#endif
#ifdef USE_IRIDESCENCEMAP
	uniform mat3 iridescenceMapTransform;
	varying vec2 vIridescenceMapUv;
#endif
#ifdef USE_IRIDESCENCE_THICKNESSMAP
	uniform mat3 iridescenceThicknessMapTransform;
	varying vec2 vIridescenceThicknessMapUv;
#endif
#ifdef USE_SPECULARMAP
	uniform mat3 specularMapTransform;
	varying vec2 vSpecularMapUv;
#endif
#ifdef USE_SPECULAR_COLORMAP
	uniform mat3 specularColorMapTransform;
	varying vec2 vSpecularColorMapUv;
#endif
#ifdef USE_SPECULAR_INTENSITYMAP
	uniform mat3 specularIntensityMapTransform;
	varying vec2 vSpecularIntensityMapUv;
#endif
#ifdef USE_TRANSMISSIONMAP
	uniform mat3 transmissionMapTransform;
	varying vec2 vTransmissionMapUv;
#endif
#ifdef USE_THICKNESSMAP
	uniform mat3 thicknessMapTransform;
	varying vec2 vThicknessMapUv;
#endif`,Vv=`#if defined( USE_UV ) || defined( USE_ANISOTROPY )
	vUv = vec3( uv, 1 ).xy;
#endif
#ifdef USE_MAP
	vMapUv = ( mapTransform * vec3( MAP_UV, 1 ) ).xy;
#endif
#ifdef USE_ALPHAMAP
	vAlphaMapUv = ( alphaMapTransform * vec3( ALPHAMAP_UV, 1 ) ).xy;
#endif
#ifdef USE_LIGHTMAP
	vLightMapUv = ( lightMapTransform * vec3( LIGHTMAP_UV, 1 ) ).xy;
#endif
#ifdef USE_AOMAP
	vAoMapUv = ( aoMapTransform * vec3( AOMAP_UV, 1 ) ).xy;
#endif
#ifdef USE_BUMPMAP
	vBumpMapUv = ( bumpMapTransform * vec3( BUMPMAP_UV, 1 ) ).xy;
#endif
#ifdef USE_NORMALMAP
	vNormalMapUv = ( normalMapTransform * vec3( NORMALMAP_UV, 1 ) ).xy;
#endif
#ifdef USE_DISPLACEMENTMAP
	vDisplacementMapUv = ( displacementMapTransform * vec3( DISPLACEMENTMAP_UV, 1 ) ).xy;
#endif
#ifdef USE_EMISSIVEMAP
	vEmissiveMapUv = ( emissiveMapTransform * vec3( EMISSIVEMAP_UV, 1 ) ).xy;
#endif
#ifdef USE_METALNESSMAP
	vMetalnessMapUv = ( metalnessMapTransform * vec3( METALNESSMAP_UV, 1 ) ).xy;
#endif
#ifdef USE_ROUGHNESSMAP
	vRoughnessMapUv = ( roughnessMapTransform * vec3( ROUGHNESSMAP_UV, 1 ) ).xy;
#endif
#ifdef USE_ANISOTROPYMAP
	vAnisotropyMapUv = ( anisotropyMapTransform * vec3( ANISOTROPYMAP_UV, 1 ) ).xy;
#endif
#ifdef USE_CLEARCOATMAP
	vClearcoatMapUv = ( clearcoatMapTransform * vec3( CLEARCOATMAP_UV, 1 ) ).xy;
#endif
#ifdef USE_CLEARCOAT_NORMALMAP
	vClearcoatNormalMapUv = ( clearcoatNormalMapTransform * vec3( CLEARCOAT_NORMALMAP_UV, 1 ) ).xy;
#endif
#ifdef USE_CLEARCOAT_ROUGHNESSMAP
	vClearcoatRoughnessMapUv = ( clearcoatRoughnessMapTransform * vec3( CLEARCOAT_ROUGHNESSMAP_UV, 1 ) ).xy;
#endif
#ifdef USE_IRIDESCENCEMAP
	vIridescenceMapUv = ( iridescenceMapTransform * vec3( IRIDESCENCEMAP_UV, 1 ) ).xy;
#endif
#ifdef USE_IRIDESCENCE_THICKNESSMAP
	vIridescenceThicknessMapUv = ( iridescenceThicknessMapTransform * vec3( IRIDESCENCE_THICKNESSMAP_UV, 1 ) ).xy;
#endif
#ifdef USE_SHEEN_COLORMAP
	vSheenColorMapUv = ( sheenColorMapTransform * vec3( SHEEN_COLORMAP_UV, 1 ) ).xy;
#endif
#ifdef USE_SHEEN_ROUGHNESSMAP
	vSheenRoughnessMapUv = ( sheenRoughnessMapTransform * vec3( SHEEN_ROUGHNESSMAP_UV, 1 ) ).xy;
#endif
#ifdef USE_SPECULARMAP
	vSpecularMapUv = ( specularMapTransform * vec3( SPECULARMAP_UV, 1 ) ).xy;
#endif
#ifdef USE_SPECULAR_COLORMAP
	vSpecularColorMapUv = ( specularColorMapTransform * vec3( SPECULAR_COLORMAP_UV, 1 ) ).xy;
#endif
#ifdef USE_SPECULAR_INTENSITYMAP
	vSpecularIntensityMapUv = ( specularIntensityMapTransform * vec3( SPECULAR_INTENSITYMAP_UV, 1 ) ).xy;
#endif
#ifdef USE_TRANSMISSIONMAP
	vTransmissionMapUv = ( transmissionMapTransform * vec3( TRANSMISSIONMAP_UV, 1 ) ).xy;
#endif
#ifdef USE_THICKNESSMAP
	vThicknessMapUv = ( thicknessMapTransform * vec3( THICKNESSMAP_UV, 1 ) ).xy;
#endif`,Gv=`#if defined( USE_ENVMAP ) || defined( DISTANCE ) || defined ( USE_SHADOWMAP ) || defined ( USE_TRANSMISSION ) || NUM_SPOT_LIGHT_COORDS > 0
	vec4 worldPosition = vec4( transformed, 1.0 );
	#ifdef USE_BATCHING
		worldPosition = batchingMatrix * worldPosition;
	#endif
	#ifdef USE_INSTANCING
		worldPosition = instanceMatrix * worldPosition;
	#endif
	worldPosition = modelMatrix * worldPosition;
#endif`;const kv=`varying vec2 vUv;
uniform mat3 uvTransform;
void main() {
	vUv = ( uvTransform * vec3( uv, 1 ) ).xy;
	gl_Position = vec4( position.xy, 1.0, 1.0 );
}`,Wv=`uniform sampler2D t2D;
uniform float backgroundIntensity;
varying vec2 vUv;
void main() {
	vec4 texColor = texture2D( t2D, vUv );
	#ifdef DECODE_VIDEO_TEXTURE
		texColor = vec4( mix( pow( texColor.rgb * 0.9478672986 + vec3( 0.0521327014 ), vec3( 2.4 ) ), texColor.rgb * 0.0773993808, vec3( lessThanEqual( texColor.rgb, vec3( 0.04045 ) ) ) ), texColor.w );
	#endif
	texColor.rgb *= backgroundIntensity;
	gl_FragColor = texColor;
	#include <tonemapping_fragment>
	#include <colorspace_fragment>
}`,Xv=`varying vec3 vWorldDirection;
#include <common>
void main() {
	vWorldDirection = transformDirection( position, modelMatrix );
	#include <begin_vertex>
	#include <project_vertex>
	gl_Position.z = gl_Position.w;
}`,Yv=`#ifdef ENVMAP_TYPE_CUBE
	uniform samplerCube envMap;
#elif defined( ENVMAP_TYPE_CUBE_UV )
	uniform sampler2D envMap;
#endif
uniform float backgroundBlurriness;
uniform float backgroundIntensity;
uniform mat3 backgroundRotation;
varying vec3 vWorldDirection;
#include <cube_uv_reflection_fragment>
void main() {
	#ifdef ENVMAP_TYPE_CUBE
		vec4 texColor = textureCube( envMap, backgroundRotation * vWorldDirection );
	#elif defined( ENVMAP_TYPE_CUBE_UV )
		vec4 texColor = textureCubeUV( envMap, backgroundRotation * vWorldDirection, backgroundBlurriness );
	#else
		vec4 texColor = vec4( 0.0, 0.0, 0.0, 1.0 );
	#endif
	texColor.rgb *= backgroundIntensity;
	gl_FragColor = texColor;
	#include <tonemapping_fragment>
	#include <colorspace_fragment>
}`,qv=`varying vec3 vWorldDirection;
#include <common>
void main() {
	vWorldDirection = transformDirection( position, modelMatrix );
	#include <begin_vertex>
	#include <project_vertex>
	gl_Position.z = gl_Position.w;
}`,Kv=`uniform samplerCube tCube;
uniform float tFlip;
uniform float opacity;
varying vec3 vWorldDirection;
void main() {
	vec4 texColor = textureCube( tCube, vec3( tFlip * vWorldDirection.x, vWorldDirection.yz ) );
	gl_FragColor = texColor;
	gl_FragColor.a *= opacity;
	#include <tonemapping_fragment>
	#include <colorspace_fragment>
}`,jv=`#include <common>
#include <batching_pars_vertex>
#include <uv_pars_vertex>
#include <displacementmap_pars_vertex>
#include <morphtarget_pars_vertex>
#include <skinning_pars_vertex>
#include <logdepthbuf_pars_vertex>
#include <clipping_planes_pars_vertex>
varying vec2 vHighPrecisionZW;
void main() {
	#include <uv_vertex>
	#include <batching_vertex>
	#include <skinbase_vertex>
	#include <morphinstance_vertex>
	#ifdef USE_DISPLACEMENTMAP
		#include <beginnormal_vertex>
		#include <morphnormal_vertex>
		#include <skinnormal_vertex>
	#endif
	#include <begin_vertex>
	#include <morphtarget_vertex>
	#include <skinning_vertex>
	#include <displacementmap_vertex>
	#include <project_vertex>
	#include <logdepthbuf_vertex>
	#include <clipping_planes_vertex>
	vHighPrecisionZW = gl_Position.zw;
}`,Zv=`#if DEPTH_PACKING == 3200
	uniform float opacity;
#endif
#include <common>
#include <packing>
#include <uv_pars_fragment>
#include <map_pars_fragment>
#include <alphamap_pars_fragment>
#include <alphatest_pars_fragment>
#include <alphahash_pars_fragment>
#include <logdepthbuf_pars_fragment>
#include <clipping_planes_pars_fragment>
varying vec2 vHighPrecisionZW;
void main() {
	vec4 diffuseColor = vec4( 1.0 );
	#include <clipping_planes_fragment>
	#if DEPTH_PACKING == 3200
		diffuseColor.a = opacity;
	#endif
	#include <map_fragment>
	#include <alphamap_fragment>
	#include <alphatest_fragment>
	#include <alphahash_fragment>
	#include <logdepthbuf_fragment>
	#ifdef USE_REVERSED_DEPTH_BUFFER
		float fragCoordZ = vHighPrecisionZW[ 0 ] / vHighPrecisionZW[ 1 ];
	#else
		float fragCoordZ = 0.5 * vHighPrecisionZW[ 0 ] / vHighPrecisionZW[ 1 ] + 0.5;
	#endif
	#if DEPTH_PACKING == 3200
		gl_FragColor = vec4( vec3( 1.0 - fragCoordZ ), opacity );
	#elif DEPTH_PACKING == 3201
		gl_FragColor = packDepthToRGBA( fragCoordZ );
	#elif DEPTH_PACKING == 3202
		gl_FragColor = vec4( packDepthToRGB( fragCoordZ ), 1.0 );
	#elif DEPTH_PACKING == 3203
		gl_FragColor = vec4( packDepthToRG( fragCoordZ ), 0.0, 1.0 );
	#endif
}`,$v=`#define DISTANCE
varying vec3 vWorldPosition;
#include <common>
#include <batching_pars_vertex>
#include <uv_pars_vertex>
#include <displacementmap_pars_vertex>
#include <morphtarget_pars_vertex>
#include <skinning_pars_vertex>
#include <clipping_planes_pars_vertex>
void main() {
	#include <uv_vertex>
	#include <batching_vertex>
	#include <skinbase_vertex>
	#include <morphinstance_vertex>
	#ifdef USE_DISPLACEMENTMAP
		#include <beginnormal_vertex>
		#include <morphnormal_vertex>
		#include <skinnormal_vertex>
	#endif
	#include <begin_vertex>
	#include <morphtarget_vertex>
	#include <skinning_vertex>
	#include <displacementmap_vertex>
	#include <project_vertex>
	#include <worldpos_vertex>
	#include <clipping_planes_vertex>
	vWorldPosition = worldPosition.xyz;
}`,Jv=`#define DISTANCE
uniform vec3 referencePosition;
uniform float nearDistance;
uniform float farDistance;
varying vec3 vWorldPosition;
#include <common>
#include <uv_pars_fragment>
#include <map_pars_fragment>
#include <alphamap_pars_fragment>
#include <alphatest_pars_fragment>
#include <alphahash_pars_fragment>
#include <clipping_planes_pars_fragment>
void main () {
	vec4 diffuseColor = vec4( 1.0 );
	#include <clipping_planes_fragment>
	#include <map_fragment>
	#include <alphamap_fragment>
	#include <alphatest_fragment>
	#include <alphahash_fragment>
	float dist = length( vWorldPosition - referencePosition );
	dist = ( dist - nearDistance ) / ( farDistance - nearDistance );
	dist = saturate( dist );
	gl_FragColor = vec4( dist, 0.0, 0.0, 1.0 );
}`,Qv=`varying vec3 vWorldDirection;
#include <common>
void main() {
	vWorldDirection = transformDirection( position, modelMatrix );
	#include <begin_vertex>
	#include <project_vertex>
}`,eM=`uniform sampler2D tEquirect;
varying vec3 vWorldDirection;
#include <common>
void main() {
	vec3 direction = normalize( vWorldDirection );
	vec2 sampleUV = equirectUv( direction );
	gl_FragColor = texture2D( tEquirect, sampleUV );
	#include <tonemapping_fragment>
	#include <colorspace_fragment>
}`,tM=`uniform float scale;
attribute float lineDistance;
varying float vLineDistance;
#include <common>
#include <uv_pars_vertex>
#include <color_pars_vertex>
#include <fog_pars_vertex>
#include <morphtarget_pars_vertex>
#include <logdepthbuf_pars_vertex>
#include <clipping_planes_pars_vertex>
void main() {
	vLineDistance = scale * lineDistance;
	#include <uv_vertex>
	#include <color_vertex>
	#include <morphinstance_vertex>
	#include <morphcolor_vertex>
	#include <begin_vertex>
	#include <morphtarget_vertex>
	#include <project_vertex>
	#include <logdepthbuf_vertex>
	#include <clipping_planes_vertex>
	#include <fog_vertex>
}`,nM=`uniform vec3 diffuse;
uniform float opacity;
uniform float dashSize;
uniform float totalSize;
varying float vLineDistance;
#include <common>
#include <color_pars_fragment>
#include <uv_pars_fragment>
#include <map_pars_fragment>
#include <fog_pars_fragment>
#include <logdepthbuf_pars_fragment>
#include <clipping_planes_pars_fragment>
void main() {
	vec4 diffuseColor = vec4( diffuse, opacity );
	#include <clipping_planes_fragment>
	if ( mod( vLineDistance, totalSize ) > dashSize ) {
		discard;
	}
	vec3 outgoingLight = vec3( 0.0 );
	#include <logdepthbuf_fragment>
	#include <map_fragment>
	#include <color_fragment>
	outgoingLight = diffuseColor.rgb;
	#include <opaque_fragment>
	#include <tonemapping_fragment>
	#include <colorspace_fragment>
	#include <fog_fragment>
	#include <premultiplied_alpha_fragment>
}`,iM=`#include <common>
#include <batching_pars_vertex>
#include <uv_pars_vertex>
#include <envmap_pars_vertex>
#include <color_pars_vertex>
#include <fog_pars_vertex>
#include <morphtarget_pars_vertex>
#include <skinning_pars_vertex>
#include <logdepthbuf_pars_vertex>
#include <clipping_planes_pars_vertex>
void main() {
	#include <uv_vertex>
	#include <color_vertex>
	#include <morphinstance_vertex>
	#include <morphcolor_vertex>
	#include <batching_vertex>
	#if defined ( USE_ENVMAP ) || defined ( USE_SKINNING )
		#include <beginnormal_vertex>
		#include <morphnormal_vertex>
		#include <skinbase_vertex>
		#include <skinnormal_vertex>
		#include <defaultnormal_vertex>
	#endif
	#include <begin_vertex>
	#include <morphtarget_vertex>
	#include <skinning_vertex>
	#include <project_vertex>
	#include <logdepthbuf_vertex>
	#include <clipping_planes_vertex>
	#include <worldpos_vertex>
	#include <envmap_vertex>
	#include <fog_vertex>
}`,rM=`uniform vec3 diffuse;
uniform float opacity;
#ifndef FLAT_SHADED
	varying vec3 vNormal;
#endif
#include <common>
#include <dithering_pars_fragment>
#include <color_pars_fragment>
#include <uv_pars_fragment>
#include <map_pars_fragment>
#include <alphamap_pars_fragment>
#include <alphatest_pars_fragment>
#include <alphahash_pars_fragment>
#include <aomap_pars_fragment>
#include <lightmap_pars_fragment>
#include <envmap_common_pars_fragment>
#include <envmap_pars_fragment>
#include <fog_pars_fragment>
#include <specularmap_pars_fragment>
#include <logdepthbuf_pars_fragment>
#include <clipping_planes_pars_fragment>
void main() {
	vec4 diffuseColor = vec4( diffuse, opacity );
	#include <clipping_planes_fragment>
	#include <logdepthbuf_fragment>
	#include <map_fragment>
	#include <color_fragment>
	#include <alphamap_fragment>
	#include <alphatest_fragment>
	#include <alphahash_fragment>
	#include <specularmap_fragment>
	ReflectedLight reflectedLight = ReflectedLight( vec3( 0.0 ), vec3( 0.0 ), vec3( 0.0 ), vec3( 0.0 ) );
	#ifdef USE_LIGHTMAP
		vec4 lightMapTexel = texture2D( lightMap, vLightMapUv );
		reflectedLight.indirectDiffuse += lightMapTexel.rgb * lightMapIntensity * RECIPROCAL_PI;
	#else
		reflectedLight.indirectDiffuse += vec3( 1.0 );
	#endif
	#include <aomap_fragment>
	reflectedLight.indirectDiffuse *= diffuseColor.rgb;
	vec3 outgoingLight = reflectedLight.indirectDiffuse;
	#include <envmap_fragment>
	#include <opaque_fragment>
	#include <tonemapping_fragment>
	#include <colorspace_fragment>
	#include <fog_fragment>
	#include <premultiplied_alpha_fragment>
	#include <dithering_fragment>
}`,sM=`#define LAMBERT
varying vec3 vViewPosition;
#include <common>
#include <batching_pars_vertex>
#include <uv_pars_vertex>
#include <displacementmap_pars_vertex>
#include <envmap_pars_vertex>
#include <color_pars_vertex>
#include <fog_pars_vertex>
#include <normal_pars_vertex>
#include <morphtarget_pars_vertex>
#include <skinning_pars_vertex>
#include <shadowmap_pars_vertex>
#include <logdepthbuf_pars_vertex>
#include <clipping_planes_pars_vertex>
void main() {
	#include <uv_vertex>
	#include <color_vertex>
	#include <morphinstance_vertex>
	#include <morphcolor_vertex>
	#include <batching_vertex>
	#include <beginnormal_vertex>
	#include <morphnormal_vertex>
	#include <skinbase_vertex>
	#include <skinnormal_vertex>
	#include <defaultnormal_vertex>
	#include <normal_vertex>
	#include <begin_vertex>
	#include <morphtarget_vertex>
	#include <skinning_vertex>
	#include <displacementmap_vertex>
	#include <project_vertex>
	#include <logdepthbuf_vertex>
	#include <clipping_planes_vertex>
	vViewPosition = - mvPosition.xyz;
	#include <worldpos_vertex>
	#include <envmap_vertex>
	#include <shadowmap_vertex>
	#include <fog_vertex>
}`,oM=`#define LAMBERT
uniform vec3 diffuse;
uniform vec3 emissive;
uniform float opacity;
#include <common>
#include <dithering_pars_fragment>
#include <color_pars_fragment>
#include <uv_pars_fragment>
#include <map_pars_fragment>
#include <alphamap_pars_fragment>
#include <alphatest_pars_fragment>
#include <alphahash_pars_fragment>
#include <aomap_pars_fragment>
#include <lightmap_pars_fragment>
#include <emissivemap_pars_fragment>
#include <cube_uv_reflection_fragment>
#include <envmap_common_pars_fragment>
#include <envmap_pars_fragment>
#include <envmap_physical_pars_fragment>
#include <fog_pars_fragment>
#include <bsdfs>
#include <lights_pars_begin>
#include <normal_pars_fragment>
#include <lights_lambert_pars_fragment>
#include <shadowmap_pars_fragment>
#include <bumpmap_pars_fragment>
#include <normalmap_pars_fragment>
#include <specularmap_pars_fragment>
#include <logdepthbuf_pars_fragment>
#include <clipping_planes_pars_fragment>
void main() {
	vec4 diffuseColor = vec4( diffuse, opacity );
	#include <clipping_planes_fragment>
	ReflectedLight reflectedLight = ReflectedLight( vec3( 0.0 ), vec3( 0.0 ), vec3( 0.0 ), vec3( 0.0 ) );
	vec3 totalEmissiveRadiance = emissive;
	#include <logdepthbuf_fragment>
	#include <map_fragment>
	#include <color_fragment>
	#include <alphamap_fragment>
	#include <alphatest_fragment>
	#include <alphahash_fragment>
	#include <specularmap_fragment>
	#include <normal_fragment_begin>
	#include <normal_fragment_maps>
	#include <emissivemap_fragment>
	#include <lights_lambert_fragment>
	#include <lights_fragment_begin>
	#include <lights_fragment_maps>
	#include <lights_fragment_end>
	#include <aomap_fragment>
	vec3 outgoingLight = reflectedLight.directDiffuse + reflectedLight.indirectDiffuse + totalEmissiveRadiance;
	#include <envmap_fragment>
	#include <opaque_fragment>
	#include <tonemapping_fragment>
	#include <colorspace_fragment>
	#include <fog_fragment>
	#include <premultiplied_alpha_fragment>
	#include <dithering_fragment>
}`,aM=`#define MATCAP
varying vec3 vViewPosition;
#include <common>
#include <batching_pars_vertex>
#include <uv_pars_vertex>
#include <color_pars_vertex>
#include <displacementmap_pars_vertex>
#include <fog_pars_vertex>
#include <normal_pars_vertex>
#include <morphtarget_pars_vertex>
#include <skinning_pars_vertex>
#include <logdepthbuf_pars_vertex>
#include <clipping_planes_pars_vertex>
void main() {
	#include <uv_vertex>
	#include <color_vertex>
	#include <morphinstance_vertex>
	#include <morphcolor_vertex>
	#include <batching_vertex>
	#include <beginnormal_vertex>
	#include <morphnormal_vertex>
	#include <skinbase_vertex>
	#include <skinnormal_vertex>
	#include <defaultnormal_vertex>
	#include <normal_vertex>
	#include <begin_vertex>
	#include <morphtarget_vertex>
	#include <skinning_vertex>
	#include <displacementmap_vertex>
	#include <project_vertex>
	#include <logdepthbuf_vertex>
	#include <clipping_planes_vertex>
	#include <fog_vertex>
	vViewPosition = - mvPosition.xyz;
}`,lM=`#define MATCAP
uniform vec3 diffuse;
uniform float opacity;
uniform sampler2D matcap;
varying vec3 vViewPosition;
#include <common>
#include <dithering_pars_fragment>
#include <color_pars_fragment>
#include <uv_pars_fragment>
#include <map_pars_fragment>
#include <alphamap_pars_fragment>
#include <alphatest_pars_fragment>
#include <alphahash_pars_fragment>
#include <fog_pars_fragment>
#include <normal_pars_fragment>
#include <bumpmap_pars_fragment>
#include <normalmap_pars_fragment>
#include <logdepthbuf_pars_fragment>
#include <clipping_planes_pars_fragment>
void main() {
	vec4 diffuseColor = vec4( diffuse, opacity );
	#include <clipping_planes_fragment>
	#include <logdepthbuf_fragment>
	#include <map_fragment>
	#include <color_fragment>
	#include <alphamap_fragment>
	#include <alphatest_fragment>
	#include <alphahash_fragment>
	#include <normal_fragment_begin>
	#include <normal_fragment_maps>
	vec3 viewDir = normalize( vViewPosition );
	vec3 x = normalize( vec3( viewDir.z, 0.0, - viewDir.x ) );
	vec3 y = cross( viewDir, x );
	vec2 uv = vec2( dot( x, normal ), dot( y, normal ) ) * 0.495 + 0.5;
	#ifdef USE_MATCAP
		vec4 matcapColor = texture2D( matcap, uv );
	#else
		vec4 matcapColor = vec4( vec3( mix( 0.2, 0.8, uv.y ) ), 1.0 );
	#endif
	vec3 outgoingLight = diffuseColor.rgb * matcapColor.rgb;
	#include <opaque_fragment>
	#include <tonemapping_fragment>
	#include <colorspace_fragment>
	#include <fog_fragment>
	#include <premultiplied_alpha_fragment>
	#include <dithering_fragment>
}`,cM=`#define NORMAL
#if defined( FLAT_SHADED ) || defined( USE_BUMPMAP ) || defined( USE_NORMALMAP_TANGENTSPACE )
	varying vec3 vViewPosition;
#endif
#include <common>
#include <batching_pars_vertex>
#include <uv_pars_vertex>
#include <displacementmap_pars_vertex>
#include <normal_pars_vertex>
#include <morphtarget_pars_vertex>
#include <skinning_pars_vertex>
#include <logdepthbuf_pars_vertex>
#include <clipping_planes_pars_vertex>
void main() {
	#include <uv_vertex>
	#include <batching_vertex>
	#include <beginnormal_vertex>
	#include <morphinstance_vertex>
	#include <morphnormal_vertex>
	#include <skinbase_vertex>
	#include <skinnormal_vertex>
	#include <defaultnormal_vertex>
	#include <normal_vertex>
	#include <begin_vertex>
	#include <morphtarget_vertex>
	#include <skinning_vertex>
	#include <displacementmap_vertex>
	#include <project_vertex>
	#include <logdepthbuf_vertex>
	#include <clipping_planes_vertex>
#if defined( FLAT_SHADED ) || defined( USE_BUMPMAP ) || defined( USE_NORMALMAP_TANGENTSPACE )
	vViewPosition = - mvPosition.xyz;
#endif
}`,uM=`#define NORMAL
uniform float opacity;
#if defined( FLAT_SHADED ) || defined( USE_BUMPMAP ) || defined( USE_NORMALMAP_TANGENTSPACE )
	varying vec3 vViewPosition;
#endif
#include <uv_pars_fragment>
#include <normal_pars_fragment>
#include <bumpmap_pars_fragment>
#include <normalmap_pars_fragment>
#include <logdepthbuf_pars_fragment>
#include <clipping_planes_pars_fragment>
void main() {
	vec4 diffuseColor = vec4( 0.0, 0.0, 0.0, opacity );
	#include <clipping_planes_fragment>
	#include <logdepthbuf_fragment>
	#include <normal_fragment_begin>
	#include <normal_fragment_maps>
	gl_FragColor = vec4( normalize( normal ) * 0.5 + 0.5, diffuseColor.a );
	#ifdef OPAQUE
		gl_FragColor.a = 1.0;
	#endif
}`,fM=`#define PHONG
varying vec3 vViewPosition;
#include <common>
#include <batching_pars_vertex>
#include <uv_pars_vertex>
#include <displacementmap_pars_vertex>
#include <envmap_pars_vertex>
#include <color_pars_vertex>
#include <fog_pars_vertex>
#include <normal_pars_vertex>
#include <morphtarget_pars_vertex>
#include <skinning_pars_vertex>
#include <shadowmap_pars_vertex>
#include <logdepthbuf_pars_vertex>
#include <clipping_planes_pars_vertex>
void main() {
	#include <uv_vertex>
	#include <color_vertex>
	#include <morphcolor_vertex>
	#include <batching_vertex>
	#include <beginnormal_vertex>
	#include <morphinstance_vertex>
	#include <morphnormal_vertex>
	#include <skinbase_vertex>
	#include <skinnormal_vertex>
	#include <defaultnormal_vertex>
	#include <normal_vertex>
	#include <begin_vertex>
	#include <morphtarget_vertex>
	#include <skinning_vertex>
	#include <displacementmap_vertex>
	#include <project_vertex>
	#include <logdepthbuf_vertex>
	#include <clipping_planes_vertex>
	vViewPosition = - mvPosition.xyz;
	#include <worldpos_vertex>
	#include <envmap_vertex>
	#include <shadowmap_vertex>
	#include <fog_vertex>
}`,hM=`#define PHONG
uniform vec3 diffuse;
uniform vec3 emissive;
uniform vec3 specular;
uniform float shininess;
uniform float opacity;
#include <common>
#include <dithering_pars_fragment>
#include <color_pars_fragment>
#include <uv_pars_fragment>
#include <map_pars_fragment>
#include <alphamap_pars_fragment>
#include <alphatest_pars_fragment>
#include <alphahash_pars_fragment>
#include <aomap_pars_fragment>
#include <lightmap_pars_fragment>
#include <emissivemap_pars_fragment>
#include <cube_uv_reflection_fragment>
#include <envmap_common_pars_fragment>
#include <envmap_pars_fragment>
#include <envmap_physical_pars_fragment>
#include <fog_pars_fragment>
#include <bsdfs>
#include <lights_pars_begin>
#include <normal_pars_fragment>
#include <lights_phong_pars_fragment>
#include <shadowmap_pars_fragment>
#include <bumpmap_pars_fragment>
#include <normalmap_pars_fragment>
#include <specularmap_pars_fragment>
#include <logdepthbuf_pars_fragment>
#include <clipping_planes_pars_fragment>
void main() {
	vec4 diffuseColor = vec4( diffuse, opacity );
	#include <clipping_planes_fragment>
	ReflectedLight reflectedLight = ReflectedLight( vec3( 0.0 ), vec3( 0.0 ), vec3( 0.0 ), vec3( 0.0 ) );
	vec3 totalEmissiveRadiance = emissive;
	#include <logdepthbuf_fragment>
	#include <map_fragment>
	#include <color_fragment>
	#include <alphamap_fragment>
	#include <alphatest_fragment>
	#include <alphahash_fragment>
	#include <specularmap_fragment>
	#include <normal_fragment_begin>
	#include <normal_fragment_maps>
	#include <emissivemap_fragment>
	#include <lights_phong_fragment>
	#include <lights_fragment_begin>
	#include <lights_fragment_maps>
	#include <lights_fragment_end>
	#include <aomap_fragment>
	vec3 outgoingLight = reflectedLight.directDiffuse + reflectedLight.indirectDiffuse + reflectedLight.directSpecular + reflectedLight.indirectSpecular + totalEmissiveRadiance;
	#include <envmap_fragment>
	#include <opaque_fragment>
	#include <tonemapping_fragment>
	#include <colorspace_fragment>
	#include <fog_fragment>
	#include <premultiplied_alpha_fragment>
	#include <dithering_fragment>
}`,dM=`#define STANDARD
varying vec3 vViewPosition;
#ifdef USE_TRANSMISSION
	varying vec3 vWorldPosition;
#endif
#include <common>
#include <batching_pars_vertex>
#include <uv_pars_vertex>
#include <displacementmap_pars_vertex>
#include <color_pars_vertex>
#include <fog_pars_vertex>
#include <normal_pars_vertex>
#include <morphtarget_pars_vertex>
#include <skinning_pars_vertex>
#include <shadowmap_pars_vertex>
#include <logdepthbuf_pars_vertex>
#include <clipping_planes_pars_vertex>
void main() {
	#include <uv_vertex>
	#include <color_vertex>
	#include <morphinstance_vertex>
	#include <morphcolor_vertex>
	#include <batching_vertex>
	#include <beginnormal_vertex>
	#include <morphnormal_vertex>
	#include <skinbase_vertex>
	#include <skinnormal_vertex>
	#include <defaultnormal_vertex>
	#include <normal_vertex>
	#include <begin_vertex>
	#include <morphtarget_vertex>
	#include <skinning_vertex>
	#include <displacementmap_vertex>
	#include <project_vertex>
	#include <logdepthbuf_vertex>
	#include <clipping_planes_vertex>
	vViewPosition = - mvPosition.xyz;
	#include <worldpos_vertex>
	#include <shadowmap_vertex>
	#include <fog_vertex>
#ifdef USE_TRANSMISSION
	vWorldPosition = worldPosition.xyz;
#endif
}`,pM=`#define STANDARD
#ifdef PHYSICAL
	#define IOR
	#define USE_SPECULAR
#endif
uniform vec3 diffuse;
uniform vec3 emissive;
uniform float roughness;
uniform float metalness;
uniform float opacity;
#ifdef IOR
	uniform float ior;
#endif
#ifdef USE_SPECULAR
	uniform float specularIntensity;
	uniform vec3 specularColor;
	#ifdef USE_SPECULAR_COLORMAP
		uniform sampler2D specularColorMap;
	#endif
	#ifdef USE_SPECULAR_INTENSITYMAP
		uniform sampler2D specularIntensityMap;
	#endif
#endif
#ifdef USE_CLEARCOAT
	uniform float clearcoat;
	uniform float clearcoatRoughness;
#endif
#ifdef USE_DISPERSION
	uniform float dispersion;
#endif
#ifdef USE_IRIDESCENCE
	uniform float iridescence;
	uniform float iridescenceIOR;
	uniform float iridescenceThicknessMinimum;
	uniform float iridescenceThicknessMaximum;
#endif
#ifdef USE_SHEEN
	uniform vec3 sheenColor;
	uniform float sheenRoughness;
	#ifdef USE_SHEEN_COLORMAP
		uniform sampler2D sheenColorMap;
	#endif
	#ifdef USE_SHEEN_ROUGHNESSMAP
		uniform sampler2D sheenRoughnessMap;
	#endif
#endif
#ifdef USE_ANISOTROPY
	uniform vec2 anisotropyVector;
	#ifdef USE_ANISOTROPYMAP
		uniform sampler2D anisotropyMap;
	#endif
#endif
varying vec3 vViewPosition;
#include <common>
#include <dithering_pars_fragment>
#include <color_pars_fragment>
#include <uv_pars_fragment>
#include <map_pars_fragment>
#include <alphamap_pars_fragment>
#include <alphatest_pars_fragment>
#include <alphahash_pars_fragment>
#include <aomap_pars_fragment>
#include <lightmap_pars_fragment>
#include <emissivemap_pars_fragment>
#include <iridescence_fragment>
#include <cube_uv_reflection_fragment>
#include <envmap_common_pars_fragment>
#include <envmap_physical_pars_fragment>
#include <fog_pars_fragment>
#include <lights_pars_begin>
#include <normal_pars_fragment>
#include <lights_physical_pars_fragment>
#include <transmission_pars_fragment>
#include <shadowmap_pars_fragment>
#include <bumpmap_pars_fragment>
#include <normalmap_pars_fragment>
#include <clearcoat_pars_fragment>
#include <iridescence_pars_fragment>
#include <roughnessmap_pars_fragment>
#include <metalnessmap_pars_fragment>
#include <logdepthbuf_pars_fragment>
#include <clipping_planes_pars_fragment>
void main() {
	vec4 diffuseColor = vec4( diffuse, opacity );
	#include <clipping_planes_fragment>
	ReflectedLight reflectedLight = ReflectedLight( vec3( 0.0 ), vec3( 0.0 ), vec3( 0.0 ), vec3( 0.0 ) );
	vec3 totalEmissiveRadiance = emissive;
	#include <logdepthbuf_fragment>
	#include <map_fragment>
	#include <color_fragment>
	#include <alphamap_fragment>
	#include <alphatest_fragment>
	#include <alphahash_fragment>
	#include <roughnessmap_fragment>
	#include <metalnessmap_fragment>
	#include <normal_fragment_begin>
	#include <normal_fragment_maps>
	#include <clearcoat_normal_fragment_begin>
	#include <clearcoat_normal_fragment_maps>
	#include <emissivemap_fragment>
	#include <lights_physical_fragment>
	#include <lights_fragment_begin>
	#include <lights_fragment_maps>
	#include <lights_fragment_end>
	#include <aomap_fragment>
	vec3 totalDiffuse = reflectedLight.directDiffuse + reflectedLight.indirectDiffuse;
	vec3 totalSpecular = reflectedLight.directSpecular + reflectedLight.indirectSpecular;
	#include <transmission_fragment>
	vec3 outgoingLight = totalDiffuse + totalSpecular + totalEmissiveRadiance;
	#ifdef USE_SHEEN
 
		outgoingLight = outgoingLight + sheenSpecularDirect + sheenSpecularIndirect;
 
 	#endif
	#ifdef USE_CLEARCOAT
		float dotNVcc = saturate( dot( geometryClearcoatNormal, geometryViewDir ) );
		vec3 Fcc = F_Schlick( material.clearcoatF0, material.clearcoatF90, dotNVcc );
		outgoingLight = outgoingLight * ( 1.0 - material.clearcoat * Fcc ) + ( clearcoatSpecularDirect + clearcoatSpecularIndirect ) * material.clearcoat;
	#endif
	#include <opaque_fragment>
	#include <tonemapping_fragment>
	#include <colorspace_fragment>
	#include <fog_fragment>
	#include <premultiplied_alpha_fragment>
	#include <dithering_fragment>
}`,mM=`#define TOON
varying vec3 vViewPosition;
#include <common>
#include <batching_pars_vertex>
#include <uv_pars_vertex>
#include <displacementmap_pars_vertex>
#include <color_pars_vertex>
#include <fog_pars_vertex>
#include <normal_pars_vertex>
#include <morphtarget_pars_vertex>
#include <skinning_pars_vertex>
#include <shadowmap_pars_vertex>
#include <logdepthbuf_pars_vertex>
#include <clipping_planes_pars_vertex>
void main() {
	#include <uv_vertex>
	#include <color_vertex>
	#include <morphinstance_vertex>
	#include <morphcolor_vertex>
	#include <batching_vertex>
	#include <beginnormal_vertex>
	#include <morphnormal_vertex>
	#include <skinbase_vertex>
	#include <skinnormal_vertex>
	#include <defaultnormal_vertex>
	#include <normal_vertex>
	#include <begin_vertex>
	#include <morphtarget_vertex>
	#include <skinning_vertex>
	#include <displacementmap_vertex>
	#include <project_vertex>
	#include <logdepthbuf_vertex>
	#include <clipping_planes_vertex>
	vViewPosition = - mvPosition.xyz;
	#include <worldpos_vertex>
	#include <shadowmap_vertex>
	#include <fog_vertex>
}`,gM=`#define TOON
uniform vec3 diffuse;
uniform vec3 emissive;
uniform float opacity;
#include <common>
#include <dithering_pars_fragment>
#include <color_pars_fragment>
#include <uv_pars_fragment>
#include <map_pars_fragment>
#include <alphamap_pars_fragment>
#include <alphatest_pars_fragment>
#include <alphahash_pars_fragment>
#include <aomap_pars_fragment>
#include <lightmap_pars_fragment>
#include <emissivemap_pars_fragment>
#include <gradientmap_pars_fragment>
#include <fog_pars_fragment>
#include <bsdfs>
#include <lights_pars_begin>
#include <normal_pars_fragment>
#include <lights_toon_pars_fragment>
#include <shadowmap_pars_fragment>
#include <bumpmap_pars_fragment>
#include <normalmap_pars_fragment>
#include <logdepthbuf_pars_fragment>
#include <clipping_planes_pars_fragment>
void main() {
	vec4 diffuseColor = vec4( diffuse, opacity );
	#include <clipping_planes_fragment>
	ReflectedLight reflectedLight = ReflectedLight( vec3( 0.0 ), vec3( 0.0 ), vec3( 0.0 ), vec3( 0.0 ) );
	vec3 totalEmissiveRadiance = emissive;
	#include <logdepthbuf_fragment>
	#include <map_fragment>
	#include <color_fragment>
	#include <alphamap_fragment>
	#include <alphatest_fragment>
	#include <alphahash_fragment>
	#include <normal_fragment_begin>
	#include <normal_fragment_maps>
	#include <emissivemap_fragment>
	#include <lights_toon_fragment>
	#include <lights_fragment_begin>
	#include <lights_fragment_maps>
	#include <lights_fragment_end>
	#include <aomap_fragment>
	vec3 outgoingLight = reflectedLight.directDiffuse + reflectedLight.indirectDiffuse + totalEmissiveRadiance;
	#include <opaque_fragment>
	#include <tonemapping_fragment>
	#include <colorspace_fragment>
	#include <fog_fragment>
	#include <premultiplied_alpha_fragment>
	#include <dithering_fragment>
}`,_M=`uniform float size;
uniform float scale;
#include <common>
#include <color_pars_vertex>
#include <fog_pars_vertex>
#include <morphtarget_pars_vertex>
#include <logdepthbuf_pars_vertex>
#include <clipping_planes_pars_vertex>
#ifdef USE_POINTS_UV
	varying vec2 vUv;
	uniform mat3 uvTransform;
#endif
void main() {
	#ifdef USE_POINTS_UV
		vUv = ( uvTransform * vec3( uv, 1 ) ).xy;
	#endif
	#include <color_vertex>
	#include <morphinstance_vertex>
	#include <morphcolor_vertex>
	#include <begin_vertex>
	#include <morphtarget_vertex>
	#include <project_vertex>
	gl_PointSize = size;
	#ifdef USE_SIZEATTENUATION
		bool isPerspective = isPerspectiveMatrix( projectionMatrix );
		if ( isPerspective ) gl_PointSize *= ( scale / - mvPosition.z );
	#endif
	#include <logdepthbuf_vertex>
	#include <clipping_planes_vertex>
	#include <worldpos_vertex>
	#include <fog_vertex>
}`,xM=`uniform vec3 diffuse;
uniform float opacity;
#include <common>
#include <color_pars_fragment>
#include <map_particle_pars_fragment>
#include <alphatest_pars_fragment>
#include <alphahash_pars_fragment>
#include <fog_pars_fragment>
#include <logdepthbuf_pars_fragment>
#include <clipping_planes_pars_fragment>
void main() {
	vec4 diffuseColor = vec4( diffuse, opacity );
	#include <clipping_planes_fragment>
	vec3 outgoingLight = vec3( 0.0 );
	#include <logdepthbuf_fragment>
	#include <map_particle_fragment>
	#include <color_fragment>
	#include <alphatest_fragment>
	#include <alphahash_fragment>
	outgoingLight = diffuseColor.rgb;
	#include <opaque_fragment>
	#include <tonemapping_fragment>
	#include <colorspace_fragment>
	#include <fog_fragment>
	#include <premultiplied_alpha_fragment>
}`,vM=`#include <common>
#include <batching_pars_vertex>
#include <fog_pars_vertex>
#include <morphtarget_pars_vertex>
#include <skinning_pars_vertex>
#include <logdepthbuf_pars_vertex>
#include <shadowmap_pars_vertex>
void main() {
	#include <batching_vertex>
	#include <beginnormal_vertex>
	#include <morphinstance_vertex>
	#include <morphnormal_vertex>
	#include <skinbase_vertex>
	#include <skinnormal_vertex>
	#include <defaultnormal_vertex>
	#include <begin_vertex>
	#include <morphtarget_vertex>
	#include <skinning_vertex>
	#include <project_vertex>
	#include <logdepthbuf_vertex>
	#include <worldpos_vertex>
	#include <shadowmap_vertex>
	#include <fog_vertex>
}`,MM=`uniform vec3 color;
uniform float opacity;
#include <common>
#include <fog_pars_fragment>
#include <bsdfs>
#include <lights_pars_begin>
#include <logdepthbuf_pars_fragment>
#include <shadowmap_pars_fragment>
#include <shadowmask_pars_fragment>
void main() {
	#include <logdepthbuf_fragment>
	gl_FragColor = vec4( color, opacity * ( 1.0 - getShadowMask() ) );
	#include <tonemapping_fragment>
	#include <colorspace_fragment>
	#include <fog_fragment>
	#include <premultiplied_alpha_fragment>
}`,SM=`uniform float rotation;
uniform vec2 center;
#include <common>
#include <uv_pars_vertex>
#include <fog_pars_vertex>
#include <logdepthbuf_pars_vertex>
#include <clipping_planes_pars_vertex>
void main() {
	#include <uv_vertex>
	vec4 mvPosition = modelViewMatrix[ 3 ];
	vec2 scale = vec2( length( modelMatrix[ 0 ].xyz ), length( modelMatrix[ 1 ].xyz ) );
	#ifndef USE_SIZEATTENUATION
		bool isPerspective = isPerspectiveMatrix( projectionMatrix );
		if ( isPerspective ) scale *= - mvPosition.z;
	#endif
	vec2 alignedPosition = ( position.xy - ( center - vec2( 0.5 ) ) ) * scale;
	vec2 rotatedPosition;
	rotatedPosition.x = cos( rotation ) * alignedPosition.x - sin( rotation ) * alignedPosition.y;
	rotatedPosition.y = sin( rotation ) * alignedPosition.x + cos( rotation ) * alignedPosition.y;
	mvPosition.xy += rotatedPosition;
	gl_Position = projectionMatrix * mvPosition;
	#include <logdepthbuf_vertex>
	#include <clipping_planes_vertex>
	#include <fog_vertex>
}`,EM=`uniform vec3 diffuse;
uniform float opacity;
#include <common>
#include <uv_pars_fragment>
#include <map_pars_fragment>
#include <alphamap_pars_fragment>
#include <alphatest_pars_fragment>
#include <alphahash_pars_fragment>
#include <fog_pars_fragment>
#include <logdepthbuf_pars_fragment>
#include <clipping_planes_pars_fragment>
void main() {
	vec4 diffuseColor = vec4( diffuse, opacity );
	#include <clipping_planes_fragment>
	vec3 outgoingLight = vec3( 0.0 );
	#include <logdepthbuf_fragment>
	#include <map_fragment>
	#include <alphamap_fragment>
	#include <alphatest_fragment>
	#include <alphahash_fragment>
	outgoingLight = diffuseColor.rgb;
	#include <opaque_fragment>
	#include <tonemapping_fragment>
	#include <colorspace_fragment>
	#include <fog_fragment>
}`,je={alphahash_fragment:k0,alphahash_pars_fragment:W0,alphamap_fragment:X0,alphamap_pars_fragment:Y0,alphatest_fragment:q0,alphatest_pars_fragment:K0,aomap_fragment:j0,aomap_pars_fragment:Z0,batching_pars_vertex:$0,batching_vertex:J0,begin_vertex:Q0,beginnormal_vertex:ex,bsdfs:tx,iridescence_fragment:nx,bumpmap_pars_fragment:ix,clipping_planes_fragment:rx,clipping_planes_pars_fragment:sx,clipping_planes_pars_vertex:ox,clipping_planes_vertex:ax,color_fragment:lx,color_pars_fragment:cx,color_pars_vertex:ux,color_vertex:fx,common:hx,cube_uv_reflection_fragment:dx,defaultnormal_vertex:px,displacementmap_pars_vertex:mx,displacementmap_vertex:gx,emissivemap_fragment:_x,emissivemap_pars_fragment:xx,colorspace_fragment:vx,colorspace_pars_fragment:Mx,envmap_fragment:Sx,envmap_common_pars_fragment:Ex,envmap_pars_fragment:yx,envmap_pars_vertex:bx,envmap_physical_pars_fragment:Nx,envmap_vertex:Tx,fog_vertex:Ax,fog_pars_vertex:wx,fog_fragment:Rx,fog_pars_fragment:Cx,gradientmap_pars_fragment:Px,lightmap_pars_fragment:Dx,lights_lambert_fragment:Ix,lights_lambert_pars_fragment:Lx,lights_pars_begin:Ux,lights_toon_fragment:Fx,lights_toon_pars_fragment:Ox,lights_phong_fragment:Bx,lights_phong_pars_fragment:zx,lights_physical_fragment:Hx,lights_physical_pars_fragment:Vx,lights_fragment_begin:Gx,lights_fragment_maps:kx,lights_fragment_end:Wx,lightprobes_pars_fragment:Xx,logdepthbuf_fragment:Yx,logdepthbuf_pars_fragment:qx,logdepthbuf_pars_vertex:Kx,logdepthbuf_vertex:jx,map_fragment:Zx,map_pars_fragment:$x,map_particle_fragment:Jx,map_particle_pars_fragment:Qx,metalnessmap_fragment:ev,metalnessmap_pars_fragment:tv,morphinstance_vertex:nv,morphcolor_vertex:iv,morphnormal_vertex:rv,morphtarget_pars_vertex:sv,morphtarget_vertex:ov,normal_fragment_begin:av,normal_fragment_maps:lv,normal_pars_fragment:cv,normal_pars_vertex:uv,normal_vertex:fv,normalmap_pars_fragment:hv,clearcoat_normal_fragment_begin:dv,clearcoat_normal_fragment_maps:pv,clearcoat_pars_fragment:mv,iridescence_pars_fragment:gv,opaque_fragment:_v,packing:xv,premultiplied_alpha_fragment:vv,project_vertex:Mv,dithering_fragment:Sv,dithering_pars_fragment:Ev,roughnessmap_fragment:yv,roughnessmap_pars_fragment:bv,shadowmap_pars_fragment:Tv,shadowmap_pars_vertex:Av,shadowmap_vertex:wv,shadowmask_pars_fragment:Rv,skinbase_vertex:Cv,skinning_pars_vertex:Pv,skinning_vertex:Dv,skinnormal_vertex:Iv,specularmap_fragment:Lv,specularmap_pars_fragment:Uv,tonemapping_fragment:Nv,tonemapping_pars_fragment:Fv,transmission_fragment:Ov,transmission_pars_fragment:Bv,uv_pars_fragment:zv,uv_pars_vertex:Hv,uv_vertex:Vv,worldpos_vertex:Gv,background_vert:kv,background_frag:Wv,backgroundCube_vert:Xv,backgroundCube_frag:Yv,cube_vert:qv,cube_frag:Kv,depth_vert:jv,depth_frag:Zv,distance_vert:$v,distance_frag:Jv,equirect_vert:Qv,equirect_frag:eM,linedashed_vert:tM,linedashed_frag:nM,meshbasic_vert:iM,meshbasic_frag:rM,meshlambert_vert:sM,meshlambert_frag:oM,meshmatcap_vert:aM,meshmatcap_frag:lM,meshnormal_vert:cM,meshnormal_frag:uM,meshphong_vert:fM,meshphong_frag:hM,meshphysical_vert:dM,meshphysical_frag:pM,meshtoon_vert:mM,meshtoon_frag:gM,points_vert:_M,points_frag:xM,shadow_vert:vM,shadow_frag:MM,sprite_vert:SM,sprite_frag:EM},ye={common:{diffuse:{value:new lt(16777215)},opacity:{value:1},map:{value:null},mapTransform:{value:new Xe},alphaMap:{value:null},alphaMapTransform:{value:new Xe},alphaTest:{value:0}},specularmap:{specularMap:{value:null},specularMapTransform:{value:new Xe}},envmap:{envMap:{value:null},envMapRotation:{value:new Xe},reflectivity:{value:1},ior:{value:1.5},refractionRatio:{value:.98},dfgLUT:{value:null}},aomap:{aoMap:{value:null},aoMapIntensity:{value:1},aoMapTransform:{value:new Xe}},lightmap:{lightMap:{value:null},lightMapIntensity:{value:1},lightMapTransform:{value:new Xe}},bumpmap:{bumpMap:{value:null},bumpMapTransform:{value:new Xe},bumpScale:{value:1}},normalmap:{normalMap:{value:null},normalMapTransform:{value:new Xe},normalScale:{value:new st(1,1)}},displacementmap:{displacementMap:{value:null},displacementMapTransform:{value:new Xe},displacementScale:{value:1},displacementBias:{value:0}},emissivemap:{emissiveMap:{value:null},emissiveMapTransform:{value:new Xe}},metalnessmap:{metalnessMap:{value:null},metalnessMapTransform:{value:new Xe}},roughnessmap:{roughnessMap:{value:null},roughnessMapTransform:{value:new Xe}},gradientmap:{gradientMap:{value:null}},fog:{fogDensity:{value:25e-5},fogNear:{value:1},fogFar:{value:2e3},fogColor:{value:new lt(16777215)}},lights:{ambientLightColor:{value:[]},lightProbe:{value:[]},directionalLights:{value:[],properties:{direction:{},color:{}}},directionalLightShadows:{value:[],properties:{shadowIntensity:1,shadowBias:{},shadowNormalBias:{},shadowRadius:{},shadowMapSize:{}}},directionalShadowMatrix:{value:[]},spotLights:{value:[],properties:{color:{},position:{},direction:{},distance:{},coneCos:{},penumbraCos:{},decay:{}}},spotLightShadows:{value:[],properties:{shadowIntensity:1,shadowBias:{},shadowNormalBias:{},shadowRadius:{},shadowMapSize:{}}},spotLightMap:{value:[]},spotLightMatrix:{value:[]},pointLights:{value:[],properties:{color:{},position:{},decay:{},distance:{}}},pointLightShadows:{value:[],properties:{shadowIntensity:1,shadowBias:{},shadowNormalBias:{},shadowRadius:{},shadowMapSize:{},shadowCameraNear:{},shadowCameraFar:{}}},pointShadowMatrix:{value:[]},hemisphereLights:{value:[],properties:{direction:{},skyColor:{},groundColor:{}}},rectAreaLights:{value:[],properties:{color:{},position:{},width:{},height:{}}},ltc_1:{value:null},ltc_2:{value:null},probesSH:{value:null},probesMin:{value:new N},probesMax:{value:new N},probesResolution:{value:new N}},points:{diffuse:{value:new lt(16777215)},opacity:{value:1},size:{value:1},scale:{value:1},map:{value:null},alphaMap:{value:null},alphaMapTransform:{value:new Xe},alphaTest:{value:0},uvTransform:{value:new Xe}},sprite:{diffuse:{value:new lt(16777215)},opacity:{value:1},center:{value:new st(.5,.5)},rotation:{value:0},map:{value:null},mapTransform:{value:new Xe},alphaMap:{value:null},alphaMapTransform:{value:new Xe},alphaTest:{value:0}}},Bn={basic:{uniforms:en([ye.common,ye.specularmap,ye.envmap,ye.aomap,ye.lightmap,ye.fog]),vertexShader:je.meshbasic_vert,fragmentShader:je.meshbasic_frag},lambert:{uniforms:en([ye.common,ye.specularmap,ye.envmap,ye.aomap,ye.lightmap,ye.emissivemap,ye.bumpmap,ye.normalmap,ye.displacementmap,ye.fog,ye.lights,{emissive:{value:new lt(0)},envMapIntensity:{value:1}}]),vertexShader:je.meshlambert_vert,fragmentShader:je.meshlambert_frag},phong:{uniforms:en([ye.common,ye.specularmap,ye.envmap,ye.aomap,ye.lightmap,ye.emissivemap,ye.bumpmap,ye.normalmap,ye.displacementmap,ye.fog,ye.lights,{emissive:{value:new lt(0)},specular:{value:new lt(1118481)},shininess:{value:30},envMapIntensity:{value:1}}]),vertexShader:je.meshphong_vert,fragmentShader:je.meshphong_frag},standard:{uniforms:en([ye.common,ye.envmap,ye.aomap,ye.lightmap,ye.emissivemap,ye.bumpmap,ye.normalmap,ye.displacementmap,ye.roughnessmap,ye.metalnessmap,ye.fog,ye.lights,{emissive:{value:new lt(0)},roughness:{value:1},metalness:{value:0},envMapIntensity:{value:1}}]),vertexShader:je.meshphysical_vert,fragmentShader:je.meshphysical_frag},toon:{uniforms:en([ye.common,ye.aomap,ye.lightmap,ye.emissivemap,ye.bumpmap,ye.normalmap,ye.displacementmap,ye.gradientmap,ye.fog,ye.lights,{emissive:{value:new lt(0)}}]),vertexShader:je.meshtoon_vert,fragmentShader:je.meshtoon_frag},matcap:{uniforms:en([ye.common,ye.bumpmap,ye.normalmap,ye.displacementmap,ye.fog,{matcap:{value:null}}]),vertexShader:je.meshmatcap_vert,fragmentShader:je.meshmatcap_frag},points:{uniforms:en([ye.points,ye.fog]),vertexShader:je.points_vert,fragmentShader:je.points_frag},dashed:{uniforms:en([ye.common,ye.fog,{scale:{value:1},dashSize:{value:1},totalSize:{value:2}}]),vertexShader:je.linedashed_vert,fragmentShader:je.linedashed_frag},depth:{uniforms:en([ye.common,ye.displacementmap]),vertexShader:je.depth_vert,fragmentShader:je.depth_frag},normal:{uniforms:en([ye.common,ye.bumpmap,ye.normalmap,ye.displacementmap,{opacity:{value:1}}]),vertexShader:je.meshnormal_vert,fragmentShader:je.meshnormal_frag},sprite:{uniforms:en([ye.sprite,ye.fog]),vertexShader:je.sprite_vert,fragmentShader:je.sprite_frag},background:{uniforms:{uvTransform:{value:new Xe},t2D:{value:null},backgroundIntensity:{value:1}},vertexShader:je.background_vert,fragmentShader:je.background_frag},backgroundCube:{uniforms:{envMap:{value:null},backgroundBlurriness:{value:0},backgroundIntensity:{value:1},backgroundRotation:{value:new Xe}},vertexShader:je.backgroundCube_vert,fragmentShader:je.backgroundCube_frag},cube:{uniforms:{tCube:{value:null},tFlip:{value:-1},opacity:{value:1}},vertexShader:je.cube_vert,fragmentShader:je.cube_frag},equirect:{uniforms:{tEquirect:{value:null}},vertexShader:je.equirect_vert,fragmentShader:je.equirect_frag},distance:{uniforms:en([ye.common,ye.displacementmap,{referencePosition:{value:new N},nearDistance:{value:1},farDistance:{value:1e3}}]),vertexShader:je.distance_vert,fragmentShader:je.distance_frag},shadow:{uniforms:en([ye.lights,ye.fog,{color:{value:new lt(0)},opacity:{value:1}}]),vertexShader:je.shadow_vert,fragmentShader:je.shadow_frag}};Bn.physical={uniforms:en([Bn.standard.uniforms,{clearcoat:{value:0},clearcoatMap:{value:null},clearcoatMapTransform:{value:new Xe},clearcoatNormalMap:{value:null},clearcoatNormalMapTransform:{value:new Xe},clearcoatNormalScale:{value:new st(1,1)},clearcoatRoughness:{value:0},clearcoatRoughnessMap:{value:null},clearcoatRoughnessMapTransform:{value:new Xe},dispersion:{value:0},iridescence:{value:0},iridescenceMap:{value:null},iridescenceMapTransform:{value:new Xe},iridescenceIOR:{value:1.3},iridescenceThicknessMinimum:{value:100},iridescenceThicknessMaximum:{value:400},iridescenceThicknessMap:{value:null},iridescenceThicknessMapTransform:{value:new Xe},sheen:{value:0},sheenColor:{value:new lt(0)},sheenColorMap:{value:null},sheenColorMapTransform:{value:new Xe},sheenRoughness:{value:1},sheenRoughnessMap:{value:null},sheenRoughnessMapTransform:{value:new Xe},transmission:{value:0},transmissionMap:{value:null},transmissionMapTransform:{value:new Xe},transmissionSamplerSize:{value:new st},transmissionSamplerMap:{value:null},thickness:{value:0},thicknessMap:{value:null},thicknessMapTransform:{value:new Xe},attenuationDistance:{value:0},attenuationColor:{value:new lt(0)},specularColor:{value:new lt(1,1,1)},specularColorMap:{value:null},specularColorMapTransform:{value:new Xe},specularIntensity:{value:1},specularIntensityMap:{value:null},specularIntensityMapTransform:{value:new Xe},anisotropyVector:{value:new st},anisotropyMap:{value:null},anisotropyMapTransform:{value:new Xe}}]),vertexShader:je.meshphysical_vert,fragmentShader:je.meshphysical_frag};const po={r:0,b:0,g:0},yM=new Mt,op=new Xe;op.set(-1,0,0,0,1,0,0,0,1);function bM(n,e,t,i,r,s){const o=new lt(0);let a=r===!0?0:1,l,c,u=null,h=0,f=null;function p(x){let y=x.isScene===!0?x.background:null;if(y&&y.isTexture){const S=x.backgroundBlurriness>0;y=e.get(y,S)}return y}function g(x){let y=!1;const S=p(x);S===null?m(o,a):S&&S.isColor&&(m(S,1),y=!0);const C=n.xr.getEnvironmentBlendMode();C==="additive"?t.buffers.color.setClear(0,0,0,1,s):C==="alpha-blend"&&t.buffers.color.setClear(0,0,0,0,s),(n.autoClear||y)&&(t.buffers.depth.setTest(!0),t.buffers.depth.setMask(!0),t.buffers.color.setMask(!0),n.clear(n.autoClearColor,n.autoClearDepth,n.autoClearStencil))}function M(x,y){const S=p(y);S&&(S.isCubeTexture||S.mapping===da)?(c===void 0&&(c=new Pe(new Ct(1,1,1),new qn({name:"BackgroundCubeMaterial",uniforms:Gr(Bn.backgroundCube.uniforms),vertexShader:Bn.backgroundCube.vertexShader,fragmentShader:Bn.backgroundCube.fragmentShader,side:on,depthTest:!1,depthWrite:!1,fog:!1,allowOverride:!1})),c.geometry.deleteAttribute("normal"),c.geometry.deleteAttribute("uv"),c.onBeforeRender=function(C,A,P){this.matrixWorld.copyPosition(P.matrixWorld)},Object.defineProperty(c.material,"envMap",{get:function(){return this.uniforms.envMap.value}}),i.update(c)),c.material.uniforms.envMap.value=S,c.material.uniforms.backgroundBlurriness.value=y.backgroundBlurriness,c.material.uniforms.backgroundIntensity.value=y.backgroundIntensity,c.material.uniforms.backgroundRotation.value.setFromMatrix4(yM.makeRotationFromEuler(y.backgroundRotation)).transpose(),S.isCubeTexture&&S.isRenderTargetTexture===!1&&c.material.uniforms.backgroundRotation.value.premultiply(op),c.material.toneMapped=Qe.getTransfer(S.colorSpace)!==ut,(u!==S||h!==S.version||f!==n.toneMapping)&&(c.material.needsUpdate=!0,u=S,h=S.version,f=n.toneMapping),c.layers.enableAll(),x.unshift(c,c.geometry,c.material,0,0,null)):S&&S.isTexture&&(l===void 0&&(l=new Pe(new Fs(2,2),new qn({name:"BackgroundMaterial",uniforms:Gr(Bn.background.uniforms),vertexShader:Bn.background.vertexShader,fragmentShader:Bn.background.fragmentShader,side:Li,depthTest:!1,depthWrite:!1,fog:!1,allowOverride:!1})),l.geometry.deleteAttribute("normal"),Object.defineProperty(l.material,"map",{get:function(){return this.uniforms.t2D.value}}),i.update(l)),l.material.uniforms.t2D.value=S,l.material.uniforms.backgroundIntensity.value=y.backgroundIntensity,l.material.toneMapped=Qe.getTransfer(S.colorSpace)!==ut,S.matrixAutoUpdate===!0&&S.updateMatrix(),l.material.uniforms.uvTransform.value.copy(S.matrix),(u!==S||h!==S.version||f!==n.toneMapping)&&(l.material.needsUpdate=!0,u=S,h=S.version,f=n.toneMapping),l.layers.enableAll(),x.unshift(l,l.geometry,l.material,0,0,null))}function m(x,y){x.getRGB(po,tp(n)),t.buffers.color.setClear(po.r,po.g,po.b,y,s)}function d(){c!==void 0&&(c.geometry.dispose(),c.material.dispose(),c=void 0),l!==void 0&&(l.geometry.dispose(),l.material.dispose(),l=void 0)}return{getClearColor:function(){return o},setClearColor:function(x,y=1){o.set(x),a=y,m(o,a)},getClearAlpha:function(){return a},setClearAlpha:function(x){a=x,m(o,a)},render:g,addToRenderList:M,dispose:d}}function TM(n,e){const t=n.getParameter(n.MAX_VERTEX_ATTRIBS),i={},r=f(null);let s=r,o=!1;function a(D,I,k,G,O){let V=!1;const H=h(D,G,k,I);s!==H&&(s=H,c(s.object)),V=p(D,G,k,O),V&&g(D,G,k,O),O!==null&&e.update(O,n.ELEMENT_ARRAY_BUFFER),(V||o)&&(o=!1,S(D,I,k,G),O!==null&&n.bindBuffer(n.ELEMENT_ARRAY_BUFFER,e.get(O).buffer))}function l(){return n.createVertexArray()}function c(D){return n.bindVertexArray(D)}function u(D){return n.deleteVertexArray(D)}function h(D,I,k,G){const O=G.wireframe===!0;let V=i[I.id];V===void 0&&(V={},i[I.id]=V);const H=D.isInstancedMesh===!0?D.id:0;let $=V[H];$===void 0&&($={},V[H]=$);let oe=$[k.id];oe===void 0&&(oe={},$[k.id]=oe);let ve=oe[O];return ve===void 0&&(ve=f(l()),oe[O]=ve),ve}function f(D){const I=[],k=[],G=[];for(let O=0;O<t;O++)I[O]=0,k[O]=0,G[O]=0;return{geometry:null,program:null,wireframe:!1,newAttributes:I,enabledAttributes:k,attributeDivisors:G,object:D,attributes:{},index:null}}function p(D,I,k,G){const O=s.attributes,V=I.attributes;let H=0;const $=k.getAttributes();for(const oe in $)if($[oe].location>=0){const be=O[oe];let we=V[oe];if(we===void 0&&(oe==="instanceMatrix"&&D.instanceMatrix&&(we=D.instanceMatrix),oe==="instanceColor"&&D.instanceColor&&(we=D.instanceColor)),be===void 0||be.attribute!==we||we&&be.data!==we.data)return!0;H++}return s.attributesNum!==H||s.index!==G}function g(D,I,k,G){const O={},V=I.attributes;let H=0;const $=k.getAttributes();for(const oe in $)if($[oe].location>=0){let be=V[oe];be===void 0&&(oe==="instanceMatrix"&&D.instanceMatrix&&(be=D.instanceMatrix),oe==="instanceColor"&&D.instanceColor&&(be=D.instanceColor));const we={};we.attribute=be,be&&be.data&&(we.data=be.data),O[oe]=we,H++}s.attributes=O,s.attributesNum=H,s.index=G}function M(){const D=s.newAttributes;for(let I=0,k=D.length;I<k;I++)D[I]=0}function m(D){d(D,0)}function d(D,I){const k=s.newAttributes,G=s.enabledAttributes,O=s.attributeDivisors;k[D]=1,G[D]===0&&(n.enableVertexAttribArray(D),G[D]=1),O[D]!==I&&(n.vertexAttribDivisor(D,I),O[D]=I)}function x(){const D=s.newAttributes,I=s.enabledAttributes;for(let k=0,G=I.length;k<G;k++)I[k]!==D[k]&&(n.disableVertexAttribArray(k),I[k]=0)}function y(D,I,k,G,O,V,H){H===!0?n.vertexAttribIPointer(D,I,k,O,V):n.vertexAttribPointer(D,I,k,G,O,V)}function S(D,I,k,G){M();const O=G.attributes,V=k.getAttributes(),H=I.defaultAttributeValues;for(const $ in V){const oe=V[$];if(oe.location>=0){let ve=O[$];if(ve===void 0&&($==="instanceMatrix"&&D.instanceMatrix&&(ve=D.instanceMatrix),$==="instanceColor"&&D.instanceColor&&(ve=D.instanceColor)),ve!==void 0){const be=ve.normalized,we=ve.itemSize,$e=e.get(ve);if($e===void 0)continue;const tt=$e.buffer,We=$e.type,se=$e.bytesPerElement,Se=We===n.INT||We===n.UNSIGNED_INT||ve.gpuType===Bc;if(ve.isInterleavedBufferAttribute){const me=ve.data,Be=me.stride,He=ve.offset;if(me.isInstancedInterleavedBuffer){for(let Ve=0;Ve<oe.locationSize;Ve++)d(oe.location+Ve,me.meshPerAttribute);D.isInstancedMesh!==!0&&G._maxInstanceCount===void 0&&(G._maxInstanceCount=me.meshPerAttribute*me.count)}else for(let Ve=0;Ve<oe.locationSize;Ve++)m(oe.location+Ve);n.bindBuffer(n.ARRAY_BUFFER,tt);for(let Ve=0;Ve<oe.locationSize;Ve++)y(oe.location+Ve,we/oe.locationSize,We,be,Be*se,(He+we/oe.locationSize*Ve)*se,Se)}else{if(ve.isInstancedBufferAttribute){for(let me=0;me<oe.locationSize;me++)d(oe.location+me,ve.meshPerAttribute);D.isInstancedMesh!==!0&&G._maxInstanceCount===void 0&&(G._maxInstanceCount=ve.meshPerAttribute*ve.count)}else for(let me=0;me<oe.locationSize;me++)m(oe.location+me);n.bindBuffer(n.ARRAY_BUFFER,tt);for(let me=0;me<oe.locationSize;me++)y(oe.location+me,we/oe.locationSize,We,be,we*se,we/oe.locationSize*me*se,Se)}}else if(H!==void 0){const be=H[$];if(be!==void 0)switch(be.length){case 2:n.vertexAttrib2fv(oe.location,be);break;case 3:n.vertexAttrib3fv(oe.location,be);break;case 4:n.vertexAttrib4fv(oe.location,be);break;default:n.vertexAttrib1fv(oe.location,be)}}}}x()}function C(){T();for(const D in i){const I=i[D];for(const k in I){const G=I[k];for(const O in G){const V=G[O];for(const H in V)u(V[H].object),delete V[H];delete G[O]}}delete i[D]}}function A(D){if(i[D.id]===void 0)return;const I=i[D.id];for(const k in I){const G=I[k];for(const O in G){const V=G[O];for(const H in V)u(V[H].object),delete V[H];delete G[O]}}delete i[D.id]}function P(D){for(const I in i){const k=i[I];for(const G in k){const O=k[G];if(O[D.id]===void 0)continue;const V=O[D.id];for(const H in V)u(V[H].object),delete V[H];delete O[D.id]}}}function v(D){for(const I in i){const k=i[I],G=D.isInstancedMesh===!0?D.id:0,O=k[G];if(O!==void 0){for(const V in O){const H=O[V];for(const $ in H)u(H[$].object),delete H[$];delete O[V]}delete k[G],Object.keys(k).length===0&&delete i[I]}}}function T(){L(),o=!0,s!==r&&(s=r,c(s.object))}function L(){r.geometry=null,r.program=null,r.wireframe=!1}return{setup:a,reset:T,resetDefaultState:L,dispose:C,releaseStatesOfGeometry:A,releaseStatesOfObject:v,releaseStatesOfProgram:P,initAttributes:M,enableAttribute:m,disableUnusedAttributes:x}}function AM(n,e,t){let i;function r(l){i=l}function s(l,c){n.drawArrays(i,l,c),t.update(c,i,1)}function o(l,c,u){u!==0&&(n.drawArraysInstanced(i,l,c,u),t.update(c,i,u))}function a(l,c,u){if(u===0)return;e.get("WEBGL_multi_draw").multiDrawArraysWEBGL(i,l,0,c,0,u);let f=0;for(let p=0;p<u;p++)f+=c[p];t.update(f,i,1)}this.setMode=r,this.render=s,this.renderInstances=o,this.renderMultiDraw=a}function wM(n,e,t,i){let r;function s(){if(r!==void 0)return r;if(e.has("EXT_texture_filter_anisotropic")===!0){const P=e.get("EXT_texture_filter_anisotropic");r=n.getParameter(P.MAX_TEXTURE_MAX_ANISOTROPY_EXT)}else r=0;return r}function o(P){return!(P!==Tn&&i.convert(P)!==n.getParameter(n.IMPLEMENTATION_COLOR_READ_FORMAT))}function a(P){const v=P===fi&&(e.has("EXT_color_buffer_half_float")||e.has("EXT_color_buffer_float"));return!(P!==xn&&i.convert(P)!==n.getParameter(n.IMPLEMENTATION_COLOR_READ_TYPE)&&P!==Hn&&!v)}function l(P){if(P==="highp"){if(n.getShaderPrecisionFormat(n.VERTEX_SHADER,n.HIGH_FLOAT).precision>0&&n.getShaderPrecisionFormat(n.FRAGMENT_SHADER,n.HIGH_FLOAT).precision>0)return"highp";P="mediump"}return P==="mediump"&&n.getShaderPrecisionFormat(n.VERTEX_SHADER,n.MEDIUM_FLOAT).precision>0&&n.getShaderPrecisionFormat(n.FRAGMENT_SHADER,n.MEDIUM_FLOAT).precision>0?"mediump":"lowp"}let c=t.precision!==void 0?t.precision:"highp";const u=l(c);u!==c&&(ze("WebGLRenderer:",c,"not supported, using",u,"instead."),c=u);const h=t.logarithmicDepthBuffer===!0,f=t.reversedDepthBuffer===!0&&e.has("EXT_clip_control");t.reversedDepthBuffer===!0&&f===!1&&ze("WebGLRenderer: Unable to use reversed depth buffer due to missing EXT_clip_control extension. Fallback to default depth buffer.");const p=n.getParameter(n.MAX_TEXTURE_IMAGE_UNITS),g=n.getParameter(n.MAX_VERTEX_TEXTURE_IMAGE_UNITS),M=n.getParameter(n.MAX_TEXTURE_SIZE),m=n.getParameter(n.MAX_CUBE_MAP_TEXTURE_SIZE),d=n.getParameter(n.MAX_VERTEX_ATTRIBS),x=n.getParameter(n.MAX_VERTEX_UNIFORM_VECTORS),y=n.getParameter(n.MAX_VARYING_VECTORS),S=n.getParameter(n.MAX_FRAGMENT_UNIFORM_VECTORS),C=n.getParameter(n.MAX_SAMPLES),A=n.getParameter(n.SAMPLES);return{isWebGL2:!0,getMaxAnisotropy:s,getMaxPrecision:l,textureFormatReadable:o,textureTypeReadable:a,precision:c,logarithmicDepthBuffer:h,reversedDepthBuffer:f,maxTextures:p,maxVertexTextures:g,maxTextureSize:M,maxCubemapSize:m,maxAttributes:d,maxVertexUniforms:x,maxVaryings:y,maxFragmentUniforms:S,maxSamples:C,samples:A}}function RM(n){const e=this;let t=null,i=0,r=!1,s=!1;const o=new Yi,a=new Xe,l={value:null,needsUpdate:!1};this.uniform=l,this.numPlanes=0,this.numIntersection=0,this.init=function(h,f){const p=h.length!==0||f||i!==0||r;return r=f,i=h.length,p},this.beginShadows=function(){s=!0,u(null)},this.endShadows=function(){s=!1},this.setGlobalState=function(h,f){t=u(h,f,0)},this.setState=function(h,f,p){const g=h.clippingPlanes,M=h.clipIntersection,m=h.clipShadows,d=n.get(h);if(!r||g===null||g.length===0||s&&!m)s?u(null):c();else{const x=s?0:i,y=x*4;let S=d.clippingState||null;l.value=S,S=u(g,f,y,p);for(let C=0;C!==y;++C)S[C]=t[C];d.clippingState=S,this.numIntersection=M?this.numPlanes:0,this.numPlanes+=x}};function c(){l.value!==t&&(l.value=t,l.needsUpdate=i>0),e.numPlanes=i,e.numIntersection=0}function u(h,f,p,g){const M=h!==null?h.length:0;let m=null;if(M!==0){if(m=l.value,g!==!0||m===null){const d=p+M*4,x=f.matrixWorldInverse;a.getNormalMatrix(x),(m===null||m.length<d)&&(m=new Float32Array(d));for(let y=0,S=p;y!==M;++y,S+=4)o.copy(h[y]).applyMatrix4(x,a),o.normal.toArray(m,S),m[S+3]=o.constant}l.value=m,l.needsUpdate=!0}return e.numPlanes=M,e.numIntersection=0,m}}const Di=4,wf=[.125,.215,.35,.446,.526,.582],Qi=20,CM=256,es=new ip,Rf=new lt;let rl=null,sl=0,ol=0,al=!1;const PM=new N;class Cf{constructor(e){this._renderer=e,this._pingPongRenderTarget=null,this._lodMax=0,this._cubeSize=0,this._sizeLods=[],this._sigmas=[],this._lodMeshes=[],this._backgroundBox=null,this._cubemapMaterial=null,this._equirectMaterial=null,this._blurMaterial=null,this._ggxMaterial=null}fromScene(e,t=0,i=.1,r=100,s={}){const{size:o=256,position:a=PM}=s;rl=this._renderer.getRenderTarget(),sl=this._renderer.getActiveCubeFace(),ol=this._renderer.getActiveMipmapLevel(),al=this._renderer.xr.enabled,this._renderer.xr.enabled=!1,this._setSize(o);const l=this._allocateTargets();return l.depthBuffer=!0,this._sceneToCubeUV(e,i,r,l,a),t>0&&this._blur(l,0,0,t),this._applyPMREM(l),this._cleanup(l),l}fromEquirectangular(e,t=null){return this._fromTexture(e,t)}fromCubemap(e,t=null){return this._fromTexture(e,t)}compileCubemapShader(){this._cubemapMaterial===null&&(this._cubemapMaterial=If(),this._compileMaterial(this._cubemapMaterial))}compileEquirectangularShader(){this._equirectMaterial===null&&(this._equirectMaterial=Df(),this._compileMaterial(this._equirectMaterial))}dispose(){this._dispose(),this._cubemapMaterial!==null&&this._cubemapMaterial.dispose(),this._equirectMaterial!==null&&this._equirectMaterial.dispose(),this._backgroundBox!==null&&(this._backgroundBox.geometry.dispose(),this._backgroundBox.material.dispose())}_setSize(e){this._lodMax=Math.floor(Math.log2(e)),this._cubeSize=Math.pow(2,this._lodMax)}_dispose(){this._blurMaterial!==null&&this._blurMaterial.dispose(),this._ggxMaterial!==null&&this._ggxMaterial.dispose(),this._pingPongRenderTarget!==null&&this._pingPongRenderTarget.dispose();for(let e=0;e<this._lodMeshes.length;e++)this._lodMeshes[e].geometry.dispose()}_cleanup(e){this._renderer.setRenderTarget(rl,sl,ol),this._renderer.xr.enabled=al,e.scissorTest=!1,Tr(e,0,0,e.width,e.height)}_fromTexture(e,t){e.mapping===or||e.mapping===Hr?this._setSize(e.image.length===0?16:e.image[0].width||e.image[0].image.width):this._setSize(e.image.width/4),rl=this._renderer.getRenderTarget(),sl=this._renderer.getActiveCubeFace(),ol=this._renderer.getActiveMipmapLevel(),al=this._renderer.xr.enabled,this._renderer.xr.enabled=!1;const i=t||this._allocateTargets();return this._textureToCubeUV(e,i),this._applyPMREM(i),this._cleanup(i),i}_allocateTargets(){const e=3*Math.max(this._cubeSize,112),t=4*this._cubeSize,i={magFilter:jt,minFilter:jt,generateMipmaps:!1,type:fi,format:Tn,colorSpace:Xo,depthBuffer:!1},r=Pf(e,t,i);if(this._pingPongRenderTarget===null||this._pingPongRenderTarget.width!==e||this._pingPongRenderTarget.height!==t){this._pingPongRenderTarget!==null&&this._dispose(),this._pingPongRenderTarget=Pf(e,t,i);const{_lodMax:s}=this;({lodMeshes:this._lodMeshes,sizeLods:this._sizeLods,sigmas:this._sigmas}=DM(s)),this._blurMaterial=LM(s,e,t),this._ggxMaterial=IM(s,e,t)}return r}_compileMaterial(e){const t=new Pe(new $t,e);this._renderer.compile(t,es)}_sceneToCubeUV(e,t,i,r,s){const l=new yn(90,1,t,i),c=[1,-1,1,1,1,1],u=[1,1,1,-1,-1,-1],h=this._renderer,f=h.autoClear,p=h.toneMapping;h.getClearColor(Rf),h.toneMapping=kn,h.autoClear=!1,h.state.buffers.depth.getReversed()&&(h.setRenderTarget(r),h.clearDepth(),h.setRenderTarget(null)),this._backgroundBox===null&&(this._backgroundBox=new Pe(new Ct,new ma({name:"PMREM.Background",side:on,depthWrite:!1,depthTest:!1})));const M=this._backgroundBox,m=M.material;let d=!1;const x=e.background;x?x.isColor&&(m.color.copy(x),e.background=null,d=!0):(m.color.copy(Rf),d=!0);for(let y=0;y<6;y++){const S=y%3;S===0?(l.up.set(0,c[y],0),l.position.set(s.x,s.y,s.z),l.lookAt(s.x+u[y],s.y,s.z)):S===1?(l.up.set(0,0,c[y]),l.position.set(s.x,s.y,s.z),l.lookAt(s.x,s.y+u[y],s.z)):(l.up.set(0,c[y],0),l.position.set(s.x,s.y,s.z),l.lookAt(s.x,s.y,s.z+u[y]));const C=this._cubeSize;Tr(r,S*C,y>2?C:0,C,C),h.setRenderTarget(r),d&&h.render(M,l),h.render(e,l)}h.toneMapping=p,h.autoClear=f,e.background=x}_textureToCubeUV(e,t){const i=this._renderer,r=e.mapping===or||e.mapping===Hr;r?(this._cubemapMaterial===null&&(this._cubemapMaterial=If()),this._cubemapMaterial.uniforms.flipEnvMap.value=e.isRenderTargetTexture===!1?-1:1):this._equirectMaterial===null&&(this._equirectMaterial=Df());const s=r?this._cubemapMaterial:this._equirectMaterial,o=this._lodMeshes[0];o.material=s;const a=s.uniforms;a.envMap.value=e;const l=this._cubeSize;Tr(t,0,0,3*l,2*l),i.setRenderTarget(t),i.render(o,es)}_applyPMREM(e){const t=this._renderer,i=t.autoClear;t.autoClear=!1;const r=this._lodMeshes.length;for(let s=1;s<r;s++)this._applyGGXFilter(e,s-1,s);t.autoClear=i}_applyGGXFilter(e,t,i){const r=this._renderer,s=this._pingPongRenderTarget,o=this._ggxMaterial,a=this._lodMeshes[i];a.material=o;const l=o.uniforms,c=i/(this._lodMeshes.length-1),u=t/(this._lodMeshes.length-1),h=Math.sqrt(c*c-u*u),f=0+c*1.25,p=h*f,{_lodMax:g}=this,M=this._sizeLods[i],m=3*M*(i>g-Di?i-g+Di:0),d=4*(this._cubeSize-M);l.envMap.value=e.texture,l.roughness.value=p,l.mipInt.value=g-t,Tr(s,m,d,3*M,2*M),r.setRenderTarget(s),r.render(a,es),l.envMap.value=s.texture,l.roughness.value=0,l.mipInt.value=g-i,Tr(e,m,d,3*M,2*M),r.setRenderTarget(e),r.render(a,es)}_blur(e,t,i,r,s){const o=this._pingPongRenderTarget;this._halfBlur(e,o,t,i,r,"latitudinal",s),this._halfBlur(o,e,i,i,r,"longitudinal",s)}_halfBlur(e,t,i,r,s,o,a){const l=this._renderer,c=this._blurMaterial;o!=="latitudinal"&&o!=="longitudinal"&&et("blur direction must be either latitudinal or longitudinal!");const u=3,h=this._lodMeshes[r];h.material=c;const f=c.uniforms,p=this._sizeLods[i]-1,g=isFinite(s)?Math.PI/(2*p):2*Math.PI/(2*Qi-1),M=s/g,m=isFinite(s)?1+Math.floor(u*M):Qi;m>Qi&&ze(`sigmaRadians, ${s}, is too large and will clip, as it requested ${m} samples when the maximum is set to ${Qi}`);const d=[];let x=0;for(let P=0;P<Qi;++P){const v=P/M,T=Math.exp(-v*v/2);d.push(T),P===0?x+=T:P<m&&(x+=2*T)}for(let P=0;P<d.length;P++)d[P]=d[P]/x;f.envMap.value=e.texture,f.samples.value=m,f.weights.value=d,f.latitudinal.value=o==="latitudinal",a&&(f.poleAxis.value=a);const{_lodMax:y}=this;f.dTheta.value=g,f.mipInt.value=y-i;const S=this._sizeLods[r],C=3*S*(r>y-Di?r-y+Di:0),A=4*(this._cubeSize-S);Tr(t,C,A,3*S,2*S),l.setRenderTarget(t),l.render(h,es)}}function DM(n){const e=[],t=[],i=[];let r=n;const s=n-Di+1+wf.length;for(let o=0;o<s;o++){const a=Math.pow(2,r);e.push(a);let l=1/a;o>n-Di?l=wf[o-n+Di-1]:o===0&&(l=0),t.push(l);const c=1/(a-2),u=-c,h=1+c,f=[u,u,h,u,h,h,u,u,h,h,u,h],p=6,g=6,M=3,m=2,d=1,x=new Float32Array(M*g*p),y=new Float32Array(m*g*p),S=new Float32Array(d*g*p);for(let A=0;A<p;A++){const P=A%3*2/3-1,v=A>2?0:-1,T=[P,v,0,P+2/3,v,0,P+2/3,v+1,0,P,v,0,P+2/3,v+1,0,P,v+1,0];x.set(T,M*g*A),y.set(f,m*g*A);const L=[A,A,A,A,A,A];S.set(L,d*g*A)}const C=new $t;C.setAttribute("position",new Xn(x,M)),C.setAttribute("uv",new Xn(y,m)),C.setAttribute("faceIndex",new Xn(S,d)),i.push(new Pe(C,null)),r>Di&&r--}return{lodMeshes:i,sizeLods:e,sigmas:t}}function Pf(n,e,t){const i=new Wn(n,e,t);return i.texture.mapping=da,i.texture.name="PMREM.cubeUv",i.scissorTest=!0,i}function Tr(n,e,t,i,r){n.viewport.set(e,t,i,r),n.scissor.set(e,t,i,r)}function IM(n,e,t){return new qn({name:"PMREMGGXConvolution",defines:{GGX_SAMPLES:CM,CUBEUV_TEXEL_WIDTH:1/e,CUBEUV_TEXEL_HEIGHT:1/t,CUBEUV_MAX_MIP:`${n}.0`},uniforms:{envMap:{value:null},roughness:{value:0},mipInt:{value:0}},vertexShader:ga(),fragmentShader:`

			precision highp float;
			precision highp int;

			varying vec3 vOutputDirection;

			uniform sampler2D envMap;
			uniform float roughness;
			uniform float mipInt;

			#define ENVMAP_TYPE_CUBE_UV
			#include <cube_uv_reflection_fragment>

			#define PI 3.14159265359

			// Van der Corput radical inverse
			float radicalInverse_VdC(uint bits) {
				bits = (bits << 16u) | (bits >> 16u);
				bits = ((bits & 0x55555555u) << 1u) | ((bits & 0xAAAAAAAAu) >> 1u);
				bits = ((bits & 0x33333333u) << 2u) | ((bits & 0xCCCCCCCCu) >> 2u);
				bits = ((bits & 0x0F0F0F0Fu) << 4u) | ((bits & 0xF0F0F0F0u) >> 4u);
				bits = ((bits & 0x00FF00FFu) << 8u) | ((bits & 0xFF00FF00u) >> 8u);
				return float(bits) * 2.3283064365386963e-10; // / 0x100000000
			}

			// Hammersley sequence
			vec2 hammersley(uint i, uint N) {
				return vec2(float(i) / float(N), radicalInverse_VdC(i));
			}

			// GGX VNDF importance sampling (Eric Heitz 2018)
			// "Sampling the GGX Distribution of Visible Normals"
			// https://jcgt.org/published/0007/04/01/
			vec3 importanceSampleGGX_VNDF(vec2 Xi, vec3 V, float roughness) {
				float alpha = roughness * roughness;

				// Section 4.1: Orthonormal basis
				vec3 T1 = vec3(1.0, 0.0, 0.0);
				vec3 T2 = cross(V, T1);

				// Section 4.2: Parameterization of projected area
				float r = sqrt(Xi.x);
				float phi = 2.0 * PI * Xi.y;
				float t1 = r * cos(phi);
				float t2 = r * sin(phi);
				float s = 0.5 * (1.0 + V.z);
				t2 = (1.0 - s) * sqrt(1.0 - t1 * t1) + s * t2;

				// Section 4.3: Reprojection onto hemisphere
				vec3 Nh = t1 * T1 + t2 * T2 + sqrt(max(0.0, 1.0 - t1 * t1 - t2 * t2)) * V;

				// Section 3.4: Transform back to ellipsoid configuration
				return normalize(vec3(alpha * Nh.x, alpha * Nh.y, max(0.0, Nh.z)));
			}

			void main() {
				vec3 N = normalize(vOutputDirection);
				vec3 V = N; // Assume view direction equals normal for pre-filtering

				vec3 prefilteredColor = vec3(0.0);
				float totalWeight = 0.0;

				// For very low roughness, just sample the environment directly
				if (roughness < 0.001) {
					gl_FragColor = vec4(bilinearCubeUV(envMap, N, mipInt), 1.0);
					return;
				}

				// Tangent space basis for VNDF sampling
				vec3 up = abs(N.z) < 0.999 ? vec3(0.0, 0.0, 1.0) : vec3(1.0, 0.0, 0.0);
				vec3 tangent = normalize(cross(up, N));
				vec3 bitangent = cross(N, tangent);

				for(uint i = 0u; i < uint(GGX_SAMPLES); i++) {
					vec2 Xi = hammersley(i, uint(GGX_SAMPLES));

					// For PMREM, V = N, so in tangent space V is always (0, 0, 1)
					vec3 H_tangent = importanceSampleGGX_VNDF(Xi, vec3(0.0, 0.0, 1.0), roughness);

					// Transform H back to world space
					vec3 H = normalize(tangent * H_tangent.x + bitangent * H_tangent.y + N * H_tangent.z);
					vec3 L = normalize(2.0 * dot(V, H) * H - V);

					float NdotL = max(dot(N, L), 0.0);

					if(NdotL > 0.0) {
						// Sample environment at fixed mip level
						// VNDF importance sampling handles the distribution filtering
						vec3 sampleColor = bilinearCubeUV(envMap, L, mipInt);

						// Weight by NdotL for the split-sum approximation
						// VNDF PDF naturally accounts for the visible microfacet distribution
						prefilteredColor += sampleColor * NdotL;
						totalWeight += NdotL;
					}
				}

				if (totalWeight > 0.0) {
					prefilteredColor = prefilteredColor / totalWeight;
				}

				gl_FragColor = vec4(prefilteredColor, 1.0);
			}
		`,blending:oi,depthTest:!1,depthWrite:!1})}function LM(n,e,t){const i=new Float32Array(Qi),r=new N(0,1,0);return new qn({name:"SphericalGaussianBlur",defines:{n:Qi,CUBEUV_TEXEL_WIDTH:1/e,CUBEUV_TEXEL_HEIGHT:1/t,CUBEUV_MAX_MIP:`${n}.0`},uniforms:{envMap:{value:null},samples:{value:1},weights:{value:i},latitudinal:{value:!1},dTheta:{value:0},mipInt:{value:0},poleAxis:{value:r}},vertexShader:ga(),fragmentShader:`

			precision mediump float;
			precision mediump int;

			varying vec3 vOutputDirection;

			uniform sampler2D envMap;
			uniform int samples;
			uniform float weights[ n ];
			uniform bool latitudinal;
			uniform float dTheta;
			uniform float mipInt;
			uniform vec3 poleAxis;

			#define ENVMAP_TYPE_CUBE_UV
			#include <cube_uv_reflection_fragment>

			vec3 getSample( float theta, vec3 axis ) {

				float cosTheta = cos( theta );
				// Rodrigues' axis-angle rotation
				vec3 sampleDirection = vOutputDirection * cosTheta
					+ cross( axis, vOutputDirection ) * sin( theta )
					+ axis * dot( axis, vOutputDirection ) * ( 1.0 - cosTheta );

				return bilinearCubeUV( envMap, sampleDirection, mipInt );

			}

			void main() {

				vec3 axis = latitudinal ? poleAxis : cross( poleAxis, vOutputDirection );

				if ( all( equal( axis, vec3( 0.0 ) ) ) ) {

					axis = vec3( vOutputDirection.z, 0.0, - vOutputDirection.x );

				}

				axis = normalize( axis );

				gl_FragColor = vec4( 0.0, 0.0, 0.0, 1.0 );
				gl_FragColor.rgb += weights[ 0 ] * getSample( 0.0, axis );

				for ( int i = 1; i < n; i++ ) {

					if ( i >= samples ) {

						break;

					}

					float theta = dTheta * float( i );
					gl_FragColor.rgb += weights[ i ] * getSample( -1.0 * theta, axis );
					gl_FragColor.rgb += weights[ i ] * getSample( theta, axis );

				}

			}
		`,blending:oi,depthTest:!1,depthWrite:!1})}function Df(){return new qn({name:"EquirectangularToCubeUV",uniforms:{envMap:{value:null}},vertexShader:ga(),fragmentShader:`

			precision mediump float;
			precision mediump int;

			varying vec3 vOutputDirection;

			uniform sampler2D envMap;

			#include <common>

			void main() {

				vec3 outputDirection = normalize( vOutputDirection );
				vec2 uv = equirectUv( outputDirection );

				gl_FragColor = vec4( texture2D ( envMap, uv ).rgb, 1.0 );

			}
		`,blending:oi,depthTest:!1,depthWrite:!1})}function If(){return new qn({name:"CubemapToCubeUV",uniforms:{envMap:{value:null},flipEnvMap:{value:-1}},vertexShader:ga(),fragmentShader:`

			precision mediump float;
			precision mediump int;

			uniform float flipEnvMap;

			varying vec3 vOutputDirection;

			uniform samplerCube envMap;

			void main() {

				gl_FragColor = textureCube( envMap, vec3( flipEnvMap * vOutputDirection.x, vOutputDirection.yz ) );

			}
		`,blending:oi,depthTest:!1,depthWrite:!1})}function ga(){return`

		precision mediump float;
		precision mediump int;

		attribute float faceIndex;

		varying vec3 vOutputDirection;

		// RH coordinate system; PMREM face-indexing convention
		vec3 getDirection( vec2 uv, float face ) {

			uv = 2.0 * uv - 1.0;

			vec3 direction = vec3( uv, 1.0 );

			if ( face == 0.0 ) {

				direction = direction.zyx; // ( 1, v, u ) pos x

			} else if ( face == 1.0 ) {

				direction = direction.xzy;
				direction.xz *= -1.0; // ( -u, 1, -v ) pos y

			} else if ( face == 2.0 ) {

				direction.x *= -1.0; // ( -u, v, 1 ) pos z

			} else if ( face == 3.0 ) {

				direction = direction.zyx;
				direction.xz *= -1.0; // ( -1, v, -u ) neg x

			} else if ( face == 4.0 ) {

				direction = direction.xzy;
				direction.xy *= -1.0; // ( -u, -1, v ) neg y

			} else if ( face == 5.0 ) {

				direction.z *= -1.0; // ( u, v, -1 ) neg z

			}

			return direction;

		}

		void main() {

			vOutputDirection = getDirection( uv, faceIndex );
			gl_Position = vec4( position, 1.0 );

		}
	`}class ap extends Wn{constructor(e=1,t={}){super(e,e,t),this.isWebGLCubeRenderTarget=!0;const i={width:e,height:e,depth:1},r=[i,i,i,i,i,i];this.texture=new Qd(r),this._setTextureOptions(t),this.texture.isRenderTargetTexture=!0}fromEquirectangularTexture(e,t){this.texture.type=t.type,this.texture.colorSpace=t.colorSpace,this.texture.generateMipmaps=t.generateMipmaps,this.texture.minFilter=t.minFilter,this.texture.magFilter=t.magFilter;const i={uniforms:{tEquirect:{value:null}},vertexShader:`

				varying vec3 vWorldDirection;

				vec3 transformDirection( in vec3 dir, in mat4 matrix ) {

					return normalize( ( matrix * vec4( dir, 0.0 ) ).xyz );

				}

				void main() {

					vWorldDirection = transformDirection( position, modelMatrix );

					#include <begin_vertex>
					#include <project_vertex>

				}
			`,fragmentShader:`

				uniform sampler2D tEquirect;

				varying vec3 vWorldDirection;

				#include <common>

				void main() {

					vec3 direction = normalize( vWorldDirection );

					vec2 sampleUV = equirectUv( direction );

					gl_FragColor = texture2D( tEquirect, sampleUV );

				}
			`},r=new Ct(5,5,5),s=new qn({name:"CubemapFromEquirect",uniforms:Gr(i.uniforms),vertexShader:i.vertexShader,fragmentShader:i.fragmentShader,side:on,blending:oi});s.uniforms.tEquirect.value=t;const o=new Pe(r,s),a=t.minFilter;return t.minFilter===er&&(t.minFilter=jt),new O0(1,10,this).update(e,o),t.minFilter=a,o.geometry.dispose(),o.material.dispose(),this}clear(e,t=!0,i=!0,r=!0){const s=e.getRenderTarget();for(let o=0;o<6;o++)e.setRenderTarget(this,o),e.clear(t,i,r);e.setRenderTarget(s)}}function UM(n){let e=new WeakMap,t=new WeakMap,i=null;function r(f,p=!1){return f==null?null:p?o(f):s(f)}function s(f){if(f&&f.isTexture){const p=f.mapping;if(p===Ia||p===La)if(e.has(f)){const g=e.get(f).texture;return a(g,f.mapping)}else{const g=f.image;if(g&&g.height>0){const M=new ap(g.height);return M.fromEquirectangularTexture(n,f),e.set(f,M),f.addEventListener("dispose",c),a(M.texture,f.mapping)}else return null}}return f}function o(f){if(f&&f.isTexture){const p=f.mapping,g=p===Ia||p===La,M=p===or||p===Hr;if(g||M){let m=t.get(f);const d=m!==void 0?m.texture.pmremVersion:0;if(f.isRenderTargetTexture&&f.pmremVersion!==d)return i===null&&(i=new Cf(n)),m=g?i.fromEquirectangular(f,m):i.fromCubemap(f,m),m.texture.pmremVersion=f.pmremVersion,t.set(f,m),m.texture;if(m!==void 0)return m.texture;{const x=f.image;return g&&x&&x.height>0||M&&x&&l(x)?(i===null&&(i=new Cf(n)),m=g?i.fromEquirectangular(f):i.fromCubemap(f),m.texture.pmremVersion=f.pmremVersion,t.set(f,m),f.addEventListener("dispose",u),m.texture):null}}}return f}function a(f,p){return p===Ia?f.mapping=or:p===La&&(f.mapping=Hr),f}function l(f){let p=0;const g=6;for(let M=0;M<g;M++)f[M]!==void 0&&p++;return p===g}function c(f){const p=f.target;p.removeEventListener("dispose",c);const g=e.get(p);g!==void 0&&(e.delete(p),g.dispose())}function u(f){const p=f.target;p.removeEventListener("dispose",u);const g=t.get(p);g!==void 0&&(t.delete(p),g.dispose())}function h(){e=new WeakMap,t=new WeakMap,i!==null&&(i.dispose(),i=null)}return{get:r,dispose:h}}function NM(n){const e={};function t(i){if(e[i]!==void 0)return e[i];const r=n.getExtension(i);return e[i]=r,r}return{has:function(i){return t(i)!==null},init:function(){t("EXT_color_buffer_float"),t("WEBGL_clip_cull_distance"),t("OES_texture_float_linear"),t("EXT_color_buffer_half_float"),t("WEBGL_multisampled_render_to_texture"),t("WEBGL_render_shared_exponent")},get:function(i){const r=t(i);return r===null&&pc("WebGLRenderer: "+i+" extension not supported."),r}}}function FM(n,e,t,i){const r={},s=new WeakMap;function o(h){const f=h.target;f.index!==null&&e.remove(f.index);for(const g in f.attributes)e.remove(f.attributes[g]);f.removeEventListener("dispose",o),delete r[f.id];const p=s.get(f);p&&(e.remove(p),s.delete(f)),i.releaseStatesOfGeometry(f),f.isInstancedBufferGeometry===!0&&delete f._maxInstanceCount,t.memory.geometries--}function a(h,f){return r[f.id]===!0||(f.addEventListener("dispose",o),r[f.id]=!0,t.memory.geometries++),f}function l(h){const f=h.attributes;for(const p in f)e.update(f[p],n.ARRAY_BUFFER)}function c(h){const f=[],p=h.index,g=h.attributes.position;let M=0;if(g===void 0)return;if(p!==null){const x=p.array;M=p.version;for(let y=0,S=x.length;y<S;y+=3){const C=x[y+0],A=x[y+1],P=x[y+2];f.push(C,A,A,P,P,C)}}else{const x=g.array;M=g.version;for(let y=0,S=x.length/3-1;y<S;y+=3){const C=y+0,A=y+1,P=y+2;f.push(C,A,A,P,P,C)}}const m=new(g.count>=65535?Zd:jd)(f,1);m.version=M;const d=s.get(h);d&&e.remove(d),s.set(h,m)}function u(h){const f=s.get(h);if(f){const p=h.index;p!==null&&f.version<p.version&&c(h)}else c(h);return s.get(h)}return{get:a,update:l,getWireframeAttribute:u}}function OM(n,e,t){let i;function r(h){i=h}let s,o;function a(h){s=h.type,o=h.bytesPerElement}function l(h,f){n.drawElements(i,f,s,h*o),t.update(f,i,1)}function c(h,f,p){p!==0&&(n.drawElementsInstanced(i,f,s,h*o,p),t.update(f,i,p))}function u(h,f,p){if(p===0)return;e.get("WEBGL_multi_draw").multiDrawElementsWEBGL(i,f,0,s,h,0,p);let M=0;for(let m=0;m<p;m++)M+=f[m];t.update(M,i,1)}this.setMode=r,this.setIndex=a,this.render=l,this.renderInstances=c,this.renderMultiDraw=u}function BM(n){const e={geometries:0,textures:0},t={frame:0,calls:0,triangles:0,points:0,lines:0};function i(s,o,a){switch(t.calls++,o){case n.TRIANGLES:t.triangles+=a*(s/3);break;case n.LINES:t.lines+=a*(s/2);break;case n.LINE_STRIP:t.lines+=a*(s-1);break;case n.LINE_LOOP:t.lines+=a*s;break;case n.POINTS:t.points+=a*s;break;default:et("WebGLInfo: Unknown draw mode:",o);break}}function r(){t.calls=0,t.triangles=0,t.points=0,t.lines=0}return{memory:e,render:t,programs:null,autoReset:!0,reset:r,update:i}}function zM(n,e,t){const i=new WeakMap,r=new At;function s(o,a,l){const c=o.morphTargetInfluences,u=a.morphAttributes.position||a.morphAttributes.normal||a.morphAttributes.color,h=u!==void 0?u.length:0;let f=i.get(a);if(f===void 0||f.count!==h){let T=function(){P.dispose(),i.delete(a),a.removeEventListener("dispose",T)};f!==void 0&&f.texture.dispose();const p=a.morphAttributes.position!==void 0,g=a.morphAttributes.normal!==void 0,M=a.morphAttributes.color!==void 0,m=a.morphAttributes.position||[],d=a.morphAttributes.normal||[],x=a.morphAttributes.color||[];let y=0;p===!0&&(y=1),g===!0&&(y=2),M===!0&&(y=3);let S=a.attributes.position.count*y,C=1;S>e.maxTextureSize&&(C=Math.ceil(S/e.maxTextureSize),S=e.maxTextureSize);const A=new Float32Array(S*C*4*h),P=new qd(A,S,C,h);P.type=Hn,P.needsUpdate=!0;const v=y*4;for(let L=0;L<h;L++){const D=m[L],I=d[L],k=x[L],G=S*C*4*L;for(let O=0;O<D.count;O++){const V=O*v;p===!0&&(r.fromBufferAttribute(D,O),A[G+V+0]=r.x,A[G+V+1]=r.y,A[G+V+2]=r.z,A[G+V+3]=0),g===!0&&(r.fromBufferAttribute(I,O),A[G+V+4]=r.x,A[G+V+5]=r.y,A[G+V+6]=r.z,A[G+V+7]=0),M===!0&&(r.fromBufferAttribute(k,O),A[G+V+8]=r.x,A[G+V+9]=r.y,A[G+V+10]=r.z,A[G+V+11]=k.itemSize===4?r.w:1)}}f={count:h,texture:P,size:new st(S,C)},i.set(a,f),a.addEventListener("dispose",T)}if(o.isInstancedMesh===!0&&o.morphTexture!==null)l.getUniforms().setValue(n,"morphTexture",o.morphTexture,t);else{let p=0;for(let M=0;M<c.length;M++)p+=c[M];const g=a.morphTargetsRelative?1:1-p;l.getUniforms().setValue(n,"morphTargetBaseInfluence",g),l.getUniforms().setValue(n,"morphTargetInfluences",c)}l.getUniforms().setValue(n,"morphTargetsTexture",f.texture,t),l.getUniforms().setValue(n,"morphTargetsTextureSize",f.size)}return{update:s}}function HM(n,e,t,i,r){let s=new WeakMap;function o(c){const u=r.render.frame,h=c.geometry,f=e.get(c,h);if(s.get(f)!==u&&(e.update(f),s.set(f,u)),c.isInstancedMesh&&(c.hasEventListener("dispose",l)===!1&&c.addEventListener("dispose",l),s.get(c)!==u&&(t.update(c.instanceMatrix,n.ARRAY_BUFFER),c.instanceColor!==null&&t.update(c.instanceColor,n.ARRAY_BUFFER),s.set(c,u))),c.isSkinnedMesh){const p=c.skeleton;s.get(p)!==u&&(p.update(),s.set(p,u))}return f}function a(){s=new WeakMap}function l(c){const u=c.target;u.removeEventListener("dispose",l),i.releaseStatesOfObject(u),t.remove(u.instanceMatrix),u.instanceColor!==null&&t.remove(u.instanceColor)}return{update:o,dispose:a}}const VM={[Dd]:"LINEAR_TONE_MAPPING",[Id]:"REINHARD_TONE_MAPPING",[Ld]:"CINEON_TONE_MAPPING",[Ud]:"ACES_FILMIC_TONE_MAPPING",[Fd]:"AGX_TONE_MAPPING",[Od]:"NEUTRAL_TONE_MAPPING",[Nd]:"CUSTOM_TONE_MAPPING"};function GM(n,e,t,i,r){const s=new Wn(e,t,{type:n,depthBuffer:i,stencilBuffer:r,depthTexture:i?new Vr(e,t):void 0}),o=new Wn(e,t,{type:fi,depthBuffer:!1,stencilBuffer:!1}),a=new $t;a.setAttribute("position",new St([-1,3,0,-1,-1,0,3,-1,0],3)),a.setAttribute("uv",new St([0,2,0,0,2,0],2));const l=new L0({uniforms:{tDiffuse:{value:null}},vertexShader:`
			precision highp float;

			uniform mat4 modelViewMatrix;
			uniform mat4 projectionMatrix;

			attribute vec3 position;
			attribute vec2 uv;

			varying vec2 vUv;

			void main() {
				vUv = uv;
				gl_Position = projectionMatrix * modelViewMatrix * vec4( position, 1.0 );
			}`,fragmentShader:`
			precision highp float;

			uniform sampler2D tDiffuse;

			varying vec2 vUv;

			#include <tonemapping_pars_fragment>
			#include <colorspace_pars_fragment>

			void main() {
				gl_FragColor = texture2D( tDiffuse, vUv );

				#ifdef LINEAR_TONE_MAPPING
					gl_FragColor.rgb = LinearToneMapping( gl_FragColor.rgb );
				#elif defined( REINHARD_TONE_MAPPING )
					gl_FragColor.rgb = ReinhardToneMapping( gl_FragColor.rgb );
				#elif defined( CINEON_TONE_MAPPING )
					gl_FragColor.rgb = CineonToneMapping( gl_FragColor.rgb );
				#elif defined( ACES_FILMIC_TONE_MAPPING )
					gl_FragColor.rgb = ACESFilmicToneMapping( gl_FragColor.rgb );
				#elif defined( AGX_TONE_MAPPING )
					gl_FragColor.rgb = AgXToneMapping( gl_FragColor.rgb );
				#elif defined( NEUTRAL_TONE_MAPPING )
					gl_FragColor.rgb = NeutralToneMapping( gl_FragColor.rgb );
				#elif defined( CUSTOM_TONE_MAPPING )
					gl_FragColor.rgb = CustomToneMapping( gl_FragColor.rgb );
				#endif

				#ifdef SRGB_TRANSFER
					gl_FragColor = sRGBTransferOETF( gl_FragColor );
				#endif
			}`,depthTest:!1,depthWrite:!1}),c=new Pe(a,l),u=new ip(-1,1,1,-1,0,1);let h=null,f=null,p=!1,g,M=null,m=[],d=!1;this.setSize=function(x,y){s.setSize(x,y),o.setSize(x,y);for(let S=0;S<m.length;S++){const C=m[S];C.setSize&&C.setSize(x,y)}},this.setEffects=function(x){m=x,d=m.length>0&&m[0].isRenderPass===!0;const y=s.width,S=s.height;for(let C=0;C<m.length;C++){const A=m[C];A.setSize&&A.setSize(y,S)}},this.begin=function(x,y){if(p||x.toneMapping===kn&&m.length===0)return!1;if(M=y,y!==null){const S=y.width,C=y.height;(s.width!==S||s.height!==C)&&this.setSize(S,C)}return d===!1&&x.setRenderTarget(s),g=x.toneMapping,x.toneMapping=kn,!0},this.hasRenderPass=function(){return d},this.end=function(x,y){x.toneMapping=g,p=!0;let S=s,C=o;for(let A=0;A<m.length;A++){const P=m[A];if(P.enabled!==!1&&(P.render(x,C,S,y),P.needsSwap!==!1)){const v=S;S=C,C=v}}if(h!==x.outputColorSpace||f!==x.toneMapping){h=x.outputColorSpace,f=x.toneMapping,l.defines={},Qe.getTransfer(h)===ut&&(l.defines.SRGB_TRANSFER="");const A=VM[f];A&&(l.defines[A]=""),l.needsUpdate=!0}l.uniforms.tDiffuse.value=S.texture,x.setRenderTarget(M),x.render(c,u),M=null,p=!1},this.isCompositing=function(){return p},this.dispose=function(){s.depthTexture&&s.depthTexture.dispose(),s.dispose(),o.dispose(),a.dispose(),l.dispose()}}const lp=new rn,gc=new Vr(1,1),cp=new qd,up=new f0,fp=new Qd,Lf=[],Uf=[],Nf=new Float32Array(16),Ff=new Float32Array(9),Of=new Float32Array(4);function Wr(n,e,t){const i=n[0];if(i<=0||i>0)return n;const r=e*t;let s=Lf[r];if(s===void 0&&(s=new Float32Array(r),Lf[r]=s),e!==0){i.toArray(s,0);for(let o=1,a=0;o!==e;++o)a+=t,n[o].toArray(s,a)}return s}function It(n,e){if(n.length!==e.length)return!1;for(let t=0,i=n.length;t<i;t++)if(n[t]!==e[t])return!1;return!0}function Lt(n,e){for(let t=0,i=e.length;t<i;t++)n[t]=e[t]}function _a(n,e){let t=Uf[e];t===void 0&&(t=new Int32Array(e),Uf[e]=t);for(let i=0;i!==e;++i)t[i]=n.allocateTextureUnit();return t}function kM(n,e){const t=this.cache;t[0]!==e&&(n.uniform1f(this.addr,e),t[0]=e)}function WM(n,e){const t=this.cache;if(e.x!==void 0)(t[0]!==e.x||t[1]!==e.y)&&(n.uniform2f(this.addr,e.x,e.y),t[0]=e.x,t[1]=e.y);else{if(It(t,e))return;n.uniform2fv(this.addr,e),Lt(t,e)}}function XM(n,e){const t=this.cache;if(e.x!==void 0)(t[0]!==e.x||t[1]!==e.y||t[2]!==e.z)&&(n.uniform3f(this.addr,e.x,e.y,e.z),t[0]=e.x,t[1]=e.y,t[2]=e.z);else if(e.r!==void 0)(t[0]!==e.r||t[1]!==e.g||t[2]!==e.b)&&(n.uniform3f(this.addr,e.r,e.g,e.b),t[0]=e.r,t[1]=e.g,t[2]=e.b);else{if(It(t,e))return;n.uniform3fv(this.addr,e),Lt(t,e)}}function YM(n,e){const t=this.cache;if(e.x!==void 0)(t[0]!==e.x||t[1]!==e.y||t[2]!==e.z||t[3]!==e.w)&&(n.uniform4f(this.addr,e.x,e.y,e.z,e.w),t[0]=e.x,t[1]=e.y,t[2]=e.z,t[3]=e.w);else{if(It(t,e))return;n.uniform4fv(this.addr,e),Lt(t,e)}}function qM(n,e){const t=this.cache,i=e.elements;if(i===void 0){if(It(t,e))return;n.uniformMatrix2fv(this.addr,!1,e),Lt(t,e)}else{if(It(t,i))return;Of.set(i),n.uniformMatrix2fv(this.addr,!1,Of),Lt(t,i)}}function KM(n,e){const t=this.cache,i=e.elements;if(i===void 0){if(It(t,e))return;n.uniformMatrix3fv(this.addr,!1,e),Lt(t,e)}else{if(It(t,i))return;Ff.set(i),n.uniformMatrix3fv(this.addr,!1,Ff),Lt(t,i)}}function jM(n,e){const t=this.cache,i=e.elements;if(i===void 0){if(It(t,e))return;n.uniformMatrix4fv(this.addr,!1,e),Lt(t,e)}else{if(It(t,i))return;Nf.set(i),n.uniformMatrix4fv(this.addr,!1,Nf),Lt(t,i)}}function ZM(n,e){const t=this.cache;t[0]!==e&&(n.uniform1i(this.addr,e),t[0]=e)}function $M(n,e){const t=this.cache;if(e.x!==void 0)(t[0]!==e.x||t[1]!==e.y)&&(n.uniform2i(this.addr,e.x,e.y),t[0]=e.x,t[1]=e.y);else{if(It(t,e))return;n.uniform2iv(this.addr,e),Lt(t,e)}}function JM(n,e){const t=this.cache;if(e.x!==void 0)(t[0]!==e.x||t[1]!==e.y||t[2]!==e.z)&&(n.uniform3i(this.addr,e.x,e.y,e.z),t[0]=e.x,t[1]=e.y,t[2]=e.z);else{if(It(t,e))return;n.uniform3iv(this.addr,e),Lt(t,e)}}function QM(n,e){const t=this.cache;if(e.x!==void 0)(t[0]!==e.x||t[1]!==e.y||t[2]!==e.z||t[3]!==e.w)&&(n.uniform4i(this.addr,e.x,e.y,e.z,e.w),t[0]=e.x,t[1]=e.y,t[2]=e.z,t[3]=e.w);else{if(It(t,e))return;n.uniform4iv(this.addr,e),Lt(t,e)}}function eS(n,e){const t=this.cache;t[0]!==e&&(n.uniform1ui(this.addr,e),t[0]=e)}function tS(n,e){const t=this.cache;if(e.x!==void 0)(t[0]!==e.x||t[1]!==e.y)&&(n.uniform2ui(this.addr,e.x,e.y),t[0]=e.x,t[1]=e.y);else{if(It(t,e))return;n.uniform2uiv(this.addr,e),Lt(t,e)}}function nS(n,e){const t=this.cache;if(e.x!==void 0)(t[0]!==e.x||t[1]!==e.y||t[2]!==e.z)&&(n.uniform3ui(this.addr,e.x,e.y,e.z),t[0]=e.x,t[1]=e.y,t[2]=e.z);else{if(It(t,e))return;n.uniform3uiv(this.addr,e),Lt(t,e)}}function iS(n,e){const t=this.cache;if(e.x!==void 0)(t[0]!==e.x||t[1]!==e.y||t[2]!==e.z||t[3]!==e.w)&&(n.uniform4ui(this.addr,e.x,e.y,e.z,e.w),t[0]=e.x,t[1]=e.y,t[2]=e.z,t[3]=e.w);else{if(It(t,e))return;n.uniform4uiv(this.addr,e),Lt(t,e)}}function rS(n,e,t){const i=this.cache,r=t.allocateTextureUnit();i[0]!==r&&(n.uniform1i(this.addr,r),i[0]=r);let s;this.type===n.SAMPLER_2D_SHADOW?(gc.compareFunction=t.isReversedDepthBuffer()?Xc:Wc,s=gc):s=lp,t.setTexture2D(e||s,r)}function sS(n,e,t){const i=this.cache,r=t.allocateTextureUnit();i[0]!==r&&(n.uniform1i(this.addr,r),i[0]=r),t.setTexture3D(e||up,r)}function oS(n,e,t){const i=this.cache,r=t.allocateTextureUnit();i[0]!==r&&(n.uniform1i(this.addr,r),i[0]=r),t.setTextureCube(e||fp,r)}function aS(n,e,t){const i=this.cache,r=t.allocateTextureUnit();i[0]!==r&&(n.uniform1i(this.addr,r),i[0]=r),t.setTexture2DArray(e||cp,r)}function lS(n){switch(n){case 5126:return kM;case 35664:return WM;case 35665:return XM;case 35666:return YM;case 35674:return qM;case 35675:return KM;case 35676:return jM;case 5124:case 35670:return ZM;case 35667:case 35671:return $M;case 35668:case 35672:return JM;case 35669:case 35673:return QM;case 5125:return eS;case 36294:return tS;case 36295:return nS;case 36296:return iS;case 35678:case 36198:case 36298:case 36306:case 35682:return rS;case 35679:case 36299:case 36307:return sS;case 35680:case 36300:case 36308:case 36293:return oS;case 36289:case 36303:case 36311:case 36292:return aS}}function cS(n,e){n.uniform1fv(this.addr,e)}function uS(n,e){const t=Wr(e,this.size,2);n.uniform2fv(this.addr,t)}function fS(n,e){const t=Wr(e,this.size,3);n.uniform3fv(this.addr,t)}function hS(n,e){const t=Wr(e,this.size,4);n.uniform4fv(this.addr,t)}function dS(n,e){const t=Wr(e,this.size,4);n.uniformMatrix2fv(this.addr,!1,t)}function pS(n,e){const t=Wr(e,this.size,9);n.uniformMatrix3fv(this.addr,!1,t)}function mS(n,e){const t=Wr(e,this.size,16);n.uniformMatrix4fv(this.addr,!1,t)}function gS(n,e){n.uniform1iv(this.addr,e)}function _S(n,e){n.uniform2iv(this.addr,e)}function xS(n,e){n.uniform3iv(this.addr,e)}function vS(n,e){n.uniform4iv(this.addr,e)}function MS(n,e){n.uniform1uiv(this.addr,e)}function SS(n,e){n.uniform2uiv(this.addr,e)}function ES(n,e){n.uniform3uiv(this.addr,e)}function yS(n,e){n.uniform4uiv(this.addr,e)}function bS(n,e,t){const i=this.cache,r=e.length,s=_a(t,r);It(i,s)||(n.uniform1iv(this.addr,s),Lt(i,s));let o;this.type===n.SAMPLER_2D_SHADOW?o=gc:o=lp;for(let a=0;a!==r;++a)t.setTexture2D(e[a]||o,s[a])}function TS(n,e,t){const i=this.cache,r=e.length,s=_a(t,r);It(i,s)||(n.uniform1iv(this.addr,s),Lt(i,s));for(let o=0;o!==r;++o)t.setTexture3D(e[o]||up,s[o])}function AS(n,e,t){const i=this.cache,r=e.length,s=_a(t,r);It(i,s)||(n.uniform1iv(this.addr,s),Lt(i,s));for(let o=0;o!==r;++o)t.setTextureCube(e[o]||fp,s[o])}function wS(n,e,t){const i=this.cache,r=e.length,s=_a(t,r);It(i,s)||(n.uniform1iv(this.addr,s),Lt(i,s));for(let o=0;o!==r;++o)t.setTexture2DArray(e[o]||cp,s[o])}function RS(n){switch(n){case 5126:return cS;case 35664:return uS;case 35665:return fS;case 35666:return hS;case 35674:return dS;case 35675:return pS;case 35676:return mS;case 5124:case 35670:return gS;case 35667:case 35671:return _S;case 35668:case 35672:return xS;case 35669:case 35673:return vS;case 5125:return MS;case 36294:return SS;case 36295:return ES;case 36296:return yS;case 35678:case 36198:case 36298:case 36306:case 35682:return bS;case 35679:case 36299:case 36307:return TS;case 35680:case 36300:case 36308:case 36293:return AS;case 36289:case 36303:case 36311:case 36292:return wS}}class CS{constructor(e,t,i){this.id=e,this.addr=i,this.cache=[],this.type=t.type,this.setValue=lS(t.type)}}class PS{constructor(e,t,i){this.id=e,this.addr=i,this.cache=[],this.type=t.type,this.size=t.size,this.setValue=RS(t.type)}}class DS{constructor(e){this.id=e,this.seq=[],this.map={}}setValue(e,t,i){const r=this.seq;for(let s=0,o=r.length;s!==o;++s){const a=r[s];a.setValue(e,t[a.id],i)}}}const ll=/(\w+)(\])?(\[|\.)?/g;function Bf(n,e){n.seq.push(e),n.map[e.id]=e}function IS(n,e,t){const i=n.name,r=i.length;for(ll.lastIndex=0;;){const s=ll.exec(i),o=ll.lastIndex;let a=s[1];const l=s[2]==="]",c=s[3];if(l&&(a=a|0),c===void 0||c==="["&&o+2===r){Bf(t,c===void 0?new CS(a,n,e):new PS(a,n,e));break}else{let h=t.map[a];h===void 0&&(h=new DS(a),Bf(t,h)),t=h}}}class Co{constructor(e,t){this.seq=[],this.map={};const i=e.getProgramParameter(t,e.ACTIVE_UNIFORMS);for(let o=0;o<i;++o){const a=e.getActiveUniform(t,o),l=e.getUniformLocation(t,a.name);IS(a,l,this)}const r=[],s=[];for(const o of this.seq)o.type===e.SAMPLER_2D_SHADOW||o.type===e.SAMPLER_CUBE_SHADOW||o.type===e.SAMPLER_2D_ARRAY_SHADOW?r.push(o):s.push(o);r.length>0&&(this.seq=r.concat(s))}setValue(e,t,i,r){const s=this.map[t];s!==void 0&&s.setValue(e,i,r)}setOptional(e,t,i){const r=t[i];r!==void 0&&this.setValue(e,i,r)}static upload(e,t,i,r){for(let s=0,o=t.length;s!==o;++s){const a=t[s],l=i[a.id];l.needsUpdate!==!1&&a.setValue(e,l.value,r)}}static seqWithValue(e,t){const i=[];for(let r=0,s=e.length;r!==s;++r){const o=e[r];o.id in t&&i.push(o)}return i}}function zf(n,e,t){const i=n.createShader(e);return n.shaderSource(i,t),n.compileShader(i),i}const LS=37297;let US=0;function NS(n,e){const t=n.split(`
`),i=[],r=Math.max(e-6,0),s=Math.min(e+6,t.length);for(let o=r;o<s;o++){const a=o+1;i.push(`${a===e?">":" "} ${a}: ${t[o]}`)}return i.join(`
`)}const Hf=new Xe;function FS(n){Qe._getMatrix(Hf,Qe.workingColorSpace,n);const e=`mat3( ${Hf.elements.map(t=>t.toFixed(4))} )`;switch(Qe.getTransfer(n)){case Yo:return[e,"LinearTransferOETF"];case ut:return[e,"sRGBTransferOETF"];default:return ze("WebGLProgram: Unsupported color space: ",n),[e,"LinearTransferOETF"]}}function Vf(n,e,t){const i=n.getShaderParameter(e,n.COMPILE_STATUS),s=(n.getShaderInfoLog(e)||"").trim();if(i&&s==="")return"";const o=/ERROR: 0:(\d+)/.exec(s);if(o){const a=parseInt(o[1]);return t.toUpperCase()+`

`+s+`

`+NS(n.getShaderSource(e),a)}else return s}function OS(n,e){const t=FS(e);return[`vec4 ${n}( vec4 value ) {`,`	return ${t[1]}( vec4( value.rgb * ${t[0]}, value.a ) );`,"}"].join(`
`)}const BS={[Dd]:"Linear",[Id]:"Reinhard",[Ld]:"Cineon",[Ud]:"ACESFilmic",[Fd]:"AgX",[Od]:"Neutral",[Nd]:"Custom"};function zS(n,e){const t=BS[e];return t===void 0?(ze("WebGLProgram: Unsupported toneMapping:",e),"vec3 "+n+"( vec3 color ) { return LinearToneMapping( color ); }"):"vec3 "+n+"( vec3 color ) { return "+t+"ToneMapping( color ); }"}const mo=new N;function HS(){Qe.getLuminanceCoefficients(mo);const n=mo.x.toFixed(4),e=mo.y.toFixed(4),t=mo.z.toFixed(4);return["float luminance( const in vec3 rgb ) {",`	const vec3 weights = vec3( ${n}, ${e}, ${t} );`,"	return dot( weights, rgb );","}"].join(`
`)}function VS(n){return[n.extensionClipCullDistance?"#extension GL_ANGLE_clip_cull_distance : require":"",n.extensionMultiDraw?"#extension GL_ANGLE_multi_draw : require":""].filter(ls).join(`
`)}function GS(n){const e=[];for(const t in n){const i=n[t];i!==!1&&e.push("#define "+t+" "+i)}return e.join(`
`)}function kS(n,e){const t={},i=n.getProgramParameter(e,n.ACTIVE_ATTRIBUTES);for(let r=0;r<i;r++){const s=n.getActiveAttrib(e,r),o=s.name;let a=1;s.type===n.FLOAT_MAT2&&(a=2),s.type===n.FLOAT_MAT3&&(a=3),s.type===n.FLOAT_MAT4&&(a=4),t[o]={type:s.type,location:n.getAttribLocation(e,o),locationSize:a}}return t}function ls(n){return n!==""}function Gf(n,e){const t=e.numSpotLightShadows+e.numSpotLightMaps-e.numSpotLightShadowsWithMaps;return n.replace(/NUM_DIR_LIGHTS/g,e.numDirLights).replace(/NUM_SPOT_LIGHTS/g,e.numSpotLights).replace(/NUM_SPOT_LIGHT_MAPS/g,e.numSpotLightMaps).replace(/NUM_SPOT_LIGHT_COORDS/g,t).replace(/NUM_RECT_AREA_LIGHTS/g,e.numRectAreaLights).replace(/NUM_POINT_LIGHTS/g,e.numPointLights).replace(/NUM_HEMI_LIGHTS/g,e.numHemiLights).replace(/NUM_DIR_LIGHT_SHADOWS/g,e.numDirLightShadows).replace(/NUM_SPOT_LIGHT_SHADOWS_WITH_MAPS/g,e.numSpotLightShadowsWithMaps).replace(/NUM_SPOT_LIGHT_SHADOWS/g,e.numSpotLightShadows).replace(/NUM_POINT_LIGHT_SHADOWS/g,e.numPointLightShadows)}function kf(n,e){return n.replace(/NUM_CLIPPING_PLANES/g,e.numClippingPlanes).replace(/UNION_CLIPPING_PLANES/g,e.numClippingPlanes-e.numClipIntersection)}const WS=/^[ \t]*#include +<([\w\d./]+)>/gm;function _c(n){return n.replace(WS,YS)}const XS=new Map;function YS(n,e){let t=je[e];if(t===void 0){const i=XS.get(e);if(i!==void 0)t=je[i],ze('WebGLRenderer: Shader chunk "%s" has been deprecated. Use "%s" instead.',e,i);else throw new Error("Can not resolve #include <"+e+">")}return _c(t)}const qS=/#pragma unroll_loop_start\s+for\s*\(\s*int\s+i\s*=\s*(\d+)\s*;\s*i\s*<\s*(\d+)\s*;\s*i\s*\+\+\s*\)\s*{([\s\S]+?)}\s+#pragma unroll_loop_end/g;function Wf(n){return n.replace(qS,KS)}function KS(n,e,t,i){let r="";for(let s=parseInt(e);s<parseInt(t);s++)r+=i.replace(/\[\s*i\s*\]/g,"[ "+s+" ]").replace(/UNROLLED_LOOP_INDEX/g,s);return r}function Xf(n){let e=`precision ${n.precision} float;
	precision ${n.precision} int;
	precision ${n.precision} sampler2D;
	precision ${n.precision} samplerCube;
	precision ${n.precision} sampler3D;
	precision ${n.precision} sampler2DArray;
	precision ${n.precision} sampler2DShadow;
	precision ${n.precision} samplerCubeShadow;
	precision ${n.precision} sampler2DArrayShadow;
	precision ${n.precision} isampler2D;
	precision ${n.precision} isampler3D;
	precision ${n.precision} isamplerCube;
	precision ${n.precision} isampler2DArray;
	precision ${n.precision} usampler2D;
	precision ${n.precision} usampler3D;
	precision ${n.precision} usamplerCube;
	precision ${n.precision} usampler2DArray;
	`;return n.precision==="highp"?e+=`
#define HIGH_PRECISION`:n.precision==="mediump"?e+=`
#define MEDIUM_PRECISION`:n.precision==="lowp"&&(e+=`
#define LOW_PRECISION`),e}const jS={[bo]:"SHADOWMAP_TYPE_PCF",[as]:"SHADOWMAP_TYPE_VSM"};function ZS(n){return jS[n.shadowMapType]||"SHADOWMAP_TYPE_BASIC"}const $S={[or]:"ENVMAP_TYPE_CUBE",[Hr]:"ENVMAP_TYPE_CUBE",[da]:"ENVMAP_TYPE_CUBE_UV"};function JS(n){return n.envMap===!1?"ENVMAP_TYPE_CUBE":$S[n.envMapMode]||"ENVMAP_TYPE_CUBE"}const QS={[Hr]:"ENVMAP_MODE_REFRACTION"};function eE(n){return n.envMap===!1?"ENVMAP_MODE_REFLECTION":QS[n.envMapMode]||"ENVMAP_MODE_REFLECTION"}const tE={[Pd]:"ENVMAP_BLENDING_MULTIPLY",[C_]:"ENVMAP_BLENDING_MIX",[P_]:"ENVMAP_BLENDING_ADD"};function nE(n){return n.envMap===!1?"ENVMAP_BLENDING_NONE":tE[n.combine]||"ENVMAP_BLENDING_NONE"}function iE(n){const e=n.envMapCubeUVHeight;if(e===null)return null;const t=Math.log2(e)-2,i=1/e;return{texelWidth:1/(3*Math.max(Math.pow(2,t),112)),texelHeight:i,maxMip:t}}function rE(n,e,t,i){const r=n.getContext(),s=t.defines;let o=t.vertexShader,a=t.fragmentShader;const l=ZS(t),c=JS(t),u=eE(t),h=nE(t),f=iE(t),p=VS(t),g=GS(s),M=r.createProgram();let m,d,x=t.glslVersion?"#version "+t.glslVersion+`
`:"";t.isRawShaderMaterial?(m=["#define SHADER_TYPE "+t.shaderType,"#define SHADER_NAME "+t.shaderName,g].filter(ls).join(`
`),m.length>0&&(m+=`
`),d=["#define SHADER_TYPE "+t.shaderType,"#define SHADER_NAME "+t.shaderName,g].filter(ls).join(`
`),d.length>0&&(d+=`
`)):(m=[Xf(t),"#define SHADER_TYPE "+t.shaderType,"#define SHADER_NAME "+t.shaderName,g,t.extensionClipCullDistance?"#define USE_CLIP_DISTANCE":"",t.batching?"#define USE_BATCHING":"",t.batchingColor?"#define USE_BATCHING_COLOR":"",t.instancing?"#define USE_INSTANCING":"",t.instancingColor?"#define USE_INSTANCING_COLOR":"",t.instancingMorph?"#define USE_INSTANCING_MORPH":"",t.useFog&&t.fog?"#define USE_FOG":"",t.useFog&&t.fogExp2?"#define FOG_EXP2":"",t.map?"#define USE_MAP":"",t.envMap?"#define USE_ENVMAP":"",t.envMap?"#define "+u:"",t.lightMap?"#define USE_LIGHTMAP":"",t.aoMap?"#define USE_AOMAP":"",t.bumpMap?"#define USE_BUMPMAP":"",t.normalMap?"#define USE_NORMALMAP":"",t.normalMapObjectSpace?"#define USE_NORMALMAP_OBJECTSPACE":"",t.normalMapTangentSpace?"#define USE_NORMALMAP_TANGENTSPACE":"",t.displacementMap?"#define USE_DISPLACEMENTMAP":"",t.emissiveMap?"#define USE_EMISSIVEMAP":"",t.anisotropy?"#define USE_ANISOTROPY":"",t.anisotropyMap?"#define USE_ANISOTROPYMAP":"",t.clearcoatMap?"#define USE_CLEARCOATMAP":"",t.clearcoatRoughnessMap?"#define USE_CLEARCOAT_ROUGHNESSMAP":"",t.clearcoatNormalMap?"#define USE_CLEARCOAT_NORMALMAP":"",t.iridescenceMap?"#define USE_IRIDESCENCEMAP":"",t.iridescenceThicknessMap?"#define USE_IRIDESCENCE_THICKNESSMAP":"",t.specularMap?"#define USE_SPECULARMAP":"",t.specularColorMap?"#define USE_SPECULAR_COLORMAP":"",t.specularIntensityMap?"#define USE_SPECULAR_INTENSITYMAP":"",t.roughnessMap?"#define USE_ROUGHNESSMAP":"",t.metalnessMap?"#define USE_METALNESSMAP":"",t.alphaMap?"#define USE_ALPHAMAP":"",t.alphaHash?"#define USE_ALPHAHASH":"",t.transmission?"#define USE_TRANSMISSION":"",t.transmissionMap?"#define USE_TRANSMISSIONMAP":"",t.thicknessMap?"#define USE_THICKNESSMAP":"",t.sheenColorMap?"#define USE_SHEEN_COLORMAP":"",t.sheenRoughnessMap?"#define USE_SHEEN_ROUGHNESSMAP":"",t.mapUv?"#define MAP_UV "+t.mapUv:"",t.alphaMapUv?"#define ALPHAMAP_UV "+t.alphaMapUv:"",t.lightMapUv?"#define LIGHTMAP_UV "+t.lightMapUv:"",t.aoMapUv?"#define AOMAP_UV "+t.aoMapUv:"",t.emissiveMapUv?"#define EMISSIVEMAP_UV "+t.emissiveMapUv:"",t.bumpMapUv?"#define BUMPMAP_UV "+t.bumpMapUv:"",t.normalMapUv?"#define NORMALMAP_UV "+t.normalMapUv:"",t.displacementMapUv?"#define DISPLACEMENTMAP_UV "+t.displacementMapUv:"",t.metalnessMapUv?"#define METALNESSMAP_UV "+t.metalnessMapUv:"",t.roughnessMapUv?"#define ROUGHNESSMAP_UV "+t.roughnessMapUv:"",t.anisotropyMapUv?"#define ANISOTROPYMAP_UV "+t.anisotropyMapUv:"",t.clearcoatMapUv?"#define CLEARCOATMAP_UV "+t.clearcoatMapUv:"",t.clearcoatNormalMapUv?"#define CLEARCOAT_NORMALMAP_UV "+t.clearcoatNormalMapUv:"",t.clearcoatRoughnessMapUv?"#define CLEARCOAT_ROUGHNESSMAP_UV "+t.clearcoatRoughnessMapUv:"",t.iridescenceMapUv?"#define IRIDESCENCEMAP_UV "+t.iridescenceMapUv:"",t.iridescenceThicknessMapUv?"#define IRIDESCENCE_THICKNESSMAP_UV "+t.iridescenceThicknessMapUv:"",t.sheenColorMapUv?"#define SHEEN_COLORMAP_UV "+t.sheenColorMapUv:"",t.sheenRoughnessMapUv?"#define SHEEN_ROUGHNESSMAP_UV "+t.sheenRoughnessMapUv:"",t.specularMapUv?"#define SPECULARMAP_UV "+t.specularMapUv:"",t.specularColorMapUv?"#define SPECULAR_COLORMAP_UV "+t.specularColorMapUv:"",t.specularIntensityMapUv?"#define SPECULAR_INTENSITYMAP_UV "+t.specularIntensityMapUv:"",t.transmissionMapUv?"#define TRANSMISSIONMAP_UV "+t.transmissionMapUv:"",t.thicknessMapUv?"#define THICKNESSMAP_UV "+t.thicknessMapUv:"",t.vertexTangents&&t.flatShading===!1?"#define USE_TANGENT":"",t.vertexNormals?"#define HAS_NORMAL":"",t.vertexColors?"#define USE_COLOR":"",t.vertexAlphas?"#define USE_COLOR_ALPHA":"",t.vertexUv1s?"#define USE_UV1":"",t.vertexUv2s?"#define USE_UV2":"",t.vertexUv3s?"#define USE_UV3":"",t.pointsUvs?"#define USE_POINTS_UV":"",t.flatShading?"#define FLAT_SHADED":"",t.skinning?"#define USE_SKINNING":"",t.morphTargets?"#define USE_MORPHTARGETS":"",t.morphNormals&&t.flatShading===!1?"#define USE_MORPHNORMALS":"",t.morphColors?"#define USE_MORPHCOLORS":"",t.morphTargetsCount>0?"#define MORPHTARGETS_TEXTURE_STRIDE "+t.morphTextureStride:"",t.morphTargetsCount>0?"#define MORPHTARGETS_COUNT "+t.morphTargetsCount:"",t.doubleSided?"#define DOUBLE_SIDED":"",t.flipSided?"#define FLIP_SIDED":"",t.shadowMapEnabled?"#define USE_SHADOWMAP":"",t.shadowMapEnabled?"#define "+l:"",t.sizeAttenuation?"#define USE_SIZEATTENUATION":"",t.numLightProbes>0?"#define USE_LIGHT_PROBES":"",t.logarithmicDepthBuffer?"#define USE_LOGARITHMIC_DEPTH_BUFFER":"",t.reversedDepthBuffer?"#define USE_REVERSED_DEPTH_BUFFER":"","uniform mat4 modelMatrix;","uniform mat4 modelViewMatrix;","uniform mat4 projectionMatrix;","uniform mat4 viewMatrix;","uniform mat3 normalMatrix;","uniform vec3 cameraPosition;","uniform bool isOrthographic;","#ifdef USE_INSTANCING","	attribute mat4 instanceMatrix;","#endif","#ifdef USE_INSTANCING_COLOR","	attribute vec3 instanceColor;","#endif","#ifdef USE_INSTANCING_MORPH","	uniform sampler2D morphTexture;","#endif","attribute vec3 position;","attribute vec3 normal;","attribute vec2 uv;","#ifdef USE_UV1","	attribute vec2 uv1;","#endif","#ifdef USE_UV2","	attribute vec2 uv2;","#endif","#ifdef USE_UV3","	attribute vec2 uv3;","#endif","#ifdef USE_TANGENT","	attribute vec4 tangent;","#endif","#if defined( USE_COLOR_ALPHA )","	attribute vec4 color;","#elif defined( USE_COLOR )","	attribute vec3 color;","#endif","#ifdef USE_SKINNING","	attribute vec4 skinIndex;","	attribute vec4 skinWeight;","#endif",`
`].filter(ls).join(`
`),d=[Xf(t),"#define SHADER_TYPE "+t.shaderType,"#define SHADER_NAME "+t.shaderName,g,t.useFog&&t.fog?"#define USE_FOG":"",t.useFog&&t.fogExp2?"#define FOG_EXP2":"",t.alphaToCoverage?"#define ALPHA_TO_COVERAGE":"",t.map?"#define USE_MAP":"",t.matcap?"#define USE_MATCAP":"",t.envMap?"#define USE_ENVMAP":"",t.envMap?"#define "+c:"",t.envMap?"#define "+u:"",t.envMap?"#define "+h:"",f?"#define CUBEUV_TEXEL_WIDTH "+f.texelWidth:"",f?"#define CUBEUV_TEXEL_HEIGHT "+f.texelHeight:"",f?"#define CUBEUV_MAX_MIP "+f.maxMip+".0":"",t.lightMap?"#define USE_LIGHTMAP":"",t.aoMap?"#define USE_AOMAP":"",t.bumpMap?"#define USE_BUMPMAP":"",t.normalMap?"#define USE_NORMALMAP":"",t.normalMapObjectSpace?"#define USE_NORMALMAP_OBJECTSPACE":"",t.normalMapTangentSpace?"#define USE_NORMALMAP_TANGENTSPACE":"",t.packedNormalMap?"#define USE_PACKED_NORMALMAP":"",t.emissiveMap?"#define USE_EMISSIVEMAP":"",t.anisotropy?"#define USE_ANISOTROPY":"",t.anisotropyMap?"#define USE_ANISOTROPYMAP":"",t.clearcoat?"#define USE_CLEARCOAT":"",t.clearcoatMap?"#define USE_CLEARCOATMAP":"",t.clearcoatRoughnessMap?"#define USE_CLEARCOAT_ROUGHNESSMAP":"",t.clearcoatNormalMap?"#define USE_CLEARCOAT_NORMALMAP":"",t.dispersion?"#define USE_DISPERSION":"",t.iridescence?"#define USE_IRIDESCENCE":"",t.iridescenceMap?"#define USE_IRIDESCENCEMAP":"",t.iridescenceThicknessMap?"#define USE_IRIDESCENCE_THICKNESSMAP":"",t.specularMap?"#define USE_SPECULARMAP":"",t.specularColorMap?"#define USE_SPECULAR_COLORMAP":"",t.specularIntensityMap?"#define USE_SPECULAR_INTENSITYMAP":"",t.roughnessMap?"#define USE_ROUGHNESSMAP":"",t.metalnessMap?"#define USE_METALNESSMAP":"",t.alphaMap?"#define USE_ALPHAMAP":"",t.alphaTest?"#define USE_ALPHATEST":"",t.alphaHash?"#define USE_ALPHAHASH":"",t.sheen?"#define USE_SHEEN":"",t.sheenColorMap?"#define USE_SHEEN_COLORMAP":"",t.sheenRoughnessMap?"#define USE_SHEEN_ROUGHNESSMAP":"",t.transmission?"#define USE_TRANSMISSION":"",t.transmissionMap?"#define USE_TRANSMISSIONMAP":"",t.thicknessMap?"#define USE_THICKNESSMAP":"",t.vertexTangents&&t.flatShading===!1?"#define USE_TANGENT":"",t.vertexColors||t.instancingColor?"#define USE_COLOR":"",t.vertexAlphas||t.batchingColor?"#define USE_COLOR_ALPHA":"",t.vertexUv1s?"#define USE_UV1":"",t.vertexUv2s?"#define USE_UV2":"",t.vertexUv3s?"#define USE_UV3":"",t.pointsUvs?"#define USE_POINTS_UV":"",t.gradientMap?"#define USE_GRADIENTMAP":"",t.flatShading?"#define FLAT_SHADED":"",t.doubleSided?"#define DOUBLE_SIDED":"",t.flipSided?"#define FLIP_SIDED":"",t.shadowMapEnabled?"#define USE_SHADOWMAP":"",t.shadowMapEnabled?"#define "+l:"",t.premultipliedAlpha?"#define PREMULTIPLIED_ALPHA":"",t.numLightProbes>0?"#define USE_LIGHT_PROBES":"",t.numLightProbeGrids>0?"#define USE_LIGHT_PROBES_GRID":"",t.decodeVideoTexture?"#define DECODE_VIDEO_TEXTURE":"",t.decodeVideoTextureEmissive?"#define DECODE_VIDEO_TEXTURE_EMISSIVE":"",t.logarithmicDepthBuffer?"#define USE_LOGARITHMIC_DEPTH_BUFFER":"",t.reversedDepthBuffer?"#define USE_REVERSED_DEPTH_BUFFER":"","uniform mat4 viewMatrix;","uniform vec3 cameraPosition;","uniform bool isOrthographic;",t.toneMapping!==kn?"#define TONE_MAPPING":"",t.toneMapping!==kn?je.tonemapping_pars_fragment:"",t.toneMapping!==kn?zS("toneMapping",t.toneMapping):"",t.dithering?"#define DITHERING":"",t.opaque?"#define OPAQUE":"",je.colorspace_pars_fragment,OS("linearToOutputTexel",t.outputColorSpace),HS(),t.useDepthPacking?"#define DEPTH_PACKING "+t.depthPacking:"",`
`].filter(ls).join(`
`)),o=_c(o),o=Gf(o,t),o=kf(o,t),a=_c(a),a=Gf(a,t),a=kf(a,t),o=Wf(o),a=Wf(a),t.isRawShaderMaterial!==!0&&(x=`#version 300 es
`,m=[p,"#define attribute in","#define varying out","#define texture2D texture"].join(`
`)+`
`+m,d=["#define varying in",t.glslVersion===ef?"":"layout(location = 0) out highp vec4 pc_fragColor;",t.glslVersion===ef?"":"#define gl_FragColor pc_fragColor","#define gl_FragDepthEXT gl_FragDepth","#define texture2D texture","#define textureCube texture","#define texture2DProj textureProj","#define texture2DLodEXT textureLod","#define texture2DProjLodEXT textureProjLod","#define textureCubeLodEXT textureLod","#define texture2DGradEXT textureGrad","#define texture2DProjGradEXT textureProjGrad","#define textureCubeGradEXT textureGrad"].join(`
`)+`
`+d);const y=x+m+o,S=x+d+a,C=zf(r,r.VERTEX_SHADER,y),A=zf(r,r.FRAGMENT_SHADER,S);r.attachShader(M,C),r.attachShader(M,A),t.index0AttributeName!==void 0?r.bindAttribLocation(M,0,t.index0AttributeName):t.morphTargets===!0&&r.bindAttribLocation(M,0,"position"),r.linkProgram(M);function P(D){if(n.debug.checkShaderErrors){const I=r.getProgramInfoLog(M)||"",k=r.getShaderInfoLog(C)||"",G=r.getShaderInfoLog(A)||"",O=I.trim(),V=k.trim(),H=G.trim();let $=!0,oe=!0;if(r.getProgramParameter(M,r.LINK_STATUS)===!1)if($=!1,typeof n.debug.onShaderError=="function")n.debug.onShaderError(r,M,C,A);else{const ve=Vf(r,C,"vertex"),be=Vf(r,A,"fragment");et("THREE.WebGLProgram: Shader Error "+r.getError()+" - VALIDATE_STATUS "+r.getProgramParameter(M,r.VALIDATE_STATUS)+`

Material Name: `+D.name+`
Material Type: `+D.type+`

Program Info Log: `+O+`
`+ve+`
`+be)}else O!==""?ze("WebGLProgram: Program Info Log:",O):(V===""||H==="")&&(oe=!1);oe&&(D.diagnostics={runnable:$,programLog:O,vertexShader:{log:V,prefix:m},fragmentShader:{log:H,prefix:d}})}r.deleteShader(C),r.deleteShader(A),v=new Co(r,M),T=kS(r,M)}let v;this.getUniforms=function(){return v===void 0&&P(this),v};let T;this.getAttributes=function(){return T===void 0&&P(this),T};let L=t.rendererExtensionParallelShaderCompile===!1;return this.isReady=function(){return L===!1&&(L=r.getProgramParameter(M,LS)),L},this.destroy=function(){i.releaseStatesOfProgram(this),r.deleteProgram(M),this.program=void 0},this.type=t.shaderType,this.name=t.shaderName,this.id=US++,this.cacheKey=e,this.usedTimes=1,this.program=M,this.vertexShader=C,this.fragmentShader=A,this}let sE=0;class oE{constructor(){this.shaderCache=new Map,this.materialCache=new Map}update(e){const t=e.vertexShader,i=e.fragmentShader,r=this._getShaderStage(t),s=this._getShaderStage(i),o=this._getShaderCacheForMaterial(e);return o.has(r)===!1&&(o.add(r),r.usedTimes++),o.has(s)===!1&&(o.add(s),s.usedTimes++),this}remove(e){const t=this.materialCache.get(e);for(const i of t)i.usedTimes--,i.usedTimes===0&&this.shaderCache.delete(i.code);return this.materialCache.delete(e),this}getVertexShaderID(e){return this._getShaderStage(e.vertexShader).id}getFragmentShaderID(e){return this._getShaderStage(e.fragmentShader).id}dispose(){this.shaderCache.clear(),this.materialCache.clear()}_getShaderCacheForMaterial(e){const t=this.materialCache;let i=t.get(e);return i===void 0&&(i=new Set,t.set(e,i)),i}_getShaderStage(e){const t=this.shaderCache;let i=t.get(e);return i===void 0&&(i=new aE(e),t.set(e,i)),i}}class aE{constructor(e){this.id=sE++,this.code=e,this.usedTimes=0}}function lE(n){return n===ar||n===ko||n===Wo}function cE(n,e,t,i,r,s){const o=new Kc,a=new oE,l=new Set,c=[],u=new Map,h=i.logarithmicDepthBuffer;let f=i.precision;const p={MeshDepthMaterial:"depth",MeshDistanceMaterial:"distance",MeshNormalMaterial:"normal",MeshBasicMaterial:"basic",MeshLambertMaterial:"lambert",MeshPhongMaterial:"phong",MeshToonMaterial:"toon",MeshStandardMaterial:"physical",MeshPhysicalMaterial:"physical",MeshMatcapMaterial:"matcap",LineBasicMaterial:"basic",LineDashedMaterial:"dashed",PointsMaterial:"points",ShadowMaterial:"shadow",SpriteMaterial:"sprite"};function g(v){return l.add(v),v===0?"uv":`uv${v}`}function M(v,T,L,D,I,k){const G=D.fog,O=I.geometry,V=v.isMeshStandardMaterial||v.isMeshLambertMaterial||v.isMeshPhongMaterial?D.environment:null,H=v.isMeshStandardMaterial||v.isMeshLambertMaterial&&!v.envMap||v.isMeshPhongMaterial&&!v.envMap,$=e.get(v.envMap||V,H),oe=$&&$.mapping===da?$.image.height:null,ve=p[v.type];v.precision!==null&&(f=i.getMaxPrecision(v.precision),f!==v.precision&&ze("WebGLProgram.getParameters:",v.precision,"not supported, using",f,"instead."));const be=O.morphAttributes.position||O.morphAttributes.normal||O.morphAttributes.color,we=be!==void 0?be.length:0;let $e=0;O.morphAttributes.position!==void 0&&($e=1),O.morphAttributes.normal!==void 0&&($e=2),O.morphAttributes.color!==void 0&&($e=3);let tt,We,se,Se;if(ve){const Ye=Bn[ve];tt=Ye.vertexShader,We=Ye.fragmentShader}else tt=v.vertexShader,We=v.fragmentShader,a.update(v),se=a.getVertexShaderID(v),Se=a.getFragmentShaderID(v);const me=n.getRenderTarget(),Be=n.state.buffers.depth.getReversed(),He=I.isInstancedMesh===!0,Ve=I.isBatchedMesh===!0,R=!!v.map,U=!!v.matcap,W=!!$,ee=!!v.aoMap,K=!!v.lightMap,Q=!!v.bumpMap,le=!!v.normalMap,fe=!!v.displacementMap,w=!!v.emissiveMap,ne=!!v.metalnessMap,pe=!!v.roughnessMap,ce=v.anisotropy>0,J=v.clearcoat>0,Re=v.dispersion>0,b=v.iridescence>0,_=v.sheen>0,B=v.transmission>0,j=ce&&!!v.anisotropyMap,ie=J&&!!v.clearcoatMap,ue=J&&!!v.clearcoatNormalMap,he=J&&!!v.clearcoatRoughnessMap,Z=b&&!!v.iridescenceMap,re=b&&!!v.iridescenceThicknessMap,ge=_&&!!v.sheenColorMap,Ee=_&&!!v.sheenRoughnessMap,_e=!!v.specularMap,de=!!v.specularColorMap,ke=!!v.specularIntensityMap,Ke=B&&!!v.transmissionMap,rt=B&&!!v.thicknessMap,F=!!v.gradientMap,xe=!!v.alphaMap,te=v.alphaTest>0,Ce=!!v.alphaHash,Me=!!v.extensions;let ae=kn;v.toneMapped&&(me===null||me.isXRRenderTarget===!0)&&(ae=n.toneMapping);const Ue={shaderID:ve,shaderType:v.type,shaderName:v.name,vertexShader:tt,fragmentShader:We,defines:v.defines,customVertexShaderID:se,customFragmentShaderID:Se,isRawShaderMaterial:v.isRawShaderMaterial===!0,glslVersion:v.glslVersion,precision:f,batching:Ve,batchingColor:Ve&&I._colorsTexture!==null,instancing:He,instancingColor:He&&I.instanceColor!==null,instancingMorph:He&&I.morphTexture!==null,outputColorSpace:me===null?n.outputColorSpace:me.isXRRenderTarget===!0?me.texture.colorSpace:Qe.workingColorSpace,alphaToCoverage:!!v.alphaToCoverage,map:R,matcap:U,envMap:W,envMapMode:W&&$.mapping,envMapCubeUVHeight:oe,aoMap:ee,lightMap:K,bumpMap:Q,normalMap:le,displacementMap:fe,emissiveMap:w,normalMapObjectSpace:le&&v.normalMapType===L_,normalMapTangentSpace:le&&v.normalMapType===$u,packedNormalMap:le&&v.normalMapType===$u&&lE(v.normalMap.format),metalnessMap:ne,roughnessMap:pe,anisotropy:ce,anisotropyMap:j,clearcoat:J,clearcoatMap:ie,clearcoatNormalMap:ue,clearcoatRoughnessMap:he,dispersion:Re,iridescence:b,iridescenceMap:Z,iridescenceThicknessMap:re,sheen:_,sheenColorMap:ge,sheenRoughnessMap:Ee,specularMap:_e,specularColorMap:de,specularIntensityMap:ke,transmission:B,transmissionMap:Ke,thicknessMap:rt,gradientMap:F,opaque:v.transparent===!1&&v.blending===Ur&&v.alphaToCoverage===!1,alphaMap:xe,alphaTest:te,alphaHash:Ce,combine:v.combine,mapUv:R&&g(v.map.channel),aoMapUv:ee&&g(v.aoMap.channel),lightMapUv:K&&g(v.lightMap.channel),bumpMapUv:Q&&g(v.bumpMap.channel),normalMapUv:le&&g(v.normalMap.channel),displacementMapUv:fe&&g(v.displacementMap.channel),emissiveMapUv:w&&g(v.emissiveMap.channel),metalnessMapUv:ne&&g(v.metalnessMap.channel),roughnessMapUv:pe&&g(v.roughnessMap.channel),anisotropyMapUv:j&&g(v.anisotropyMap.channel),clearcoatMapUv:ie&&g(v.clearcoatMap.channel),clearcoatNormalMapUv:ue&&g(v.clearcoatNormalMap.channel),clearcoatRoughnessMapUv:he&&g(v.clearcoatRoughnessMap.channel),iridescenceMapUv:Z&&g(v.iridescenceMap.channel),iridescenceThicknessMapUv:re&&g(v.iridescenceThicknessMap.channel),sheenColorMapUv:ge&&g(v.sheenColorMap.channel),sheenRoughnessMapUv:Ee&&g(v.sheenRoughnessMap.channel),specularMapUv:_e&&g(v.specularMap.channel),specularColorMapUv:de&&g(v.specularColorMap.channel),specularIntensityMapUv:ke&&g(v.specularIntensityMap.channel),transmissionMapUv:Ke&&g(v.transmissionMap.channel),thicknessMapUv:rt&&g(v.thicknessMap.channel),alphaMapUv:xe&&g(v.alphaMap.channel),vertexTangents:!!O.attributes.tangent&&(le||ce),vertexNormals:!!O.attributes.normal,vertexColors:v.vertexColors,vertexAlphas:v.vertexColors===!0&&!!O.attributes.color&&O.attributes.color.itemSize===4,pointsUvs:I.isPoints===!0&&!!O.attributes.uv&&(R||xe),fog:!!G,useFog:v.fog===!0,fogExp2:!!G&&G.isFogExp2,flatShading:v.wireframe===!1&&(v.flatShading===!0||O.attributes.normal===void 0&&le===!1&&(v.isMeshLambertMaterial||v.isMeshPhongMaterial||v.isMeshStandardMaterial||v.isMeshPhysicalMaterial)),sizeAttenuation:v.sizeAttenuation===!0,logarithmicDepthBuffer:h,reversedDepthBuffer:Be,skinning:I.isSkinnedMesh===!0,morphTargets:O.morphAttributes.position!==void 0,morphNormals:O.morphAttributes.normal!==void 0,morphColors:O.morphAttributes.color!==void 0,morphTargetsCount:we,morphTextureStride:$e,numDirLights:T.directional.length,numPointLights:T.point.length,numSpotLights:T.spot.length,numSpotLightMaps:T.spotLightMap.length,numRectAreaLights:T.rectArea.length,numHemiLights:T.hemi.length,numDirLightShadows:T.directionalShadowMap.length,numPointLightShadows:T.pointShadowMap.length,numSpotLightShadows:T.spotShadowMap.length,numSpotLightShadowsWithMaps:T.numSpotLightShadowsWithMaps,numLightProbes:T.numLightProbes,numLightProbeGrids:k.length,numClippingPlanes:s.numPlanes,numClipIntersection:s.numIntersection,dithering:v.dithering,shadowMapEnabled:n.shadowMap.enabled&&L.length>0,shadowMapType:n.shadowMap.type,toneMapping:ae,decodeVideoTexture:R&&v.map.isVideoTexture===!0&&Qe.getTransfer(v.map.colorSpace)===ut,decodeVideoTextureEmissive:w&&v.emissiveMap.isVideoTexture===!0&&Qe.getTransfer(v.emissiveMap.colorSpace)===ut,premultipliedAlpha:v.premultipliedAlpha,doubleSided:v.side===zn,flipSided:v.side===on,useDepthPacking:v.depthPacking>=0,depthPacking:v.depthPacking||0,index0AttributeName:v.index0AttributeName,extensionClipCullDistance:Me&&v.extensions.clipCullDistance===!0&&t.has("WEBGL_clip_cull_distance"),extensionMultiDraw:(Me&&v.extensions.multiDraw===!0||Ve)&&t.has("WEBGL_multi_draw"),rendererExtensionParallelShaderCompile:t.has("KHR_parallel_shader_compile"),customProgramCacheKey:v.customProgramCacheKey()};return Ue.vertexUv1s=l.has(1),Ue.vertexUv2s=l.has(2),Ue.vertexUv3s=l.has(3),l.clear(),Ue}function m(v){const T=[];if(v.shaderID?T.push(v.shaderID):(T.push(v.customVertexShaderID),T.push(v.customFragmentShaderID)),v.defines!==void 0)for(const L in v.defines)T.push(L),T.push(v.defines[L]);return v.isRawShaderMaterial===!1&&(d(T,v),x(T,v),T.push(n.outputColorSpace)),T.push(v.customProgramCacheKey),T.join()}function d(v,T){v.push(T.precision),v.push(T.outputColorSpace),v.push(T.envMapMode),v.push(T.envMapCubeUVHeight),v.push(T.mapUv),v.push(T.alphaMapUv),v.push(T.lightMapUv),v.push(T.aoMapUv),v.push(T.bumpMapUv),v.push(T.normalMapUv),v.push(T.displacementMapUv),v.push(T.emissiveMapUv),v.push(T.metalnessMapUv),v.push(T.roughnessMapUv),v.push(T.anisotropyMapUv),v.push(T.clearcoatMapUv),v.push(T.clearcoatNormalMapUv),v.push(T.clearcoatRoughnessMapUv),v.push(T.iridescenceMapUv),v.push(T.iridescenceThicknessMapUv),v.push(T.sheenColorMapUv),v.push(T.sheenRoughnessMapUv),v.push(T.specularMapUv),v.push(T.specularColorMapUv),v.push(T.specularIntensityMapUv),v.push(T.transmissionMapUv),v.push(T.thicknessMapUv),v.push(T.combine),v.push(T.fogExp2),v.push(T.sizeAttenuation),v.push(T.morphTargetsCount),v.push(T.morphAttributeCount),v.push(T.numDirLights),v.push(T.numPointLights),v.push(T.numSpotLights),v.push(T.numSpotLightMaps),v.push(T.numHemiLights),v.push(T.numRectAreaLights),v.push(T.numDirLightShadows),v.push(T.numPointLightShadows),v.push(T.numSpotLightShadows),v.push(T.numSpotLightShadowsWithMaps),v.push(T.numLightProbes),v.push(T.shadowMapType),v.push(T.toneMapping),v.push(T.numClippingPlanes),v.push(T.numClipIntersection),v.push(T.depthPacking)}function x(v,T){o.disableAll(),T.instancing&&o.enable(0),T.instancingColor&&o.enable(1),T.instancingMorph&&o.enable(2),T.matcap&&o.enable(3),T.envMap&&o.enable(4),T.normalMapObjectSpace&&o.enable(5),T.normalMapTangentSpace&&o.enable(6),T.clearcoat&&o.enable(7),T.iridescence&&o.enable(8),T.alphaTest&&o.enable(9),T.vertexColors&&o.enable(10),T.vertexAlphas&&o.enable(11),T.vertexUv1s&&o.enable(12),T.vertexUv2s&&o.enable(13),T.vertexUv3s&&o.enable(14),T.vertexTangents&&o.enable(15),T.anisotropy&&o.enable(16),T.alphaHash&&o.enable(17),T.batching&&o.enable(18),T.dispersion&&o.enable(19),T.batchingColor&&o.enable(20),T.gradientMap&&o.enable(21),T.packedNormalMap&&o.enable(22),T.vertexNormals&&o.enable(23),v.push(o.mask),o.disableAll(),T.fog&&o.enable(0),T.useFog&&o.enable(1),T.flatShading&&o.enable(2),T.logarithmicDepthBuffer&&o.enable(3),T.reversedDepthBuffer&&o.enable(4),T.skinning&&o.enable(5),T.morphTargets&&o.enable(6),T.morphNormals&&o.enable(7),T.morphColors&&o.enable(8),T.premultipliedAlpha&&o.enable(9),T.shadowMapEnabled&&o.enable(10),T.doubleSided&&o.enable(11),T.flipSided&&o.enable(12),T.useDepthPacking&&o.enable(13),T.dithering&&o.enable(14),T.transmission&&o.enable(15),T.sheen&&o.enable(16),T.opaque&&o.enable(17),T.pointsUvs&&o.enable(18),T.decodeVideoTexture&&o.enable(19),T.decodeVideoTextureEmissive&&o.enable(20),T.alphaToCoverage&&o.enable(21),T.numLightProbeGrids>0&&o.enable(22),v.push(o.mask)}function y(v){const T=p[v.type];let L;if(T){const D=Bn[T];L=P0.clone(D.uniforms)}else L=v.uniforms;return L}function S(v,T){let L=u.get(T);return L!==void 0?++L.usedTimes:(L=new rE(n,T,v,r),c.push(L),u.set(T,L)),L}function C(v){if(--v.usedTimes===0){const T=c.indexOf(v);c[T]=c[c.length-1],c.pop(),u.delete(v.cacheKey),v.destroy()}}function A(v){a.remove(v)}function P(){a.dispose()}return{getParameters:M,getProgramCacheKey:m,getUniforms:y,acquireProgram:S,releaseProgram:C,releaseShaderCache:A,programs:c,dispose:P}}function uE(){let n=new WeakMap;function e(o){return n.has(o)}function t(o){let a=n.get(o);return a===void 0&&(a={},n.set(o,a)),a}function i(o){n.delete(o)}function r(o,a,l){n.get(o)[a]=l}function s(){n=new WeakMap}return{has:e,get:t,remove:i,update:r,dispose:s}}function fE(n,e){return n.groupOrder!==e.groupOrder?n.groupOrder-e.groupOrder:n.renderOrder!==e.renderOrder?n.renderOrder-e.renderOrder:n.material.id!==e.material.id?n.material.id-e.material.id:n.materialVariant!==e.materialVariant?n.materialVariant-e.materialVariant:n.z!==e.z?n.z-e.z:n.id-e.id}function Yf(n,e){return n.groupOrder!==e.groupOrder?n.groupOrder-e.groupOrder:n.renderOrder!==e.renderOrder?n.renderOrder-e.renderOrder:n.z!==e.z?e.z-n.z:n.id-e.id}function qf(){const n=[];let e=0;const t=[],i=[],r=[];function s(){e=0,t.length=0,i.length=0,r.length=0}function o(f){let p=0;return f.isInstancedMesh&&(p+=2),f.isSkinnedMesh&&(p+=1),p}function a(f,p,g,M,m,d){let x=n[e];return x===void 0?(x={id:f.id,object:f,geometry:p,material:g,materialVariant:o(f),groupOrder:M,renderOrder:f.renderOrder,z:m,group:d},n[e]=x):(x.id=f.id,x.object=f,x.geometry=p,x.material=g,x.materialVariant=o(f),x.groupOrder=M,x.renderOrder=f.renderOrder,x.z=m,x.group=d),e++,x}function l(f,p,g,M,m,d){const x=a(f,p,g,M,m,d);g.transmission>0?i.push(x):g.transparent===!0?r.push(x):t.push(x)}function c(f,p,g,M,m,d){const x=a(f,p,g,M,m,d);g.transmission>0?i.unshift(x):g.transparent===!0?r.unshift(x):t.unshift(x)}function u(f,p){t.length>1&&t.sort(f||fE),i.length>1&&i.sort(p||Yf),r.length>1&&r.sort(p||Yf)}function h(){for(let f=e,p=n.length;f<p;f++){const g=n[f];if(g.id===null)break;g.id=null,g.object=null,g.geometry=null,g.material=null,g.group=null}}return{opaque:t,transmissive:i,transparent:r,init:s,push:l,unshift:c,finish:h,sort:u}}function hE(){let n=new WeakMap;function e(i,r){const s=n.get(i);let o;return s===void 0?(o=new qf,n.set(i,[o])):r>=s.length?(o=new qf,s.push(o)):o=s[r],o}function t(){n=new WeakMap}return{get:e,dispose:t}}function dE(){const n={};return{get:function(e){if(n[e.id]!==void 0)return n[e.id];let t;switch(e.type){case"DirectionalLight":t={direction:new N,color:new lt};break;case"SpotLight":t={position:new N,direction:new N,color:new lt,distance:0,coneCos:0,penumbraCos:0,decay:0};break;case"PointLight":t={position:new N,color:new lt,distance:0,decay:0};break;case"HemisphereLight":t={direction:new N,skyColor:new lt,groundColor:new lt};break;case"RectAreaLight":t={color:new lt,position:new N,halfWidth:new N,halfHeight:new N};break}return n[e.id]=t,t}}}function pE(){const n={};return{get:function(e){if(n[e.id]!==void 0)return n[e.id];let t;switch(e.type){case"DirectionalLight":t={shadowIntensity:1,shadowBias:0,shadowNormalBias:0,shadowRadius:1,shadowMapSize:new st};break;case"SpotLight":t={shadowIntensity:1,shadowBias:0,shadowNormalBias:0,shadowRadius:1,shadowMapSize:new st};break;case"PointLight":t={shadowIntensity:1,shadowBias:0,shadowNormalBias:0,shadowRadius:1,shadowMapSize:new st,shadowCameraNear:1,shadowCameraFar:1e3};break}return n[e.id]=t,t}}}let mE=0;function gE(n,e){return(e.castShadow?2:0)-(n.castShadow?2:0)+(e.map?1:0)-(n.map?1:0)}function _E(n){const e=new dE,t=pE(),i={version:0,hash:{directionalLength:-1,pointLength:-1,spotLength:-1,rectAreaLength:-1,hemiLength:-1,numDirectionalShadows:-1,numPointShadows:-1,numSpotShadows:-1,numSpotMaps:-1,numLightProbes:-1},ambient:[0,0,0],probe:[],directional:[],directionalShadow:[],directionalShadowMap:[],directionalShadowMatrix:[],spot:[],spotLightMap:[],spotShadow:[],spotShadowMap:[],spotLightMatrix:[],rectArea:[],rectAreaLTC1:null,rectAreaLTC2:null,point:[],pointShadow:[],pointShadowMap:[],pointShadowMatrix:[],hemi:[],numSpotLightShadowsWithMaps:0,numLightProbes:0};for(let c=0;c<9;c++)i.probe.push(new N);const r=new N,s=new Mt,o=new Mt;function a(c){let u=0,h=0,f=0;for(let T=0;T<9;T++)i.probe[T].set(0,0,0);let p=0,g=0,M=0,m=0,d=0,x=0,y=0,S=0,C=0,A=0,P=0;c.sort(gE);for(let T=0,L=c.length;T<L;T++){const D=c[T],I=D.color,k=D.intensity,G=D.distance;let O=null;if(D.shadow&&D.shadow.map&&(D.shadow.map.texture.format===ar?O=D.shadow.map.texture:O=D.shadow.map.depthTexture||D.shadow.map.texture),D.isAmbientLight)u+=I.r*k,h+=I.g*k,f+=I.b*k;else if(D.isLightProbe){for(let V=0;V<9;V++)i.probe[V].addScaledVector(D.sh.coefficients[V],k);P++}else if(D.isDirectionalLight){const V=e.get(D);if(V.color.copy(D.color).multiplyScalar(D.intensity),D.castShadow){const H=D.shadow,$=t.get(D);$.shadowIntensity=H.intensity,$.shadowBias=H.bias,$.shadowNormalBias=H.normalBias,$.shadowRadius=H.radius,$.shadowMapSize=H.mapSize,i.directionalShadow[p]=$,i.directionalShadowMap[p]=O,i.directionalShadowMatrix[p]=D.shadow.matrix,x++}i.directional[p]=V,p++}else if(D.isSpotLight){const V=e.get(D);V.position.setFromMatrixPosition(D.matrixWorld),V.color.copy(I).multiplyScalar(k),V.distance=G,V.coneCos=Math.cos(D.angle),V.penumbraCos=Math.cos(D.angle*(1-D.penumbra)),V.decay=D.decay,i.spot[M]=V;const H=D.shadow;if(D.map&&(i.spotLightMap[C]=D.map,C++,H.updateMatrices(D),D.castShadow&&A++),i.spotLightMatrix[M]=H.matrix,D.castShadow){const $=t.get(D);$.shadowIntensity=H.intensity,$.shadowBias=H.bias,$.shadowNormalBias=H.normalBias,$.shadowRadius=H.radius,$.shadowMapSize=H.mapSize,i.spotShadow[M]=$,i.spotShadowMap[M]=O,S++}M++}else if(D.isRectAreaLight){const V=e.get(D);V.color.copy(I).multiplyScalar(k),V.halfWidth.set(D.width*.5,0,0),V.halfHeight.set(0,D.height*.5,0),i.rectArea[m]=V,m++}else if(D.isPointLight){const V=e.get(D);if(V.color.copy(D.color).multiplyScalar(D.intensity),V.distance=D.distance,V.decay=D.decay,D.castShadow){const H=D.shadow,$=t.get(D);$.shadowIntensity=H.intensity,$.shadowBias=H.bias,$.shadowNormalBias=H.normalBias,$.shadowRadius=H.radius,$.shadowMapSize=H.mapSize,$.shadowCameraNear=H.camera.near,$.shadowCameraFar=H.camera.far,i.pointShadow[g]=$,i.pointShadowMap[g]=O,i.pointShadowMatrix[g]=D.shadow.matrix,y++}i.point[g]=V,g++}else if(D.isHemisphereLight){const V=e.get(D);V.skyColor.copy(D.color).multiplyScalar(k),V.groundColor.copy(D.groundColor).multiplyScalar(k),i.hemi[d]=V,d++}}m>0&&(n.has("OES_texture_float_linear")===!0?(i.rectAreaLTC1=ye.LTC_FLOAT_1,i.rectAreaLTC2=ye.LTC_FLOAT_2):(i.rectAreaLTC1=ye.LTC_HALF_1,i.rectAreaLTC2=ye.LTC_HALF_2)),i.ambient[0]=u,i.ambient[1]=h,i.ambient[2]=f;const v=i.hash;(v.directionalLength!==p||v.pointLength!==g||v.spotLength!==M||v.rectAreaLength!==m||v.hemiLength!==d||v.numDirectionalShadows!==x||v.numPointShadows!==y||v.numSpotShadows!==S||v.numSpotMaps!==C||v.numLightProbes!==P)&&(i.directional.length=p,i.spot.length=M,i.rectArea.length=m,i.point.length=g,i.hemi.length=d,i.directionalShadow.length=x,i.directionalShadowMap.length=x,i.pointShadow.length=y,i.pointShadowMap.length=y,i.spotShadow.length=S,i.spotShadowMap.length=S,i.directionalShadowMatrix.length=x,i.pointShadowMatrix.length=y,i.spotLightMatrix.length=S+C-A,i.spotLightMap.length=C,i.numSpotLightShadowsWithMaps=A,i.numLightProbes=P,v.directionalLength=p,v.pointLength=g,v.spotLength=M,v.rectAreaLength=m,v.hemiLength=d,v.numDirectionalShadows=x,v.numPointShadows=y,v.numSpotShadows=S,v.numSpotMaps=C,v.numLightProbes=P,i.version=mE++)}function l(c,u){let h=0,f=0,p=0,g=0,M=0;const m=u.matrixWorldInverse;for(let d=0,x=c.length;d<x;d++){const y=c[d];if(y.isDirectionalLight){const S=i.directional[h];S.direction.setFromMatrixPosition(y.matrixWorld),r.setFromMatrixPosition(y.target.matrixWorld),S.direction.sub(r),S.direction.transformDirection(m),h++}else if(y.isSpotLight){const S=i.spot[p];S.position.setFromMatrixPosition(y.matrixWorld),S.position.applyMatrix4(m),S.direction.setFromMatrixPosition(y.matrixWorld),r.setFromMatrixPosition(y.target.matrixWorld),S.direction.sub(r),S.direction.transformDirection(m),p++}else if(y.isRectAreaLight){const S=i.rectArea[g];S.position.setFromMatrixPosition(y.matrixWorld),S.position.applyMatrix4(m),o.identity(),s.copy(y.matrixWorld),s.premultiply(m),o.extractRotation(s),S.halfWidth.set(y.width*.5,0,0),S.halfHeight.set(0,y.height*.5,0),S.halfWidth.applyMatrix4(o),S.halfHeight.applyMatrix4(o),g++}else if(y.isPointLight){const S=i.point[f];S.position.setFromMatrixPosition(y.matrixWorld),S.position.applyMatrix4(m),f++}else if(y.isHemisphereLight){const S=i.hemi[M];S.direction.setFromMatrixPosition(y.matrixWorld),S.direction.transformDirection(m),M++}}}return{setup:a,setupView:l,state:i}}function Kf(n){const e=new _E(n),t=[],i=[],r=[];function s(f){h.camera=f,t.length=0,i.length=0,r.length=0}function o(f){t.push(f)}function a(f){i.push(f)}function l(f){r.push(f)}function c(){e.setup(t)}function u(f){e.setupView(t,f)}const h={lightsArray:t,shadowsArray:i,lightProbeGridArray:r,camera:null,lights:e,transmissionRenderTarget:{},textureUnits:0};return{init:s,state:h,setupLights:c,setupLightsView:u,pushLight:o,pushShadow:a,pushLightProbeGrid:l}}function xE(n){let e=new WeakMap;function t(r,s=0){const o=e.get(r);let a;return o===void 0?(a=new Kf(n),e.set(r,[a])):s>=o.length?(a=new Kf(n),o.push(a)):a=o[s],a}function i(){e=new WeakMap}return{get:t,dispose:i}}const vE=`void main() {
	gl_Position = vec4( position, 1.0 );
}`,ME=`uniform sampler2D shadow_pass;
uniform vec2 resolution;
uniform float radius;
void main() {
	const float samples = float( VSM_SAMPLES );
	float mean = 0.0;
	float squared_mean = 0.0;
	float uvStride = samples <= 1.0 ? 0.0 : 2.0 / ( samples - 1.0 );
	float uvStart = samples <= 1.0 ? 0.0 : - 1.0;
	for ( float i = 0.0; i < samples; i ++ ) {
		float uvOffset = uvStart + i * uvStride;
		#ifdef HORIZONTAL_PASS
			vec2 distribution = texture2D( shadow_pass, ( gl_FragCoord.xy + vec2( uvOffset, 0.0 ) * radius ) / resolution ).rg;
			mean += distribution.x;
			squared_mean += distribution.y * distribution.y + distribution.x * distribution.x;
		#else
			float depth = texture2D( shadow_pass, ( gl_FragCoord.xy + vec2( 0.0, uvOffset ) * radius ) / resolution ).r;
			mean += depth;
			squared_mean += depth * depth;
		#endif
	}
	mean = mean / samples;
	squared_mean = squared_mean / samples;
	float std_dev = sqrt( max( 0.0, squared_mean - mean * mean ) );
	gl_FragColor = vec4( mean, std_dev, 0.0, 1.0 );
}`,SE=[new N(1,0,0),new N(-1,0,0),new N(0,1,0),new N(0,-1,0),new N(0,0,1),new N(0,0,-1)],EE=[new N(0,-1,0),new N(0,-1,0),new N(0,0,1),new N(0,0,-1),new N(0,-1,0),new N(0,-1,0)],jf=new Mt,ts=new N,cl=new N;function yE(n,e,t){let i=new $d;const r=new st,s=new st,o=new At,a=new U0,l=new N0,c={},u=t.maxTextureSize,h={[Li]:on,[on]:Li,[zn]:zn},f=new qn({defines:{VSM_SAMPLES:8},uniforms:{shadow_pass:{value:null},resolution:{value:new st},radius:{value:4}},vertexShader:vE,fragmentShader:ME}),p=f.clone();p.defines.HORIZONTAL_PASS=1;const g=new $t;g.setAttribute("position",new Xn(new Float32Array([-1,-1,.5,3,-1,.5,-1,3,.5]),3));const M=new Pe(g,f),m=this;this.enabled=!1,this.autoUpdate=!0,this.needsUpdate=!1,this.type=bo;let d=this.type;this.render=function(A,P,v){if(m.enabled===!1||m.autoUpdate===!1&&m.needsUpdate===!1||A.length===0)return;this.type===u_&&(ze("WebGLShadowMap: PCFSoftShadowMap has been deprecated. Using PCFShadowMap instead."),this.type=bo);const T=n.getRenderTarget(),L=n.getActiveCubeFace(),D=n.getActiveMipmapLevel(),I=n.state;I.setBlending(oi),I.buffers.depth.getReversed()===!0?I.buffers.color.setClear(0,0,0,0):I.buffers.color.setClear(1,1,1,1),I.buffers.depth.setTest(!0),I.setScissorTest(!1);const k=d!==this.type;k&&P.traverse(function(G){G.material&&(Array.isArray(G.material)?G.material.forEach(O=>O.needsUpdate=!0):G.material.needsUpdate=!0)});for(let G=0,O=A.length;G<O;G++){const V=A[G],H=V.shadow;if(H===void 0){ze("WebGLShadowMap:",V,"has no shadow.");continue}if(H.autoUpdate===!1&&H.needsUpdate===!1)continue;r.copy(H.mapSize);const $=H.getFrameExtents();r.multiply($),s.copy(H.mapSize),(r.x>u||r.y>u)&&(r.x>u&&(s.x=Math.floor(u/$.x),r.x=s.x*$.x,H.mapSize.x=s.x),r.y>u&&(s.y=Math.floor(u/$.y),r.y=s.y*$.y,H.mapSize.y=s.y));const oe=n.state.buffers.depth.getReversed();if(H.camera._reversedDepth=oe,H.map===null||k===!0){if(H.map!==null&&(H.map.depthTexture!==null&&(H.map.depthTexture.dispose(),H.map.depthTexture=null),H.map.dispose()),this.type===as){if(V.isPointLight){ze("WebGLShadowMap: VSM shadow maps are not supported for PointLights. Use PCF or BasicShadowMap instead.");continue}H.map=new Wn(r.x,r.y,{format:ar,type:fi,minFilter:jt,magFilter:jt,generateMipmaps:!1}),H.map.texture.name=V.name+".shadowMap",H.map.depthTexture=new Vr(r.x,r.y,Hn),H.map.depthTexture.name=V.name+".shadowMapDepth",H.map.depthTexture.format=hi,H.map.depthTexture.compareFunction=null,H.map.depthTexture.minFilter=zt,H.map.depthTexture.magFilter=zt}else V.isPointLight?(H.map=new ap(r.x),H.map.depthTexture=new R0(r.x,Yn)):(H.map=new Wn(r.x,r.y),H.map.depthTexture=new Vr(r.x,r.y,Yn)),H.map.depthTexture.name=V.name+".shadowMap",H.map.depthTexture.format=hi,this.type===bo?(H.map.depthTexture.compareFunction=oe?Xc:Wc,H.map.depthTexture.minFilter=jt,H.map.depthTexture.magFilter=jt):(H.map.depthTexture.compareFunction=null,H.map.depthTexture.minFilter=zt,H.map.depthTexture.magFilter=zt);H.camera.updateProjectionMatrix()}const ve=H.map.isWebGLCubeRenderTarget?6:1;for(let be=0;be<ve;be++){if(H.map.isWebGLCubeRenderTarget)n.setRenderTarget(H.map,be),n.clear();else{be===0&&(n.setRenderTarget(H.map),n.clear());const we=H.getViewport(be);o.set(s.x*we.x,s.y*we.y,s.x*we.z,s.y*we.w),I.viewport(o)}if(V.isPointLight){const we=H.camera,$e=H.matrix,tt=V.distance||we.far;tt!==we.far&&(we.far=tt,we.updateProjectionMatrix()),ts.setFromMatrixPosition(V.matrixWorld),we.position.copy(ts),cl.copy(we.position),cl.add(SE[be]),we.up.copy(EE[be]),we.lookAt(cl),we.updateMatrixWorld(),$e.makeTranslation(-ts.x,-ts.y,-ts.z),jf.multiplyMatrices(we.projectionMatrix,we.matrixWorldInverse),H._frustum.setFromProjectionMatrix(jf,we.coordinateSystem,we.reversedDepth)}else H.updateMatrices(V);i=H.getFrustum(),S(P,v,H.camera,V,this.type)}H.isPointLightShadow!==!0&&this.type===as&&x(H,v),H.needsUpdate=!1}d=this.type,m.needsUpdate=!1,n.setRenderTarget(T,L,D)};function x(A,P){const v=e.update(M);f.defines.VSM_SAMPLES!==A.blurSamples&&(f.defines.VSM_SAMPLES=A.blurSamples,p.defines.VSM_SAMPLES=A.blurSamples,f.needsUpdate=!0,p.needsUpdate=!0),A.mapPass===null&&(A.mapPass=new Wn(r.x,r.y,{format:ar,type:fi})),f.uniforms.shadow_pass.value=A.map.depthTexture,f.uniforms.resolution.value=A.mapSize,f.uniforms.radius.value=A.radius,n.setRenderTarget(A.mapPass),n.clear(),n.renderBufferDirect(P,null,v,f,M,null),p.uniforms.shadow_pass.value=A.mapPass.texture,p.uniforms.resolution.value=A.mapSize,p.uniforms.radius.value=A.radius,n.setRenderTarget(A.map),n.clear(),n.renderBufferDirect(P,null,v,p,M,null)}function y(A,P,v,T){let L=null;const D=v.isPointLight===!0?A.customDistanceMaterial:A.customDepthMaterial;if(D!==void 0)L=D;else if(L=v.isPointLight===!0?l:a,n.localClippingEnabled&&P.clipShadows===!0&&Array.isArray(P.clippingPlanes)&&P.clippingPlanes.length!==0||P.displacementMap&&P.displacementScale!==0||P.alphaMap&&P.alphaTest>0||P.map&&P.alphaTest>0||P.alphaToCoverage===!0){const I=L.uuid,k=P.uuid;let G=c[I];G===void 0&&(G={},c[I]=G);let O=G[k];O===void 0&&(O=L.clone(),G[k]=O,P.addEventListener("dispose",C)),L=O}if(L.visible=P.visible,L.wireframe=P.wireframe,T===as?L.side=P.shadowSide!==null?P.shadowSide:P.side:L.side=P.shadowSide!==null?P.shadowSide:h[P.side],L.alphaMap=P.alphaMap,L.alphaTest=P.alphaToCoverage===!0?.5:P.alphaTest,L.map=P.map,L.clipShadows=P.clipShadows,L.clippingPlanes=P.clippingPlanes,L.clipIntersection=P.clipIntersection,L.displacementMap=P.displacementMap,L.displacementScale=P.displacementScale,L.displacementBias=P.displacementBias,L.wireframeLinewidth=P.wireframeLinewidth,L.linewidth=P.linewidth,v.isPointLight===!0&&L.isMeshDistanceMaterial===!0){const I=n.properties.get(L);I.light=v}return L}function S(A,P,v,T,L){if(A.visible===!1)return;if(A.layers.test(P.layers)&&(A.isMesh||A.isLine||A.isPoints)&&(A.castShadow||A.receiveShadow&&L===as)&&(!A.frustumCulled||i.intersectsObject(A))){A.modelViewMatrix.multiplyMatrices(v.matrixWorldInverse,A.matrixWorld);const k=e.update(A),G=A.material;if(Array.isArray(G)){const O=k.groups;for(let V=0,H=O.length;V<H;V++){const $=O[V],oe=G[$.materialIndex];if(oe&&oe.visible){const ve=y(A,oe,T,L);A.onBeforeShadow(n,A,P,v,k,ve,$),n.renderBufferDirect(v,null,k,ve,A,$),A.onAfterShadow(n,A,P,v,k,ve,$)}}}else if(G.visible){const O=y(A,G,T,L);A.onBeforeShadow(n,A,P,v,k,O,null),n.renderBufferDirect(v,null,k,O,A,null),A.onAfterShadow(n,A,P,v,k,O,null)}}const I=A.children;for(let k=0,G=I.length;k<G;k++)S(I[k],P,v,T,L)}function C(A){A.target.removeEventListener("dispose",C);for(const v in c){const T=c[v],L=A.target.uuid;L in T&&(T[L].dispose(),delete T[L])}}}function bE(n,e){function t(){let F=!1;const xe=new At;let te=null;const Ce=new At(0,0,0,0);return{setMask:function(Me){te!==Me&&!F&&(n.colorMask(Me,Me,Me,Me),te=Me)},setLocked:function(Me){F=Me},setClear:function(Me,ae,Ue,Ye,yt){yt===!0&&(Me*=Ye,ae*=Ye,Ue*=Ye),xe.set(Me,ae,Ue,Ye),Ce.equals(xe)===!1&&(n.clearColor(Me,ae,Ue,Ye),Ce.copy(xe))},reset:function(){F=!1,te=null,Ce.set(-1,0,0,0)}}}function i(){let F=!1,xe=!1,te=null,Ce=null,Me=null;return{setReversed:function(ae){if(xe!==ae){const Ue=e.get("EXT_clip_control");ae?Ue.clipControlEXT(Ue.LOWER_LEFT_EXT,Ue.ZERO_TO_ONE_EXT):Ue.clipControlEXT(Ue.LOWER_LEFT_EXT,Ue.NEGATIVE_ONE_TO_ONE_EXT),xe=ae;const Ye=Me;Me=null,this.setClear(Ye)}},getReversed:function(){return xe},setTest:function(ae){ae?me(n.DEPTH_TEST):Be(n.DEPTH_TEST)},setMask:function(ae){te!==ae&&!F&&(n.depthMask(ae),te=ae)},setFunc:function(ae){if(xe&&(ae=k_[ae]),Ce!==ae){switch(ae){case Cl:n.depthFunc(n.NEVER);break;case Pl:n.depthFunc(n.ALWAYS);break;case Dl:n.depthFunc(n.LESS);break;case zr:n.depthFunc(n.LEQUAL);break;case Il:n.depthFunc(n.EQUAL);break;case Ll:n.depthFunc(n.GEQUAL);break;case Ul:n.depthFunc(n.GREATER);break;case Nl:n.depthFunc(n.NOTEQUAL);break;default:n.depthFunc(n.LEQUAL)}Ce=ae}},setLocked:function(ae){F=ae},setClear:function(ae){Me!==ae&&(Me=ae,xe&&(ae=1-ae),n.clearDepth(ae))},reset:function(){F=!1,te=null,Ce=null,Me=null,xe=!1}}}function r(){let F=!1,xe=null,te=null,Ce=null,Me=null,ae=null,Ue=null,Ye=null,yt=null;return{setTest:function(ft){F||(ft?me(n.STENCIL_TEST):Be(n.STENCIL_TEST))},setMask:function(ft){xe!==ft&&!F&&(n.stencilMask(ft),xe=ft)},setFunc:function(ft,Kn,Rn){(te!==ft||Ce!==Kn||Me!==Rn)&&(n.stencilFunc(ft,Kn,Rn),te=ft,Ce=Kn,Me=Rn)},setOp:function(ft,Kn,Rn){(ae!==ft||Ue!==Kn||Ye!==Rn)&&(n.stencilOp(ft,Kn,Rn),ae=ft,Ue=Kn,Ye=Rn)},setLocked:function(ft){F=ft},setClear:function(ft){yt!==ft&&(n.clearStencil(ft),yt=ft)},reset:function(){F=!1,xe=null,te=null,Ce=null,Me=null,ae=null,Ue=null,Ye=null,yt=null}}}const s=new t,o=new i,a=new r,l=new WeakMap,c=new WeakMap;let u={},h={},f={},p=new WeakMap,g=[],M=null,m=!1,d=null,x=null,y=null,S=null,C=null,A=null,P=null,v=new lt(0,0,0),T=0,L=!1,D=null,I=null,k=null,G=null,O=null;const V=n.getParameter(n.MAX_COMBINED_TEXTURE_IMAGE_UNITS);let H=!1,$=0;const oe=n.getParameter(n.VERSION);oe.indexOf("WebGL")!==-1?($=parseFloat(/^WebGL (\d)/.exec(oe)[1]),H=$>=1):oe.indexOf("OpenGL ES")!==-1&&($=parseFloat(/^OpenGL ES (\d)/.exec(oe)[1]),H=$>=2);let ve=null,be={};const we=n.getParameter(n.SCISSOR_BOX),$e=n.getParameter(n.VIEWPORT),tt=new At().fromArray(we),We=new At().fromArray($e);function se(F,xe,te,Ce){const Me=new Uint8Array(4),ae=n.createTexture();n.bindTexture(F,ae),n.texParameteri(F,n.TEXTURE_MIN_FILTER,n.NEAREST),n.texParameteri(F,n.TEXTURE_MAG_FILTER,n.NEAREST);for(let Ue=0;Ue<te;Ue++)F===n.TEXTURE_3D||F===n.TEXTURE_2D_ARRAY?n.texImage3D(xe,0,n.RGBA,1,1,Ce,0,n.RGBA,n.UNSIGNED_BYTE,Me):n.texImage2D(xe+Ue,0,n.RGBA,1,1,0,n.RGBA,n.UNSIGNED_BYTE,Me);return ae}const Se={};Se[n.TEXTURE_2D]=se(n.TEXTURE_2D,n.TEXTURE_2D,1),Se[n.TEXTURE_CUBE_MAP]=se(n.TEXTURE_CUBE_MAP,n.TEXTURE_CUBE_MAP_POSITIVE_X,6),Se[n.TEXTURE_2D_ARRAY]=se(n.TEXTURE_2D_ARRAY,n.TEXTURE_2D_ARRAY,1,1),Se[n.TEXTURE_3D]=se(n.TEXTURE_3D,n.TEXTURE_3D,1,1),s.setClear(0,0,0,1),o.setClear(1),a.setClear(0),me(n.DEPTH_TEST),o.setFunc(zr),Q(!1),le(qu),me(n.CULL_FACE),ee(oi);function me(F){u[F]!==!0&&(n.enable(F),u[F]=!0)}function Be(F){u[F]!==!1&&(n.disable(F),u[F]=!1)}function He(F,xe){return f[F]!==xe?(n.bindFramebuffer(F,xe),f[F]=xe,F===n.DRAW_FRAMEBUFFER&&(f[n.FRAMEBUFFER]=xe),F===n.FRAMEBUFFER&&(f[n.DRAW_FRAMEBUFFER]=xe),!0):!1}function Ve(F,xe){let te=g,Ce=!1;if(F){te=p.get(xe),te===void 0&&(te=[],p.set(xe,te));const Me=F.textures;if(te.length!==Me.length||te[0]!==n.COLOR_ATTACHMENT0){for(let ae=0,Ue=Me.length;ae<Ue;ae++)te[ae]=n.COLOR_ATTACHMENT0+ae;te.length=Me.length,Ce=!0}}else te[0]!==n.BACK&&(te[0]=n.BACK,Ce=!0);Ce&&n.drawBuffers(te)}function R(F){return M!==F?(n.useProgram(F),M=F,!0):!1}const U={[$i]:n.FUNC_ADD,[h_]:n.FUNC_SUBTRACT,[d_]:n.FUNC_REVERSE_SUBTRACT};U[p_]=n.MIN,U[m_]=n.MAX;const W={[g_]:n.ZERO,[__]:n.ONE,[x_]:n.SRC_COLOR,[wl]:n.SRC_ALPHA,[b_]:n.SRC_ALPHA_SATURATE,[E_]:n.DST_COLOR,[M_]:n.DST_ALPHA,[v_]:n.ONE_MINUS_SRC_COLOR,[Rl]:n.ONE_MINUS_SRC_ALPHA,[y_]:n.ONE_MINUS_DST_COLOR,[S_]:n.ONE_MINUS_DST_ALPHA,[T_]:n.CONSTANT_COLOR,[A_]:n.ONE_MINUS_CONSTANT_COLOR,[w_]:n.CONSTANT_ALPHA,[R_]:n.ONE_MINUS_CONSTANT_ALPHA};function ee(F,xe,te,Ce,Me,ae,Ue,Ye,yt,ft){if(F===oi){m===!0&&(Be(n.BLEND),m=!1);return}if(m===!1&&(me(n.BLEND),m=!0),F!==f_){if(F!==d||ft!==L){if((x!==$i||C!==$i)&&(n.blendEquation(n.FUNC_ADD),x=$i,C=$i),ft)switch(F){case Ur:n.blendFuncSeparate(n.ONE,n.ONE_MINUS_SRC_ALPHA,n.ONE,n.ONE_MINUS_SRC_ALPHA);break;case Ku:n.blendFunc(n.ONE,n.ONE);break;case ju:n.blendFuncSeparate(n.ZERO,n.ONE_MINUS_SRC_COLOR,n.ZERO,n.ONE);break;case Zu:n.blendFuncSeparate(n.DST_COLOR,n.ONE_MINUS_SRC_ALPHA,n.ZERO,n.ONE);break;default:et("WebGLState: Invalid blending: ",F);break}else switch(F){case Ur:n.blendFuncSeparate(n.SRC_ALPHA,n.ONE_MINUS_SRC_ALPHA,n.ONE,n.ONE_MINUS_SRC_ALPHA);break;case Ku:n.blendFuncSeparate(n.SRC_ALPHA,n.ONE,n.ONE,n.ONE);break;case ju:et("WebGLState: SubtractiveBlending requires material.premultipliedAlpha = true");break;case Zu:et("WebGLState: MultiplyBlending requires material.premultipliedAlpha = true");break;default:et("WebGLState: Invalid blending: ",F);break}y=null,S=null,A=null,P=null,v.set(0,0,0),T=0,d=F,L=ft}return}Me=Me||xe,ae=ae||te,Ue=Ue||Ce,(xe!==x||Me!==C)&&(n.blendEquationSeparate(U[xe],U[Me]),x=xe,C=Me),(te!==y||Ce!==S||ae!==A||Ue!==P)&&(n.blendFuncSeparate(W[te],W[Ce],W[ae],W[Ue]),y=te,S=Ce,A=ae,P=Ue),(Ye.equals(v)===!1||yt!==T)&&(n.blendColor(Ye.r,Ye.g,Ye.b,yt),v.copy(Ye),T=yt),d=F,L=!1}function K(F,xe){F.side===zn?Be(n.CULL_FACE):me(n.CULL_FACE);let te=F.side===on;xe&&(te=!te),Q(te),F.blending===Ur&&F.transparent===!1?ee(oi):ee(F.blending,F.blendEquation,F.blendSrc,F.blendDst,F.blendEquationAlpha,F.blendSrcAlpha,F.blendDstAlpha,F.blendColor,F.blendAlpha,F.premultipliedAlpha),o.setFunc(F.depthFunc),o.setTest(F.depthTest),o.setMask(F.depthWrite),s.setMask(F.colorWrite);const Ce=F.stencilWrite;a.setTest(Ce),Ce&&(a.setMask(F.stencilWriteMask),a.setFunc(F.stencilFunc,F.stencilRef,F.stencilFuncMask),a.setOp(F.stencilFail,F.stencilZFail,F.stencilZPass)),w(F.polygonOffset,F.polygonOffsetFactor,F.polygonOffsetUnits),F.alphaToCoverage===!0?me(n.SAMPLE_ALPHA_TO_COVERAGE):Be(n.SAMPLE_ALPHA_TO_COVERAGE)}function Q(F){D!==F&&(F?n.frontFace(n.CW):n.frontFace(n.CCW),D=F)}function le(F){F!==l_?(me(n.CULL_FACE),F!==I&&(F===qu?n.cullFace(n.BACK):F===c_?n.cullFace(n.FRONT):n.cullFace(n.FRONT_AND_BACK))):Be(n.CULL_FACE),I=F}function fe(F){F!==k&&(H&&n.lineWidth(F),k=F)}function w(F,xe,te){F?(me(n.POLYGON_OFFSET_FILL),(G!==xe||O!==te)&&(G=xe,O=te,o.getReversed()&&(xe=-xe),n.polygonOffset(xe,te))):Be(n.POLYGON_OFFSET_FILL)}function ne(F){F?me(n.SCISSOR_TEST):Be(n.SCISSOR_TEST)}function pe(F){F===void 0&&(F=n.TEXTURE0+V-1),ve!==F&&(n.activeTexture(F),ve=F)}function ce(F,xe,te){te===void 0&&(ve===null?te=n.TEXTURE0+V-1:te=ve);let Ce=be[te];Ce===void 0&&(Ce={type:void 0,texture:void 0},be[te]=Ce),(Ce.type!==F||Ce.texture!==xe)&&(ve!==te&&(n.activeTexture(te),ve=te),n.bindTexture(F,xe||Se[F]),Ce.type=F,Ce.texture=xe)}function J(){const F=be[ve];F!==void 0&&F.type!==void 0&&(n.bindTexture(F.type,null),F.type=void 0,F.texture=void 0)}function Re(){try{n.compressedTexImage2D(...arguments)}catch(F){et("WebGLState:",F)}}function b(){try{n.compressedTexImage3D(...arguments)}catch(F){et("WebGLState:",F)}}function _(){try{n.texSubImage2D(...arguments)}catch(F){et("WebGLState:",F)}}function B(){try{n.texSubImage3D(...arguments)}catch(F){et("WebGLState:",F)}}function j(){try{n.compressedTexSubImage2D(...arguments)}catch(F){et("WebGLState:",F)}}function ie(){try{n.compressedTexSubImage3D(...arguments)}catch(F){et("WebGLState:",F)}}function ue(){try{n.texStorage2D(...arguments)}catch(F){et("WebGLState:",F)}}function he(){try{n.texStorage3D(...arguments)}catch(F){et("WebGLState:",F)}}function Z(){try{n.texImage2D(...arguments)}catch(F){et("WebGLState:",F)}}function re(){try{n.texImage3D(...arguments)}catch(F){et("WebGLState:",F)}}function ge(F){return h[F]!==void 0?h[F]:n.getParameter(F)}function Ee(F,xe){h[F]!==xe&&(n.pixelStorei(F,xe),h[F]=xe)}function _e(F){tt.equals(F)===!1&&(n.scissor(F.x,F.y,F.z,F.w),tt.copy(F))}function de(F){We.equals(F)===!1&&(n.viewport(F.x,F.y,F.z,F.w),We.copy(F))}function ke(F,xe){let te=c.get(xe);te===void 0&&(te=new WeakMap,c.set(xe,te));let Ce=te.get(F);Ce===void 0&&(Ce=n.getUniformBlockIndex(xe,F.name),te.set(F,Ce))}function Ke(F,xe){const Ce=c.get(xe).get(F);l.get(xe)!==Ce&&(n.uniformBlockBinding(xe,Ce,F.__bindingPointIndex),l.set(xe,Ce))}function rt(){n.disable(n.BLEND),n.disable(n.CULL_FACE),n.disable(n.DEPTH_TEST),n.disable(n.POLYGON_OFFSET_FILL),n.disable(n.SCISSOR_TEST),n.disable(n.STENCIL_TEST),n.disable(n.SAMPLE_ALPHA_TO_COVERAGE),n.blendEquation(n.FUNC_ADD),n.blendFunc(n.ONE,n.ZERO),n.blendFuncSeparate(n.ONE,n.ZERO,n.ONE,n.ZERO),n.blendColor(0,0,0,0),n.colorMask(!0,!0,!0,!0),n.clearColor(0,0,0,0),n.depthMask(!0),n.depthFunc(n.LESS),o.setReversed(!1),n.clearDepth(1),n.stencilMask(4294967295),n.stencilFunc(n.ALWAYS,0,4294967295),n.stencilOp(n.KEEP,n.KEEP,n.KEEP),n.clearStencil(0),n.cullFace(n.BACK),n.frontFace(n.CCW),n.polygonOffset(0,0),n.activeTexture(n.TEXTURE0),n.bindFramebuffer(n.FRAMEBUFFER,null),n.bindFramebuffer(n.DRAW_FRAMEBUFFER,null),n.bindFramebuffer(n.READ_FRAMEBUFFER,null),n.useProgram(null),n.lineWidth(1),n.scissor(0,0,n.canvas.width,n.canvas.height),n.viewport(0,0,n.canvas.width,n.canvas.height),n.pixelStorei(n.PACK_ALIGNMENT,4),n.pixelStorei(n.UNPACK_ALIGNMENT,4),n.pixelStorei(n.UNPACK_FLIP_Y_WEBGL,!1),n.pixelStorei(n.UNPACK_PREMULTIPLY_ALPHA_WEBGL,!1),n.pixelStorei(n.UNPACK_COLORSPACE_CONVERSION_WEBGL,n.BROWSER_DEFAULT_WEBGL),n.pixelStorei(n.PACK_ROW_LENGTH,0),n.pixelStorei(n.PACK_SKIP_PIXELS,0),n.pixelStorei(n.PACK_SKIP_ROWS,0),n.pixelStorei(n.UNPACK_ROW_LENGTH,0),n.pixelStorei(n.UNPACK_IMAGE_HEIGHT,0),n.pixelStorei(n.UNPACK_SKIP_PIXELS,0),n.pixelStorei(n.UNPACK_SKIP_ROWS,0),n.pixelStorei(n.UNPACK_SKIP_IMAGES,0),u={},h={},ve=null,be={},f={},p=new WeakMap,g=[],M=null,m=!1,d=null,x=null,y=null,S=null,C=null,A=null,P=null,v=new lt(0,0,0),T=0,L=!1,D=null,I=null,k=null,G=null,O=null,tt.set(0,0,n.canvas.width,n.canvas.height),We.set(0,0,n.canvas.width,n.canvas.height),s.reset(),o.reset(),a.reset()}return{buffers:{color:s,depth:o,stencil:a},enable:me,disable:Be,bindFramebuffer:He,drawBuffers:Ve,useProgram:R,setBlending:ee,setMaterial:K,setFlipSided:Q,setCullFace:le,setLineWidth:fe,setPolygonOffset:w,setScissorTest:ne,activeTexture:pe,bindTexture:ce,unbindTexture:J,compressedTexImage2D:Re,compressedTexImage3D:b,texImage2D:Z,texImage3D:re,pixelStorei:Ee,getParameter:ge,updateUBOMapping:ke,uniformBlockBinding:Ke,texStorage2D:ue,texStorage3D:he,texSubImage2D:_,texSubImage3D:B,compressedTexSubImage2D:j,compressedTexSubImage3D:ie,scissor:_e,viewport:de,reset:rt}}function TE(n,e,t,i,r,s,o){const a=e.has("WEBGL_multisampled_render_to_texture")?e.get("WEBGL_multisampled_render_to_texture"):null,l=typeof navigator>"u"?!1:/OculusBrowser/g.test(navigator.userAgent),c=new st,u=new WeakMap,h=new Set;let f;const p=new WeakMap;let g=!1;try{g=typeof OffscreenCanvas<"u"&&new OffscreenCanvas(1,1).getContext("2d")!==null}catch{}function M(b,_){return g?new OffscreenCanvas(b,_):Ko("canvas")}function m(b,_,B){let j=1;const ie=Re(b);if((ie.width>B||ie.height>B)&&(j=B/Math.max(ie.width,ie.height)),j<1)if(typeof HTMLImageElement<"u"&&b instanceof HTMLImageElement||typeof HTMLCanvasElement<"u"&&b instanceof HTMLCanvasElement||typeof ImageBitmap<"u"&&b instanceof ImageBitmap||typeof VideoFrame<"u"&&b instanceof VideoFrame){const ue=Math.floor(j*ie.width),he=Math.floor(j*ie.height);f===void 0&&(f=M(ue,he));const Z=_?M(ue,he):f;return Z.width=ue,Z.height=he,Z.getContext("2d").drawImage(b,0,0,ue,he),ze("WebGLRenderer: Texture has been resized from ("+ie.width+"x"+ie.height+") to ("+ue+"x"+he+")."),Z}else return"data"in b&&ze("WebGLRenderer: Image in DataTexture is too big ("+ie.width+"x"+ie.height+")."),b;return b}function d(b){return b.generateMipmaps}function x(b){n.generateMipmap(b)}function y(b){return b.isWebGLCubeRenderTarget?n.TEXTURE_CUBE_MAP:b.isWebGL3DRenderTarget?n.TEXTURE_3D:b.isWebGLArrayRenderTarget||b.isCompressedArrayTexture?n.TEXTURE_2D_ARRAY:n.TEXTURE_2D}function S(b,_,B,j,ie,ue=!1){if(b!==null){if(n[b]!==void 0)return n[b];ze("WebGLRenderer: Attempt to use non-existing WebGL internal format '"+b+"'")}let he;j&&(he=e.get("EXT_texture_norm16"),he||ze("WebGLRenderer: Unable to use normalized textures without EXT_texture_norm16 extension"));let Z=_;if(_===n.RED&&(B===n.FLOAT&&(Z=n.R32F),B===n.HALF_FLOAT&&(Z=n.R16F),B===n.UNSIGNED_BYTE&&(Z=n.R8),B===n.UNSIGNED_SHORT&&he&&(Z=he.R16_EXT),B===n.SHORT&&he&&(Z=he.R16_SNORM_EXT)),_===n.RED_INTEGER&&(B===n.UNSIGNED_BYTE&&(Z=n.R8UI),B===n.UNSIGNED_SHORT&&(Z=n.R16UI),B===n.UNSIGNED_INT&&(Z=n.R32UI),B===n.BYTE&&(Z=n.R8I),B===n.SHORT&&(Z=n.R16I),B===n.INT&&(Z=n.R32I)),_===n.RG&&(B===n.FLOAT&&(Z=n.RG32F),B===n.HALF_FLOAT&&(Z=n.RG16F),B===n.UNSIGNED_BYTE&&(Z=n.RG8),B===n.UNSIGNED_SHORT&&he&&(Z=he.RG16_EXT),B===n.SHORT&&he&&(Z=he.RG16_SNORM_EXT)),_===n.RG_INTEGER&&(B===n.UNSIGNED_BYTE&&(Z=n.RG8UI),B===n.UNSIGNED_SHORT&&(Z=n.RG16UI),B===n.UNSIGNED_INT&&(Z=n.RG32UI),B===n.BYTE&&(Z=n.RG8I),B===n.SHORT&&(Z=n.RG16I),B===n.INT&&(Z=n.RG32I)),_===n.RGB_INTEGER&&(B===n.UNSIGNED_BYTE&&(Z=n.RGB8UI),B===n.UNSIGNED_SHORT&&(Z=n.RGB16UI),B===n.UNSIGNED_INT&&(Z=n.RGB32UI),B===n.BYTE&&(Z=n.RGB8I),B===n.SHORT&&(Z=n.RGB16I),B===n.INT&&(Z=n.RGB32I)),_===n.RGBA_INTEGER&&(B===n.UNSIGNED_BYTE&&(Z=n.RGBA8UI),B===n.UNSIGNED_SHORT&&(Z=n.RGBA16UI),B===n.UNSIGNED_INT&&(Z=n.RGBA32UI),B===n.BYTE&&(Z=n.RGBA8I),B===n.SHORT&&(Z=n.RGBA16I),B===n.INT&&(Z=n.RGBA32I)),_===n.RGB&&(B===n.UNSIGNED_SHORT&&he&&(Z=he.RGB16_EXT),B===n.SHORT&&he&&(Z=he.RGB16_SNORM_EXT),B===n.UNSIGNED_INT_5_9_9_9_REV&&(Z=n.RGB9_E5),B===n.UNSIGNED_INT_10F_11F_11F_REV&&(Z=n.R11F_G11F_B10F)),_===n.RGBA){const re=ue?Yo:Qe.getTransfer(ie);B===n.FLOAT&&(Z=n.RGBA32F),B===n.HALF_FLOAT&&(Z=n.RGBA16F),B===n.UNSIGNED_BYTE&&(Z=re===ut?n.SRGB8_ALPHA8:n.RGBA8),B===n.UNSIGNED_SHORT&&he&&(Z=he.RGBA16_EXT),B===n.SHORT&&he&&(Z=he.RGBA16_SNORM_EXT),B===n.UNSIGNED_SHORT_4_4_4_4&&(Z=n.RGBA4),B===n.UNSIGNED_SHORT_5_5_5_1&&(Z=n.RGB5_A1)}return(Z===n.R16F||Z===n.R32F||Z===n.RG16F||Z===n.RG32F||Z===n.RGBA16F||Z===n.RGBA32F)&&e.get("EXT_color_buffer_float"),Z}function C(b,_){let B;return b?_===null||_===Yn||_===As?B=n.DEPTH24_STENCIL8:_===Hn?B=n.DEPTH32F_STENCIL8:_===Ts&&(B=n.DEPTH24_STENCIL8,ze("DepthTexture: 16 bit depth attachment is not supported with stencil. Using 24-bit attachment.")):_===null||_===Yn||_===As?B=n.DEPTH_COMPONENT24:_===Hn?B=n.DEPTH_COMPONENT32F:_===Ts&&(B=n.DEPTH_COMPONENT16),B}function A(b,_){return d(b)===!0||b.isFramebufferTexture&&b.minFilter!==zt&&b.minFilter!==jt?Math.log2(Math.max(_.width,_.height))+1:b.mipmaps!==void 0&&b.mipmaps.length>0?b.mipmaps.length:b.isCompressedTexture&&Array.isArray(b.image)?_.mipmaps.length:1}function P(b){const _=b.target;_.removeEventListener("dispose",P),T(_),_.isVideoTexture&&u.delete(_),_.isHTMLTexture&&h.delete(_)}function v(b){const _=b.target;_.removeEventListener("dispose",v),D(_)}function T(b){const _=i.get(b);if(_.__webglInit===void 0)return;const B=b.source,j=p.get(B);if(j){const ie=j[_.__cacheKey];ie.usedTimes--,ie.usedTimes===0&&L(b),Object.keys(j).length===0&&p.delete(B)}i.remove(b)}function L(b){const _=i.get(b);n.deleteTexture(_.__webglTexture);const B=b.source,j=p.get(B);delete j[_.__cacheKey],o.memory.textures--}function D(b){const _=i.get(b);if(b.depthTexture&&(b.depthTexture.dispose(),i.remove(b.depthTexture)),b.isWebGLCubeRenderTarget)for(let j=0;j<6;j++){if(Array.isArray(_.__webglFramebuffer[j]))for(let ie=0;ie<_.__webglFramebuffer[j].length;ie++)n.deleteFramebuffer(_.__webglFramebuffer[j][ie]);else n.deleteFramebuffer(_.__webglFramebuffer[j]);_.__webglDepthbuffer&&n.deleteRenderbuffer(_.__webglDepthbuffer[j])}else{if(Array.isArray(_.__webglFramebuffer))for(let j=0;j<_.__webglFramebuffer.length;j++)n.deleteFramebuffer(_.__webglFramebuffer[j]);else n.deleteFramebuffer(_.__webglFramebuffer);if(_.__webglDepthbuffer&&n.deleteRenderbuffer(_.__webglDepthbuffer),_.__webglMultisampledFramebuffer&&n.deleteFramebuffer(_.__webglMultisampledFramebuffer),_.__webglColorRenderbuffer)for(let j=0;j<_.__webglColorRenderbuffer.length;j++)_.__webglColorRenderbuffer[j]&&n.deleteRenderbuffer(_.__webglColorRenderbuffer[j]);_.__webglDepthRenderbuffer&&n.deleteRenderbuffer(_.__webglDepthRenderbuffer)}const B=b.textures;for(let j=0,ie=B.length;j<ie;j++){const ue=i.get(B[j]);ue.__webglTexture&&(n.deleteTexture(ue.__webglTexture),o.memory.textures--),i.remove(B[j])}i.remove(b)}let I=0;function k(){I=0}function G(){return I}function O(b){I=b}function V(){const b=I;return b>=r.maxTextures&&ze("WebGLTextures: Trying to use "+b+" texture units while this GPU supports only "+r.maxTextures),I+=1,b}function H(b){const _=[];return _.push(b.wrapS),_.push(b.wrapT),_.push(b.wrapR||0),_.push(b.magFilter),_.push(b.minFilter),_.push(b.anisotropy),_.push(b.internalFormat),_.push(b.format),_.push(b.type),_.push(b.generateMipmaps),_.push(b.premultiplyAlpha),_.push(b.flipY),_.push(b.unpackAlignment),_.push(b.colorSpace),_.join()}function $(b,_){const B=i.get(b);if(b.isVideoTexture&&ce(b),b.isRenderTargetTexture===!1&&b.isExternalTexture!==!0&&b.version>0&&B.__version!==b.version){const j=b.image;if(j===null)ze("WebGLRenderer: Texture marked for update but no image data found.");else if(j.complete===!1)ze("WebGLRenderer: Texture marked for update but image is incomplete");else{Be(B,b,_);return}}else b.isExternalTexture&&(B.__webglTexture=b.sourceTexture?b.sourceTexture:null);t.bindTexture(n.TEXTURE_2D,B.__webglTexture,n.TEXTURE0+_)}function oe(b,_){const B=i.get(b);if(b.isRenderTargetTexture===!1&&b.version>0&&B.__version!==b.version){Be(B,b,_);return}else b.isExternalTexture&&(B.__webglTexture=b.sourceTexture?b.sourceTexture:null);t.bindTexture(n.TEXTURE_2D_ARRAY,B.__webglTexture,n.TEXTURE0+_)}function ve(b,_){const B=i.get(b);if(b.isRenderTargetTexture===!1&&b.version>0&&B.__version!==b.version){Be(B,b,_);return}t.bindTexture(n.TEXTURE_3D,B.__webglTexture,n.TEXTURE0+_)}function be(b,_){const B=i.get(b);if(b.isCubeDepthTexture!==!0&&b.version>0&&B.__version!==b.version){He(B,b,_);return}t.bindTexture(n.TEXTURE_CUBE_MAP,B.__webglTexture,n.TEXTURE0+_)}const we={[Fl]:n.REPEAT,[si]:n.CLAMP_TO_EDGE,[Ol]:n.MIRRORED_REPEAT},$e={[zt]:n.NEAREST,[D_]:n.NEAREST_MIPMAP_NEAREST,[Ws]:n.NEAREST_MIPMAP_LINEAR,[jt]:n.LINEAR,[Ua]:n.LINEAR_MIPMAP_NEAREST,[er]:n.LINEAR_MIPMAP_LINEAR},tt={[U_]:n.NEVER,[z_]:n.ALWAYS,[N_]:n.LESS,[Wc]:n.LEQUAL,[F_]:n.EQUAL,[Xc]:n.GEQUAL,[O_]:n.GREATER,[B_]:n.NOTEQUAL};function We(b,_){if(_.type===Hn&&e.has("OES_texture_float_linear")===!1&&(_.magFilter===jt||_.magFilter===Ua||_.magFilter===Ws||_.magFilter===er||_.minFilter===jt||_.minFilter===Ua||_.minFilter===Ws||_.minFilter===er)&&ze("WebGLRenderer: Unable to use linear filtering with floating point textures. OES_texture_float_linear not supported on this device."),n.texParameteri(b,n.TEXTURE_WRAP_S,we[_.wrapS]),n.texParameteri(b,n.TEXTURE_WRAP_T,we[_.wrapT]),(b===n.TEXTURE_3D||b===n.TEXTURE_2D_ARRAY)&&n.texParameteri(b,n.TEXTURE_WRAP_R,we[_.wrapR]),n.texParameteri(b,n.TEXTURE_MAG_FILTER,$e[_.magFilter]),n.texParameteri(b,n.TEXTURE_MIN_FILTER,$e[_.minFilter]),_.compareFunction&&(n.texParameteri(b,n.TEXTURE_COMPARE_MODE,n.COMPARE_REF_TO_TEXTURE),n.texParameteri(b,n.TEXTURE_COMPARE_FUNC,tt[_.compareFunction])),e.has("EXT_texture_filter_anisotropic")===!0){if(_.magFilter===zt||_.minFilter!==Ws&&_.minFilter!==er||_.type===Hn&&e.has("OES_texture_float_linear")===!1)return;if(_.anisotropy>1||i.get(_).__currentAnisotropy){const B=e.get("EXT_texture_filter_anisotropic");n.texParameterf(b,B.TEXTURE_MAX_ANISOTROPY_EXT,Math.min(_.anisotropy,r.getMaxAnisotropy())),i.get(_).__currentAnisotropy=_.anisotropy}}}function se(b,_){let B=!1;b.__webglInit===void 0&&(b.__webglInit=!0,_.addEventListener("dispose",P));const j=_.source;let ie=p.get(j);ie===void 0&&(ie={},p.set(j,ie));const ue=H(_);if(ue!==b.__cacheKey){ie[ue]===void 0&&(ie[ue]={texture:n.createTexture(),usedTimes:0},o.memory.textures++,B=!0),ie[ue].usedTimes++;const he=ie[b.__cacheKey];he!==void 0&&(ie[b.__cacheKey].usedTimes--,he.usedTimes===0&&L(_)),b.__cacheKey=ue,b.__webglTexture=ie[ue].texture}return B}function Se(b,_,B){return Math.floor(Math.floor(b/B)/_)}function me(b,_,B,j){const ue=b.updateRanges;if(ue.length===0)t.texSubImage2D(n.TEXTURE_2D,0,0,0,_.width,_.height,B,j,_.data);else{ue.sort((Ee,_e)=>Ee.start-_e.start);let he=0;for(let Ee=1;Ee<ue.length;Ee++){const _e=ue[he],de=ue[Ee],ke=_e.start+_e.count,Ke=Se(de.start,_.width,4),rt=Se(_e.start,_.width,4);de.start<=ke+1&&Ke===rt&&Se(de.start+de.count-1,_.width,4)===Ke?_e.count=Math.max(_e.count,de.start+de.count-_e.start):(++he,ue[he]=de)}ue.length=he+1;const Z=t.getParameter(n.UNPACK_ROW_LENGTH),re=t.getParameter(n.UNPACK_SKIP_PIXELS),ge=t.getParameter(n.UNPACK_SKIP_ROWS);t.pixelStorei(n.UNPACK_ROW_LENGTH,_.width);for(let Ee=0,_e=ue.length;Ee<_e;Ee++){const de=ue[Ee],ke=Math.floor(de.start/4),Ke=Math.ceil(de.count/4),rt=ke%_.width,F=Math.floor(ke/_.width),xe=Ke,te=1;t.pixelStorei(n.UNPACK_SKIP_PIXELS,rt),t.pixelStorei(n.UNPACK_SKIP_ROWS,F),t.texSubImage2D(n.TEXTURE_2D,0,rt,F,xe,te,B,j,_.data)}b.clearUpdateRanges(),t.pixelStorei(n.UNPACK_ROW_LENGTH,Z),t.pixelStorei(n.UNPACK_SKIP_PIXELS,re),t.pixelStorei(n.UNPACK_SKIP_ROWS,ge)}}function Be(b,_,B){let j=n.TEXTURE_2D;(_.isDataArrayTexture||_.isCompressedArrayTexture)&&(j=n.TEXTURE_2D_ARRAY),_.isData3DTexture&&(j=n.TEXTURE_3D);const ie=se(b,_),ue=_.source;t.bindTexture(j,b.__webglTexture,n.TEXTURE0+B);const he=i.get(ue);if(ue.version!==he.__version||ie===!0){if(t.activeTexture(n.TEXTURE0+B),(typeof ImageBitmap<"u"&&_.image instanceof ImageBitmap)===!1){const te=Qe.getPrimaries(Qe.workingColorSpace),Ce=_.colorSpace===Pi?null:Qe.getPrimaries(_.colorSpace),Me=_.colorSpace===Pi||te===Ce?n.NONE:n.BROWSER_DEFAULT_WEBGL;t.pixelStorei(n.UNPACK_FLIP_Y_WEBGL,_.flipY),t.pixelStorei(n.UNPACK_PREMULTIPLY_ALPHA_WEBGL,_.premultiplyAlpha),t.pixelStorei(n.UNPACK_COLORSPACE_CONVERSION_WEBGL,Me)}t.pixelStorei(n.UNPACK_ALIGNMENT,_.unpackAlignment);let re=m(_.image,!1,r.maxTextureSize);re=J(_,re);const ge=s.convert(_.format,_.colorSpace),Ee=s.convert(_.type);let _e=S(_.internalFormat,ge,Ee,_.normalized,_.colorSpace,_.isVideoTexture);We(j,_);let de;const ke=_.mipmaps,Ke=_.isVideoTexture!==!0,rt=he.__version===void 0||ie===!0,F=ue.dataReady,xe=A(_,re);if(_.isDepthTexture)_e=C(_.format===tr,_.type),rt&&(Ke?t.texStorage2D(n.TEXTURE_2D,1,_e,re.width,re.height):t.texImage2D(n.TEXTURE_2D,0,_e,re.width,re.height,0,ge,Ee,null));else if(_.isDataTexture)if(ke.length>0){Ke&&rt&&t.texStorage2D(n.TEXTURE_2D,xe,_e,ke[0].width,ke[0].height);for(let te=0,Ce=ke.length;te<Ce;te++)de=ke[te],Ke?F&&t.texSubImage2D(n.TEXTURE_2D,te,0,0,de.width,de.height,ge,Ee,de.data):t.texImage2D(n.TEXTURE_2D,te,_e,de.width,de.height,0,ge,Ee,de.data);_.generateMipmaps=!1}else Ke?(rt&&t.texStorage2D(n.TEXTURE_2D,xe,_e,re.width,re.height),F&&me(_,re,ge,Ee)):t.texImage2D(n.TEXTURE_2D,0,_e,re.width,re.height,0,ge,Ee,re.data);else if(_.isCompressedTexture)if(_.isCompressedArrayTexture){Ke&&rt&&t.texStorage3D(n.TEXTURE_2D_ARRAY,xe,_e,ke[0].width,ke[0].height,re.depth);for(let te=0,Ce=ke.length;te<Ce;te++)if(de=ke[te],_.format!==Tn)if(ge!==null)if(Ke){if(F)if(_.layerUpdates.size>0){const Me=Af(de.width,de.height,_.format,_.type);for(const ae of _.layerUpdates){const Ue=de.data.subarray(ae*Me/de.data.BYTES_PER_ELEMENT,(ae+1)*Me/de.data.BYTES_PER_ELEMENT);t.compressedTexSubImage3D(n.TEXTURE_2D_ARRAY,te,0,0,ae,de.width,de.height,1,ge,Ue)}_.clearLayerUpdates()}else t.compressedTexSubImage3D(n.TEXTURE_2D_ARRAY,te,0,0,0,de.width,de.height,re.depth,ge,de.data)}else t.compressedTexImage3D(n.TEXTURE_2D_ARRAY,te,_e,de.width,de.height,re.depth,0,de.data,0,0);else ze("WebGLRenderer: Attempt to load unsupported compressed texture format in .uploadTexture()");else Ke?F&&t.texSubImage3D(n.TEXTURE_2D_ARRAY,te,0,0,0,de.width,de.height,re.depth,ge,Ee,de.data):t.texImage3D(n.TEXTURE_2D_ARRAY,te,_e,de.width,de.height,re.depth,0,ge,Ee,de.data)}else{Ke&&rt&&t.texStorage2D(n.TEXTURE_2D,xe,_e,ke[0].width,ke[0].height);for(let te=0,Ce=ke.length;te<Ce;te++)de=ke[te],_.format!==Tn?ge!==null?Ke?F&&t.compressedTexSubImage2D(n.TEXTURE_2D,te,0,0,de.width,de.height,ge,de.data):t.compressedTexImage2D(n.TEXTURE_2D,te,_e,de.width,de.height,0,de.data):ze("WebGLRenderer: Attempt to load unsupported compressed texture format in .uploadTexture()"):Ke?F&&t.texSubImage2D(n.TEXTURE_2D,te,0,0,de.width,de.height,ge,Ee,de.data):t.texImage2D(n.TEXTURE_2D,te,_e,de.width,de.height,0,ge,Ee,de.data)}else if(_.isDataArrayTexture)if(Ke){if(rt&&t.texStorage3D(n.TEXTURE_2D_ARRAY,xe,_e,re.width,re.height,re.depth),F)if(_.layerUpdates.size>0){const te=Af(re.width,re.height,_.format,_.type);for(const Ce of _.layerUpdates){const Me=re.data.subarray(Ce*te/re.data.BYTES_PER_ELEMENT,(Ce+1)*te/re.data.BYTES_PER_ELEMENT);t.texSubImage3D(n.TEXTURE_2D_ARRAY,0,0,0,Ce,re.width,re.height,1,ge,Ee,Me)}_.clearLayerUpdates()}else t.texSubImage3D(n.TEXTURE_2D_ARRAY,0,0,0,0,re.width,re.height,re.depth,ge,Ee,re.data)}else t.texImage3D(n.TEXTURE_2D_ARRAY,0,_e,re.width,re.height,re.depth,0,ge,Ee,re.data);else if(_.isData3DTexture)Ke?(rt&&t.texStorage3D(n.TEXTURE_3D,xe,_e,re.width,re.height,re.depth),F&&t.texSubImage3D(n.TEXTURE_3D,0,0,0,0,re.width,re.height,re.depth,ge,Ee,re.data)):t.texImage3D(n.TEXTURE_3D,0,_e,re.width,re.height,re.depth,0,ge,Ee,re.data);else if(_.isFramebufferTexture){if(rt)if(Ke)t.texStorage2D(n.TEXTURE_2D,xe,_e,re.width,re.height);else{let te=re.width,Ce=re.height;for(let Me=0;Me<xe;Me++)t.texImage2D(n.TEXTURE_2D,Me,_e,te,Ce,0,ge,Ee,null),te>>=1,Ce>>=1}}else if(_.isHTMLTexture){if("texElementImage2D"in n){const te=n.canvas;if(te.hasAttribute("layoutsubtree")||te.setAttribute("layoutsubtree","true"),re.parentNode!==te){te.appendChild(re),h.add(_),te.onpaint=Ye=>{const yt=Ye.changedElements;for(const ft of h)yt.includes(ft.image)&&(ft.needsUpdate=!0)},te.requestPaint();return}const Ce=0,Me=n.RGBA,ae=n.RGBA,Ue=n.UNSIGNED_BYTE;n.texElementImage2D(n.TEXTURE_2D,Ce,Me,ae,Ue,re),n.texParameteri(n.TEXTURE_2D,n.TEXTURE_MIN_FILTER,n.LINEAR),n.texParameteri(n.TEXTURE_2D,n.TEXTURE_WRAP_S,n.CLAMP_TO_EDGE),n.texParameteri(n.TEXTURE_2D,n.TEXTURE_WRAP_T,n.CLAMP_TO_EDGE)}}else if(ke.length>0){if(Ke&&rt){const te=Re(ke[0]);t.texStorage2D(n.TEXTURE_2D,xe,_e,te.width,te.height)}for(let te=0,Ce=ke.length;te<Ce;te++)de=ke[te],Ke?F&&t.texSubImage2D(n.TEXTURE_2D,te,0,0,ge,Ee,de):t.texImage2D(n.TEXTURE_2D,te,_e,ge,Ee,de);_.generateMipmaps=!1}else if(Ke){if(rt){const te=Re(re);t.texStorage2D(n.TEXTURE_2D,xe,_e,te.width,te.height)}F&&t.texSubImage2D(n.TEXTURE_2D,0,0,0,ge,Ee,re)}else t.texImage2D(n.TEXTURE_2D,0,_e,ge,Ee,re);d(_)&&x(j),he.__version=ue.version,_.onUpdate&&_.onUpdate(_)}b.__version=_.version}function He(b,_,B){if(_.image.length!==6)return;const j=se(b,_),ie=_.source;t.bindTexture(n.TEXTURE_CUBE_MAP,b.__webglTexture,n.TEXTURE0+B);const ue=i.get(ie);if(ie.version!==ue.__version||j===!0){t.activeTexture(n.TEXTURE0+B);const he=Qe.getPrimaries(Qe.workingColorSpace),Z=_.colorSpace===Pi?null:Qe.getPrimaries(_.colorSpace),re=_.colorSpace===Pi||he===Z?n.NONE:n.BROWSER_DEFAULT_WEBGL;t.pixelStorei(n.UNPACK_FLIP_Y_WEBGL,_.flipY),t.pixelStorei(n.UNPACK_PREMULTIPLY_ALPHA_WEBGL,_.premultiplyAlpha),t.pixelStorei(n.UNPACK_ALIGNMENT,_.unpackAlignment),t.pixelStorei(n.UNPACK_COLORSPACE_CONVERSION_WEBGL,re);const ge=_.isCompressedTexture||_.image[0].isCompressedTexture,Ee=_.image[0]&&_.image[0].isDataTexture,_e=[];for(let ae=0;ae<6;ae++)!ge&&!Ee?_e[ae]=m(_.image[ae],!0,r.maxCubemapSize):_e[ae]=Ee?_.image[ae].image:_.image[ae],_e[ae]=J(_,_e[ae]);const de=_e[0],ke=s.convert(_.format,_.colorSpace),Ke=s.convert(_.type),rt=S(_.internalFormat,ke,Ke,_.normalized,_.colorSpace),F=_.isVideoTexture!==!0,xe=ue.__version===void 0||j===!0,te=ie.dataReady;let Ce=A(_,de);We(n.TEXTURE_CUBE_MAP,_);let Me;if(ge){F&&xe&&t.texStorage2D(n.TEXTURE_CUBE_MAP,Ce,rt,de.width,de.height);for(let ae=0;ae<6;ae++){Me=_e[ae].mipmaps;for(let Ue=0;Ue<Me.length;Ue++){const Ye=Me[Ue];_.format!==Tn?ke!==null?F?te&&t.compressedTexSubImage2D(n.TEXTURE_CUBE_MAP_POSITIVE_X+ae,Ue,0,0,Ye.width,Ye.height,ke,Ye.data):t.compressedTexImage2D(n.TEXTURE_CUBE_MAP_POSITIVE_X+ae,Ue,rt,Ye.width,Ye.height,0,Ye.data):ze("WebGLRenderer: Attempt to load unsupported compressed texture format in .setTextureCube()"):F?te&&t.texSubImage2D(n.TEXTURE_CUBE_MAP_POSITIVE_X+ae,Ue,0,0,Ye.width,Ye.height,ke,Ke,Ye.data):t.texImage2D(n.TEXTURE_CUBE_MAP_POSITIVE_X+ae,Ue,rt,Ye.width,Ye.height,0,ke,Ke,Ye.data)}}}else{if(Me=_.mipmaps,F&&xe){Me.length>0&&Ce++;const ae=Re(_e[0]);t.texStorage2D(n.TEXTURE_CUBE_MAP,Ce,rt,ae.width,ae.height)}for(let ae=0;ae<6;ae++)if(Ee){F?te&&t.texSubImage2D(n.TEXTURE_CUBE_MAP_POSITIVE_X+ae,0,0,0,_e[ae].width,_e[ae].height,ke,Ke,_e[ae].data):t.texImage2D(n.TEXTURE_CUBE_MAP_POSITIVE_X+ae,0,rt,_e[ae].width,_e[ae].height,0,ke,Ke,_e[ae].data);for(let Ue=0;Ue<Me.length;Ue++){const yt=Me[Ue].image[ae].image;F?te&&t.texSubImage2D(n.TEXTURE_CUBE_MAP_POSITIVE_X+ae,Ue+1,0,0,yt.width,yt.height,ke,Ke,yt.data):t.texImage2D(n.TEXTURE_CUBE_MAP_POSITIVE_X+ae,Ue+1,rt,yt.width,yt.height,0,ke,Ke,yt.data)}}else{F?te&&t.texSubImage2D(n.TEXTURE_CUBE_MAP_POSITIVE_X+ae,0,0,0,ke,Ke,_e[ae]):t.texImage2D(n.TEXTURE_CUBE_MAP_POSITIVE_X+ae,0,rt,ke,Ke,_e[ae]);for(let Ue=0;Ue<Me.length;Ue++){const Ye=Me[Ue];F?te&&t.texSubImage2D(n.TEXTURE_CUBE_MAP_POSITIVE_X+ae,Ue+1,0,0,ke,Ke,Ye.image[ae]):t.texImage2D(n.TEXTURE_CUBE_MAP_POSITIVE_X+ae,Ue+1,rt,ke,Ke,Ye.image[ae])}}}d(_)&&x(n.TEXTURE_CUBE_MAP),ue.__version=ie.version,_.onUpdate&&_.onUpdate(_)}b.__version=_.version}function Ve(b,_,B,j,ie,ue){const he=s.convert(B.format,B.colorSpace),Z=s.convert(B.type),re=S(B.internalFormat,he,Z,B.normalized,B.colorSpace),ge=i.get(_),Ee=i.get(B);if(Ee.__renderTarget=_,!ge.__hasExternalTextures){const _e=Math.max(1,_.width>>ue),de=Math.max(1,_.height>>ue);ie===n.TEXTURE_3D||ie===n.TEXTURE_2D_ARRAY?t.texImage3D(ie,ue,re,_e,de,_.depth,0,he,Z,null):t.texImage2D(ie,ue,re,_e,de,0,he,Z,null)}t.bindFramebuffer(n.FRAMEBUFFER,b),pe(_)?a.framebufferTexture2DMultisampleEXT(n.FRAMEBUFFER,j,ie,Ee.__webglTexture,0,ne(_)):(ie===n.TEXTURE_2D||ie>=n.TEXTURE_CUBE_MAP_POSITIVE_X&&ie<=n.TEXTURE_CUBE_MAP_NEGATIVE_Z)&&n.framebufferTexture2D(n.FRAMEBUFFER,j,ie,Ee.__webglTexture,ue),t.bindFramebuffer(n.FRAMEBUFFER,null)}function R(b,_,B){if(n.bindRenderbuffer(n.RENDERBUFFER,b),_.depthBuffer){const j=_.depthTexture,ie=j&&j.isDepthTexture?j.type:null,ue=C(_.stencilBuffer,ie),he=_.stencilBuffer?n.DEPTH_STENCIL_ATTACHMENT:n.DEPTH_ATTACHMENT;pe(_)?a.renderbufferStorageMultisampleEXT(n.RENDERBUFFER,ne(_),ue,_.width,_.height):B?n.renderbufferStorageMultisample(n.RENDERBUFFER,ne(_),ue,_.width,_.height):n.renderbufferStorage(n.RENDERBUFFER,ue,_.width,_.height),n.framebufferRenderbuffer(n.FRAMEBUFFER,he,n.RENDERBUFFER,b)}else{const j=_.textures;for(let ie=0;ie<j.length;ie++){const ue=j[ie],he=s.convert(ue.format,ue.colorSpace),Z=s.convert(ue.type),re=S(ue.internalFormat,he,Z,ue.normalized,ue.colorSpace);pe(_)?a.renderbufferStorageMultisampleEXT(n.RENDERBUFFER,ne(_),re,_.width,_.height):B?n.renderbufferStorageMultisample(n.RENDERBUFFER,ne(_),re,_.width,_.height):n.renderbufferStorage(n.RENDERBUFFER,re,_.width,_.height)}}n.bindRenderbuffer(n.RENDERBUFFER,null)}function U(b,_,B){const j=_.isWebGLCubeRenderTarget===!0;if(t.bindFramebuffer(n.FRAMEBUFFER,b),!(_.depthTexture&&_.depthTexture.isDepthTexture))throw new Error("renderTarget.depthTexture must be an instance of THREE.DepthTexture");const ie=i.get(_.depthTexture);if(ie.__renderTarget=_,(!ie.__webglTexture||_.depthTexture.image.width!==_.width||_.depthTexture.image.height!==_.height)&&(_.depthTexture.image.width=_.width,_.depthTexture.image.height=_.height,_.depthTexture.needsUpdate=!0),j){if(ie.__webglInit===void 0&&(ie.__webglInit=!0,_.depthTexture.addEventListener("dispose",P)),ie.__webglTexture===void 0){ie.__webglTexture=n.createTexture(),t.bindTexture(n.TEXTURE_CUBE_MAP,ie.__webglTexture),We(n.TEXTURE_CUBE_MAP,_.depthTexture);const ge=s.convert(_.depthTexture.format),Ee=s.convert(_.depthTexture.type);let _e;_.depthTexture.format===hi?_e=n.DEPTH_COMPONENT24:_.depthTexture.format===tr&&(_e=n.DEPTH24_STENCIL8);for(let de=0;de<6;de++)n.texImage2D(n.TEXTURE_CUBE_MAP_POSITIVE_X+de,0,_e,_.width,_.height,0,ge,Ee,null)}}else $(_.depthTexture,0);const ue=ie.__webglTexture,he=ne(_),Z=j?n.TEXTURE_CUBE_MAP_POSITIVE_X+B:n.TEXTURE_2D,re=_.depthTexture.format===tr?n.DEPTH_STENCIL_ATTACHMENT:n.DEPTH_ATTACHMENT;if(_.depthTexture.format===hi)pe(_)?a.framebufferTexture2DMultisampleEXT(n.FRAMEBUFFER,re,Z,ue,0,he):n.framebufferTexture2D(n.FRAMEBUFFER,re,Z,ue,0);else if(_.depthTexture.format===tr)pe(_)?a.framebufferTexture2DMultisampleEXT(n.FRAMEBUFFER,re,Z,ue,0,he):n.framebufferTexture2D(n.FRAMEBUFFER,re,Z,ue,0);else throw new Error("Unknown depthTexture format")}function W(b){const _=i.get(b),B=b.isWebGLCubeRenderTarget===!0;if(_.__boundDepthTexture!==b.depthTexture){const j=b.depthTexture;if(_.__depthDisposeCallback&&_.__depthDisposeCallback(),j){const ie=()=>{delete _.__boundDepthTexture,delete _.__depthDisposeCallback,j.removeEventListener("dispose",ie)};j.addEventListener("dispose",ie),_.__depthDisposeCallback=ie}_.__boundDepthTexture=j}if(b.depthTexture&&!_.__autoAllocateDepthBuffer)if(B)for(let j=0;j<6;j++)U(_.__webglFramebuffer[j],b,j);else{const j=b.texture.mipmaps;j&&j.length>0?U(_.__webglFramebuffer[0],b,0):U(_.__webglFramebuffer,b,0)}else if(B){_.__webglDepthbuffer=[];for(let j=0;j<6;j++)if(t.bindFramebuffer(n.FRAMEBUFFER,_.__webglFramebuffer[j]),_.__webglDepthbuffer[j]===void 0)_.__webglDepthbuffer[j]=n.createRenderbuffer(),R(_.__webglDepthbuffer[j],b,!1);else{const ie=b.stencilBuffer?n.DEPTH_STENCIL_ATTACHMENT:n.DEPTH_ATTACHMENT,ue=_.__webglDepthbuffer[j];n.bindRenderbuffer(n.RENDERBUFFER,ue),n.framebufferRenderbuffer(n.FRAMEBUFFER,ie,n.RENDERBUFFER,ue)}}else{const j=b.texture.mipmaps;if(j&&j.length>0?t.bindFramebuffer(n.FRAMEBUFFER,_.__webglFramebuffer[0]):t.bindFramebuffer(n.FRAMEBUFFER,_.__webglFramebuffer),_.__webglDepthbuffer===void 0)_.__webglDepthbuffer=n.createRenderbuffer(),R(_.__webglDepthbuffer,b,!1);else{const ie=b.stencilBuffer?n.DEPTH_STENCIL_ATTACHMENT:n.DEPTH_ATTACHMENT,ue=_.__webglDepthbuffer;n.bindRenderbuffer(n.RENDERBUFFER,ue),n.framebufferRenderbuffer(n.FRAMEBUFFER,ie,n.RENDERBUFFER,ue)}}t.bindFramebuffer(n.FRAMEBUFFER,null)}function ee(b,_,B){const j=i.get(b);_!==void 0&&Ve(j.__webglFramebuffer,b,b.texture,n.COLOR_ATTACHMENT0,n.TEXTURE_2D,0),B!==void 0&&W(b)}function K(b){const _=b.texture,B=i.get(b),j=i.get(_);b.addEventListener("dispose",v);const ie=b.textures,ue=b.isWebGLCubeRenderTarget===!0,he=ie.length>1;if(he||(j.__webglTexture===void 0&&(j.__webglTexture=n.createTexture()),j.__version=_.version,o.memory.textures++),ue){B.__webglFramebuffer=[];for(let Z=0;Z<6;Z++)if(_.mipmaps&&_.mipmaps.length>0){B.__webglFramebuffer[Z]=[];for(let re=0;re<_.mipmaps.length;re++)B.__webglFramebuffer[Z][re]=n.createFramebuffer()}else B.__webglFramebuffer[Z]=n.createFramebuffer()}else{if(_.mipmaps&&_.mipmaps.length>0){B.__webglFramebuffer=[];for(let Z=0;Z<_.mipmaps.length;Z++)B.__webglFramebuffer[Z]=n.createFramebuffer()}else B.__webglFramebuffer=n.createFramebuffer();if(he)for(let Z=0,re=ie.length;Z<re;Z++){const ge=i.get(ie[Z]);ge.__webglTexture===void 0&&(ge.__webglTexture=n.createTexture(),o.memory.textures++)}if(b.samples>0&&pe(b)===!1){B.__webglMultisampledFramebuffer=n.createFramebuffer(),B.__webglColorRenderbuffer=[],t.bindFramebuffer(n.FRAMEBUFFER,B.__webglMultisampledFramebuffer);for(let Z=0;Z<ie.length;Z++){const re=ie[Z];B.__webglColorRenderbuffer[Z]=n.createRenderbuffer(),n.bindRenderbuffer(n.RENDERBUFFER,B.__webglColorRenderbuffer[Z]);const ge=s.convert(re.format,re.colorSpace),Ee=s.convert(re.type),_e=S(re.internalFormat,ge,Ee,re.normalized,re.colorSpace,b.isXRRenderTarget===!0),de=ne(b);n.renderbufferStorageMultisample(n.RENDERBUFFER,de,_e,b.width,b.height),n.framebufferRenderbuffer(n.FRAMEBUFFER,n.COLOR_ATTACHMENT0+Z,n.RENDERBUFFER,B.__webglColorRenderbuffer[Z])}n.bindRenderbuffer(n.RENDERBUFFER,null),b.depthBuffer&&(B.__webglDepthRenderbuffer=n.createRenderbuffer(),R(B.__webglDepthRenderbuffer,b,!0)),t.bindFramebuffer(n.FRAMEBUFFER,null)}}if(ue){t.bindTexture(n.TEXTURE_CUBE_MAP,j.__webglTexture),We(n.TEXTURE_CUBE_MAP,_);for(let Z=0;Z<6;Z++)if(_.mipmaps&&_.mipmaps.length>0)for(let re=0;re<_.mipmaps.length;re++)Ve(B.__webglFramebuffer[Z][re],b,_,n.COLOR_ATTACHMENT0,n.TEXTURE_CUBE_MAP_POSITIVE_X+Z,re);else Ve(B.__webglFramebuffer[Z],b,_,n.COLOR_ATTACHMENT0,n.TEXTURE_CUBE_MAP_POSITIVE_X+Z,0);d(_)&&x(n.TEXTURE_CUBE_MAP),t.unbindTexture()}else if(he){for(let Z=0,re=ie.length;Z<re;Z++){const ge=ie[Z],Ee=i.get(ge);let _e=n.TEXTURE_2D;(b.isWebGL3DRenderTarget||b.isWebGLArrayRenderTarget)&&(_e=b.isWebGL3DRenderTarget?n.TEXTURE_3D:n.TEXTURE_2D_ARRAY),t.bindTexture(_e,Ee.__webglTexture),We(_e,ge),Ve(B.__webglFramebuffer,b,ge,n.COLOR_ATTACHMENT0+Z,_e,0),d(ge)&&x(_e)}t.unbindTexture()}else{let Z=n.TEXTURE_2D;if((b.isWebGL3DRenderTarget||b.isWebGLArrayRenderTarget)&&(Z=b.isWebGL3DRenderTarget?n.TEXTURE_3D:n.TEXTURE_2D_ARRAY),t.bindTexture(Z,j.__webglTexture),We(Z,_),_.mipmaps&&_.mipmaps.length>0)for(let re=0;re<_.mipmaps.length;re++)Ve(B.__webglFramebuffer[re],b,_,n.COLOR_ATTACHMENT0,Z,re);else Ve(B.__webglFramebuffer,b,_,n.COLOR_ATTACHMENT0,Z,0);d(_)&&x(Z),t.unbindTexture()}b.depthBuffer&&W(b)}function Q(b){const _=b.textures;for(let B=0,j=_.length;B<j;B++){const ie=_[B];if(d(ie)){const ue=y(b),he=i.get(ie).__webglTexture;t.bindTexture(ue,he),x(ue),t.unbindTexture()}}}const le=[],fe=[];function w(b){if(b.samples>0){if(pe(b)===!1){const _=b.textures,B=b.width,j=b.height;let ie=n.COLOR_BUFFER_BIT;const ue=b.stencilBuffer?n.DEPTH_STENCIL_ATTACHMENT:n.DEPTH_ATTACHMENT,he=i.get(b),Z=_.length>1;if(Z)for(let ge=0;ge<_.length;ge++)t.bindFramebuffer(n.FRAMEBUFFER,he.__webglMultisampledFramebuffer),n.framebufferRenderbuffer(n.FRAMEBUFFER,n.COLOR_ATTACHMENT0+ge,n.RENDERBUFFER,null),t.bindFramebuffer(n.FRAMEBUFFER,he.__webglFramebuffer),n.framebufferTexture2D(n.DRAW_FRAMEBUFFER,n.COLOR_ATTACHMENT0+ge,n.TEXTURE_2D,null,0);t.bindFramebuffer(n.READ_FRAMEBUFFER,he.__webglMultisampledFramebuffer);const re=b.texture.mipmaps;re&&re.length>0?t.bindFramebuffer(n.DRAW_FRAMEBUFFER,he.__webglFramebuffer[0]):t.bindFramebuffer(n.DRAW_FRAMEBUFFER,he.__webglFramebuffer);for(let ge=0;ge<_.length;ge++){if(b.resolveDepthBuffer&&(b.depthBuffer&&(ie|=n.DEPTH_BUFFER_BIT),b.stencilBuffer&&b.resolveStencilBuffer&&(ie|=n.STENCIL_BUFFER_BIT)),Z){n.framebufferRenderbuffer(n.READ_FRAMEBUFFER,n.COLOR_ATTACHMENT0,n.RENDERBUFFER,he.__webglColorRenderbuffer[ge]);const Ee=i.get(_[ge]).__webglTexture;n.framebufferTexture2D(n.DRAW_FRAMEBUFFER,n.COLOR_ATTACHMENT0,n.TEXTURE_2D,Ee,0)}n.blitFramebuffer(0,0,B,j,0,0,B,j,ie,n.NEAREST),l===!0&&(le.length=0,fe.length=0,le.push(n.COLOR_ATTACHMENT0+ge),b.depthBuffer&&b.resolveDepthBuffer===!1&&(le.push(ue),fe.push(ue),n.invalidateFramebuffer(n.DRAW_FRAMEBUFFER,fe)),n.invalidateFramebuffer(n.READ_FRAMEBUFFER,le))}if(t.bindFramebuffer(n.READ_FRAMEBUFFER,null),t.bindFramebuffer(n.DRAW_FRAMEBUFFER,null),Z)for(let ge=0;ge<_.length;ge++){t.bindFramebuffer(n.FRAMEBUFFER,he.__webglMultisampledFramebuffer),n.framebufferRenderbuffer(n.FRAMEBUFFER,n.COLOR_ATTACHMENT0+ge,n.RENDERBUFFER,he.__webglColorRenderbuffer[ge]);const Ee=i.get(_[ge]).__webglTexture;t.bindFramebuffer(n.FRAMEBUFFER,he.__webglFramebuffer),n.framebufferTexture2D(n.DRAW_FRAMEBUFFER,n.COLOR_ATTACHMENT0+ge,n.TEXTURE_2D,Ee,0)}t.bindFramebuffer(n.DRAW_FRAMEBUFFER,he.__webglMultisampledFramebuffer)}else if(b.depthBuffer&&b.resolveDepthBuffer===!1&&l){const _=b.stencilBuffer?n.DEPTH_STENCIL_ATTACHMENT:n.DEPTH_ATTACHMENT;n.invalidateFramebuffer(n.DRAW_FRAMEBUFFER,[_])}}}function ne(b){return Math.min(r.maxSamples,b.samples)}function pe(b){const _=i.get(b);return b.samples>0&&e.has("WEBGL_multisampled_render_to_texture")===!0&&_.__useRenderToTexture!==!1}function ce(b){const _=o.render.frame;u.get(b)!==_&&(u.set(b,_),b.update())}function J(b,_){const B=b.colorSpace,j=b.format,ie=b.type;return b.isCompressedTexture===!0||b.isVideoTexture===!0||B!==Xo&&B!==Pi&&(Qe.getTransfer(B)===ut?(j!==Tn||ie!==xn)&&ze("WebGLTextures: sRGB encoded textures have to use RGBAFormat and UnsignedByteType."):et("WebGLTextures: Unsupported texture color space:",B)),_}function Re(b){return typeof HTMLImageElement<"u"&&b instanceof HTMLImageElement?(c.width=b.naturalWidth||b.width,c.height=b.naturalHeight||b.height):typeof VideoFrame<"u"&&b instanceof VideoFrame?(c.width=b.displayWidth,c.height=b.displayHeight):(c.width=b.width,c.height=b.height),c}this.allocateTextureUnit=V,this.resetTextureUnits=k,this.getTextureUnits=G,this.setTextureUnits=O,this.setTexture2D=$,this.setTexture2DArray=oe,this.setTexture3D=ve,this.setTextureCube=be,this.rebindTextures=ee,this.setupRenderTarget=K,this.updateRenderTargetMipmap=Q,this.updateMultisampleRenderTarget=w,this.setupDepthRenderbuffer=W,this.setupFrameBufferTexture=Ve,this.useMultisampledRTT=pe,this.isReversedDepthBuffer=function(){return t.buffers.depth.getReversed()}}function AE(n,e){function t(i,r=Pi){let s;const o=Qe.getTransfer(r);if(i===xn)return n.UNSIGNED_BYTE;if(i===zc)return n.UNSIGNED_SHORT_4_4_4_4;if(i===Hc)return n.UNSIGNED_SHORT_5_5_5_1;if(i===Vd)return n.UNSIGNED_INT_5_9_9_9_REV;if(i===Gd)return n.UNSIGNED_INT_10F_11F_11F_REV;if(i===zd)return n.BYTE;if(i===Hd)return n.SHORT;if(i===Ts)return n.UNSIGNED_SHORT;if(i===Bc)return n.INT;if(i===Yn)return n.UNSIGNED_INT;if(i===Hn)return n.FLOAT;if(i===fi)return n.HALF_FLOAT;if(i===kd)return n.ALPHA;if(i===Wd)return n.RGB;if(i===Tn)return n.RGBA;if(i===hi)return n.DEPTH_COMPONENT;if(i===tr)return n.DEPTH_STENCIL;if(i===Xd)return n.RED;if(i===Vc)return n.RED_INTEGER;if(i===ar)return n.RG;if(i===Gc)return n.RG_INTEGER;if(i===kc)return n.RGBA_INTEGER;if(i===To||i===Ao||i===wo||i===Ro)if(o===ut)if(s=e.get("WEBGL_compressed_texture_s3tc_srgb"),s!==null){if(i===To)return s.COMPRESSED_SRGB_S3TC_DXT1_EXT;if(i===Ao)return s.COMPRESSED_SRGB_ALPHA_S3TC_DXT1_EXT;if(i===wo)return s.COMPRESSED_SRGB_ALPHA_S3TC_DXT3_EXT;if(i===Ro)return s.COMPRESSED_SRGB_ALPHA_S3TC_DXT5_EXT}else return null;else if(s=e.get("WEBGL_compressed_texture_s3tc"),s!==null){if(i===To)return s.COMPRESSED_RGB_S3TC_DXT1_EXT;if(i===Ao)return s.COMPRESSED_RGBA_S3TC_DXT1_EXT;if(i===wo)return s.COMPRESSED_RGBA_S3TC_DXT3_EXT;if(i===Ro)return s.COMPRESSED_RGBA_S3TC_DXT5_EXT}else return null;if(i===Bl||i===zl||i===Hl||i===Vl)if(s=e.get("WEBGL_compressed_texture_pvrtc"),s!==null){if(i===Bl)return s.COMPRESSED_RGB_PVRTC_4BPPV1_IMG;if(i===zl)return s.COMPRESSED_RGB_PVRTC_2BPPV1_IMG;if(i===Hl)return s.COMPRESSED_RGBA_PVRTC_4BPPV1_IMG;if(i===Vl)return s.COMPRESSED_RGBA_PVRTC_2BPPV1_IMG}else return null;if(i===Gl||i===kl||i===Wl||i===Xl||i===Yl||i===ko||i===ql)if(s=e.get("WEBGL_compressed_texture_etc"),s!==null){if(i===Gl||i===kl)return o===ut?s.COMPRESSED_SRGB8_ETC2:s.COMPRESSED_RGB8_ETC2;if(i===Wl)return o===ut?s.COMPRESSED_SRGB8_ALPHA8_ETC2_EAC:s.COMPRESSED_RGBA8_ETC2_EAC;if(i===Xl)return s.COMPRESSED_R11_EAC;if(i===Yl)return s.COMPRESSED_SIGNED_R11_EAC;if(i===ko)return s.COMPRESSED_RG11_EAC;if(i===ql)return s.COMPRESSED_SIGNED_RG11_EAC}else return null;if(i===Kl||i===jl||i===Zl||i===$l||i===Jl||i===Ql||i===ec||i===tc||i===nc||i===ic||i===rc||i===sc||i===oc||i===ac)if(s=e.get("WEBGL_compressed_texture_astc"),s!==null){if(i===Kl)return o===ut?s.COMPRESSED_SRGB8_ALPHA8_ASTC_4x4_KHR:s.COMPRESSED_RGBA_ASTC_4x4_KHR;if(i===jl)return o===ut?s.COMPRESSED_SRGB8_ALPHA8_ASTC_5x4_KHR:s.COMPRESSED_RGBA_ASTC_5x4_KHR;if(i===Zl)return o===ut?s.COMPRESSED_SRGB8_ALPHA8_ASTC_5x5_KHR:s.COMPRESSED_RGBA_ASTC_5x5_KHR;if(i===$l)return o===ut?s.COMPRESSED_SRGB8_ALPHA8_ASTC_6x5_KHR:s.COMPRESSED_RGBA_ASTC_6x5_KHR;if(i===Jl)return o===ut?s.COMPRESSED_SRGB8_ALPHA8_ASTC_6x6_KHR:s.COMPRESSED_RGBA_ASTC_6x6_KHR;if(i===Ql)return o===ut?s.COMPRESSED_SRGB8_ALPHA8_ASTC_8x5_KHR:s.COMPRESSED_RGBA_ASTC_8x5_KHR;if(i===ec)return o===ut?s.COMPRESSED_SRGB8_ALPHA8_ASTC_8x6_KHR:s.COMPRESSED_RGBA_ASTC_8x6_KHR;if(i===tc)return o===ut?s.COMPRESSED_SRGB8_ALPHA8_ASTC_8x8_KHR:s.COMPRESSED_RGBA_ASTC_8x8_KHR;if(i===nc)return o===ut?s.COMPRESSED_SRGB8_ALPHA8_ASTC_10x5_KHR:s.COMPRESSED_RGBA_ASTC_10x5_KHR;if(i===ic)return o===ut?s.COMPRESSED_SRGB8_ALPHA8_ASTC_10x6_KHR:s.COMPRESSED_RGBA_ASTC_10x6_KHR;if(i===rc)return o===ut?s.COMPRESSED_SRGB8_ALPHA8_ASTC_10x8_KHR:s.COMPRESSED_RGBA_ASTC_10x8_KHR;if(i===sc)return o===ut?s.COMPRESSED_SRGB8_ALPHA8_ASTC_10x10_KHR:s.COMPRESSED_RGBA_ASTC_10x10_KHR;if(i===oc)return o===ut?s.COMPRESSED_SRGB8_ALPHA8_ASTC_12x10_KHR:s.COMPRESSED_RGBA_ASTC_12x10_KHR;if(i===ac)return o===ut?s.COMPRESSED_SRGB8_ALPHA8_ASTC_12x12_KHR:s.COMPRESSED_RGBA_ASTC_12x12_KHR}else return null;if(i===lc||i===cc||i===uc)if(s=e.get("EXT_texture_compression_bptc"),s!==null){if(i===lc)return o===ut?s.COMPRESSED_SRGB_ALPHA_BPTC_UNORM_EXT:s.COMPRESSED_RGBA_BPTC_UNORM_EXT;if(i===cc)return s.COMPRESSED_RGB_BPTC_SIGNED_FLOAT_EXT;if(i===uc)return s.COMPRESSED_RGB_BPTC_UNSIGNED_FLOAT_EXT}else return null;if(i===fc||i===hc||i===Wo||i===dc)if(s=e.get("EXT_texture_compression_rgtc"),s!==null){if(i===fc)return s.COMPRESSED_RED_RGTC1_EXT;if(i===hc)return s.COMPRESSED_SIGNED_RED_RGTC1_EXT;if(i===Wo)return s.COMPRESSED_RED_GREEN_RGTC2_EXT;if(i===dc)return s.COMPRESSED_SIGNED_RED_GREEN_RGTC2_EXT}else return null;return i===As?n.UNSIGNED_INT_24_8:n[i]!==void 0?n[i]:null}return{convert:t}}const wE=`
void main() {

	gl_Position = vec4( position, 1.0 );

}`,RE=`
uniform sampler2DArray depthColor;
uniform float depthWidth;
uniform float depthHeight;

void main() {

	vec2 coord = vec2( gl_FragCoord.x / depthWidth, gl_FragCoord.y / depthHeight );

	if ( coord.x >= 1.0 ) {

		gl_FragDepth = texture( depthColor, vec3( coord.x - 1.0, coord.y, 1 ) ).r;

	} else {

		gl_FragDepth = texture( depthColor, vec3( coord.x, coord.y, 0 ) ).r;

	}

}`;class CE{constructor(){this.texture=null,this.mesh=null,this.depthNear=0,this.depthFar=0}init(e,t){if(this.texture===null){const i=new ep(e.texture);(e.depthNear!==t.depthNear||e.depthFar!==t.depthFar)&&(this.depthNear=e.depthNear,this.depthFar=e.depthFar),this.texture=i}}getMesh(e){if(this.texture!==null&&this.mesh===null){const t=e.cameras[0].viewport,i=new qn({vertexShader:wE,fragmentShader:RE,uniforms:{depthColor:{value:this.texture},depthWidth:{value:t.z},depthHeight:{value:t.w}}});this.mesh=new Pe(new Fs(20,20),i)}return this.mesh}reset(){this.texture=null,this.mesh=null}getDepthTexture(){return this.texture}}class PE extends Ni{constructor(e,t){super();const i=this;let r=null,s=1,o=null,a="local-floor",l=1,c=null,u=null,h=null,f=null,p=null,g=null;const M=typeof XRWebGLBinding<"u",m=new CE,d={},x=t.getContextAttributes();let y=null,S=null;const C=[],A=[],P=new st;let v=null;const T=new yn;T.viewport=new At;const L=new yn;L.viewport=new At;const D=[T,L],I=new B0;let k=null,G=null;this.cameraAutoUpdate=!0,this.enabled=!1,this.isPresenting=!1,this.getController=function(se){let Se=C[se];return Se===void 0&&(Se=new Ha,C[se]=Se),Se.getTargetRaySpace()},this.getControllerGrip=function(se){let Se=C[se];return Se===void 0&&(Se=new Ha,C[se]=Se),Se.getGripSpace()},this.getHand=function(se){let Se=C[se];return Se===void 0&&(Se=new Ha,C[se]=Se),Se.getHandSpace()};function O(se){const Se=A.indexOf(se.inputSource);if(Se===-1)return;const me=C[Se];me!==void 0&&(me.update(se.inputSource,se.frame,c||o),me.dispatchEvent({type:se.type,data:se.inputSource}))}function V(){r.removeEventListener("select",O),r.removeEventListener("selectstart",O),r.removeEventListener("selectend",O),r.removeEventListener("squeeze",O),r.removeEventListener("squeezestart",O),r.removeEventListener("squeezeend",O),r.removeEventListener("end",V),r.removeEventListener("inputsourceschange",H);for(let se=0;se<C.length;se++){const Se=A[se];Se!==null&&(A[se]=null,C[se].disconnect(Se))}k=null,G=null,m.reset();for(const se in d)delete d[se];e.setRenderTarget(y),p=null,f=null,h=null,r=null,S=null,We.stop(),i.isPresenting=!1,e.setPixelRatio(v),e.setSize(P.width,P.height,!1),i.dispatchEvent({type:"sessionend"})}this.setFramebufferScaleFactor=function(se){s=se,i.isPresenting===!0&&ze("WebXRManager: Cannot change framebuffer scale while presenting.")},this.setReferenceSpaceType=function(se){a=se,i.isPresenting===!0&&ze("WebXRManager: Cannot change reference space type while presenting.")},this.getReferenceSpace=function(){return c||o},this.setReferenceSpace=function(se){c=se},this.getBaseLayer=function(){return f!==null?f:p},this.getBinding=function(){return h===null&&M&&(h=new XRWebGLBinding(r,t)),h},this.getFrame=function(){return g},this.getSession=function(){return r},this.setSession=async function(se){if(r=se,r!==null){if(y=e.getRenderTarget(),r.addEventListener("select",O),r.addEventListener("selectstart",O),r.addEventListener("selectend",O),r.addEventListener("squeeze",O),r.addEventListener("squeezestart",O),r.addEventListener("squeezeend",O),r.addEventListener("end",V),r.addEventListener("inputsourceschange",H),x.xrCompatible!==!0&&await t.makeXRCompatible(),v=e.getPixelRatio(),e.getSize(P),M&&"createProjectionLayer"in XRWebGLBinding.prototype){let me=null,Be=null,He=null;x.depth&&(He=x.stencil?t.DEPTH24_STENCIL8:t.DEPTH_COMPONENT24,me=x.stencil?tr:hi,Be=x.stencil?As:Yn);const Ve={colorFormat:t.RGBA8,depthFormat:He,scaleFactor:s};h=this.getBinding(),f=h.createProjectionLayer(Ve),r.updateRenderState({layers:[f]}),e.setPixelRatio(1),e.setSize(f.textureWidth,f.textureHeight,!1),S=new Wn(f.textureWidth,f.textureHeight,{format:Tn,type:xn,depthTexture:new Vr(f.textureWidth,f.textureHeight,Be,void 0,void 0,void 0,void 0,void 0,void 0,me),stencilBuffer:x.stencil,colorSpace:e.outputColorSpace,samples:x.antialias?4:0,resolveDepthBuffer:f.ignoreDepthValues===!1,resolveStencilBuffer:f.ignoreDepthValues===!1})}else{const me={antialias:x.antialias,alpha:!0,depth:x.depth,stencil:x.stencil,framebufferScaleFactor:s};p=new XRWebGLLayer(r,t,me),r.updateRenderState({baseLayer:p}),e.setPixelRatio(1),e.setSize(p.framebufferWidth,p.framebufferHeight,!1),S=new Wn(p.framebufferWidth,p.framebufferHeight,{format:Tn,type:xn,colorSpace:e.outputColorSpace,stencilBuffer:x.stencil,resolveDepthBuffer:p.ignoreDepthValues===!1,resolveStencilBuffer:p.ignoreDepthValues===!1})}S.isXRRenderTarget=!0,this.setFoveation(l),c=null,o=await r.requestReferenceSpace(a),We.setContext(r),We.start(),i.isPresenting=!0,i.dispatchEvent({type:"sessionstart"})}},this.getEnvironmentBlendMode=function(){if(r!==null)return r.environmentBlendMode},this.getDepthTexture=function(){return m.getDepthTexture()};function H(se){for(let Se=0;Se<se.removed.length;Se++){const me=se.removed[Se],Be=A.indexOf(me);Be>=0&&(A[Be]=null,C[Be].disconnect(me))}for(let Se=0;Se<se.added.length;Se++){const me=se.added[Se];let Be=A.indexOf(me);if(Be===-1){for(let Ve=0;Ve<C.length;Ve++)if(Ve>=A.length){A.push(me),Be=Ve;break}else if(A[Ve]===null){A[Ve]=me,Be=Ve;break}if(Be===-1)break}const He=C[Be];He&&He.connect(me)}}const $=new N,oe=new N;function ve(se,Se,me){$.setFromMatrixPosition(Se.matrixWorld),oe.setFromMatrixPosition(me.matrixWorld);const Be=$.distanceTo(oe),He=Se.projectionMatrix.elements,Ve=me.projectionMatrix.elements,R=He[14]/(He[10]-1),U=He[14]/(He[10]+1),W=(He[9]+1)/He[5],ee=(He[9]-1)/He[5],K=(He[8]-1)/He[0],Q=(Ve[8]+1)/Ve[0],le=R*K,fe=R*Q,w=Be/(-K+Q),ne=w*-K;if(Se.matrixWorld.decompose(se.position,se.quaternion,se.scale),se.translateX(ne),se.translateZ(w),se.matrixWorld.compose(se.position,se.quaternion,se.scale),se.matrixWorldInverse.copy(se.matrixWorld).invert(),He[10]===-1)se.projectionMatrix.copy(Se.projectionMatrix),se.projectionMatrixInverse.copy(Se.projectionMatrixInverse);else{const pe=R+w,ce=U+w,J=le-ne,Re=fe+(Be-ne),b=W*U/ce*pe,_=ee*U/ce*pe;se.projectionMatrix.makePerspective(J,Re,b,_,pe,ce),se.projectionMatrixInverse.copy(se.projectionMatrix).invert()}}function be(se,Se){Se===null?se.matrixWorld.copy(se.matrix):se.matrixWorld.multiplyMatrices(Se.matrixWorld,se.matrix),se.matrixWorldInverse.copy(se.matrixWorld).invert()}this.updateCamera=function(se){if(r===null)return;let Se=se.near,me=se.far;m.texture!==null&&(m.depthNear>0&&(Se=m.depthNear),m.depthFar>0&&(me=m.depthFar)),I.near=L.near=T.near=Se,I.far=L.far=T.far=me,(k!==I.near||G!==I.far)&&(r.updateRenderState({depthNear:I.near,depthFar:I.far}),k=I.near,G=I.far),I.layers.mask=se.layers.mask|6,T.layers.mask=I.layers.mask&-5,L.layers.mask=I.layers.mask&-3;const Be=se.parent,He=I.cameras;be(I,Be);for(let Ve=0;Ve<He.length;Ve++)be(He[Ve],Be);He.length===2?ve(I,T,L):I.projectionMatrix.copy(T.projectionMatrix),we(se,I,Be)};function we(se,Se,me){me===null?se.matrix.copy(Se.matrixWorld):(se.matrix.copy(me.matrixWorld),se.matrix.invert(),se.matrix.multiply(Se.matrixWorld)),se.matrix.decompose(se.position,se.quaternion,se.scale),se.updateMatrixWorld(!0),se.projectionMatrix.copy(Se.projectionMatrix),se.projectionMatrixInverse.copy(Se.projectionMatrixInverse),se.isPerspectiveCamera&&(se.fov=ws*2*Math.atan(1/se.projectionMatrix.elements[5]),se.zoom=1)}this.getCamera=function(){return I},this.getFoveation=function(){if(!(f===null&&p===null))return l},this.setFoveation=function(se){l=se,f!==null&&(f.fixedFoveation=se),p!==null&&p.fixedFoveation!==void 0&&(p.fixedFoveation=se)},this.hasDepthSensing=function(){return m.texture!==null},this.getDepthSensingMesh=function(){return m.getMesh(I)},this.getCameraTexture=function(se){return d[se]};let $e=null;function tt(se,Se){if(u=Se.getViewerPose(c||o),g=Se,u!==null){const me=u.views;p!==null&&(e.setRenderTargetFramebuffer(S,p.framebuffer),e.setRenderTarget(S));let Be=!1;me.length!==I.cameras.length&&(I.cameras.length=0,Be=!0);for(let U=0;U<me.length;U++){const W=me[U];let ee=null;if(p!==null)ee=p.getViewport(W);else{const Q=h.getViewSubImage(f,W);ee=Q.viewport,U===0&&(e.setRenderTargetTextures(S,Q.colorTexture,Q.depthStencilTexture),e.setRenderTarget(S))}let K=D[U];K===void 0&&(K=new yn,K.layers.enable(U),K.viewport=new At,D[U]=K),K.matrix.fromArray(W.transform.matrix),K.matrix.decompose(K.position,K.quaternion,K.scale),K.projectionMatrix.fromArray(W.projectionMatrix),K.projectionMatrixInverse.copy(K.projectionMatrix).invert(),K.viewport.set(ee.x,ee.y,ee.width,ee.height),U===0&&(I.matrix.copy(K.matrix),I.matrix.decompose(I.position,I.quaternion,I.scale)),Be===!0&&I.cameras.push(K)}const He=r.enabledFeatures;if(He&&He.includes("depth-sensing")&&r.depthUsage=="gpu-optimized"&&M){h=i.getBinding();const U=h.getDepthInformation(me[0]);U&&U.isValid&&U.texture&&m.init(U,r.renderState)}if(He&&He.includes("camera-access")&&M){e.state.unbindTexture(),h=i.getBinding();for(let U=0;U<me.length;U++){const W=me[U].camera;if(W){let ee=d[W];ee||(ee=new ep,d[W]=ee);const K=h.getCameraImage(W);ee.sourceTexture=K}}}}for(let me=0;me<C.length;me++){const Be=A[me],He=C[me];Be!==null&&He!==void 0&&He.update(Be,Se,c||o)}$e&&$e(se,Se),Se.detectedPlanes&&i.dispatchEvent({type:"planesdetected",data:Se}),g=null}const We=new sp;We.setAnimationLoop(tt),this.setAnimationLoop=function(se){$e=se},this.dispose=function(){}}}const DE=new Mt,hp=new Xe;hp.set(-1,0,0,0,1,0,0,0,1);function IE(n,e){function t(m,d){m.matrixAutoUpdate===!0&&m.updateMatrix(),d.value.copy(m.matrix)}function i(m,d){d.color.getRGB(m.fogColor.value,tp(n)),d.isFog?(m.fogNear.value=d.near,m.fogFar.value=d.far):d.isFogExp2&&(m.fogDensity.value=d.density)}function r(m,d,x,y,S){d.isNodeMaterial?d.uniformsNeedUpdate=!1:d.isMeshBasicMaterial?s(m,d):d.isMeshLambertMaterial?(s(m,d),d.envMap&&(m.envMapIntensity.value=d.envMapIntensity)):d.isMeshToonMaterial?(s(m,d),h(m,d)):d.isMeshPhongMaterial?(s(m,d),u(m,d),d.envMap&&(m.envMapIntensity.value=d.envMapIntensity)):d.isMeshStandardMaterial?(s(m,d),f(m,d),d.isMeshPhysicalMaterial&&p(m,d,S)):d.isMeshMatcapMaterial?(s(m,d),g(m,d)):d.isMeshDepthMaterial?s(m,d):d.isMeshDistanceMaterial?(s(m,d),M(m,d)):d.isMeshNormalMaterial?s(m,d):d.isLineBasicMaterial?(o(m,d),d.isLineDashedMaterial&&a(m,d)):d.isPointsMaterial?l(m,d,x,y):d.isSpriteMaterial?c(m,d):d.isShadowMaterial?(m.color.value.copy(d.color),m.opacity.value=d.opacity):d.isShaderMaterial&&(d.uniformsNeedUpdate=!1)}function s(m,d){m.opacity.value=d.opacity,d.color&&m.diffuse.value.copy(d.color),d.emissive&&m.emissive.value.copy(d.emissive).multiplyScalar(d.emissiveIntensity),d.map&&(m.map.value=d.map,t(d.map,m.mapTransform)),d.alphaMap&&(m.alphaMap.value=d.alphaMap,t(d.alphaMap,m.alphaMapTransform)),d.bumpMap&&(m.bumpMap.value=d.bumpMap,t(d.bumpMap,m.bumpMapTransform),m.bumpScale.value=d.bumpScale,d.side===on&&(m.bumpScale.value*=-1)),d.normalMap&&(m.normalMap.value=d.normalMap,t(d.normalMap,m.normalMapTransform),m.normalScale.value.copy(d.normalScale),d.side===on&&m.normalScale.value.negate()),d.displacementMap&&(m.displacementMap.value=d.displacementMap,t(d.displacementMap,m.displacementMapTransform),m.displacementScale.value=d.displacementScale,m.displacementBias.value=d.displacementBias),d.emissiveMap&&(m.emissiveMap.value=d.emissiveMap,t(d.emissiveMap,m.emissiveMapTransform)),d.specularMap&&(m.specularMap.value=d.specularMap,t(d.specularMap,m.specularMapTransform)),d.alphaTest>0&&(m.alphaTest.value=d.alphaTest);const x=e.get(d),y=x.envMap,S=x.envMapRotation;y&&(m.envMap.value=y,m.envMapRotation.value.setFromMatrix4(DE.makeRotationFromEuler(S)).transpose(),y.isCubeTexture&&y.isRenderTargetTexture===!1&&m.envMapRotation.value.premultiply(hp),m.reflectivity.value=d.reflectivity,m.ior.value=d.ior,m.refractionRatio.value=d.refractionRatio),d.lightMap&&(m.lightMap.value=d.lightMap,m.lightMapIntensity.value=d.lightMapIntensity,t(d.lightMap,m.lightMapTransform)),d.aoMap&&(m.aoMap.value=d.aoMap,m.aoMapIntensity.value=d.aoMapIntensity,t(d.aoMap,m.aoMapTransform))}function o(m,d){m.diffuse.value.copy(d.color),m.opacity.value=d.opacity,d.map&&(m.map.value=d.map,t(d.map,m.mapTransform))}function a(m,d){m.dashSize.value=d.dashSize,m.totalSize.value=d.dashSize+d.gapSize,m.scale.value=d.scale}function l(m,d,x,y){m.diffuse.value.copy(d.color),m.opacity.value=d.opacity,m.size.value=d.size*x,m.scale.value=y*.5,d.map&&(m.map.value=d.map,t(d.map,m.uvTransform)),d.alphaMap&&(m.alphaMap.value=d.alphaMap,t(d.alphaMap,m.alphaMapTransform)),d.alphaTest>0&&(m.alphaTest.value=d.alphaTest)}function c(m,d){m.diffuse.value.copy(d.color),m.opacity.value=d.opacity,m.rotation.value=d.rotation,d.map&&(m.map.value=d.map,t(d.map,m.mapTransform)),d.alphaMap&&(m.alphaMap.value=d.alphaMap,t(d.alphaMap,m.alphaMapTransform)),d.alphaTest>0&&(m.alphaTest.value=d.alphaTest)}function u(m,d){m.specular.value.copy(d.specular),m.shininess.value=Math.max(d.shininess,1e-4)}function h(m,d){d.gradientMap&&(m.gradientMap.value=d.gradientMap)}function f(m,d){m.metalness.value=d.metalness,d.metalnessMap&&(m.metalnessMap.value=d.metalnessMap,t(d.metalnessMap,m.metalnessMapTransform)),m.roughness.value=d.roughness,d.roughnessMap&&(m.roughnessMap.value=d.roughnessMap,t(d.roughnessMap,m.roughnessMapTransform)),d.envMap&&(m.envMapIntensity.value=d.envMapIntensity)}function p(m,d,x){m.ior.value=d.ior,d.sheen>0&&(m.sheenColor.value.copy(d.sheenColor).multiplyScalar(d.sheen),m.sheenRoughness.value=d.sheenRoughness,d.sheenColorMap&&(m.sheenColorMap.value=d.sheenColorMap,t(d.sheenColorMap,m.sheenColorMapTransform)),d.sheenRoughnessMap&&(m.sheenRoughnessMap.value=d.sheenRoughnessMap,t(d.sheenRoughnessMap,m.sheenRoughnessMapTransform))),d.clearcoat>0&&(m.clearcoat.value=d.clearcoat,m.clearcoatRoughness.value=d.clearcoatRoughness,d.clearcoatMap&&(m.clearcoatMap.value=d.clearcoatMap,t(d.clearcoatMap,m.clearcoatMapTransform)),d.clearcoatRoughnessMap&&(m.clearcoatRoughnessMap.value=d.clearcoatRoughnessMap,t(d.clearcoatRoughnessMap,m.clearcoatRoughnessMapTransform)),d.clearcoatNormalMap&&(m.clearcoatNormalMap.value=d.clearcoatNormalMap,t(d.clearcoatNormalMap,m.clearcoatNormalMapTransform),m.clearcoatNormalScale.value.copy(d.clearcoatNormalScale),d.side===on&&m.clearcoatNormalScale.value.negate())),d.dispersion>0&&(m.dispersion.value=d.dispersion),d.iridescence>0&&(m.iridescence.value=d.iridescence,m.iridescenceIOR.value=d.iridescenceIOR,m.iridescenceThicknessMinimum.value=d.iridescenceThicknessRange[0],m.iridescenceThicknessMaximum.value=d.iridescenceThicknessRange[1],d.iridescenceMap&&(m.iridescenceMap.value=d.iridescenceMap,t(d.iridescenceMap,m.iridescenceMapTransform)),d.iridescenceThicknessMap&&(m.iridescenceThicknessMap.value=d.iridescenceThicknessMap,t(d.iridescenceThicknessMap,m.iridescenceThicknessMapTransform))),d.transmission>0&&(m.transmission.value=d.transmission,m.transmissionSamplerMap.value=x.texture,m.transmissionSamplerSize.value.set(x.width,x.height),d.transmissionMap&&(m.transmissionMap.value=d.transmissionMap,t(d.transmissionMap,m.transmissionMapTransform)),m.thickness.value=d.thickness,d.thicknessMap&&(m.thicknessMap.value=d.thicknessMap,t(d.thicknessMap,m.thicknessMapTransform)),m.attenuationDistance.value=d.attenuationDistance,m.attenuationColor.value.copy(d.attenuationColor)),d.anisotropy>0&&(m.anisotropyVector.value.set(d.anisotropy*Math.cos(d.anisotropyRotation),d.anisotropy*Math.sin(d.anisotropyRotation)),d.anisotropyMap&&(m.anisotropyMap.value=d.anisotropyMap,t(d.anisotropyMap,m.anisotropyMapTransform))),m.specularIntensity.value=d.specularIntensity,m.specularColor.value.copy(d.specularColor),d.specularColorMap&&(m.specularColorMap.value=d.specularColorMap,t(d.specularColorMap,m.specularColorMapTransform)),d.specularIntensityMap&&(m.specularIntensityMap.value=d.specularIntensityMap,t(d.specularIntensityMap,m.specularIntensityMapTransform))}function g(m,d){d.matcap&&(m.matcap.value=d.matcap)}function M(m,d){const x=e.get(d).light;m.referencePosition.value.setFromMatrixPosition(x.matrixWorld),m.nearDistance.value=x.shadow.camera.near,m.farDistance.value=x.shadow.camera.far}return{refreshFogUniforms:i,refreshMaterialUniforms:r}}function LE(n,e,t,i){let r={},s={},o=[];const a=n.getParameter(n.MAX_UNIFORM_BUFFER_BINDINGS);function l(x,y){const S=y.program;i.uniformBlockBinding(x,S)}function c(x,y){let S=r[x.id];S===void 0&&(g(x),S=u(x),r[x.id]=S,x.addEventListener("dispose",m));const C=y.program;i.updateUBOMapping(x,C);const A=e.render.frame;s[x.id]!==A&&(f(x),s[x.id]=A)}function u(x){const y=h();x.__bindingPointIndex=y;const S=n.createBuffer(),C=x.__size,A=x.usage;return n.bindBuffer(n.UNIFORM_BUFFER,S),n.bufferData(n.UNIFORM_BUFFER,C,A),n.bindBuffer(n.UNIFORM_BUFFER,null),n.bindBufferBase(n.UNIFORM_BUFFER,y,S),S}function h(){for(let x=0;x<a;x++)if(o.indexOf(x)===-1)return o.push(x),x;return et("WebGLRenderer: Maximum number of simultaneously usable uniforms groups reached."),0}function f(x){const y=r[x.id],S=x.uniforms,C=x.__cache;n.bindBuffer(n.UNIFORM_BUFFER,y);for(let A=0,P=S.length;A<P;A++){const v=Array.isArray(S[A])?S[A]:[S[A]];for(let T=0,L=v.length;T<L;T++){const D=v[T];if(p(D,A,T,C)===!0){const I=D.__offset,k=Array.isArray(D.value)?D.value:[D.value];let G=0;for(let O=0;O<k.length;O++){const V=k[O],H=M(V);typeof V=="number"||typeof V=="boolean"?(D.__data[0]=V,n.bufferSubData(n.UNIFORM_BUFFER,I+G,D.__data)):V.isMatrix3?(D.__data[0]=V.elements[0],D.__data[1]=V.elements[1],D.__data[2]=V.elements[2],D.__data[3]=0,D.__data[4]=V.elements[3],D.__data[5]=V.elements[4],D.__data[6]=V.elements[5],D.__data[7]=0,D.__data[8]=V.elements[6],D.__data[9]=V.elements[7],D.__data[10]=V.elements[8],D.__data[11]=0):ArrayBuffer.isView(V)?D.__data.set(new V.constructor(V.buffer,V.byteOffset,D.__data.length)):(V.toArray(D.__data,G),G+=H.storage/Float32Array.BYTES_PER_ELEMENT)}n.bufferSubData(n.UNIFORM_BUFFER,I,D.__data)}}}n.bindBuffer(n.UNIFORM_BUFFER,null)}function p(x,y,S,C){const A=x.value,P=y+"_"+S;if(C[P]===void 0)return typeof A=="number"||typeof A=="boolean"?C[P]=A:ArrayBuffer.isView(A)?C[P]=A.slice():C[P]=A.clone(),!0;{const v=C[P];if(typeof A=="number"||typeof A=="boolean"){if(v!==A)return C[P]=A,!0}else{if(ArrayBuffer.isView(A))return!0;if(v.equals(A)===!1)return v.copy(A),!0}}return!1}function g(x){const y=x.uniforms;let S=0;const C=16;for(let P=0,v=y.length;P<v;P++){const T=Array.isArray(y[P])?y[P]:[y[P]];for(let L=0,D=T.length;L<D;L++){const I=T[L],k=Array.isArray(I.value)?I.value:[I.value];for(let G=0,O=k.length;G<O;G++){const V=k[G],H=M(V),$=S%C,oe=$%H.boundary,ve=$+oe;S+=oe,ve!==0&&C-ve<H.storage&&(S+=C-ve),I.__data=new Float32Array(H.storage/Float32Array.BYTES_PER_ELEMENT),I.__offset=S,S+=H.storage}}}const A=S%C;return A>0&&(S+=C-A),x.__size=S,x.__cache={},this}function M(x){const y={boundary:0,storage:0};return typeof x=="number"||typeof x=="boolean"?(y.boundary=4,y.storage=4):x.isVector2?(y.boundary=8,y.storage=8):x.isVector3||x.isColor?(y.boundary=16,y.storage=12):x.isVector4?(y.boundary=16,y.storage=16):x.isMatrix3?(y.boundary=48,y.storage=48):x.isMatrix4?(y.boundary=64,y.storage=64):x.isTexture?ze("WebGLRenderer: Texture samplers can not be part of an uniforms group."):ArrayBuffer.isView(x)?(y.boundary=16,y.storage=x.byteLength):ze("WebGLRenderer: Unsupported uniform value type.",x),y}function m(x){const y=x.target;y.removeEventListener("dispose",m);const S=o.indexOf(y.__bindingPointIndex);o.splice(S,1),n.deleteBuffer(r[y.id]),delete r[y.id],delete s[y.id]}function d(){for(const x in r)n.deleteBuffer(r[x]);o=[],r={},s={}}return{bind:l,update:c,dispose:d}}const UE=new Uint16Array([12469,15057,12620,14925,13266,14620,13807,14376,14323,13990,14545,13625,14713,13328,14840,12882,14931,12528,14996,12233,15039,11829,15066,11525,15080,11295,15085,10976,15082,10705,15073,10495,13880,14564,13898,14542,13977,14430,14158,14124,14393,13732,14556,13410,14702,12996,14814,12596,14891,12291,14937,11834,14957,11489,14958,11194,14943,10803,14921,10506,14893,10278,14858,9960,14484,14039,14487,14025,14499,13941,14524,13740,14574,13468,14654,13106,14743,12678,14818,12344,14867,11893,14889,11509,14893,11180,14881,10751,14852,10428,14812,10128,14765,9754,14712,9466,14764,13480,14764,13475,14766,13440,14766,13347,14769,13070,14786,12713,14816,12387,14844,11957,14860,11549,14868,11215,14855,10751,14825,10403,14782,10044,14729,9651,14666,9352,14599,9029,14967,12835,14966,12831,14963,12804,14954,12723,14936,12564,14917,12347,14900,11958,14886,11569,14878,11247,14859,10765,14828,10401,14784,10011,14727,9600,14660,9289,14586,8893,14508,8533,15111,12234,15110,12234,15104,12216,15092,12156,15067,12010,15028,11776,14981,11500,14942,11205,14902,10752,14861,10393,14812,9991,14752,9570,14682,9252,14603,8808,14519,8445,14431,8145,15209,11449,15208,11451,15202,11451,15190,11438,15163,11384,15117,11274,15055,10979,14994,10648,14932,10343,14871,9936,14803,9532,14729,9218,14645,8742,14556,8381,14461,8020,14365,7603,15273,10603,15272,10607,15267,10619,15256,10631,15231,10614,15182,10535,15118,10389,15042,10167,14963,9787,14883,9447,14800,9115,14710,8665,14615,8318,14514,7911,14411,7507,14279,7198,15314,9675,15313,9683,15309,9712,15298,9759,15277,9797,15229,9773,15166,9668,15084,9487,14995,9274,14898,8910,14800,8539,14697,8234,14590,7790,14479,7409,14367,7067,14178,6621,15337,8619,15337,8631,15333,8677,15325,8769,15305,8871,15264,8940,15202,8909,15119,8775,15022,8565,14916,8328,14804,8009,14688,7614,14569,7287,14448,6888,14321,6483,14088,6171,15350,7402,15350,7419,15347,7480,15340,7613,15322,7804,15287,7973,15229,8057,15148,8012,15046,7846,14933,7611,14810,7357,14682,7069,14552,6656,14421,6316,14251,5948,14007,5528,15356,5942,15356,5977,15353,6119,15348,6294,15332,6551,15302,6824,15249,7044,15171,7122,15070,7050,14949,6861,14818,6611,14679,6349,14538,6067,14398,5651,14189,5311,13935,4958,15359,4123,15359,4153,15356,4296,15353,4646,15338,5160,15311,5508,15263,5829,15188,6042,15088,6094,14966,6001,14826,5796,14678,5543,14527,5287,14377,4985,14133,4586,13869,4257,15360,1563,15360,1642,15358,2076,15354,2636,15341,3350,15317,4019,15273,4429,15203,4732,15105,4911,14981,4932,14836,4818,14679,4621,14517,4386,14359,4156,14083,3795,13808,3437,15360,122,15360,137,15358,285,15355,636,15344,1274,15322,2177,15281,2765,15215,3223,15120,3451,14995,3569,14846,3567,14681,3466,14511,3305,14344,3121,14037,2800,13753,2467,15360,0,15360,1,15359,21,15355,89,15346,253,15325,479,15287,796,15225,1148,15133,1492,15008,1749,14856,1882,14685,1886,14506,1783,14324,1608,13996,1398,13702,1183]);let In=null;function NE(){return In===null&&(In=new b0(UE,16,16,ar,fi),In.name="DFG_LUT",In.minFilter=jt,In.magFilter=jt,In.wrapS=si,In.wrapT=si,In.generateMipmaps=!1,In.needsUpdate=!0),In}class yy{constructor(e={}){const{canvas:t=V_(),context:i=null,depth:r=!0,stencil:s=!1,alpha:o=!1,antialias:a=!1,premultipliedAlpha:l=!0,preserveDrawingBuffer:c=!1,powerPreference:u="default",failIfMajorPerformanceCaveat:h=!1,reversedDepthBuffer:f=!1,outputBufferType:p=xn}=e;this.isWebGLRenderer=!0;let g;if(i!==null){if(typeof WebGLRenderingContext<"u"&&i instanceof WebGLRenderingContext)throw new Error("THREE.WebGLRenderer: WebGL 1 is not supported since r163.");g=i.getContextAttributes().alpha}else g=o;const M=p,m=new Set([kc,Gc,Vc]),d=new Set([xn,Yn,Ts,As,zc,Hc]),x=new Uint32Array(4),y=new Int32Array(4),S=new N;let C=null,A=null;const P=[],v=[];let T=null;this.domElement=t,this.debug={checkShaderErrors:!0,onShaderError:null},this.autoClear=!0,this.autoClearColor=!0,this.autoClearDepth=!0,this.autoClearStencil=!0,this.sortObjects=!0,this.clippingPlanes=[],this.localClippingEnabled=!1,this.toneMapping=kn,this.toneMappingExposure=1,this.transmissionResolutionScale=1;const L=this;let D=!1,I=null;this._outputColorSpace=_n;let k=0,G=0,O=null,V=-1,H=null;const $=new At,oe=new At;let ve=null;const be=new lt(0);let we=0,$e=t.width,tt=t.height,We=1,se=null,Se=null;const me=new At(0,0,$e,tt),Be=new At(0,0,$e,tt);let He=!1;const Ve=new $d;let R=!1,U=!1;const W=new Mt,ee=new N,K=new At,Q={background:null,fog:null,environment:null,overrideMaterial:null,isScene:!0};let le=!1;function fe(){return O===null?We:1}let w=i;function ne(E,z){return t.getContext(E,z)}try{const E={alpha:!0,depth:r,stencil:s,antialias:a,premultipliedAlpha:l,preserveDrawingBuffer:c,powerPreference:u,failIfMajorPerformanceCaveat:h};if("setAttribute"in t&&t.setAttribute("data-engine",`three.js r${Oc}`),t.addEventListener("webglcontextlost",ae,!1),t.addEventListener("webglcontextrestored",Ue,!1),t.addEventListener("webglcontextcreationerror",Ye,!1),w===null){const z="webgl2";if(w=ne(z,E),w===null)throw ne(z)?new Error("Error creating WebGL context with your selected attributes."):new Error("Error creating WebGL context.")}}catch(E){throw et("WebGLRenderer: "+E.message),E}let pe,ce,J,Re,b,_,B,j,ie,ue,he,Z,re,ge,Ee,_e,de,ke,Ke,rt,F,xe,te;function Ce(){pe=new NM(w),pe.init(),F=new AE(w,pe),ce=new wM(w,pe,e,F),J=new bE(w,pe),ce.reversedDepthBuffer&&f&&J.buffers.depth.setReversed(!0),Re=new BM(w),b=new uE,_=new TE(w,pe,J,b,ce,F,Re),B=new UM(L),j=new G0(w),xe=new TM(w,j),ie=new FM(w,j,Re,xe),ue=new HM(w,ie,j,xe,Re),ke=new zM(w,ce,_),Ee=new RM(b),he=new cE(L,B,pe,ce,xe,Ee),Z=new IE(L,b),re=new hE,ge=new xE(pe),de=new bM(L,B,J,ue,g,l),_e=new yE(L,ue,ce),te=new LE(w,Re,ce,J),Ke=new AM(w,pe,Re),rt=new OM(w,pe,Re),Re.programs=he.programs,L.capabilities=ce,L.extensions=pe,L.properties=b,L.renderLists=re,L.shadowMap=_e,L.state=J,L.info=Re}Ce(),M!==xn&&(T=new GM(M,t.width,t.height,r,s));const Me=new PE(L,w);this.xr=Me,this.getContext=function(){return w},this.getContextAttributes=function(){return w.getContextAttributes()},this.forceContextLoss=function(){const E=pe.get("WEBGL_lose_context");E&&E.loseContext()},this.forceContextRestore=function(){const E=pe.get("WEBGL_lose_context");E&&E.restoreContext()},this.getPixelRatio=function(){return We},this.setPixelRatio=function(E){E!==void 0&&(We=E,this.setSize($e,tt,!1))},this.getSize=function(E){return E.set($e,tt)},this.setSize=function(E,z,q=!0){if(Me.isPresenting){ze("WebGLRenderer: Can't change size while VR device is presenting.");return}$e=E,tt=z,t.width=Math.floor(E*We),t.height=Math.floor(z*We),q===!0&&(t.style.width=E+"px",t.style.height=z+"px"),T!==null&&T.setSize(t.width,t.height),this.setViewport(0,0,E,z)},this.getDrawingBufferSize=function(E){return E.set($e*We,tt*We).floor()},this.setDrawingBufferSize=function(E,z,q){$e=E,tt=z,We=q,t.width=Math.floor(E*q),t.height=Math.floor(z*q),this.setViewport(0,0,E,z)},this.setEffects=function(E){if(M===xn){et("THREE.WebGLRenderer: setEffects() requires outputBufferType set to HalfFloatType or FloatType.");return}if(E){for(let z=0;z<E.length;z++)if(E[z].isOutputPass===!0){ze("THREE.WebGLRenderer: OutputPass is not needed in setEffects(). Tone mapping and color space conversion are applied automatically.");break}}T.setEffects(E||[])},this.getCurrentViewport=function(E){return E.copy($)},this.getViewport=function(E){return E.copy(me)},this.setViewport=function(E,z,q,X){E.isVector4?me.set(E.x,E.y,E.z,E.w):me.set(E,z,q,X),J.viewport($.copy(me).multiplyScalar(We).round())},this.getScissor=function(E){return E.copy(Be)},this.setScissor=function(E,z,q,X){E.isVector4?Be.set(E.x,E.y,E.z,E.w):Be.set(E,z,q,X),J.scissor(oe.copy(Be).multiplyScalar(We).round())},this.getScissorTest=function(){return He},this.setScissorTest=function(E){J.setScissorTest(He=E)},this.setOpaqueSort=function(E){se=E},this.setTransparentSort=function(E){Se=E},this.getClearColor=function(E){return E.copy(de.getClearColor())},this.setClearColor=function(){de.setClearColor(...arguments)},this.getClearAlpha=function(){return de.getClearAlpha()},this.setClearAlpha=function(){de.setClearAlpha(...arguments)},this.clear=function(E=!0,z=!0,q=!0){let X=0;if(E){let Y=!1;if(O!==null){const Ae=O.texture.format;Y=m.has(Ae)}if(Y){const Ae=O.texture.type,Ie=d.has(Ae),Te=de.getClearColor(),Le=de.getClearAlpha(),Ne=Te.r,qe=Te.g,Ze=Te.b;Ie?(x[0]=Ne,x[1]=qe,x[2]=Ze,x[3]=Le,w.clearBufferuiv(w.COLOR,0,x)):(y[0]=Ne,y[1]=qe,y[2]=Ze,y[3]=Le,w.clearBufferiv(w.COLOR,0,y))}else X|=w.COLOR_BUFFER_BIT}z&&(X|=w.DEPTH_BUFFER_BIT,this.state.buffers.depth.setMask(!0)),q&&(X|=w.STENCIL_BUFFER_BIT,this.state.buffers.stencil.setMask(4294967295)),X!==0&&w.clear(X)},this.clearColor=function(){this.clear(!0,!1,!1)},this.clearDepth=function(){this.clear(!1,!0,!1)},this.clearStencil=function(){this.clear(!1,!1,!0)},this.setNodesHandler=function(E){E.setRenderer(this),I=E},this.dispose=function(){t.removeEventListener("webglcontextlost",ae,!1),t.removeEventListener("webglcontextrestored",Ue,!1),t.removeEventListener("webglcontextcreationerror",Ye,!1),de.dispose(),re.dispose(),ge.dispose(),b.dispose(),B.dispose(),ue.dispose(),xe.dispose(),te.dispose(),he.dispose(),Me.dispose(),Me.removeEventListener("sessionstart",Jc),Me.removeEventListener("sessionend",Qc),Fi.stop()};function ae(E){E.preventDefault(),nf("WebGLRenderer: Context Lost."),D=!0}function Ue(){nf("WebGLRenderer: Context Restored."),D=!1;const E=Re.autoReset,z=_e.enabled,q=_e.autoUpdate,X=_e.needsUpdate,Y=_e.type;Ce(),Re.autoReset=E,_e.enabled=z,_e.autoUpdate=q,_e.needsUpdate=X,_e.type=Y}function Ye(E){et("WebGLRenderer: A WebGL context could not be created. Reason: ",E.statusMessage)}function yt(E){const z=E.target;z.removeEventListener("dispose",yt),ft(z)}function ft(E){Kn(E),b.remove(E)}function Kn(E){const z=b.get(E).programs;z!==void 0&&(z.forEach(function(q){he.releaseProgram(q)}),E.isShaderMaterial&&he.releaseShaderCache(E))}this.renderBufferDirect=function(E,z,q,X,Y,Ae){z===null&&(z=Q);const Ie=Y.isMesh&&Y.matrixWorld.determinant()<0,Te=mp(E,z,q,X,Y);J.setMaterial(X,Ie);let Le=q.index,Ne=1;if(X.wireframe===!0){if(Le=ie.getWireframeAttribute(q),Le===void 0)return;Ne=2}const qe=q.drawRange,Ze=q.attributes.position;let Fe=qe.start*Ne,ht=(qe.start+qe.count)*Ne;Ae!==null&&(Fe=Math.max(Fe,Ae.start*Ne),ht=Math.min(ht,(Ae.start+Ae.count)*Ne)),Le!==null?(Fe=Math.max(Fe,0),ht=Math.min(ht,Le.count)):Ze!=null&&(Fe=Math.max(Fe,0),ht=Math.min(ht,Ze.count));const bt=ht-Fe;if(bt<0||bt===1/0)return;xe.setup(Y,X,Te,q,Le);let Et,dt=Ke;if(Le!==null&&(Et=j.get(Le),dt=rt,dt.setIndex(Et)),Y.isMesh)X.wireframe===!0?(J.setLineWidth(X.wireframeLinewidth*fe()),dt.setMode(w.LINES)):dt.setMode(w.TRIANGLES);else if(Y.isLine){let Ht=X.linewidth;Ht===void 0&&(Ht=1),J.setLineWidth(Ht*fe()),Y.isLineSegments?dt.setMode(w.LINES):Y.isLineLoop?dt.setMode(w.LINE_LOOP):dt.setMode(w.LINE_STRIP)}else Y.isPoints?dt.setMode(w.POINTS):Y.isSprite&&dt.setMode(w.TRIANGLES);if(Y.isBatchedMesh)if(pe.get("WEBGL_multi_draw"))dt.renderMultiDraw(Y._multiDrawStarts,Y._multiDrawCounts,Y._multiDrawCount);else{const Ht=Y._multiDrawStarts,De=Y._multiDrawCounts,an=Y._multiDrawCount,nt=Le?j.get(Le).bytesPerElement:1,dn=b.get(X).currentProgram.getUniforms();for(let Cn=0;Cn<an;Cn++)dn.setValue(w,"_gl_DrawID",Cn),dt.render(Ht[Cn]/nt,De[Cn])}else if(Y.isInstancedMesh)dt.renderInstances(Fe,bt,Y.count);else if(q.isInstancedBufferGeometry){const Ht=q._maxInstanceCount!==void 0?q._maxInstanceCount:1/0,De=Math.min(q.instanceCount,Ht);dt.renderInstances(Fe,bt,De)}else dt.render(Fe,bt)};function Rn(E,z,q){E.transparent===!0&&E.side===zn&&E.forceSinglePass===!1?(E.side=on,E.needsUpdate=!0,Bs(E,z,q),E.side=Li,E.needsUpdate=!0,Bs(E,z,q),E.side=zn):Bs(E,z,q)}this.compile=function(E,z,q=null){q===null&&(q=E),A=ge.get(q),A.init(z),v.push(A),q.traverseVisible(function(Y){Y.isLight&&Y.layers.test(z.layers)&&(A.pushLight(Y),Y.castShadow&&A.pushShadow(Y))}),E!==q&&E.traverseVisible(function(Y){Y.isLight&&Y.layers.test(z.layers)&&(A.pushLight(Y),Y.castShadow&&A.pushShadow(Y))}),A.setupLights();const X=new Set;return E.traverse(function(Y){if(!(Y.isMesh||Y.isPoints||Y.isLine||Y.isSprite))return;const Ae=Y.material;if(Ae)if(Array.isArray(Ae))for(let Ie=0;Ie<Ae.length;Ie++){const Te=Ae[Ie];Rn(Te,q,Y),X.add(Te)}else Rn(Ae,q,Y),X.add(Ae)}),A=v.pop(),X},this.compileAsync=function(E,z,q=null){const X=this.compile(E,z,q);return new Promise(Y=>{function Ae(){if(X.forEach(function(Ie){b.get(Ie).currentProgram.isReady()&&X.delete(Ie)}),X.size===0){Y(E);return}setTimeout(Ae,10)}pe.get("KHR_parallel_shader_compile")!==null?Ae():setTimeout(Ae,10)})};let xa=null;function dp(E){xa&&xa(E)}function Jc(){Fi.stop()}function Qc(){Fi.start()}const Fi=new sp;Fi.setAnimationLoop(dp),typeof self<"u"&&Fi.setContext(self),this.setAnimationLoop=function(E){xa=E,Me.setAnimationLoop(E),E===null?Fi.stop():Fi.start()},Me.addEventListener("sessionstart",Jc),Me.addEventListener("sessionend",Qc),this.render=function(E,z){if(z!==void 0&&z.isCamera!==!0){et("WebGLRenderer.render: camera is not an instance of THREE.Camera.");return}if(D===!0)return;I!==null&&I.renderStart(E,z);const q=Me.enabled===!0&&Me.isPresenting===!0,X=T!==null&&(O===null||q)&&T.begin(L,O);if(E.matrixWorldAutoUpdate===!0&&E.updateMatrixWorld(),z.parent===null&&z.matrixWorldAutoUpdate===!0&&z.updateMatrixWorld(),Me.enabled===!0&&Me.isPresenting===!0&&(T===null||T.isCompositing()===!1)&&(Me.cameraAutoUpdate===!0&&Me.updateCamera(z),z=Me.getCamera()),E.isScene===!0&&E.onBeforeRender(L,E,z,O),A=ge.get(E,v.length),A.init(z),A.state.textureUnits=_.getTextureUnits(),v.push(A),W.multiplyMatrices(z.projectionMatrix,z.matrixWorldInverse),Ve.setFromProjectionMatrix(W,Vn,z.reversedDepth),U=this.localClippingEnabled,R=Ee.init(this.clippingPlanes,U),C=re.get(E,P.length),C.init(),P.push(C),Me.enabled===!0&&Me.isPresenting===!0){const Ie=L.xr.getDepthSensingMesh();Ie!==null&&va(Ie,z,-1/0,L.sortObjects)}va(E,z,0,L.sortObjects),C.finish(),L.sortObjects===!0&&C.sort(se,Se),le=Me.enabled===!1||Me.isPresenting===!1||Me.hasDepthSensing()===!1,le&&de.addToRenderList(C,E),this.info.render.frame++,R===!0&&Ee.beginShadows();const Y=A.state.shadowsArray;if(_e.render(Y,E,z),R===!0&&Ee.endShadows(),this.info.autoReset===!0&&this.info.reset(),(X&&T.hasRenderPass())===!1){const Ie=C.opaque,Te=C.transmissive;if(A.setupLights(),z.isArrayCamera){const Le=z.cameras;if(Te.length>0)for(let Ne=0,qe=Le.length;Ne<qe;Ne++){const Ze=Le[Ne];tu(Ie,Te,E,Ze)}le&&de.render(E);for(let Ne=0,qe=Le.length;Ne<qe;Ne++){const Ze=Le[Ne];eu(C,E,Ze,Ze.viewport)}}else Te.length>0&&tu(Ie,Te,E,z),le&&de.render(E),eu(C,E,z)}O!==null&&G===0&&(_.updateMultisampleRenderTarget(O),_.updateRenderTargetMipmap(O)),X&&T.end(L),E.isScene===!0&&E.onAfterRender(L,E,z),xe.resetDefaultState(),V=-1,H=null,v.pop(),v.length>0?(A=v[v.length-1],_.setTextureUnits(A.state.textureUnits),R===!0&&Ee.setGlobalState(L.clippingPlanes,A.state.camera)):A=null,P.pop(),P.length>0?C=P[P.length-1]:C=null,I!==null&&I.renderEnd()};function va(E,z,q,X){if(E.visible===!1)return;if(E.layers.test(z.layers)){if(E.isGroup)q=E.renderOrder;else if(E.isLOD)E.autoUpdate===!0&&E.update(z);else if(E.isLightProbeGrid)A.pushLightProbeGrid(E);else if(E.isLight)A.pushLight(E),E.castShadow&&A.pushShadow(E);else if(E.isSprite){if(!E.frustumCulled||Ve.intersectsSprite(E)){X&&K.setFromMatrixPosition(E.matrixWorld).applyMatrix4(W);const Ie=ue.update(E),Te=E.material;Te.visible&&C.push(E,Ie,Te,q,K.z,null)}}else if((E.isMesh||E.isLine||E.isPoints)&&(!E.frustumCulled||Ve.intersectsObject(E))){const Ie=ue.update(E),Te=E.material;if(X&&(E.boundingSphere!==void 0?(E.boundingSphere===null&&E.computeBoundingSphere(),K.copy(E.boundingSphere.center)):(Ie.boundingSphere===null&&Ie.computeBoundingSphere(),K.copy(Ie.boundingSphere.center)),K.applyMatrix4(E.matrixWorld).applyMatrix4(W)),Array.isArray(Te)){const Le=Ie.groups;for(let Ne=0,qe=Le.length;Ne<qe;Ne++){const Ze=Le[Ne],Fe=Te[Ze.materialIndex];Fe&&Fe.visible&&C.push(E,Ie,Fe,q,K.z,Ze)}}else Te.visible&&C.push(E,Ie,Te,q,K.z,null)}}const Ae=E.children;for(let Ie=0,Te=Ae.length;Ie<Te;Ie++)va(Ae[Ie],z,q,X)}function eu(E,z,q,X){const{opaque:Y,transmissive:Ae,transparent:Ie}=E;A.setupLightsView(q),R===!0&&Ee.setGlobalState(L.clippingPlanes,q),X&&J.viewport($.copy(X)),Y.length>0&&Os(Y,z,q),Ae.length>0&&Os(Ae,z,q),Ie.length>0&&Os(Ie,z,q),J.buffers.depth.setTest(!0),J.buffers.depth.setMask(!0),J.buffers.color.setMask(!0),J.setPolygonOffset(!1)}function tu(E,z,q,X){if((q.isScene===!0?q.overrideMaterial:null)!==null)return;if(A.state.transmissionRenderTarget[X.id]===void 0){const Fe=pe.has("EXT_color_buffer_half_float")||pe.has("EXT_color_buffer_float");A.state.transmissionRenderTarget[X.id]=new Wn(1,1,{generateMipmaps:!0,type:Fe?fi:xn,minFilter:er,samples:Math.max(4,ce.samples),stencilBuffer:s,resolveDepthBuffer:!1,resolveStencilBuffer:!1,colorSpace:Qe.workingColorSpace})}const Ae=A.state.transmissionRenderTarget[X.id],Ie=X.viewport||$;Ae.setSize(Ie.z*L.transmissionResolutionScale,Ie.w*L.transmissionResolutionScale);const Te=L.getRenderTarget(),Le=L.getActiveCubeFace(),Ne=L.getActiveMipmapLevel();L.setRenderTarget(Ae),L.getClearColor(be),we=L.getClearAlpha(),we<1&&L.setClearColor(16777215,.5),L.clear(),le&&de.render(q);const qe=L.toneMapping;L.toneMapping=kn;const Ze=X.viewport;if(X.viewport!==void 0&&(X.viewport=void 0),A.setupLightsView(X),R===!0&&Ee.setGlobalState(L.clippingPlanes,X),Os(E,q,X),_.updateMultisampleRenderTarget(Ae),_.updateRenderTargetMipmap(Ae),pe.has("WEBGL_multisampled_render_to_texture")===!1){let Fe=!1;for(let ht=0,bt=z.length;ht<bt;ht++){const Et=z[ht],{object:dt,geometry:Ht,material:De,group:an}=Et;if(De.side===zn&&dt.layers.test(X.layers)){const nt=De.side;De.side=on,De.needsUpdate=!0,nu(dt,q,X,Ht,De,an),De.side=nt,De.needsUpdate=!0,Fe=!0}}Fe===!0&&(_.updateMultisampleRenderTarget(Ae),_.updateRenderTargetMipmap(Ae))}L.setRenderTarget(Te,Le,Ne),L.setClearColor(be,we),Ze!==void 0&&(X.viewport=Ze),L.toneMapping=qe}function Os(E,z,q){const X=z.isScene===!0?z.overrideMaterial:null;for(let Y=0,Ae=E.length;Y<Ae;Y++){const Ie=E[Y],{object:Te,geometry:Le,group:Ne}=Ie;let qe=Ie.material;qe.allowOverride===!0&&X!==null&&(qe=X),Te.layers.test(q.layers)&&nu(Te,z,q,Le,qe,Ne)}}function nu(E,z,q,X,Y,Ae){E.onBeforeRender(L,z,q,X,Y,Ae),E.modelViewMatrix.multiplyMatrices(q.matrixWorldInverse,E.matrixWorld),E.normalMatrix.getNormalMatrix(E.modelViewMatrix),Y.onBeforeRender(L,z,q,X,E,Ae),Y.transparent===!0&&Y.side===zn&&Y.forceSinglePass===!1?(Y.side=on,Y.needsUpdate=!0,L.renderBufferDirect(q,z,X,Y,E,Ae),Y.side=Li,Y.needsUpdate=!0,L.renderBufferDirect(q,z,X,Y,E,Ae),Y.side=zn):L.renderBufferDirect(q,z,X,Y,E,Ae),E.onAfterRender(L,z,q,X,Y,Ae)}function Bs(E,z,q){z.isScene!==!0&&(z=Q);const X=b.get(E),Y=A.state.lights,Ae=A.state.shadowsArray,Ie=Y.state.version,Te=he.getParameters(E,Y.state,Ae,z,q,A.state.lightProbeGridArray),Le=he.getProgramCacheKey(Te);let Ne=X.programs;X.environment=E.isMeshStandardMaterial||E.isMeshLambertMaterial||E.isMeshPhongMaterial?z.environment:null,X.fog=z.fog;const qe=E.isMeshStandardMaterial||E.isMeshLambertMaterial&&!E.envMap||E.isMeshPhongMaterial&&!E.envMap;X.envMap=B.get(E.envMap||X.environment,qe),X.envMapRotation=X.environment!==null&&E.envMap===null?z.environmentRotation:E.envMapRotation,Ne===void 0&&(E.addEventListener("dispose",yt),Ne=new Map,X.programs=Ne);let Ze=Ne.get(Le);if(Ze!==void 0){if(X.currentProgram===Ze&&X.lightsStateVersion===Ie)return ru(E,Te),Ze}else Te.uniforms=he.getUniforms(E),I!==null&&E.isNodeMaterial&&I.build(E,q,Te),E.onBeforeCompile(Te,L),Ze=he.acquireProgram(Te,Le),Ne.set(Le,Ze),X.uniforms=Te.uniforms;const Fe=X.uniforms;return(!E.isShaderMaterial&&!E.isRawShaderMaterial||E.clipping===!0)&&(Fe.clippingPlanes=Ee.uniform),ru(E,Te),X.needsLights=_p(E),X.lightsStateVersion=Ie,X.needsLights&&(Fe.ambientLightColor.value=Y.state.ambient,Fe.lightProbe.value=Y.state.probe,Fe.directionalLights.value=Y.state.directional,Fe.directionalLightShadows.value=Y.state.directionalShadow,Fe.spotLights.value=Y.state.spot,Fe.spotLightShadows.value=Y.state.spotShadow,Fe.rectAreaLights.value=Y.state.rectArea,Fe.ltc_1.value=Y.state.rectAreaLTC1,Fe.ltc_2.value=Y.state.rectAreaLTC2,Fe.pointLights.value=Y.state.point,Fe.pointLightShadows.value=Y.state.pointShadow,Fe.hemisphereLights.value=Y.state.hemi,Fe.directionalShadowMatrix.value=Y.state.directionalShadowMatrix,Fe.spotLightMatrix.value=Y.state.spotLightMatrix,Fe.spotLightMap.value=Y.state.spotLightMap,Fe.pointShadowMatrix.value=Y.state.pointShadowMatrix),X.lightProbeGrid=A.state.lightProbeGridArray.length>0,X.currentProgram=Ze,X.uniformsList=null,Ze}function iu(E){if(E.uniformsList===null){const z=E.currentProgram.getUniforms();E.uniformsList=Co.seqWithValue(z.seq,E.uniforms)}return E.uniformsList}function ru(E,z){const q=b.get(E);q.outputColorSpace=z.outputColorSpace,q.batching=z.batching,q.batchingColor=z.batchingColor,q.instancing=z.instancing,q.instancingColor=z.instancingColor,q.instancingMorph=z.instancingMorph,q.skinning=z.skinning,q.morphTargets=z.morphTargets,q.morphNormals=z.morphNormals,q.morphColors=z.morphColors,q.morphTargetsCount=z.morphTargetsCount,q.numClippingPlanes=z.numClippingPlanes,q.numIntersection=z.numClipIntersection,q.vertexAlphas=z.vertexAlphas,q.vertexTangents=z.vertexTangents,q.toneMapping=z.toneMapping}function pp(E,z){if(E.length===0)return null;if(E.length===1)return E[0].texture!==null?E[0]:null;S.setFromMatrixPosition(z.matrixWorld);for(let q=0,X=E.length;q<X;q++){const Y=E[q];if(Y.texture!==null&&Y.boundingBox.containsPoint(S))return Y}return null}function mp(E,z,q,X,Y){z.isScene!==!0&&(z=Q),_.resetTextureUnits();const Ae=z.fog,Ie=X.isMeshStandardMaterial||X.isMeshLambertMaterial||X.isMeshPhongMaterial?z.environment:null,Te=O===null?L.outputColorSpace:O.isXRRenderTarget===!0?O.texture.colorSpace:Qe.workingColorSpace,Le=X.isMeshStandardMaterial||X.isMeshLambertMaterial&&!X.envMap||X.isMeshPhongMaterial&&!X.envMap,Ne=B.get(X.envMap||Ie,Le),qe=X.vertexColors===!0&&!!q.attributes.color&&q.attributes.color.itemSize===4,Ze=!!q.attributes.tangent&&(!!X.normalMap||X.anisotropy>0),Fe=!!q.morphAttributes.position,ht=!!q.morphAttributes.normal,bt=!!q.morphAttributes.color;let Et=kn;X.toneMapped&&(O===null||O.isXRRenderTarget===!0)&&(Et=L.toneMapping);const dt=q.morphAttributes.position||q.morphAttributes.normal||q.morphAttributes.color,Ht=dt!==void 0?dt.length:0,De=b.get(X),an=A.state.lights;if(R===!0&&(U===!0||E!==H)){const gt=E===H&&X.id===V;Ee.setState(X,E,gt)}let nt=!1;X.version===De.__version?(De.needsLights&&De.lightsStateVersion!==an.state.version||De.outputColorSpace!==Te||Y.isBatchedMesh&&De.batching===!1||!Y.isBatchedMesh&&De.batching===!0||Y.isBatchedMesh&&De.batchingColor===!0&&Y.colorTexture===null||Y.isBatchedMesh&&De.batchingColor===!1&&Y.colorTexture!==null||Y.isInstancedMesh&&De.instancing===!1||!Y.isInstancedMesh&&De.instancing===!0||Y.isSkinnedMesh&&De.skinning===!1||!Y.isSkinnedMesh&&De.skinning===!0||Y.isInstancedMesh&&De.instancingColor===!0&&Y.instanceColor===null||Y.isInstancedMesh&&De.instancingColor===!1&&Y.instanceColor!==null||Y.isInstancedMesh&&De.instancingMorph===!0&&Y.morphTexture===null||Y.isInstancedMesh&&De.instancingMorph===!1&&Y.morphTexture!==null||De.envMap!==Ne||X.fog===!0&&De.fog!==Ae||De.numClippingPlanes!==void 0&&(De.numClippingPlanes!==Ee.numPlanes||De.numIntersection!==Ee.numIntersection)||De.vertexAlphas!==qe||De.vertexTangents!==Ze||De.morphTargets!==Fe||De.morphNormals!==ht||De.morphColors!==bt||De.toneMapping!==Et||De.morphTargetsCount!==Ht||!!De.lightProbeGrid!=A.state.lightProbeGridArray.length>0)&&(nt=!0):(nt=!0,De.__version=X.version);let dn=De.currentProgram;nt===!0&&(dn=Bs(X,z,Y),I&&X.isNodeMaterial&&I.onUpdateProgram(X,dn,De));let Cn=!1,mi=!1,cr=!1;const pt=dn.getUniforms(),Tt=De.uniforms;if(J.useProgram(dn.program)&&(Cn=!0,mi=!0,cr=!0),X.id!==V&&(V=X.id,mi=!0),De.needsLights){const gt=pp(A.state.lightProbeGridArray,Y);De.lightProbeGrid!==gt&&(De.lightProbeGrid=gt,mi=!0)}if(Cn||H!==E){J.buffers.depth.getReversed()&&E.reversedDepth!==!0&&(E._reversedDepth=!0,E.updateProjectionMatrix()),pt.setValue(w,"projectionMatrix",E.projectionMatrix),pt.setValue(w,"viewMatrix",E.matrixWorldInverse);const _i=pt.map.cameraPosition;_i!==void 0&&_i.setValue(w,ee.setFromMatrixPosition(E.matrixWorld)),ce.logarithmicDepthBuffer&&pt.setValue(w,"logDepthBufFC",2/(Math.log(E.far+1)/Math.LN2)),(X.isMeshPhongMaterial||X.isMeshToonMaterial||X.isMeshLambertMaterial||X.isMeshBasicMaterial||X.isMeshStandardMaterial||X.isShaderMaterial)&&pt.setValue(w,"isOrthographic",E.isOrthographicCamera===!0),H!==E&&(H=E,mi=!0,cr=!0)}if(De.needsLights&&(an.state.directionalShadowMap.length>0&&pt.setValue(w,"directionalShadowMap",an.state.directionalShadowMap,_),an.state.spotShadowMap.length>0&&pt.setValue(w,"spotShadowMap",an.state.spotShadowMap,_),an.state.pointShadowMap.length>0&&pt.setValue(w,"pointShadowMap",an.state.pointShadowMap,_)),Y.isSkinnedMesh){pt.setOptional(w,Y,"bindMatrix"),pt.setOptional(w,Y,"bindMatrixInverse");const gt=Y.skeleton;gt&&(gt.boneTexture===null&&gt.computeBoneTexture(),pt.setValue(w,"boneTexture",gt.boneTexture,_))}Y.isBatchedMesh&&(pt.setOptional(w,Y,"batchingTexture"),pt.setValue(w,"batchingTexture",Y._matricesTexture,_),pt.setOptional(w,Y,"batchingIdTexture"),pt.setValue(w,"batchingIdTexture",Y._indirectTexture,_),pt.setOptional(w,Y,"batchingColorTexture"),Y._colorsTexture!==null&&pt.setValue(w,"batchingColorTexture",Y._colorsTexture,_));const gi=q.morphAttributes;if((gi.position!==void 0||gi.normal!==void 0||gi.color!==void 0)&&ke.update(Y,q,dn),(mi||De.receiveShadow!==Y.receiveShadow)&&(De.receiveShadow=Y.receiveShadow,pt.setValue(w,"receiveShadow",Y.receiveShadow)),(X.isMeshStandardMaterial||X.isMeshLambertMaterial||X.isMeshPhongMaterial)&&X.envMap===null&&z.environment!==null&&(Tt.envMapIntensity.value=z.environmentIntensity),Tt.dfgLUT!==void 0&&(Tt.dfgLUT.value=NE()),mi){if(pt.setValue(w,"toneMappingExposure",L.toneMappingExposure),De.needsLights&&gp(Tt,cr),Ae&&X.fog===!0&&Z.refreshFogUniforms(Tt,Ae),Z.refreshMaterialUniforms(Tt,X,We,tt,A.state.transmissionRenderTarget[E.id]),De.needsLights&&De.lightProbeGrid){const gt=De.lightProbeGrid;Tt.probesSH.value=gt.texture,Tt.probesMin.value.copy(gt.boundingBox.min),Tt.probesMax.value.copy(gt.boundingBox.max),Tt.probesResolution.value.copy(gt.resolution)}Co.upload(w,iu(De),Tt,_)}if(X.isShaderMaterial&&X.uniformsNeedUpdate===!0&&(Co.upload(w,iu(De),Tt,_),X.uniformsNeedUpdate=!1),X.isSpriteMaterial&&pt.setValue(w,"center",Y.center),pt.setValue(w,"modelViewMatrix",Y.modelViewMatrix),pt.setValue(w,"normalMatrix",Y.normalMatrix),pt.setValue(w,"modelMatrix",Y.matrixWorld),X.uniformsGroups!==void 0){const gt=X.uniformsGroups;for(let _i=0,ur=gt.length;_i<ur;_i++){const su=gt[_i];te.update(su,dn),te.bind(su,dn)}}return dn}function gp(E,z){E.ambientLightColor.needsUpdate=z,E.lightProbe.needsUpdate=z,E.directionalLights.needsUpdate=z,E.directionalLightShadows.needsUpdate=z,E.pointLights.needsUpdate=z,E.pointLightShadows.needsUpdate=z,E.spotLights.needsUpdate=z,E.spotLightShadows.needsUpdate=z,E.rectAreaLights.needsUpdate=z,E.hemisphereLights.needsUpdate=z}function _p(E){return E.isMeshLambertMaterial||E.isMeshToonMaterial||E.isMeshPhongMaterial||E.isMeshStandardMaterial||E.isShadowMaterial||E.isShaderMaterial&&E.lights===!0}this.getActiveCubeFace=function(){return k},this.getActiveMipmapLevel=function(){return G},this.getRenderTarget=function(){return O},this.setRenderTargetTextures=function(E,z,q){const X=b.get(E);X.__autoAllocateDepthBuffer=E.resolveDepthBuffer===!1,X.__autoAllocateDepthBuffer===!1&&(X.__useRenderToTexture=!1),b.get(E.texture).__webglTexture=z,b.get(E.depthTexture).__webglTexture=X.__autoAllocateDepthBuffer?void 0:q,X.__hasExternalTextures=!0},this.setRenderTargetFramebuffer=function(E,z){const q=b.get(E);q.__webglFramebuffer=z,q.__useDefaultFramebuffer=z===void 0};const xp=w.createFramebuffer();this.setRenderTarget=function(E,z=0,q=0){O=E,k=z,G=q;let X=null,Y=!1,Ae=!1;if(E){const Te=b.get(E);if(Te.__useDefaultFramebuffer!==void 0){J.bindFramebuffer(w.FRAMEBUFFER,Te.__webglFramebuffer),$.copy(E.viewport),oe.copy(E.scissor),ve=E.scissorTest,J.viewport($),J.scissor(oe),J.setScissorTest(ve),V=-1;return}else if(Te.__webglFramebuffer===void 0)_.setupRenderTarget(E);else if(Te.__hasExternalTextures)_.rebindTextures(E,b.get(E.texture).__webglTexture,b.get(E.depthTexture).__webglTexture);else if(E.depthBuffer){const qe=E.depthTexture;if(Te.__boundDepthTexture!==qe){if(qe!==null&&b.has(qe)&&(E.width!==qe.image.width||E.height!==qe.image.height))throw new Error("WebGLRenderTarget: Attached DepthTexture is initialized to the incorrect size.");_.setupDepthRenderbuffer(E)}}const Le=E.texture;(Le.isData3DTexture||Le.isDataArrayTexture||Le.isCompressedArrayTexture)&&(Ae=!0);const Ne=b.get(E).__webglFramebuffer;E.isWebGLCubeRenderTarget?(Array.isArray(Ne[z])?X=Ne[z][q]:X=Ne[z],Y=!0):E.samples>0&&_.useMultisampledRTT(E)===!1?X=b.get(E).__webglMultisampledFramebuffer:Array.isArray(Ne)?X=Ne[q]:X=Ne,$.copy(E.viewport),oe.copy(E.scissor),ve=E.scissorTest}else $.copy(me).multiplyScalar(We).floor(),oe.copy(Be).multiplyScalar(We).floor(),ve=He;if(q!==0&&(X=xp),J.bindFramebuffer(w.FRAMEBUFFER,X)&&J.drawBuffers(E,X),J.viewport($),J.scissor(oe),J.setScissorTest(ve),Y){const Te=b.get(E.texture);w.framebufferTexture2D(w.FRAMEBUFFER,w.COLOR_ATTACHMENT0,w.TEXTURE_CUBE_MAP_POSITIVE_X+z,Te.__webglTexture,q)}else if(Ae){const Te=z;for(let Le=0;Le<E.textures.length;Le++){const Ne=b.get(E.textures[Le]);w.framebufferTextureLayer(w.FRAMEBUFFER,w.COLOR_ATTACHMENT0+Le,Ne.__webglTexture,q,Te)}}else if(E!==null&&q!==0){const Te=b.get(E.texture);w.framebufferTexture2D(w.FRAMEBUFFER,w.COLOR_ATTACHMENT0,w.TEXTURE_2D,Te.__webglTexture,q)}V=-1},this.readRenderTargetPixels=function(E,z,q,X,Y,Ae,Ie,Te=0){if(!(E&&E.isWebGLRenderTarget)){et("WebGLRenderer.readRenderTargetPixels: renderTarget is not THREE.WebGLRenderTarget.");return}let Le=b.get(E).__webglFramebuffer;if(E.isWebGLCubeRenderTarget&&Ie!==void 0&&(Le=Le[Ie]),Le){J.bindFramebuffer(w.FRAMEBUFFER,Le);try{const Ne=E.textures[Te],qe=Ne.format,Ze=Ne.type;if(E.textures.length>1&&w.readBuffer(w.COLOR_ATTACHMENT0+Te),!ce.textureFormatReadable(qe)){et("WebGLRenderer.readRenderTargetPixels: renderTarget is not in RGBA or implementation defined format.");return}if(!ce.textureTypeReadable(Ze)){et("WebGLRenderer.readRenderTargetPixels: renderTarget is not in UnsignedByteType or implementation defined type.");return}z>=0&&z<=E.width-X&&q>=0&&q<=E.height-Y&&w.readPixels(z,q,X,Y,F.convert(qe),F.convert(Ze),Ae)}finally{const Ne=O!==null?b.get(O).__webglFramebuffer:null;J.bindFramebuffer(w.FRAMEBUFFER,Ne)}}},this.readRenderTargetPixelsAsync=async function(E,z,q,X,Y,Ae,Ie,Te=0){if(!(E&&E.isWebGLRenderTarget))throw new Error("THREE.WebGLRenderer.readRenderTargetPixels: renderTarget is not THREE.WebGLRenderTarget.");let Le=b.get(E).__webglFramebuffer;if(E.isWebGLCubeRenderTarget&&Ie!==void 0&&(Le=Le[Ie]),Le)if(z>=0&&z<=E.width-X&&q>=0&&q<=E.height-Y){J.bindFramebuffer(w.FRAMEBUFFER,Le);const Ne=E.textures[Te],qe=Ne.format,Ze=Ne.type;if(E.textures.length>1&&w.readBuffer(w.COLOR_ATTACHMENT0+Te),!ce.textureFormatReadable(qe))throw new Error("THREE.WebGLRenderer.readRenderTargetPixelsAsync: renderTarget is not in RGBA or implementation defined format.");if(!ce.textureTypeReadable(Ze))throw new Error("THREE.WebGLRenderer.readRenderTargetPixelsAsync: renderTarget is not in UnsignedByteType or implementation defined type.");const Fe=w.createBuffer();w.bindBuffer(w.PIXEL_PACK_BUFFER,Fe),w.bufferData(w.PIXEL_PACK_BUFFER,Ae.byteLength,w.STREAM_READ),w.readPixels(z,q,X,Y,F.convert(qe),F.convert(Ze),0);const ht=O!==null?b.get(O).__webglFramebuffer:null;J.bindFramebuffer(w.FRAMEBUFFER,ht);const bt=w.fenceSync(w.SYNC_GPU_COMMANDS_COMPLETE,0);return w.flush(),await G_(w,bt,4),w.bindBuffer(w.PIXEL_PACK_BUFFER,Fe),w.getBufferSubData(w.PIXEL_PACK_BUFFER,0,Ae),w.deleteBuffer(Fe),w.deleteSync(bt),Ae}else throw new Error("THREE.WebGLRenderer.readRenderTargetPixelsAsync: requested read bounds are out of range.")},this.copyFramebufferToTexture=function(E,z=null,q=0){const X=Math.pow(2,-q),Y=Math.floor(E.image.width*X),Ae=Math.floor(E.image.height*X),Ie=z!==null?z.x:0,Te=z!==null?z.y:0;_.setTexture2D(E,0),w.copyTexSubImage2D(w.TEXTURE_2D,q,0,0,Ie,Te,Y,Ae),J.unbindTexture()};const vp=w.createFramebuffer(),Mp=w.createFramebuffer();this.copyTextureToTexture=function(E,z,q=null,X=null,Y=0,Ae=0){let Ie,Te,Le,Ne,qe,Ze,Fe,ht,bt;const Et=E.isCompressedTexture?E.mipmaps[Ae]:E.image;if(q!==null)Ie=q.max.x-q.min.x,Te=q.max.y-q.min.y,Le=q.isBox3?q.max.z-q.min.z:1,Ne=q.min.x,qe=q.min.y,Ze=q.isBox3?q.min.z:0;else{const Tt=Math.pow(2,-Y);Ie=Math.floor(Et.width*Tt),Te=Math.floor(Et.height*Tt),E.isDataArrayTexture?Le=Et.depth:E.isData3DTexture?Le=Math.floor(Et.depth*Tt):Le=1,Ne=0,qe=0,Ze=0}X!==null?(Fe=X.x,ht=X.y,bt=X.z):(Fe=0,ht=0,bt=0);const dt=F.convert(z.format),Ht=F.convert(z.type);let De;z.isData3DTexture?(_.setTexture3D(z,0),De=w.TEXTURE_3D):z.isDataArrayTexture||z.isCompressedArrayTexture?(_.setTexture2DArray(z,0),De=w.TEXTURE_2D_ARRAY):(_.setTexture2D(z,0),De=w.TEXTURE_2D),J.activeTexture(w.TEXTURE0),J.pixelStorei(w.UNPACK_FLIP_Y_WEBGL,z.flipY),J.pixelStorei(w.UNPACK_PREMULTIPLY_ALPHA_WEBGL,z.premultiplyAlpha),J.pixelStorei(w.UNPACK_ALIGNMENT,z.unpackAlignment);const an=J.getParameter(w.UNPACK_ROW_LENGTH),nt=J.getParameter(w.UNPACK_IMAGE_HEIGHT),dn=J.getParameter(w.UNPACK_SKIP_PIXELS),Cn=J.getParameter(w.UNPACK_SKIP_ROWS),mi=J.getParameter(w.UNPACK_SKIP_IMAGES);J.pixelStorei(w.UNPACK_ROW_LENGTH,Et.width),J.pixelStorei(w.UNPACK_IMAGE_HEIGHT,Et.height),J.pixelStorei(w.UNPACK_SKIP_PIXELS,Ne),J.pixelStorei(w.UNPACK_SKIP_ROWS,qe),J.pixelStorei(w.UNPACK_SKIP_IMAGES,Ze);const cr=E.isDataArrayTexture||E.isData3DTexture,pt=z.isDataArrayTexture||z.isData3DTexture;if(E.isDepthTexture){const Tt=b.get(E),gi=b.get(z),gt=b.get(Tt.__renderTarget),_i=b.get(gi.__renderTarget);J.bindFramebuffer(w.READ_FRAMEBUFFER,gt.__webglFramebuffer),J.bindFramebuffer(w.DRAW_FRAMEBUFFER,_i.__webglFramebuffer);for(let ur=0;ur<Le;ur++)cr&&(w.framebufferTextureLayer(w.READ_FRAMEBUFFER,w.COLOR_ATTACHMENT0,b.get(E).__webglTexture,Y,Ze+ur),w.framebufferTextureLayer(w.DRAW_FRAMEBUFFER,w.COLOR_ATTACHMENT0,b.get(z).__webglTexture,Ae,bt+ur)),w.blitFramebuffer(Ne,qe,Ie,Te,Fe,ht,Ie,Te,w.DEPTH_BUFFER_BIT,w.NEAREST);J.bindFramebuffer(w.READ_FRAMEBUFFER,null),J.bindFramebuffer(w.DRAW_FRAMEBUFFER,null)}else if(Y!==0||E.isRenderTargetTexture||b.has(E)){const Tt=b.get(E),gi=b.get(z);J.bindFramebuffer(w.READ_FRAMEBUFFER,vp),J.bindFramebuffer(w.DRAW_FRAMEBUFFER,Mp);for(let gt=0;gt<Le;gt++)cr?w.framebufferTextureLayer(w.READ_FRAMEBUFFER,w.COLOR_ATTACHMENT0,Tt.__webglTexture,Y,Ze+gt):w.framebufferTexture2D(w.READ_FRAMEBUFFER,w.COLOR_ATTACHMENT0,w.TEXTURE_2D,Tt.__webglTexture,Y),pt?w.framebufferTextureLayer(w.DRAW_FRAMEBUFFER,w.COLOR_ATTACHMENT0,gi.__webglTexture,Ae,bt+gt):w.framebufferTexture2D(w.DRAW_FRAMEBUFFER,w.COLOR_ATTACHMENT0,w.TEXTURE_2D,gi.__webglTexture,Ae),Y!==0?w.blitFramebuffer(Ne,qe,Ie,Te,Fe,ht,Ie,Te,w.COLOR_BUFFER_BIT,w.NEAREST):pt?w.copyTexSubImage3D(De,Ae,Fe,ht,bt+gt,Ne,qe,Ie,Te):w.copyTexSubImage2D(De,Ae,Fe,ht,Ne,qe,Ie,Te);J.bindFramebuffer(w.READ_FRAMEBUFFER,null),J.bindFramebuffer(w.DRAW_FRAMEBUFFER,null)}else pt?E.isDataTexture||E.isData3DTexture?w.texSubImage3D(De,Ae,Fe,ht,bt,Ie,Te,Le,dt,Ht,Et.data):z.isCompressedArrayTexture?w.compressedTexSubImage3D(De,Ae,Fe,ht,bt,Ie,Te,Le,dt,Et.data):w.texSubImage3D(De,Ae,Fe,ht,bt,Ie,Te,Le,dt,Ht,Et):E.isDataTexture?w.texSubImage2D(w.TEXTURE_2D,Ae,Fe,ht,Ie,Te,dt,Ht,Et.data):E.isCompressedTexture?w.compressedTexSubImage2D(w.TEXTURE_2D,Ae,Fe,ht,Et.width,Et.height,dt,Et.data):w.texSubImage2D(w.TEXTURE_2D,Ae,Fe,ht,Ie,Te,dt,Ht,Et);J.pixelStorei(w.UNPACK_ROW_LENGTH,an),J.pixelStorei(w.UNPACK_IMAGE_HEIGHT,nt),J.pixelStorei(w.UNPACK_SKIP_PIXELS,dn),J.pixelStorei(w.UNPACK_SKIP_ROWS,Cn),J.pixelStorei(w.UNPACK_SKIP_IMAGES,mi),Ae===0&&z.generateMipmaps&&w.generateMipmap(De),J.unbindTexture()},this.initRenderTarget=function(E){b.get(E).__webglFramebuffer===void 0&&_.setupRenderTarget(E)},this.initTexture=function(E){E.isCubeTexture?_.setTextureCube(E,0):E.isData3DTexture?_.setTexture3D(E,0):E.isDataArrayTexture||E.isCompressedArrayTexture?_.setTexture2DArray(E,0):_.setTexture2D(E,0),J.unbindTexture()},this.resetState=function(){k=0,G=0,O=null,J.reset(),xe.reset()},typeof __THREE_DEVTOOLS__<"u"&&__THREE_DEVTOOLS__.dispatchEvent(new CustomEvent("observe",{detail:this}))}get coordinateSystem(){return Vn}get outputColorSpace(){return this._outputColorSpace}set outputColorSpace(e){this._outputColorSpace=e;const t=this.getContext();t.drawingBufferColorSpace=Qe._getDrawingBufferColorSpace(e),t.unpackColorSpace=Qe._getUnpackColorSpace()}}const Wi=new z0,Wt=new N,Ai=new N,vt=new Xt,Zf={X:new N(1,0,0),Y:new N(0,1,0),Z:new N(0,0,1)},ul={type:"change"},$f={type:"mouseDown",mode:null},Jf={type:"mouseUp",mode:null},Qf={type:"objectChange"};class by extends H0{constructor(e,t=null){super(void 0,t);const i=new VE(this);this._root=i;const r=new GE;this._gizmo=r,i.add(r);const s=new kE;this._plane=s,i.add(s);const o=this;function a(y,S){let C=S;Object.defineProperty(o,y,{get:function(){return C!==void 0?C:S},set:function(A){C!==A&&(C=A,s[y]=A,r[y]=A,o.dispatchEvent({type:y+"-changed",value:A}),o.dispatchEvent(ul))}}),o[y]=S,s[y]=S,r[y]=S}a("camera",e),a("object",void 0),a("enabled",!0),a("axis",null),a("mode","translate"),a("translationSnap",null),a("rotationSnap",null),a("scaleSnap",null),a("space","world"),a("size",1),a("dragging",!1),a("showX",!0),a("showY",!0),a("showZ",!0),a("showXY",!0),a("showYZ",!0),a("showXZ",!0),a("minX",-1/0),a("maxX",1/0),a("minY",-1/0),a("maxY",1/0),a("minZ",-1/0),a("maxZ",1/0);const l=new N,c=new N,u=new Xt,h=new Xt,f=new N,p=new Xt,g=new N,M=new N,m=new N,d=0,x=new N;a("worldPosition",l),a("worldPositionStart",c),a("worldQuaternion",u),a("worldQuaternionStart",h),a("cameraPosition",f),a("cameraQuaternion",p),a("pointStart",g),a("pointEnd",M),a("rotationAxis",m),a("rotationAngle",d),a("eye",x),this._offset=new N,this._startNorm=new N,this._endNorm=new N,this._cameraScale=new N,this._parentPosition=new N,this._parentQuaternion=new Xt,this._parentQuaternionInv=new Xt,this._parentScale=new N,this._worldScaleStart=new N,this._worldQuaternionInv=new Xt,this._worldScale=new N,this._positionStart=new N,this._quaternionStart=new Xt,this._scaleStart=new N,this._getPointer=FE.bind(this),this._onPointerDown=BE.bind(this),this._onPointerHover=OE.bind(this),this._onPointerMove=zE.bind(this),this._onPointerUp=HE.bind(this),t!==null&&this.connect(t)}connect(e){super.connect(e),this.domElement.addEventListener("pointerdown",this._onPointerDown),this.domElement.addEventListener("pointermove",this._onPointerHover),this.domElement.addEventListener("pointerup",this._onPointerUp),this.domElement.style.touchAction="none"}disconnect(){this.domElement.removeEventListener("pointerdown",this._onPointerDown),this.domElement.removeEventListener("pointermove",this._onPointerHover),this.domElement.removeEventListener("pointermove",this._onPointerMove),this.domElement.removeEventListener("pointerup",this._onPointerUp),this.domElement.style.touchAction=""}getHelper(){return this._root}pointerHover(e){if(this.object===void 0||this.dragging===!0)return;e!==null&&Wi.setFromCamera(e,this.camera);const t=fl(this._gizmo.picker[this.mode],Wi);t?this.axis=t.object.name:this.axis=null}pointerDown(e){if(!(this.object===void 0||this.dragging===!0||e!=null&&e.button!==0)&&this.axis!==null){e!==null&&Wi.setFromCamera(e,this.camera);const t=fl(this._plane,Wi,!0);t&&(this.object.updateMatrixWorld(),this.object.parent.updateMatrixWorld(),this._positionStart.copy(this.object.position),this._quaternionStart.copy(this.object.quaternion),this._scaleStart.copy(this.object.scale),this.object.matrixWorld.decompose(this.worldPositionStart,this.worldQuaternionStart,this._worldScaleStart),this.pointStart.copy(t.point).sub(this.worldPositionStart)),this.dragging=!0,$f.mode=this.mode,this.dispatchEvent($f)}}pointerMove(e){const t=this.axis,i=this.mode,r=this.object;let s=this.space;if(i==="scale"?s="local":(t==="E"||t==="XYZE"||t==="XYZ")&&(s="world"),r===void 0||t===null||this.dragging===!1||e!==null&&e.button!==-1)return;e!==null&&Wi.setFromCamera(e,this.camera);const o=fl(this._plane,Wi,!0);if(o){if(this.pointEnd.copy(o.point).sub(this.worldPositionStart),i==="translate")this._offset.copy(this.pointEnd).sub(this.pointStart),s==="local"&&t!=="XYZ"&&this._offset.applyQuaternion(this._worldQuaternionInv),t.indexOf("X")===-1&&(this._offset.x=0),t.indexOf("Y")===-1&&(this._offset.y=0),t.indexOf("Z")===-1&&(this._offset.z=0),s==="local"&&t!=="XYZ"?this._offset.applyQuaternion(this._quaternionStart).divide(this._parentScale):this._offset.applyQuaternion(this._parentQuaternionInv).divide(this._parentScale),r.position.copy(this._offset).add(this._positionStart),this.translationSnap&&(s==="local"&&(r.position.applyQuaternion(vt.copy(this._quaternionStart).invert()),t.search("X")!==-1&&(r.position.x=Math.round(r.position.x/this.translationSnap)*this.translationSnap),t.search("Y")!==-1&&(r.position.y=Math.round(r.position.y/this.translationSnap)*this.translationSnap),t.search("Z")!==-1&&(r.position.z=Math.round(r.position.z/this.translationSnap)*this.translationSnap),r.position.applyQuaternion(this._quaternionStart)),s==="world"&&(r.parent&&r.position.add(Wt.setFromMatrixPosition(r.parent.matrixWorld)),t.search("X")!==-1&&(r.position.x=Math.round(r.position.x/this.translationSnap)*this.translationSnap),t.search("Y")!==-1&&(r.position.y=Math.round(r.position.y/this.translationSnap)*this.translationSnap),t.search("Z")!==-1&&(r.position.z=Math.round(r.position.z/this.translationSnap)*this.translationSnap),r.parent&&r.position.sub(Wt.setFromMatrixPosition(r.parent.matrixWorld)))),r.position.x=Math.max(this.minX,Math.min(this.maxX,r.position.x)),r.position.y=Math.max(this.minY,Math.min(this.maxY,r.position.y)),r.position.z=Math.max(this.minZ,Math.min(this.maxZ,r.position.z));else if(i==="scale"){if(t.search("XYZ")!==-1){let a=this.pointEnd.length()/this.pointStart.length();this.pointEnd.dot(this.pointStart)<0&&(a*=-1),Ai.set(a,a,a)}else Wt.copy(this.pointStart),Ai.copy(this.pointEnd),Wt.applyQuaternion(this._worldQuaternionInv),Ai.applyQuaternion(this._worldQuaternionInv),Ai.divide(Wt),t.search("X")===-1&&(Ai.x=1),t.search("Y")===-1&&(Ai.y=1),t.search("Z")===-1&&(Ai.z=1);r.scale.copy(this._scaleStart).multiply(Ai),this.scaleSnap&&(t.search("X")!==-1&&(r.scale.x=Math.round(r.scale.x/this.scaleSnap)*this.scaleSnap||this.scaleSnap),t.search("Y")!==-1&&(r.scale.y=Math.round(r.scale.y/this.scaleSnap)*this.scaleSnap||this.scaleSnap),t.search("Z")!==-1&&(r.scale.z=Math.round(r.scale.z/this.scaleSnap)*this.scaleSnap||this.scaleSnap))}else if(i==="rotate"){this._offset.copy(this.pointEnd).sub(this.pointStart);const a=20/this.worldPosition.distanceTo(Wt.setFromMatrixPosition(this.camera.matrixWorld));let l=!1;t==="XYZE"?(this.rotationAxis.copy(this._offset).cross(this.eye).normalize(),this.rotationAngle=this._offset.dot(Wt.copy(this.rotationAxis).cross(this.eye))*a):(t==="X"||t==="Y"||t==="Z")&&(this.rotationAxis.copy(Zf[t]),Wt.copy(Zf[t]),s==="local"&&Wt.applyQuaternion(this.worldQuaternion),Wt.cross(this.eye),Wt.length()===0?l=!0:this.rotationAngle=this._offset.dot(Wt.normalize())*a),(t==="E"||l)&&(this.rotationAxis.copy(this.eye),this.rotationAngle=this.pointEnd.angleTo(this.pointStart),this._startNorm.copy(this.pointStart).normalize(),this._endNorm.copy(this.pointEnd).normalize(),this.rotationAngle*=this._endNorm.cross(this._startNorm).dot(this.eye)<0?1:-1),this.rotationSnap&&(this.rotationAngle=Math.round(this.rotationAngle/this.rotationSnap)*this.rotationSnap),s==="local"&&t!=="E"&&t!=="XYZE"?(r.quaternion.copy(this._quaternionStart),r.quaternion.multiply(vt.setFromAxisAngle(this.rotationAxis,this.rotationAngle)).normalize()):(this.rotationAxis.applyQuaternion(this._parentQuaternionInv),r.quaternion.copy(vt.setFromAxisAngle(this.rotationAxis,this.rotationAngle)),r.quaternion.multiply(this._quaternionStart).normalize())}this.dispatchEvent(ul),this.dispatchEvent(Qf)}}pointerUp(e){e!==null&&e.button!==0||(this.dragging&&this.axis!==null&&(Jf.mode=this.mode,this.dispatchEvent(Jf)),this.dragging=!1,this.axis=null)}dispose(){this.disconnect(),this._root.dispose()}attach(e){return this.object=e,this._root.visible=!0,this}detach(){return this.object=void 0,this.axis=null,this._root.visible=!1,this}reset(){this.enabled&&this.dragging&&(this.object.position.copy(this._positionStart),this.object.quaternion.copy(this._quaternionStart),this.object.scale.copy(this._scaleStart),this.dispatchEvent(ul),this.dispatchEvent(Qf),this.pointStart.copy(this.pointEnd))}getRaycaster(){return Wi}getMode(){return this.mode}setMode(e){this.mode=e}setTranslationSnap(e){this.translationSnap=e}setRotationSnap(e){this.rotationSnap=e}setScaleSnap(e){this.scaleSnap=e}setSize(e){this.size=e}setSpace(e){this.space=e}setColors(e,t,i,r){const s=this._gizmo.materialLib;s.xAxis.color.set(e),s.yAxis.color.set(t),s.zAxis.color.set(i),s.active.color.set(r),s.xAxisTransparent.color.set(e),s.yAxisTransparent.color.set(t),s.zAxisTransparent.color.set(i),s.activeTransparent.color.set(r),s.xAxis._color&&s.xAxis._color.set(e),s.yAxis._color&&s.yAxis._color.set(t),s.zAxis._color&&s.zAxis._color.set(i),s.active._color&&s.active._color.set(r),s.xAxisTransparent._color&&s.xAxisTransparent._color.set(e),s.yAxisTransparent._color&&s.yAxisTransparent._color.set(t),s.zAxisTransparent._color&&s.zAxisTransparent._color.set(i),s.activeTransparent._color&&s.activeTransparent._color.set(r)}}function FE(n){if(this.domElement.ownerDocument.pointerLockElement)return{x:0,y:0,button:n.button};{const e=this.domElement.getBoundingClientRect();return{x:(n.clientX-e.left)/e.width*2-1,y:-(n.clientY-e.top)/e.height*2+1,button:n.button}}}function OE(n){if(this.enabled)switch(n.pointerType){case"mouse":case"pen":this.pointerHover(this._getPointer(n));break}}function BE(n){this.enabled&&(document.pointerLockElement||this.domElement.setPointerCapture(n.pointerId),this.domElement.addEventListener("pointermove",this._onPointerMove),this.pointerHover(this._getPointer(n)),this.pointerDown(this._getPointer(n)))}function zE(n){this.enabled&&this.pointerMove(this._getPointer(n))}function HE(n){this.enabled&&(this.domElement.releasePointerCapture(n.pointerId),this.domElement.removeEventListener("pointermove",this._onPointerMove),this.pointerUp(this._getPointer(n)))}function fl(n,e,t){const i=e.intersectObject(n,!0);for(let r=0;r<i.length;r++)if(i[r].object.visible||t)return i[r];return!1}const go=new Ui,mt=new N(0,1,0),eh=new N(0,0,0),th=new Mt,_o=new Xt,Po=new Xt,Ln=new N,nh=new Mt,cs=new N(1,0,0),qi=new N(0,1,0),us=new N(0,0,1),xo=new N,ns=new N,is=new N;class VE extends Ft{constructor(e){super(),this.isTransformControlsRoot=!0,this.controls=e,this.visible=!1}updateMatrixWorld(e){const t=this.controls;t.object!==void 0&&(t.object.updateMatrixWorld(),t.object.parent===null?console.error("TransformControls: The attached 3D object must be a part of the scene graph."):t.object.parent.matrixWorld.decompose(t._parentPosition,t._parentQuaternion,t._parentScale),t.object.matrixWorld.decompose(t.worldPosition,t.worldQuaternion,t._worldScale),t._parentQuaternionInv.copy(t._parentQuaternion).invert(),t._worldQuaternionInv.copy(t.worldQuaternion).invert()),t.camera.updateMatrixWorld(),t.camera.matrixWorld.decompose(t.cameraPosition,t.cameraQuaternion,t._cameraScale),t.camera.isOrthographicCamera?t.camera.getWorldDirection(t.eye).negate():t.eye.copy(t.cameraPosition).sub(t.worldPosition).normalize(),super.updateMatrixWorld(e)}dispose(){this.traverse(function(e){e.geometry&&e.geometry.dispose(),e.material&&e.material.dispose()})}}class GE extends Ft{constructor(){super(),this.isTransformControlsGizmo=!0,this.type="TransformControlsGizmo";const e=new ma({depthTest:!1,depthWrite:!1,fog:!1,toneMapped:!1,transparent:!0}),t=new Jd({depthTest:!1,depthWrite:!1,fog:!1,toneMapped:!1,transparent:!0}),i=e.clone();i.opacity=.15;const r=t.clone();r.opacity=.5;const s=e.clone();s.color.setHex(16711680);const o=e.clone();o.color.setHex(65280);const a=e.clone();a.color.setHex(255);const l=e.clone();l.color.setHex(16711680),l.opacity=.5;const c=e.clone();c.color.setHex(65280),c.opacity=.5;const u=e.clone();u.color.setHex(255),u.opacity=.5;const h=e.clone();h.opacity=.25;const f=e.clone();f.color.setHex(16776960),f.opacity=.25;const p=e.clone();p.color.setHex(16776960);const g=e.clone();g.color.setHex(7895160),this.materialLib={xAxis:s,yAxis:o,zAxis:a,active:p,xAxisTransparent:l,yAxisTransparent:c,zAxisTransparent:u,activeTransparent:f};const M=new kt(0,.04,.1,12);M.translate(0,.05,0);const m=new Ct(.08,.08,.08);m.translate(0,.04,0);const d=new $t;d.setAttribute("position",new St([0,0,0,1,0,0],3));const x=new kt(.0075,.0075,.5,3);x.translate(0,.25,0);function y(O,V){const H=new Ji(O,.0075,3,64,V*Math.PI*2);return H.rotateY(Math.PI/2),H.rotateX(Math.PI/2),H}function S(){const O=new $t;return O.setAttribute("position",new St([0,0,0,1,1,1],3)),O}const C={X:[[new Pe(M,s),[.5,0,0],[0,0,-Math.PI/2]],[new Pe(M,s),[-.5,0,0],[0,0,Math.PI/2]],[new Pe(x,s),[0,0,0],[0,0,-Math.PI/2]]],Y:[[new Pe(M,o),[0,.5,0]],[new Pe(M,o),[0,-.5,0],[Math.PI,0,0]],[new Pe(x,o)]],Z:[[new Pe(M,a),[0,0,.5],[Math.PI/2,0,0]],[new Pe(M,a),[0,0,-.5],[-Math.PI/2,0,0]],[new Pe(x,a),null,[Math.PI/2,0,0]]],XYZ:[[new Pe(new Rr(.1,0),h),[0,0,0]]],XY:[[new Pe(new Ct(.15,.15,.01),u),[.15,.15,0]]],YZ:[[new Pe(new Ct(.15,.15,.01),l),[0,.15,.15],[0,Math.PI/2,0]]],XZ:[[new Pe(new Ct(.15,.15,.01),c),[.15,0,.15],[-Math.PI/2,0,0]]]},A={X:[[new Pe(new kt(.2,0,.6,4),i),[.3,0,0],[0,0,-Math.PI/2]],[new Pe(new kt(.2,0,.6,4),i),[-.3,0,0],[0,0,Math.PI/2]]],Y:[[new Pe(new kt(.2,0,.6,4),i),[0,.3,0]],[new Pe(new kt(.2,0,.6,4),i),[0,-.3,0],[0,0,Math.PI]]],Z:[[new Pe(new kt(.2,0,.6,4),i),[0,0,.3],[Math.PI/2,0,0]],[new Pe(new kt(.2,0,.6,4),i),[0,0,-.3],[-Math.PI/2,0,0]]],XYZ:[[new Pe(new Rr(.2,0),i)]],XY:[[new Pe(new Ct(.2,.2,.01),i),[.15,.15,0]]],YZ:[[new Pe(new Ct(.2,.2,.01),i),[0,.15,.15],[0,Math.PI/2,0]]],XZ:[[new Pe(new Ct(.2,.2,.01),i),[.15,0,.15],[-Math.PI/2,0,0]]]},P={START:[[new Pe(new Rr(.01,2),r),null,null,null,"helper"]],END:[[new Pe(new Rr(.01,2),r),null,null,null,"helper"]],DELTA:[[new bi(S(),r),null,null,null,"helper"]],X:[[new bi(d,r),[-1e3,0,0],null,[1e6,1,1],"helper"]],Y:[[new bi(d,r),[0,-1e3,0],[0,0,Math.PI/2],[1e6,1,1],"helper"]],Z:[[new bi(d,r),[0,0,-1e3],[0,-Math.PI/2,0],[1e6,1,1],"helper"]]},v={XYZE:[[new Pe(y(.5,1),g),null,[0,Math.PI/2,0]]],X:[[new Pe(y(.5,.5),s)]],Y:[[new Pe(y(.5,.5),o),null,[0,0,-Math.PI/2]]],Z:[[new Pe(y(.5,.5),a),null,[0,Math.PI/2,0]]],E:[[new Pe(y(.75,1),f),null,[0,Math.PI/2,0]]]},T={AXIS:[[new bi(d,r),[-1e3,0,0],null,[1e6,1,1],"helper"]]},L={XYZE:[[new Pe(new $c(.25,10,8),i)]],X:[[new Pe(new Ji(.5,.1,4,24),i),[0,0,0],[0,-Math.PI/2,-Math.PI/2]]],Y:[[new Pe(new Ji(.5,.1,4,24),i),[0,0,0],[Math.PI/2,0,0]]],Z:[[new Pe(new Ji(.5,.1,4,24),i),[0,0,0],[0,0,-Math.PI/2]]],E:[[new Pe(new Ji(.75,.1,2,24),i)]]},D={X:[[new Pe(m,s),[.5,0,0],[0,0,-Math.PI/2]],[new Pe(x,s),[0,0,0],[0,0,-Math.PI/2]],[new Pe(m,s),[-.5,0,0],[0,0,Math.PI/2]]],Y:[[new Pe(m,o),[0,.5,0]],[new Pe(x,o)],[new Pe(m,o),[0,-.5,0],[0,0,Math.PI]]],Z:[[new Pe(m,a),[0,0,.5],[Math.PI/2,0,0]],[new Pe(x,a),[0,0,0],[Math.PI/2,0,0]],[new Pe(m,a),[0,0,-.5],[-Math.PI/2,0,0]]],XY:[[new Pe(new Ct(.15,.15,.01),u),[.15,.15,0]]],YZ:[[new Pe(new Ct(.15,.15,.01),l),[0,.15,.15],[0,Math.PI/2,0]]],XZ:[[new Pe(new Ct(.15,.15,.01),c),[.15,0,.15],[-Math.PI/2,0,0]]],XYZ:[[new Pe(new Ct(.1,.1,.1),h)]]},I={X:[[new Pe(new kt(.2,0,.6,4),i),[.3,0,0],[0,0,-Math.PI/2]],[new Pe(new kt(.2,0,.6,4),i),[-.3,0,0],[0,0,Math.PI/2]]],Y:[[new Pe(new kt(.2,0,.6,4),i),[0,.3,0]],[new Pe(new kt(.2,0,.6,4),i),[0,-.3,0],[0,0,Math.PI]]],Z:[[new Pe(new kt(.2,0,.6,4),i),[0,0,.3],[Math.PI/2,0,0]],[new Pe(new kt(.2,0,.6,4),i),[0,0,-.3],[-Math.PI/2,0,0]]],XY:[[new Pe(new Ct(.2,.2,.01),i),[.15,.15,0]]],YZ:[[new Pe(new Ct(.2,.2,.01),i),[0,.15,.15],[0,Math.PI/2,0]]],XZ:[[new Pe(new Ct(.2,.2,.01),i),[.15,0,.15],[-Math.PI/2,0,0]]],XYZ:[[new Pe(new Ct(.2,.2,.2),i),[0,0,0]]]},k={X:[[new bi(d,r),[-1e3,0,0],null,[1e6,1,1],"helper"]],Y:[[new bi(d,r),[0,-1e3,0],[0,0,Math.PI/2],[1e6,1,1],"helper"]],Z:[[new bi(d,r),[0,0,-1e3],[0,-Math.PI/2,0],[1e6,1,1],"helper"]]};function G(O){const V=new Ft;for(const H in O)for(let $=O[H].length;$--;){const oe=O[H][$][0].clone(),ve=O[H][$][1],be=O[H][$][2],we=O[H][$][3],$e=O[H][$][4];oe.name=H,oe.tag=$e,ve&&oe.position.set(ve[0],ve[1],ve[2]),be&&oe.rotation.set(be[0],be[1],be[2]),we&&oe.scale.set(we[0],we[1],we[2]),oe.updateMatrix();const tt=oe.geometry.clone();tt.applyMatrix4(oe.matrix),oe.geometry=tt,oe.renderOrder=1/0,oe.position.set(0,0,0),oe.rotation.set(0,0,0),oe.scale.set(1,1,1),V.add(oe)}return V}this.gizmo={},this.picker={},this.helper={},this.add(this.gizmo.translate=G(C)),this.add(this.gizmo.rotate=G(v)),this.add(this.gizmo.scale=G(D)),this.add(this.picker.translate=G(A)),this.add(this.picker.rotate=G(L)),this.add(this.picker.scale=G(I)),this.add(this.helper.translate=G(P)),this.add(this.helper.rotate=G(T)),this.add(this.helper.scale=G(k)),this.picker.translate.visible=!1,this.picker.rotate.visible=!1,this.picker.scale.visible=!1}updateMatrixWorld(e){const i=(this.mode==="scale"?"local":this.space)==="local"?this.worldQuaternion:Po;this.gizmo.translate.visible=this.mode==="translate",this.gizmo.rotate.visible=this.mode==="rotate",this.gizmo.scale.visible=this.mode==="scale",this.helper.translate.visible=this.mode==="translate",this.helper.rotate.visible=this.mode==="rotate",this.helper.scale.visible=this.mode==="scale";let r=[];r=r.concat(this.picker[this.mode].children),r=r.concat(this.gizmo[this.mode].children),r=r.concat(this.helper[this.mode].children);for(let s=0;s<r.length;s++){const o=r[s];o.visible=!0,o.rotation.set(0,0,0),o.position.copy(this.worldPosition);let a;if(this.camera.isOrthographicCamera?a=(this.camera.top-this.camera.bottom)/this.camera.zoom:a=this.worldPosition.distanceTo(this.cameraPosition)*Math.min(1.9*Math.tan(Math.PI*this.camera.fov/360)/this.camera.zoom,7),o.scale.set(1,1,1).multiplyScalar(a*this.size/4),o.tag==="helper"){o.visible=!1,o.name==="AXIS"?(o.visible=!!this.axis,this.axis==="X"&&(vt.setFromEuler(go.set(0,0,0)),o.quaternion.copy(i).multiply(vt),Math.abs(mt.copy(cs).applyQuaternion(i).dot(this.eye))>.9&&(o.visible=!1)),this.axis==="Y"&&(vt.setFromEuler(go.set(0,0,Math.PI/2)),o.quaternion.copy(i).multiply(vt),Math.abs(mt.copy(qi).applyQuaternion(i).dot(this.eye))>.9&&(o.visible=!1)),this.axis==="Z"&&(vt.setFromEuler(go.set(0,Math.PI/2,0)),o.quaternion.copy(i).multiply(vt),Math.abs(mt.copy(us).applyQuaternion(i).dot(this.eye))>.9&&(o.visible=!1)),this.axis==="XYZE"&&(vt.setFromEuler(go.set(0,Math.PI/2,0)),mt.copy(this.rotationAxis),o.quaternion.setFromRotationMatrix(th.lookAt(eh,mt,qi)),o.quaternion.multiply(vt),o.visible=this.dragging),this.axis==="E"&&(o.visible=!1)):o.name==="START"?(o.position.copy(this.worldPositionStart),o.visible=this.dragging):o.name==="END"?(o.position.copy(this.worldPosition),o.visible=this.dragging):o.name==="DELTA"?(o.position.copy(this.worldPositionStart),o.quaternion.copy(this.worldQuaternionStart),Wt.set(1e-10,1e-10,1e-10).add(this.worldPositionStart).sub(this.worldPosition).multiplyScalar(-1),Wt.applyQuaternion(this.worldQuaternionStart.clone().invert()),o.scale.copy(Wt),o.visible=this.dragging):(o.quaternion.copy(i),this.dragging?o.position.copy(this.worldPositionStart):o.position.copy(this.worldPosition),this.axis&&(o.visible=this.axis.search(o.name)!==-1));continue}o.quaternion.copy(i),this.mode==="translate"||this.mode==="scale"?(o.name==="X"&&Math.abs(mt.copy(cs).applyQuaternion(i).dot(this.eye))>.99&&(o.scale.set(1e-10,1e-10,1e-10),o.visible=!1),o.name==="Y"&&Math.abs(mt.copy(qi).applyQuaternion(i).dot(this.eye))>.99&&(o.scale.set(1e-10,1e-10,1e-10),o.visible=!1),o.name==="Z"&&Math.abs(mt.copy(us).applyQuaternion(i).dot(this.eye))>.99&&(o.scale.set(1e-10,1e-10,1e-10),o.visible=!1),o.name==="XY"&&Math.abs(mt.copy(us).applyQuaternion(i).dot(this.eye))<.2&&(o.scale.set(1e-10,1e-10,1e-10),o.visible=!1),o.name==="YZ"&&Math.abs(mt.copy(cs).applyQuaternion(i).dot(this.eye))<.2&&(o.scale.set(1e-10,1e-10,1e-10),o.visible=!1),o.name==="XZ"&&Math.abs(mt.copy(qi).applyQuaternion(i).dot(this.eye))<.2&&(o.scale.set(1e-10,1e-10,1e-10),o.visible=!1)):this.mode==="rotate"&&(_o.copy(i),mt.copy(this.eye).applyQuaternion(vt.copy(i).invert()),o.name.search("E")!==-1&&o.quaternion.setFromRotationMatrix(th.lookAt(this.eye,eh,qi)),o.name==="X"&&(vt.setFromAxisAngle(cs,Math.atan2(-mt.y,mt.z)),vt.multiplyQuaternions(_o,vt),o.quaternion.copy(vt)),o.name==="Y"&&(vt.setFromAxisAngle(qi,Math.atan2(mt.x,mt.z)),vt.multiplyQuaternions(_o,vt),o.quaternion.copy(vt)),o.name==="Z"&&(vt.setFromAxisAngle(us,Math.atan2(mt.y,mt.x)),vt.multiplyQuaternions(_o,vt),o.quaternion.copy(vt))),o.visible=o.visible&&(o.name.indexOf("X")===-1||this.showX),o.visible=o.visible&&(o.name.indexOf("Y")===-1||this.showY),o.visible=o.visible&&(o.name.indexOf("Z")===-1||this.showZ),o.visible=o.visible&&(o.name.indexOf("E")===-1||this.showX&&this.showY&&this.showZ),o.visible=o.visible&&(o.name.indexOf("XY")===-1||this.showXY),o.visible=o.visible&&(o.name.indexOf("YZ")===-1||this.showYZ),o.visible=o.visible&&(o.name.indexOf("XZ")===-1||this.showXZ),o.material._color=o.material._color||o.material.color.clone(),o.material._opacity=o.material._opacity||o.material.opacity,o.material.color.copy(o.material._color),o.material.opacity=o.material._opacity,this.enabled&&this.axis&&(o.name===this.axis?(o.material.color.copy(this.materialLib.active.color),o.material.opacity=1):this.axis.split("").some(function(l){return o.name===l})&&(o.material.color.copy(this.materialLib.active.color),o.material.opacity=1))}super.updateMatrixWorld(e)}}class kE extends Pe{constructor(){super(new Fs(1e5,1e5,2,2),new ma({visible:!1,wireframe:!0,side:zn,transparent:!0,opacity:.1,toneMapped:!1})),this.isTransformControlsPlane=!0,this.type="TransformControlsPlane"}updateMatrixWorld(e){let t=this.space;switch(this.position.copy(this.worldPosition),this.mode==="scale"&&(t="local"),xo.copy(cs).applyQuaternion(t==="local"?this.worldQuaternion:Po),ns.copy(qi).applyQuaternion(t==="local"?this.worldQuaternion:Po),is.copy(us).applyQuaternion(t==="local"?this.worldQuaternion:Po),mt.copy(ns),this.mode){case"translate":case"scale":switch(this.axis){case"X":mt.copy(this.eye).cross(xo),Ln.copy(xo).cross(mt);break;case"Y":mt.copy(this.eye).cross(ns),Ln.copy(ns).cross(mt);break;case"Z":mt.copy(this.eye).cross(is),Ln.copy(is).cross(mt);break;case"XY":Ln.copy(is);break;case"YZ":Ln.copy(xo);break;case"XZ":mt.copy(is),Ln.copy(ns);break;case"XYZ":case"E":Ln.set(0,0,0);break}break;default:Ln.set(0,0,0)}Ln.length()===0?this.quaternion.copy(this.cameraQuaternion):(nh.lookAt(Wt.set(0,0,0),Ln,mt),this.quaternion.setFromRotationMatrix(nh)),super.updateMatrixWorld(e)}}const Ty="nui://sky_firejob/source/html/assets/sky-gauge.min-ChBL96Ke.js";export{by as $,ty as A,dg as B,pg as C,sy as D,jE as E,sn as F,dy as G,Dt as H,mm as I,_y as J,sa as K,qh as L,Cm as M,Rm as N,Rh as O,Qp as P,qE as Q,Am as R,bg as S,hy as T,gm as U,Yh as V,Sy as W,yn as X,yy as Y,Pe as Z,Ey as _,Nt as a,My as a0,N as a1,ay as a2,Im as a3,JE as a4,Wh as a5,$E as a6,ra as a7,my as a8,xy as a9,oy as aa,Ty as ab,cy as ac,ly as ad,gy as ae,ey as af,py as ag,fy as ah,QE as ai,vy as aj,ir as b,Tc as c,KE as d,XE as e,yg as f,Up as g,ZE as h,So as i,ny as j,El as k,uy as l,em as m,hm as n,YE as o,ry as p,WE as q,ba as r,fg as s,it as t,gd as u,iy as v,Ta as w,hg as x,Lp as y,yl as z};
