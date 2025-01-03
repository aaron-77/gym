using System;
using System.Collections.Generic;

namespace DataAccess.EntityFramework;

public partial class Cita
{
    public int CitaId { get; set; }

    public int? UsuarioId { get; set; }

    public int? EntrenadorId { get; set; }

    public DateTime FechaHora { get; set; }

    public string TipoCita { get; set; } = null!;

    public string Estado { get; set; } = null!;

    public DateTime FechaHoraFin { get; set; }

    public virtual Usuario? Entrenador { get; set; }

    public virtual Usuario? Usuario { get; set; }
}
