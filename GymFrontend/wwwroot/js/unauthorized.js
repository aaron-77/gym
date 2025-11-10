function goBack() {
  // Try to go back in browser history
  if (window.history.length > 1) {
    window.history.back()
  } else {
    console.warn("No hay historial para volver");
  }
}
