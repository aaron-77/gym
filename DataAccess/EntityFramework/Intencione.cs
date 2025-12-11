using System;
using System.Collections.Generic;

namespace DataAccess.EntityFramework;

public partial class Intencione
{
    public int IntencionId { get; set; }

    public string Nombre { get; set; } = null!;

    public DateTime FechaDeRegistro { get; set; }

    public DateTime? FechaModificacionDeRegistro { get; set; }

    public virtual ICollection<Meta> Meta { get; set; } = new List<Meta>();
}
