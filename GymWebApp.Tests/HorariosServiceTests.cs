// File: Tests/Services/HorariosServiceTests.cs
using DataAccess.EntityFramework;
using DTO.Dtos;
using Microsoft.EntityFrameworkCore;
using Moq;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Xunit;

namespace Tests.Services
{
    public class HorariosServiceTests
    {
        private readonly Mock<FitnessCenterDbContext> _mockContext;
        private readonly HorariosService _horariosService;

        public HorariosServiceTests()
        {
            _mockContext = new Mock<FitnessCenterDbContext>();
            _horariosService = new HorariosService(_mockContext.Object);
        }

        [Fact]
        public async Task ObtenerPreReservasDeHorario_ReturnsListOfDTOHorarioVisualizacion()
        {
            // Arrange
            var fechaActual = DateTime.Now;
            var horariosPreReservados = new List<DTOHorarioPreReservado>
            {
                new DTOHorarioPreReservado
                {
                    idPreReserva = 1,
                    fechaReservada = fechaActual,
                    horaInicio = fechaActual.AddHours(1),
                    horaFin = fechaActual.AddHours(2),
                    idUsuarioQueReserva = 1,
                    fechaDeExpiracionDeLaReserva = fechaActual.AddDays(1)
                }
            }.AsQueryable();

            var mockSet = new Mock<DbSet<DTOHorarioPreReservado>>();
            mockSet.As<IQueryable<DTOHorarioPreReservado>>().Setup(m => m.Provider).Returns(horariosPreReservados.Provider);
            mockSet.As<IQueryable<DTOHorarioPreReservado>>().Setup(m => m.Expression).Returns(horariosPreReservados.Expression);
            mockSet.As<IQueryable<DTOHorarioPreReservado>>().Setup(m => m.ElementType).Returns(horariosPreReservados.ElementType);
            mockSet.As<IQueryable<DTOHorarioPreReservado>>().Setup(m => m.GetEnumerator()).Returns(horariosPreReservados.GetEnumerator());

            _mockContext.Setup(c => c.HorariosPreReservados).Returns(mockSet.Object);

            // Act
            var result = await _horariosService.ObtenerPreReservasDeHorario();

            // Assert
            Assert.NotNull(result);
            Assert.Single(result);
            Assert.Equal(1, result.First().idHora);
        }

        [Fact]
        public async Task ObtenerPreReservasDeHorario_ThrowsException()
        {
            // Arrange
            _mockContext.Setup(c => c.HorariosPreReservados).Throws(new Exception("Error en la consulta"));

            // Act & Assert
            await Assert.ThrowsAsync<Exception>(() => _horariosService.ObtenerPreReservasDeHorario());
        }
    }
}