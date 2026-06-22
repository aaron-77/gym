(function () {
    'use strict';

    /* Mapa: valor de data-animate-in → clase hidden direccional */
    var HIDDEN_MAP = {
        fadeIn: 'hidden',
        fadeInLeft: 'hidden-left',
        fadeInRight: 'hidden-right',
        fadeInUp: 'hidden-up',
        flipInY: 'hidden-flip'
    };

    function getHiddenClass(animateIn) {
        return HIDDEN_MAP[animateIn] || 'hidden';
    }

    /**
     * State machine por elemento:
     *   'idle'    → esperando primer entrance
     *   'entered' → visible, puede hacer exit
     *   'exited'  → oculto, puede re-entrar
     */
    var stateMap = new Map();

    var observer = new IntersectionObserver(function (entries) {
        entries.forEach(function (entry) {
            var el = entry.target;
            var state = stateMap.get(el) || { phase: 'idle' };
            var animateIn = el.getAttribute('data-animate-in') || '';
            var animateOut = el.getAttribute('data-animate-out') || '';
            var hiddenClass = getHiddenClass(animateIn);

            if (entry.isIntersecting && state.phase !== 'entered') {
                // --- ENTRANCE: idle → entered  o  exited → entered ---
                el.classList.remove(hiddenClass, 'animate__' + animateOut);
                void el.offsetWidth; // fuerza reflow para reiniciar animación
                el.classList.add('animate__animated', 'animate__' + animateIn);
                state.phase = 'entered';

            } else if (!entry.isIntersecting && state.phase === 'entered') {
                // --- EXIT: entered → exited ---
                el.classList.remove('animate__' + animateIn);
                el.classList.add(hiddenClass);
                void el.offsetWidth; // fuerza reflow para reiniciar animación
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
            var animateIn = el.getAttribute('data-animate-in') || '';
            var hiddenClass = getHiddenClass(animateIn);
            el.classList.add(hiddenClass);
            observer.observe(el);
        }
    }

    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', init);
    } else {
        init();
    }
})();
