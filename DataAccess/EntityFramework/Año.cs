using System;
using System.Collections.Generic;

namespace DataAccess.EntityFramework;

public partial class Año
{
    public int IdAño { get; set; }

    public int Año1 { get; set; }

    public DateTime? FechaCreacion { get; set; }

    public DateTime? FechaModificacion { get; set; }

    public virtual ICollection<DiasDeLaSemanaHorasLaborale> DiasDeLaSemanaHorasLaborales { get; set; } = new List<DiasDeLaSemanaHorasLaborale>();
}
