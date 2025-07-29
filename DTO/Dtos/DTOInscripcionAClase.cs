using System;
using System.ComponentModel.DataAnnotations;
namespace DTO.Dtos
{
public class DTOInscripcionAClase
{
    [Required(ErrorMessage = "El ID de la clase programada es requerido")]
    public int IdProgramacionClase { get; set; }

    [Required(ErrorMessage = "El ID del cliente es requerido")]
    public int IdCliente { get; set; }
}
}