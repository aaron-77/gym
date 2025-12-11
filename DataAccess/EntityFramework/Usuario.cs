using System;
using System.Collections.Generic;

namespace DataAccess.EntityFramework;

public partial class Usuario
{
    public int UsuarioId { get; set; }

    public string Nombre { get; set; } = null!;

    public string Apellido { get; set; } = null!;

    public string Email { get; set; } = null!;

    public string Telefono { get; set; } = null!;

    public string NombreUsuario { get; set; } = null!;

    public string Contrasena { get; set; } = null!;

    public DateOnly FechaNacimiento { get; set; }

    public DateTime? FechaRegistro { get; set; }

    public int? RolId { get; set; }

    public string Estado { get; set; } = null!;

    public virtual Role? Rol { get; set; }
}
