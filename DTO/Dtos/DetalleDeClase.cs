using System;
using System.Collections.Generic;


namespace DTO.Dtos
{
    public class DetalleDeClase
    {
        public int Duracion { get; set; }
        public string NivelDeIntensidad { get; set; }
        public string NivelDeDificultad { get; set; }
        public string DescripcionDeLaClase { get; set; }
        public List<string> BeneficiosDeLaClase { get; set; }
        public List<EstructuraDeClase> EstructuraDeLaClase { get; set; }
        public List<EjercicioPreview> EjerciciosDeClase { get; set; }
        public DTOConsejoDeClase Consejos { get; set; }
        public List<DTOEquipo> EquipamientoRecomendado { get; set; }
        public List<ClaseProgramada> HorariosProgramados { get; set; }
    }
}
