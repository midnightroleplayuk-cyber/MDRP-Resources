/* =========================================================================
   SHOPVIEWER - visor 3D da loja de telemóveis (ex-apex_phoneshop/viewer.js), 2026-10-03
   -------------------------------------------------------------------------
   three.js r128 (sem módulos) carregado SÓ quando a loja abre pela primeira vez:
   ShopViewer.load() injeta vendor/three/three.min.js e depois vendor/three/GLTFLoader.js
   (uma vez; devolve sempre a mesma Promise<boolean>). O index.html não os inclui: são
   ~700 KB que só quem entra numa loja precisa.
   Palco: renderer com fundo TRANSPARENTE por cima do palco em CSS da loja (xs-*), com
   um chão holográfico no próprio 3D (anel fino, anel de marcas e um halo, aditivos) e a
   sombra de contacto debaixo do aparelho. Ambiente PMREM gerado aqui (caixas de luz
   emissivas, sem ficheiros HDR), luz hemisférica + principal + preenchimento + contraluz.
   O modelo roda num prato (yaw) e a câmara sobe e desce (elevação), por isso a sombra e
   o anel ficam sempre certos debaixo do aparelho.
   Controlo: arrastar = rodar (com inércia), roda do rato = aproximar (com limites),
   duplo clique = repor. Rotação automática lenta quando ninguém mexe.
   Dobráveis: o clip Fechar_Abrir (4 s: fechado aos 2 s) é conduzido à mão.
   Auriculares: o clip Case_Open abre a caixa (mola amortecida).
   Marcas: viewer.hide (expressões regulares dos materiais) esconde a marca real e
   viewer.mark desenha a fictícia (pera ou texto) no mesmo sítio.
   O ciclo de render só corre com o visor ativo (setActive). Contexto WebGL perdido:
   V.onLost() e a loja mostra a imagem do produto.
   ========================================================================= */
