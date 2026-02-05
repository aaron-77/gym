// Cliente HTTP reutilizable para peticiones GET y POST
/**
 * Realiza una petición HTTP al API
 * @param {string} endpointPath - Ruta del endpoint (ej: "/Horarios/obtenerPreReservas")
 * @param {Object} [body] - Objeto a enviar como body en una petición POST. Si no se proporciona, se hace GET.
 * @param {Object} [params] - Objeto con parámetros de query para GET.
 * @returns {Promise} Promise con la respuesta del API
 */
async function realizarPeticionAPI(endpointPath, body, params) {
    try {
        const baseUrl = getNginxBaseUrl();
        let url = `${baseUrl}${endpointPath}`;
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


/**
 * Obtiene la URL base del porxy inverso(nginx) desde la configuración
 * @returns {string} URL base del proxy inverso
 */
function getNginxBaseUrl() {
    // Verificar si window.AppConfig está disponible
    if (typeof window !== 'undefined' && window.AppConfig && window.AppConfig.EndPoints && window.AppConfig.EndPoints.nginx) {
        // Determinar si usar SSL basado en el protocolo actual
        const useSsl = window.location.protocol === 'https:';
        const apiConfig = window.AppConfig.EndPoints.nginx;

        // Usar SSL si está disponible y el protocolo es HTTPS, sino usar nossl
        if (useSsl && apiConfig.ssl) {
            return apiConfig.ssl;
        } else if (apiConfig.nossl || apiConfig.nossl == "") {
            return apiConfig.nossl;
        }
    }

    // Fallback a localhost si no hay configuración disponible
    console.warn('AppConfig no disponible, usando URL por defecto');
    return window.location.origin;
}
/**
 * Obtiene la URL base del API desde la configuración
 * @returns {string} URL base del API
 */
function getApiBaseUrl() {
    // Verificar si window.AppConfig está disponible
    if (typeof window !== 'undefined' && window.AppConfig && window.AppConfig.EndPoints && window.AppConfig.EndPoints.api) {
        // Determinar si usar SSL basado en el protocolo actual
        const useSsl = window.location.protocol === 'https:';
        const apiConfig = window.AppConfig.EndPoints.api;
        
        // Usar SSL si está disponible y el protocolo es HTTPS, sino usar nossl
        if (useSsl && apiConfig.ssl) {
            return apiConfig.ssl;
        } else if (apiConfig.nossl || apiConfig.nossl == "") {
            return apiConfig.nossl;
        }
    }
    
    // Fallback a localhost si no hay configuración disponible
    console.warn('AppConfig no disponible, usando URL por defecto');
    return window.location.origin;
}

/**
 * Obtiene la URL base del frontend desde la configuración
 * @returns {string} URL base del frontend
 */
function getFrontendBaseUrl() {
    // Verificar si window.AppConfig está disponible
    if (typeof window !== 'undefined' && window.AppConfig && window.AppConfig.EndPoints && window.AppConfig.EndPoints.frontend) {
        // Determinar si usar SSL basado en el protocolo actual
        const useSsl = window.location.protocol === 'https:';
        const frontendConfig = window.AppConfig.EndPoints.frontend;
        console.dir(frontendConfig)
        // Usar SSL si está disponible y el protocolo es HTTPS, sino usar nossl
        if (useSsl && frontendConfig.ssl) {
            return frontendConfig.ssl;
        } else if (frontendConfig.nossl || frontendConfig == "") {
            return frontendConfig.nossl;
        }
    }
    
    // Fallback a la URL actual si no hay configuración disponible
    return window.location.origin;
}

// Hacer las funciones disponibles globalmente para scripts no-module
if (typeof window !== 'undefined') {
    window.getApiBaseUrl = getApiBaseUrl;
    window.getFrontendBaseUrl = getFrontendBaseUrl;
    window.getNginxBaseUrl = getNginxBaseUrl;
    window.realizarPeticionAPI = realizarPeticionAPI;
}

// Exportar las funciones para uso en otros módulos
export { realizarPeticionAPI, getApiBaseUrl, getFrontendBaseUrl, getNginxBaseUrl }; 