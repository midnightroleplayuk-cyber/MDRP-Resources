(function() {
    const dispatchContainer = document.getElementById('dispatch-container');
    const callsList = document.getElementById('dispatch-calls-list');
    const dragHandle = document.getElementById('dispatch-drag-handle');
    const counterDisplay = document.getElementById('dispatch-counter');
    
    if (!dispatchContainer || !callsList || !dragHandle) {
        console.error("DISPATCH: Essential elements missing from DOM. Check index.html");
        return;
    }

    let isDragging = false;
    let currentCallIndex = 0;
    let currentX;
    let currentY;
    let initialX;
    let initialY;
    let xOffset = 0;
    let yOffset = 0;

    // Dragging Logic
    dragHandle.addEventListener('mousedown', dragStart);
    document.addEventListener('mousemove', drag);
    document.addEventListener('mouseup', dragEnd);

    function dragStart(e) {
        initialX = e.clientX - xOffset;
        initialY = e.clientY - yOffset;
        if (e.target === dragHandle || dragHandle.contains(e.target)) {
            isDragging = true;
        }
    }

    function drag(e) {
        if (isDragging) {
            e.preventDefault();
            currentX = e.clientX - initialX;
            currentY = e.clientY - initialY;
            xOffset = currentX;
            yOffset = currentY;
            setTranslate(currentX, currentY, dispatchContainer);
        }
    }

    function setTranslate(xPos, yPos, el) {
        el.style.transform = `translate3d(${xPos}px, ${yPos}px, 0)`;
    }

    function dragEnd() {
        initialX = currentX;
        initialY = currentY;
        isDragging = false;
    }

    // Keyboard Navigation
    document.addEventListener('keydown', function(e) {
        if (dispatchContainer.classList.contains('hidden')) return;
        
        const totalCalls = callsList.querySelectorAll('.dispatch-call').length;
        if (totalCalls <= 1) return;

        if (e.key === 'ArrowLeft') {
            currentCallIndex = Math.max(0, currentCallIndex - 1);
            updateDispatchScroll();
        } else if (e.key === 'ArrowRight') {
            currentCallIndex = Math.min(totalCalls - 1, currentCallIndex + 1);
            updateDispatchScroll();
        }
    });

    function updateDispatchScroll() {
        const totalCalls = callsList.querySelectorAll('.dispatch-call').length;
        if (totalCalls === 0) {
            currentCallIndex = 0;
            if (counterDisplay) counterDisplay.innerText = '0/0';
            callsList.style.transform = 'translateX(0)';
            
            // Reset header to default (red/alert)
            dragHandle.classList.remove('radio-mode', 'priority-mode');
            return;
        }

        // Clamp index
        if (currentCallIndex >= totalCalls) currentCallIndex = totalCalls - 1;
        if (currentCallIndex < 0) currentCallIndex = 0;

        // Simplified transform: Each item is 100% of the container
        callsList.style.width = '100%'; 
        callsList.style.transform = `translateX(-${currentCallIndex * 100}%)`;
        
        if (counterDisplay) {
            counterDisplay.innerText = `${currentCallIndex + 1}/${totalCalls}`;
        }

        // Update Header Color based on current call
        const calls = callsList.querySelectorAll('.dispatch-call');
        const currentCall = calls[currentCallIndex];
        if (currentCall) {
            const isRadio = currentCall.getAttribute('data-radio') === 'true';
            const code = currentCall.getAttribute('data-code');
            const isPriority = code === 'CODE-99' || code === '10-71';

            dragHandle.classList.remove('radio-mode', 'priority-mode');
            if (isPriority) {
                dragHandle.classList.add('priority-mode');
            } else if (isRadio) {
                dragHandle.classList.add('radio-mode');
            }
        }
    }
    window.updateDispatchScroll = updateDispatchScroll;

    // Dispatch Functions
    window.toggleDispatch = function(show) {
        if (show) {
            dispatchContainer.classList.remove('hidden');
        } else {
            dispatchContainer.classList.add('hidden');
            fetch(`https://${GetParentResourceName()}/closeDispatch`, {
                method: 'POST',
                body: JSON.stringify({})
            });
        }
    };

    window.lockDispatch = function() {
        fetch(`https://${GetParentResourceName()}/lockDispatch`, {
            method: 'POST',
            body: JSON.stringify({})
        });
    };

    window.addDispatchCall = function(call) {
        const emptyMsg = callsList.querySelector('.dispatch-empty');
        if (emptyMsg) emptyMsg.remove();

        const callEl = document.createElement('div');
        callEl.className = 'dispatch-call';
        callEl.setAttribute('data-code', call.code);
        callEl.setAttribute('data-x', call.coords.x);
        callEl.setAttribute('data-y', call.coords.y);
        callEl.setAttribute('data-radio', call.isRadio ? 'true' : 'false');
        
        callEl.innerHTML = `
            <div class="call-main-row">
                <div class="call-left-side">
                    <span class="call-tag">${call.code}</span>
                    <span class="call-main-title">${call.title}</span>
                </div>
                <div class="call-right-side">
                    <div class="call-info-row">
                        <span>${call.time || window.T('now')}</span>
                        <i class="fas fa-clock"></i>
                    </div>
                    <div class="call-info-row">
                        <span>${call.location}</span>
                        <i class="fas fa-location-dot"></i>
                    </div>
                </div>
            </div>
            ${call.info ? `<div class="call-details-box">${call.info}</div>` : ''}
            <div class="call-actions-row">
                <button class="action-btn primary" onclick="window.setDispatchGPS(${call.coords.x}, ${call.coords.y})">
                    <i class="fas fa-crosshairs"></i> ${window.T('gps')}
                </button>
                <button class="action-btn" onclick="this.closest('.dispatch-call').remove(); window.updateDispatchScroll(); window.checkDispatchEmpty()">
                    <i class="fas fa-check"></i> ${window.T('dismiss')}
                </button>
            </div>`;

        callsList.prepend(callEl);
        applyTranslations(callEl);
        
        currentCallIndex = 0; // Jump to new call
        updateDispatchScroll();
        
        // Play notification sound
        const audio = new Audio('https://www.myinstants.com/media/sounds/gta-v-dispatch-sound.mp3');
        audio.volume = 0.2;
        audio.play().catch(() => {});
    };

    window.setDispatchGPS = function(x, y) {
        fetch(`https://${GetParentResourceName()}/setDispatchGPS`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ x, y })
        });
    };

    window.checkDispatchEmpty = function() {
        if (callsList.children.length === 0) {
            currentCallIndex = 0;
            if (counterDisplay) counterDisplay.innerText = '0/0';
            callsList.innerHTML = `
                <div class="dispatch-empty">
                    <i class="fas fa-satellite-dish"></i>
                    <p>${window.T('station_clear')}</p>
                </div>
            `;
            applyTranslations(callsList);
        }
    };

    // Message Listener
    window.addEventListener('message', function(event) {
        const item = event.data;
        if (item.action === 'toggleDispatch') {
            console.log("DISPATCH: Toggling UI", item.show);
            window.toggleDispatch(item.show);
        } else if (item.action === 'addDispatchCall') {
            window.addDispatchCall(item.call);
        } else if (item.action === 'scrollDispatch') {
            const totalCalls = callsList.querySelectorAll('.dispatch-call').length;
            if (totalCalls <= 1) return;

            if (item.direction === 'prev') {
                currentCallIndex = Math.max(0, currentCallIndex - 1);
            } else if (item.direction === 'next') {
                currentCallIndex = Math.min(totalCalls - 1, currentCallIndex + 1);
            }
            updateDispatchScroll();
        } else if (item.action === 'setGPSActive') {
            const calls = callsList.querySelectorAll('.dispatch-call');
            const activeCall = calls[currentCallIndex];
            if (activeCall) {
                const x = parseFloat(activeCall.getAttribute('data-x'));
                const y = parseFloat(activeCall.getAttribute('data-y'));
                if (!isNaN(x) && !isNaN(y)) {
                    window.setDispatchGPS(x, y);
                }
            }
        }
    });

})();

