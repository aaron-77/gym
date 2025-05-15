using System;
using System.Collections.Generic;

namespace DataAccess.EntityFramework;

public partial class PreReservasDeHorario
{
    public int IdPreReserva { get; set; }

    public int FkHorarioClaseProgramada { get; set; }

    public DateTime FechaInicioDeLaReserva { get; set; }

    public DateTime FechaDeExpiracionDeLaReserva { get; set; }

    public virtual HorariosDeClasesProgramada FkHorarioClaseProgramadaNavigation { get; set; } = null!;
}
