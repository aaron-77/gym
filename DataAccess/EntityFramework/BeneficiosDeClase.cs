using System;
using System.Collections.Generic;

namespace DataAccess.EntityFramework;

public partial class BeneficiosDeClase
{
    public int IdBeneficio { get; set; }

    public int FkClase { get; set; }

    public string Beneficio { get; set; } = null!;

    public DateTime? FechaDeCreacion { get; set; }

    public DateTime? FechaDeModificacion { get; set; }

    public int? FkIcon { get; set; }

    public string? DescripcionBeneficio { get; set; }

    public virtual Clase FkClaseNavigation { get; set; } = null!;

    public virtual IconsForParameter? FkIconNavigation { get; set; }
}
