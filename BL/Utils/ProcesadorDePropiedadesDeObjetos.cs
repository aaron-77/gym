namespace BL.Utils
{
    public class ProcesadorDePropiedadesDeObjetos
    {
        public static object obtenerValorDePropiedad(object objeto, string nombrePropiedad)
        {
            object valorObtenido = null;

            System.Reflection.PropertyInfo[] propiedades = objeto.GetType().GetProperties();
            valorObtenido = propiedades
                .FirstOrDefault(p => p.Name == nombrePropiedad)
                .GetValue(objeto);

            return valorObtenido;
        }

        public static Type obtenerTipoDePropiedad(object objeto, string nombrePropiedad)
        {
            Type tipoObtenido = null;
            System.Reflection.PropertyInfo[] propiedades = objeto.GetType().GetProperties();
            var propiedad = propiedades.FirstOrDefault(p => p.Name == nombrePropiedad);
            if (propiedad != null)
            {
                tipoObtenido = propiedad.PropertyType;
            }
            else
            {
                throw new ArgumentException(
                    $"La propiedad '{propiedad.Name}' no existe en el objeto de tipo {objeto.GetType().Name}"
                );
            }
            return tipoObtenido;
        }

        public static TTarget MapProperties<TSource, TTarget>(TSource source)
            where TTarget : new()
        {
            if (source == null)
                throw new ArgumentNullException(nameof(source));

            var target = new TTarget();
            var sourceProps = typeof(TSource).GetProperties();
            var targetProps = typeof(TTarget).GetProperties();

            foreach (var sProp in sourceProps)
            {
                var tProp = targetProps.FirstOrDefault(p =>
                    p.Name == sProp.Name
                    && p.PropertyType.IsAssignableFrom(sProp.PropertyType)
                    && p.CanWrite
                );

                if (tProp != null)
                {
                    var value = sProp.GetValue(source);
                    tProp.SetValue(target, value);
                }
            }

            return target;
        }

        /* public static List<Dictionary<string, int>> ObtenerMesesYAniosUnicos(List<DTOUltimaMedidaDeParametro> medidas)
        {
            return medidas
                .Select(m => new { Mes = m.fechaDeCreacion.Month, Año = m.fechaDeCreacion.Year })
                .Distinct()
                .OrderBy(m => m.Año)
                .ThenBy(m => m.Mes)
                .Select(m => new Dictionary<string, int> { { "mes", m.Mes }, { "año", m.Año } })
                .ToList();
        } */
    }
}
