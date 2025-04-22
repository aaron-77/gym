using System;
using System.Collections.Generic;

namespace DataAccess.DataAccess.EntityFramework.Temp;

public partial class TipoRutina
{
    public int IdTipoRutina { get; set; }

    public string NombreTipoRutina { get; set; } = null!;

    public DateTime? FechaDeCreacion { get; set; }

    public DateTime? FechaDeModificacion { get; set; }

    public virtual ICollection<Rutina> Rutinas { get; set; } = new List<Rutina>();
}
