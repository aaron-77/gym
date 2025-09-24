using System;
using System.Collections.Generic;
using DataAccess.Identity;

namespace DataAccess.EntityFramework;

public partial class HorariosDeClasesProgramada
{
    public int IdHorarioDeClaseProgramada { get; set; }

    public int FkClaseProgramada { get; set; }

    public int FkHorarioLaboral { get; set; }

    public int FkEstadoHorarioClase { get; set; }

    public DateOnly? FechaDeLaClase { get; set; }

    public string? FkEntrenador { get; set; }

    public virtual ClasesProgramada FkClaseProgramadaNavigation { get; set; } = null!;

    public virtual ApplicationUser? FkEntrenadorNavigation { get; set; }

    public virtual EstadosHorarioClaseProgramadum FkEstadoHorarioClaseNavigation { get; set; } = null!;

    public virtual HorasLaborale FkHorarioLaboralNavigation { get; set; } = null!;
}
