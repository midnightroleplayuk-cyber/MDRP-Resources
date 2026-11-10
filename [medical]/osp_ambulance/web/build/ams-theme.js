(function () {
  const PARTS = [
    { id: "Head", label: "HEAD", zone: "head", img: "head" },
    { id: "Torso", label: "TORSO", zone: "torso", img: "torso" },
    { id: "Rarm", label: "RIGHT ARM", zone: "rarm", img: "arm_right" },
    { id: "Larm", label: "LEFT ARM", zone: "larm", img: "arm_left" },
    { id: "Rleg", label: "RIGHT LEG", zone: "rleg", img: "leg_right" },
    { id: "Lleg", label: "LEFT LEG", zone: "lleg", img: "leg_left" },
  ];

  const state = {
    open: false,
    tab: "status",
    selected: "Head",
    damage: null,
    inv: [],
    bypass: false,
    jobAccess: {},
    players: [],
    showPlayers: false,
    lang: {},
    medications: [],
    casts: [],
  };

  const resourceName = () =>
    window.GetParentResourceName ? GetParentResourceName() : "osp_ambulance";

  async function nui(name, data) {
    try {
      await fetch(`https://${resourceName()}/${name}`, {
        method: "POST",
        headers: { "Content-Type": "application/json; charset=UTF-8" },
        body: JSON.stringify(data || {}),
      });
    } catch (_) {}
  }

  async function nuiJson(name, data) {
    try {
      const res = await fetch(`https://${resourceName()}/${name}`, {
        method: "POST",
        headers: { "Content-Type": "application/json; charset=UTF-8" },
        body: JSON.stringify(data || {}),
      });
      return await res.json();
    } catch (_) {
      return {};
    }
  }

  function t(path, fallback) {
    const ui = state.lang.ui || window.lang?.ui || {};
    const buttons = state.lang.buttons || window.lang?.buttons || {};
    if (path.startsWith("buttons.")) return buttons[path.slice(8)] || fallback;
    return ui[path] || fallback;
  }

  function hasItem(item) {
    if (!item) return true;
    if (state.bypass) return true;
    return state.inv.some((entry) => entry.item === item && (entry.amount || 0) >= 1);
  }

  function can(action) {
    const access = state.jobAccess || {};
    if (action in access) return access[action] !== false;
    return true;
  }

  function parseMaybe(value) {
    if (typeof value !== "string") return value;
    try {
      return JSON.parse(value);
    } catch (_) {
      return value;
    }
  }

  const WOUND_NAMES = {
    abrasion: "Abrasion",
    avulsion: "Avulsion",
    contusion: "Contusion",
    crush: "Crush",
    cut: "Cut",
    laceration: "Laceration",
    lowvelocitywound: "Low Velocity Wound",
    mediumvelocitywound: "Medium Velocity Wound",
    highvelocitywound: "High Velocity Wound",
    velocitywound: "Velocity Wound",
    puncturewound: "Puncture Wound",
    burn: "Burn",
  };

  const SPLINT_ITEMS = {
    Head: { item: "neckbrace", label: "Neck Brace" },
    Rarm: { item: "armsplint", label: "Arm Splint" },
    Larm: { item: "armsplint", label: "Arm Splint" },
    Rleg: { item: "legsplint", label: "Leg Splint" },
    Lleg: { item: "legsplint", label: "Leg Splint" },
  };

  const CAST_ITEMS = {
    Head: { item: "neckcast", label: "Neck Cast" },
    Rarm: { item: "armcast", label: "Arm Cast" },
    Larm: { item: "armcast", label: "Arm Cast" },
    Rleg: { item: "legcast", label: "Leg Cast" },
    Lleg: { item: "legcast", label: "Leg Cast" },
  };

  function prettyItem(name) {
    return String(name || "")
      .replace(/_/g, " ")
      .replace(/\b\w/g, (ch) => ch.toUpperCase());
  }

  function bestBandage(woundName) {
    let best = { item: "field_dressing", score: -1 };
    for (const med of state.medications || []) {
      if (med.type !== "bandage" || !med.effectivenessModifiers) continue;
      const score = Number(med.effectivenessModifiers[woundName] || 0);
      if (score > best.score) best = { item: med.itemName, score };
    }
    return { item: best.item, label: prettyItem(best.item) };
  }

  const BLOOD_SUFFIX = {
    "O-": "ominus",
    "O+": "oplus",
    "A-": "aminus",
    "A+": "aplus",
    "B-": "bminus",
    "B+": "bplus",
    "AB-": "abminus",
    "AB+": "abplus",
  };

  const PART_PLAN_LABELS = {
    Head: "Head",
    Torso: "Torso",
    Rarm: "Right arm",
    Larm: "Left arm",
    Rleg: "Right leg",
    Lleg: "Left leg",
  };

  function matchingBloodItem(dmg) {
    const type = BLOOD_SUFFIX[dmg?.bloodType] ? dmg.bloodType : (BLOOD_SUFFIX[dmg?.reportedBloodType] ? dmg.reportedBloodType : "O-");
    const item = `blood500ml_${BLOOD_SUFFIX[type] || "ominus"}`;
    return { item, label: `Blood 500ml ${type}` };
  }

  function hasActiveFluidSupport(bpd) {
    const infusions = bpd?.ActiveInfusions || {};
    const names = Object.entries(infusions)
      .filter(([, amount]) => (amount ?? 0) > 0)
      .map(([name]) => String(name).toLowerCase());
    if (names.some((name) => name.includes("saline") || name.includes("blood"))) return true;
    return Number(bpd?.RefillBloodLeft || 0) > 0 || Number(bpd?.TotalBloodFill || 0) > 0;
  }

  function totalBleed(bpd) {
    return PARTS.reduce((sum, part) => sum + Number(bpd?.Bleeding?.[part.id] || 0), 0);
  }

  function applyTreatmentOrder(rowsByPart) {
    let lowest = 99;
    Object.values(rowsByPart).forEach((rows) => {
      rows.forEach((row) => {
        const step = Number(row.step) || 0;
        if (!row.optional && step > 0 && step < lowest) lowest = step;
      });
    });
    if (lowest === 99) lowest = 0;
    Object.values(rowsByPart).forEach((rows) => {
      rows.forEach((row) => {
        const step = Number(row.step) || 0;
        row.locked = !row.optional && step > 0 && lowest > 0 && step > lowest;
      });
    });
    return rowsByPart;
  }

  function buildTreatmentsFallback(part) {
    const all = buildAllTreatmentsFallback();
    return all[part] || [];
  }

  function buildAllTreatmentsFallback() {
    const regions = { Head: [], Torso: [], Rarm: [], Larm: [], Rleg: [], Lleg: [] };
    const dmg = state.damage;
    if (!dmg) return regions;
    const bpd = dmg.BodyPartDamage || {};

    PARTS.forEach((partMeta) => {
      const part = partMeta.id;
      const rows = regions[part];
      const seen = new Set();
      const push = (row) => {
        const key = `${row.condition}|${row.item}|${row.callback}`;
        if (seen.has(key)) return;
        seen.add(key);
        rows.push(row);
      };
      const rawWounds = bpd.Wounds?.[part];
      const wounds = Array.isArray(rawWounds) ? rawWounds : Object.values(rawWounds || {});
      const fracture = bpd.Fractures?.[part];
      const bleeding = Number(bpd.Bleeding?.[part] || 0);

      if (bpd.NeedSewed?.[part]) {
        push({
          condition: "Needs stitches",
          action: "Sewing Kit",
          item: "sewing_kit",
          callback: "UsedMedication",
          step: 2,
          payload: { BodyPart: part, item: "sewing_kit", apply: true },
        });
      }

      if (fracture === true || fracture === "xrayed") {
        const splint = SPLINT_ITEMS[part];
        if (splint) {
          push({
            condition: "Fracture",
            action: `Apply ${splint.label}`,
            item: splint.item,
            callback: "ApplyCast",
            fractured: true,
            step: 3,
            payload: { BodyPart: part, item: splint.item },
          });
        }
      } else if (fracture === "splint") {
        const cast = CAST_ITEMS[part];
        if (cast) {
          push({
            condition: "Fracture",
            action: `Apply ${cast.label}`,
            item: cast.item,
            callback: "ApplyCast",
            fractured: true,
            optional: true,
            step: 3,
            payload: { BodyPart: part, item: cast.item },
          });
        }
      }

      for (const woundName of wounds) {
        if (typeof woundName !== "string") continue;
        const display = WOUND_NAMES[woundName] || prettyItem(woundName);
        const bandage = bestBandage(woundName);
        push({
          condition: display,
          action: bandage.label,
          item: bandage.item,
          callback: "UsedMedication",
          step: bleeding > 0 ? 1 : 2,
          payload: { BodyPart: part, item: bandage.item, apply: true, wound: woundName },
        });
      }

      if (bleeding > 0 && part !== "Head" && part !== "Torso" && !bpd.appliedTourniquets?.[part]) {
        push({
          condition: "Bleeding",
          action: "Tourniquet",
          item: "tourniquet",
          callback: "UsedMedication",
          step: 1,
          payload: { BodyPart: part, item: "tourniquet", apply: true },
        });
      }
    });

    const torso = regions.Torso;
    const torsoSeen = new Set(torso.map((row) => `${row.condition}|${row.item}|${row.callback}`));
    const pushTorso = (row) => {
      const key = `${row.condition}|${row.item}|${row.callback}`;
      if (torsoSeen.has(key)) return;
      torsoSeen.add(key);
      torso.push(row);
    };
    const pulse = Number(dmg.Pulse || 80);
    const spo2 = Number(dmg.oxygenSaturation || 99);
    const arrest = dmg.isDead || dmg.inLastStand || pulse <= 0;
    if (arrest) {
      if (!dmg.epiGiven) {
        pushTorso({
          condition: "Cardiac arrest",
          action: "Administer Epinephrine",
          item: "epinephrine",
          callback: "UsedMedication",
          step: 0,
          payload: { BodyPart: "Torso", item: "epinephrine", apply: true },
        });
      }
      pushTorso({
        condition: "Cardiac arrest",
        action: "Commence CPR",
        callback: "CPR",
        step: 0,
        payload: {},
      });
    }
    if (spo2 < 94) {
      pushTorso({
        condition: "Low oxygen",
        action: "Use BVM",
        item: "bvm",
        callback: "BVM",
        step: 5,
        payload: {},
      });
    }
    const bloodLevel = Number(bpd.BloodLevel || 6);
    if (bloodLevel < 5.2 && !hasActiveFluidSupport(bpd)) {
      if (bloodLevel < 4.2 || totalBleed(bpd) >= 0.35) {
        const blood = matchingBloodItem(dmg);
        pushTorso({
          condition: "Blood loss",
          action: blood.label,
          item: blood.item,
          callback: "UsedMedication",
          step: 4,
          payload: { BodyPart: "Torso", item: blood.item, apply: true },
        });
      } else {
        pushTorso({
          condition: "Blood loss",
          action: "Saline 500ml",
          item: "saline500ml",
          callback: "UsedMedication",
          step: 4,
          payload: { BodyPart: "Torso", item: "saline500ml", apply: true },
        });
      }
    }
    const pain = Number(dmg.Pain || 0);
    if (pain >= 4) {
      const headWounds = bpd.Wounds?.Head;
      const headList = Array.isArray(headWounds) ? headWounds : Object.values(headWounds || {});
      const headInjured = headList.length > 0 || Number(bpd.DamageType?.Head || 0) > 0 || Boolean(bpd.Fractures?.Head);
      const painPart = headInjured ? "Head" : "Torso";
      const painRow = {
        condition: "Pain",
        action: "Administer Morphine",
        item: "morphine",
        callback: "UsedMedication",
        step: 5,
        payload: { BodyPart: painPart, item: "morphine", apply: true },
      };
      if (painPart === "Torso") pushTorso(painRow);
      else regions.Head.push(painRow);
    }
    if (dmg.overdose?.active && !dmg.overdose?.treated) {
      pushTorso({
        condition: "Overdose",
        action: "Administer Narcan",
        item: "narcan",
        callback: "UsedMedication",
        step: 0,
        payload: { BodyPart: "Torso", item: "narcan", apply: true },
      });
    }
    if (dmg.needsGlucose && (dmg.isDead || dmg.inLastStand)) {
      let cause = "Starvation";
      if (dmg.glucoseCause === "thirst") cause = "Dehydration";
      else if (dmg.glucoseCause === "both") cause = "Starvation / Dehydration";
      pushTorso({
        condition: cause,
        action: "Glucose Tablet",
        item: "glucose",
        callback: "GlucoseTablet",
        step: 0,
        payload: {},
      });
    }

    return applyTreatmentOrder(regions);
  }

  function treatmentsFor(part) {
    const fromLua = state.damage?.regionTreatments?.[part];
    if (Array.isArray(fromLua)) return fromLua;
    if (fromLua && typeof fromLua === "object") {
      const list = Object.keys(fromLua)
        .sort((a, b) => Number(a) - Number(b))
        .map((key) => fromLua[key])
        .filter((row) => row && typeof row === "object");
      if (list.length) return list;
    }
    return buildTreatmentsFallback(part);
  }

  function treatmentPlan() {
    const fromLua = state.damage?.treatmentPlan;
    if (Array.isArray(fromLua) && fromLua.length) return fromLua;
    const buckets = {
      1: { title: "Stop bleeding", hints: [] },
      2: { title: "Close wounds", hints: [] },
      3: { title: "Stabilize", hints: [] },
      4: { title: "Fluids", hints: [] },
      5: { title: "Support", hints: [] },
    };
    PARTS.forEach((part) => {
      treatmentsFor(part.id).forEach((row) => {
        const step = Number(row.step) || 0;
        if (row.optional || !buckets[step]) return;
        buckets[step].hints.push(`${PART_PLAN_LABELS[part.id] || part.id} · ${row.action || row.itemLabel || row.condition}`);
      });
    });
    let lowest = 99;
    for (let step = 1; step <= 5; step += 1) {
      if (buckets[step].hints.length && step < lowest) lowest = step;
    }
    return [1, 2, 3, 4, 5].map((step) => {
      const bucket = buckets[step];
      let status = "done";
      if (bucket.hints.length) status = step === lowest ? "current" : "locked";
      return {
        step,
        title: bucket.title,
        status,
        hint: bucket.hints[0] || "Done",
        remaining: bucket.hints.length,
      };
    });
  }

  function isFractured(part) {
    const fracture = state.damage?.BodyPartDamage?.Fractures?.[part];
    if (treatmentsFor(part).some((row) => row.fractured)) return true;
    return fracture === true || fracture === "xrayed" || fracture === "splint";
  }

  function bagLabel(left, total) {
    const size = Number(total) || 0;
    const remain = Number(left) || 0;
    if (size <= 0) return "0/0ml";
    if (size >= 1000) return `${Math.round(remain / 10) / 100}/${size / 1000}L`;
    return `${Math.round(remain)}/${Math.round(size)}ml`;
  }

  function activeInfusionNames() {
    const raw = state.damage?.BodyPartDamage?.ActiveInfusions;
    if (!raw || typeof raw !== "object") return [];
    return Object.entries(raw)
      .filter(([, amount]) => (amount ?? 0) > 0)
      .map(([name]) => String(name).toLowerCase());
  }

  function salineLabel() {
    const bpd = state.damage?.BodyPartDamage || {};
    const names = activeInfusionNames();
    const saline = names.some((name) => name.includes("saline"));
    const propofol = names.some((name) => name.includes("propofol"));
    if (saline || (!propofol && Number(bpd.TotalInfusionFill) > 0)) {
      return bagLabel(bpd.RefillInfusionLeft, bpd.TotalInfusionFill);
    }
    return "0/0ml";
  }

  function bloodIvLabel() {
    const bpd = state.damage?.BodyPartDamage || {};
    return bagLabel(bpd.RefillBloodLeft, bpd.TotalBloodFill);
  }

  function propofolLabel() {
    const bpd = state.damage?.BodyPartDamage || {};
    const names = activeInfusionNames();
    if (names.some((name) => name.includes("propofol"))) {
      return bagLabel(bpd.RefillInfusionLeft, bpd.TotalInfusionFill);
    }
    return "0/0ml";
  }

  function painLabel() {
    const pain = Number(state.damage?.Pain || 0);
    if (pain <= 0) return "None";
    if (pain < 4) return "Mild";
    if (pain < 8) return "Moderate";
    return "Severe";
  }

  function volumePct() {
    const level = Number(state.damage?.BodyPartDamage?.BloodLevel || 6);
    return Math.max(0, Math.min(100, Math.round((level / 6) * 100)));
  }

  function volumeLabel() {
    return `${volumePct()}%`;
  }

  function partFlags(partId) {
    const bpd = state.damage?.BodyPartDamage || {};
    const rawWounds = bpd.Wounds?.[partId];
    const wounds = Array.isArray(rawWounds) ? rawWounds : Object.values(rawWounds || {});
    const bleeding = Number(bpd.Bleeding?.[partId] || 0) > 0;
    const fractured = isFractured(partId);
    const injured = fractured || bleeding || wounds.length > 0 || treatmentsFor(partId).length > 0;
    return { fractured, bleeding, injured };
  }

  function vitalTone(kind, value) {
    if (kind === "triage") {
      const text = String(value || "").toLowerCase();
      if (text.includes("immediate") || text.includes("expectant")) return "is-danger";
      if (text.includes("delayed")) return "is-warn";
      return "";
    }
    if (kind === "pain") {
      if (value === "Severe") return "is-danger";
      if (value === "Moderate") return "is-warn";
      return "";
    }
    if (kind === "bloodloss") {
      if (value === t("severe_bloodloss", "Severe")) return "is-danger";
      if (value === t("moderate_bloodloss", "Moderate")) return "is-warn";
      return "";
    }
    if (kind === "volume") {
      if (value < 50) return "is-danger";
      if (value < 75) return "is-warn";
      return "";
    }
    if (kind === "hr") {
      if (value <= 0 || value < 40) return "is-danger";
      if (value < 50) return "is-warn";
      return "";
    }
    if (kind === "sys") {
      if (value < 80) return "is-danger";
      if (value < 90) return "is-warn";
      return "";
    }
    if (kind === "spo2") {
      if (value < 90) return "is-danger";
      if (value < 94) return "is-warn";
      return "";
    }
    return "";
  }

  function setOpen(open) {
    state.open = open;
    document.documentElement.classList.toggle("ams-ui", open);
    render();
  }

  let deathChromeTimer = null;
  let deathDutyCount = 0;

  function deathDutyText() {
    const n = Math.max(0, Math.floor(Number(deathDutyCount) || 0));
    const deathLang = (state.lang && state.lang.death) || (window.lang && window.lang.death) || {};
    if (n <= 0) return deathLang.duty_online_none || "NO NHC ON DUTY";
    const template = deathLang.duty_online || "%s NHC ON DUTY";
    return template.replace("%s", String(n));
  }

  function deathOverlay() {
    return document.querySelector("#root > div[style*='99998']");
  }

  function syncDeathChrome() {
    const overlay = deathOverlay();
    if (!overlay || !document.documentElement.classList.contains("ams-death")) return;

    const timerSvg = overlay.querySelector("svg[viewBox='0 0 100 100']");
    const ring = timerSvg && timerSvg.parentElement;
    const timerSection = ring && ring.parentElement;
    const wrap = timerSection && timerSection.parentElement;
    if (!wrap) return;

    const text = (overlay.textContent || "").toUpperCase();
    const timerDone = /\b00:00\b/.test(text) || /\b0:00\b/.test(text);
    const waitingRespawn = document.documentElement.classList.contains("ams-death-respawn");
    const canRespawn =
      !waitingRespawn
      || document.documentElement.classList.contains("ams-can-respawn")
      || timerDone;

    if (waitingRespawn) {
      document.documentElement.classList.toggle("ams-can-respawn", canRespawn);
      overlay.querySelectorAll("div, span, p, h1, h2, h3").forEach((el) => {
        const t = (el.textContent || "").trim().toUpperCase().replace(/\s+/g, " ");
        if (t.length === 0 || t.length > 48) return;
        const holdPrompt = t.includes("HOLD E") || (t.includes("HOLD") && t.includes("RESPAWN"));
        const countdown = t === "TO RESPAWN" || t === "RESPAWN";
        if (holdPrompt) {
          el.style.visibility = canRespawn ? "" : "hidden";
          el.style.opacity = canRespawn ? "" : "0";
        } else if (countdown && canRespawn) {
          el.style.visibility = "hidden";
          el.style.opacity = "0";
        }
      });
    }

    overlay.querySelectorAll(".ams-death-label").forEach((node) => {
      node.textContent = "";
      node.style.display = "none";
    });

    overlay.querySelectorAll("div, span, p, button").forEach((el) => {
      const raw = el.textContent || "";
      if (raw.length === 0 || raw.length > 80) return;
      if (!/EMS/i.test(raw) || !/notify|press g/i.test(raw)) return;
      el.textContent = raw
        .replace(/PRESS G TO NOTIFY EMS/ig, "/111   ·   NOTIFY MHS    ")
        .replace(/NOTIFY EMS/ig, "NOTIFY MHS")
        .replace(/\bEMS\b/g, "MHS");
    });

    const emsText = [...overlay.querySelectorAll("div")].find((node) =>
      String(node.getAttribute("style") || "").includes("Inter")
    );
    const emsBox = emsText && emsText.parentElement;

    wrap.querySelectorAll(".ams-death-duty").forEach((node) => {
      if (node.previousElementSibling !== emsBox) node.remove();
    });

    let duty = wrap.querySelector(".ams-death-duty");
    if (!duty) {
      duty = document.createElement("div");
      duty.className = "ams-death-duty";
      if (emsBox.nextSibling) wrap.insertBefore(duty, emsBox.nextSibling);
      else wrap.appendChild(duty);
    }

    if (document.documentElement.classList.contains("ams-death-notified")) {
      duty.textContent = deathDutyText();
      duty.style.display = "";
    } else {
      duty.textContent = "";
      duty.style.display = "none";
    }
  }

  function ensureEyelids() {
    let lids = document.querySelector(".ams-eyelids");
    if (lids) return lids;
    lids = document.createElement("div");
    lids.className = "ams-eyelids";
    lids.innerHTML =
      '<div class="ams-eyelid ams-eyelid-top"></div><div class="ams-eyelid ams-eyelid-bottom"></div><div class="ams-eye-vignette"></div>';
    document.body.appendChild(lids);
    return lids;
  }

  function setDeathPhase(phase) {
    const rootEl = document.documentElement;
    rootEl.classList.toggle("ams-death", phase !== "hidden");
    rootEl.classList.toggle("ams-death-laststand", phase === "laststand");
    rootEl.classList.toggle("ams-death-respawn", phase === "respawn");
    if (phase === "laststand" || phase === "respawn") {
      ensureEyelids();
      if (phase === "respawn" && !rootEl.classList.contains("ams-death-fading")) {
        rootEl.style.setProperty("--ams-death-fade", "0");
      }
    }
    if (phase === "hidden") {
      rootEl.classList.remove("ams-death-notified", "ams-death-fading", "ams-can-respawn");
      rootEl.style.setProperty("--ams-death-fade", "0");
      const lids = document.querySelector(".ams-eyelids");
      if (lids) lids.remove();
      if (deathChromeTimer) {
        clearInterval(deathChromeTimer);
        deathChromeTimer = null;
      }
      return;
    }
    if (!deathChromeTimer) {
      deathChromeTimer = setInterval(syncDeathChrome, 400);
    }
    requestAnimationFrame(syncDeathChrome);
    setTimeout(syncDeathChrome, 80);
  }

  const reception = {
    open: false,
    busy: false,
    hospitalId: null,
    current: null,
    plans: [],
    checkInCost: 0,
    baseCheckInCost: 0,
  };

  const receptionRoot = document.createElement("div");
  receptionRoot.className = "ams-reception";

  function ins(key, fallback) {
    return (window.lang && window.lang.insurance && window.lang.insurance[key])
      || (state.lang.insurance && state.lang.insurance[key])
      || fallback;
  }

  function money(value) {
    return "£" + Math.round(Number(value) || 0);
  }

  function applyReceptionData(data) {
    if (!data || typeof data !== "object") return;
    if (data.hospitalId != null) reception.hospitalId = data.hospitalId;
    if ("current" in data) reception.current = data.current || null;
    if (Array.isArray(data.plans)) reception.plans = data.plans;
    if (data.checkInCost != null) reception.checkInCost = Number(data.checkInCost) || 0;
    if (data.baseCheckInCost != null) reception.baseCheckInCost = Number(data.baseCheckInCost) || 0;
  }

  function closeReception() {
    if (!reception.open) return;
    reception.open = false;
    reception.busy = false;
    document.documentElement.classList.remove("ams-reception-open");
    receptionRoot.classList.remove("is-open");
    receptionRoot.innerHTML = "";
    nui("insuranceClose");
  }

  function hideStockReception() {
    document.querySelectorAll("#root div").forEach((el) => {
      if (el.closest(".ams-reception")) return;
      const z = el.style && el.style.zIndex;
      if (z === "99999") el.style.setProperty("display", "none", "important");
    });
  }

  function openReception(data) {
    applyReceptionData(data);
    reception.open = true;
    document.documentElement.classList.add("ams-reception-open");
    renderReception();
    hideStockReception();
    requestAnimationFrame(hideStockReception);
    setTimeout(hideStockReception, 50);
  }

  function coverStatus() {
    if (!Array.isArray(reception.plans) || reception.plans.length === 0) {
      return ins("nhs_status", "NHS · no charge");
    }
    const current = reception.current;
    if (!current || !current.label) return ins("no_plan", "No cover");
    if (current.expiresDate) return `${current.label} · ${ins("expires_on", "Expires on %s").replace("%s", current.expiresDate)}`;
    return current.label;
  }

  function costLine() {
    const cost = reception.checkInCost;
    const base = reception.baseCheckInCost;
    if (cost <= 0 && !(base > 0)) return "";
    if (base > cost) {
      return `<span class="cost"><s>${escapeHtml(money(base))}</s><b>${escapeHtml(cost <= 0 ? "Covered" : money(cost))}</b></span>`;
    }
    return `<span class="cost"><b>${escapeHtml(money(cost))}</b></span>`;
  }

  function planRows() {
    const plans = Array.isArray(reception.plans) ? reception.plans : [];
    let featuredId = null;
    let best = -1;
    for (const plan of plans) {
      const pct = Number(plan.checkInDiscount) || 0;
      if (!plan.owned && pct > best) {
        best = pct;
        featuredId = plan.id;
      }
    }
    return plans.map((plan) => {
      const pct = Math.round((Number(plan.checkInDiscount) || 0) * 100);
      const days = plan.durationDays
        ? ins("duration_days", "%s days").replace("%s", String(plan.durationDays))
        : ins("duration_permanent", "Until replaced");
      const meds = Array.isArray(plan.freeMedications)
        ? plan.freeMedications.map(prettyItem).join(", ")
        : "";
      const meta = [`${pct}% off check-in`, days, meds].filter(Boolean).join(" · ");
      const owned = Boolean(plan.owned);
      const cls = ["ams-reception-row", owned ? "is-owned" : "", plan.id === featuredId ? "is-featured" : ""]
        .filter(Boolean)
        .join(" ");
      return `
        <div class="${cls}">
          <div>
            <span class="name">${escapeHtml(plan.label || plan.id || "Plan")}</span>
            <span class="meta">${escapeHtml(meta)}</span>
          </div>
          <div class="price">${escapeHtml(money(plan.price))}</div>
          <button class="ams-reception-buy" data-plan="${escapeHtml(String(plan.id || ""))}" ${owned || reception.busy ? "disabled" : ""}>
            ${owned ? ins("owned", "Active") : ins("buy_button", "Buy")}
          </button>
        </div>`;
    }).join("");
  }

  function renderReception() {
    if (!reception.open) {
      receptionRoot.classList.remove("is-open");
      receptionRoot.innerHTML = "";
      return;
    }
    receptionRoot.classList.add("is-open");
    receptionRoot.innerHTML = `
      <div class="ams-reception-panel">
        <div class="ams-reception-head">
          <div class="ams-reception-brand">
            <i class="fa-solid fa-hospital"></i>
            <div>
              <h1>${escapeHtml(ins("reception_title", "Hospital Reception"))}</h1>
              <span>Check-in</span>
            </div>
          </div>
          <button class="ams-reception-close" data-reception="close"><i class="fa-solid fa-xmark"></i></button>
        </div>
        <div class="ams-reception-checkin">
          <div class="ams-reception-status">
            <span class="k">Status</span>
            <span class="v">${escapeHtml(coverStatus())}</span>
            ${costLine()}
          </div>
          <button class="ams-reception-checkin-btn" data-reception="checkin" ${reception.busy ? "disabled" : ""}>Check in</button>
        </div>
        ${Array.isArray(reception.plans) && reception.plans.length ? `
        <div class="ams-reception-cover">
          <div class="ams-reception-cover-label">Cover</div>
          ${planRows()}
        </div>` : ""}
      </div>
    `;
  }

  async function receptionCheckin() {
    if (reception.busy) return;
    reception.busy = true;
    renderReception();
    await nuiJson("insuranceCheckin", { hospitalId: reception.hospitalId });
    reception.open = false;
    reception.busy = false;
    document.documentElement.classList.remove("ams-reception-open");
    receptionRoot.classList.remove("is-open");
    receptionRoot.innerHTML = "";
  }

  async function receptionBuy(planId) {
    if (!planId || reception.busy) return;
    reception.busy = true;
    renderReception();
    const result = await nuiJson("insurancePurchase", { planId });
    reception.busy = false;
    if (result && (result.ok || result.plans)) applyReceptionData(result);
    renderReception();
  }

  function applyMessage(payload) {
    if (!payload || typeof payload !== "object") return;
    if (payload.action === "showInsurance") {
      openReception(payload);
      return;
    }
    if (payload.action === "hideInsurance") {
      if (reception.open) {
        reception.open = false;
        reception.busy = false;
        document.documentElement.classList.remove("ams-reception-open");
        receptionRoot.classList.remove("is-open");
        receptionRoot.innerHTML = "";
      }
      return;
    }
    if (payload.type === "lang" && payload.translations) {
      state.lang = parseMaybe(payload.translations) || state.lang;
    }
    if (payload.jobAccess) state.jobAccess = payload.jobAccess;
    if (typeof payload.bypassItems === "boolean") state.bypass = payload.bypassItems;
    if (payload.invItems) state.inv = parseMaybe(payload.invItems) || [];
    if (payload.medicationData) state.medications = parseMaybe(payload.medicationData) || [];
    if (payload.castsData) state.casts = parseMaybe(payload.castsData) || [];
    if (payload.players) state.players = parseMaybe(payload.players) || [];
    if (payload.damageStatus) {
      const dmg = parseMaybe(payload.damageStatus);
      if (dmg && typeof dmg === "object") {
        state.damage = dmg;
        if (state.open) render();
      }
    }
    if (payload.display === true) setOpen(true);
    if (payload.display === false) setOpen(false);
    if (payload.doctorCount != null) {
      deathDutyCount = Number(payload.doctorCount) || 0;
    }
    if (payload.emsnotif === 2) {
      document.documentElement.classList.add("ams-death-notified");
    } else if (payload.emsnotif === 1 || payload.emsnotif === 3) {
      document.documentElement.classList.remove("ams-death-notified");
    }
    if (payload.emsnotif !== undefined || payload.doctorCount != null) {
      requestAnimationFrame(syncDeathChrome);
    }
    if (payload.deathFade != null) {
      const fade = Math.max(0, Number(payload.deathFade) || 0);
      document.documentElement.style.setProperty("--ams-death-fade", String(fade));
      document.documentElement.classList.toggle("ams-death-fading", fade > 0.01);
    }
    if (payload.death === 1) setDeathPhase("laststand");
    else if (payload.death === 2) {
      setDeathPhase("respawn");
      if (payload.canRespawn !== true) {
        document.documentElement.classList.remove("ams-can-respawn");
      }
    } else if (payload.death === 3) {
      document.documentElement.style.setProperty("--ams-death-fade", "0");
      document.documentElement.classList.remove("ams-death-fading");
      setDeathPhase("hidden");
    }
    if (payload.canRespawn === true) {
      document.documentElement.classList.add("ams-can-respawn");
      requestAnimationFrame(syncDeathChrome);
    } else if (payload.canRespawn === false) {
      document.documentElement.classList.remove("ams-can-respawn");
      requestAnimationFrame(syncDeathChrome);
    }
  }

  function closeUi() {
    nui("focusOff");
    setOpen(false);
    window.postMessage({ display: false }, "*");
  }

  async function runTreatment(row) {
    if (!row || !row.callback || row.locked) return;
    if (row.item && !hasItem(row.item)) return;
    const playerId = state.damage?.ServerId;
    await nui(row.callback, Object.assign({ PlayerId: playerId }, row.payload || {}));
  }

  function footerAction(name) {
    const playerId = state.damage?.ServerId;
    nui(name, { PlayerId: playerId });
  }

  function render() {
    if (!root) return;
    if (!state.open) {
      root.classList.remove("is-open");
      root.innerHTML = "";
      return;
    }

    const dmg = state.damage || {};
    const bpd = dmg.BodyPartDamage || {};
    const pulse = Math.round(Number(dmg.Pulse || 0));
    const bp = Array.isArray(dmg.BloodPressure) ? dmg.BloodPressure : [120, 80];
    const spo2 = Math.round(Number(dmg.oxygenSaturation || 0));
    const selectedMeta = PARTS.find((part) => part.id === state.selected) || PARTS[0];
    const flatline = Boolean(dmg.isDead) || pulse <= 0;

    root.classList.add("is-open");
    root.innerHTML = `
      <div class="ams-shell">
        <div class="ams-header">
          <div class="ams-brand">
            <span class="ams-brand-dot"></span>
            <h1>${t("medical_console", "NATIONAL HEALTH CARE")}</h1>
          </div>
          <div class="ams-sub">${t("patient_assessment", "PATIENT ASSESSMENT")}</div>
          <div class="ams-vitals">
            ${chip("fa-user", "PATIENT", dmg.playerName || "Unknown")}
            ${chip("fa-triangle-exclamation", "TRIAGE", bpd.Triage || "NONE", vitalTone("triage", bpd.Triage))}
            ${dmg.needsGlucose && (dmg.isDead || dmg.inLastStand) ? chip("fa-utensils", "DOWNED", dmg.glucoseCause === "thirst" ? "DEHYDRATION" : dmg.glucoseCause === "both" ? "STARVATION / THIRST" : "STARVATION", "is-danger") : ""}
            ${chip("fa-heart", "PAIN", painLabel(), vitalTone("pain", painLabel()))}
            ${chip("fa-droplet", "BLOODLOSS", volumeLabel(), vitalTone("volume", volumePct()))}
            ${chip("fa-prescription-bottle", "SALINE INJECT", salineLabel())}
            ${chip("fa-heart-circle-plus", "BLOOD INJECT", bloodIvLabel())}
            ${chip("fa-syringe", "PROPOFOL INJECT", propofolLabel())}
          </div>
          <div class="ams-ecg">
            <div class="ams-ecg-grid${flatline ? " is-flatline" : ""}"><div class="ams-ecg-wave"></div></div>
            <div class="ams-ecg-stat ${vitalTone("hr", pulse)}"><b>${pulse || "--"}</b><span>BPM</span></div>
            <div class="ams-ecg-stat ${vitalTone("sys", Math.round(bp[0] || 0))}"><b>${Math.round(bp[0] || 0)}/${Math.round(bp[1] || 0)}</b><span>BP</span></div>
            <div class="ams-ecg-stat ${vitalTone("spo2", spo2)}"><b>${spo2 || "--"}</b><span>SPO2</span></div>
            <button class="ams-close" data-act="close"><i class="fa-solid fa-xmark"></i></button>
          </div>
        </div>
        <div class="ams-toolbar">
          <div class="ams-tabs">
            <button class="ams-tab ${state.tab === "status" ? "is-active" : ""}" data-tab="status">${t("status_tab", "STATUS")}</button>
          </div>
          <button class="ams-log-btn" data-tab="log"><i class="fa-regular fa-clock"></i> ${t("log_tab", "Medical Log")}</button>
        </div>
        <div class="ams-body">
          <aside class="ams-map">
            <div class="ams-map-label">${t("body_map", "BODY MAP")}</div>
            <div class="ams-figure">
              <div class="ams-skel">
                <img class="body" src="./img/background.png" alt="" />
                ${PARTS.map((part) => {
                  const flags = partFlags(part.id);
                  const cls = [
                    "ams-part",
                    part.zone,
                    state.selected === part.id ? "is-selected" : "",
                    flags.fractured ? "is-fractured" : "",
                    flags.injured && !flags.fractured ? "is-injured" : "",
                    flags.bleeding && !flags.fractured ? "is-bleeding" : "",
                  ].filter(Boolean).join(" ");
                  return `
                  <button type="button" class="${cls}" data-part="${part.id}">
                    <img class="limb" src="./img/${part.img}.png" alt="" />
                    <img class="bone" src="./img/${part.img}_fracture.png" alt="" />
                  </button>`;
                }).join("")}
              </div>
            </div>
          </aside>
          <section class="ams-injuries">
            ${state.tab === "log" ? renderLog() : renderGrid(selectedMeta)}
          </section>
        </div>
        <div class="ams-footer">
          <button data-nui="CheckConsciousness">Check Consciousness</button>
          <button data-nui="CheckPulse">Check Pulse</button>
          <button data-nui="CheckBodyTemp">Check Body Temperature</button>
          <button data-nui="CPR" ${can("cpr") ? "" : "disabled"}>Commence CPR</button>
          <button data-nui="Bodybag" ${can("bodybag") ? "" : "disabled"}>Body Bag</button>
        </div>
        ${state.showPlayers ? renderPlayers() : ""}
      </div>
    `;
  }

  function chip(icon, key, value, tone) {
    return `<div class="ams-chip ${tone || ""}"><i class="fa-solid ${icon}"></i><div><span class="k">${key}</span><span class="v">${escapeHtml(String(value))}</span></div></div>`;
  }

  function renderPlan() {
    const plan = treatmentPlan();
    if (!plan.some((row) => row.status === "current" || row.status === "locked")) return "";
    return `
      <div class="ams-plan">
        <div class="ams-plan-label">${t("treatment_plan", "TREATMENT PLAN")}</div>
        ${plan.map((row) => `
          <div class="ams-plan-row is-${escapeHtml(row.status || "done")}">
            <span class="n">${row.step}</span>
            <span class="t">${escapeHtml(row.title || "")}</span>
            <span class="h">${escapeHtml(row.hint || "")}</span>
          </div>`).join("")}
      </div>`;
  }

  function renderGrid(selectedMeta) {
    return `
      <div class="ams-injuries-head">
        <div class="ams-injuries-label">${t("injuries_header", "INJURIES")}</div>
        <div class="sel">${selectedMeta.label}</div>
      </div>
      ${renderPlan()}
      <div class="ams-grid">
        ${PARTS.map(renderCard).join("")}
      </div>
    `;
  }

  function renderCard(part) {
    const rows = treatmentsFor(part.id);
    const fractured = isFractured(part.id);
    const selected = state.selected === part.id;
    let body;
    if (!rows.length) {
      body = `
        <div class="ams-card-empty">
          <i class="fa-solid fa-heart-pulse"></i>
          <b>${t("healthy_status", "HEALTHY")}</b>
          <span>${t("no_wounds_short", "NO WOUNDS")}</span>
        </div>`;
    } else {
      const showGroup = part.id === "Torso" && rows.some((row) => row.condition === "Cardiac arrest" || row.condition === "Low oxygen" || row.condition === "Pain" || row.condition === "Blood loss" || row.condition === "Overdose" || row.condition === "Starvation" || row.condition === "Dehydration" || row.condition === "Starvation / Dehydration" || row.condition === "Shockable rhythm" || row.condition === "Slow heart rate" || row.condition === "Major bleeding");
      body = `
        <div class="ams-treats">
          ${showGroup ? `<div class="ams-treat-group">${t("medications_fluids", "MEDICATIONS & FLUIDS")}</div>` : ""}
          ${rows.map((row) => {
            const locked = row.locked === true;
            const disabled = locked
              || (row.callback && row.item && !hasItem(row.item))
              || (row.callback === "CPR" && !can("cpr"))
              || (row.callback === "BVM" && !hasItem("bvm"));
            return `
              <button class="ams-treat${locked ? " is-locked" : ""}" data-treat="${encodeURIComponent(JSON.stringify(row))}" ${disabled || !row.callback ? "disabled" : ""}>
                <span class="cond">${escapeHtml(row.condition || "")}</span><span class="dot">·</span><span class="need">${escapeHtml(locked ? `Next: ${row.action || row.itemLabel || ""}` : (row.action || row.itemLabel || ""))}</span>
              </button>`;
          }).join("")}
        </div>`;
    }
    return `
      <article class="ams-card${selected ? " is-selected" : ""}${fractured ? " is-fractured" : ""}${rows.length ? " is-hurt" : ""}" data-part="${part.id}">
        <h3>${part.label}</h3>
        ${body}
      </article>`;
  }

  function renderLog() {
    const log = Array.isArray(state.damage?.MessageLog) ? state.damage.MessageLog : [];
    return `
      <div class="ams-injuries-label">${t("log_tab", "Medical Log")}</div>
      <div class="ams-log">
        ${log.length ? log.map((line) => `<div>${escapeHtml(String(line))}</div>`).join("") : `<div class="empty">${t("no_activity_logs", "No activity logs found")}</div>`}
      </div>
    `;
  }

  function renderPlayers() {
    const players = Array.isArray(state.players) ? state.players : [];
    return `
      <div class="ams-nearby">
        ${players.map((player) => `<button data-load="${player.id || player.PlayerId || player.serverId}">${escapeHtml(player.name || player.playerName || "Patient")}</button>`).join("") || `<div class="empty">No nearby patients</div>`}
      </div>
    `;
  }

  function escapeHtml(value) {
    return String(value)
      .replace(/&/g, "&amp;")
      .replace(/</g, "&lt;")
      .replace(/>/g, "&gt;")
      .replace(/"/g, "&quot;");
  }

  const root = document.createElement("div");
  root.className = "ams-root";
  const mount = () => {
    if (!root.parentNode) document.body.appendChild(root);
    if (!receptionRoot.parentNode) document.body.appendChild(receptionRoot);
    render();
  };
  if (document.body) mount();
  else document.addEventListener("DOMContentLoaded", mount);

  window.addEventListener("message", (event) => applyMessage(event.data || {}));

  window.addEventListener("keydown", (event) => {
    if (event.key === "Escape" || event.key === "Esc") {
      if (reception.open) {
        event.preventDefault();
        closeReception();
        return;
      }
      if (!state.open) return;
      event.preventDefault();
      closeUi();
    }
  });

  receptionRoot.addEventListener("click", (event) => {
    if (event.target === receptionRoot) {
      closeReception();
      return;
    }
    const close = event.target.closest("[data-reception='close']");
    if (close) {
      closeReception();
      return;
    }
    const checkin = event.target.closest("[data-reception='checkin']");
    if (checkin) {
      receptionCheckin();
      return;
    }
    const buy = event.target.closest("[data-plan]");
    if (buy && !buy.disabled) {
      receptionBuy(buy.getAttribute("data-plan"));
    }
  });

  root.addEventListener("click", (event) => {
    const close = event.target.closest("[data-act='close']");
    if (close) {
      closeUi();
      return;
    }
    const tab = event.target.closest("[data-tab]");
    if (tab) {
      state.tab = tab.getAttribute("data-tab");
      render();
      return;
    }
    const part = event.target.closest("[data-part]");
    if (part && !event.target.closest("[data-treat]")) {
      state.selected = part.getAttribute("data-part");
      state.tab = "status";
      render();
      return;
    }
    const treat = event.target.closest("[data-treat]");
    if (treat) {
      try {
        runTreatment(JSON.parse(decodeURIComponent(treat.getAttribute("data-treat"))));
      } catch (_) {}
      return;
    }
    const nuiBtn = event.target.closest("[data-nui]");
    if (nuiBtn && !nuiBtn.disabled) {
      footerAction(nuiBtn.getAttribute("data-nui"));
      return;
    }
    const load = event.target.closest("[data-load]");
    if (load) {
      nui("LoadPlayer", { PlayerId: Number(load.getAttribute("data-load")) });
      state.showPlayers = false;
    }
  });
})();
