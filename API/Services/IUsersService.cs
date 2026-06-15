using DTO.Dtos;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace API.Services
{
    public interface IUsersService
    {
        Task<List<QueryUser>> GetUsuariosPorRolAsync(string rol);
    }
}
