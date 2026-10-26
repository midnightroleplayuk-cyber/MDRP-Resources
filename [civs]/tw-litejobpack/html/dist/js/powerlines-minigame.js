// ===========================
// POWERLINES POLE MINIGAME (FOURMINIGAME)
// ===========================
// Birebir tw-powerlines'dan alindi
// Welding mechanic: Kabloların ucuna tıkla, sürükle, diğer uca bırak

var resourceName = "tw-litejobpack";
if (window.GetParentResourceName) {
    resourceName = window.GetParentResourceName();
}

// Store event listeners for cleanup
window._fourminigameListeners = window._fourminigameListeners || {
    mousemove: null,
    mouseup: null,
    keydown: null
};

// Cleanup function - call before starting new game or when game ends
window.cleanupFourminigame = function() {

    if (window._fourminigameListeners.mousemove) {
        document.removeEventListener("mousemove", window._fourminigameListeners.mousemove);
        window._fourminigameListeners.mousemove = null;
    }
    if (window._fourminigameListeners.mouseup) {
        document.removeEventListener("mouseup", window._fourminigameListeners.mouseup);
        window._fourminigameListeners.mouseup = null;
    }
    if (window._fourminigameListeners.keydown) {
        document.removeEventListener("keydown", window._fourminigameListeners.keydown);
        window._fourminigameListeners.keydown = null;
    }
    // Reset cursor
    document.body.style.cursor = "default";
    // Hide welding element
    var weldingDiv = document.getElementById("ams-welding");
    if (weldingDiv) {
        weldingDiv.style.display = "none";
    }
    // Hide minigame container
    $("#app-minigame").hide();
};

