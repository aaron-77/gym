using System;
using System.Collections.Generic;

namespace DataAccess.EntityFramework;

public partial class EstadosDeActividadLaboral
{
    public int IdEstadoActividadLaboral { get; set; }

    public string? NombreEstadoActividadLaboral { get; set; }

    public DateTime? FechaCreacion { get; set; }

    public DateTime? FcehaModificacion { get; set; }

    public virtual ICollection<DiasFestivosVariable> DiasFestivosVariables { get; set; } = new List<DiasFestivosVariable>();

    public virtual ICollection<DiasFestivosYdescanso> DiasFestivosYdescansos { get; set; } = new List<DiasFestivosYdescanso>();
}
