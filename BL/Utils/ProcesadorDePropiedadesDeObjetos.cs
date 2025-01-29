namespace BL.Utils
{
    public class ProcesadorDePropiedadesDeObjetos
    {
        public static object obtenerValorDePropiedad(object objeto, string nombrePropiedad)
        {
            object valorObtenido = null;

            System.Reflection.PropertyInfo[] propiedades = objeto.GetType().GetProperties();
            valorObtenido = propiedades.FirstOrDefault(p => p.Name == nombrePropiedad).GetValue(objeto);

            return valorObtenido;

        }

        public static Type obtenerTipoDePropiedad(object objeto, string nombrePropiedad)
        {
            Type tipoObtenido = null;
            System.Reflection.PropertyInfo[] propiedades = objeto.GetType().GetProperties();
            var propiedad = propiedades.FirstOrDefault(p => p.Name == nombrePropiedad);
            if (propiedad != null )
            {
                tipoObtenido =  propiedad.PropertyType;     
            }
            else
            {
                throw new ArgumentException($"La propiedad '{propiedad.Name}' no existe en el objeto de tipo {objeto.GetType().Name}");
            }
            return tipoObtenido;
        }

    }
}