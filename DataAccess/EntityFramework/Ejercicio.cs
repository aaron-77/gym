using System;
using System.Collections.Generic;

namespace DataAccess.EntityFramework;

public partial class Ejercicio
{
    public int EjercicioId { get; set; }

    public string NombreEjercicio { get; set; } = null!;

    public string TipoEjercicio { get; set; } = null!;

    public string? Descripcion { get; set; }

    public virtual ICollection<DetalleEntrenamiento> DetalleEntrenamientos { get; set; } = new List<DetalleEntrenamiento>();

    public virtual ICollection<EjercicioEquipo> EjercicioEquipos { get; set; } = new List<EjercicioEquipo>();

    public virtual ICollection<Meta> Meta { get; set; } = new List<Meta>();

    public virtual ICollection<RutinaEjercicio> RutinaEjercicios { get; set; } = new List<RutinaEjercicio>();
}
