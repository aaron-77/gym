(function () {
    'use strict';

    var animated = new Map();

    var observer = new IntersectionObserver(function (entries) {
        entries.forEach(function (entry) {
            var el = entry.target;
            var animateIn = el.getAttribute('data-animate-in') || '';
            var animateOut = el.getAttribute('data-animate-out') || '';

            if (entry.isIntersecting && !animated.get(el)) {
                // ENTRADA: sacar hidden y salida, poner entrada
                el.classList.remove('anim-hidden', 'animate__' + animateOut);
                el.classList.add('animate__' + animateIn);
                animated.set(el, true);

            } else if (!entry.isIntersecting && animated.get(el) && animateOut) {
                // SALIDA: sacar entrada, poner salida, AL FINAL hidden
                el.classList.remove('animate__' + animateIn);
                el.classList.add('animate__' + animateOut);
                el.classList.add('anim-hidden');
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
