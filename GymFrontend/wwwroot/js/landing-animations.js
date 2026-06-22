(function () {
    'use strict';

    var lastScrollY = window.scrollY;
    var scrollDirection = 'down';

    window.addEventListener('scroll', function () {
        var currentScrollY = window.scrollY;
        scrollDirection = currentScrollY >= lastScrollY ? 'down' : 'up';
        lastScrollY = currentScrollY;
    }, { passive: true });

    /**
     * State machine por elemento:
     *   'idle'    → puede hacer entrance
     *   'entered' → puede hacer exit (no puede re-entrar)
     *   'exited'  → puede hacer entrance de nuevo (no puede re-exit)
     */
    var stateMap = new Map();

    var observer = new IntersectionObserver(function (entries) {
        entries.forEach(function (entry) {
            var el = entry.target;
            var state = stateMap.get(el) || { phase: 'idle' };
            var animateIn = el.getAttribute('data-animate-in') || '';
            var animateOut = el.getAttribute('data-animate-out') || '';

            var isEntering = entry.isIntersecting && scrollDirection === 'down' && state.phase !== 'entered';
            var isExiting = !entry.isIntersecting && scrollDirection === 'up' && state.phase === 'entered';

            if (isEntering && animateIn) {
                // Swap to entrance animation
                el.classList.remove('animate__' + animateIn, 'animate__' + animateOut);
                void el.offsetWidth;
                el.classList.add('animate__animated', 'animate__' + animateIn);
                state.phase = 'entered';
            } else if (isExiting && animateOut) {
                // Swap to exit animation
                el.classList.remove('animate__' + animateIn, 'animate__' + animateOut);
                void el.offsetWidth;
                el.classList.add('animate__animated', 'animate__' + animateOut);
                state.phase = 'exited';
            }

            stateMap.set(el, state);
        });
    }, {
        threshold: 0.15,
        rootMargin: '0px 0px -30px 0px'
    });

    function init() {
        var elements = document.querySelectorAll('[data-animate-in]');
        for (var i = 0; i < elements.length; i++) {
            var el = elements[i];
            el.classList.add('animate__animated');
            observer.observe(el);
        }
    }

    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', init);
    } else {
        init();
    }
})();
