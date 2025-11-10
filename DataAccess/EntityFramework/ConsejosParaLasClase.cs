using System;
using System.Collections.Generic;

namespace DataAccess.EntityFramework;

public partial class ConsejosParaLasClase
{
    public int IdConsejo { get; set; }

    public int? FkClase { get; set; }

    public int? FkEjercicio { get; set; }

    public string IntroduccionDeConsejo { get; set; } = null!;

    public string Consejos { get; set; } = null!;

    public virtual Clase? FkClaseNavigation { get; set; }

    public virtual Ejercicio? FkEjercicioNavigation { get; set; }
}
