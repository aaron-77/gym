using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;

using API.Services.Validaciones;
using BL.Utils;
using BL.Validaciones;
using DataAccess.EntityFramework;
using DataAccess.Identity;
using DTO.Dtos;

namespace API.Services
{
    public class ServiceConsultarInscripcionesDeCliente : IServiceConsultarInscripcionesDeCliente
    {
        private readonly FitnessCenterDbContext _context;
        private readonly ILogger<ServiceConsultarInscripcionesDeCliente> _logger;
        private readonly IValidadorUsuarioExistente _validadorUsuario;

        /// <summary>
        /// Constructor principal con DI.
        /// </summary>
        public ServiceConsultarInscripcionesDeCliente(
            FitnessCenterDbContext context,
            ILogger<ServiceConsultarInscripcionesDeCliente> logger,
            IValidadorUsuarioExistente validadorUsuario)
        {
            _context = context;
            _logger = logger;
            _validadorUsuario = validadorUsuario;
        }

        /// <summary>
        /// Constructor de retrocompatibilidad — crea el validador internamente.
        /// Usado por tests existentes que aún no inyectan IValidadorUsuarioExistente.
        /// </summary>
        public ServiceConsultarInscripcionesDeCliente(
            FitnessCenterDbContext context,
            UserManager<ApplicationUser> userManager,
            ILogger<ServiceConsultarInscripcionesDeCliente> logger)
            : this(context, logger, new ValidadorUsuarioExistente(userManager))
        {
        }

        public async Task<DTOResponse<List<DTOInscripcionDelCliente>>> ConsultarInscripcionesAsync(string idUsuario)
        {
            try
            {
                // Paso 1: Validar formato del ID usando validador estático
                var (esValido, mensajeError) = ValidadorStringId.Validar(idUsuario, "ID de usuario");
                if (!esValido)
                {
                    return ResponseManager.BuildResponse<List<DTOInscripcionDelCliente>>(
                        success: false,
                        httpCode: 400,
                        message: "Datos inválidos",
                        errors: new List<ErrorModel>
                        {
                            new() { message = mensajeError, propiedad = "idUsuario" }
                        },
                        payload: null!);
                }

                // Paso 2: Validar que el usuario exista en BD
                var (existe, _) = await _validadorUsuario.ValidarAsync(idUsuario);
                if (!existe)
                {
                    return ResponseManager.BuildResponse<List<DTOInscripcionDelCliente>>(
                        success: false,
                        httpCode: 404,
                        message: "Usuario no encontrado",
                        errors: new List<ErrorModel>
                        {
                            new() { message = "El usuario especificado no existe.", propiedad = "idUsuario" }
                        },
                        payload: null!);
                }

                // Paso 3: Ejecutar función SQL para obtener inscripciones
                var inscripciones = await ExecuteQueryAsync(idUsuario);

                // Paso 4: Retornar respuesta exitosa
                return ResponseManager.BuildResponse<List<DTOInscripcionDelCliente>>(
                    success: true,
                    httpCode: 200,
                    message: "Consulta exitosa",
                    errors: null,
                    payload: inscripciones);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error al consultar inscripciones del cliente {IdUsuario}", idUsuario);

                return ResponseManager.BuildResponse<List<DTOInscripcionDelCliente>>(
                    success: false,
                    httpCode: 500,
                    message: "Error interno del servidor",
                    errors: new List<ErrorModel>
                    {
                        new() { message = "Ocurrió un error al consultar las inscripciones.", propiedad = null }
                    },
                    payload: null!);
            }
        }

        /// <summary>
        /// Ejecuta la consulta SQL contra la función fn_obtenerInscripcionesDelCliente.
        /// Separado en método virtual para permitir mocking en tests unitarios.
        /// </summary>
        protected virtual async Task<List<DTOInscripcionDelCliente>> ExecuteQueryAsync(string idUsuario)
        {
            return await _context
                .InscripcionesDelClienteSP
                .FromSqlInterpolated($"SELECT * FROM dbo.fn_obtenerInscripcionesDelCliente({idUsuario})")
                .ToListAsync();
        }
    }
}
