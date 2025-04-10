import { ObservadorSujeto } from "./observerPattern.js"
let dataForCharts = null;
// Method to obtain the month of the current date in number format
let $chartContainer = document.querySelector(".chart-container");
let myChart = null;
let $chartCanvas = document.getElementById("myChart");
let idCliente = null;
let idParametro = null;
let idEjercicio = null;
let espaciadoTemporal = '';
let fechaCreacionMedida = null;
let tipoDeBusqueda = '';
let fechaDeInicio = null;
let fechaFin = null;
let conDetalle = true;
let $monthCheckBoxes = document.querySelectorAll(".month-checkbox-item");
let $yearCheckBoxes = document.querySelectorAll(".year-checkbox-item");
let $rangeDateElements = document.querySelectorAll(".range-element");
const $submitButton = document.getElementById("submitButton");
const $form = document.getElementById('chartForm');
const $espaciadoTemporal = document.getElementById('espaciadoTemporal');
const $tipoDeBusqueda = document.getElementById('tipoDeBusqueda');
const $fechaInicio = document.getElementById('fechaInicio');
const $fechaFin = document.getElementById('fechaFin');
const $customTimeSearchItems = document.querySelectorAll('.custom-time-search-item');
const $conDetalle = document.getElementById('conDetalle');
const $ejercicios = document.getElementById('inputEjercicio');
const $parametros = document.getElementById('inputParametro');
const $errorMessageContainer = document.getElementById("errorMessageContainer");
const parametrosObserver = new ObservadorSujeto();
const espaciadoTemporalObserver = new ObservadorSujeto();
const tipoDeBusquedaObserver = new ObservadorSujeto();
const fechaInicioOserver = new ObservadorSujeto();
const fechaFinObserver = new ObservadorSujeto();
let mesesObsevers = [];
let añosObservers = [];
let observersOfObserverPattern = [];
let ejerciciosYParametrosDelCliente = [];
let ejercicioSeleccionado = null;
let parametroSeleccionado = null;
let ejerciciosDelCliente = [];
let parametrosDelCliente = [];
let isFormVisible = true;

function isEmpty(value) {
  return !value;
}
function validarOrdenDeFechas(fechaInicio, fechaFin) {

}

let nameFormFieldsAndDependiencies = {
  inputEjercicio: { name: "idEjercicio", dependencies: [], validations: [isEmpty] },
  inputParametro: { name: "idParametro", dependencies: ["espaciadoTemporal", "tipoDeBusqueda", "fechaInicio", "fechaFin", "mesesDeFiltro", "añosDeFiltro"], validations: [isEmpty] },
  espaciadoTemporal: { name: "espaciadoTemporal", dependencies: ["mesesDeFiltro", "añosDeFiltro", "fechaInicio", "fechaFin"], validations: [isEmpty] },
  tipoDeBusqueda: { name: "tipoDeBusqueda", dependencies: ["mesesDeFiltro", "añosDeFiltro", "fechaInicio", "fechaFin"], validations: [isEmpty] },
  fechaInicio: { name: "fechaInicio", dependencies: [], validations: [isEmpty] },
  fechaFin: { name: "fechaFin", dependencies: [], validations: [isEmpty] },
  mesesDeFiltro: { name: "mesesDeFiltro", dependencies: [], validations: [isEmpty] },
  añosDeFiltro: { name: "añosDeFiltro", dependencies: [], validations: [isEmpty] }
}

function getYearOfCustomDate(customDate) {
  return customDate.getFullYear();
}

function getCurrentMonth() {
  const date = new Date();
  return date.getMonth() + 1; // getMonth() returns month from 0-11, so add 1
}

function getCurrentYear() {
  const date = new Date();
  return date.getFullYear();
}

