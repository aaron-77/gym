# Respaldo de Datos Hardcodeados - Clases

> Generado: 2026-05-21
> Origen: HomeController.Index() + DetalleDeClase.cshtml
> Propósito: Datos de referencia para seed de BD (clases, imágenes, beneficios, estructura, ejercicios, consejos, equipamiento, horarios)

---

## 1. Previews de Clases (HomeController.Index)

| idClase | nombreClase | descripcionCortaClase | urlImage |
|---------|-------------|----------------------|----------|
| 5 | Entrenamiento HIIT | Entrenamiento de intervalos de alta intensidad para maximizar la quema de calorías y mejorar la salud cardiovascular. | /img/hiit.jpg |
| 2 | Fuerza y Potencia | Desarrolla músculo, aumenta la fuerza y desarrolla potencia explosiva con nuestro programa de fuerza integral. | /img/strenght.jpg |
| 3 | CrossFit | Combina fuerza y acondicionamiento en movimientos funcionales variados realizados a alta intensidad. | /img/crossfit.jpg |
| 4 | Boxeo | Aprende técnicas de boxeo mientras obtienes un entrenamiento de cuerpo completo que mejora la coordinación y quema calorías. | /img/boxing.jpg |
| 1 | Entrenamiento Funcional | Mejora tus movimientos diarios con ejercicios que simulan actividades comunes. | /img/functional.jpg |
| 6 | Entrenamiento Personal | Obtén atención personalizada y entrenamientos personalizados para alcanzar tus objetivos específicos de fitness. | /img/personaltraining.jpg |

---

## 2. Detalle de Clase - Entrenamiento HIIT (idClase=5)

### Header
- **Título**: ENTRENAMIENTO **HIIT**
- **Subtítulo**: Entrenamiento por Intervalos de Alta Intensidad
- **Duración**: 45 minutos
- **Intensidad**: Alta Intensidad
- **Nivel**: Intermedio a Avanzado
- **Banner**: `@Model.imagenesDeClase.urlParaBanner` (hardcodeado en modelo)

### Descripción General
- **Imagen**: `/img/hiit2.jpg`
- **Texto párrafo 1**: El Entrenamiento por Intervalos de Alta Intensidad (HIIT) alterna entre ráfagas intensas de actividad y períodos fijos de actividad menos intensa o descanso. Nuestras clases HIIT están diseñadas para aumentar tu ritmo cardíaco y quemar más grasa en menos tiempo.
- **Texto párrafo 2**: Este tipo de entrenamiento te proporciona un entrenamiento completo mientras mejora tu condición cardiovascular y maximiza la quema de calorías. Los estudios han demostrado que el HIIT puede quemar hasta un 30% más de calorías que otras formas de cardio en el mismo período de tiempo.

### Beneficios (fallback)
| beneficio | descripcionBeneficio | urlPublica |
|-----------|---------------------|------------|
| Mejora Cardiovascular | Aumenta la capacidad aeróbica y anaeróbica | ~/img/heart.svg |
| Quema de Grasa | Mayor quema calórica durante y después del ejercicio | ~/img/flame.svg |
| Eficiencia | Resultados máximos en tiempo mínimo | ~/img/svgacceso24black.svg |

### Estructura de Clase (fallback)
| TituloBloque | DuracionMenorEnMinutos | DuracionMayorEnMinutos | DescripcionBloque |
|--------------|----------------------|----------------------|-------------------|
| Calentamiento | 5 | 7 | Comenzamos con un calentamiento dinámico para preparar el cuerpo para el ejercicio intenso. Incluye movilidad articular, activación muscular y elevación gradual del ritmo cardíaco. |
| Bloques HIIT | 30 | 30 | El núcleo de la clase consiste en 4-6 bloques de ejercicios de alta intensidad. Cada bloque alterna entre 20-40 segundos de trabajo máximo y 10-20 segundos de descanso. Realizamos 3-4 rondas de cada bloque con un minuto de recuperación entre bloques. |
| Enfriamiento | 5 | 7 | Finalizamos con ejercicios de baja intensidad para reducir gradualmente el ritmo cardíaco, seguidos de estiramientos estáticos para mejorar la flexibilidad y acelerar la recuperación. |

### Ejercicios Principales (fallback - comentado en vista)
| NombreEjercicio | DescripcionEjercicio | UrlIcono |
|-----------------|---------------------|----------|
| Burpees | Ejercicio de cuerpo completo que combina sentadilla, plancha, flexión y salto. Excelente para desarrollar resistencia cardiovascular y fuerza. | ~/img/burpees.jpg |
| Mountain Climbers | En posición de plancha, alternamos llevando las rodillas hacia el pecho. Trabaja el core y eleva el ritmo cardíaco. | ~/img/mountainclimbers.webp |
| Jumping Jacks | Saltos abriendo y cerrando piernas y brazos simultáneamente. Excelente ejercicio cardiovascular que involucra todo el cuerpo. | ~/img/jumpingjacks.webp |
| Sentadillas con Salto | Sentadilla tradicional seguida de un salto explosivo. Desarrolla potencia en el tren inferior y eleva el ritmo cardíaco. | ~/img/sentadillaconsalto.jpg |

### Consejos (fallback - comentado en vista)
- Comienza con versiones modificadas de los ejercicios hasta dominar la técnica correcta.
- Escucha a tu cuerpo y toma descansos adicionales si los necesitas.
- Mantén una buena hidratación antes, durante y después de la clase.

### Equipamiento (fallback - comentado en vista)
| NombreEquipo | Descripcion |
|--------------|-------------|
| Mancuernas Ligeras | Para añadir resistencia a ejercicios como sentadillas o press de hombros. |
| Kettlebells | Ideales para ejercicios balísticos como swings o clean and press. |
| Esterilla | Para mayor comodidad en ejercicios de suelo como planchas o abdominales. |

### Horarios (fallback)
| DiaDeLaSemana | HoraInicio | HoraFin | NombreEntrenador |
|---------------|------------|---------|------------------|
| Lunes | 6:00 | 6:45 | Sara Jiménez |
| Martes | 17:30 | 18:15 | Miguel Martínez |
| Jueves | 6:00 | 6:45 | Sara Jiménez |

### Imagen Tips
- `/img/lesiongym.jpg`

---

## 3. Imágenes Referenciadas

| Ruta | Uso |
|------|-----|
| /img/hiit.jpg | Preview HIIT |
| /img/strenght.jpg | Preview Fuerza |
| /img/crossfit.jpg | Preview CrossFit |
| /img/boxing.jpg | Preview Boxeo |
| /img/functional.jpg | Preview Funcional |
| /img/personaltraining.jpg | Preview Personal |
| /img/hiit2.jpg | Detalle HIIT descripción |
| /img/lesiongym.jpg | Detalle HIIT tips |
| ~/img/heart.svg | Beneficio cardiovascular |
| ~/img/flame.svg | Beneficio quema grasa / intensidad |
| ~/img/svgacceso24black.svg | Beneficio eficiencia / duración |
| ~/img/burpees.jpg | Ejercicio Burpees |
| ~/img/mountainclimbers.webp | Ejercicio Mountain Climbers |
| ~/img/jumpingjacks.webp | Ejercicio Jumping Jacks |
| ~/img/sentadillaconsalto.jpg | Ejercicio Sentadillas con Salto |
