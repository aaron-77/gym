using System;
using System.Collections.Generic;

namespace DataAccess.DataAccess.EntityFramework.Temp;

public partial class ClasesProgramada
{
    public int IdProgramacionClase { get; set; }

    public int FkClase { get; set; }

    public DateTime FechaInicio { get; set; }

    public DateTime FechaFin { get; set; }

    public int FkEntrenador { get; set; }

    public int CupoMaximo { get; set; }

    /// <summary>
    /// los estados seran: disponible,no disponible,cancelada
    /// </summary>
    public int FkEstadoClaseProgramada { get; set; }

    public DateTime? FechaCreacion { get; set; }

    public DateTime? FechaModificacion { get; set; }

    public virtual Clase FkClaseNavigation { get; set; } = null!;

    public virtual Usuario FkEntrenadorNavigation { get; set; } = null!;

    public virtual EstadosClasesProgramada FkEstadoClaseProgramadaNavigation { get; set; } = null!;

    public virtual ICollection<InscripcionesDeClase> InscripcionesDeClases { get; set; } = new List<InscripcionesDeClase>();
}
