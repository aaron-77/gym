using System;
using System.Collections.Generic;

namespace DataAccess.DataAccess.EntityFramework.Temp;

public partial class UnidadesDeMedidum
{
    public int UnidadDeMedidaId { get; set; }

    public string? Nombre { get; set; }

    public DateTime FechaDeRegistro { get; set; }

    public DateTime? FechaModificacionDeRegistro { get; set; }

    public virtual ICollection<ParametrosUnidadesDeMedidum> ParametrosUnidadesDeMedida { get; set; } = new List<ParametrosUnidadesDeMedidum>();
}
