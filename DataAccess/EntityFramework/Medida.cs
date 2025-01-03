using System;
using System.Collections.Generic;

namespace DataAccess.EntityFramework;

public partial class Medida
{
    public int? MedidaId { get; set; }

    public int FkUsuario { get; set; }

    public DateTime? FechaDeCreacion { get; set; }

    public int? FkParametro { get; set; }

    public decimal? Valor { get; set; }

    public virtual ParametrosDeMedicion? FkParametroNavigation { get; set; }

    public virtual Usuario FkUsuarioNavigation { get; set; } = null!;
}
