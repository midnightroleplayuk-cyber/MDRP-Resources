let isBreathalyzerActive = false;
let isPlayerTester = false;
let breathalyzerOfficerId = null;
let breathIndicatorPos = 0;
let breathProgress = 0;
let isKeyEHeld = false;
let breathalyzerTimer = null;
let lastSyncTime = 0;

window.addEventListener('message', function(event) {
    if (event.data.action === 'openBreathalyzer') {
        openBreathalyzer(event.data.officerId, event.data.isPlayer);
    } else if (event.data.action === 'syncBreathProgress') {
        if (!isPlayerTester) {
            updateUIProgress(event.data.progress, event.data.indicatorPos);
        }
    } else if (event.data.action === 'showBreathResult') {
        finishBreathalyzer(true, event.data.result);
    }
});

function openBreathalyzer(officerId, isPlayer) {
    breathalyzerOfficerId = officerId;
    isPlayerTester = isPlayer;
    isBreathalyzerActive = true;
    isKeyEHeld = false;
    
    document.getElementById('breathalyzer-view').classList.remove('hidden');
    document.getElementById('breath-screen').classList.remove('hidden');
    document.getElementById('breath-status').innerText = isPlayer ? window.T('ready_to_test') : window.T('subject_ready');
    document.getElementById('breath-status').style.color = 'white';
    document.getElementById('breath-value').innerText = '0.00%';
    document.getElementById('breath-minigame').classList.add('hidden');
    
    if (isPlayer) {
        document.getElementById('mouthpiece-click').classList.remove('hidden');
    } else {
        document.getElementById('mouthpiece-click').classList.add('hidden');
        document.getElementById('breath-minigame').classList.remove('hidden');
    }
    
    breathProgress = 0;
    breathIndicatorPos = 0;
}

window.startBreathalyzerMinigame = function() {
    if (!isPlayerTester) return;
    
    document.getElementById('mouthpiece-click').classList.add('hidden');
    document.getElementById('breath-status').innerText = window.T('blowing_dots');
    document.getElementById('breath-minigame').classList.remove('hidden');
    
    startMinigameLoop();
};

function updateUIProgress(progress, indicatorPos) {
    document.getElementById('breath-indicator').style.left = indicatorPos + '%';
    
    if (indicatorPos >= 40 && indicatorPos <= 60) {
        document.getElementById('breath-status').style.color = '#00ff00';
    } else {
        document.getElementById('breath-status').style.color = '#ffcc00';
    }
}

function startMinigameLoop() {
    if (breathalyzerTimer) cancelAnimationFrame(breathalyzerTimer);
    
    function loop(time) {
        if (!isBreathalyzerActive) return;

        // INSTANT MOVEMENT LOGIC
        if (isKeyEHeld) {
            breathIndicatorPos += 1.2; // Move UP instantly
        } else {
            breathIndicatorPos -= 0.8; // Move DOWN instantly
        }
        
        // Boundaries
        if (breathIndicatorPos < 0) breathIndicatorPos = 0;
        if (breathIndicatorPos > 100) breathIndicatorPos = 100;

        updateUIProgress(breathProgress, breathIndicatorPos);

        // Sync to server every 100ms (to prevent network spam but keep it smooth)
        if (time - lastSyncTime > 100) {
            fetch(`https://${GetParentResourceName()}/syncBreathProgress`, {
                method: 'POST',
                body: JSON.stringify({
                    officerId: breathalyzerOfficerId,
                    progress: breathProgress,
                    indicatorPos: breathIndicatorPos
                })
            });
            lastSyncTime = time;
        }

        // Check safe zone (40-60)
        if (breathIndicatorPos >= 40 && breathIndicatorPos <= 60) {
            breathProgress += 0.4; // Progress speed
            document.getElementById('breath-status').style.color = '#00ff00';
        }

        // Complete check
        if (breathProgress >= 100) {
            isBreathalyzerActive = false;
            fetch(`https://${GetParentResourceName()}/breathalyzerComplete`, {
                method: 'POST',
                body: JSON.stringify({
                    officerId: breathalyzerOfficerId,
                    success: true
                })
            });
            return;
        }

        breathalyzerTimer = requestAnimationFrame(loop);
    }
    
    breathalyzerTimer = requestAnimationFrame(loop);
}

function finishBreathalyzer(success, resultValue) {
    isBreathalyzerActive = false;
    if (breathalyzerTimer) cancelAnimationFrame(breathalyzerTimer);
    
    const screen = document.getElementById('breath-screen');
    const status = document.getElementById('breath-status');
    const value = document.getElementById('breath-value');
    
    document.getElementById('breath-minigame').classList.add('hidden');
    document.getElementById('mouthpiece-click').classList.add('hidden');
    
    if (success) {
        status.innerText = window.T('calculating_dots');
        setTimeout(() => {
            const bac = resultValue.toFixed(2);
            value.innerText = bac + '%';
            
            if (parseFloat(bac) > 0.08) {
                status.innerText = window.T('over_limit');
                screen.classList.add('screen-error');
            } else {
                status.innerText = window.T('legal_limit');
                screen.classList.add('screen-success');
            }
            
            setTimeout(() => {
                closeBreathalyzerUI();
            }, 5000);
        }, 1500);
    } else {
        status.innerText = window.T('failed');
        screen.classList.add('screen-error');
        setTimeout(() => {
            closeBreathalyzerUI();
        }, 2000);
    }
}

function closeBreathalyzerUI() {
    document.getElementById('breathalyzer-view').classList.add('hidden');
    document.getElementById('breath-screen').classList.remove('screen-error', 'screen-success');
    isBreathalyzerActive = false;
    isKeyEHeld = false;
}

// Key handling
window.addEventListener('keydown', function(event) {
    if (event.key.toLowerCase() === 'e') {
        isKeyEHeld = true;
    }
    
    if (event.key === 'Escape') {
        isBreathalyzerActive = false;
        if (breathalyzerTimer) cancelAnimationFrame(breathalyzerTimer);
        document.getElementById('breathalyzer-view').classList.add('hidden');
        fetch(`https://${GetParentResourceName()}/closeBreathalyzer`, {
            method: 'POST',
            body: JSON.stringify({})
        });
    }
});

window.addEventListener('keyup', function(event) {
    if (event.key.toLowerCase() === 'e') {
        isKeyEHeld = false;
    }
});
