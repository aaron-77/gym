// Utility functions for local date handling
export function convertirADateLocal(valorInput) {
    if (!valorInput) return null;

    // Parsear como fecha local 
    const [fechaParte, horaParte = '00:00'] = valorInput.split('T');
    const [anio, mes, dia] = fechaParte.split('-').map(Number);
    const [hora, minuto] = horaParte.split(':').map(Number);

    // Crear Date en hora LOCAL
    return new Date(anio, mes - 1, dia, hora, minuto, 0);
}

export function pad(n) {
    return n.toString().padStart(2, '0');
}

/**
 * Formatea una fecha como YYYY/MM/DD.
 * Acepta objetos Date o strings (ISO 8601, formatos parseables por Date).
 * @param {Date|string} fecha
 * @returns {string} Fecha formateada como "YYYY/MM/DD" o string vacío si es inválida
 */
export function formatearFechaSlashFormat(fecha) {
    if (!fecha) {
        console.error(`formatearFechaSlashFormat: fecha vacía o null (recibió: ${fecha})`);
        return '';
    }

    const dateObj = fecha instanceof Date ? fecha : new Date(fecha);
    if (isNaN(dateObj.getTime())) {
        console.error(`formatearFechaSlashFormat: fecha inválida (recibió: ${fecha}) — no es una fecha parseable`);
        return '';
    }

    return `${dateObj.getFullYear()}/${pad(dateObj.getMonth() + 1)}/${pad(dateObj.getDate())}`;
}

export function formatLocalDateTimeForQuery(date) {
    if (!date) return '';
    const y = date.getFullYear();
    const mo = pad(date.getMonth() + 1);
    const d = pad(date.getDate());
    const hh = pad(date.getHours());
    const mm = pad(date.getMinutes());
    return `${y}-${mo}-${d}T${hh}:${mm}:00`;
}
