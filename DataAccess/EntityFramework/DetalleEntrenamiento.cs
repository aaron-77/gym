using System;
using System.Collections.Generic;

namespace DataAccess.EntityFramework;

public partial class DetalleEntrenamiento
{
    public int DetalleId { get; set; }

    public int? RegistroId { get; set; }

    public int? EjercicioId { get; set; }

    public int? Sets { get; set; }

    public int? Repeticiones { get; set; }

    public decimal? Peso { get; set; }

    public int? Tiempo { get; set; }

    public virtual Ejercicio? Ejercicio { get; set; }

    public virtual RegistrosEntrenamiento? Registro { get; set; }
}
