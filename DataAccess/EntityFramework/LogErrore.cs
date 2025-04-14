using System;
using System.Collections.Generic;

namespace DataAccess.EntityFramework;

public partial class LogErrore
{
    public int Id { get; set; }

    public string Procedimiento { get; set; } = null!;

    public string Mensaje { get; set; } = null!;

    public int Severidad { get; set; }

    public int Estado { get; set; }

    public DateTime? Fecha { get; set; }

    public string? Usuario { get; set; }

    public string? Host { get; set; }

    public string? Aplicacion { get; set; }
}
