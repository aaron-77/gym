// Actualizar el año actual en el footer
(function () {
    var yearEl = document.getElementById('currentYear');
    if (yearEl) {
        yearEl.textContent = new Date().getFullYear();
    }
})();

// Menú móvil toggle
(function () {
    var menuBtn = document.getElementById('mobileMenuBtn');
    var navLinks = document.getElementById('navLinks');
    if (menuBtn && navLinks) {
        menuBtn.addEventListener('click', function () {
            menuBtn.classList.toggle('active');
            navLinks.classList.toggle('active');
        });
    }
})();
