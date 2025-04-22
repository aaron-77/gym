using System;
using System.Collections.Generic;

namespace DataAccess.DataAccess.EntityFramework.Temp;

public partial class Meta
{
    public int MetaId { get; set; }

    public int FkUsuario { get; set; }

    public int FkIntencion { get; set; }

    public int FkParametro { get; set; }

    public int? FkEjercicio { get; set; }

    public decimal ValorObjetivo { get; set; }

    public DateTime FechaDeInicioDeLaMeta { get; set; }

    public DateTime FechaLimite { get; set; }

    public DateTime FechaDeRegistro { get; set; }

    public DateTime? FechaDeModificacionDeRegistro { get; set; }

    public int FkNivelDeLogro { get; set; }

    public virtual Ejercicio? FkEjercicioNavigation { get; set; }

    public virtual Intencione FkIntencionNavigation { get; set; } = null!;

    public virtual NivelesDeLogro FkNivelDeLogroNavigation { get; set; } = null!;

    public virtual ParametrosDeMedicion FkParametroNavigation { get; set; } = null!;

    public virtual Usuario FkUsuarioNavigation { get; set; } = null!;
}
