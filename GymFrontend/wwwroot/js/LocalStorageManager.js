/**
 * Guarda un valor en localStorage.
 * @param {string} key - Nombre de la clave.
 * @param {*} value - Valor a guardar (se convierte a JSON).
 */
function saveToLocalStorage(key, value) {
    try {
      localStorage.setItem(key, JSON.stringify(value));
      console.log(`✅ Guardado: ${key}`);
    } catch (error) {
      console.error("Error al guardar en localStorage", error);
    }
  }
  
  /**
   * Obtiene un valor desde localStorage.
   * @param {string} key - Nombre de la clave.
   * @returns {*} Valor parseado o null si no existe.
   */
  function getFromLocalStorage(key) {
    try {
      const data = localStorage.getItem(key);
      return data ? JSON.parse(data) : null;
    } catch (error) {
      console.error("Error al obtener de localStorage", error);
      return null;
    }
  }
  
  /**
   * Modifica un valor ya existente en localStorage.
   * @param {string} key - Nombre de la clave.
   * @param {*} newValue - Nuevo valor a guardar.
   */
  function updateLocalStorage(key, newValue) {
    if (localStorage.getItem(key) !== null) {
      saveToLocalStorage(key, newValue);
      console.log(`✏️ Modificado: ${key}`);
    } else {
      console.warn(`⚠️ La clave "${key}" no existe en localStorage`);
    }
  }
  
  /**
   * Elimina un valor de localStorage.
   * @param {string} key - Nombre de la clave.
   */
  function removeFromLocalStorage(key) {
    if (localStorage.getItem(key) !== null) {
      localStorage.removeItem(key);
      console.log(`🗑️ Eliminado: ${key}`);
    } else {
      console.warn(`⚠️ La clave "${key}" no existe en localStorage`);
    }
  }
  
  /**
   * Limpia todo el localStorage.
   */
  function clearLocalStorage() {
    localStorage.clear();
    console.log("🧹 localStorage limpiado por completo");
  }
  