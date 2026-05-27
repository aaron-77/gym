using System;
using System.Collections.Generic;


namespace DTO.Dtos
{
    public class DetalleDeClase
    {
        public string NombreClase { get; set; }
        public string SubtituloClase { get; set; }
        public int Duracion { get; set; }
        public string NivelDeIntensidad { get; set; }
        public string NivelDeDificultad { get; set; }
        public string DescripcionDeLaClase { get; set; }
        public DTOImagenesDeClase imagenesDeClase { get; set; }
        public List<DTOBeneficiosDeClase> BeneficiosDeLaClase { get; set; }
        public List<DTOEstructuraDeClase> EstructuraDeLaClase { get; set; }
        public List<EjercicioPreview> EjerciciosDeClase { get; set; }
        public DTOConsejoDeClase Consejos { get; set; }
        public List<DTOEquipo> EquipamientoRecomendado { get; set; }
        public List<ClaseProgramada> HorariosProgramados { get; set; }
    }
}
