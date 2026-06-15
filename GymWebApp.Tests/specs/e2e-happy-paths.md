# Specs E2E - Happy Paths

## Overview
Este documento define las pruebas E2E de happy paths para la aplicación FitnessGym. Las pruebas verifican los flujos principales del usuario a través del browser, pasando por toda la pila (browser → Nginx → Frontend → API → BD).

## Ambiente
- **Infraestructura**: TestContainers (SQL Server + API + Frontend + Nginx)
- **Browser**: Playwright .NET
- **Base de datos**: Restaurada desde backup con datos de prueba
- **URL Base**: `http://localhost:5080` (Nginx)

## Credenciales de Prueba
Las credenciales se leen de `appsettings.Testing.json`:
- **TestUser (empleado)**: `uno@gmail.com` / `Password123*`
- **TestUserCliente**: Definido en config

---

## Pruebas

### 1. Público - Registro de Cuenta

| Campo | Valor |
|-------|-------|
| **Test** | `Register_ConDatosValidos_CreaCuenta` |
| **Nombre en spec** | Registro con datos válidos crea cuenta exitosamente |
| **Given** | Usuario en página de registro `/crearCuenta` |
| **When** | Completa formulario con email, contraseña y datos requeridos, envía formulario |
| **Then** | Redirige a página de login o muestra mensaje de éxito |

---

### 2. Cliente - Login

| Campo | Valor |
|-------|-------|
| **Test** | `Cliente_Login_AccedeDashboard` |
| **Nombre en spec** | Cliente logueado redirige a su dashboard |
| **Given** | Usuario en página de login `/signIn` |
| **When** | Ingresa credenciales de cliente y envía formulario |
| **Then** | Redirige a `/clientes` |

---

### 3. Cliente - Ver Detalles de Progreso

| Campo | Valor |
|-------|-------|
| **Test** | `Cliente_VerDetallesDeProgreso` |
| **Nombre en spec** | Cliente puede ver gráfico de progreso |
| **Given** | Cliente logueado en dashboard `/clientes` |
| **When** | Navega a `/detallesDeProgreso` |
| **Then** | Página carga correctamente con gráfico de medidas |

---

### 4. Cliente - Filtrar Medidas en Gráfico

| Campo | Valor |
|-------|-------|
| **Test** | `Cliente_FiltrarMedidasEnGrafico` |
| **Nombre en spec** | Cliente puede filtrar datos en el gráfico |
| **Given** | Cliente en página de detalles de progreso |
| **When** | Selecciona filtros (meses/años) y aplica |
| **Then** | Gráfico se actualiza con los datos filtrados |

---

### 5. Empleado - Login

| Campo | Valor |
|-------|-------|
| **Test** | `Empleado_Login_AccedeDashboard` |
| **Nombre en spec** | Empleado logueado redirige a su dashboard |
| **Given** | Usuario en página de login `/signIn` |
| **When** | Ingresa credenciales de empleado y envía formulario |
| **Then** | Redirige a `/empleados` |

---

### 6. Empleado - Registrar Medida

| Campo | Valor |
|-------|-------|
| **Test** | `Empleado_RegistrarMedida` |
| **Nombre en spec** | Empleado puede registrar medida de cliente |
| **Given** | Empleado logueado en dashboard `/empleados` |
| **When** | Completa formulario de medidas y envía |
| **Then** | Medida registrada exitosamente, aparece en la lista |

---

### 7. Empleado - Registrar Clase Catálogo

| Campo | Valor |
|-------|-------|
| **Test** | `Empleado_RegistrarClaseCatalogo` |
| **Nombre en spec** | Empleado puede registrar clase al catálogo |
| **Given** | Empleado logueado, navega a `/registrarClase` |
| **When** | Completa formulario con datos de clase y envía |
| **Then** | Clase registrada exitosamente en el catálogo |

---

### 8. Empleado - Programar Clase

| Campo | Valor |
|-------|-------|
| **Test** | `Empleado_ProgramarClase` |
| **Nombre en spec** | Empleado puede programar clase |
| **Given** | Empleado logueado, navega a `/registroClasesProgramadas` |
| **When** | Programa fecha/hora de clase y envía |
| **Then** | Clase programada exitosamente |

---

### 9. Empleado - Inscribir Cliente a Clase

| Campo | Valor |
|-------|-------|
| **Test** | `Empleado_InscribirClienteAClase` |
| **Nombre en spec** | Empleado puede inscribir cliente a clase |
| **Given** | Empleado logueado, navega a `/inscripcionAClases` |
| **When** | Selecciona cliente y clase, confirma inscripción |
| **Then** | Cliente inscrito exitosamente |

---

### 10. Empleado - Registrar Cita

| Campo | Valor |
|-------|-------|
| **Test** | `Empleado_RegistrarCita` |
| **Nombre en spec** | Empleado puede registrar cita |
| **Given** | Empleado logueado, navega a `/registrarCita` |
| **When** | Completa formulario de cita y envía |
| **Then** | Cita registrada exitosamente |

---

### 11. Empleado - Modificar Cita

| Campo | Valor |
|-------|-------|
| **Test** | `Empleado_ModificarCita` |
| **Nombre en spec** | Empleado puede modificar cita existente |
| **Given** | Empleado logueado, navega a `/modificarCita` |
| **When** | Modifica datos de cita y guarda |
| **Then** | Cita modificada exitosamente |

---

### 12. Empleado - Gestionar Rutinas

| Campo | Valor |
|-------|-------|
| **Test** | `Empleado_GestionarRutinas` |
| **Nombre en spec** | Empleado puede gestionar rutinas |
| **Given** | Empleado logueado, navega a `/gestionRutinas` |
| **When** | Crea/editar rutina y guarda |
| **Then** | Rutina guardada exitosamente |

---

### 13. Empleado - Asignar Ejercicios a Rutinas

| Campo | Valor |
|-------|-------|
| **Test** | `Empleado_AsignarEjerciciosARutina` |
| **Nombre en spec** | Empleado puede asignar ejercicios a rutinas |
| **Given** | Empleado logueado, navega a `/AsignacionEjercicios` |
| **When** | Selecciona ejercicios y los asigna a una rutina |
| **Then** | Ejercicios asignados exitosamente a la rutina |

---

## Estructura de Archivos

```
GymWebApp.Tests/
├── E2E/
│   ├── Common/
│   │   ├── E2eContainerHelper.cs     # Infraestructura
│   │   └── PlaywrightTestBase.cs    # Clase base
│   ├── Features/
│   │   └── E2EHappyPathsTests.cs   # Todas las pruebas
│   └── specs/
│       └── e2e-happy-paths.md    # Este archivo
```

## Convenciones

- **Naming**: `{Rol}_{Accion}_{Resultado}`
- **Herencia**: Todas las clases heredan de `PlaywrightTestBase`
- **Colección**: `Collection("E2E HappyPaths")`
- **Setup**: `IAsyncLifetime` con `InitializeAsync` y `DisposeAsync`
- **Credenciales**: Se leen de `appsettings.Testing.json`