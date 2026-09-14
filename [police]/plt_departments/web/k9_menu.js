(function() {
    const k9Menu = document.getElementById('k9-menu-container');
    const k9Tabs = document.querySelectorAll('#k9-menu-container .tab');
    const k9Views = {
        commands: document.getElementById('k9-commands-view'),
        actions: document.getElementById('k9-actions-view')
    };

    window.openK9Menu = function() {
        if (k9Menu) {
            k9Menu.style.setProperty('display', 'flex', 'important');
            k9Menu.classList.add('visible');
        }
    };

    window.closeK9Menu = function() {
        if (k9Menu) {
            k9Menu.classList.remove('visible');
            k9Menu.style.setProperty('display', 'none', 'important');
            fetch(`https://${GetParentResourceName()}/closeK9Menu`, {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({})
            });
        }
    };

    window.k9Action = function(action) {
        fetch(`https://${GetParentResourceName()}/k9Action`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ action })
        });
        // We don't necessarily close the menu on every action
    };

    k9Tabs.forEach(tab => {
        tab.addEventListener('click', () => {
            const cat = tab.dataset.cat;
            
            // Update tabs
            k9Tabs.forEach(t => t.classList.remove('active'));
            tab.classList.add('active');

            // Update views
            Object.keys(k9Views).forEach(viewKey => {
                if (viewKey === cat) {
                    k9Views[viewKey].classList.remove('hidden');
                } else {
                    k9Views[viewKey].classList.add('hidden');
                }
            });
        });
    });

    window.addEventListener('message', function(event) {
        if (event.data.action === 'openK9Menu') {
            window.openK9Menu();
        } else if (event.data.action === 'closeK9Menu') {
            const container = document.getElementById('k9-menu-container');
            if (container) {
                container.classList.remove('visible');
                container.style.setProperty('display', 'none', 'important');
            }
        }
    });

    // Handle Escape key
    window.addEventListener('keydown', function(event) {
        if (event.key === 'Escape') {
            if (k9Menu && k9Menu.classList.contains('visible')) {
                window.closeK9Menu();
            }
        }
    });
})();

