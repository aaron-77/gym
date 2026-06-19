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

// Active state en nav-links al hacer scroll — ilumina la sección visible
(function () {
    var navLinks = document.querySelectorAll('.nav-link');

    // Solo links con fragmento/hash (anclas a secciones tipo "/Home#home"), excluir links a otras páginas
    var sectionLinks = Array.from(navLinks).filter(function (link) {
        var href = link.getAttribute('href');
        return href && href.includes('#');
    });

    // Extraer los IDs de las secciones desde el fragmento de la URL
    var sections = sectionLinks.map(function (link) {
        var href = link.getAttribute('href');
        var hash = href.split('#')[1];
        return hash ? document.getElementById(hash) : null;
    }).filter(Boolean);

    function updateActiveLink() {
        var scrollY = window.scrollY;
        var activeId = null;

        // Recorrer secciones de arriba a abajo y quedarse con la última que esté visible
        sections.forEach(function (section) {
            if (!section) return;
            var offsetTop = section.offsetTop;
            var offsetBottom = offsetTop + section.offsetHeight;

            // Si el scroll pasó el inicio de la sección
            if (scrollY >= offsetTop - 300) {
                activeId = section.getAttribute('id');
            }
        });

        // Aplicar/remover active class
        sectionLinks.forEach(function (link) {
            var href = link.getAttribute('href');
            var linkHash = href.split('#')[1] || '';
            if (linkHash === activeId) {
                link.classList.add('active');
            } else {
                link.classList.remove('active');
            }
        });
    }

    window.addEventListener('scroll', updateActiveLink, { passive: true });
    window.addEventListener('load', updateActiveLink);
})();

// Active state en nav-links según la página actual — ilumina el link de la página activa
(function () {
    var navLinks = document.querySelectorAll('.nav-link');

    // Links SIN fragmento/hash (navegación entre páginas, ej: /signIn, /signUp)
    var pageLinks = Array.from(navLinks).filter(function (link) {
        var href = link.getAttribute('href');
        return href && !href.includes('#');
    });

    function normalizePath(path) {
        // Saca trailing slash pero mantiene '/' para la raíz
        return path.replace(/\/+$/, '') || '/';
    }

    function updateActivePageLink() {
        var currentPath = normalizePath(window.location.pathname);

        pageLinks.forEach(function (link) {
            var linkPath = normalizePath(new URL(link.href, window.location.origin).pathname);

            if (linkPath === currentPath) {
                link.classList.add('active');
            } else {
                link.classList.remove('active');
            }
        });
    }

    // Correr al cargar la página
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', updateActivePageLink);
    } else {
        updateActivePageLink();
    }
})();
