import { showMessage, iconTypes } from './messageManager.mjs';

let clients = [];
let rutinas = [];
let ejercicios = [];
let clientId = null;
let rutinaId = null;
let exercideId = null;

export async function enviarFormularioRutina(event) {
    event.preventDefault();

    const form = event.target;
    if (!form.checkValidity()) {
        event.stopPropagation();
        form.classList.add('was-validated');
        return;
    }

    const formData = new FormData(form);

    try {
        const submitBtn = form.querySelector('button[type="submit"]');
        submitBtn.disabled = true;
        submitBtn.innerHTML = '<span class="spinner-border spinner-border-sm" role="status" aria-hidden="true"></span> Guardando...';

        const path = "/gestionRutinas";
        const response = await fetch(path, {
            method: 'POST',
            body: formData
        });

        if (!response.ok) {
            throw new Error('Error al procesar la solicitud');
        }

        const data = await response.json();

        if (data.success) {
            await showMessage(iconTypes.success, data.message || 'Rutina registrada correctamente');
            form.reset();
            form.classList.remove('was-validated');
        } else {
            await showMessage(iconTypes.error, data.message || 'Error al registrar la rutina');
        }
    } catch (error) {
        console.error('Error:', error);
        await showMessage(iconTypes.error, error.message || 'Error al registrar la rutina');
    } finally {
        const submitBtn = form.querySelector('button[type="submit"]');
        if (submitBtn) {
            submitBtn.disabled = false;
            submitBtn.innerHTML = 'Registrar';
        }
    }
}

export async function enviarFormularioAsignacionEjercicio(event) {
    event.preventDefault();

    const form = event.target;
    if (!form.checkValidity()) {
        event.stopPropagation();
        form.classList.add('was-validated');
        return;
    }

    const formData = new FormData(form);

    try {
        const submitBtn = form.querySelector('button[type="submit"]');
        const originalText = submitBtn.innerHTML;
        submitBtn.disabled = true;
        submitBtn.innerHTML = '<span class="spinner-border spinner-border-sm" role="status" aria-hidden="true"></span> Guardando...';

        const path = "/asignarEjercicios";
        const response = await fetch(path, {
            method: 'POST',
            body: formData
        });

        if (!response.ok) {
            throw new Error('Error al procesar la solicitud');
        }

        const data = await response.json();

        if (data.success) {
            await showMessage(iconTypes.success, data.message || 'Ejercicio asignado correctamente');
            form.reset();
            form.classList.remove('was-validated');
            // Disable dependent fields again
            const desactivables = document.querySelectorAll('.desactivable');
            for (let element of desactivables) {
                element.disabled = true;
            }
            const desctivableElementsG = document.querySelectorAll('.desactivable-g');
            for (let item of desctivableElementsG) {
                item.disabled = true;
            }
        } else {
            await showMessage(iconTypes.error, data.message || 'Error al asignar ejercicio');
        }
    } catch (error) {
        console.error('Error:', error);
        await showMessage(iconTypes.error, error.message || 'Error al asignar ejercicio');
    } finally {
        const submitBtn = form.querySelector('button[type="submit"]');
        if (submitBtn) {
            submitBtn.disabled = false;
            submitBtn.innerHTML = 'Asignar';
        }
    }
}

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
   if(comboCliente ){
       
       comboCliente.addEventListener('change', handleSelectedAction);
       comboRutina.addEventListener('change', handleSelectedAction);
       comboEjercicios.addEventListener('change', handleSelectedAction);
       
   }
    
    
    // Agregar listeners para los formularios
    
    const formularioRutina = document.getElementById("formGestionRutinas");
    if (formularioRutina) {
        // Verificar si es el formulario de rutinas o de asignación de ejercicios por el action
  
        const action = formularioRutina.getAttribute('action');
        if (action === 'gestionRutinas') {
            formularioRutina.addEventListener('submit', enviarFormularioRutina);
            
        } else if (action === 'asignarEjercicios') {
            formularioRutina.addEventListener('submit', enviarFormularioAsignacionEjercicio);
        }
    }
})