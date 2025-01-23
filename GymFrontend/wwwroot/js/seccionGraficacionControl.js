
const clickDetailsHandler = (event) => {
    let parent = event.currentTarget.parentElement;
    for (let i = 0; i < 2; i++) {
        if (parent.parentElement) {
            parent = parent.parentElement;
        }
    }
    // Get data attributes
    let fkCliente = parent.getAttribute('data-fkCliente');
    let fkParametro = parent.getAttribute('data-fkParametro');
    let fkEjercicio = parent.getAttribute('data-fkEjercicio');
    navigateToPage(`detallesDeProgreso?fkCliente=${fkCliente}&fkParametro=${fkParametro}&fkEjercicio=${fkEjercicio}`);
}

document.addEventListener('click',clickDetailsHandler );

const navigateToPage = (url) => {
    window.href = url;
}