function populateSelect(selectElement, data, valueProperty = 'value', textProperty = 'text') {
  // Limpiar las opciones existentes
  selectElement.innerHTML = '';
  // Iterar sobre los datos y agregar un option por cada uno
  let defaultOption = document.createElement('option');
  defaultOption.id = "defaultOption";
  defaultOption.value = null;  // Usar la propiedad para el value
  defaultOption.textContent = "Selecciona una opcion"
  selectElement.appendChild(defaultOption);
  data.forEach(item => {
    let option = document.createElement('option');
    option.value = item[valueProperty];  // Usar la propiedad para el value
    option.textContent = item[textProperty];  // Usar la propiedad para el texto
    selectElement.appendChild(option);
  });
}
function calcularDiferenciaDeFechaEnDias(fechaMayor, fechaMenor) {
  let diferenciaDias = 0;

  if (!fechaMayor || !fechaMenor) {
    return diferenciaDias;;
  }
  // convertir las fechas a objetos date para poderlas restar
  const fecha1 = new Date(fechaMayor);
  const fecha2 = new Date(fechaMenor);
  // Calcular la diferencia en milisegundos
  const diferenciaMs = Math.abs(fecha1 - fecha2);
  // Convertir la diferencia a días
  diferenciaDias = diferenciaMs / (1000 * 60 * 60 * 24);
  return diferenciaDias
}
function resultsCanBeDetailded(dateDifferenceInDays) {
  const MINIMUM_DAYS_FOR_DETAIL = 60;
  let canBeDetailed = false;
  switch (espaciadoTemporal) {
    case "rango":
      if (dateDifferenceInDays >= MINIMUM_DAYS_FOR_DETAIL) {
        canBeDetailed = true;
      }
      break;
    case "individual":
      if (tipoDeBusqueda == "año") {
        canBeDetailed = true;
      }
      break;
    default:
      canBeDetailed = false;
  }

  return canBeDetailed;
}
function enableOrDiseableConDetalleCheckBox(fechaMayor, fechaMenor) {
  const dierenciaFechaEndias = calcularDiferenciaDeFechaEnDias(fechaMayor, fechaMenor);
  if (!resultsCanBeDetailded(dierenciaFechaEndias)) {
    desactivarConDetalleCheckBox();
    return;
  }
  activarConDetalleCheckBox();
}
function getQueryParams() {
  const params = new URLSearchParams(window.location.search);
  idCliente = params.get('idCliente');
  idParametro = params.get('idParametro');
  idEjercicio = params.get('idEjercicio');
  espaciadoTemporal = params.get('espaciadoTemporal');
  tipoDeBusqueda = params.get('tipoDeBusqueda');
  fechaCreacionMedida = parseDate(params.get('fechaDeCreacion'));

}

export function assembleQueryParams(...parametersAndValues) {
  // si la cantdidad de elementos no es par el ensamblaje no se puede realizar, ya que se espera que el nombre del parametro y el valor del parametro esten juntos
  if (parametersAndValues.length % 2 != 0) {
    throw new Error('Error al ensamblar los parametros de la consulta, la cantidad de parametros y valores no es par');
  }
  const queryParams = new URLSearchParams();
  for (let index in parametersAndValues) {
    //si el indice impar entonces es el nombre del parametro y sabemos que se esta visitando el nombre, por lo tanto el siguiente valor es el valor del parametro
    index = parseInt(index);
    if (index == 0 || index % 2 == 0) {
      const paramName = parametersAndValues[index];
      const paramValue = parametersAndValues[index + 1];
      // si es un arreglo el parametro tiene que enviarse multiples veces para que sea reconocido como array en el api
      if (Array.isArray(paramValue)) {
        for (let value of paramValue) {
          queryParams.append(paramName, value);
        }
      } else {
        //si no es arreglo simplemente se agrega el parametro y su valor(CUIDADO no se esta revisando que no haya sido agregado anteriormente)
        queryParams.append(paramName, paramValue);
      }
    }
  }
  return queryParams;

}

function resetExercisesData() {
  ejerciciosDelCliente = ejerciciosYParametrosDelCliente
    .filter(ejercicio => ejercicio.ejercicioId != null)
    .map(ejercicio => { return { ejercicioId: ejercicio.ejercicioId, nombreEjercicio: ejercicio.nombreEjercicio } });

}
function resetParametersData() {
  parametrosDelCliente = ejerciciosYParametrosDelCliente
    .map(parametro => { return { parametroMedicionId: parametro.parametroMedicionId, nombreParametro: parametro.nombreParametro } });
}
function setSelectedExercise(idEjercicio) {
  let ejercicioConParametroEncontrado = ejerciciosYParametrosDelCliente.find(exer => exer.ejercicioId == idEjercicio);
  let ejercicio = { ejercicioId: ejercicioConParametroEncontrado.ejercicioId, nombreEjercicio: ejercicioConParametroEncontrado.nombreEjercicio }
  ejercicioSeleccionado = ejercicio;
}
function setClientParameters(idEjercicio) {
  let parametrosDelEjercicio = ejerciciosYParametrosDelCliente.filter(ejerYpParam => ejerYpParam.ejercicioId == idEjercicio)
    .map(exerYParm => {
      return {
        parametroMedicionId: exerYParm.parametroMedicionId, nombreParametro: exerYParm.nombreParametro
      }
    });
  parametrosDelCliente = parametrosDelEjercicio;
}
function setSelectedParameter(idParametro) {
  parametroSeleccionado = parametrosDelCliente.find(param => param.parametroMedicionId == idParametro)
}


