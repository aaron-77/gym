using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using API.Services;
using DTO.Dtos;
using GymWebApp.Tests.Integration.Common;
using GymWebApp.Tests.Integration.Helpers;
using Microsoft.Data.SqlClient;
using Microsoft.Extensions.DependencyInjection;
using Xunit;
using FluentAssertions;

namespace GymWebApp.Tests.Integration.Features.Horarios;

[Collection("IntegrationTests")]
public class PreReservarHorarioReagendacionServiceTests : IntegrationTestBase
{
    public PreReservarHorarioReagendacionServiceTests(CitasApiWebApplicationFactory<Program> factory, TestContainerHelper testContainerHelper)
        : base(factory, testContainerHelper) { }

    #region Happy Path

    [Fact]
    public async Task PreReservarHorarioReagendacion_DatosValidos_CreaPreReserva()
    {
        // Arrange
        var slot = await SlotDisponibleParaClaseProgramadaHelper.obtenerSlotDisponibleParaClaseProgramadaAsync(
            TestContainerHelper.ConnectionString,
            DateOnly.FromDateTime(DateTime.Now.AddDays(7)));

        if (slot == null)
            throw new InvalidOperationException("No se encontró slot disponible para la prueba");

        var (idClaseProgramada, _) = await PreReservarHorarioReagendacionTestHelper.CrearClaseProgramadaDePruebaAsync(
            TestContainerHelper.ConnectionString, slot);

        var dto = PreReservarHorarioReagendacionTestHelper.ConstruirDto(slot, idClaseProgramada, slot.ClienteId);

        var context = Factory.Services.GetRequiredService<DataAccess.EntityFramework.FitnessCenterDbContext>();
        var service = new HorariosService(context);

        try
        {
            // Act
            var idPreReserva = await service.PreReservarHorarioReagendacion(dto);

            // Assert
            idPreReserva.Should().BeGreaterThan(0, "El ID de pre-reserva debe ser mayor a 0");
        }
        finally
        {
            await PreReservarHorarioReagendacionTestHelper.LimpiarDatosDePruebaAsync(
                TestContainerHelper.ConnectionString, idClaseProgramada, slot.EntrenadorId, slot.IdHoraLaboral, slot.FechaDisponible, slot.ClaseId);
        }
    }

    #endregion

    #region Sad Paths

    [Fact]
    public async Task PreReservarHorarioReagendacion_PreReservaDuplicada_LanzaExcepcion()
    {
        // Arrange
        var slot = await SlotDisponibleParaClaseProgramadaHelper.obtenerSlotDisponibleParaClaseProgramadaAsync(
            TestContainerHelper.ConnectionString,
            DateOnly.FromDateTime(DateTime.Now.AddDays(7)));

        if (slot == null)
            throw new InvalidOperationException("No se encontró slot disponible para la prueba");

        var (idClaseProgramada, _) = await PreReservarHorarioReagendacionTestHelper.CrearClaseProgramadaDePruebaAsync(
            TestContainerHelper.ConnectionString, slot);

        var dto = PreReservarHorarioReagendacionTestHelper.ConstruirDto(slot, idClaseProgramada, slot.ClienteId);

        var context = Factory.Services.GetRequiredService<DataAccess.EntityFramework.FitnessCenterDbContext>();
        var service = new HorariosService(context);

        try
        {
            // Primera llamada exitosa
            var idPreReserva = await service.PreReservarHorarioReagendacion(dto);
            idPreReserva.Should().BeGreaterThan(0);

            // Act & Assert
            var ex = await Assert.ThrowsAsync<SqlException>(() => service.PreReservarHorarioReagendacion(dto));
            ex.Message.Should().Contain("Ya existe una pre-reserva vigente");
        }
        finally
        {
            await PreReservarHorarioReagendacionTestHelper.LimpiarDatosDePruebaAsync(
                TestContainerHelper.ConnectionString, idClaseProgramada, slot.EntrenadorId, slot.IdHoraLaboral, slot.FechaDisponible, slot.ClaseId);
        }
    }

    [Fact]
    public async Task PreReservarHorarioReagendacion_SinCupo_LanzaExcepcion()
    {
        // Arrange
        var slot = await SlotDisponibleParaClaseProgramadaHelper.obtenerSlotDisponibleParaClaseProgramadaAsync(
            TestContainerHelper.ConnectionString,
            DateOnly.FromDateTime(DateTime.Now.AddDays(7)));

        if (slot == null)
            throw new InvalidOperationException("No se encontró slot disponible para la prueba");

        var (idClaseProgramada, _) = await PreReservarHorarioReagendacionTestHelper.CrearClaseProgramadaDePruebaAsync(
            TestContainerHelper.ConnectionString, slot);

        // Llenar el cupo con una inscripción vigente del cliente del slot
        await GymWebApp.Tests.Integration.Common.DatabaseHelper.ExecuteNonQueryAsync(
            TestContainerHelper.ConnectionString,
            @"INSERT INTO inscripcionesDeClases (fkProgramacionClase, fechaDeInscripcion, fkEstadoInscripcion, fkCliente)
              VALUES (@FkProgramacionClase, GETDATE(), (SELECT idEstadoInscripcion FROM v_idEstadoVigenteInscripcionAClase), @FkCliente)",
            new Dictionary<string, object?>
            {
                ["@FkProgramacionClase"] = idClaseProgramada,
                ["@FkCliente"] = slot.ClienteId
            });

        // Obtener un segundo cliente distinto
        var segundoClienteId = await GymWebApp.Tests.Integration.Common.DatabaseHelper.ExecuteScalarAsync<string>(
            TestContainerHelper.ConnectionString,
            @"SELECT TOP 1 u.Id 
              FROM AspNetUsers u
              INNER JOIN AspNetUserRoles ur ON u.Id = ur.UserId
              INNER JOIN AspNetRoles r ON ur.RoleId = r.Id
              WHERE r.Name = 'cliente' AND u.Id <> @ClienteId",
            new Dictionary<string, object?> { ["@ClienteId"] = slot.ClienteId });

        if (string.IsNullOrEmpty(segundoClienteId))
            throw new InvalidOperationException("No se encontró un segundo cliente para la prueba");

        var dto = PreReservarHorarioReagendacionTestHelper.ConstruirDto(slot, idClaseProgramada, segundoClienteId);

        var context = Factory.Services.GetRequiredService<DataAccess.EntityFramework.FitnessCenterDbContext>();
        var service = new HorariosService(context);

        try
        {
            // Act & Assert
            var ex = await Assert.ThrowsAsync<SqlException>(() => service.PreReservarHorarioReagendacion(dto));
            ex.Message.Should().Contain("No hay cupo disponible");
        }
        finally
        {
            await GymWebApp.Tests.Integration.Common.DatabaseHelper.ExecuteNonQueryAsync(
                TestContainerHelper.ConnectionString,
                "DELETE FROM inscripcionesDeClases WHERE fkProgramacionClase = @IdClaseProgramada",
                new Dictionary<string, object?> { ["@IdClaseProgramada"] = idClaseProgramada });

            await PreReservarHorarioReagendacionTestHelper.LimpiarDatosDePruebaAsync(
                TestContainerHelper.ConnectionString, idClaseProgramada, slot.EntrenadorId, slot.IdHoraLaboral, slot.FechaDisponible, slot.ClaseId);
        }
    }

    #endregion

}
