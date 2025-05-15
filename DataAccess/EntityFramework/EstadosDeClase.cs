using System;
using System.Collections.Generic;

namespace DataAccess.EntityFramework;

public partial class EstadosDeClase
{
    public int IdEstadoClase { get; set; }

    public string NombreEstado { get; set; } = null!;

    public string? DescripcionEstado { get; set; }

    public DateTime? FechaCreacion { get; set; }

    public DateTime? FechaModificacion { get; set; }

    public virtual ICollection<Clase> Clases { get; set; } = new List<Clase>();
}
