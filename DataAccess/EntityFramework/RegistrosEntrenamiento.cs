using DataAccess.Identity;
using System;
using System.Collections.Generic;

namespace DataAccess.EntityFramework;

public partial class RegistrosEntrenamiento
{
    public int RegistroId { get; set; }

    public int? RutinaId { get; set; }

    public DateTime? FechaRegistro { get; set; }

    public string? UserId { get; set; }

    public virtual ICollection<DetalleEntrenamiento> DetalleEntrenamientos { get; set; } = new List<DetalleEntrenamiento>();

    public virtual Rutina? Rutina { get; set; }

    public virtual ApplicationUser? User { get; set; }
}
