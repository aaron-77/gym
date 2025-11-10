using System;
using System.Collections.Generic;

namespace DataAccess.EntityFramework;

public partial class DiasDeLaSemanaHorasLaborale
{
    public int IdHorarioLaboral { get; set; }

    public int FkDiaDeLaSemana { get; set; }

    public int FkHoraLaboral { get; set; }

    public int FkAño { get; set; }

    public virtual Año FkAñoNavigation { get; set; } = null!;

    public virtual DiasDeLaSemana FkDiaDeLaSemanaNavigation { get; set; } = null!;

    public virtual HorasLaborale FkHoraLaboralNavigation { get; set; } = null!;

    public virtual ICollection<HorariosDeClasesProgramada> HorariosDeClasesProgramada { get; set; } = new List<HorariosDeClasesProgramada>();
}
