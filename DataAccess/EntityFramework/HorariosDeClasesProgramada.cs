using System;
using System.Collections.Generic;

namespace DataAccess.EntityFramework;

public partial class HorariosDeClasesProgramada
{
    public int IdHorarioDeClaseProgramada { get; set; }

    public int FkClaseProgramada { get; set; }

    public int FkHorarioLaboral { get; set; }

    public virtual ClasesProgramada FkClaseProgramadaNavigation { get; set; } = null!;

    public virtual DiasDeLaSemanaHorasLaborale FkHorarioLaboralNavigation { get; set; } = null!;

    public virtual ICollection<PreReservasDeHorario> PreReservasDeHorarios { get; set; } = new List<PreReservasDeHorario>();
}
