using Microsoft.AspNetCore.Identity;
using API.Infraestructure.Auth;
using DataAccess.Infraestructure;
using Microsoft.Identity.Client;
using DTO.Dtos;
using BL.Utils;
using Microsoft.AspNetCore.Http; // Added for IHttpContextAccessor
using DataAccess.Identity;
using Microsoft.Extensions.Options;
using DataAccess.EntityFramework;
using Microsoft.EntityFrameworkCore;

namespace API.Services
{
    public class AuthService
    {

        private readonly SignInManager<ApplicationUser> _signInManager;
        private readonly UserManager<ApplicationUser> _userManager;
        private readonly RoleManager<IdentityRole> _roleManager;
        private readonly JwtTokenGenerator _jwtTokenGenerator;
        private readonly IHttpContextAccessor _httpContextAccessor; // Inyectar IHttpContextAccessor
        private readonly TokensService _tokensService; // Inyectar TokensService
        private readonly JwtSettings _jwtSettings; // Inyectar JwtSettings para obtener ExpiryMinutes
        private readonly FitnessCenterDbContext _context;

        public AuthService(
            UserManager<ApplicationUser> userManager,
            SignInManager<ApplicationUser> signInManager,
            JwtTokenGenerator jwtTokenGenerator,
            RoleManager<IdentityRole> roleManager,
            IHttpContextAccessor httpContextAccessor, // Añadir a la inyección de dependencias
            TokensService tokensService, // Añadir a la inyección de dependencias
            IOptions<JwtSettings> jwtOptions,
            FitnessCenterDbContext context
        )
        {
            _userManager = userManager;
            _signInManager = signInManager;
            _jwtTokenGenerator = jwtTokenGenerator;
            _roleManager = roleManager;
            _httpContextAccessor = httpContextAccessor; // Asignar
            _tokensService = tokensService; // Asignar
            _jwtSettings = jwtOptions.Value; // Asignar
            _context = context;
        }
        public async Task<DTOLoggedUser> AuthenticateUser(string username, string password)
        {
            try {
                var user = await _userManager.FindByNameAsync(username);
                if (user == null)
                    return null;
                // Validar contraseña
                var result = await _signInManager.CheckPasswordSignInAsync(user, password, false);
                if (!result.Succeeded)
                    return null;
                var roles = await _userManager.GetRolesAsync(user);
                var accessToken = await _jwtTokenGenerator.GenerateAccessToken(user, roles);
                var idToken = _jwtTokenGenerator.GenerateIdToken(user, roles);

                // Obtener información del cliente para el refresh token
                string aspnetcore_urls = Environment.GetEnvironmentVariable("ASPNETCORE_URLS") ?? "";
                bool useSsl = aspnetcore_urls.StartsWith("https", StringComparison.OrdinalIgnoreCase);
                var httpContext = _httpContextAccessor.HttpContext;
                var clientId = "gymwebapp-frontend"; // Puedes obtenerlo de la configuración o del request si es necesario
                var ipAddress =aspnetcore_urls;
                var userAgent = httpContext?.Request.Headers["User-Agent"].ToString();

                var refreshToken = await _jwtTokenGenerator.GenerateRefreshToken(user.Id, clientId);

                // Registrar Access Token e Id Token en la base de datos
                var expiresAt = DateTime.UtcNow.AddMinutes(_jwtSettings.ExpiryMinutes);
                await _tokensService.RegisterAccessTokenAsync(accessToken, user.Id, clientId, expiresAt, ipAddress, userAgent);
                await _tokensService.RegisterIdTokenAsync(idToken, user.Id, clientId, expiresAt, ipAddress, userAgent);

                return new DTOLoggedUser
                {
                    Id = user.Id,
                    Direccion = user.Direccion,
                    Correo = user.Email,
                    FechaDeNacimiento = user.FechaDeNacimiento,
                    Telefono = user.PhoneNumber,
                    NumeroDeIdentificacion = user.NumeroDeIdentificacion,
                    NombreCompleto = user.NombreCompleto,
                    AccessToken = accessToken,
                    IdToken = idToken,
                    RefreshToken = refreshToken
                };

            } catch (Exception ex) {
                Console.WriteLine($"Error en AuthenticateUser: {_context.Database.GetConnectionString()}");
                return null;
            }
            
            
        }

