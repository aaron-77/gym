using DataAccess.EntityFramework;
using Microsoft.EntityFrameworkCore;
using System;
using System.Threading.Tasks;
using System.Linq; // Added for .Any()
using Microsoft.AspNetCore.Identity;
using DataAccess.Identity; // Nuevo: Necesario para UserManager

namespace API.Services
{
    public class UserRoleService
    {
        private readonly FitnessCenterDbContext _context;
        private readonly UserManager<ApplicationUser> _userManager; // Nuevo: Para manejar usuarios y roles de Identity

        // Constante para el nombre del rol de empleado
        private const string ROL_EMPLEADO = "empleado";

        public UserRoleService(FitnessCenterDbContext context, UserManager<ApplicationUser> userManager) // Modificado: Se añadió UserManager
        {
            _context = context;
            _userManager = userManager; // Inicialización
        }


        /// <summary>
        /// Verifica si un usuario tiene un rol específico
        /// </summary>
        /// <param name="usuarioId">ID del usuario a verificar</param>
        /// <param name="nombreRol">Nombre del rol a verificar</param>
        /// <returns>True si el usuario tiene el rol especificado, False en caso contrario</returns>
        public async Task<bool> TieneRol(string usuarioId, string nombreRol)
        {
            try
            {
                var usuario = await _userManager.FindByIdAsync(usuarioId); // Usa UserManager para encontrar el usuario

                if (usuario == null)
                {
                    return false;
                }

                return await _userManager.IsInRoleAsync(usuario, nombreRol); // Usa UserManager para verificar el rol
            }
            catch (Exception)
            {
                return false; // En caso de error, asumimos que no tiene el rol
            }
        }

        
    }
} 