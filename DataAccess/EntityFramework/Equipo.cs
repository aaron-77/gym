using System;
using System.Collections.Generic;

namespace DataAccess.EntityFramework;

public partial class Equipo
{
    public int EquipoId { get; set; }

    public string NombreEquipo { get; set; } = null!;

    public string? Descripcion { get; set; }

    public int? FkIcon { get; set; }

    public virtual ICollection<EjercicioEquipo> EjercicioEquipos { get; set; } = new List<EjercicioEquipo>();

    public virtual IconsForParameter? FkIconNavigation { get; set; }
}
