var sounds = {};
var _playTimers = {};  // debounce rapid play commands (rapid Next/shuffle)

function post(cb, data) {
  try {
    var xhr = new XMLHttpRequest();
    xhr.open("POST", "https://av_music/" + cb, true);
    xhr.setRequestHeader("Content-Type", "application/json");
    xhr.send(JSON.stringify(data || {}));
  } catch (e) {}
}

post("ytInit", {});
setInterval(function () {
  post("ytPing", {});
}, 2000);

function getNameForWindow(win) {
  for (var n in sounds) {
    if (sounds[n].iframe && sounds[n].iframe.contentWindow === win) return n;
  }
  return null;
}

window.addEventListener("message", function (event) {
  var d = event.data;
  if (!d || typeof d !== "object") return;
  if (d.cmd) return;
  var name = getNameForWindow(event.source);
  if (!name) return;
  var entry = sounds[name];
  if (!entry) return;
  if (d.type === "ytReady") {
    post("ytEvent", { name: name, event: "ready", duration: d.duration });
  } else if (d.type === "ytPlaying") {
    if (!entry.started) {
      entry.started = true;
      post("ytEvent", { name: name, event: "playing" });
    } else {
      post("ytEvent", { name: name, event: "resumed" });
    }
  } else if (d.type === "ytPaused") {
    post("ytEvent", { name: name, event: "paused" });
  } else if (d.type === "ytEnded") {
    post("ytEvent", { name: name, event: "ended" });
  } else if (d.type === "ytError") {
    post("ytEvent", { name: name, event: "error", code: d.code });
  } else if (d.type === "ytTime") {
    post("ytEvent", {
      name: name,
      event: "timeSync",
      currentTime: d.currentTime,
      duration: d.duration,
    });
  }
});

function destroySound(name) {
  var e = sounds[name];
  if (!e) return;
  delete sounds[name];
  try {
    if (e.iframe) e.iframe.src = "about:blank";
  } catch (x) {}
  try {
    if (e.iframe && e.iframe.contentWindow)
      e.iframe.contentWindow.postMessage({ cmd: "stop" }, "*");
  } catch (x) {}
  setTimeout(function () {
    try {
      if (e.iframe) e.iframe.remove();
    } catch (x) {}
  }, 100);
}

function _execPlay(p) {
  destroySound(p.name);
  var vol = typeof p.volume === "number" ? p.volume : 0.5;
  var ytVol = p.spatial ? 0 : Math.round(vol * 100);
  var iframe = document.createElement("iframe");
  iframe.id = "p_" + p.name;
  iframe.style.cssText =
    "position:absolute;left:-9999px;top:-9999px;width:200px;height:200px;border:none;";
  iframe.allow = "autoplay";
  var params =
    "vid=" +
    encodeURIComponent(p.videoId || "") +
    "&t=" +
    (p.initialTime || 0) +
    "&live=" +
    (p.isLive ? "1" : "0") +
    "&vol=" +
    ytVol +
    (p.spatial ? "&spatial=1" : "");
  iframe.src = "https://cfx-nui-av_music/html/yt-player.html?" + params;
  document.body.appendChild(iframe);
  sounds[p.name] = {
    iframe: iframe,
    spatial: !!p.spatial,
    baseVol: vol,
    radius: p.radius || 20,
    falloff: 1.0,
    pan: 0,
    started: false,
  };
}

// Debounced play: destroy old iframe immediately, but wait 50 ms before
// creating the new one so rapid Next/shuffle clicks don't cycle iframes
// mid-initialization (which causes postMessage origin mismatches).
function doPlay(p) {
  if (_playTimers[p.name]) {
    clearTimeout(_playTimers[p.name]);
    delete _playTimers[p.name];
  }
  destroySound(p.name);  // tear down immediately so no stale events fire
  _playTimers[p.name] = setTimeout(function () {
    delete _playTimers[p.name];
    _execPlay(p);
  }, 50);
}

window.addEventListener("message", function (event) {
  try {
    var d =
      typeof event.data === "string" ? JSON.parse(event.data) : event.data;
    var cmd = d.cmd,
      name = d.name;
    if (!cmd) return;
    if (cmd === "play") {
      doPlay(d);
      return;
    }
    if (cmd === "stop") {
      destroySound(name);
      return;
    }
    var entry = sounds[name];
    if (!entry) return;
    var win = entry.iframe && entry.iframe.contentWindow;
    if (!win) return;
    if (cmd === "pause") {
      win.postMessage({ cmd: "pause" }, "*");
    } else if (cmd === "resume") {
      win.postMessage({ cmd: "resume" }, "*");
    } else if (cmd === "seek") {
      win.postMessage({ cmd: "seek", time: d.time }, "*");
    } else if (cmd === "volume") {
      entry.baseVol = d.volume;
      if (!entry.spatial)
        win.postMessage({ cmd: "volume", volume: d.volume }, "*");
    } else if (cmd === "filter") {
      win.postMessage({ cmd: "filter", frequency: d.frequency }, "*");
    } else if (cmd === "updateSpatial") {
      if (!entry.spatial) return;
      var sp = d.speaker,
        ls = d.listener && d.listener.position;
      if (!sp || !ls) return;
      var dx = sp.x - ls.x,
        dy = sp.y - ls.y,
        dz = sp.z - ls.z;
      var dist = Math.sqrt(dx * dx + dy * dy + dz * dz);
      var falloff = Math.max(0, 1 - dist / entry.radius);
      entry.falloff = falloff;
      var pan = 0;
      var fwd = d.listener && d.listener.forward;
      if (fwd) {
        var rx = fwd.y,
          ry = -fwd.x;
        var rLen = Math.sqrt(rx * rx + ry * ry);
        if (rLen > 0.001) {
          rx /= rLen;
          ry /= rLen;
        }
        var dxy = Math.sqrt(dx * dx + dy * dy);
        if (dxy > 0.1) {
          pan = (dx * rx + dy * ry) / dxy;
          pan = pan < -1 ? -1 : pan > 1 ? 1 : pan;
        }
      }
      entry.pan = pan;
      win.postMessage(
        { cmd: "volume", volume: entry.baseVol * falloff, pan: pan },
        "*",
      );
    }
  } catch (err) {}
});
