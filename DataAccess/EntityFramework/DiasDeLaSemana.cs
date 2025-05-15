using System;
using System.Collections.Generic;

namespace DataAccess.EntityFramework;

public partial class DiasDeLaSemana
{
    public int IdDia { get; set; }

    public string NombreDia { get; set; } = null!;

    public DateTime? FechaCreacion { get; set; }

    public DateTime? FechaModificacion { get; set; }

    public bool? Activo { get; set; }

    public virtual ICollection<DiasDeLaSemanaHorasLaborale> DiasDeLaSemanaHorasLaborales { get; set; } = new List<DiasDeLaSemanaHorasLaborale>();
}
