using System;
using System.Collections.Generic;

namespace DataAccess.EntityFramework;

public partial class Cupone
{
    public int CuponId { get; set; }

    public string Codigo { get; set; } = null!;

    public int? DescuentoId { get; set; }

    public DateTime FechaExpiracion { get; set; }

    public string Estado { get; set; } = null!;

    public virtual Descuento? Descuento { get; set; }
}
