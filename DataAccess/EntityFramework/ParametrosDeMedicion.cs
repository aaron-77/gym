using System;
using System.Collections.Generic;

namespace DataAccess.EntityFramework;

public partial class ParametrosDeMedicion
{
    public int ParametroMedicionId { get; set; }

    public string? Nombre { get; set; }

    public DateTime FechaDeRegistro { get; set; }

    public DateTime? FechaModificacionDeRegistro { get; set; }

    public int? FkIcon { get; set; }

    public virtual ICollection<EjerciciosParametrosDeMedicion> EjerciciosParametrosDeMedicions { get; set; } = new List<EjerciciosParametrosDeMedicion>();

    public virtual IconsForParameter? FkIconNavigation { get; set; }

    public virtual ICollection<Medida> Medida { get; set; } = new List<Medida>();

    public virtual ICollection<Meta> Meta { get; set; } = new List<Meta>();

    public virtual ICollection<ParametrosUnidadesDeMedidum> ParametrosUnidadesDeMedida { get; set; } = new List<ParametrosUnidadesDeMedidum>();
}