async function fetchEjerciciosYParametrosDelCliente(idCliente) {
  try {
    let serverResponse = await fetch(`http://localhost:5274/api/obtenerEjerciciosYParametros?idCliente=${idCliente}`);
    const jsonServerResponse = await serverResponse.json();
    if (!jsonServerResponse.ok) {
      throw new Error('Error al consutar los ejercicios y parametros del cliente');
    }
    ejerciciosYParametrosDelCliente = jsonServerResponse.data;
    resetExercisesData();
    resetParametersData();
  } catch (error) {
    console.log(error)
  }
}
async function fetchProgressDetails() {
  try {
    let mesDeMedida = getMonthOfCustomDate(fechaCreacionMedida);
    let añoDeMedida = getYearOfCustomDate(fechaCreacionMedida);
    addMonth(mesDeMedida);
    addYear(añoDeMedida);
    const queryParams = assembleQueryParams("idCliente", idCliente,
      "idParametro", idParametro,
      "idEjercicio", idEjercicio,
      "espaciadoTemporal", espaciadoTemporal,
      "tipoDeBusqueda", tipoDeBusqueda,
      "fechaDeInicio", fechaDeInicio,
      "fechaFin", fechaFin,
      "conDetalle", conDetalle,
      "mesesDeFiltro", selectedMonths,
      "añosDeFiltro", selectedYears).toString();
    const response = await fetch(`http://localhost:5274/obtenerDetallesDeProgreso?${queryParams}`);
    //const response = await fetch(`http://localhost:5274/obtenerDetallesDeProgreso?idCliente=${idCliente}&idParametro=${idParametro}&idEjercicio=${idEjercicio}&espaciadoTemporal=${espaciadoTemporal}&tipoDeBusqueda=${tipoDeBusqueda}&fechaDeInicio=${fechaDeInicio}&fechaFin=${fechaFin}&conDetalle=${conDetalle}&mesesDeFiltro=${monthsJsonArray}&añosDeFiltro=${yearsJsonArray}`);
    if (!response.ok) {
      throw new Error('Error al consutar los detalles de progreso');
    }
    const data = await response.json();
    return data;
  } catch (error) {
    console.error('There has been a problem with your fetch operation:', error);
  }
}

export function makeMesageText(...texts) {
  return texts.join(" ");
}

export function getMontName(monthNumber) {
  for (let month in monthMapping) {
    if (monthMapping[month] === monthNumber) {
      return month;
    }
  }
}


function parseDate(fechaStr) {
  if (!fechaStr) return null; // Manejo de valores nulos o vacíos

  // Dividir la parte de la fecha y la hora
  const [fechaParte, horaParte] = fechaStr.split(" ");

  // Dividir la fecha en [Día, Mes, Año]
  const [dia, mes, anio] = fechaParte.split("/").map(num => parseInt(num, 10));

  // Verificar si hay una parte de hora y extraer [Horas, Minutos, Segundos]
  let horas = 0, minutos = 0, segundos = 0;
  if (horaParte) {
    [horas, minutos, segundos] = horaParte.split(":").map(num => parseInt(num, 10) || 0);
  }

  // Crear la fecha correctamente (meses en JS van de 0 a 11)
  return new Date(anio, mes - 1, dia, horas, minutos, segundos);
}

function removeMonth(monthNumber) {
  selectedMonths = selectedMonths.filter(month => month !== monthNumber);
}
function removeYear(year) {
  selectedYears = selectedYears.filter(year => year !== year);
}

function desactivarConDetalleCheckBox() {
  $conDetalle.disabled = true;
}
function activarConDetalleCheckBox() {
  $conDetalle.disabled = false;
}
function desactivarInputs(...inputs) {
  inputs.forEach(input => {
    input.disabled = true;
  });
}

function activarInputs(...inputs) {
  inputs.forEach(input => {
    input.disabled = false;
  });
}

function uncheckCheckboxes(...checkboxes) {
  for (let checkbox of checkboxes) {
    let monthNumber = monthMapping[checkbox.value];
    checkbox.checked = false;
    const event = new Event('change', { bubbles: true });
    checkbox.dispatchEvent(event);
    console.log(selectedMonths);
  }
}

function checkCheckboxes(...checkboxes) {
  for (let checkbox of checkboxes) {
    checkbox.checked = true;
    const event = new Event('change', { bubbles: true });
    checkbox.dispatchEvent(event);
    console.log(selectedMonths);
  }
}
function getActualMontCheckBox() {
  let currentMonthCheckBox = null;
  for (let checkbox of $monthCheckBoxes) {
    if (parseInt(monthMapping[checkbox.value]) == getCurrentMonth()) {
      return checkbox;
      //checkbox.disabled = true;
    }
  }
}
function getActualYearCheckbox(params) {
  for (let checkbox of $yearCheckBoxes) {
    if (parseInt(checkbox.value) == getCurrentYear()) {
      return checkbox;
    }
  }
  return null;
}

function getMonthOfCustomDate(customDate) {
  return customDate.getMonth() + 1;
}


