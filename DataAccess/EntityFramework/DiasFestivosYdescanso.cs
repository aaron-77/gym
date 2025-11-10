using System;
using System.Collections.Generic;

namespace DataAccess.EntityFramework;

public partial class DiasFestivosYdescanso
{
    public int IdDiaFestivo { get; set; }

    public DateOnly FechaFestivaOdescanso { get; set; }

    public string? Descripcion { get; set; }

    public int FkEstadoActividadLaboral { get; set; }

    public DateTime? FechaCreacion { get; set; }

    public DateTime? FcehaModificacion { get; set; }

    public virtual EstadosDeActividadLaboral FkEstadoActividadLaboralNavigation { get; set; } = null!;
}
