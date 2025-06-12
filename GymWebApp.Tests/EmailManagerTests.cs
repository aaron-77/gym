using BL.Utils;
using MimeKit;
using Xunit;
using DTO.Dtos;

namespace GymWebApp.Tests
{
    public class EmailManagerTests
    {
        private readonly EmailManagerMailKit _emailManager;

        public EmailManagerTests()  
        {
            // Configura el EmailManager con datos de prueba
            _emailManager = new EmailManagerMailKit("smtp.gmail.com", 587, "aaronlarabonfil@gmail.com", "kayxfchmpquogjgg");
        }

        [Fact]
        public void CrearEmail_CreacionCorrecta()
        {
            // Arrange
            string fromName = "aaron hernandez";
            string fromEmail = "aaronlarabonfil@gmail.com";
            string toName = "juan perez(tammbien es aaron)";
            string toEmail = "aaronhl1313@gmail.com";
            string subject = "pruebas de envio con mailkit";
            string body = "Test Body";

            // Act
            var message = _emailManager.crearEmail(fromName, fromEmail, toName, toEmail, subject, body);

            // Assert
            
            Assert.Equal(fromName, message.From[0].Name);
        
        }

        [Fact]
        public void EnviarEmail_EnvioExitoso()
        {
            
                var message = _emailManager.crearEmail("aaron hernandez",
             "aaronlarabonfil@gmail.com",
              "juan perez(tambien es aaron)",
               "aaronhl1313@gmail.com",
                "pruebas de envio con mailkit", 
                "Test Body");

            // Act
            var response = _emailManager.EnviarEmail(message);
            Console.WriteLine("mensaje excepcion: "+response.Message);
            // Assert
            Assert.True(response.IsSuccess);
            Assert.Equal("Email enviado exitosamente.", response.Message);    
            
                       // Arrange
            
        }

        
    }
}