export function generateTitleXAxis(selectedMonthsOrYears, espaciadoTemporal, tipoDeBusqueda, fechaInicial, fechaFinal) {
  if (espaciadoTemporal === "individual" && tipoDeBusqueda === "mes") {
    const mesesOAñosSeleccionados = selectedMonthsOrYears.map(mes => `${getMontName(mes)}`);
    return makeMesageText("Mediciones en los meses: ", mesesOAñosSeleccionados) + ` ${getCurrentYear()}`;
  } else if (espaciadoTemporal == "individual" && tipoDeBusqueda == "año") {
    const mesesOAñosSeleccionados = selectedMonthsOrYears.map(mes => `${getMontName(mes)}`);
    return makeMesageText("Mediciones en los años: ", mesesOAñosSeleccionados);
  }
  else if (espaciadoTemporal === "rango") {
    return `Mediciones de ${fechaInicial} a ${fechaFinal}`;
  } else {
    return "Configuración no válida";
  }
}


const monthMapping = {
  'enero': 1,
  'febrero': 2,
  'marzo': 3,
  'abril': 4,
  'mayo': 5,
  'junio': 6,
  'julio': 7,
  'agosto': 8,
  'septiembre': 9,
  'octubre': 10,
  'noviembre': 11,
  'diciembre': 12
};
function getMonthAbbreviation(monthNumber) {
  for (let [mes, num] of Object.entries(monthMapping)) {
    if (num === monthNumber) {
      return mes.substring(0, 3).charAt(0).toUpperCase() + mes.substring(1, 3); // Capitaliza la primera letra
    }
  }
  return ""; // En caso de error
}

export function formatFecha(fechaStr) {
  let fecha = new Date(fechaStr);

  let dia = fecha.getDate().toString().padStart(2, '0');
  let mesAbrev = getMonthAbbreviation(fecha.getMonth() + 1); // +1 porque getMonth() devuelve base 0
  let año = fecha.getFullYear();

  return `${dia}/${mesAbrev}/${año}`;
}

export function makeDataLabelXAxis(value, weekNumber) {
  let message = "";
  if (espaciadoTemporal == "individual" && tipoDeBusqueda == "mes") {

    message = `semana ${weekNumber} ${formatFecha(value)}`;
    return message;
  } else if (espaciadoTemporal == "individual" && tipoDeBusqueda == "año" || espaciadoTemporal == "rango") {
    message = `${formatFecha(value)}`;
    return message;
  }
}
function createObjectFromMap(...map) {
  const objeto = {};
  if (map instanceof Map) {
    // Si es un Map, iteramos sobre sus entradas
    for (const [clave, valor] of map) {
      objeto[clave] = valor;
    }
  } else {
    console.error("El objeto no es un Map");
  }
  return objeto;
}
function makeConfigForChart() {
  let annotations = {};
  dataForCharts.data.metasDeMedida.forEach((meta, index) => {
    annotations[`meta ${index + 1}`] = {
      type: 'line',
      yMin: meta.valorObjetivo,
      yMax: meta.valorObjetivo,
      borderColor: 'rgb(161, 255, 99)',
      borderWidth: 2,
      label: {
        content: `meta ${index + 1}`,
        display: true,
        position: "end",
        backgroundColor: "rgb(150, 150, 150)",
        yAdjust: -17,
        drawTime: 'afterDatasetsDraw'
      }
    }
  })
  return {
    responsive: true,
    plugins: {
      title: {
        display: true,
        text: makeMesageText("Tu progreso en", dataForCharts.data.medidas[0].nombreParametro)
      },
      annotation: {
        annotations: annotations
      }
    },
    scales: {
      x: {
        type: 'category',

        title: {
          display: true,
          text: generateTitleXAxis(selectedMonths, espaciadoTemporal, tipoDeBusqueda, fechaDeInicio, fechaFin)
        }
      }
    },
    responsive: true,
    maintainAspectRatio: false 

  }
}
function registerPluginsForChart() {
  Chart.register(window['chartjs-plugin-annotation']);
}
function makeDatasetsForChart(labelForTitleDataSet = ["Tus mediciones"], ...arrayDataForMultipleDatasets) {
  let datasets = [];
  for (let index in arrayDataForMultipleDatasets) {
    datasets.push({
      label: labelForTitleDataSet,
      data: arrayDataForMultipleDatasets[index].map((dataObject, index) => { return dataObject })
    });
    return datasets;
  }
}

