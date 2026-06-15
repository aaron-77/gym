using DataAccess.Repositories;
using DTO.Dtos;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace API.Services
{
    public class ClasesService : IClasesService
    {
        private readonly IClasesRepository _clasesRepository;
        private readonly IUsersService _usersService;

        public ClasesService(
            IClasesRepository clasesRepository,
            IUsersService usersService)
        {
            _clasesRepository = clasesRepository;
            _usersService = usersService;
        }

        public async Task<List<DTODificultad>> GetNivelesDeDificultadAsync()
        {
            try
            {
                var result = await _clasesRepository.GetNivelesDeDificultadAsync();
                return result.Select(n => new DTODificultad
                {
                    Id = n.IdNivelDeDificultadDeClase,
                    Nombre = n.NombreNivelDeDificultad
                }).ToList();
            }
            catch (Exception ex)
            {
                throw new InvalidOperationException("Error en ClasesService al obtener niveles de dificultad.", ex);
            }
        }

        public async Task<List<DTOIntensidad>> GetNivelesDeIntensidadAsync()
        {
            try
            {
                var result = await _clasesRepository.GetNivelesDeIntensidadAsync();
                return result.Select(n => new DTOIntensidad
                {
                    Id = n.IdNivelDeIntensidad,
                    Nombre = n.NombreNivelDeIntensidad ?? "N/A"
                }).ToList();
            }
            catch (Exception ex)
            {
                throw new InvalidOperationException("Error en ClasesService al obtener niveles de intensidad.", ex);
            }
        }

        public async Task<List<QueryUser>> GetInstructoresAsync()
        {
            try
            {
                return await _usersService.GetUsuariosPorRolAsync("empleado");
            }
            catch (Exception ex)
            {
                throw new InvalidOperationException("Error en ClasesService al obtener los instructores.", ex);
            }
        }

        public async Task<List<DTOClasePreview>> GetPreviewDeClasesAsync()
        {
            try
            {
                var result = await _clasesRepository.GetPreviewDeClasesAsync();
                return result.Select(c => new DTOClasePreview
                {
                    idClase = c.ClaseId,
                    nombreClase = c.NombreClase,
                    descripcionCortaClase = c.Descripcion ?? string.Empty,
                    urlImage = c.ImagesForClases
                        .FirstOrDefault(i => i.UrlParaBanner != null)?.UrlParaBanner ?? string.Empty
                }).ToList();
            }
            catch (Exception ex)
            {
                throw new InvalidOperationException("Error en ClasesService al obtener preview de clases.", ex);
            }
        }
    }
}
