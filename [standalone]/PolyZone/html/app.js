const wrap = document.getElementById("wrap");
const txt = document.getElementById("text");
const status = document.getElementById("status");

function postNui(name, data = {}) {
  fetch(`https://${GetParentResourceName()}/${name}`, {
    method: "POST",
    headers: { "Content-Type": "application/json; charset=UTF-8" },
    body: JSON.stringify(data)
  });
}

window.addEventListener("message", (e) => {
  const d = e.data;

  if (d.action === "open") {
    const t = (d.text || "").trim();
    if (!t) return; // never show blank UI

    wrap.style.display = "flex";      // <-- force show
    wrap.classList.remove("hidden");
    txt.value = d.text || "";
    status.textContent = "";
    setTimeout(() => txt.focus(), 50);
  }

  if (d.action === "close") {
    wrap.style.display = "none";      // <-- force hide
    wrap.classList.add("hidden");
    txt.value = "";
    status.textContent = "";
  }
});

document.getElementById("close").addEventListener("click", () => postNui("close"));

function doCopy(closeAfter) {
  txt.select();
  document.execCommand("copy"); // deprecated but still works in FiveM
  status.textContent = "Copied (CTRL+C safe)";
  if (closeAfter) setTimeout(() => postNui("close"), 150);
}

document.getElementById("copy").addEventListener("click", () => doCopy(false));
document.getElementById("copyclose").addEventListener("click", () => doCopy(true));
