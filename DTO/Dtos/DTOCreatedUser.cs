/*  <summary>
    DTO para el usuario recien creado, se usa solo al moneto de mandar la respuesta de la creacion del usuario
    </summary>
*/
namespace DTO.Dtos
{
    public class DTOCreatedUser
    {
        public string Id { get; set; }
        public string NombreCompleto { get; set; }

        public DateTime FechaDeNacimiento { get; set; }  // Usamos DateTime para representar una fecha

        public string Direccion { get; set; }

        public string NumeroDeIdentificacion { get; set; }

        public string Correo { get; set; }

        public string Telefono { get; set; }

    }
}