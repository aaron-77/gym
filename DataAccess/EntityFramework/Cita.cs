using System;
using System.Collections.Generic;
using DataAccess.Identity;

namespace DataAccess.EntityFramework;

public partial class Cita
{
    public int CitaId { get; set; }

    public DateTime FechaHora { get; set; }

    public string TipoCita { get; set; } = null!;

    public string Estado { get; set; } = null!;

    public DateTime FechaHoraFin { get; set; }

    public string? EntrenadorId { get; set; }

    public string? UserId { get; set; }

    public virtual ApplicationUser? Entrenador { get; set; }

    public virtual ApplicationUser? User { get; set; }
}
