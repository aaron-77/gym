using System;
using System.Collections.Generic;

namespace DataAccess.DataAccess.EntityFramework.Temp;

public partial class ParametrosUnidadesDeMedidum
{
    public int FkParametroDeMedicion { get; set; }

    public int FkUnidadDeMedida { get; set; }

    public DateTime FechaDeRegistro { get; set; }

    public virtual ParametrosDeMedicion FkParametroDeMedicionNavigation { get; set; } = null!;

    public virtual UnidadesDeMedidum FkUnidadDeMedidaNavigation { get; set; } = null!;
}
