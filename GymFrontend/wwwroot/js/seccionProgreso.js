
const typesOfElements = {
    ejercicio: 'ejercicio',
}
const fontResponsiveClasses = {
    normal: 'contenido-texto-dato-principal',
    small: 'contenido-texto-dato-principal-v2'
}

const haveExerciseDefined = (dataValue) => {
    if (dataValue !== null && !isNaN(dataValue) && Number(dataValue) > 0) {
        return true;
    } else {
        return false;
    }
}

const getFixedFontClass = (typeOfElement) => {
    let cssClass = '';
    switch (typeOfElement) {
        case 'ejercicio':
            cssClass = fontResponsiveClasses.small;
            break;
        default:
            cssClass = fontResponsiveClasses.normal;
    }
    return cssClass;
}

const fixResponsiveFontClass = (typeOfElement) => {
    const allContentRows = document.getElementsByClassName("row");
    const exerciseRows = Array.from(allContentRows).filter(element => haveExerciseDefined(element.dataset.fkejercicio));
    for (let element of exerciseRows) {
        const principalDataContent = Array.from(element.getElementsByClassName('contenido-texto-dato-principal'));
        for (let dataContent of principalDataContent) {
            dataContent.classList.remove(fontResponsiveClasses.normal);
            dataContent.classList.add(fontResponsiveClasses.small);
        }
    }
}

document.addEventListener('DOMContentLoaded', function () {
    fixResponsiveFontClass(typesOfElements.ejercicio);
});