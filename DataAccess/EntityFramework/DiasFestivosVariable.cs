using System;
using System.Collections.Generic;

namespace DataAccess.EntityFramework;

public partial class DiasFestivosVariable
{
    public int IdDiaFestivoVariable { get; set; }

    public string NombreDiasFestivoVariable { get; set; } = null!;

    public int? DeQueSemana { get; set; }

    public int? DeQueMes { get; set; }

    public int DeQueDia { get; set; }

    public DateTime FechaCreacion { get; set; }

    public DateTime? FechaModificacion { get; set; }

    public int FkTipoDeRecurrenciaDelFestivo { get; set; }

    public int FkEstadoActividadLaboral { get; set; }

    public virtual EstadosDeActividadLaboral FkEstadoActividadLaboralNavigation { get; set; } = null!;

    public virtual TiposDeRecurrenciaDeDiasFestivo FkTipoDeRecurrenciaDelFestivoNavigation { get; set; } = null!;
}
