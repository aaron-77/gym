using System;
using System.Collections.Generic;

namespace DataAccess.EntityFramework;

public partial class HorasLaborale
{
    public int IdHora { get; set; }

    public TimeOnly HoraInicio { get; set; }

    public TimeOnly HoraFin { get; set; }

    public DateTime? FechaCreacion { get; set; }

    public DateTime? FechaModificacion { get; set; }

    public virtual ICollection<HorariosDeClasesProgramada> HorariosDeClasesProgramada { get; set; } = new List<HorariosDeClasesProgramada>();

    public virtual ICollection<PreReservasDeHorario> PreReservasDeHorarios { get; set; } = new List<PreReservasDeHorario>();
}