//-------------------- empeiza codigode bolt------------------------------------
let selectedMonths = [];
let selectedYears = [];
// Function to initialize the chart
function initializeChart(chartType) {
  registerPluginsForChart()
  const ctx = document.getElementById('myChart');
  let valoresMedidas = dataForCharts.data.medidas.map((medida, index) => { return medida.valor });
  let labelsForXAxisValues = dataForCharts.data.medidas.map((medida, index) => { return makeDataLabelXAxis(medida.fechaDeCreacion, index + 1) })
  let datasetTitle = makeMesageText("Tus mediciones de ", dataForCharts.data.medidas[0].nombreParametro);
  const dataSets = makeDatasetsForChart([datasetTitle], valoresMedidas);
  const options = makeConfigForChart();
  myChart = new Chart(ctx, {
    type: chartType,
    data: {
      labels: labelsForXAxisValues,
      datasets: dataSets
    },
    options: options
  });

}
function updateChart() {
  let valoresMedidas = dataForCharts.data.medidas.map((medida, index) => { return medida.valor });
  let labelsForXAxisValues = dataForCharts.data.medidas.map((medida, index) => { return makeDataLabelXAxis(medida.fechaDeCreacion, index + 1) })
  let datasetTitle = makeMesageText("Tus mediciones de ", dataForCharts.data.medidas[0].nombreParametro);
  const dataSets = makeDatasetsForChart([datasetTitle], valoresMedidas);
  const options = makeConfigForChart();//las opciones no se pueden reemplazar con asignacion normal
  myChart.data.labels = labelsForXAxisValues;
  myChart.data.datasets = dataSets;
  myChart.options = options;
  myChart.update();
}

function handleRangeDateInputChange(event) {
  tipoDeBusqueda=null;  
  if (event.currentTarget.id == "fechaInicio") {
    fechaDeInicio = event.currentTarget.value;

  } else {
    fechaFin = event.currentTarget.value;
  }
  if (fechaDeInicio && fechaFin) {
    enableOrDiseableConDetalleCheckBox(fechaFin, fechaDeInicio);
  }
}
// Function to handle month selection
function handleMonthSelection(event) {
  const monthNumber = monthMapping[event.target.value];

  if (event.target.checked) {
    addMonth(monthNumber);
  } else {
    removeMonth(monthNumber);
  }

  sortSelectedMonths();
  console.log('Selected months:', selectedMonths);
}

function handleYearSelection(event) {
  const yearNumber = event.target.value;
  if (event.target.checked) {
    addYear(yearNumber);
  } else {
    removeYear(yearNumber);
  }
  sortSelectedYears();
  console.log('Selected years', selectedYears);
}
function handleExersiceSelection(event) {
  const $select = event.currentTarget;
  let $option = $select.options[$select.selectedIndex];
  let idOptionSelected = $option.id;
  if (idOptionSelected == "defaultOption") {
    idEjercicio = null;
    resetExercisesData();
    resetParametersData();
    populateSelect($ejercicios, ejerciciosDelCliente, "ejercicioId", "nombreEjercicio");
    populateSelect($parametros, parametrosDelCliente, "parametroMedicionId", "nombreParametro")
    return;
  }
  idEjercicio = parseInt($select.value);
  let idExerciseSelected = parseInt($select.value);
  setSelectedExercise(idExerciseSelected);
  setClientParameters(idExerciseSelected);
  populateSelect($parametros, parametrosDelCliente, 'parametroMedicionId', 'nombreParametro');

}
function getParameterSelected($input) {
  let $option = $input.options[$input.selectedIndex];
  let idOptionSelected = $option.value;
  return idOptionSelected;
}
function handleParameterSelection(event) {
  const $select = event.currentTarget;
  let idOptionSelected = getParameterSelected($select);
  executeParametersIntarectionLogic(idOptionSelected);
}


// Function to add a month to the selection
function addMonth(monthNumber) {
  if (!selectedMonths.includes(monthNumber)) {
    selectedMonths.push(monthNumber);
  }
}
function addYear(year) {
  year = parseInt(year);
  if (!selectedYears.includes(year)) {
    selectedYears.push(year);
  }
}

// Function to sort selected months
function sortSelectedMonths() {
  selectedMonths.sort((a, b) => a - b);
}
function sortSelectedYears() {
  selectedYears.sort((a, b) => a - b);
}
function executeParametersIntarectionLogic(idOptionSelected) {
  if (idOptionSelected == "defaultOption") {
    resetExercisesData();
    resetParametersData();
    populateSelect($ejercicios, ejerciciosDelCliente, "ejercicioId", "nombreEjercicio");
    populateSelect($parametros, parametrosDelCliente, "parametroMedicionId", "nombreParametro")
    parametrosObserver.notificar(true);
    return;
  }
  idParametro = parseInt(idOptionSelected);
  setSelectedParameter(idParametro);
  parametrosObserver.notificar(false);
}

