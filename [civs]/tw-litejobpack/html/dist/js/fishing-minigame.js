// ===========================
// FISHING MINIGAME (Redesigned)
// ===========================
// Vertical timing bar with bouncing cursor — hit SPACE in sweet spot
// Features: timer ring, hit dots, particles, smooth animations

var resourceName = "tw-litejobpack";
if (window.GetParentResourceName) {
    resourceName = window.GetParentResourceName();
}

// ---- State ----
window._fishingMinigame = {
    active: false,
    sweetSpotSize: 0.20,
    speed: 1.5,
    hitsRequired: 2,
    hitsCompleted: 0,
    timeLimit: 15,
    timeRemaining: 15,
    timerInterval: null,
    animFrame: null,

    cursorPos: 0.0,
    cursorDirection: 1,
    baseSpeed: 0.015,

    sweetSpotStart: 0.0,
    sweetSpotEnd: 0.0,

    fishLabel: "",
    difficulty: "",
};

// ---- Cleanup ----
window.cleanupFishingMinigame = function () {
    var state = window._fishingMinigame;
    state.active = false;
    state.hitsCompleted = 0;
    state.cursorPos = 0.0;
    state.cursorDirection = 1;

    if (state.timerInterval) {
        clearInterval(state.timerInterval);
        state.timerInterval = null;
    }
    if (state.animFrame) {
        cancelAnimationFrame(state.animFrame);
        state.animFrame = null;
    }
    if (window._fishingKeyHandler) {
        document.removeEventListener("keydown", window._fishingKeyHandler);
        window._fishingKeyHandler = null;
    }

    // Exit animation
    var container = document.getElementById("fm-container");
    if (container) {
        container.classList.add("fm-exit");
    }
};

// ---- Sweet spot randomization ----
function randomizeSweetSpot() {
    var state = window._fishingMinigame;
    var margin = 0.05;
    var maxStart = 1.0 - state.sweetSpotSize - margin;
    var start = margin + Math.random() * maxStart;
    state.sweetSpotStart = start;
    state.sweetSpotEnd = start + state.sweetSpotSize;

    var el = document.getElementById("fishing-sweetspot");
    if (el) {
        el.style.top = (state.sweetSpotStart * 100) + "%";
        el.style.height = (state.sweetSpotSize * 100) + "%";
    }
}

// ---- Animation loop ----
function fishingAnimLoop() {
    var state = window._fishingMinigame;
    if (!state.active) return;

    var moveAmount = state.baseSpeed * state.speed;
    state.cursorPos += moveAmount * state.cursorDirection;

    if (state.cursorPos >= 1.0) {
        state.cursorPos = 1.0;
        state.cursorDirection = -1;
    } else if (state.cursorPos <= 0.0) {
        state.cursorPos = 0.0;
        state.cursorDirection = 1;
    }

    var cursor = document.getElementById("fishing-cursor");
    if (cursor) {
        cursor.style.top = (state.cursorPos * 100) + "%";
    }

    state.animFrame = requestAnimationFrame(fishingAnimLoop);
}

// ---- Sweet spot check ----
function isCursorInSweetSpot() {
    var state = window._fishingMinigame;
    return state.cursorPos >= state.sweetSpotStart && state.cursorPos <= state.sweetSpotEnd;
}

// ---- Flash effect ----
function flashBar(type) {
    var flash = document.getElementById("fm-flash");
    if (!flash) return;

    flash.classList.remove("fm-flash-hit", "fm-flash-miss");
    // Force reflow
    void flash.offsetWidth;
    flash.classList.add(type === "hit" ? "fm-flash-hit" : "fm-flash-miss");
}

// ---- Particles ----
function spawnParticles(type) {
    var container = document.getElementById("fm-particles");
    if (!container) return;

    var count = type === "hit" ? 8 : 5;
    for (var i = 0; i < count; i++) {
        var p = document.createElement("div");
        p.className = "fm-particle " + (type === "hit" ? "fm-particle-hit" : "fm-particle-miss");

        var size = 3 + Math.random() * 5;
        p.style.width = size + "px";
        p.style.height = size + "px";

        // Position near center of bar
        p.style.left = "50%";
        p.style.top = "50%";

        var angle = Math.random() * Math.PI * 2;
        var dist = 30 + Math.random() * 60;
        p.style.setProperty("--px", (Math.cos(angle) * dist) + "px");
        p.style.setProperty("--py", (Math.sin(angle) * dist) + "px");

        container.appendChild(p);

        // Cleanup after animation
        (function (el) {
            setTimeout(function () {
                if (el.parentNode) el.parentNode.removeChild(el);
            }, 700);
        })(p);
    }
}

// ---- Update hit dots ----
function updateHitDots() {
    var state = window._fishingMinigame;
    for (var i = 0; i < state.hitsRequired; i++) {
        var dot = document.getElementById("fm-hit-" + i);
        if (dot) {
            dot.classList.remove("completed", "failed");
            if (i < state.hitsCompleted) {
                dot.classList.add("completed");
            }
        }
    }
}

