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

    public DateTime FechaNacimiento { get; set; }

    public DateTime? FechaRegistro { get; set; }

    public int? RolId { get; set; }

    public string Estado { get; set; } = null!;

    public virtual ICollection<Cita> CitaEntrenadors { get; set; } = new List<Cita>();

    public virtual ICollection<Cita> CitaUsuarios { get; set; } = new List<Cita>();

    public virtual ICollection<Clase> Clases { get; set; } = new List<Clase>();

    public virtual ICollection<InscripcionClase> InscripcionClases { get; set; } = new List<InscripcionClase>();

    public virtual ICollection<Medida> Medida { get; set; } = new List<Medida>();

    public virtual ICollection<Meta> Meta { get; set; } = new List<Meta>();

    public virtual ICollection<Pago> Pagos { get; set; } = new List<Pago>();

    public virtual ICollection<RegistrosEntrenamiento> RegistrosEntrenamientos { get; set; } = new List<RegistrosEntrenamiento>();

    public virtual Role? Rol { get; set; }

    public virtual ICollection<Rutina> RutinaEntrenadors { get; set; } = new List<Rutina>();

    public virtual ICollection<Rutina> RutinaUsuarios { get; set; } = new List<Rutina>();
}
