using DataAccess.EntityFramework;
using Microsoft.EntityFrameworkCore;
using System;
using System.Threading.Tasks;

namespace API.Services
{
    public class UserRoleService
    {
        private readonly FitnessCenterDbContext _context;

        // Constante para el nombre del rol de empleado
        private const string ROL_EMPLEADO = "empleado";

        public UserRoleService(FitnessCenterDbContext context)
        {
            _context = context;
        }


        /// <summary>
        /// Verifica si un usuario tiene un rol específico
        /// </summary>
        /// <param name="usuarioId">ID del usuario a verificar</param>
        /// <param name="nombreRol">Nombre del rol a verificar</param>
        /// <returns>True si el usuario tiene el rol especificado, False en caso contrario</returns>
        public async Task<bool> TieneRol(int usuarioId, string nombreRol)
        {
            try
            {
                var usuario = await _context.Usuarios
                    .Include(u => u.Rol)
                    .FirstOrDefaultAsync(u => u.UsuarioId == usuarioId);

                if (usuario == null || usuario.Rol == null)
                {
                    return false;
                }

                return usuario.Rol.NombreRol?.ToLower() == nombreRol.ToLower();
            }
            catch (Exception)
            {
                return false; // En caso de error, asumimos que no tiene el rol
            }
        }

        
    }
} 