
const combinados = [...arreglo1, ...arreglo2];

const resultado = combinados.reduce((acc, item) => {
  const fecha = new Date(item.fecha);
  const anio = fecha.getFullYear();
  const mes = meses[fecha.getMonth()]; // nombre de mes

  if (!acc[anio]) acc[anio] = new Set();
  acc[anio].add(mes);

  return acc;
}, {});

// 🔁 Convertimos los sets a arrays
for (const anio in resultado) {
  resultado[anio] = Array.from(resultado[anio]);
}
