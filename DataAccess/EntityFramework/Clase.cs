using DataAccess.Identity;
using System;
using System.Collections.Generic;

namespace DataAccess.EntityFramework;

public partial class Clase
{
    public int ClaseId { get; set; }

    public string NombreClase { get; set; } = null!;
    public string? SubtituloClase {get; set;} 

    public int Cupo { get; set; }

    public string? Descripcion { get; set; }

    public int? DuracionEnMinutos { get; set; }

    public int? FkIntensidad { get; set; }

    public int? FkDificultad { get; set; }

    public int TiempoDeDescansoEnMinutos { get; set; }

    public int DuracionEnMinutosConDescansoIncluido { get; set; }

    public int? FkEstadoClase { get; set; }

    public string? InstructorId { get; set; }

    public virtual ICollection<BeneficiosDeClase> BeneficiosDeClases { get; set; } = new List<BeneficiosDeClase>();

    public virtual ICollection<ClasesProgramada> ClasesProgramada { get; set; } = new List<ClasesProgramada>();

    public virtual ICollection<ConsejosParaLasClase> ConsejosParaLasClases { get; set; } = new List<ConsejosParaLasClase>();

    public virtual ICollection<EstructuraDeClase> EstructuraDeClases { get; set; } = new List<EstructuraDeClase>();

    public virtual NivelesDeDificultadDeClase? FkDificultadNavigation { get; set; }

    public virtual EstadosDeClase? FkEstadoClaseNavigation { get; set; }

    public virtual NivelesDeIntensidadDeClase? FkIntensidadNavigation { get; set; }

    public virtual ICollection<ImagesForClase> ImagesForClases { get; set; } = new List<ImagesForClase>();

    public virtual ApplicationUser? Instructor { get; set; }

    public virtual ICollection<Rutina> Rutinas { get; set; } = new List<Rutina>();
}
