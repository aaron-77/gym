using System;
using System.Collections.Generic;

namespace DataAccess.EntityFramework;

public partial class PreReservasDeHorario
{
    public int IdPreReserva { get; set; }

    public DateTime FechaInicioDeLaReserva { get; set; }

    public DateTime FechaDeExpiracionDeLaReserva { get; set; }

    public int FkHoraLaboral { get; set; }

    public string? IdUsuarioQueReserva { get; set; }

    public DateOnly FechaReservada { get; set; }

    public int? IdClase { get; set; }

    public DateOnly? FechaDeLaClase { get; set; }

    public string? IdEntrenador { get; set; }

    public virtual HorasLaborale FkHoraLaboralNavigation { get; set; } = null!;
}
