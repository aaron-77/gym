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
 * Obtiene la fecha y hora de referencia del browser en formato yyyy-MM-dd HH:mm:ss.
 * @param {Date|string} [fecha] - Fecha a formatear. Default: ahora del browser. Si ya es string se devuelve tal cual.
 * @returns {string} Fecha y hora en formato yyyy-MM-dd HH:mm:ss
 */
function obtenerFechaReferencia(fecha = new Date()) {
    // Si ya viene formateada como string, se devuelve sin cambios
    if (typeof fecha === 'string') {
        return fecha;
    }
    return fecha
        .toLocaleString('sv-SE', { year: 'numeric', month: '2-digit', day: '2-digit', hour: '2-digit', minute: '2-digit', second: '2-digit', hour12: false })
        .replace(',', '');
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
        const nginxConfig = window.AppConfig.EndPoints.nginx;

        // Usar SSL si está disponible y el protocolo es HTTPS, sino usar nossl
        if (useSsl && nginxConfig.frontendssl) {
            return nginxConfig.frontendssl;
        } else if (nginxConfig.frontend || nginxConfig.frontend == "") {
            return nginxConfig.frontend;
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
    if (typeof window !== 'undefined' && window.AppConfig && window.AppConfig.EndPoints && window.AppConfig.EndPoints.api && window.AppConfig.EndPoints.frontend) {
        // Determinar si usar SSL basado en el protocolo actual
        const useSsl = window.location.protocol === 'https:';
        const apiConfig = window.AppConfig.EndPoints.api;
        
        // Usar SSL si está disponible y el protocolo es HTTPS, sino usar nossl
        if (useSsl && apiConfig.frontendssl) {
            return apiConfig.frontendssl;
        } else if (apiConfig.frontend || apiConfig.frontend == "") {
            return apiConfig.frontend;
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
        if (useSsl && frontendConfig.frontendssl) {
            return frontendConfig.frontendssl;
        } else if (frontendConfig.frontend || frontendConfig.frontend == "") {
            return frontendConfig.frontend;
        }
    }
    
    // Fallback a la URL actual si no hay configuración disponible
    return window.location.origin;
}

/**
 * Obtiene la URL base para SignalR desde la configuración
 * @returns {string} URL base para SignalR
 */
function getSignalRBaseUrl() {
    if (typeof window !== 'undefined' && window.AppConfig && window.AppConfig.EndPoints && window.AppConfig.EndPoints.signalEndpoint) {
        return window.AppConfig.EndPoints.signalEndpoint;
    }
    
    console.warn('signalEndpoint no configurado, usando URL por defecto');
    return getNginxBaseUrl();
}

/**
 * Resuelve la ruta de un endpoint BFF desde window.AppConfig.EndPoints
 * @param {string} key - Nombre de la key ENDPOINT_* registrada en appsettings.json (ej: "ENDPOINT_CLASES_OBTENERCLASES")
 * @param {string} fallback - Ruta literal exacta a usar cuando la config no está disponible o el valor es vacío/nulo
 * @returns {string} Ruta del endpoint configurada, o el fallback si no hay valor válido
 */
function obtenerEndpoint(key, fallback) {
    const value = window?.AppConfig?.EndPoints?.[key];
    return value ? value : fallback;
}

// Estado de carga de botones de acción
/** @type {WeakMap<HTMLElement, {original: string, originalWidth: string, pendingLabel: string|null, loading: boolean}>} */
const buttonState = new WeakMap();

const BUTTON_SPINNER = '<span class="spinner-border spinner-border-sm" role="status" aria-hidden="true"></span>';

/**
 * Resuelve un botón a partir de un elemento, un selector CSS o un id.
 * No lanza excepciones: devuelve null si no se puede resolver.
 * @param {HTMLElement|string|null} target - Elemento, selector CSS o id del botón
 * @returns {HTMLElement|null} El botón resuelto, o null
 */
function resolveButton(target) {
    try {
        if (!target) return null;
        if (typeof target === 'string') return document.querySelector(target);
        return target instanceof HTMLElement ? target : null;
    } catch {
        return null;
    }
}

/**
 * Deshabilita el botón y muestra un spinner sin texto visible mientras dura la operación.
 * Idempotente: si el botón ya está en carga, no hace nada.
 * @param {HTMLElement|string|null} target - Elemento, selector CSS o id del botón
 * @returns {HTMLElement|null} El botón en estado de carga, o null si no se pudo resolver
 */
function setButtonLoading(target) {
    const button = resolveButton(target);
    if (!button) return null;

    let state = buttonState.get(button);
    if (state?.loading) return null;

    // Registrar el original solo la primera vez: nunca sobreescribirlo con el spinner
    if (!state) {
        state = {
            original: button.innerHTML,
            originalWidth: button.style.width,
            pendingLabel: null,
            loading: false
        };
        buttonState.set(button, state);
    } else {
        // Ciclo nuevo: descartar cualquier label pendiente de la carga anterior
        state.pendingLabel = null;
    }

    // Medir antes de deshabilitar, pinear antes de mutar: evita el salto de ancho
    const width = button.offsetWidth;
    button.style.width = `${width}px`;
    button.disabled = true;
    button.innerHTML = BUTTON_SPINNER;
    button.setAttribute('aria-busy', 'true');
    state.loading = true;

    return button;
}

/**
 * Restituye el botón a su estado original: contenido, ancho y habilitación.
 * No-op si el botón no está en estado de carga.
 * @param {HTMLElement|string|null} target - Elemento, selector CSS o id del botón
 * @param {{label?: string}} [options] - label explícito a restaurar (tiene prioridad sobre el pendiente)
 * @returns {void}
 */
function restoreButton(target, options = {}) {
    try {
        const button = resolveButton(target);
        if (!button) return;

        const state = buttonState.get(button);
        if (!state?.loading) return;

        // Gana el pendiente si hubo cambio de estado durante la carga, luego el explícito, luego el original
        if (state.pendingLabel !== null) {
            button.innerHTML = state.pendingLabel;
        } else if (options.label !== undefined) {
            button.innerHTML = options.label;
        } else {
            button.innerHTML = state.original;
        }

        button.style.width = state.originalWidth;
        button.disabled = false;
        button.removeAttribute('aria-busy');
        buttonState.delete(button);
    } catch {
        // El helper nunca puede romper el flujo del handler que lo usa
    }
}

/**
 * Ejecuta una acción con el botón en estado de carga y lo restituye siempre,
 * incluso si la acción lanza una excepción.
 * @param {HTMLElement|string|null} target - Elemento, selector CSS o id del botón
 * @param {Function} action - Acción asíncrona a ejecutar
 * @returns {Promise<any>} El resultado de la acción
 */
async function withButtonLoading(target, action) {
    const button = setButtonLoading(target);
    try {
        return await action();
    } finally {
        restoreButton(button);
    }
}

/**
 * Escribe el label del botón respetando si está en estado de carga.
 * Si está cargando, difiere la escritura como label pendiente para no destruir el spinner.
 * @param {HTMLElement|string|null} target - Elemento, selector CSS o id del botón
 * @param {string} html - Contenido HTML nuevo del botón
 * @returns {void}
 */
function setButtonLabel(target, html) {
    try {
        const button = resolveButton(target);
        if (!button) return;

        const state = buttonState.get(button);
        if (state?.loading) {
            state.pendingLabel = html;
            return;
        }
        button.innerHTML = html;
    } catch {
        // No-op defensivo
    }
}

// Hacer las funciones disponibles globalmente para scripts no-module
if (typeof window !== 'undefined') {
    window.getApiBaseUrl = getApiBaseUrl;
    window.getFrontendBaseUrl = getFrontendBaseUrl;
    window.getNginxBaseUrl = getNginxBaseUrl;
    window.getSignalRBaseUrl = getSignalRBaseUrl;
    window.realizarPeticionAPI = realizarPeticionAPI;
    window.obtenerFechaReferencia = obtenerFechaReferencia;
    window.obtenerEndpoint = obtenerEndpoint;
    window.resolveButton = resolveButton;
    window.setButtonLoading = setButtonLoading;
    window.restoreButton = restoreButton;
    window.withButtonLoading = withButtonLoading;
    window.setButtonLabel = setButtonLabel;
}

// Exportar las funciones para uso en otros módulos
export { realizarPeticionAPI, getApiBaseUrl, getFrontendBaseUrl, getNginxBaseUrl, getSignalRBaseUrl, obtenerFechaReferencia, obtenerEndpoint, resolveButton, setButtonLoading, restoreButton, withButtonLoading, setButtonLabel }; 