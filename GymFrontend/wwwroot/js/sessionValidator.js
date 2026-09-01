import { realizarPeticionAPI, obtenerEndpoint } from './httpClient.js';
import { logout } from './Logout.js';
// ====== Configuración ======
const inactivityCheckTime = 10 * 1000; // 10 segundos
const warningBeforeExp = 60 * 1000; // 1 minuto antes

let warningTimer;    // Timer para lanzar la advertencia
let countdownTimer;  // Timer de los 10 segundos

// ====== Función principal ======
export function startSession(tokensExpirationDate) {
  const exp = tokensExpirationDate * 1000; // exp viene en segundos UNIX
  const now = Date.now();

  const timeUntilWarning = exp - now - warningBeforeExp;

  if (timeUntilWarning > 0) {
    warningTimer = setTimeout(showExpirationWarning, timeUntilWarning);
  } else {
    // si ya está cerca de expirar
    showExpirationWarning();
  }
}

// ====== Aviso de expiración ======
 function showExpirationWarning() {
  console.log("⚠️ Tu sesión está por expirar. Muestro modal al usuario...");
  // aquí podrías mostrar un modal con la cuenta regresiva

  // Iniciar los 10 segundos
  countdownTimer = setTimeout(() => {
    console.log("⏱️ Usuario inactivo en la ventana crítica → logout()");
    logoutSession();
  }, inactivityCheckTime);

  // Escuchar interacción del usuario
  watchUserActivity(renewSession);
}

// ====== Detectar actividad ======
 function watchUserActivity(onActive) {
  const reset = () => {
    clearTimeout(countdownTimer); // cancela el logout
    removeListeners();
    onActive();
  };

  const events = ["mousemove", "keydown", "mousedown", "scroll", "touchstart"];
  events.forEach(ev => window.addEventListener(ev, reset, { once: true }));

  function removeListeners() {
    events.forEach(ev => window.removeEventListener(ev, reset));
  }
}

// ====== Renovar sesión ======
async function renewSession() {
  console.log("✅ Usuario activo → renovar token con refresh");
  const responseJson = await realizarPeticionAPI(obtenerEndpoint('ENDPOINT_USUARIOS_UPDATEIDANDACCESSTOKENS', "/updateIdAndAccessTokens"),{updateTokens:true});
  removeFromLocalStorage("idTokenExpiration");
  saveToLocalStorage("idTokenExpiration", responseJson.payload.expDateIdToken);
  if(!responseJson.success){
    console.log("Error al renovar la sesion");
    return;
  }
  const sessionTimeExpiration = await getSessionTimeExpiration();
  startSession(sessionTimeExpiration);
  if (responseJson.success === false) {
    console.error("Error al renovar la sesion");
    logoutSession();
    return;
  }
  console.log("Sesión renovada con éxito");
}

// ====== Logout ======
async function logoutSession() {
  console.log("🚪 Cerrando sesión...");
  removeFromLocalStorage("idTokenExpiration");
  // limpiar tokens y redirigir al login
  logout();
}



async function getSessionTimeExpiration() {
    let fechaDeExpiracionTokens = getFromLocalStorage("idTokenExpiration");
    let responseJson;
    if (!fechaDeExpiracionTokens) {
        console.log("no hay storedSessionTimeExpiration");
        responseJson = await realizarPeticionAPI(obtenerEndpoint('ENDPOINT_USUARIOS_GETSESSIONTIMEEXPIRATION', "/getSessionTimeExpiration"));
    }else{
        return fechaDeExpiracionTokens;
    }
    
    if (!responseJson || responseJson.success === false) {
        console.error("Error fetching session expiration time");
        return null;
    }

    fechaDeExpiracionTokens = responseJson.payload;

    if (!fechaDeExpiracionTokens) {
        console.error("No expiration time found in response");
        return null;
    }

    return fechaDeExpiracionTokens


}

addEventListener("DOMContentLoaded", async () => {
    const sessionTimeExpiration = await getSessionTimeExpiration();
    
    if (!sessionTimeExpiration) {
        console.error("No se pudo obtener el tiempo de expiración de la sesión");
        return;
    }


    saveToLocalStorage("idTokenExpiration", sessionTimeExpiration);
    startSession(sessionTimeExpiration);
});


