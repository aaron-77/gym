using System;
using System.Collections.Generic;

namespace DataAccess.EntityFramework;

public partial class Medida
{
    public int MedidaId { get; set; }

    public int FkUsuario { get; set; }

    public decimal Peso { get; set; }

    public decimal Altura { get; set; }

    public decimal Imc { get; set; }

    public int Edad { get; set; }

    public string? Genero { get; set; }

    public virtual Usuario FkUsuarioNavigation { get; set; } = null!;
}
