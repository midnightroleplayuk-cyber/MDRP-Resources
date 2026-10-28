
window.Crane3D = (function () {
  "use strict";

  const MODEL_URL = (typeof window !== "undefined" && window.CRANE_MODEL_URL) || "";

  const TILT = 0.36;
  const PRESS = 0.035;
  const TOG = 0.55;
  const DAMP = 0.28;
  const SWAP_JOY = true;
  const SGN = { slewX: -1, boomZ: -1, knuckX: -1, teleZ: -1 };
  const CAM = { dir: [0, 1.65, 0.62], dist: 1.353, lookY: 0.1 };

  let renderer = null, scene = null, camera = null, root = null;
  let raf = null, host = null, onResize = null;
  let loaded = false, loading = false;

  const S = {
    slewL: 0, slewR: 0, boomU: 0, boomD: 0,
    knuckL: 0, knuckR: 0, teleU: 0, teleD: 0,
    winchD: 0, winchU: 0, grab: 0, slow: 0,
    jkey: 0, exit: 0,
  };

  let joyL = null, joyR = null;
  let togSlow = null;
  const btns = [];

  function init() {
    scene = new THREE.Scene();
    camera = new THREE.PerspectiveCamera(33, 1, 0.05, 100);
    camera.position.set(0, 1.75, 2.05);
    camera.lookAt(0, 0.15, 0);

    renderer = new THREE.WebGLRenderer({ antialias: true, alpha: true, powerPreference: "high-performance" });
    renderer.setPixelRatio(Math.min(window.devicePixelRatio || 1, 2));
    renderer.outputEncoding = THREE.sRGBEncoding;
    renderer.physicallyCorrectLights = true;

    scene.add(new THREE.AmbientLight(0xffffff, 0.7));
    scene.add(new THREE.HemisphereLight(0xffffff, 0x3a3a34, 0.65));
    const key = new THREE.DirectionalLight(0xffffff, 1.45); key.position.set(1.3, 2.4, 1.6); scene.add(key);
    const fill = new THREE.DirectionalLight(0xcfe0f0, 0.6); fill.position.set(-1.6, 1.0, -0.6); scene.add(fill);
    const rim = new THREE.DirectionalLight(0xffffff, 0.5); rim.position.set(0, 0.6, -2.4); scene.add(rim);
    const top = new THREE.DirectionalLight(0xffffff, 0.55); top.position.set(0, 3.0, 0.2); scene.add(top);
  }

  const norm = (s) => (s || "").replace(/^[\s_]+|[\s_]+$/g, "");
  function findByName(target) {
    let found = null;
    root.traverse((o) => { if (!found && o.name && norm(o.name) === target) found = o; });
    return found;
  }

  function wrapPivot(mesh, f01) {
    mesh.geometry.computeBoundingBox();
    const bb = mesh.geometry.boundingBox;
    const px = (bb.min.x + bb.max.x) / 2;
    const pz = (bb.min.z + bb.max.z) / 2;
    const py = bb.min.y + f01 * (bb.max.y - bb.min.y);
    const pivot = new THREE.Group();
    pivot.position.set(px, py, pz);
    root.add(pivot);
    pivot.add(mesh);
    mesh.position.set(-px, -py, -pz);
    return pivot;
  }

  function setupParts() {
    const jl = findByName("joystick_L");
    const jr = findByName("joystick_R");
    if (jl) joyL = wrapPivot(jl, 0.14);
    if (jr) joyR = wrapPivot(jr, 0.14);

    const tg = findByName("toggle_slow");
    if (tg) { const p = wrapPivot(tg, 0.08); togSlow = { pivot: p, mesh: tg }; }

    const bmap = [
      { n: "btn_winch_down", k: "winchD" },
      { n: "btn_winch_up", k: "winchU" },
      { n: "btn_grab", k: "grab" },
      { n: "btnstart", k: "jkey" },
      { n: "estop", k: "exit" },
    ];
    bmap.forEach((b) => {
      const m = findByName(b.n);
      if (m) btns.push({ mesh: m, baseY: m.position.y, key: b.k });
    });
  }

  function frameCamera() {
    const box = new THREE.Box3().setFromObject(root);
    const c = box.getCenter(new THREE.Vector3());
    const size = box.getSize(new THREE.Vector3());
    const maxDim = Math.max(size.x, size.y, size.z);
    const fov = (camera.fov * Math.PI) / 180;
    let dist = (maxDim / 2) / Math.tan(fov / 2);
    dist *= CAM.dist;
    const dir = new THREE.Vector3(CAM.dir[0], CAM.dir[1], CAM.dir[2]).normalize();
    camera.position.copy(c.clone().add(dir.multiplyScalar(dist)));
    camera.lookAt(c.x, c.y + CAM.lookY, c.z);
    camera.near = Math.max(0.01, dist / 60);
    camera.far = dist * 12;
    camera.updateProjectionMatrix();
  }

  function loadModel(cb) {
    loading = true;
    const loader = new THREE.GLTFLoader();
    if (THREE.DRACOLoader) {
      const draco = new THREE.DRACOLoader();
      draco.setDecoderPath("./js/vendor/draco/");
      loader.setDRACOLoader(draco);
    }
    const MAX_TRIES = 3;
    let tries = 0;
    const onLoaded = (gltf) => {
      root = gltf.scene;
      scene.add(root);
      setupParts();
      root.updateMatrixWorld(true);
      frameCamera();
      loaded = true;
      loading = false;
      cb && cb();
    };
    const attempt = () => {
      tries += 1;
      loader.load(MODEL_URL, onLoaded, undefined, (err) => {
        console.error("[Crane3D] model load failed (" + tries + "/" + MAX_TRIES
          + "):", MODEL_URL, err);
        if (tries < MAX_TRIES) { setTimeout(attempt, 2000); return; }
        loading = false;
      });
    };
    if (!MODEL_URL) {
      console.error("[Crane3D] window.CRANE_MODEL_URL is not set — see index.html");
      loading = false;
      return;
    }
    attempt();
  }

  function damp(cur, target) { return cur + (target - cur) * DAMP; }

  function slewAxis() { return SWAP_JOY ? [S.knuckR, S.knuckL, S.teleU, S.teleD] : [S.slewR, S.slewL, S.boomU, S.boomD]; }
  function knuckAxis() { return SWAP_JOY ? [S.slewR, S.slewL, S.boomU, S.boomD] : [S.knuckR, S.knuckL, S.teleU, S.teleD]; }

  function tick() {
    if (joyL) {
      const [xr, xl, yu, yd] = slewAxis();
      joyL.rotation.z = damp(joyL.rotation.z, (xr - xl) * TILT * SGN.slewX);
      joyL.rotation.x = damp(joyL.rotation.x, (yu - yd) * TILT * SGN.boomZ);
    }
    if (joyR) {
      const [xr, xl, yu, yd] = knuckAxis();
      joyR.rotation.z = damp(joyR.rotation.z, (xr - xl) * TILT * SGN.knuckX);
      joyR.rotation.x = damp(joyR.rotation.x, (yu - yd) * TILT * SGN.teleZ);
    }
    if (togSlow) togSlow.pivot.rotation.x = damp(togSlow.pivot.rotation.x, (S.slow ? 1 : 0) * TOG);
    for (let i = 0; i < btns.length; i++) {
      const b = btns[i];
      b.mesh.position.y = damp(b.mesh.position.y, b.baseY - (S[b.key] ? PRESS : 0));
    }
  }

  function animate() {
    raf = requestAnimationFrame(animate);
    if (loaded) tick();
    renderer.render(scene, camera);
  }

  function resize() {
    if (!host || !renderer) return;
    const w = host.clientWidth || host.offsetWidth;
    const h = host.clientHeight || host.offsetHeight;
    if (!w || !h) return;
    renderer.setSize(w, h, false);
    camera.aspect = w / h;
    camera.updateProjectionMatrix();
  }

  function setKeys(keys) {
    if (!keys) return;
    for (const k in S) if (k in keys) S[k] = keys[k] ? 1 : 0;
  }

  function show(el, keys) {
    if (typeof THREE === "undefined") { console.error("[Crane3D] THREE yok"); return; }
    host = el;
    if (!renderer) init();
    el.appendChild(renderer.domElement);
    resize();
    setKeys(keys);
    if (!loaded && !loading) loadModel();
    if (!raf) animate();
    onResize = resize;
    window.addEventListener("resize", onResize);
  }

  function hide() {
    if (raf) { cancelAnimationFrame(raf); raf = null; }
    if (renderer && renderer.domElement && renderer.domElement.parentNode) {
      renderer.domElement.parentNode.removeChild(renderer.domElement);
    }
    if (onResize) { window.removeEventListener("resize", onResize); onResize = null; }
  }

  return { show, hide, setKeys };
})();
