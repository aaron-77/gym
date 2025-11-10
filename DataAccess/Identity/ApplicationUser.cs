using System.ComponentModel.DataAnnotations;
using DataAccess.EntityFramework;
using Microsoft.AspNetCore.Identity;

namespace DataAccess.Identity;

public class ApplicationUser : IdentityUser
{
    // Puedes agregar aquí propiedades personalizadasD

    public string NombreCompleto { get; set; }

    [MaxLength(50)]
    public string Apellido { get; set; }

    public string NumeroDeIdentificacion { get; set; }
    public string Direccion { get; set; }
    public DateTime FechaDeNacimiento { get; set; }
    public DateTime FechaDeRegistro { get; set; }

    public int? IdAntiguo { get; set; }

    [MaxLength(50)]
    public string Estado { get; set; } = "activo"; // activo, inactivo, suspendido

    // 👇 Relaciones de navegación que antes daban error
    public virtual ICollection<AccessToken> AccessTokens { get; set; } = new List<AccessToken>();
    public virtual ICollection<Cita> CitaEntrenadors { get; set; } = new List<Cita>();
    public virtual ICollection<Cita> CitaUsers { get; set; } = new List<Cita>();
    public virtual ICollection<Clase> Clases { get; set; } = new List<Clase>();
    public virtual ICollection<ClasesProgramada> ClasesProgramada { get; set; } =
        new List<ClasesProgramada>();
    public virtual ICollection<HorariosDeClasesProgramada> HorariosDeClasesProgramada { get; set; } =
        new List<HorariosDeClasesProgramada>();
    public virtual ICollection<InscripcionesDeClase> InscripcionesDeClases { get; set; } =
        new List<InscripcionesDeClase>();
    public virtual ICollection<Medida> Medida { get; set; } = new List<Medida>();
    public virtual ICollection<Meta> Meta { get; set; } = new List<Meta>();
    public virtual ICollection<Pago> Pagos { get; set; } = new List<Pago>();
    public virtual ICollection<RefreshToken> RefreshTokens { get; set; } = new List<RefreshToken>();
    public virtual ICollection<RegistrosEntrenamiento> RegistrosEntrenamientos { get; set; } =
        new List<RegistrosEntrenamiento>();
    public virtual ICollection<Rutina> RutinaEntrenadors { get; set; } = new List<Rutina>();
    public virtual ICollection<Rutina> RutinaUsers { get; set; } = new List<Rutina>();
}
