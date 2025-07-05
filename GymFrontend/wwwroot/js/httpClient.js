// Cliente HTTP reutilizable para peticiones GET y POST
/**
 * Realiza una petición HTTP al API
 * @param {string} endpointPath - Ruta del endpoint después de "/api" (ej: "Horarios/obtenerPreReservas")
 * @param {Object} [body] - Objeto a enviar como body en una petición POST. Si no se proporciona, se hace GET.
 * @param {Object} [params] - Objeto con parámetros de query para GET.
 * @returns {Promise} Promise con la respuesta del API
 */
async function realizarPeticionAPI(endpointPath, body, params) {
    try {
        const baseUrl = 'http://localhost:5274';
        let url = `${baseUrl}/api/${endpointPath}`;
        let options = {
            method: 'GET',
            headers: {
                'Content-Type': 'application/json'
            }
        };
        // Si hay params y es GET, agregar a la URL
        if ((!body || Object.keys(body).length === 0) && params && Object.keys(params).length > 0) {
            const queryString = new URLSearchParams(params).toString();
            url += `?${queryString}`;
        }
        if (body && Object.keys(body).length > 0) {
            options.method = 'POST';
            options.body = JSON.stringify(body);
        }
        const response = await fetch(url, options);
        const data = await response.json();
        
        // Verificar si la respuesta HTTP fue exitosa
        if (!response.ok) {
            throw new Error(`Error HTTP: ${response.status}`);
        }
        
        // Si la respuesta tiene la estructura DTOResponse (con payload)
        if (data && data.payload !== undefined) {
            // Verificar si la respuesta indica éxito
            if (!data.success) {
                console.error('Error en la respuesta del API:', data.message, data.errors);
                throw new Error(data.message || 'Error en la respuesta del servidor');
            }
        }
        
        // Retornar la respuesta completa
        return data;
    } catch (error) {
        console.error('Error al realizar petición al API:', error);
        throw error; // Re-lanzar el error para que el código que llama pueda manejarlo
    }
}

// Exportar la función para uso en otros módulos
export { realizarPeticionAPI }; 