// Convierte un objeto FormData a un objeto JSON, transformando cadenas vacías o 'null' en null reales
export function formDataToJson(formData) {
    const json = {};
    for (let [key, value] of formData.entries()) {
        // Si el valor es la cadena 'null' o está vacío, asignar null real
        if (value === '' || value === 'null') {
            json[key] = null;
        } else {
            json[key] = value;
        }
    }
    return json;
} 