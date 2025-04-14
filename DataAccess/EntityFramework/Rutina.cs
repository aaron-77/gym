using System;
using System.Collections.Generic;

namespace DataAccess.EntityFramework;

public partial class Rutina
{
    public int RutinaId { get; set; }

    public int? UsuarioId { get; set; }

    public int? EntrenadorId { get; set; }

    public DateTime? FechaCreacion { get; set; }

    public string? Observaciones { get; set; }

    public int? FkClase { get; set; }

    public int? FkTipoRutina { get; set; }

    public virtual Usuario? Entrenador { get; set; }

    public virtual Clase? FkClaseNavigation { get; set; }

    public virtual TipoRutina? FkTipoRutinaNavigation { get; set; }

    public virtual ICollection<RegistrosEntrenamiento> RegistrosEntrenamientos { get; set; } = new List<RegistrosEntrenamiento>();

    public virtual ICollection<RutinaEjercicio> RutinaEjercicios { get; set; } = new List<RutinaEjercicio>();

    public virtual Usuario? Usuario { get; set; }
}
