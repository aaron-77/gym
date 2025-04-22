using System;
using System.Collections.Generic;

namespace DataAccess.DataAccess.EntityFramework.Temp;

public partial class NivelesDeIntensidadDeClase
{
    public int IdNivelDeIntensidad { get; set; }

    public string? NombreNivelDeIntensidad { get; set; }

    public DateTime? FechaDeCreacion { get; set; }

    public virtual ICollection<Clase> Clases { get; set; } = new List<Clase>();
}
