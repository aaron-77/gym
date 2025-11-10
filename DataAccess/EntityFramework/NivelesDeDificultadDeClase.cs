using System;
using System.Collections.Generic;

namespace DataAccess.EntityFramework;

public partial class NivelesDeDificultadDeClase
{
    public int IdNivelDeDificultadDeClase { get; set; }

    public string NombreNivelDeDificultad { get; set; } = null!;

    public DateTime? FechaDeCreacion { get; set; }

    public DateTime? FechaDeModificacion { get; set; }

    public virtual ICollection<Clase> Clases { get; set; } = new List<Clase>();
}
