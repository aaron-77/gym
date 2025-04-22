using System;
using System.Collections.Generic;

namespace DataAccess.DataAccess.EntityFramework.Temp;

public partial class EstadosInscripcione
{
    public int IdEstadoInscripcion { get; set; }

    public string NombreEstadoInscripcion { get; set; } = null!;

    public DateTime? FechaCreacion { get; set; }

    public DateTime? FechaModificacion { get; set; }

    public virtual ICollection<InscripcionesDeClase> InscripcionesDeClases { get; set; } = new List<InscripcionesDeClase>();
}
