# Tasks: horariosDelDiaInscripcion.js — Vista de Horarios para Cancelar/Reagendar Inscripciones

> Spec: specs/74-spect-horariosDelDiaInscripcion-js-vistaCancelarReagendar.md

## Phase 1: Implementation

- [x] 1.1 Agregar `preReservaHorarioInscripcion` key en `GymFrontend/appsettings.json` sección `EndPoints`: `"preReservaHorarioInscripcion": "/Horarios/preReservarHorarioInscripcion"`
- [x] 1.2 Crear `GymFrontend/wwwroot/js/horariosDelDiaInscripcion.js` — clon de `horariosDelDia.js` con 3 diferencias:
  - Constructor: agregar `this.selectedIdClaseProgramada = null`
  - `handleScheduleClick`: guardar `element.dataset.idClaseProgramada` en `this.selectedIdClaseProgramada`
  - `registrarPreReservaDeHorario`: leer endpoint de `window.AppConfig.EndPoints.preReservaHorarioInscripcion` con fallback; agregar `idClaseProgramada` al body
- [x] 1.3 Modificar `GymFrontend/wwwroot/js/cancelarReagendarInscripcion.js` — cambiar import de `'./horariosDelDia.js'` a `'./horariosDelDiaInscripcion.js'`

## Verify

- [ ] 2.1 `dotnet build GymFrontend/GymFrontend.csproj` — compila sin errores
- [ ] 2.2 Verificar que `window.AppConfig.EndPoints.preReservaHorarioInscripcion` queda expuesto en el HTML renderizado (revisar el script tag generado por AppConfigTagHelper)
