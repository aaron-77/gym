using System.Data;
namespace DataAccess.Infraestructure
{
    
/// <summary>
/// Clase para definir parámetros personalizados con dirección y tipo específicos
/// </summary>
public class DatabaseParameter
{
    public object Value { get; set; }
    public ParameterDirection Direction { get; set; } = ParameterDirection.Input;
    public DbType DbType { get; set; } = DbType.String;
    public int Size { get; set; } = 0;

    public DatabaseParameter(object value, ParameterDirection direction = ParameterDirection.Input)
    {
        Value = value;
        Direction = direction;
    }

    public DatabaseParameter(object value, ParameterDirection direction, DbType dbType, int size = 0)
    {
        Value = value;
        Direction = direction;
        DbType = dbType;
        Size = size;
    }
}
}