// ---- Setup hit dots (create correct number) ----
function setupHitDots() {
    var state = window._fishingMinigame;
    var container = document.getElementById("fm-hits");
    if (!container) return;

    container.innerHTML = "";
    for (var i = 0; i < state.hitsRequired; i++) {
        var dot = document.createElement("div");
        dot.className = "fm-hit-dot";
        dot.id = "fm-hit-" + i;
        container.appendChild(dot);
    }
}

// ---- Setup difficulty dots ----
function setupDifficultyDots(difficulty) {
    var el = document.getElementById("fm-difficulty");
    if (!el) return;

    var levels = { easy: 1, medium: 2, hard: 3 };
    var active = levels[difficulty] || 1;

    var dots = el.querySelectorAll(".fm-diff-dot");
    for (var i = 0; i < dots.length; i++) {
        if (i < active) {
            dots[i].classList.add("active");
        } else {
            dots[i].classList.remove("active");
        }
    }
}

// ---- Timer ring ----
var TIMER_CIRCUMFERENCE = 2 * Math.PI * 17; // r=17

function updateTimerRing() {
    var state = window._fishingMinigame;
    var fill = document.getElementById("fm-timer-fill");
    var text = document.getElementById("fishing-timer-text");

    if (text) {
        text.textContent = state.timeRemaining;
    }

    if (fill) {
        var ratio = state.timeRemaining / state.timeLimit;
        var offset = TIMER_CIRCUMFERENCE * (1 - ratio);
        fill.style.strokeDashoffset = offset;

        fill.classList.remove("warning", "critical");
        if (ratio <= 0.2) {
            fill.classList.add("critical");
        } else if (ratio <= 0.4) {
            fill.classList.add("warning");
        }
    }
}

// ---- Handle hit attempt ----
function handleFishingHit() {
    var state = window._fishingMinigame;
    if (!state.active) return;

    if (isCursorInSweetSpot()) {
        state.hitsCompleted++;
        flashBar("hit");
        spawnParticles("hit");
        updateHitDots();

        if (typeof clicksound === "function") {
            clicksound("click.mp3", true);
        }

        if (state.hitsCompleted >= state.hitsRequired) {
            endFishingMinigame(true);
        } else {
            randomizeSweetSpot();
            state.speed += 0.2;
        }
    } else {
        flashBar("miss");
        spawnParticles("miss");

        // Mark current dot as failed
        var dot = document.getElementById("fm-hit-" + state.hitsCompleted);
        if (dot) dot.classList.add("failed");

        endFishingMinigame(false);
    }
}

// ---- End minigame ----
function endFishingMinigame(success) {
    var state = window._fishingMinigame;
    if (!state.active) return;

    window.cleanupFishingMinigame();

    $.post(
        "https://" + resourceName + "/fishingMinigameResult",
        JSON.stringify({ success: success })
    );
}

// ---- Start minigame ----
window.startFishingMinigame = function (config) {
    window.cleanupFishingMinigame();

    var state = window._fishingMinigame;
    state.active = true;
    state.sweetSpotSize = config.sweetSpotSize || 0.20;
    state.speed = config.speed || 1.5;
    state.hitsRequired = config.hitsRequired || 2;
    state.hitsCompleted = 0;
    state.timeLimit = config.timeLimit || 15;
    state.timeRemaining = state.timeLimit;
    state.cursorPos = 0.0;
    state.cursorDirection = 1;
    state.baseSpeed = 0.015;
    state.fishLabel = config.fishLabel || "Balik";
    state.difficulty = config.difficulty || "medium";

    // Remove exit class, restore animation
    var container = document.getElementById("fm-container");
    if (container) {
        container.classList.remove("fm-exit");
    }

    // Fish name
    var fishName = document.getElementById("fishing-fish-name");
    if (fishName) {
        fishName.textContent = state.fishLabel;
    }

    // Difficulty dots
    setupDifficultyDots(state.difficulty);

    // Hit dots
    setupHitDots();

    // Timer ring initial
    var fill = document.getElementById("fm-timer-fill");
    if (fill) {
        fill.style.strokeDasharray = TIMER_CIRCUMFERENCE;
        fill.style.strokeDashoffset = 0;
        fill.classList.remove("warning", "critical");
    }
    updateTimerRing();

    // Sweet spot
    randomizeSweetSpot();

    // Start animation
    state.animFrame = requestAnimationFrame(fishingAnimLoop);

    // Timer countdown
    if (state.timeLimit > 0) {
        state.timerInterval = setInterval(function () {
            if (!state.active) {
                clearInterval(state.timerInterval);
                return;
            }

            state.timeRemaining--;
            updateTimerRing();

            if (state.timeRemaining <= 0) {
                endFishingMinigame(false);
            }
        }, 1000);
    }

    // Key listener
    window._fishingKeyHandler = function (e) {
        if (!state.active) return;

        if (e.code === "Space" || e.keyCode === 32) {
            e.preventDefault();
            handleFishingHit();
        } else if (e.key === "Escape" || e.keyCode === 27) {
            e.preventDefault();
            endFishingMinigame(false);
        }
    };

    document.addEventListener("keydown", window._fishingKeyHandler);
};


