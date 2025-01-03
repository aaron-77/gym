using System;
using System.Collections.Generic;

namespace DataAccess.EntityFramework;

public partial class DuracionCita
{
    public int DuracionId { get; set; }

    public int Duracion { get; set; }

    public int FrecuenciaNotificaciones { get; set; }
}
