// Scroll to membership section when clicking the "Comienza Hoy" button
(function () {
    var btn = document.getElementById('botonComienzaHoy');
    if (btn) {
        btn.addEventListener('click', function (e) {
            e.preventDefault();
            var section = document.getElementById('membership');
            if (section) {
                section.scrollIntoView({ behavior: 'smooth' });
            }
        });
    }
})();
