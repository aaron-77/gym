let clients = [];
let rutinas = [];
let ejercicios = [];
let clientId = null;
let rutinaId = null;
let exercideId = null;
const handleSelectedAction = async (ev) => {
    const comboSelected = ev.currentTarget;
    enableElements(comboSelected.id);
    if (comboSelected.id == "inputCliente") {
        clientId = comboSelected.value;
        await getRutinas(clientId);
        fillCitasAgendadas();
        console.log(rutinas);
    }
    if (comboSelected.id == "inputRutina") {
        rutinaId = parseInt(comboSelected.value);
        await getEjercicios();
        fillComboEjercicios();
    }
}
const enableElements = (activaedCombo) => {
    switch(activaedCombo){
        case "inputCliente":
            document.querySelectorAll(".desactivable")[0].disabled = false;
        break;
        case "inputRutina":
            document.querySelectorAll(".desactivable")[1].disabled = false;
        break;
        case "inputEjercicio":
        const desactivablesG = document.querySelectorAll(".desactivable-g");
        for (let desactivable of desactivablesG) {
            desactivable.disabled = false;
        }
        break;
    }
}
const disableElements = () => {
    const descactivableElements = document.querySelectorAll(".desactivable");
    for (let element of descactivableElements) {
        element.disabled = true;
    }
    const desctivableElementsG = document.querySelectorAll(".desactivable-g");
    for (let item of desctivableElementsG) {
        item.disabled = true;
    }
}
const getClientes = async() => {
    // Usar ruta relativa ya que es un endpoint del frontend
    const response = await fetch("/obtenerUsuariosPorRol");
    const jsonResponse = await response.json();
    if (!jsonResponse.ok) {
        console.log(jsonResponse.message);
        return;
    }
    clients = jsonResponse.data;
}
const getRutinas = async (clientId) => {
    if (clientId != null) {
        const response = await fetch("/obtenerRutinasDeCliente?UsuarioID=" + clientId); // MODIFICADO: Usar endpoint del frontend
        const jsonResponse = await response.json();
        if (!jsonResponse.success) {
            console.log(jsonResponse.message)
            return;
        }
        rutinas = jsonResponse.payload;
    }
}
const getEjercicios = async() => {
    if (rutinaId != null && rutinaId > 0) {
        const response = await fetch("/Ejercicios/obtenerEjercicios"); // MODIFICADO: Usar endpoint del frontend
        const jsonResponse = await response.json();
        if (!jsonResponse.success) {
            console.log(jsonResponse.message)
            return;
        }
        ejercicios = jsonResponse.payload;
    }
}
function fillComboClients() {
    var select = document.getElementById('inputCliente');
    select.innerHTML = "";
    let defalutoption = document.createElement('option');
    defalutoption.value = null;
    defalutoption.text = "Selecciona un cliente";
    select.appendChild(defalutoption);
    clients.forEach(function (client) {
        let option = document.createElement('option');
        option.value = client.usuarioID;
        option.text = client.nombre + " " + client.apellido;
        select.appendChild(option);
    });
}
function fillCitasAgendadas() {
    let select = document.getElementById('inputRutina');
    select.innerHTML = "";
    let defalutoption = document.createElement('option');
    defalutoption.value = null;
    defalutoption.text = "Selecciona una rutina";
    select.appendChild(defalutoption);
    rutinas.forEach((rutina) => {
        let option = document.createElement('option');
        option.value = rutina.rutinaId;
        option.text = rutina.rutinaId + " " + rutina.observaciones;
        select.appendChild(option);
    });
}

function fillComboEjercicios() {
    var select = document.getElementById('inputEjercicio');
    select.innerHTML = "";
    let defalutoption = document.createElement('option');
    defalutoption.value = null;
    defalutoption.text = "Selecciona un ejercicio";
    select.appendChild(defalutoption);  
    ejercicios.forEach((ejericio) => {
        let option = document.createElement('option');
        option.value = ejericio.ejercicioID;
        option.text = ejericio.nombreEjercicio;
        select.appendChild(option);
    });
}
addEventListener("DOMContentLoaded", async () => {
    disableElements();
    const comboCliente = document.getElementById("inputCliente");
    const comboRutina = document.getElementById("inputRutina");
    const comboEjercicios = document.getElementById("inputEjercicio");
    comboCliente.addEventListener('change', handleSelectedAction);
    comboRutina.addEventListener('change', handleSelectedAction);
    comboEjercicios.addEventListener('change', handleSelectedAction);
    
})