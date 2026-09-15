const RESOURCE_NAME = 'devhub_trainheist';

let currentScreen = null;
let selectedRoute = null;
let generatedCode = null;
let routes = [];
let codeEntryActive = false;
let enteredCode = '';
let keyCaptureActive = false;

window.addEventListener('message', function(event) {
    let data = event.data;
    
    if (typeof data === 'string') {
        try {
            data = JSON.parse(data);
        } catch (e) {
            return;
        }
    }

    if (data.action === 'openHackScreen') {
        routes = data.routes || [];
        showScreen('hackScreen');
        resetHackScreen();
    }

    if (data.action === 'openCodeScreen') {
        showScreen('codeScreen');
        resetCodeScreen();
    }

    if (data.action === 'showCodeEntry') {
        showCodeEntryScreen();
    }

    if (data.action === 'hideCodeEntry') {
        hideCodeEntryScreen();
    }

    if (data.action === 'updateCode') {
        updateCodeDigits(data.code || '');
    }

    if (data.action === 'codeResult') {
        showCodeEntryResult(data.success);
    }

    if (data.action === 'resetCode') {
        updateCodeDigits('');
        document.getElementById('codeResultDisplay').classList.remove('active');
    }

    if (data.action === 'showCodeProgress') {
        showCodeProgressBar(data.duration || 5000);
    }

    if (data.action === 'showSystemError') {
        showSystemErrorScreen();
    }

    if (data.action === 'startKeyCapture') {
        keyCaptureActive = true;
    }

    if (data.action === 'stopKeyCapture') {
        keyCaptureActive = false;
    }

    if (data.action === 'close') {
        hideAllScreens();
        hideCodeEntryScreen();
        resetHackScreen();
        resetCodeScreen();
    }
    
    if (data.action === 'keyPress') {
        const codeInput = document.getElementById('codeInput');
        if (currentScreen === 'codeScreen' && codeInput) {
            if (data.key === 'backspace') {
                codeInput.value = codeInput.value.slice(0, -1);
            } else if (codeInput.value.length < 6) {
                codeInput.value += data.key;
            }
        }
    }
});

function showCodeEntryScreen() {
    hideAllScreens();
    codeEntryActive = true;
    enteredCode = '';
    updateCodeDigits('');
    document.getElementById('codeEntryScreen').classList.add('active');
    document.getElementById('codeResultDisplay').classList.remove('active');
    document.getElementById('codeEntryProgress').classList.remove('active');
    document.getElementById('codeEntryProgressFill').style.width = '0%';
    document.getElementById('codeEntryError').style.display = 'none';
    document.querySelector('.code-digit-row').style.display = '';
    document.querySelector('.code-entry-hint').style.display = '';
    document.querySelector('.code-entry-title').style.display = '';
}

function hideCodeEntryScreen() {
    codeEntryActive = false;
    document.getElementById('codeEntryScreen').classList.remove('active');
}

function updateCodeDigits(code) {
    enteredCode = code;
    for (let i = 0; i < 6; i++) {
        const digit = document.getElementById('codeDigit' + i);
        if (digit) {
            digit.textContent = code[i] || '';
        }
    }
}

function showCodeEntryResult(success) {
    const resultEl = document.getElementById('codeResultDisplay');
    resultEl.classList.add('active');
    if (success) {
        resultEl.textContent = 'Access Granted';
        resultEl.className = 'code-entry-result active success';
    } else {
        resultEl.textContent = 'Access Denied';
        resultEl.className = 'code-entry-result active error';
    }
}

function showCodeProgressBar(duration) {
    document.querySelector('.code-digit-row').style.display = 'none';
    document.querySelector('.code-entry-hint').style.display = 'none';
    document.getElementById('codeResultDisplay').classList.remove('active');
    
    const progressContainer = document.getElementById('codeEntryProgress');
    progressContainer.classList.add('active');
    
    let progress = 0;
    const step = 100 / (duration / 100);
    const interval = setInterval(function() {
        progress += step;
        if (progress > 100) progress = 100;
        document.getElementById('codeEntryProgressFill').style.width = progress + '%';
        document.getElementById('codeEntryProgressText').textContent = 'Downloading route data... ' + Math.floor(progress) + '%';
        if (progress >= 100) {
            clearInterval(interval);
        }
    }, 100);
}

function showSystemErrorScreen() {
    document.querySelector('.code-digit-row').style.display = 'none';
    document.querySelector('.code-entry-hint').style.display = 'none';
    document.getElementById('codeResultDisplay').classList.remove('active');
    document.getElementById('codeEntryProgress').classList.remove('active');
    document.querySelector('.code-entry-title').style.display = 'none';
    
    document.getElementById('codeEntryError').style.display = 'block';
}

