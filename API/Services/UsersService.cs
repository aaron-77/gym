using DataAccess.Identity;
using DTO.Dtos;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace API.Services
{
    public class UsersService : IUsersService
    {
        private readonly UserManager<ApplicationUser> _userManager;

        public UsersService(UserManager<ApplicationUser> userManager)
        {
            _userManager = userManager;
        }

        public async Task<List<QueryUser>> GetUsuariosPorRolAsync(string rol)
        {
            try
            {
                // Obtener todos los usuarios que pertenecen al rol
                var usersInRole = await _userManager.GetUsersInRoleAsync(rol);

                // Mapear directamente a QueryUser DTO sin filtrar por estado
                var result = usersInRole
                    .Select(u => new QueryUser
                    {
                        UsuarioID = u.Id,
                        Nombre = u.NombreCompleto ?? string.Empty,
                        Apellido = u.Apellido ?? string.Empty,
                        Email = u.Email ?? string.Empty,
                        Telefono = u.PhoneNumber ?? string.Empty,
                        FechaNacimiento = u.FechaDeNacimiento,
                        FechaRegistro = u.FechaDeRegistro
                    })
                    .OrderBy(u => u.Nombre)
                    .ThenBy(u => u.Apellido)
                    .ToList();

                return result;
            }
            catch (Exception ex)
            {
                throw new InvalidOperationException($"Error al obtener usuarios por el rol '{rol}'.", ex);
            }
        }
    }
}
