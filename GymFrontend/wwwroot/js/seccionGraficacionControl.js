
let dataForCharts = null;
// Method to obtain the month of the current date in number format
let idCliente = null;
let idParametro = null;
let idEjercicio = null;
let espaciadoTemporal = 'individual';
let tipoDeBusqueda = 'mes';
let fechaDeInicio = null;
let fechaFin = null;
let conDetalle = false;


const getCurrentMonth = () => {
    const date = new Date();
    return date.getMonth() + 1; // getMonth() returns month from 0-11, so add 1
};

const getCurrentYear = () => {
    const date = new Date();
    return date.getFullYear();
};

const getQueryParams = () => {
    const params = new URLSearchParams(window.location.search);
    idCliente = params.get('idCliente');
    idParametro = params.get('idParametro');
    idEjercicio = params.get('idEjercicio');
};
const fetchProgressDetails = async () => {
    try {
        let mesActual = null;
        let añoActual = null;

        getQueryParams();
        mesActual = getCurrentMonth();
        añoActual = getCurrentYear();
        //const response = await fetch(`http://localhost:5274/obtenerDetallesDeProgreso?idCliente=${idCliente}&idParametro=${idParametro}&idEjercicio=${idEjercicio}&espaciadoTemporal=${espaciadoTemporal}&tipoDeBusqueda=${tipoDeBusqueda}&fechaDeInicio=${fechaDeInicio}&fechaFin=${fechaFin}&conDetalle=${conDetalle}&mesActual=${mesActual}&añoActual=${añoActual}`);
        const response = await fetch(`http://localhost:5274/obtenerDetallesDeProgreso?idCliente=16&idParametro=4&idEjercicio=4&espaciadoTemporal=individual&tipoDeBusqueda=mes&fechaDeInicio=&fechaFin=&conDetalle=&mesActual=1&añoActual=2025`);
        if (!response.ok) {
            throw new Error('Error al consutar los detalles de progreso');
        }
        const data = await response.json();
        return data;
    } catch (error) {
        console.error('There has been a problem with your fetch operation:', error);
    }
};

dataForCharts = await fetchProgressDetails()
