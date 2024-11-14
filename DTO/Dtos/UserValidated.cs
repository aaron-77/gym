using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DTO.Dtos
{
	public class UserValidated
	{
		
		public string NombreCompleto { get; set; }
		
		public DateTime FechaDeNacimiento { get; set; }  // Usamos DateTime para representar una fecha
		
		public string Direccion { get; set; }
		
		public string NumeroDeIdentificacion { get; set; }
		
		public string Correo { get; set; }
		
		public string Telefono { get; set; }
		
		public string Contrasena { get; set; }
	}
}
