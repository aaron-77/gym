/**
 * Botones de credenciales de prueba del login.
 * Rellena el formulario con la credencial elegida y dispara el inicio de sesión.
 * Si no hay botones en la página (entorno Development o config vacía), no hace nada.
 */
(function () {
    'use strict';

    function iniciarSesionCon(button) {
        var campoCorreo = document.getElementById('username');
        var campoPassword = document.getElementById('password');
        var form = document.getElementById('loginform') && document.getElementById('loginform').querySelector('form');

        if (!campoCorreo || !campoPassword || !form) {
            return;
        }

        campoCorreo.value = button.dataset.email || '';
        campoPassword.value = button.dataset.password || '';

        if (typeof form.requestSubmit === 'function') {
            form.requestSubmit();
        } else {
            form.submit();
        }
    }

    function registrarBotones() {
        var botones = document.querySelectorAll('[data-demo-credentials]');
        botones.forEach(function (button) {
            button.addEventListener('click', function () {
                iniciarSesionCon(button);
            });
        });
    }

    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', registrarBotones);
    } else {
        registrarBotones();
    }
})();
