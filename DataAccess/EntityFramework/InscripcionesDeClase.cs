using System;
using System.Collections.Generic;

namespace DataAccess.EntityFramework;

public partial class InscripcionesDeClase
{
    public int IdInscripcion { get; set; }

    public int FkProgramacionClase { get; set; }

    public DateTime? FechaDeInscripcion { get; set; }

    public int FkEstadoInscripcion { get; set; }

    public string? FkCliente { get; set; }

    public virtual AspNetUser? FkClienteNavigation { get; set; }

    public virtual EstadosInscripcione FkEstadoInscripcionNavigation { get; set; } = null!;

    public virtual ClasesProgramada FkProgramacionClaseNavigation { get; set; } = null!;
}