(function (root) {
    'use strict';

    let T = null;
    const V = { ready: false, failed: false, onInteract: null, onLost: null };

    let renderer = null, scene = null, camera = null, host = null, canvas = null;
    let envRT = null, shadow = null, shadowTex = null, pivot = null, floor = null, floorTex = [];
    let model = null, mixer = null, action = null, foldTime = 2, animationKind = null, extras = [];
    let raf = 0, active = false, lastT = 0, dirty = true, loadToken = 0, currentKey = null;
    let fitDist = 0.45, fitY = 0.08, resizeObs = null, maxAniso = 4;

    const ELEV_MIN = -0.12, ELEV_MAX = 1.05, ZOOM_MIN = 0.55, ZOOM_MAX = 1.8;
    const ZOOM_DEF = 1.14;   /* vista inicial um pouco mais afastada (pedido do dono, 3 out): o aparelho respira no palco */
    const AUTO_SPEED = 0.32, IDLE_MS = 3500, FOLD_MS = 1250, RESET_MS = 650;
    const ELEV_LIFT = 0.10;    // a câmara olha um pouco de cima: o anel do chão lê-se como um pedestal
    const FIT_MARGIN = 1.18;    // folga à volta do aparelho (o anel do chão também tem de caber)
    let caseHoverNodes = [], caseHoverAmount = 0, caseHoverClock = 0;
    const CASE_RESPONSE = 6;   // amortecimento suave, conservando a velocidade ao inverter
    const st = {
        yaw: 0, elev: 0.1, zoom: ZOOM_DEF, zoomT: ZOOM_DEF, yawVel: 0, elevVel: 0, auto: 0,
        defYaw: 0, defElev: 0.1, lastInput: 0, dragging: false, lx: 0, ly: 0, lt: 0, pid: null,
        fold: 0, foldFrom: 0, foldTo: 0, foldStart: 0, reset: null, interacted: false,
        caseProgress: 0, caseTo: 0, caseVelocity: 0,
    };

    const clamp = (v, a, b) => Math.max(a, Math.min(b, v));
    const ease = t => (t < 0.5 ? 4 * t * t * t : 1 - Math.pow(-2 * t + 2, 3) / 2);
    const now = () => performance.now();

    /* ---------------------------------------------------------------- carregar o three.js (uma vez) */
    let loading = null;
    function inject(src) {
        return new Promise(resolve => {
            const s = document.createElement('script');
            s.src = src;
            s.async = false;
            s.onload = () => resolve(true);
            s.onerror = () => { console.error('[apex_phone] loja: não foi possível carregar', src); resolve(false); };
            document.head.appendChild(s);
        });
    }
    V.load = function () {
        if (loading) return loading;
        loading = (async () => {
            if (!(root.THREE && root.THREE.WebGLRenderer)) {
                if (!(await inject('vendor/three/three.min.js'))) return false;
            }
            if (!(root.THREE && root.THREE.GLTFLoader)) {
                if (!(await inject('vendor/three/GLTFLoader.js'))) return false;
            }
            T = root.THREE || null;
            return V.supported();
        })();
        return loading;
    };

    // sem criar um contexto de teste (cada contexto WebGL conta para o limite do CEF): se o WebGL faltar,
    // o WebGLRenderer rebenta no mount e a loja mostra a imagem do produto
    V.supported = () => !!(T && T.GLTFLoader && root.WebGLRenderingContext);

    /* ---------------------------------------------------------------- texturas feitas em canvas */
    function canvasTex(w, h, draw, srgb) {
        const c = document.createElement('canvas');
        c.width = w; c.height = h;
        draw(c.getContext('2d'), w, h);
        const t = new T.CanvasTexture(c);
        if (srgb) t.encoding = T.sRGBEncoding;
        return t;
    }

    function makeShadowTexture() {
        return canvasTex(256, 256, (g, w, h) => {
            const r = g.createRadialGradient(w / 2, h / 2, 0, w / 2, h / 2, w / 2);
            r.addColorStop(0, 'rgba(0,0,0,0.70)');
            r.addColorStop(0.35, 'rgba(0,0,0,0.42)');
            r.addColorStop(0.7, 'rgba(0,0,0,0.12)');
            r.addColorStop(1, 'rgba(0,0,0,0)');
            g.fillStyle = r;
            g.fillRect(0, 0, w, h);
        }, false);
    }

    /* chão holográfico: halo suave, anel fino e anel de marcas (graus), tudo estático e aditivo */
    function makeHaloTexture() {
        return canvasTex(256, 256, (g, w, h) => {
            const r = g.createRadialGradient(w / 2, h / 2, 0, w / 2, h / 2, w / 2);
            r.addColorStop(0, 'rgba(242,243,245,0.16)');
            r.addColorStop(0.42, 'rgba(242,243,245,0.06)');
            r.addColorStop(0.75, 'rgba(242,243,245,0.015)');
            r.addColorStop(1, 'rgba(242,243,245,0)');
            g.fillStyle = r;
            g.fillRect(0, 0, w, h);
        }, false);
    }
    function makeTicksTexture() {
        return canvasTex(1024, 1024, (g, w, h) => {
            const cx = w / 2, cy = h / 2;
            g.translate(cx, cy);
            g.strokeStyle = 'rgba(242,243,245,0.9)';
            for (let i = 0; i < 120; i++) {
                const a = (i / 120) * Math.PI * 2;
                const major = i % 10 === 0;
                const r1 = w * 0.47, r2 = w * (major ? 0.435 : 0.455);
                g.lineWidth = major ? 3 : 1.4;
                g.globalAlpha = major ? 0.95 : 0.45;
                g.beginPath();
                g.moveTo(Math.cos(a) * r1, Math.sin(a) * r1);
                g.lineTo(Math.cos(a) * r2, Math.sin(a) * r2);
                g.stroke();
            }
            g.globalAlpha = 0.35;
            g.lineWidth = 1.2;
            g.beginPath();
            g.arc(0, 0, w * 0.485, 0, Math.PI * 2);
            g.stroke();
        }, false);
    }

    function buildFloor() {
        const grp = new T.Group();
        const add = (geo, map, color, opacity, y) => {
            const m = new T.Mesh(geo, new T.MeshBasicMaterial({
                map: map || null, color, transparent: true, opacity, depthWrite: false,
                blending: T.AdditiveBlending, toneMapped: false, side: T.DoubleSide,
            }));
            m.rotation.x = -Math.PI / 2;
            m.position.y = y;
            m.renderOrder = -2;
            grp.add(m);
            return m;
        };
        const halo = makeHaloTexture(), ticks = makeTicksTexture();
        floorTex.push(halo, ticks);
        add(new T.PlaneGeometry(2.5, 2.5), halo, 0xffffff, 0.7, 0.0001);         // halo (grafite: luz branca baixa, sem azul)
        add(new T.RingGeometry(0.985, 1.0, 128), null, 0xe6e8ec, 0.42, 0.0002);    // anel fino
        add(new T.RingGeometry(0.62, 0.626, 128), null, 0xe6e8ec, 0.14, 0.0002);   // anel interior
        add(new T.PlaneGeometry(2.6, 2.6), ticks, 0xe6e8ec, 0.16, 0.0003);         // marcas
        return grp;
    }

    /* Estúdio para o mapa de ambiente: sala escura com caixas de luz (valores > 1 = HDR no PMREM) */
    function buildStudio() {
        const s = new T.Scene();
        const room = new T.Mesh(new T.BoxGeometry(1, 1, 1), new T.MeshBasicMaterial({ color: 0x15171d, side: T.BackSide }));
        room.scale.set(14, 10, 14);
        room.position.set(0, 3, 0);
        s.add(room);
        const panel = (w, h, x, y, z, k, tint) => {
            const c = new T.Color(tint || 0xffffff).multiplyScalar(k);
            const m = new T.Mesh(new T.PlaneGeometry(w, h), new T.MeshBasicMaterial({ color: c, side: T.DoubleSide }));
            m.position.set(x, y, z);
            m.lookAt(0, 0.4, 0);
            s.add(m);
        };
        panel(6, 4, 0, 7.5, 0.5, 4.0);                 // tecto (caixa grande por cima)
        panel(3.2, 4.2, -5.2, 3.2, 3.6, 6.5);           // principal, à frente e à esquerda
        panel(2.0, 4.0, 5.6, 2.6, 2.4, 2.0, 0xf2f3f5);  // preenchimento, à direita
        panel(0.7, 5.0, -3.0, 3.0, -5.8, 5.5, 0xf2f3f5); // contraluz em tira (neutra, como o palco)
        panel(0.7, 5.0, 3.2, 3.0, -5.8, 4.5, 0xf2f3f5);  // contraluz em tira
        panel(8, 1.2, 0, 0.2, 6.5, 0.5);                // reflexo baixo à frente (realça as arestas)
        return s;
    }

    function disposeTree(obj) {
        obj.traverse(o => {
            if (o.geometry) o.geometry.dispose();
            const mats = o.material ? (Array.isArray(o.material) ? o.material : [o.material]) : [];
            mats.forEach(m => {
                if (!m) return;
                for (const k in m) {
                    const v = m[k];
                    if (v && v.isTexture) v.dispose();
                }
                m.dispose();
            });
        });
    }

    /* ---------------------------------------------------------------- montar uma vez (depois do load()) */
    V.mount = function (hostEl) {
        if (V.ready) {
            if (host !== hostEl) { host = hostEl; host.insertBefore(canvas, host.firstChild); observe(); }
            return true;
        }
        if (V.failed || !V.supported()) { V.failed = true; return false; }
        host = hostEl;
        canvas = document.createElement('canvas');
        canvas.className = 'xs-gl';
        try {
            renderer = new T.WebGLRenderer({ canvas, antialias: true, alpha: true, premultipliedAlpha: true, powerPreference: 'high-performance' });
        } catch (e) {
            console.warn('[apex_phone] loja: sem WebGL, a mostrar a imagem do produto', e && e.message);
            V.failed = true;
            canvas = null;
            return false;
        }
        renderer.setPixelRatio(1);
        renderer.setClearColor(0x000000, 0);
        renderer.outputEncoding = T.sRGBEncoding;
        renderer.toneMapping = T.ACESFilmicToneMapping;
        renderer.toneMappingExposure = 1.0;
        maxAniso = Math.min(8, renderer.capabilities.getMaxAnisotropy ? renderer.capabilities.getMaxAnisotropy() : 4);
        host.insertBefore(canvas, host.firstChild);

        scene = new T.Scene();
        camera = new T.PerspectiveCamera(28, 1, 0.005, 30);

        const pmrem = new T.PMREMGenerator(renderer);
        const studio = buildStudio();
        envRT = pmrem.fromScene(studio, 0.035);
        scene.environment = envRT.texture;
        disposeTree(studio);
        pmrem.dispose();

        // a luz difusa vem sobretudo do ambiente; as diretas só desenham volume (fortes demais = cores lavadas)
        scene.add(new T.HemisphereLight(0xf4f4f5, 0x141416, 0.2));
        const key = new T.DirectionalLight(0xffffff, 0.7); key.position.set(-1.3, 1.7, 1.5); scene.add(key);
        const fill = new T.DirectionalLight(0xf2f3f5, 0.22); fill.position.set(1.5, 0.6, 1.0); scene.add(fill);
        const rim = new T.DirectionalLight(0xf2f3f5, 0.6); rim.position.set(0.4, 1.1, -1.7); scene.add(rim);

        floor = buildFloor();
        floor.visible = false;
        scene.add(floor);
        pivot = new T.Group();
        scene.add(pivot);
        shadowTex = makeShadowTexture();
        shadow = new T.Mesh(new T.PlaneGeometry(1, 1), new T.MeshBasicMaterial({ map: shadowTex, color: 0x000000, transparent: true, depthWrite: false, toneMapped: false }));
        shadow.rotation.x = -Math.PI / 2;
        shadow.position.y = 0.0004;
        shadow.renderOrder = -1;
        pivot.add(shadow);

        bindInput();
        canvas.addEventListener('webglcontextlost', e => {
            e.preventDefault();
            V.failed = true;
            V.ready = false;
            stopLoop();
            if (V.onLost) V.onLost();
        }, false);
        observe();
        V.ready = true;
        resize();
        return true;
    };

    function observe() {
        if (resizeObs) resizeObs.disconnect();
        if (root.ResizeObserver && host) {
            resizeObs = new ResizeObserver(() => resize());
            resizeObs.observe(host);
        }
    }

    /* 11 nov: o palco vive dentro da janela da loja, que escala com CSS zoom. O clientWidth/Height dá sempre o tamanho
       do desenho (o getBoundingClientRect muda de sentido entre o Chromium 103 do CEF e os atuais); o shop.js diz o zoom
       (setScale) e o canvas fica com os píxeis reais do ecrã. */
    let pxScale = 1;
    V.setScale = function (z) { z = Number(z); pxScale = z > 0 && isFinite(z) ? z : 1; };
    function resize() {
        if (!renderer || !host) return;
        const dpr = Math.min(2, root.devicePixelRatio || 1) * pxScale;
        let w = Math.round(host.clientWidth * dpr), h = Math.round(host.clientHeight * dpr);
        if (w < 2 || h < 2) return;
        const k = Math.min(1, 2048 / Math.max(w, h));
        w = Math.round(w * k); h = Math.round(h * k);
        if (canvas.width !== w || canvas.height !== h) renderer.setSize(w, h, false);
        camera.aspect = w / h;
        camera.updateProjectionMatrix();
        if (model) frame();
        dirty = true;
    }
    V.resize = resize;

    /* ---------------------------------------------------------------- enquadramento
       Dois enquadramentos: aberto e fechado (dobráveis). A câmara e o centro do modelo
       passam de um para o outro ao ritmo da dobra, por isso o aparelho fechado fica
       centrado e do tamanho certo em vez de encolhido a um canto. */
    let geo = null;     // { start: { size, center }, end: { size, center, lift } }
    let fitA = { dist: 0.45, y: 0.08 }, fitB = fitA;
    function fitFor(size, lift) {
        const r = Math.max(0.015, size.length() / 2);
        const vfov = T.MathUtils.degToRad(camera.fov);
        const hfov = 2 * Math.atan(Math.tan(vfov / 2) * camera.aspect);
        return { dist: r / Math.sin(Math.min(vfov, hfov) / 2) * FIT_MARGIN, y: (lift || 0) + size.y * 0.5 };
    }
    function frame() {
        if (!geo) return;
        fitA = fitFor(geo.start.size, 0);
        fitB = geo.end ? fitFor(geo.end.size, geo.end.lift) : fitA;
        const far = Math.max(fitA.dist, fitB.dist);
        camera.near = Math.max(0.002, Math.min(fitA.dist, fitB.dist) / 60);
        camera.far = far * 30;
        camera.updateProjectionMatrix();
    }

    function placeCamera() {
        const f = animationProgress();
        fitDist = fitA.dist + (fitB.dist - fitA.dist) * f;
        fitY = fitA.y + (fitB.y - fitA.y) * f;
        const d = fitDist * st.zoom;
        // a mira fica um pouco abaixo do centro: o aparelho sobe no palco e o anel do chao cabe por baixo dele
        const aim = fitY - fitDist * 0.04;
        camera.position.set(0, aim + d * Math.sin(st.elev), d * Math.cos(st.elev));
        camera.lookAt(0, aim, 0);
        pivot.rotation.y = st.yaw;
    }

    /* ---------------------------------------------------------------- materiais e marcas */
    function hideRegex(spec) {
        return (spec.hide || []).map(s => { try { return new RegExp(s); } catch (e) { return null; } }).filter(Boolean);
    }

    function prepare(obj, spec) {
        const res = hideRegex(spec);
        const hidden = [];
        obj.traverse(o => {
            if (!o.isMesh) return;
            const mats = Array.isArray(o.material) ? o.material : [o.material];
            if (res.length && mats.some(m => m && res.some(r => r.test(m.name || '')))) {
                o.visible = false;
                hidden.push(o);
                return;
            }
            mats.forEach(m => {
                if (!m) return;
                m.envMapIntensity = 0.8;   // o estúdio é claro: sem isto as cores pastel lavam para branco
                if (m.transmission !== undefined && m.transmission > 0) {
                    // o r128 não tem transmissão a sério: vidro = transparência com reflexos do estúdio
                    m.transmission = 0;
                    m.transparent = true;
                    m.opacity = 0.3;
                    m.depthWrite = false;
                    m.metalness = 0;
                    m.roughness = Math.min(m.roughness === undefined ? 0.1 : m.roughness, 0.08);
                }
                ['map', 'emissiveMap', 'normalMap', 'roughnessMap', 'metalnessMap', 'clearcoatMap'].forEach(k => {
                    if (m[k]) m[k].anisotropy = maxAniso;
                });
                m.needsUpdate = true;
            });
        });
        return hidden;
    }

    function drawPear(g, w, h) {
        g.fillStyle = '#fff';
        g.save();
        g.scale(w / 100, h / 120);
        g.beginPath();
        g.moveTo(50, 24);
        g.bezierCurveTo(39, 24, 35, 35, 35, 45);
        g.bezierCurveTo(35, 56, 21, 63, 21, 84);
        g.bezierCurveTo(21, 103, 35, 116, 50, 116);
        g.bezierCurveTo(65, 116, 79, 103, 79, 84);
        g.bezierCurveTo(79, 63, 65, 56, 65, 45);
        g.bezierCurveTo(65, 35, 61, 24, 50, 24);
        g.fill();
        g.beginPath();
        g.moveTo(48.6, 26); g.lineTo(47.4, 10); g.lineTo(51.0, 9.5); g.lineTo(52.2, 26);
        g.fill();
        g.beginPath();
        g.ellipse(61, 13.5, 10, 4.4, -0.45, 0, Math.PI * 2);
        g.fill();
        g.restore();
    }

    function drawText(text) {
        return (g, w, h) => {
            g.fillStyle = '#fff';
            g.textAlign = 'center';
            g.textBaseline = 'middle';
            g.font = '600 ' + Math.round(h * 0.78) + 'px Inter, Arial, sans-serif';
            const spaced = String(text).split('').join(String.fromCharCode(8202));
            g.fillText(spaced, w / 2, h / 2 + h * 0.04);
        };
    }

    /* desenha a marca fictícia (pera / texto) no sítio exato da marca real que se escondeu */
    function addMarks(hidden, spec, modelBox) {
        if (!hidden.length || !spec.mark) return;
        const mc = modelBox.getCenter(new T.Vector3());
        hidden.forEach(o => {
            o.geometry.computeBoundingBox();
            const b = o.geometry.boundingBox.clone();
            const size = b.getSize(new T.Vector3()), c = b.getCenter(new T.Vector3());
            const axes = [['x', size.x], ['y', size.y], ['z', size.z]].sort((a, z) => a[1] - z[1]);
            const thin = axes[0][0];
            if (thin !== 'z') return;   // as marcas destes modelos estão todas nas costas (normal em Z)
            const src = Array.isArray(o.material) ? o.material[0] : o.material;
            const worldC = c.clone().applyMatrix4(o.matrixWorld);
            const facing = worldC.z < mc.z ? -1 : 1;
            let tex, pw, ph;
            if (spec.mark.kind === 'text') {
                tex = canvasTex(512, 96, drawText(spec.mark.text || 'NOVA'), false);
                pw = Math.max(size.x, 0.004) * 1.05;
                ph = pw * (96 / 512);
            } else {
                tex = canvasTex(200, 240, drawPear, false);
                ph = Math.max(size.y, 0.004) * 0.95;
                pw = ph * (100 / 120);
            }
            const mat = new T.MeshPhysicalMaterial({
                color: src && src.color ? src.color.clone() : new T.Color(0x888888),
                metalness: src && src.metalness !== undefined ? src.metalness : 0.6,
                roughness: src && src.roughness !== undefined ? src.roughness : 0.3,
                clearcoat: 1, clearcoatRoughness: 0.08,
                alphaMap: tex, transparent: true, depthWrite: false,
                polygonOffset: true, polygonOffsetFactor: -2, polygonOffsetUnits: -4,
            });
            const plane = new T.Mesh(new T.PlaneGeometry(pw, ph), mat);
            const holder = new T.Group();
            holder.position.copy(o.position);
            holder.quaternion.copy(o.quaternion);
            holder.scale.copy(o.scale);
            plane.position.set(c.x, c.y, facing < 0 ? b.min.z - 0.00012 : b.max.z + 0.00012);
            if (facing < 0) plane.rotation.y = Math.PI;
            holder.add(plane);
            o.parent.add(holder);
        });
    }

    /* ---------------------------------------------------------------- carregar / trocar */
    function clearModel() {
        caseHoverNodes = [];
        caseHoverAmount = caseHoverClock = 0;
        if (mixer) { mixer.stopAllAction(); if (model) mixer.uncacheRoot(model); }
        mixer = null; action = null; animationKind = null;
        st.caseProgress = st.caseTo = st.caseVelocity = 0;
        if (model) { pivot.remove(model); disposeTree(model); }
        model = null;
        geo = null;
        if (floor) floor.visible = false;
        if (shadow) shadow.visible = false;
        extras.forEach(t => t.dispose());
        extras = [];
        if (renderer) renderer.renderLists.dispose();
    }

    function animationProgress() {
        return action ? clamp(animationKind === 'case' ? st.caseProgress : st.fold, 0, 1) : 0;
    }

    function restoreCasePose() {
        caseHoverNodes.forEach(entry => {
            if (entry.poseY !== null) entry.node.position.y = entry.poseY;
        });
    }

    function applyAnimation() {
        if (!action) return;
        restoreCasePose();
        const f = animationProgress();
        action.time = f * foldTime;
        mixer.update(0);
        caseHoverNodes.forEach(entry => { entry.poseY = entry.node.position.y; });
        if (model && geo && geo.end) {
            const a = geo.start.center, b = geo.end.center;
            model.position.x = -(a.x + (b.x - a.x) * f);
            model.position.z = -(a.z + (b.z - a.z) * f);
        }
    }

    function install(gltf, spec) {
        const same = currentKey !== null && currentKey === spec.key;
        clearModel();
        const obj = gltf.scene;
        const hidden = prepare(obj, spec);
        if (gltf.animations && gltf.animations.length) {
            const isCase = spec.kind === 'buds';
            const clip = isCase ? gltf.animations.find(a => a.name === 'Case_Open')
                : gltf.animations.find(a => /fechar|abrir|fold/i.test(a.name)) || gltf.animations[0];
            if (clip && clip.duration > 0) {
                animationKind = isCase ? 'case' : 'fold';
                mixer = new T.AnimationMixer(obj);
                action = mixer.clipAction(clip);
                // a caixa usa o clip inteiro, sem voltar ao início quando chega ao fim
                action.setLoop(T.LoopOnce, 1);
                action.clampWhenFinished = true;
                action.play();
                action.paused = true;
                foldTime = isCase ? clip.duration : clip.duration / 2;
            }
        }
        if (!same || animationKind !== 'fold') st.fold = st.foldTo = st.foldFrom = 0;
        let end = null;
        if (action) {
            // medir as duas poses: dobra fechada a meio / caixa aberta no fim
            action.time = foldTime;
            mixer.update(0);
            obj.updateMatrixWorld(true);
            const bc = new T.Box3().setFromObject(obj);
            end = { size: bc.getSize(new T.Vector3()), center: bc.getCenter(new T.Vector3()), min: bc.min.y };
            action.time = 0;
            mixer.update(0);
        }
        obj.updateMatrixWorld(true);
        const box = new T.Box3().setFromObject(obj);
        addMarks(hidden, spec, box);
        const c = box.getCenter(new T.Vector3()), size = box.getSize(new T.Vector3());
        obj.position.set(-c.x, -box.min.y, -c.z);
        model = obj;
        if (animationKind === 'case') {
            caseHoverNodes = ['Earbud_Left_Lift', 'Earbud_Right_Lift'].map(name => obj.getObjectByName(name))
                .filter(Boolean).map(node => ({ node, poseY: null }));
        }
        pivot.add(obj);
        shadow.visible = true;
        shadow.scale.set(Math.max(size.x, 0.02) * 1.45 + 0.02, Math.max(size.z, 0.012) * 2.4 + 0.03, 1);
        // o anel do chão acompanha o tamanho do aparelho (a pegada maior entre aberto e fechado)
        const foot = Math.min(Math.max(Math.hypot(size.x, size.z) * 0.58, size.y * 0.36), Math.max(size.y * 0.48, Math.hypot(size.x, size.z) * 0.5));
        floor.scale.setScalar(foot);
        floor.visible = true;
        geo = { start: { size, center: c }, end: end ? { size: end.size, center: end.center, lift: end.min - box.min.y } : null };
        frame();
        if (!same) {
            st.defYaw = st.yaw = +spec.yaw || 0;
            st.defElev = st.elev = clamp((spec.pitch === undefined ? 0.1 : +spec.pitch) + ELEV_LIFT, ELEV_MIN, ELEV_MAX);
            st.zoom = st.zoomT = ZOOM_DEF;
            st.yawVel = st.elevVel = st.auto = 0;
            st.lastInput = now();
            st.reset = null;
        }
        applyAnimation();
        currentKey = spec.key;
        dirty = true;
    }

    V.show = function (url, spec, onProgress) {
        if (!V.ready) return Promise.resolve(false);
        const token = ++loadToken;
        spec = spec || {};
        // retirar logo a caixa anterior, incluindo um movimento ainda a decorrer
        if (animationKind === 'case' || spec.kind === 'buds' || currentKey !== spec.key) {
            clearModel();
            dirty = true;
        }
        return new Promise(resolve => {
            const loader = new T.GLTFLoader();
            loader.load(url, gltf => {
                if (token !== loadToken || !V.ready) { disposeTree(gltf.scene); resolve(false); return; }
                try { install(gltf, spec); resolve(true); }
                catch (e) { console.error('[apex_phone] loja: modelo', url, e); resolve(false); }
            }, xhr => {
                if (token === loadToken && onProgress && xhr && xhr.lengthComputable && xhr.total > 0) onProgress(xhr.loaded / xhr.total);
            }, err => {
                if (token === loadToken) console.warn('[apex_phone] loja: GLB', url, err && err.message);
                resolve(false);
            });
        });
    };

    /* tira o modelo da memória da GPU (fechar a loja); o contexto fica para a próxima abertura */
    V.unload = function () {
        loadToken++;
        if (!V.ready) return;
        clearModel();
        currentKey = null;
        st.fold = st.foldTo = st.foldFrom = 0;
        dirty = true;
        if (renderer) renderer.render(scene, camera);   // o canvas fica vazio (não fica o último aparelho pintado)
    };

    V.hasFold = () => !!action && animationKind === 'fold';
    V.isFolded = () => V.hasFold() && st.foldTo > 0.5;
    V.hasCase = () => !!action && animationKind === 'case';
    V.isCaseOpen = () => V.hasCase() && st.caseTo > 0.5;
    V.setCaseOpen = function (open) {
        if (!V.hasCase()) return false;
        st.caseTo = open ? 1 : 0;
        // conservar progresso E velocidade evita saltos em cliques repetidos
        st.lastInput = now();
        st.auto = 0;
        dirty = true;
        return st.caseTo > 0.5;
    };
    V.toggleCase = () => V.setCaseOpen(!V.isCaseOpen());

    V.toggleFold = function () {
        if (!V.hasFold()) return false;
        st.foldFrom = st.fold;
        st.foldTo = st.foldTo > 0.5 ? 0 : 1;
        st.foldStart = now();
        st.lastInput = now();
        return st.foldTo > 0.5;
    };

    V.view = () => ({ yaw: st.yaw, elev: st.elev, zoom: st.zoomT, fold: st.fold, auto: st.auto, active, model: !!model,
        caseProgress: st.caseProgress, caseOpen: V.isCaseOpen(), caseVelocity: st.caseVelocity,
        animationKind, animationTime: action ? action.time : 0 });
    V.stats = () => (renderer ? { geometries: renderer.info.memory.geometries, textures: renderer.info.memory.textures, programs: (renderer.info.programs || []).length } : null);

    /* posição direta da vista (testes e atalhos): { yaw, elev, zoom } em radianos / fator */
    V.setView = function (o) {
        o = o || {};
        if (typeof o.yaw === 'number') st.yaw = o.yaw;
        if (typeof o.elev === 'number') st.elev = clamp(o.elev, ELEV_MIN, ELEV_MAX);
        if (typeof o.zoom === 'number') st.zoom = st.zoomT = clamp(o.zoom, ZOOM_MIN, ZOOM_MAX);
        st.yawVel = st.elevVel = st.auto = 0;
        st.reset = null;
        st.lastInput = now();
        dirty = true;
    };

    V.reset = function () {
        const full = Math.PI * 2;
        let from = st.yaw, to = st.defYaw;
        from = ((from - to) % full + full + Math.PI) % full - Math.PI + to;   // o caminho mais curto até ao ângulo inicial
        st.yaw = from;
        st.reset = { t0: now(), yaw0: from, elev0: st.elev, zoom0: st.zoom };
        st.yawVel = st.elevVel = st.auto = 0;
        st.zoomT = ZOOM_DEF;
        st.lastInput = now();
    };

    /* ---------------------------------------------------------------- ciclo */
    function tick(t) {
        raf = requestAnimationFrame(tick);
        const dt = clamp(((t || now()) - lastT) / 1000, 0, 0.05);
        lastT = t || now();
        if (!model) { if (dirty) { renderer.render(scene, camera); dirty = false; } return; }
        let moving = false;
        if (st.reset) {
            const p = clamp((now() - st.reset.t0) / RESET_MS, 0, 1), e = ease(p);
            st.yaw = st.reset.yaw0 + (st.defYaw - st.reset.yaw0) * e;
            st.elev = st.reset.elev0 + (st.defElev - st.reset.elev0) * e;
            st.zoom = st.zoomT = st.reset.zoom0 + (ZOOM_DEF - st.reset.zoom0) * e;
            if (p >= 1) st.reset = null;
            moving = true;
        } else if (!st.dragging) {
            if (Math.abs(st.yawVel) > 0.002) { st.yaw += st.yawVel * dt; st.yawVel *= Math.pow(0.045, dt); moving = true; } else st.yawVel = 0;
            if (Math.abs(st.elevVel) > 0.002) { st.elev = clamp(st.elev + st.elevVel * dt, ELEV_MIN, ELEV_MAX); st.elevVel *= Math.pow(0.02, dt); moving = true; } else st.elevVel = 0;
            const idle = now() - st.lastInput > IDLE_MS;
            const want = idle ? AUTO_SPEED : 0;
            st.auto += (want - st.auto) * Math.min(1, dt * (idle ? 0.9 : 6));
            if (st.auto > 0.0015) { st.yaw += st.auto * dt; moving = true; }
            if (Math.abs(st.zoomT - st.zoom) > 0.0005) { st.zoom += (st.zoomT - st.zoom) * Math.min(1, dt * 9); moving = true; }
        }
        if (V.hasFold() && Math.abs(st.fold - st.foldTo) > 0.0005) {
            const p = clamp((now() - st.foldStart) / FOLD_MS, 0, 1);
            st.fold = st.foldFrom + (st.foldTo - st.foldFrom) * ease(p);
            if (p >= 1) st.fold = st.foldTo;
            applyAnimation();
            moving = true;
        }
        if (V.hasCase() && (st.caseProgress !== st.caseTo || st.caseVelocity !== 0)) {
            // solução exata de uma mola criticamente amortecida: suave e independente dos FPS
            const offset = st.caseProgress - st.caseTo;
            const c = st.caseVelocity + CASE_RESPONSE * offset;
            const decay = Math.exp(-CASE_RESPONSE * dt);
            st.caseProgress = clamp(st.caseTo + (offset + c * dt) * decay, 0, 1);
            st.caseVelocity = (st.caseVelocity - CASE_RESPONSE * c * dt) * decay;
            if (Math.abs(st.caseProgress - st.caseTo) < 0.0005 && Math.abs(st.caseVelocity) < 0.003) {
                st.caseProgress = st.caseTo;
                st.caseVelocity = 0;
            }
            applyAnimation();
            moving = true;
        }
        if (V.hasCase() && caseHoverNodes.length) {
            const hover = st.caseProgress === 1 && st.caseTo === 1 ? 1 : 0;
            caseHoverAmount += (hover - caseHoverAmount) * (1 - Math.exp(-dt * 9));
            if (caseHoverAmount > 0.0001) {
                caseHoverClock += dt;
                caseHoverNodes.forEach((entry, i) => {
                    entry.node.position.y = entry.poseY + Math.sin(caseHoverClock * Math.PI * 2 / 2.5 + i * 0.65) * 0.0008 * caseHoverAmount;
                });
                moving = true;
            } else {
                caseHoverAmount = 0;
                restoreCasePose();
            }
        }
        if (moving || dirty) {
            placeCamera();
            renderer.render(scene, camera);
            dirty = false;
        }
    }

    function stopLoop() { if (raf) cancelAnimationFrame(raf); raf = 0; }

    V.setActive = function (on) {
        active = !!on && V.ready;
        if (active) {
            if (!raf) { lastT = now(); dirty = true; resize(); raf = requestAnimationFrame(tick); }
        } else {
            stopLoop();
            st.dragging = false;
        }
    };

    /* ---------------------------------------------------------------- rato */
    function interact() {
        st.lastInput = now();
        st.auto = 0;
        st.reset = null;
        if (!st.interacted) { st.interacted = true; if (V.onInteract) V.onInteract(); }
    }
    V.resetHint = () => { st.interacted = false; };

    function bindInput() {
        canvas.addEventListener('pointerdown', e => {
            if (e.button !== 0) return;
            interact();
            st.dragging = true;
            st.pid = e.pointerId;
            st.lx = e.clientX; st.ly = e.clientY; st.lt = now();
            st.yawVel = st.elevVel = 0;
            try { canvas.setPointerCapture(e.pointerId); } catch (x) { /* sem captura: continua a funcionar dentro do canvas */ }
            canvas.classList.add('grabbing');
        });
        canvas.addEventListener('pointermove', e => {
            if (!st.dragging || e.pointerId !== st.pid) return;
            const t = now(), dx = e.clientX - st.lx, dy = e.clientY - st.ly;
            const dtm = Math.max(8, t - st.lt) / 1000;
            st.lx = e.clientX; st.ly = e.clientY; st.lt = t;
            const ry = dx * 0.0092, re = dy * 0.0062;
            st.yaw += ry;
            st.elev = clamp(st.elev + re, ELEV_MIN, ELEV_MAX);
            st.yawVel = st.yawVel * 0.5 + (ry / dtm) * 0.5;
            st.elevVel = st.elevVel * 0.5 + (re / dtm) * 0.5;
            st.lastInput = t;
            dirty = true;
            if (raf === 0 && active) raf = requestAnimationFrame(tick);
        });
        const up = e => {
            if (!st.dragging || (e && e.pointerId !== st.pid)) return;
            st.dragging = false;
            canvas.classList.remove('grabbing');
            try { canvas.releasePointerCapture(st.pid); } catch (x) { /* já libertado */ }
            if (now() - st.lt > 90) { st.yawVel = 0; st.elevVel = 0; }
            st.yawVel = clamp(st.yawVel, -9, 9);
            st.elevVel = clamp(st.elevVel, -4, 4);
            st.lastInput = now();
        };
        canvas.addEventListener('pointerup', up);
        canvas.addEventListener('pointercancel', up);
        canvas.addEventListener('lostpointercapture', up);
        canvas.addEventListener('wheel', e => {
            e.preventDefault();
            interact();
            const k = Math.exp(clamp(e.deltaY, -240, 240) * 0.0012);
            st.zoomT = clamp(st.zoomT * k, ZOOM_MIN, ZOOM_MAX);
        }, { passive: false });
        canvas.addEventListener('dblclick', e => { e.preventDefault(); V.reset(); });
    }

    root.ShopViewer = V;
}(window));
