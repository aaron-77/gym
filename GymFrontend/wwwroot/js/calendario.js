const estadoCalendario = {};
let añoActual = new Date().getFullYear();
let mesActual = new Date().getMonth() + 1;
let mostrandoMeses = false; // Estado para saber si se están mostrando los meses
let mostrandoAnios = false; // Estado para saber si se están mostrando los años

function inicializarCalendario() {
    mostrarMes(añoActual, mesActual);
    document.getElementById('prevMonth').addEventListener('click', () => cambiarMes(-1));
    document.getElementById('nextMonth').addEventListener('click', () => cambiarMes(1));
    document.getElementById('anioActual').innerText = añoActual;
}

function mostrarMes(año, mes) {
    document.getElementById('nombreMes').innerText = obtenerNombreMes(mes);
    const diasDelMes = obtenerDiasDelMes(año, mes);
    const vista = document.getElementById('vista');
    vista.innerHTML = ''; // Limpiar vista anterior

    diasDelMes.forEach(dia => {
        const diaDiv = document.createElement('div');
        diaDiv.className = 'dia';
        diaDiv.innerText = dia.dia;
        diaDiv.classList.add(dia.disponible ? 'disponible' : 'no-disponible');
        diaDiv.addEventListener('click', () => seleccionarDia(dia.dia));
        vista.appendChild(diaDiv);
    });
}

function obtenerNombreMes(mes) {
    const nombresMeses = [
        "Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio",
        "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre"
    ];
    return nombresMeses[mes - 1];
}

function obtenerDiasDelMes(año, mes) {
    const dias = [];
    const totalDias = new Date(año, mes, 0).getDate(); // Total de días en el mes
    for (let dia = 1; dia <= totalDias; dia++) {
        dias.push({
            dia: dia,
            disponible: Math.random() < 0.5 // Simulación de disponibilidad
        });
    }
    return dias;
}

function cambiarMes(cambio) {
    mesActual += cambio;
    if (mesActual > 12) {
        mesActual = 1;
        añoActual++;
    } else if (mesActual < 1) {
        mesActual = 12;
        añoActual--;
    }
    mostrarMes(añoActual, mesActual);
}

function seleccionarDia(dia) {
    alert(`Seleccionaste el día ${dia} de ${obtenerNombreMes(mesActual)} ${añoActual}`);
}

function toggleMeses() {
    mostrandoAnios = false;
    const listaMeses = document.getElementById('listaMeses');
    const vista = document.getElementById('vista');
    listaMeses.innerHTML = ''; // Limpiar lista anterior
    vista.innerHTML = ''; // Limpiar días

    if (mostrandoMeses) {
        // Si ya se están mostrando los meses, volver a mostrar los días
        mostrarMes(añoActual, mesActual);
        mostrandoMeses = false;
    } else {
        // Mostrar los nombres de los meses
        for (let i = 1; i <= 12; i++) {
            const mesDiv = document.createElement('div');
            mesDiv.innerText = obtenerNombreMes(i);
            mesDiv.addEventListener('click', () => {
                mesActual = i;
                mostrarMes(añoActual, mesActual);
                listaMeses.style.display = 'none';
            });
            listaMeses.appendChild(mesDiv);
        }
        listaMeses.style.display = 'flex';
        mostrandoMeses = true;
    }
}

function toggleAnios() {
    mostrandoMeses = false;
    const listaAnios = document.getElementById('listaAnios');
    const vista = document.getElementById('vista');
    listaAnios.innerHTML = ''; // Limpiar lista anterior
    vista.innerHTML = ''; // Limpiar días

    if (mostrandoAnios) {
        // Si ya se están mostrando los años, volver a mostrar los meses
        mostrarMes(añoActual, mesActual);
        mostrandoAnios = false;
    } else {
        // Mostrar los años
        for (let i = añoActual; i <= añoActual + 9; i++) {
            const anioDiv = document.createElement('div');
            anioDiv.innerText = i;
            anioDiv.addEventListener('click', () => {
                añoActual = i;
                document.getElementById('anioActual').innerText = añoActual;
                mostrarMes(añoActual, mesActual);
                listaAnios.style.display = 'none';
            });
            listaAnios.appendChild(anioDiv);
        }
        listaAnios.style.display = 'flex';
        mostrandoAnios = true;
    }
}

document.addEventListener('DOMContentLoaded', inicializarCalendario);