function executeTemporalSpacingInteractionLogic(espaciadoTemporal) {
  if (!espaciadoTemporal) {
    espaciadoTemporalObserver.notificar(true);
    return;
  }
  if (espaciadoTemporal == "rango") {
    espaciadoTemporalObserver.notificarATodosExceptoA({ idInput: ["fechaInicio", "fechaFin"], isDisabled: true })
    espaciadoTemporalObserver.notificarA({ idInput: ["fechaInicio", "fechaFin"], isDisabled: false });
  } else {
    espaciadoTemporalObserver.notificarA({ idInput: "tipoDeBusqueda", isDisabled: false });
    espaciadoTemporalObserver.notificarATodosExceptoA({ idInput: "tipoDeBusqueda", isDisabled: true });
  }
}
function executeTipoDeBusquedaInteractionLogic(tipoDeBusqueda) {
  if (!tipoDeBusqueda) {
    tipoDeBusquedaObserver.notificar(true);
    return;
  }
  if (tipoDeBusqueda == "mes") {
    addYear(getCurrentYear());
    checkSelectedYears();
    getActualMontCheckBox().checked = true;
    tipoDeBusquedaObserver.notificarGrupo({ nameParticle: "mesesDeFiltro", isDisabled: false });
    tipoDeBusquedaObserver.notificarGrupo({ nameParticle: "añosDeFiltro", isDisabled: true });
    enableOrDiseableConDetalleCheckBox(fechaDeInicio, fechaFin);
    addMonth(getCurrentMonth());
    checkSelectedMonths();
  } else {// tipos de busqueda = año
    $conDetalle.checked = false;
    uncheckCheckboxes(...$yearCheckBoxes)
    addYear(getCurrentYear());
    checkSelectedYears();
    tipoDeBusquedaObserver.notificarGrupo({ nameParticle: "mesesDeFiltro", isDisabled: true });
    tipoDeBusquedaObserver.notificarGrupo({ nameParticle: "añosDeFiltro", isDisabled: false });
  }
}
function executeCheckBoxInteractionLogic($checkbox) {
  if ($checkbox.disabled == true && checkbox.checked) {
    $checkbox.disabled = false;
  }
}
// Function to handle temporal spacing changes
function handleTemporalSpacing(event) {
  espaciadoTemporal = event.target.value;
  executeTemporalSpacingInteractionLogic(espaciadoTemporal);
  enableOrDiseableConDetalleCheckBox();
}
function handleTipoDeBusqueda(event) {
  tipoDeBusqueda = event.target.value;
  // no se selecciono nada, o se selecciono el valor por defecto
  executeTipoDeBusquedaInteractionLogic(tipoDeBusqueda);
  //toggleInputs(espaciadoTemporal);
}
function handleMutationChecked(mutations, observer) {
  mutations.forEach((mutation) => {
    const mutatedElement = mutation.target;
    if (mutation.attributeName === "disabled" && mutatedElement.disabled == true && mutatedElement.type == "checkbox" && mutatedElement.checked) {
      mutatedElement.checked = false;
    }
  });
}
function handleMutationGeneralInput(mutations, observer) {

  function isADisabledInput(mutation, mutatedElement) {
    const isADisabledInput =
      mutation.attributeName === "disabled"
      && mutatedElement.disabled == true
      && (mutatedElement.type == "input"
        || mutatedElement.tagName == "SELECT"
      );

    return isADisabledInput;
  }

  function inputHasValueAndIsDisabled(mutation, mutatedElement) {
    const inputHasValueAndIsDisabled = mutation.attributeName === "value" && mutatedElement.disabled == true && mutatedElement.value;
    return inputHasValueAndIsDisabled;
  }

  mutations.forEach((mutation) => {
    const mutatedElement = mutation.target;
    if (isADisabledInput(mutation, mutatedElement)) {
      resetValueInput(mutatedElement);
      for (let observerPatterInstance of observersOfObserverPattern) {
        if (mutatedElement.id == observerPatterInstance.htmlInput.id) {
          observerPatterInstance.notificar(true);
        }
      }
    } else if (inputHasValueAndIsDisabled(mutation, mutatedElement)) {
      generalInputMutationLogic(mutatedElement);
    }
  });
}
function generalInputMutationLogic(input) {
  if (!input) {
    console.error("no hay un input para aplicarle la interaccion");
    return;
  }
  const idInput = input.id;
  let data = input.value;
  switch (idInput) {
    case "inputParametro":
      data = getParameterSelected(input);
      executeParametersIntarectionLogic(data);
      break;

    case "espaciadoTemporal":
      executeTemporalSpacingInteractionLogic(data);
      break;

    case "tipoDeBusqueda":
      executeTipoDeBusquedaInteractionLogic(data);
      break;
  }

}
function handleMutationDateInputs(mutations, observer) {
  mutations.forEach((mutation) => {
    const mutatedElement = mutation.target;
    if (mutation.attributeName === "disabled" && mutatedElement.disabled == false && mutatedElement.type == "date") {
      toggleRequiredAttributeToElement(true, mutatedElement)
    } else if (mutation.attributeName === "disabled" && mutatedElement.disabled == true && mutatedElement.type == "date") {
      toggleRequiredAttributeToElement(false, mutatedElement)
      resetValueInput(mutatedElement);
    }
  });
}

