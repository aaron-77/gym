using System;
using System.Collections.Generic;

namespace DataAccess.EntityFramework;

public partial class HorariosDeClasesProgramada
{
    public int IdHorarioDeClaseProgramada { get; set; }

    public int FkClaseProgramada { get; set; }

    public int FkHorarioLaboral { get; set; }

    public int FkEstadoHorarioClase { get; set; }

    public virtual ClasesProgramada FkClaseProgramadaNavigation { get; set; } = null!;

    public virtual EstadosHorarioClaseProgramadum FkEstadoHorarioClaseNavigation { get; set; } = null!;

    public virtual HorasLaborale FkHorarioLaboralNavigation { get; set; } = null!;
}
