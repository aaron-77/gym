using System;
using System.Collections.Generic;
using DataAccess.Identity;

namespace DataAccess.EntityFramework;

public partial class Medida
{
    public int MedidaId { get; set; }

    public DateTime? FechaDeCreacion { get; set; }

    public int? FkParametro { get; set; }

    public decimal? Valor { get; set; }

    public int? FkEjercicio { get; set; }

    public string? FkUsuario { get; set; }

    public virtual Ejercicio? FkEjercicioNavigation { get; set; }

    public virtual ParametrosDeMedicion? FkParametroNavigation { get; set; }

    public virtual ApplicationUser? FkUsuarioNavigation { get; set; }
}
