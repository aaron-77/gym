using System;
using System.Collections.Generic;

namespace DataAccess.EntityFramework;

public partial class Servicio
{
    public int ServicioId { get; set; }

    public string NombreServicio { get; set; } = null!;

    public string? Descripcion { get; set; }

    public string TipoServicio { get; set; } = null!;

    public decimal Costo { get; set; }
}
