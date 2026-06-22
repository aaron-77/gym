(function () {
    'use strict';

    var animated = new Map(); // element → true si ya reprodujo entrance

    var observer = new IntersectionObserver(function (entries) {
        entries.forEach(function (entry) {
            var el = entry.target;
            var ratio = entry.intersectionRatio;
            var animateIn = el.getAttribute('data-animate-in') || '';
            var animateOut = el.getAttribute('data-animate-out') || '';

            if (ratio >= 0.4 && !animated.get(el)) {
                // --- ENTRADA: visible al 40%+ y no había entrado aún ---
                el.classList.remove('animate__' + animateOut);
                el.classList.add('animate__animated', 'animate__' + animateIn);
                animated.set(el, true);

            } else if (ratio <= 0.1 && animated.get(el) && animateOut) {
                // --- SALIDA: visible al 10%- había entrado, y tiene data-animate-out ---
                el.classList.remove('animate__' + animateIn);
                el.classList.add('animate__animated', 'animate__' + animateOut);
                animated.set(el, false);
            }
        });
    }, {
        threshold: [0, 0.1, 0.4]
    });

    function init() {
        document.querySelectorAll('[data-animate-in]').forEach(function (el) {
            observer.observe(el);
        });
    }

    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', init);
    } else {
        init();
    }
})();
