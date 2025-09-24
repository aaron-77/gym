using System;
using System.Collections.Generic;

namespace DataAccess.EntityFramework;

public partial class PreReservasDeHorario
{
    public int IdPreReserva { get; set; }

    public DateTime FechaInicioDeLaReserva { get; set; }

    public DateTime FechaDeExpiracionDeLaReserva { get; set; }

    public int FkHoraLaboral { get; set; }

    /// <summary>
    /// id del usuario que esta registrando la clase programada,es para saber a que usuario hay que enviarle la respuesta ya que es por tiempo real
    /// </summary>
    public int IdUsuarioQueReserva { get; set; }

    public DateOnly FechaReservada { get; set; }

    public virtual HorasLaborale FkHoraLaboralNavigation { get; set; } = null!;
}
