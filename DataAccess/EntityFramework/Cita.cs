using System;
using System.Collections.Generic;

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

    public virtual AspNetUser? Entrenador { get; set; }

    public virtual AspNetUser? User { get; set; }
}
