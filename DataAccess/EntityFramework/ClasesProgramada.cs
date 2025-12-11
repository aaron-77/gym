using System;
using System.Collections.Generic;

namespace DataAccess.EntityFramework;

public partial class ClasesProgramada
{
    public int IdProgramacionClase { get; set; }

    public int FkClase { get; set; }

    public int CupoMaximo { get; set; }

    public int FkEstadoClaseProgramada { get; set; }

    public DateTime? FechaCreacion { get; set; }

    public DateTime? FechaModificacion { get; set; }

    public string? FkEntrenador { get; set; }

    public DateOnly? FechaDeLaClase { get; set; }

    

    public virtual Clase FkClaseNavigation { get; set; } = null!;

    public virtual AspNetUser? FkEntrenadorNavigation { get; set; }

    public virtual EstadosClasesProgramada FkEstadoClaseProgramadaNavigation { get; set; } = null!;

    public virtual ICollection<HorariosDeClasesProgramada> HorariosDeClasesProgramada { get; set; } = new List<HorariosDeClasesProgramada>();

    public virtual ICollection<InscripcionesDeClase> InscripcionesDeClases { get; set; } = new List<InscripcionesDeClase>();
}
