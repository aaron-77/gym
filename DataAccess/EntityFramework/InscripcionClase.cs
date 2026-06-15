using System;
using System.Collections.Generic;
using DataAccess.Identity;

namespace DataAccess.EntityFramework;

public partial class InscripcionClase
{
    public int InscripcionId { get; set; }


    public int? ClaseId { get; set; }

    public string? NewFkCliente { get; set; }
    public int? UsuarioId { get; set; }

    public DateTime? FechaInscripcion { get; set; }

    public string Estado { get; set; } = null!;

    public virtual Clase? Clase { get; set; }

    public virtual ApplicationUser? Usuario { get; set; }
}
