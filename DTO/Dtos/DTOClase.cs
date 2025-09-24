using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
namespace DTO.Dtos
{
        public class DTOClase
        {
            public int ClaseID { get; set; }
            [Required]
            public string NombreClase { get; set; }
            public string? InstructorId { get; set; }
            public int Cupo { get; set; }
            [Required]
            public string Descripcion { get; set; }
            [Required]
            public int DuracionEnMinutos { get; set; }  
            [Required]
            public int? FkIntensidad { get; set; }
            [Required]
            public int? FkDificultad { get; set; }
            [Required]
            public int TiempoDeDescansoEnMinutos { get; set; } = 15;
            [Required]
            public int DuracionEnMinutosConDescansoIncluido { get; set; }
            public int? FkEstadoClase { get; set; } = 1; // Por defecto Activa (1)
        }
} 