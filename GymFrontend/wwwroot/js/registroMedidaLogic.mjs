import { showMessage, iconTypes } from './messageManager.mjs';
import { obtenerEndpoint } from './httpClient.js';

async function enviarFormularioMedida(event) {
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

        const path = obtenerEndpoint('ENDPOINT_MEDIDAS_REGISTRAR', "/registrar");
        const response = await fetch(path, {
            method: 'POST',
            body: formData
        });

        if (!response.ok) {
            throw new Error('Error al registrar la medida');
        }

        const data = await response.json();

        if (data.success) {
            await showMessage(iconTypes.success, data.message || 'Medida registrada correctamente');
            form.reset();
            form.classList.remove('was-validated');
        } else {
            await showMessage(iconTypes.error, data.message || 'Error al registrar la medida');
        }
    } catch (error) {
        console.error('Error:', error);
        await showMessage(iconTypes.error, error.message || 'Error al registrar la medida');
    } finally {
        const submitBtn = form.querySelector('button[type="submit"]');
        submitBtn.disabled = false;
        submitBtn.innerHTML = 'Guardar';
    }
}

document.addEventListener('DOMContentLoaded', function() {
    const formulario = document.getElementById('formCitaMedicion');
    if (formulario) {
        formulario.addEventListener('submit', enviarFormularioMedida);
    }
});