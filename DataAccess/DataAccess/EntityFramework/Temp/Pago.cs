using System;
using System.Collections.Generic;

namespace DataAccess.DataAccess.EntityFramework.Temp;

public partial class Pago
{
    public int PagoId { get; set; }

    public int? UsuarioId { get; set; }

    public decimal Monto { get; set; }

    public DateTime? FechaPago { get; set; }

    public string MetodoPago { get; set; } = null!;

    public string Estado { get; set; } = null!;

    public virtual Usuario? Usuario { get; set; }
}
