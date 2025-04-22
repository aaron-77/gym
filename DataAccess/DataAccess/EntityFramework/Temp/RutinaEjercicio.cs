using System;
using System.Collections.Generic;

namespace DataAccess.DataAccess.EntityFramework.Temp;

public partial class RutinaEjercicio
{
    public int RutinaEjercicioId { get; set; }

    public int? RutinaId { get; set; }

    public int? EjercicioId { get; set; }

    public int? Sets { get; set; }

    public int? Repeticiones { get; set; }

    public decimal? Peso { get; set; }

    public int? Tiempo { get; set; }

    public int? MetaRepeticiones { get; set; }

    public virtual Ejercicio? Ejercicio { get; set; }

    public virtual Rutina? Rutina { get; set; }
}
