using GymWebApp.Tests.Integration.Common;
using GymWebApp.Tests.Integration.Helpers;
using API.Services;
using DTO.Dtos;
using Xunit;
using Microsoft.Extensions.DependencyInjection;
using System.Linq;

namespace GymWebApp.Tests.Integration.Features.Horarios
{
[Collection("HorariosServiceIntegrationTests")]
public class HorariosServiceTests : IClassFixture<CitasApiWebApplicationFactory<Program>>
    {
        private readonly CitasApiWebApplicationFactory<Program> _factory;
        private readonly string _connectionString;

        public HorariosServiceTests(CitasApiWebApplicationFactory<Program> factory)
        {
            _factory = factory;
            _connectionString = TestContainerHelper.ConnectionString;
        }

        public async Task InitializeAsync()
        {
            await TestContainerHelper.InitializeAsync();
            await TestContainerHelper.ResetDatabaseAsync();
        }

        public Task DisposeAsync()
        {
            return Task.CompletedTask;
        }

        [Fact]
        public async Task consultarHorariosDisponibles_ConFechaActual_DevuelveHorarios()
        {
            // Arrange
            var context = _factory.Services.GetRequiredService<DataAccess.EntityFramework.FitnessCenterDbContext>();
            var service = new HorariosService(context);

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

            var context = _factory.Services.GetRequiredService<DataAccess.EntityFramework.FitnessCenterDbContext>();
            var service = new HorariosService(context);

            // Act
            var idPreReserva = await service.RegistrarPreReservaDeHorario(dto);

            // Assert
            Assert.True(idPreReserva > 0, "El ID de pre-reserva debe ser mayor a 0");

            // Verificación extra en BD
            using var connection = new Microsoft.Data.SqlClient.SqlConnection(_connectionString);
            await connection.OpenAsync();
            using var cmd = new Microsoft.Data.SqlClient.SqlCommand(
                $"SELECT COUNT(*) FROM preReservasDeHorario WHERE idPreReserva = {idPreReserva}", connection);
            var count = (int)await cmd.ExecuteScalarAsync();
            Assert.Equal(1, count);
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

            var context = _factory.Services.GetRequiredService<DataAccess.EntityFramework.FitnessCenterDbContext>();
            var service = new HorariosService(context);
            var idPreReserva = await service.RegistrarPreReservaDeHorario(dto);

            // Act
            var result = await service.ObtenerPreReservasDeHorario(DateTime.Now);

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
                "SELECT TOP 1 idProgramacionClase FROM ClasesProgramadas");

            if (idProgramacionClaseObj == null)
            {
                // Skip test if no data
                return;
            }

            int idProgramacionClase = idProgramacionClaseObj;
            var context = _factory.Services.GetRequiredService<DataAccess.EntityFramework.FitnessCenterDbContext>();
            var service = new HorariosService(context);

            // Act
            var result = await service.obtenerClaseProgramadaConNuevoCupo(idProgramacionClase);

            // Assert
            Assert.NotNull(result);
            Assert.NotEmpty(result);

            // Validar que la clase programada tenga registros relacionados en horariosDeClasesProgramadas
            var claseProgramada = result.First();
            Assert.True(claseProgramada.idHora > 0, "La clase programada debe tener un idHora válido");

            // Validar que el idHora existe en la tabla horasLaborales
            var horaLaboralExists = await DatabaseHelper.ExecuteScalarAsync<int>(
                _connectionString,
                $"SELECT COUNT(*) FROM horasLaborales WHERE idHora = {claseProgramada.idHora}");
            Assert.Equal(1, horaLaboralExists);

            // Validar que existe registro en horariosDeClasesProgramadas relacionado a esta clase
            var horarioClaseProgramadaExists = await DatabaseHelper.ExecuteScalarAsync<int>(
                _connectionString,
                $"SELECT COUNT(*) FROM horariosDeClasesProgramadas WHERE fkClaseProgramada = {idProgramacionClase}");
            Assert.True(horarioClaseProgramadaExists > 0, "Debe existir al menos un registro en horariosDeClasesProgramadas");
        }
    }
}