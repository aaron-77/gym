let $inputPeso = null
let $inputAltura = null;
let $inputImc = null;
let peso = null;
let altura = null;
let imc = null;
const getTruncatedString = (stringAmount) => {
    let index = stringAmount.indexOf(".");
    let truncatedString = stringAmount;
    if (index != -1) {
        truncatedString = stringAmount.slice(0, index + 2 );
        console.log(truncatedString);
    }
    return truncatedString;
}
const handleBlur = (ev) => {
    let truncatedPeso = getTruncatedString($inputPeso.value);
    let truncatedAltura = getTruncatedString($inputAltura.value);
    peso = parseFloat(truncatedPeso)
    altura = parseFloat(truncatedAltura);

    imc = peso / Math.pow(altura, 2);

    $inputImc.value = getTruncatedString(imc.toString());
}
const handleChange = (ev) => {
    let truncatedPeso = getTruncatedString($inputPeso.value);
    let truncatedAltura = getTruncatedString($inputAltura.value);
    if (truncatedAltura == null || truncatedAltura == "" ){
        console.log("no hay altura para hacer el calculo");
        return;
    }
    peso = parseFloat(truncatedPeso)
    altura = parseFloat(getTruncatedString(truncatedAltura));

    imc = Math.trunc(peso / Math.pow(altura, 2));

    $inputImc.value = imc.toString();
}

document.addEventListener("DOMContentLoaded", () => {
    $inputPeso = document.getElementById("inputPeso");
    $inputAltura = document.getElementById("inputAltura");
    $inputImc = document.getElementById("inputPorcentajeGrasa");
    $inputAltura.addEventListener("blur", handleBlur);
    $inputPeso.addEventListener("input", handleChange)
});