        public async Task<DTOLoggedUser> RefreshAccessToken(string refreshTokenString)
        {
            var userId = await _jwtTokenGenerator.ValidateRefreshToken(refreshTokenString);
            if (userId == null)
            {
                return null; // Refresh token inválido o expirado
            }

            var user = await _userManager.FindByIdAsync(userId);
            if (user == null)
            {
                return null; // Usuario no encontrado
            }

            var roles = await _userManager.GetRolesAsync(user);
            var newAccessToken = await _jwtTokenGenerator.GenerateAccessToken(user, roles);
            var newIdToken = _jwtTokenGenerator.GenerateIdToken(user, roles);
            var expdateIdToken = JwtTokenGenerator.GetClaimValue(newIdToken, "exp");
            var httpContext = _httpContextAccessor.HttpContext;
            var clientId = "gymwebapp-frontend";
            var ipAddress = httpContext?.Connection.RemoteIpAddress?.ToString();
            var userAgent = httpContext?.Request.Headers["User-Agent"].ToString();

            var newRefreshToken = await _jwtTokenGenerator.GenerateRefreshToken(user.Id, clientId); // Generar un nuevo refresh token

            await _jwtTokenGenerator.RevokeRefreshToken(refreshTokenString); // Revocar el refresh token antiguo

            // Registrar los nuevos Access Token e Id Token en la base de datos
            var expiresAt = DateTime.UtcNow.AddMinutes(_jwtSettings.ExpiryMinutes);
            await _tokensService.RegisterAccessTokenAsync(newAccessToken, user.Id, clientId, expiresAt, ipAddress, userAgent);
            await _tokensService.RegisterIdTokenAsync(newIdToken, user.Id, clientId, expiresAt, ipAddress, userAgent);

            return new DTOLoggedUser
            {
                Id = user.Id,
                Direccion = user.Direccion,
                Correo = user.Email,
                FechaDeNacimiento = user.FechaDeNacimiento,
                Telefono = user.PhoneNumber,
                NumeroDeIdentificacion = user.NumeroDeIdentificacion,
                NombreCompleto = user.NombreCompleto,
                AccessToken = newAccessToken,
                IdToken = newIdToken,
                expDateIdToken = expdateIdToken,
                RefreshToken = newRefreshToken
            };
        }

        public async Task RevokeRefreshToken(string refreshTokenString)
        {
            await _jwtTokenGenerator.RevokeRefreshToken(refreshTokenString);
        }

        public async Task<string> RegisterUser(NewUser newUser)
        {

            var user = await _userManager.FindByNameAsync(newUser.Correo);

            if (user == null)
                return null;

            var result = await _userManager.CreateAsync(user, newUser.Contrasena);
            if (!result.Succeeded)
                return null;
            var roles = await _userManager.GetRolesAsync(user);
            var token = await _jwtTokenGenerator.GenerateAccessToken(user, roles); // Usar GenerateAccessToken
            return token;
        }
        /// <summary>
        /// Registra un nuevo usuario básico
        /// </summary>
        public async Task<DTOCreatedUser> RegisterUserAsync(NewUser model)
        {
            // Verificar si el usuario ya existe
            var existingUser = await _userManager.FindByEmailAsync(model.Correo);
            if (existingUser != null)
            {
                throw new InvalidOperationException("El email ya está registrado");

            }

            try
            {
                var user = new ApplicationUser
                {
                    UserName = model.Correo,
                    Apellido = model.Apellido,
                    Email = model.Correo,
                    NombreCompleto = model.Nombre,
                    PhoneNumber = model.Telefono,
                    EmailConfirmed = true,
                    Direccion = model.Direccion,
                    FechaDeNacimiento = model.FechaDeNacimiento,
                    NumeroDeIdentificacion = model.NumeroDeIdentificacion

                    // Cambiar a true si no requieres confirmación por email
                };

                // Crear usuario con contraseña
                var result = await _userManager.CreateAsync(user, model.Contrasena);

                if (result.Succeeded)
                {
                    return new DTOCreatedUser
                    {
                        Id = user.Id,
                        Apellido = user.Apellido,
                        NombreCompleto = user.NombreCompleto,
                        FechaDeNacimiento = model.FechaDeNacimiento,
                        Direccion = model.Direccion,
                        NumeroDeIdentificacion = model.NumeroDeIdentificacion,
                        Correo = model.Correo,
                        Telefono = model.Telefono
                    };
                }
                else
                {
                    var errors = string.Join(", ", result.Errors.Select(e => e.Description));
                    throw new InvalidOperationException($"Error al registrar usuario: {errors}");
                }

            }
            catch (Exception ex)
            {
                throw new InvalidOperationException($"Error al registrar usuario: {ex.Message}");

            }
        }

