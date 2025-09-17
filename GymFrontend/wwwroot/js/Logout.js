function logout() {
    document.getElementById("logoutForm").submit();
}

document.addEventListener("DOMContentLoaded", function(ev) {
    
    document.getElementById("logoutLink").addEventListener("click", (ev) => {
        ev.preventDefault(); 
        logout(); // Llamar a la función de cierre de sesión
    });
})