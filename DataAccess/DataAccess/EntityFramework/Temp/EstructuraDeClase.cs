using System;
using System.Collections.Generic;

namespace DataAccess.DataAccess.EntityFramework.Temp;

public partial class EstructuraDeClase
{
    public int IdBloque { get; set; }

    public int FkClase { get; set; }

    public int NumeroConsecutivoDelBloque { get; set; }

    public int DuracionMenorEnMinutos { get; set; }

    public int DuracionMayorEnMinutos { get; set; }

    public string TituloBloque { get; set; } = null!;

    public string DescripcionBloque { get; set; } = null!;

    public DateTime? FechaDeCreacion { get; set; }

    public DateTime? FechaDeModificacion { get; set; }

    public virtual Clase FkClaseNavigation { get; set; } = null!;
}