document.addEventListener('keydown', function(e) {
    if (keyCaptureActive) {
        if (e.key >= '0' && e.key <= '9') {
            fetch(`https://${RESOURCE_NAME}/keyInput`, {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ key: e.key })
            });
            e.preventDefault();
        } else if (e.key === 'Backspace') {
            fetch(`https://${RESOURCE_NAME}/keyInput`, {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ key: 'backspace' })
            });
            e.preventDefault();
        } else if (e.key === 'Escape') {
            fetch(`https://${RESOURCE_NAME}/keyInput`, {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ key: 'escape' })
            });
            e.preventDefault();
        }
    }
});

function showScreen(screenId) {
    hideAllScreens();
    document.getElementById(screenId).classList.add('active');
    currentScreen = screenId;
    
    if (screenId === 'codeScreen') {
        setTimeout(function() {
            document.getElementById('codeInput').focus();
        }, 100);
    }
}

function hideAllScreens() {
    document.querySelectorAll('.container').forEach(el => el.classList.remove('active'));
    currentScreen = null;
}

function resetHackScreen() {
    document.getElementById('hackBtn').disabled = false;
    document.getElementById('hackBtn').style.display = 'block';
    document.getElementById('hackLoading').classList.remove('active');
    document.getElementById('routesGrid').classList.remove('active');
    document.getElementById('hackProgress').classList.remove('active');
    document.getElementById('codeDisplay').classList.remove('active');
    document.getElementById('progressFill').style.width = '0%';
    selectedRoute = null;
}

function resetCodeScreen() {
    document.getElementById('codeInput').value = '';
    document.getElementById('submitCode').disabled = false;
    document.getElementById('codeProgress').classList.remove('active');
    document.getElementById('resultDisplay').classList.remove('active');
    document.getElementById('codeProgressFill').style.width = '0%';
}

document.getElementById('hackBtn').addEventListener('click', function() {
    this.disabled = true;
    document.getElementById('hackLoading').classList.add('active');

    setTimeout(function() {
        document.getElementById('hackLoading').classList.remove('active');
        document.getElementById('hackBtn').style.display = 'none';
        showRoutes();
    }, 2000);
});

function showRoutes() {
    const grid = document.getElementById('routesGrid');
    grid.innerHTML = '';

    const shuffled = routes.sort(() => 0.5 - Math.random());
    const selectedRoutes = shuffled.slice(0, 3);

    selectedRoutes.forEach((route, index) => {
        const box = document.createElement('div');
        box.className = 'route-box';
        box.textContent = route;
        box.addEventListener('click', function() {
            document.querySelectorAll('.route-box').forEach(b => b.classList.remove('selected'));
            this.classList.add('selected');
            selectedRoute = route;
            startHacking();
        });
        grid.appendChild(box);
    });

    grid.classList.add('active');
}

function startHacking() {
    document.getElementById('routesGrid').classList.remove('active');
    document.getElementById('hackProgress').classList.add('active');

    let progress = 0;
    const interval = setInterval(function() {
        progress += 2;
        document.getElementById('progressFill').style.width = progress + '%';
        document.getElementById('progressText').textContent = 'Hacking... ' + progress + '%';

        if (progress >= 100) {
            clearInterval(interval);
            showCode();
        }
    }, 100);
}

function showCode() {
    document.getElementById('hackProgress').classList.remove('active');
    document.getElementById('codeDisplay').classList.add('active');

    generatedCode = Math.floor(100000 + Math.random() * 900000).toString();
    document.getElementById('generatedCode').textContent = generatedCode;

    fetch(`https://${RESOURCE_NAME}/hackComplete`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
            code: generatedCode,
            route: selectedRoute
        })
    });
}

document.getElementById('submitCode').addEventListener('click', function() {
    const inputCode = document.getElementById('codeInput').value;
    if (inputCode.length !== 6) return;

    this.disabled = true;
    document.getElementById('codeProgress').classList.add('active');

    let progress = 0;
    const interval = setInterval(function() {
        progress += 4;
        document.getElementById('codeProgressFill').style.width = progress + '%';
        document.getElementById('codeProgressText').textContent = 'Verifying... ' + progress + '%';

        if (progress >= 100) {
            clearInterval(interval);
            verifyCode(inputCode);
        }
    }, 200);
});

function verifyCode(inputCode) {
    document.getElementById('codeProgress').classList.remove('active');
    document.getElementById('resultDisplay').classList.add('active');

    fetch(`https://${RESOURCE_NAME}/verifyCode`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ code: inputCode })
    }).then(response => response.json()).then(data => {
        const resultContent = document.getElementById('resultContent');
        const trainInfo = document.getElementById('trainInfo');

        if (data.success) {
            resultContent.innerHTML = '<p class="result-success">ACCESS GRANTED</p>';
            trainInfo.style.display = 'block';
            document.getElementById('trainRoute').textContent = data.route || 'Unknown';
            document.getElementById('trainCargo').textContent = 'High Value Assets';
            document.getElementById('trainEta').textContent = '2 minutes';
        } else {
            resultContent.innerHTML = '<p class="result-error">ACCESS DENIED - Invalid Code</p>';
            trainInfo.style.display = 'none';
        }
    });
}