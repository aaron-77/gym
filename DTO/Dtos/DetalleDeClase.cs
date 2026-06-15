using System;
using System.Collections.Generic;
using System.Text.Json;
using DTO.Constants;

namespace DTO.Dtos
{
    public class DetalleDeClase
    {
        public string NombreClase { get; set; }
        public string? SubtituloClase { get; set; }
        public int Duracion { get; set; }
        public string NivelDeIntensidad { get; set; }
        public string NivelDeDificultad { get; set; }
        public string DescripcionDeLaClase { get; set; }
        public DTOImagenesDeClase? imagenesDeClase { get; set; }
        public List<DTOBeneficiosDeClase> BeneficiosDeLaClase { get; set; }
        public List<DTOEstructuraDeClase> EstructuraDeLaClase { get; set; }
        public List<EjercicioPreview> EjerciciosDeClase { get; set; }
        public DTOConsejoDeClase? Consejos { get; set; }
        public List<DTOEquipo> EquipamientoRecomendado { get; set; }
        public List<ClaseProgramada> HorariosProgramados { get; set; }

        public static DetalleDeClase FromRaw(DetalleDeClaseRaw raw)
        {
            var options = new JsonSerializerOptions
            {
                PropertyNameCaseInsensitive = true,
            };

            return new DetalleDeClase
            {
                NombreClase = raw.NombreClase!,
                SubtituloClase = raw.SubtituloClase,
                Duracion = raw.Duracion ?? DetalleDeClaseDefaults.DuracionEnMinutos,
                NivelDeIntensidad = raw.NivelDeIntensidad!,
                NivelDeDificultad = raw.NivelDeDificultad!,
                DescripcionDeLaClase = raw.DescripcionDeLaClase ?? DetalleDeClaseDefaults.DescripcionDeLaClase,
                imagenesDeClase = !string.IsNullOrEmpty(raw.imagenesDeClase)
                    ? JsonSerializer.Deserialize<List<DTOImagenesDeClase>>(
                        raw.imagenesDeClase, options)?.FirstOrDefault()
                    : null,
                BeneficiosDeLaClase = !string.IsNullOrEmpty(raw.BeneficiosDeLaClase)
                    ? JsonSerializer.Deserialize<List<DTOBeneficiosDeClase>>(
                        raw.BeneficiosDeLaClase, options)
                    : new List<DTOBeneficiosDeClase>(),
                EstructuraDeLaClase = !string.IsNullOrEmpty(raw.EstructuraDeLaClase)
                    ? JsonSerializer.Deserialize<List<DTOEstructuraDeClase>>(
                        raw.EstructuraDeLaClase, options)
                    : new List<DTOEstructuraDeClase>(),
                EjerciciosDeClase = !string.IsNullOrEmpty(raw.EjerciciosDeClase)
                    ? JsonSerializer.Deserialize<List<EjercicioPreview>>(
                        raw.EjerciciosDeClase, options)
                    : new List<EjercicioPreview>(),
                Consejos = !string.IsNullOrEmpty(raw.Consejos)
                    ? JsonSerializer.Deserialize<List<DTOConsejoDeClase>>(
                        raw.Consejos, options)?.FirstOrDefault()
                    : null,
                EquipamientoRecomendado = !string.IsNullOrEmpty(raw.EquipamientoRecomendado)
                    ? JsonSerializer.Deserialize<List<DTOEquipo>>(
                        raw.EquipamientoRecomendado, options)
                    : new List<DTOEquipo>(),
                HorariosProgramados = !string.IsNullOrEmpty(raw.HorariosProgramados)
                    ? JsonSerializer.Deserialize<List<ClaseProgramada>>(
                        raw.HorariosProgramados, options)
                    : new List<ClaseProgramada>(),
            };
        }
    }
}