function resetValueInput(input) {
  input.value = "";

}
function attachMutationObserver(observer, ...elements) {
  for (let element of elements) {
    observer.observe(element, { attributes: true, characterData: true });
  }
}
function groupObserverOfObserverPattern(...observers) {
  for (let observer of observers) {
    if (!observersOfObserverPattern.includes(observer)) {
      observersOfObserverPattern.push(observer);
    }
  }
}

function toggleRequiredAttributeToElement(isRequired, ...elements) {
  if (isRequired) {
    for (let element of elements) {
      element.required = true;
    }
  } else {
    for (let element of elements) {
      element.required = false;
    }
  }

}

function configureInputsAfterAutomaticDisplayData(...$inputs) {
  for (let $input of $inputs) {
    generalInputMutationLogic($input);
  }
}
// Function to toggle date inputs
function toggleInputs(espaciadoTemporal) {
  if (espaciadoTemporal == "rango") {
    //enableOrDiseableConDetalleCheckBox(fechaFin, fechaDeInicio);
    //desactivarInputs(...$customTimeSearchItems);
    //uncheckCheckboxes($conDetalle)
    //uncheckCheckboxes(...$monthCheckBoxes);
    //uncheckCheckboxes(...$yearCheckBoxes);
    //activarInputs(...$rangeDateElements);
    /* for (let dateInput of $rangeDateElements) {
      dateInput.required = true;
      dateInput.required = true;
    } */
  } else {
    if (tipoDeBusqueda == "mes") {
      $conDetalle.checked = true;
      addYear(getCurrentYear());
      checkSelectedYears();
      getActualMontCheckBox();
      activarInputs(...$customTimeSearchItems)
      desactivarInputs(document.getElementById("conDetalle"));
      desactivarInputs(...$yearCheckBoxes);
      activarInputs(...$monthCheckBoxes);
      uncheckCheckboxes(...$monthCheckBoxes);
      addMonth(getCurrentMonth());
      checkSelectedMonths();

    } else {
      $conDetalle.checked = false;
      uncheckCheckboxes(...$yearCheckBoxes)
      addYear(getCurrentYear());
      checkSelectedYears();
      getActualYearCheckbox().disabled = true;
      desactivarInputs(...$monthCheckBoxes);
      activarInputs(...$yearCheckBoxes);
      checkCheckboxes(...$monthCheckBoxes);
      activarInputs(document.getElementById("conDetalle"));
    }
    enableOrDiseableConDetalleCheckBox(fechaFin, fechaDeInicio);
    desactivarInputs(...$rangeDateElements);
    //activarInputs(...$customTimeSearchItems);
    for (let dateInput of $rangeDateElements) {
      dateInput.required = true;
      dateInput.required = true;
      dateInput.value = '';
      dateInput.value = '';
    }
  }
}

// Function to handle form changes
function handleFormChange() {
  const formData = new FormData(document.forms[0]);
  const data = Object.fromEntries(formData);
  console.log('Form data:', data);
  console.log('Selected months array:', selectedMonths);
}

// Initialize form elements
function checkSelectedMonths() {
  for (let checkbox of $customTimeSearchItems) {
    if (selectedMonths.includes(monthMapping[checkbox.value])) {
      checkbox.checked = true;
    }
  }
}
function checkSelectedYears() {
  for (let checkbox of $yearCheckBoxes) {
    if (selectedYears.includes(parseInt(checkbox.value))) {
      checkbox.checked = true;
    }
  }
}
function checkConDetallesCheckbox() {
  if (espaciadoTemporal == "individual" && tipoDeBusqueda == "mes") {
    $conDetalle.checked = true;
  }
}
function displayDataToInputs() {
  $espaciadoTemporal.value = espaciadoTemporal;
  $tipoDeBusqueda.value = tipoDeBusqueda;
  $fechaInicio.value = fechaDeInicio;
  $fechaFin.value = fechaFin;
  $parametros.value = parametrosDelCliente.find(param => param.parametroMedicionId = parseInt(idParametro)).parametroMedicionId;
  checkSelectedMonths();
  checkSelectedYears()
  checkConDetallesCheckbox();
}
function configureCheckBoxObservers($checkboxes) {
  const checkBoxObservers = [];
  for (let checkbox of $checkboxes) {
    let checkBoxObserver = new ObservadorSujeto();
    checkBoxObserver.htmlInput = checkbox;
    checkBoxObservers.push(checkBoxObserver);
  }
  return checkBoxObservers;
}
function configureObsevers() {
  espaciadoTemporalObserver.htmlInput = $espaciadoTemporal;
  tipoDeBusquedaObserver.htmlInput = $tipoDeBusqueda;
  fechaInicioOserver.htmlInput = $fechaInicio;
  fechaFinObserver.htmlInput = $fechaFin;
  mesesObsevers = configureCheckBoxObservers($monthCheckBoxes)
  añosObservers = configureCheckBoxObservers($yearCheckBoxes);
  parametrosObserver.htmlInput = $parametros;
  espaciadoTemporalObserver.suscribirVarios(mesesObsevers);
  espaciadoTemporalObserver.suscribirVarios(añosObservers)
  espaciadoTemporalObserver.suscribir(tipoDeBusquedaObserver);
  espaciadoTemporalObserver.suscribirVarios([fechaInicioOserver, fechaFinObserver]);
  tipoDeBusquedaObserver.suscribirVarios(mesesObsevers);
  tipoDeBusquedaObserver.suscribirVarios(añosObservers)
  parametrosObserver.suscribir(espaciadoTemporalObserver);
  groupObserverOfObserverPattern(espaciadoTemporalObserver
    , tipoDeBusquedaObserver
    , fechaInicioOserver
    , fechaFinObserver
    , ...mesesObsevers
    , ...añosObservers
    , parametrosObserver
    , espaciadoTemporalObserver
  );
}
function toggleElementVisibility($input, isVisible) {
  $input.style.visibility = (isVisible) ? "visible" : "hidden";
}
function toggleChartOrErrorMessage(data) {
  if (data.length <= 0) {
    toggleElementVisibility($errorMessageContainer, true);
    toggleElementVisibility($chartCanvas, false);
    return;
  }
  toggleElementVisibility($errorMessageContainer, false);
  toggleElementVisibility($chartCanvas, true);
  

}


