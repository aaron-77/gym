using System;
using System.Collections.Generic;

namespace DataAccess.DataAccess.EntityFramework.Temp;

public partial class Medida
{
    public int MedidaId { get; set; }

    public int FkUsuario { get; set; }

    public DateTime? FechaDeCreacion { get; set; }

    public int? FkParametro { get; set; }

    public decimal? Valor { get; set; }

    public int? FkEjercicio { get; set; }

    public virtual Ejercicio? FkEjercicioNavigation { get; set; }

    public virtual ParametrosDeMedicion? FkParametroNavigation { get; set; }

    public virtual Usuario FkUsuarioNavigation { get; set; } = null!;
}
