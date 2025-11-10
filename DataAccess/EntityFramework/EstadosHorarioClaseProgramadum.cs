using System;
using System.Collections.Generic;

namespace DataAccess.EntityFramework;

public partial class EstadosHorarioClaseProgramadum
{
    public int IdEstadoHorarioClase { get; set; }

    public string? NombreEstadoHorario { get; set; }

    public DateTime? FechaCreacion { get; set; }

    public DateTime? FechaModificacion { get; set; }

    public virtual ICollection<HorariosDeClasesProgramada> HorariosDeClasesProgramada { get; set; } = new List<HorariosDeClasesProgramada>();
}