        /// <summary>
        /// Registra un usuario y le asigna un rol específico
        /// </summary>
        public async Task<DTOCreatedUser> RegisterUserWithRoleAsync(NewUser model, string role = "cliente")
        {

            DTOCreatedUser registerResult = null;
            try
            {
                var usuarioYaRegistrado = await _userManager.FindByEmailAsync(model.Correo);
                if (usuarioYaRegistrado != null)
                {
                    throw new InvalidOperationException("Ese usuario ya está registrado");
                }
                // Verificar si el rol existe
                if (!await _roleManager.RoleExistsAsync(role))
                {
                    throw new InvalidOperationException("El usuario no pudo registrarse por que el rol que desea asignarle no existe");
                }
                registerResult = await RegisterUserAsync(model);
                // Obtener el usuario creado
                var user = await _userManager.FindByIdAsync(registerResult.Id);
                if (user != null)
                {
                    // Asignar rol al usuario
                    var roleResult = await _userManager.AddToRoleAsync(user, role);

                    if (!roleResult.Succeeded)
                    {
                        throw new InvalidOperationException("Error al asignar el rol al nuevo usuario");
                    }
                }
            }
            catch (Exception ex)
            {

                throw new InvalidOperationException($"Error al registrar el usuario: {ex.Message}");
            }

            return registerResult;
        }

         public async Task AddRoleToUserAsync(string userId, string role)
    {
        try
        {
            // Buscar usuario por ID
            var user = await _userManager.FindByIdAsync(userId);
            if (user == null)
            {
                throw new InvalidOperationException("Usuario no encontrado");
            }

            // Verificar si el rol existe
            if (!await _roleManager.RoleExistsAsync(role))
            {
                throw new InvalidOperationException($"El rol '{role}' no existe");
            }

            // Verificar si el usuario ya tiene el rol
            if (await _userManager.IsInRoleAsync(user, role))
            {
                throw new InvalidOperationException($"El usuario ya tiene asignado el rol '{role}'");
            }

            // Asignar rol
            var result = await _userManager.AddToRoleAsync(user, role);
            if (!result.Succeeded)
            {
                throw new InvalidOperationException($"No se pudo asignar el rol: {string.Join(", ", result.Errors)}");
            }
        }
        catch (Exception ex)
        {
            throw new InvalidOperationException($"Error al agregar rol al usuario: {ex.Message}");
        }
    }

    /// <summary>
    /// Cambia la contraseña de un usuario identificado por email. Usa token de reseteo si el usuario ya tiene contraseña.
    /// </summary>
    public async Task<IdentityResult> cambiarPassword(DTO.Dtos.UserPassEdit model)
    {
        if (model == null)
            throw new ArgumentNullException(nameof(model));

        var user = await _userManager.FindByEmailAsync(model.Email);
        if (user == null)
        {
            return IdentityResult.Failed(new IdentityError { Description = "Usuario no encontrado" });
        }

        var hasPassword = await _userManager.HasPasswordAsync(user);

        IdentityResult result;
            if (hasPassword)
            {
                // Generar token y resetear la contraseña
                var token = await _userManager.GeneratePasswordResetTokenAsync(user);
                result = await _userManager.ResetPasswordAsync(user, token, model.NewPassword);
            }
            else {
                result = IdentityResult.Failed(new IdentityError { Description = "El usuario no tiene password registrado" });
            }


                return result;
    }
    }
}