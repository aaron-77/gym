using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using DTO.Dtos;
using GymWebApp.Tests.Integration.Common;
using GymWebApp.Tests.SharedHelpers;

namespace GymWebApp.Tests.Integration.Helpers;

/// <summary>
/// Helper para tests de integración de PreReservarHorarioReagendacion.
/// Centraliza la creación y limpieza de datos de prueba.
/// </summary>
public static class PreReservarHorarioReagendacionTestHelper
{
    /// <summary>
    /// Crea una clase programada de prueba con cupo = 1 usando datos de un slot seguro.
    /// </summary>
    public static async Task<(int IdClaseProgramada, int IdHorarioClaseProgramada)> CrearClaseProgramadaDePruebaAsync(
        string connectionString, SlotDisponibleParaClaseProgramadaDto slot)
    {
        var datosClase = new DTODatosClaseProgramada
        {
            fkClase = slot.ClaseId,
            fkEntrenador = slot.EntrenadorId,
            fkHoraLaboral = slot.IdHoraLaboral,
            fechaDeLaClase = slot.FechaDisponible,
            cupoMaximo = 1,
            fkEstadoClaseProgramada = 1,
            idUsuarioQueReserva = null,
            idPreservaDeHorario = null
        };

        return await ClasesProgramadasHelper.RegistrarClaseProgramadaML(connectionString, datosClase);
    }

    /// <summary>
    /// Construye un DTOPreReservaDeHorarioInscripcion con los datos del slot y cliente indicado.
    /// </summary>
    public static DTOPreReservaDeHorarioInscripcion ConstruirDto(
        SlotDisponibleParaClaseProgramadaDto slot, int idClaseProgramada, string clienteId)
    {
        return new DTOPreReservaDeHorarioInscripcion
        {
            idUsuarioQueReserva = clienteId,
            fechaTentativa = slot.FechaDisponible,
            idHoraLaboral = slot.IdHoraLaboral,
            idClase = slot.ClaseId,
            idEntrenador = slot.EntrenadorId,
            idClaseProgramada = idClaseProgramada
        };
    }

    /// <summary>
    /// Elimina los datos de prueba generados por los tests.
    /// </summary>
    public static async Task LimpiarDatosDePruebaAsync(
        string connectionString,
        int idClaseProgramada,
        string idEntrenador,
        int idHoraLaboral,
        DateOnly fechaReservada,
        int idClase)
    {
        await GymWebApp.Tests.Integration.Common.DatabaseHelper.ExecuteNonQueryAsync(
            connectionString,
            "DELETE FROM preReservasDeHorario WHERE fkHoraLaboral = @IdHora AND fechaReservada = @Fecha AND idClase = @IdClase AND idEntrenador = @IdEntrenador",
            new Dictionary<string, object?>
            {
                ["@IdHora"] = idHoraLaboral,
                ["@Fecha"] = fechaReservada,
                ["@IdClase"] = idClase,
                ["@IdEntrenador"] = idEntrenador
            });

        await GymWebApp.Tests.Integration.Common.DatabaseHelper.ExecuteNonQueryAsync(
            connectionString,
            "DELETE FROM horariosDeClasesProgramadas WHERE fkClaseProgramada = @IdClaseProgramada",
            new Dictionary<string, object?> { ["@IdClaseProgramada"] = idClaseProgramada });

        await GymWebApp.Tests.Integration.Common.DatabaseHelper.ExecuteNonQueryAsync(
            connectionString,
            "DELETE FROM clasesProgramadas WHERE idProgramacionClase = @IdClaseProgramada",
            new Dictionary<string, object?> { ["@IdClaseProgramada"] = idClaseProgramada });
    }
}
