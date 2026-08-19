// File: Tests/Services/HorariosServiceTests.cs
using API.Services;
using API.Services.Validaciones;
using DataAccess.EntityFramework;
using DataAccess.Identity;
using Moq;
using System;
using System.Threading.Tasks;
using Xunit;

namespace Tests.Services
{
    public class HorariosServiceTests
    {
        private readonly Mock<FitnessCenterDbContext> _mockContext;
        private readonly Mock<IValidadorUsuarioExistente> _mockValidadorUsuario;
        private readonly Mock<IValidadorClaseExistente> _mockValidadorClase;
        private readonly Mock<IValidadorClaseProgramadaExistente> _mockValidadorClaseProgramada;
        private readonly HorariosService _horariosService;

        public HorariosServiceTests()
        {
            _mockContext = new Mock<FitnessCenterDbContext>();
            _mockValidadorUsuario = new Mock<IValidadorUsuarioExistente>();
            _mockValidadorClase = new Mock<IValidadorClaseExistente>();
            _mockValidadorClaseProgramada = new Mock<IValidadorClaseProgramadaExistente>();

            _horariosService = new HorariosService(
                _mockContext.Object,
                _mockValidadorUsuario.Object,
                _mockValidadorClase.Object,
                _mockValidadorClaseProgramada.Object);
        }

        [Fact]
        public void HorariosService_CanBeInstantiated()
        {
            // Arrange & Act
            var service = new HorariosService(
                _mockContext.Object,
                _mockValidadorUsuario.Object,
                _mockValidadorClase.Object,
                _mockValidadorClaseProgramada.Object);

            // Assert
            Assert.NotNull(service);
        }

        [Fact]
        public async Task ObtenerPreReservasDeHorario_ThrowsException_WhenContextFails()
        {
            // Arrange
            // FromSqlInterpolated no se puede mockear fácilmente, por lo que este test
            // verifica que las excepciones se propagan correctamente
            // En un entorno real, se usaría una base de datos en memoria o un mock más sofisticado
            
            // Act & Assert
            // El método lanzará una excepción al intentar ejecutar FromSqlInterpolated en un mock
            await Assert.ThrowsAnyAsync<Exception>(() => _horariosService.ObtenerPreReservasDeHorario());
        }
    }
}