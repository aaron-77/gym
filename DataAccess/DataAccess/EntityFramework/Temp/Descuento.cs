using System;
using System.Collections.Generic;

namespace DataAccess.DataAccess.EntityFramework.Temp;

public partial class Descuento
{
    public int DescuentoId { get; set; }

    public decimal Porcentaje { get; set; }

    public string? Descripcion { get; set; }

    public DateTime FechaInicio { get; set; }

    public DateTime FechaFin { get; set; }

    public virtual ICollection<Cupone> Cupones { get; set; } = new List<Cupone>();
}
