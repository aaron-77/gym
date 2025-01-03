using System;
using System.Collections.Generic;

namespace DataAccess.EntityFramework;

public partial class InscripcionClase
{
    public int InscripcionId { get; set; }

    public int? ClaseId { get; set; }

    public int? UsuarioId { get; set; }

    public DateTime? FechaInscripcion { get; set; }

    public string Estado { get; set; } = null!;

    public virtual Clase? Clase { get; set; }

    public virtual Usuario? Usuario { get; set; }
}
