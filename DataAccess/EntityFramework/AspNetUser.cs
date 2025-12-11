using System;
using System.Collections.Generic;

namespace DataAccess.EntityFramework;

public partial class AspNetUser
{
    public string Id { get; set; } = null!;

    public string NombreCompleto { get; set; } = null!;

    public string? UserName { get; set; }

    public string? NormalizedUserName { get; set; }

    public string? Email { get; set; }

    public string? NormalizedEmail { get; set; }

    public bool EmailConfirmed { get; set; }

    public string? PasswordHash { get; set; }

    public string? SecurityStamp { get; set; }

    public string? ConcurrencyStamp { get; set; }

    public string? PhoneNumber { get; set; }

    public bool PhoneNumberConfirmed { get; set; }

    public bool TwoFactorEnabled { get; set; }

    public DateTimeOffset? LockoutEnd { get; set; }

    public bool LockoutEnabled { get; set; }

    public int AccessFailedCount { get; set; }

    public string NumeroDeIdentificacion { get; set; } = null!;

    public string Direccion { get; set; } = null!;

    public DateTime FechaDeNacimiento { get; set; }

    public string Apellido { get; set; } = null!;

    public string Estado { get; set; } = null!;

    public DateTime FechaDeRegistro { get; set; }

    public int? IdAntiguo { get; set; }

    public int IdSecundario { get; set; }

    public virtual ICollection<AccessToken> AccessTokens { get; set; } = new List<AccessToken>();

    public virtual ICollection<AspNetUserClaim> AspNetUserClaims { get; set; } = new List<AspNetUserClaim>();

    public virtual ICollection<AspNetUserLogin> AspNetUserLogins { get; set; } = new List<AspNetUserLogin>();

    public virtual ICollection<AspNetUserToken> AspNetUserTokens { get; set; } = new List<AspNetUserToken>();

    public virtual ICollection<Cita> CitaEntrenadors { get; set; } = new List<Cita>();

    public virtual ICollection<Cita> CitaUsers { get; set; } = new List<Cita>();

    public virtual ICollection<Clase> Clases { get; set; } = new List<Clase>();

    public virtual ICollection<ClasesProgramada> ClasesProgramada { get; set; } = new List<ClasesProgramada>();

    public virtual ICollection<InscripcionesDeClase> InscripcionesDeClases { get; set; } = new List<InscripcionesDeClase>();

    public virtual ICollection<Medida> Medida { get; set; } = new List<Medida>();

    public virtual ICollection<Meta> Meta { get; set; } = new List<Meta>();

    public virtual ICollection<Pago> Pagos { get; set; } = new List<Pago>();

    public virtual ICollection<RefreshToken> RefreshTokens { get; set; } = new List<RefreshToken>();

    public virtual ICollection<RegistrosEntrenamiento> RegistrosEntrenamientos { get; set; } = new List<RegistrosEntrenamiento>();

    public virtual ICollection<Rutina> RutinaEntrenadors { get; set; } = new List<Rutina>();

    public virtual ICollection<Rutina> RutinaUsers { get; set; } = new List<Rutina>();

    public virtual ICollection<AspNetRole> Roles { get; set; } = new List<AspNetRole>();
}
