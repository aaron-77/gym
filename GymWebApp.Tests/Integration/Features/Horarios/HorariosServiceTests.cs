using GymWebApp.Tests.Integration.Common;
using GymWebApp.Tests.Integration.Helpers;
using API.Services;
using DTO.Dtos;
using Xunit;
using Microsoft.Extensions.DependencyInjection;
using System.Linq;

namespace GymWebApp.Tests.Integration.Features.Horarios
{
[Collection("IntegrationTests")]
public class HorariosServiceTests : IntegrationTestBase
{
    private readonly string _connectionString;

    public HorariosServiceTests(CitasApiWebApplicationFactory<Program> factory, TestContainerHelper testContainerHelper) 
        : base(factory, testContainerHelper)
    {
        _connectionString = TestContainerHelper.ConnectionString;
    }
        
        [Fact]
        public async Task consultarHorariosDisponibles_ConFechaActual_DevuelveHorarios()
        {
            // Arrange
            var service = Factory.Services.GetRequiredService<HorariosService>();

            // Act
            var result = await service.consultarHorariosDisponibles(DateTime.Now);

            // Assert
            Assert.NotNull(result);
            Assert.NotEmpty(result);
            Assert.All(result, h =>
            {
                Assert.NotNull(h.idHora);
                Assert.NotNull(h.horaInicio);
                Assert.NotNull(h.horaFin);
            });
        }

        [Fact]
        public async Task RegistrarPreReservaDeHorario_DatosValidos_DevuelveIdMayorACero()
        {
            // Arrange - obtener datos reales de la BD usando el helper
            var fkData = await PreReservaDeHorarioHelper.obtenerRegistrosNecesarios(_connectionString);

            var dto = new DTOPreReservaDeHorario
            {
                idUsuarioQueReserva = fkData.UserId,
                idEntrenador = fkData.TrainerId,
                idClase = fkData.ClaseId,
                idHoraLaboral = fkData.HoraLaboralId,
                fechaTentativa = DateOnly.FromDateTime(fkData.FechaReservada)
            };

            var service = Factory.Services.GetRequiredService<HorariosService>();

            // Act
            var idPreReserva = await service.RegistrarPreReservaDeHorario(dto);

            // Assert
            Assert.True(idPreReserva > 0, "El ID de pre-reserva debe ser mayor a 0");

            
        }

        [Fact]
        public async Task ObtenerPreReservasDeHorario_ConDatos_DevuelvePreReservas()
        {
            // Arrange - primero registrar una pre-reserva para tener datos
            var fkData = await PreReservaDeHorarioHelper.obtenerRegistrosNecesarios(_connectionString);

            var dto = new DTOPreReservaDeHorario
            {
                idUsuarioQueReserva = fkData.UserId,
                idEntrenador = fkData.TrainerId,
                idClase = fkData.ClaseId,
                idHoraLaboral = fkData.HoraLaboralId,
                fechaTentativa = DateOnly.FromDateTime(fkData.FechaReservada)
            };

            var service = Factory.Services.GetRequiredService<HorariosService>();
            var idPreReserva = await service.RegistrarPreReservaDeHorario(dto);

            // Act
            var result = await service.ObtenerPreReservasDeHorario(DateTime.Today);

            // Assert
            Assert.NotNull(result);
            Assert.NotEmpty(result);
            
        }

        [Fact]
        public async Task obtenerClaseProgramadaConNuevoCupo_IdValido_DevuelveClase()
        {
            // Arrange
            var idProgramacionClaseObj = await DatabaseHelper.ExecuteScalarAsync<int>(
                _connectionString, 
                @"SELECT TOP 1 cp.idProgramacionClase 
                        FROM ClasesProgramadas cp
                        INNER JOIN horariosDeClasesProgramadas hcp ON cp.idProgramacionClase = hcp.fkClaseProgramada
                        INNER JOIN horasLaborales hl ON hcp.fkHorarioLaboral = hl.idHora");

            if (idProgramacionClaseObj == null)
            {
                // Skip test if no data
                return;
            }

            int idProgramacionClase = idProgramacionClaseObj;
            var service = Factory.Services.GetRequiredService<HorariosService>();

            // Act
            var result = await service.obtenerClaseProgramadaConNuevoCupo(idProgramacionClase);

            // Assert
            Assert.NotNull(result);
            Assert.NotEmpty(result);

            
        }
    }
}