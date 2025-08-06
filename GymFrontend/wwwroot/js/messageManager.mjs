import sweetalert2 from 'https://cdn.jsdelivr.net/npm/sweetalert2@11.22.2/+esm';




export const iconTypes = {
    success: 'success',
    error: 'error',
    warning: 'warning',
    info: 'info'
};

export   async function showMessage(messageType, message,messageDuration = undefined) {
    
    let response = await sweetalert2.fire({
        icon: messageType,
        title: message,
        showConfirmButton: false,
        timer: messageDuration
    });
    return response;
}


export async function showSimpleDialog(messageType, message,messageDuration = undefined) {
    let response =  await sweetalert2.fire({
        icon: messageType,
        title: message,
        showConfirmButton: true,
        timer: messageDuration
    });
    return response;
}


export async function showComplexDialog(messageType, message,config = {}) {
    
    let response = await sweetalert2.fire({
        icon: messageType,
        title: message,
        showConfirmButton: config.showConfirmButton || true,
        showCancelButton: config.showCancelButton || false,
        confirmButtonText: config.confirmButtonText || 'Aceptar',
        cancelButtonText: config.cancelButtonText || 'Cancelar',
        timer: config.messageDuration || undefined,
    });
    return response;
}