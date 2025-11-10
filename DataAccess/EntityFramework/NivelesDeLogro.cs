using System;
using System.Collections.Generic;

namespace DataAccess.EntityFramework;

public partial class NivelesDeLogro
{
    public int IdNivelDeLogro { get; set; }

    public string? Nombre { get; set; }

    public DateTime FechaDeRegistro { get; set; }

    public DateTime? FechaModificacionDeRegistro { get; set; }

    public virtual ICollection<Meta> Meta { get; set; } = new List<Meta>();
}
