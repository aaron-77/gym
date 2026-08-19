using System;
using System.ComponentModel.DataAnnotations;

namespace DTO.Dtos
{
    public class DTOPreReservaDeHorarioInscripcion
    {
        [Required(ErrorMessage = "El usuario que reserva es requerido")]
        [StringLength(36, MinimumLength = 36, ErrorMessage = "El ID de usuario debe tener exactamente 36 caracteres (GUID)")]
        public string? idUsuarioQueReserva { get; set; }

        [Required(ErrorMessage = "La fecha tentativa es requerida")]
        [DataType(DataType.Date, ErrorMessage = "La fecha tentativa no tiene un formato válido")]
        public DateOnly fechaTentativa { get; set; }

        [Required(ErrorMessage = "El horario laboral es requerido")]
        [Range(1, int.MaxValue, ErrorMessage = "El ID del horario laboral debe ser mayor a 0")]
        public int idHoraLaboral { get; set; }

        [Range(1, int.MaxValue, ErrorMessage = "El ID de la clase debe ser mayor a 0")]
        public int? idClase { get; set; }

        [StringLength(36, MinimumLength = 36, ErrorMessage = "El ID del entrenador debe tener exactamente 36 caracteres (GUID)")]
        public string? idEntrenador { get; set; }

        [Required(ErrorMessage = "La clase programada es requerida")]
        [Range(1, int.MaxValue, ErrorMessage = "El ID de la clase programada debe ser mayor a 0")]
        public int idClaseProgramada { get; set; }
    }
}