window.fourminigame = function (eventdata) {
    // Clean up any previous listeners first
    window.cleanupFourminigame();

    const COLORS = [
        {
            active: "linear-gradient(to right, rgb(128, 0, 0) 0%, red 45%, red 55%, rgb(128, 0, 0))",
            inactive: "linear-gradient(to right, rgb(48, 0, 0) 0%, rgb(128, 0, 0) 45%, rgb(128, 0, 0) 55%, rgb(48, 0, 0))"
        },
        {
            active: "linear-gradient(to right, rgb(88, 88, 0) 0%, yellow 45%, yellow 55%, rgb(88, 88, 0))",
            inactive: "linear-gradient(to right, rgb(48, 48, 0) 0%, rgb(88, 88, 0) 45%, rgb(88, 88, 0) 55%, rgb(48, 48, 0))"
        },
        {
            active: "linear-gradient(to right, rgb(0, 88, 0) 0%, green 45%, green 55%, rgb(0, 88, 0))",
            inactive: "linear-gradient(to right, rgb(0, 48, 0) 0%, rgb(0, 88, 0) 45%, rgb(0, 88, 0) 55%, rgb(0, 48, 0))"
        },
        {
            active: "linear-gradient(to right, rgb(35, 65, 90) 0%, rgb(70, 130, 180) 45%, rgb(70, 130, 180) 55%, rgb(35, 65, 90))",
            inactive: "linear-gradient(to right, rgb(18, 32, 45) 0%, rgb(35, 65, 90) 45%, rgb(35, 65, 90) 55%, rgb(18, 32, 45))"
        },
        {
            active: "linear-gradient(to right, #A36A00 0%, #FFA500 45%, #FFA500 55%, #A36A00)",
            inactive: "linear-gradient(to right, #754C00 0%, #A36A00 45%, #A36A00 55%, #754C00)"
        }
    ];

    var doorStatus = false;
    var mouse = { x: 0, y: 0 };
    var wires = [];
    var currentWeld;
    var currentTimer;
    var currentTimerLoop;
    var currentGame;
    var audioInstances = {};

    function SetDoor(bool, cb) {
        doorStatus = bool;
        if (bool) {
            $("#am-overlay").addClass("active");
            setTimeout(function () {
                $("#am-overlay").css("background-image", "none");
            }, 900);
        } else {
            $("#am-overlay").removeClass("active");
            setTimeout(function () {
                $("#am-overlay").css("background-image", `url("../img/powerlines/hazard.png")`);
            }, 750);
        }
        if (!cb) return;
        setTimeout(function () {
            cb();
        }, 3000);
    }

    function SetWeldPosition(x, y) {
        let div = document.getElementById("ams-welding");
        if (div) {
            div.style.left = x + "px";
            div.style.top = y + "px";
        }
    }

    function StopAudio(key) {
        if (audioInstances[key]) {
            audioInstances[key].pause();
            audioInstances[key].src = "";
            audioInstances[key].remove();
            delete audioInstances[key];
        }
    }

    function PlayAudio(key, loop) {
        if (audioInstances[key]) {
            audioInstances[key].pause();
            audioInstances[key].currentTime = 0;
            audioInstances[key].play().catch(function() {});
        } else {
            var audio = new Audio("./sounds/" + key + ".mp3");
            audio.loop = loop || false;
            audio.volume = 0.5;
            audio.play().catch(function() {});
            audioInstances[key] = audio;
        }
    }

    function StartWelding(wireIndex, direction) {
        if (currentWeld || wires[wireIndex - 1].wired) return;
        currentWeld = {
            index: wireIndex,
            direction: direction,
            color: wires[wireIndex - 1].color - 1
        };

        $("body").css("cursor", "none");
        $("#ams-welding").css("display", "block");
        SetWeldPosition(mouse.x - 50, mouse.y - 50);

        $.post(
            `https://${resourceName}/welding`,
            JSON.stringify({ toggle: true })
        );
    }

    function StopWelding(index) {
        if (!currentWeld) return;
        var weld = currentWeld;
        currentWeld = null;
        var weldElement = $("#ams-nodes > div:nth-child(" + weld.index + ") > div:nth-child(2)");
        StopAudio("weld");
        $("body").css("cursor", "unset");
        $("#ams-welding").css("display", "none");

        $.post(
            `https://${resourceName}/welding`,
            JSON.stringify({ toggle: false })
        );

        if (weld.direction == index) {
            $(weldElement).css("background", COLORS[weld.color].active);
            wires[weld.index - 1].wired = true;
            PlayAudio("connected");
            CheckGame();
        } else {
            $(weldElement).css("background", COLORS[weld.color].inactive);
            wires[weld.index - 1].wired = false;
            PlayAudio("error");
            currentGame.attemptsLeft -= 1;
            CheckFailGame();
        }
    }

    // Silent cancel - drag interrupted by mouse leaving area, no attempt penalty
    function CancelWelding() {
        if (!currentWeld) return;
        currentWeld = null;
        StopAudio("weld");
        $("body").css("cursor", "unset");
        $("#ams-welding").css("display", "none");
        $.post(
            `https://${resourceName}/welding`,
            JSON.stringify({ toggle: false })
        );
    }

    function WireEvents() {
        $("#ams-nodes > div > div:nth-child(1)").mousedown(function () {
            StartWelding($(this).parent().index() + 1, 0);
        });
        $("#ams-nodes > div > div:nth-child(3)").mousedown(function () {
            StartWelding($(this).parent().index() + 1, 1);
        });
        $("#ams-nodes > div > div:nth-child(1)").mouseup(function () {
            StopWelding(1);
        });
        $("#ams-nodes > div > div:nth-child(3)").mouseup(function () {
            StopWelding(0);
        });
    }

    function CreateWires(wireCount, wireWidth) {
        var _wires = [];
        var html = "";
        var colorIndex = 0;
        var size = wireWidth;
        for (var i = 0; i < wireCount; i++) {
            var wireHtml = `
            <div>
                <div style="width: {SIZE}; background: {COLOR_1};"></div>
                <div style="width: {SIZE}; background: {COLOR_2};"></div>
                <div style="width: {SIZE}; background: {COLOR_1};"></div>
            </div>
            `;
            if (colorIndex >= COLORS.length) {
                colorIndex = 0;
            }
            var color = COLORS[colorIndex];
            wireHtml = wireHtml.replaceAll("{COLOR_1}", color.active);
            wireHtml = wireHtml.replaceAll("{COLOR_2}", color.inactive);
            wireHtml = wireHtml.replaceAll("{SIZE}", size + "vw");
            html += wireHtml;
            colorIndex += 1;
            _wires[i] = {
                size: size,
                color: colorIndex,
                wired: false
            };
        }
        wires = _wires;

        $("#ams-nodes").html(html);
        WireEvents();
    }

    function CheckGame() {
        var missingWire;
        for (var i = 0; i < wires.length; i++) {
            if (!wires[i].wired) {
                missingWire = i;
                break;
            }
        }
        if (missingWire != null) return;
        EndGame(true);
    }

    function CheckFailGame() {
        if (currentGame.attemptsLeft > 0) return;
        EndGame(false);
    }

    function EndGame(success, cancelCallback) {
        if (!currentGame) return;
        if (currentTimerLoop) {
            clearInterval(currentTimerLoop);
        }
        var cb = currentGame.cb;
        currentTimerLoop = null;
        currentTimer = null;
        currentGame = null;
        currentWeld = null;  // Reset weld state
        wires = [];  // Reset wires

        // Clean up event listeners to prevent interference with panel minigame
        if (window.cleanupFourminigame) {
            window.cleanupFourminigame();
        }

        $("#app-minigame").fadeOut(0, () => {
            SetDoor(false, function () {
                $("#ams-nodes").html("");
            });
        });
        // Her zaman callback cagir - mouse kapansin
        if (cb) {
            cb(success);
        }
    }

    function DisplayInt(float) {
        var floor = Math.floor(float);
        if (floor < 10) {
            floor = "0" + floor;
        }
        return floor;
    }

    function GetTimerDisplay() {
        var minutes = Math.floor(currentTimer / 60);
        var seconds = currentTimer - minutes * 60;
        if (minutes < 0) {
            return `<span style="color: red">00:00</span>`;
        }
        return DisplayInt(minutes) + ":" + DisplayInt(seconds);
    }

    function StartTimer(seconds) {
        if (currentTimer) return;
        currentGame.started = true;
        currentTimer = seconds;
        $("#am-timer").html(GetTimerDisplay());
        currentTimerLoop = setInterval(() => {
            PlayAudio("tick");
            var display = GetTimerDisplay();
            currentTimer -= 1;
            if (currentTimer <= 0) {
                currentTimer = 0;
                $("#am-timer").html(`<span style="color: red">${display}</span>`);
                EndGame(false);
            } else if (currentTimer < 10) {
                $("#am-timer").html(`<span style="color: red">${display}</span>`);
            } else {
                $("#am-timer").html(display);
            }
        }, 1000);
    }

    function StartGame(settings, cb) {
        if (currentGame) return;
        currentGame = settings;
        currentGame.attemptsLeft = settings.maxWeldFails ? settings.maxWeldFails : 3;
        settings.wireCount = settings.wireCount ? settings.wireCount : 4;
        settings.wireWidth = settings.wireWidth ? settings.wireWidth : 0.74;
        currentGame.started = false;
        currentGame.cb = cb;
        $("#am-timer").html("");
        $("#app-minigame").fadeIn(1000);
        CreateWires(settings.wireCount, settings.wireWidth);
    }

    function OnGameCompleted(success) {
        $.post(
            `https://${resourceName}/poleMinigameComplete`,
            JSON.stringify({
                success: success
            })
        );
    }

    // Overlay click - kapi ac ve timer baslat
    $(document).ready(() => {
        $("#am-overlay").off("click").on("click", function (ev) {
            if (!currentGame || currentGame.started) return;
            StartTimer(currentGame.time);
            CreateWires(currentGame.wireCount, currentGame.wireWidth);
            SetDoor(!doorStatus);
        });
    });

    // Mouse move - welding cursor takip (stored for cleanup)
    window._fourminigameListeners.mousemove = function (e) {
        mouse.x = e.clientX;
        mouse.y = e.clientY;

        if (!currentWeld) return;

        var x = mouse.x;
        var y = mouse.y;

        var index = currentWeld.index;

        var weldElement = $("#ams-nodes > div:nth-child(" + index + ") > div:nth-child(2)");
        var startElement = $("#ams-nodes > div:nth-child(" + index + ") > div:nth-child(1)");
        var endElement = $("#ams-nodes > div:nth-child(" + index + ") > div:nth-child(3)");

        if (!weldElement.length || !startElement.length || !endElement.length) {
            return;
        }

        var elemRect = $(weldElement)[0].getBoundingClientRect();
        var startRect = $(startElement)[0].getBoundingClientRect();
        var endRect = $(endElement)[0].getBoundingClientRect();

        var min = { x: elemRect.x, y: startRect.y };
        var max = { x: elemRect.x + elemRect.width, y: endRect.y + endRect.height };

        // Generous tolerance: small mouse drift shouldn't fail the welding attempt.
        var TOL = 40;
        if (x + TOL < min.x || x - TOL > max.x || y + TOL < min.y || y - TOL > max.y) {
            CancelWelding();
        }

        SetWeldPosition(x - 50, y - 50);
    };
    document.addEventListener("mousemove", window._fourminigameListeners.mousemove);

    // Mouse up - welding durdur (stored for cleanup)
    window._fourminigameListeners.mouseup = function (ev) {
        if (!currentWeld) return;
        setTimeout(() => {
            if (!currentWeld) return;
            StopWelding();
        }, 100);
    };
    document.addEventListener("mouseup", window._fourminigameListeners.mouseup);

    // ESC - iptal (stored for cleanup)
    window._fourminigameListeners.keydown = function (ev) {
        if (ev.key === "Escape") {
            EndGame(false);
        }
    };
    document.addEventListener("keydown", window._fourminigameListeners.keydown);

    // Oyunu baslat
    StartGame(eventdata, OnGameCompleted);
};
