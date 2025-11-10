using System;
using System.Collections.Generic;

namespace DataAccess.EntityFramework;

public partial class IconsForParameter
{
    public int IconId { get; set; }

    public string Nombre { get; set; } = null!;

    public string UrlPrivada { get; set; } = null!;

    public string UrlPublica { get; set; } = null!;

    public virtual ICollection<BeneficiosDeClase> BeneficiosDeClases { get; set; } = new List<BeneficiosDeClase>();

    public virtual ICollection<Ejercicio> Ejercicios { get; set; } = new List<Ejercicio>();

    public virtual ICollection<Equipo> Equipos { get; set; } = new List<Equipo>();

    public virtual ICollection<ParametrosDeMedicion> ParametrosDeMedicions { get; set; } = new List<ParametrosDeMedicion>();
}
