// Función para calcular la duración total
function calcularDuracionTotal() {
    const duracionMinutos = parseInt(document.getElementById('duracionMinutos').value) || 0;
    const tiempoDescanso = parseInt(document.getElementById('tiempoDescanso').value) || 0;
    
    const duracionTotal = duracionMinutos + tiempoDescanso;
    document.getElementById('duracionTotal').value = duracionTotal;
}

// Función para enviar el formulario de forma asíncrona
async function enviarFormularioClase(event) {
    event.preventDefault();
    
    // Validación del formulario
    const form = event.target;
    if (!form.checkValidity()) {
        event.stopPropagation();
        form.classList.add('was-validated');
        return;
    }
    
    // Actualizar duración total antes de enviar
    calcularDuracionTotal();
    
    // Crear objeto FormData automáticamente con todos los campos del formulario
    const formData = new FormData(form);
    
    try {
        // Mostrar spinner o indicador de carga
        const submitBtn = form.querySelector('button[type="submit"]');
        const originalText = submitBtn.innerHTML;
        submitBtn.disabled = true;
        submitBtn.innerHTML = '<span class="spinner-border spinner-border-sm" role="status" aria-hidden="true"></span> Guardando...';
        
        // Obtener la URL base del frontend desde la configuración
        const path = "/Clases/registrarClase";
        // Enviar datos al servidor
        const response = await fetch(path, {
            method: 'POST',
            body: formData
        });
        
        if (!response.ok) {
            throw new Error('Error al registrar la clase');
        }
        
        const data = await response.json();
        
        // Mostrar mensaje de éxito
        alert('Clase registrada correctamente');
        
        // Resetear formulario
        form.reset();
        form.classList.remove('was-validated');
        
    } catch (error) {
        console.error('Error:', error);
        alert('Error al registrar la clase: ' + error.message);
    } finally {
        // Restaurar botón de envío
        const submitBtn = form.querySelector('button[type="submit"]');
        submitBtn.disabled = false;
        submitBtn.innerHTML = 'Guardar';
    }
}

// Inicialización cuando el DOM está cargado
document.addEventListener('DOMContentLoaded', function() {
    // Agregar listeners para calcular la duración total cuando cambien los valores
    document.getElementById('duracionMinutos').addEventListener('change', calcularDuracionTotal);
    document.getElementById('tiempoDescanso').addEventListener('change', calcularDuracionTotal);
    
    // Asociar el evento submit del formulario con nuestra función de envío
    const formulario = document.getElementById('formRegistroClase');
    if (formulario) {
        formulario.addEventListener('submit', enviarFormularioClase);
    }
    
    // Inicializar la validación de Bootstrap
    const forms = document.querySelectorAll('.needs-validation');
    Array.from(forms).forEach(form => {
        form.addEventListener('submit', event => {
            if (!form.checkValidity()) {
                event.preventDefault();
                event.stopPropagation();
            }
            form.classList.add('was-validated');
        }, false);
    });
}); 