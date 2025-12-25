// Utility functions for local date handling
export function convertirADateLocal(valorInput) {
    if (!valorInput) return null;

    // Parsear como fecha local
    const [fechaParte, horaParte = '00:00'] = valorInput.split('T');
    const [año, mes, dia] = fechaParte.split('-').map(Number);
    const [hora, minuto] = horaParte.split(':').map(Number);

    // Crear Date en hora LOCAL
    return new Date(año, mes - 1, dia, hora, minuto, 0);
}

export function pad(n) {
    return n.toString().padStart(2, '0');
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
