using System;
using System.Collections.Generic;

namespace DataAccess.DataAccess.EntityFramework.Temp;

public partial class EjerciciosParametrosDeMedicion
{
    public int Id { get; set; }

    public int FkEjercicio { get; set; }

    public int FkParametro { get; set; }

    public DateTime FechaCreacion { get; set; }

    public DateTime? FechaModificacion { get; set; }

    public virtual Ejercicio FkEjercicioNavigation { get; set; } = null!;

    public virtual ParametrosDeMedicion FkParametroNavigation { get; set; } = null!;
}
