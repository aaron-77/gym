using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DTO.Dtos
{
    public class AsignacionDeEjercicio
    {


        [Required(ErrorMessage = "Tienes que seleccionar un cliente")]
        public string UsuarioID { get; set; }

        [Range(1, int.MaxValue, ErrorMessage = "Selecciona una rutina")]
        public int RutinaId { get; set; }
        [Range(1, int.MaxValue, ErrorMessage = "Selecciona un ejercicio")]
        public int EjercicioID { get; set; }
        [Range(1, int.MaxValue, ErrorMessage = "Ingresa los sets")]
        public int Sets { get; set; }
        [Range(0, int.MaxValue, ErrorMessage = "Ingresa el peso")]
        public int Repeticiones { get; set; }
        [Range(0, int.MaxValue, ErrorMessage = "Ingresa las repeticiones")]
        public decimal Peso { get; set; }
        [Range(0, int.MaxValue, ErrorMessage = "Ingresa el tiempo")]
        public int Tiempo { get; set; }
        [Range(0, int.MaxValue, ErrorMessage = "Ingresa las metarepeticiones")]
        public int MetaRepeticiones { get; set; }
    }
}
