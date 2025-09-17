namespace DTO.Dtos
{
/*  <summary>
    DTO para el usuario que ha iniciado sesión, como tal representa la sesion del usuario, 
    se usa solo al momento de mandar la respuesta de la autenticación del usuario
    </summary>
*/
    public class DTOLoggedUser
    {


        public string Id { get; set; }
        public string NombreCompleto
        { get; set; }

        public DateTime FechaDeNacimiento { get; set; }  // Usamos DateTime para representar una fecha

        public string Direccion { get; set; }

        public string NumeroDeIdentificacion { get; set; }

        public string Correo { get; set; }

        public string Telefono { get; set; }
        public string AccessToken { get; set; }
        public string IdToken { get; set; }
        public string RefreshToken { get; set; }

    }
}