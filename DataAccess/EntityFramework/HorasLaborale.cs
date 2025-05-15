using System;
using System.Collections.Generic;

namespace DataAccess.EntityFramework;

public partial class HorasLaborale
{
    public int IdHora { get; set; }

    public TimeSpan HoraInicio { get; set; }

    public TimeSpan HoraFin { get; set; }

    public DateTime? FechaCreacion { get; set; }

    public DateTime? FechaModificacion { get; set; }

    public virtual ICollection<DiasDeLaSemanaHorasLaborale> DiasDeLaSemanaHorasLaborales { get; set; } = new List<DiasDeLaSemanaHorasLaborale>();
}