// Add event listeners
$rangeDateElements.forEach(dateElement => {
  dateElement.addEventListener('change', handleRangeDateInputChange);
});
$monthCheckBoxes.forEach(checkbox => {
  checkbox.addEventListener('change', handleMonthSelection);
});
$yearCheckBoxes.forEach(checkbox => {
  checkbox.addEventListener('change', handleYearSelection);
});

$ejercicios.addEventListener('change', handleExersiceSelection);
$parametros.addEventListener('change', handleParameterSelection);

$espaciadoTemporal.addEventListener('change', handleTemporalSpacing);
$tipoDeBusqueda.addEventListener('change', handleTipoDeBusqueda);
$form.addEventListener('change', handleFormChange);
$submitButton.addEventListener("click", async (ev) => {
  const $button = ev.currentTarget;
  $button.disabled = true;
  dataForCharts = await fetchProgressDetails();
  toggleForm();
  $button.disabled = false;
  if(dataForCharts.data.medidas.length >= 1){
    toggleChartOrErrorMessage(dataForCharts.data.medidas);
    updateChart();
  }else{
    toggleChartOrErrorMessage(dataForCharts.data.medidas);
  }
  
})

const mutationObserverMonthChecboxes = new MutationObserver(handleMutationChecked)
const mutationObserverDateInputs = new MutationObserver(handleMutationDateInputs)
const mutationObserverGeneralInputs = new MutationObserver(handleMutationGeneralInput);
attachMutationObserver(mutationObserverMonthChecboxes, ...$monthCheckBoxes, ...$yearCheckBoxes)
attachMutationObserver(mutationObserverDateInputs, ...$rangeDateElements)
attachMutationObserver(mutationObserverGeneralInputs, $parametros, $espaciadoTemporal, $tipoDeBusqueda);
getQueryParams();
configureObsevers();
await fetchEjerciciosYParametrosDelCliente(idCliente);
dataForCharts = await fetchProgressDetails()
populateSelect($ejercicios, ejerciciosDelCliente, 'ejercicioId', 'nombreEjercicio');
populateSelect($parametros, parametrosDelCliente, 'parametroMedicionId', 'nombreParametro');
displayDataToInputs();
configureInputsAfterAutomaticDisplayData($parametros, $espaciadoTemporal, $tipoDeBusqueda);
console.log(dataForCharts)
// Initialize chart or show error message
if(dataForCharts.data.medidas.length >= 1){
  toggleChartOrErrorMessage(dataForCharts.data.medidas);
  initializeChart("line");
}else{
  toggleChartOrErrorMessage(dataForCharts.data.medidas);
}

/* function toggleForm() {
    const formSlide = document.getElementById('formSlide');
    const slideableContainer = document.querySelector('.slideable-container');
    const chartContainer = document.querySelector('.chart-container');
    const toggleBtn = document.querySelector('.toggle-form-btn i');
    
    formSlide.classList.toggle('hidden');
    slideableContainer.classList.toggle('hidden');
    chartContainer.classList.toggle('expanded');
    isFormVisible = !isFormVisible;
    
    if (isFormVisible) {
        toggleBtn.classList.remove('fa-chevron-right');
        toggleBtn.classList.add('fa-chevron-left');
    } else {
        toggleBtn.classList.remove('fa-chevron-left');
        toggleBtn.classList.add('fa-chevron-right');
    }
} */
function toggleForm(){
  let collapseElement = document.getElementById("collapseOne");
  let bsCollapse = new bootstrap.Collapse(collapseElement, {
      toggle: false
  });
  bsCollapse.hide();
}




