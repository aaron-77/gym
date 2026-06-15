using System;
using System.Collections.Generic;

namespace DataAccess.EntityFramework;

public partial class TiposDeRecurrenciaDeDiasFestivo
{
    public int IdTipoDeRecurrenciaDeDiaFestivo { get; set; }

    public string NombreTipoDeRecurrencia { get; set; } = null!;

    public string? Descripcion { get; set; }

    public DateTime FechaCreacion { get; set; }

    public DateTime? FechaModificacion { get; set; }

    public virtual ICollection<DiasFestivosVariable> DiasFestivosVariables { get; set; } = new List<DiasFestivosVariable>();
}
