let isSwiping = false;
let swipeStartX = 0;
let swipeSuccess = false;

window.addEventListener('message', function(event) {
    if (event.data.action === 'startSwipeMinigame') {
        startSwipeMinigame();
    }
});

function startSwipeMinigame() {
    const container = document.getElementById('swipe-card-container');
    const cardBox = document.getElementById('swipe-card-box');
    const status = document.getElementById('swipe-status');
    
    if (!container || !cardBox || !status) return;

    swipeSuccess = false;
    isSwiping = false;
    
    status.innerText = window.T('waiting');
    status.className = 'swipe-status';
    cardBox.style.left = '20px';
    cardBox.style.transition = 'none';
    
    container.classList.remove('hidden');
}

window.closeSwipeMinigame = function() {
    const container = document.getElementById('swipe-card-container');
    if (container) {
        container.classList.add('hidden');
        fetch(`https://${GetParentResourceName()}/close`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({})
        });
    }
};

document.addEventListener('mousedown', function(e) {
    const cardBox = document.getElementById('swipe-card-box');
    if (!cardBox || swipeSuccess) return;
    
    if (e.target.closest('#swipe-card-box')) {
        e.preventDefault();
        isSwiping = true;
        const scale = window.resolutionScale || 1.0;
        swipeStartX = (e.clientX / scale) - cardBox.offsetLeft;
        cardBox.style.transition = 'none';
    }
});

document.addEventListener('mousemove', function(e) {
    if (!isSwiping || swipeSuccess) return;
    
    const cardBox = document.getElementById('swipe-card-box');
    if (!cardBox) return;

    const scale = window.resolutionScale || 1.0;
    let x = (e.clientX / scale) - swipeStartX;
    
    // Contain within wrapper boundaries (start at 20px, swipe to ~1000px)
    if (x < 20) x = 20;
    if (x > 1000) x = 1000;
    
    cardBox.style.left = x + 'px';
    
    // Check for success (swiped to the end of the large reader)
    if (x > 950) {
        finishSwipe(true);
    }
});

document.addEventListener('mouseup', function() {
    if (!isSwiping || swipeSuccess) return;
    isSwiping = false;
    
    const cardBox = document.getElementById('swipe-card-box');
    if (!cardBox) return;

    let x = parseInt(cardBox.style.left);
    if (x < 950) {
        finishSwipe(false);
    }
});

function finishSwipe(success) {
    isSwiping = false;
    const cardBox = document.getElementById('swipe-card-box');
    const status = document.getElementById('swipe-status');
    const container = document.getElementById('swipe-card-container');

    if (success) {
        swipeSuccess = true;
        status.innerText = window.T('accepted');
        status.className = 'swipe-status success';
        cardBox.style.left = '1000px';
        cardBox.style.transition = 'left 0.2s';
        
        setTimeout(() => {
            container.classList.add('hidden');
            fetch(`https://${GetParentResourceName()}/swipeSuccess`, {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({})
            });
        }, 1000);
    } else {
        status.innerText = window.T('invalid_swipe');
        status.className = 'swipe-status error';
        cardBox.style.transition = 'left 0.3s';
        cardBox.style.left = '20px';
        
        setTimeout(() => {
            if (!swipeSuccess) {
                status.innerText = window.T('waiting');
                status.className = 'swipe-status';
            }
        }, 1000);
    }
}

// Close on Escape
document.addEventListener('keydown', function(e) {
    if (e.key === 'Escape') {
        const container = document.getElementById('swipe-card-container');
        if (container && !container.classList.contains('hidden')) {
            container.classList.add('hidden');
            fetch(`https://${GetParentResourceName()}/close`, {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({})
            });
        }
    }
});

