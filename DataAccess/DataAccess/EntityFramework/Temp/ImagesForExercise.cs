using System;
using System.Collections.Generic;

namespace DataAccess.DataAccess.EntityFramework.Temp;

public partial class ImagesForExercise
{
    public int IdImage { get; set; }

    public int FkEjercicio { get; set; }

    public string NombreParaElFront { get; set; } = null!;

    public string UrlPrivada { get; set; } = null!;

    public string UrlPublica { get; set; } = null!;

    public virtual Ejercicio FkEjercicioNavigation { get; set; } = null!;
}
