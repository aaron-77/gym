import { realizarPeticionAPI } from './httpClient.js';
import { startSession } from './sessionValidator.js';
addEventListener("DOMContentLoaded", async () => {
    const sessionTimeExpiration = await getSessionTimeExpiration();
    
    if (!sessionTimeExpiration) {
        console.error("No se pudo obtener el tiempo de expiración de la sesión");
        return;
    }


    saveToLocalStorage("idTokenExpiration", sessionTimeExpiration);
    startSession(sessionTimeExpiration);
});
async function getSessionTimeExpiration() {
    let fechaDeExpiracionTokens = getFromLocalStorage("idTokenExpiration");
    let responseJson;
    if (!fechaDeExpiracionTokens) {
        console.log("no hay storedSessionTimeExpiration");
        responseJson = await realizarPeticionAPI("/getSessionTimeExpiration");
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


