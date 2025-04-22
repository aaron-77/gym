using System;
using System.Collections.Generic;

namespace DataAccess.DataAccess.EntityFramework.Temp;

public partial class EstadosClasesProgramada
{
    public int IdEstadoClaseProgramada { get; set; }

    public string NombresEstado { get; set; } = null!;

    public DateTime? FechaCreacion { get; set; }

    public DateTime? FechaModificacion { get; set; }

    public virtual ICollection<ClasesProgramada> ClasesProgramada { get; set; } = new List<ClasesProgramada>();
}
