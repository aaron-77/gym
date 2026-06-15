using System;
using System.Collections.Generic;

namespace DataAccess.EntityFramework;

public partial class VwHorariosOcupado
{
    public int FkClase { get; set; }

    public DateOnly? FechaDeLaClase { get; set; }

    public int FkHorarioLaboral { get; set; }

    public byte[]? FkEntrenadorHash { get; set; }

    public int IdHorarioDeClaseProgramada { get; set; }
}
