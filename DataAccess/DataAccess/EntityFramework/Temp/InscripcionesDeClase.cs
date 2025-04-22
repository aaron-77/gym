using System;
using System.Collections.Generic;

namespace DataAccess.DataAccess.EntityFramework.Temp;

public partial class InscripcionesDeClase
{
    public int IdInscripcion { get; set; }

    public int FkCliente { get; set; }

    public int FkProgramacionClase { get; set; }

    public DateTime? FechaDeInscripcion { get; set; }

    public int FkEstadoInscripcion { get; set; }

    public virtual Usuario FkClienteNavigation { get; set; } = null!;

    public virtual EstadosInscripcione FkEstadoInscripcionNavigation { get; set; } = null!;

    public virtual ClasesProgramada FkProgramacionClaseNavigation { get; set; } = null!;
}
