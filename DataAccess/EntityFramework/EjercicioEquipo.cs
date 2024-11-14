using System;
using System.Collections.Generic;

namespace DataAccess.EntityFramework;

public partial class EjercicioEquipo
{
    public int EjercicioEquipoId { get; set; }

    public int? EjercicioId { get; set; }

    public int? EquipoId { get; set; }

    public virtual Ejercicio? Ejercicio { get; set; }

    public virtual Equipo? Equipo { get; set; }
}
