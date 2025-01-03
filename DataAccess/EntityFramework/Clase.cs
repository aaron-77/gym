using System;
using System.Collections.Generic;

namespace DataAccess.EntityFramework;

public partial class Clase
{
    public int ClaseId { get; set; }

    public string NombreClase { get; set; } = null!;

    public int? InstructorId { get; set; }

    public int Cupo { get; set; }

    public DateTime Horario { get; set; }

    public string? Descripcion { get; set; }

    public virtual ICollection<InscripcionClase> InscripcionClases { get; set; } = new List<InscripcionClase>();

    public virtual Usuario? Instructor { get; set; }
}
