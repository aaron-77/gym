using System;
using System.Collections.Generic;

namespace DataAccess.EntityFramework;

public partial class ImagesForClase
{
    public int IdClassImage { get; set; }

    public int FkClase { get; set; }

    public string? UrlParaBanner { get; set; }

    public string? UrlParaParaDescripcionDeClase { get; set; }

    public string? UrlParaBloqueConsejos { get; set; }

    public DateTime FechaDeCreacion { get; set; }

    public DateTime FechaDeModificacion { get; set; }

    public virtual Clase FkClaseNavigation { get; set; } = null!;
}
