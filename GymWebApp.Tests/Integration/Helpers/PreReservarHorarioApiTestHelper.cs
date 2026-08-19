using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using DTO.Dtos;

namespace GymWebApp.Tests.Integration.Helpers;

/// <summary>
/// Helper para tests de integración del endpoint de pre-reserva de horario.
/// Usa seed seguro (slot disponible) y proporciona cleanup de preReservasDeHorario.
/// </summary>
public static class PreReservarHorarioApiTestHelper
{
    /// <summary>
    /// Construye un DTOPreReservaDeHorario a partir de un slot seguro y un cliente.
    /// </summary>
    public static DTOPreReservaDeHorario ConstruirDto(
        SlotDisponibleParaClaseProgramadaDto slot, string clienteId)
    {
        return new DTOPreReservaDeHorario
        {
            idUsuarioQueReserva = clienteId,
            fechaTentativa = slot.FechaDisponible,
            idHoraLaboral = slot.IdHoraLaboral,
            idClase = slot.ClaseId,
            idEntrenador = slot.EntrenadorId
        };
    }

    /// <summary>
    /// Elimina las pre-reservas de horario que coincidan con la combinación del DTO.
    /// Maneja idClase nulo y idEntrenador vacío/nulo.
    /// </summary>
    public static async Task LimpiarPreReservasDeHorarioAsync(
        string connectionString, DTOPreReservaDeHorario preReserva)
    {
        var whereClauses = new List<string>
        {
            "fkHoraLaboral = @IdHoraLaboral",
            "fechaReservada = @FechaReservada"
        };

        if (preReserva.idClase.HasValue)
            whereClauses.Add("idClase = @IdClase");
        else
            whereClauses.Add("idClase IS NULL");

        if (!string.IsNullOrEmpty(preReserva.idEntrenador))
            whereClauses.Add("idEntrenador = @IdEntrenador");
        else
            whereClauses.Add("(idEntrenador = '' OR idEntrenador IS NULL)");

        var sql = $"DELETE FROM preReservasDeHorario WHERE {string.Join(" AND ", whereClauses)}";

        var parameters = new Dictionary<string, object?>
        {
            ["@IdHoraLaboral"] = preReserva.idHoraLaboral,
            ["@FechaReservada"] = preReserva.fechaTentativa.ToDateTime(TimeOnly.MinValue)
        };

        if (preReserva.idClase.HasValue)
            parameters["@IdClase"] = preReserva.idClase.Value;

        if (!string.IsNullOrEmpty(preReserva.idEntrenador))
            parameters["@IdEntrenador"] = preReserva.idEntrenador;

        await GymWebApp.Tests.Integration.Common.DatabaseHelper.ExecuteNonQueryAsync(
            connectionString, sql, parameters);
    }

    /// <summary>
    /// Elimina las pre-reservas de horario que coincidan con la combinación del DTO.
    /// Versión para DTOPreReservaDeHorarioInscripcion. Limpia por fkHoraLaboral, fechaReservada,
    /// idClase e idEntrenador. El campo idClaseProgramada no se usa para cleanup
    /// porque no se almacena en preReservasDeHorario.
    /// </summary>
    public static async Task LimpiarPreReservasDeHorarioAsync(
        string connectionString, DTOPreReservaDeHorarioInscripcion preReserva)
    {
        var whereClauses = new List<string>
        {
            "fkHoraLaboral = @IdHoraLaboral",
            "fechaReservada = @FechaReservada"
        };

        if (preReserva.idClase.HasValue)
            whereClauses.Add("idClase = @IdClase");
        else
            whereClauses.Add("idClase IS NULL");

        if (!string.IsNullOrEmpty(preReserva.idEntrenador))
            whereClauses.Add("idEntrenador = @IdEntrenador");
        else
            whereClauses.Add("(idEntrenador = '' OR idEntrenador IS NULL)");

        var sql = $"DELETE FROM preReservasDeHorario WHERE {string.Join(" AND ", whereClauses)}";

        var parameters = new Dictionary<string, object?>
        {
            ["@IdHoraLaboral"] = preReserva.idHoraLaboral,
            ["@FechaReservada"] = preReserva.fechaTentativa.ToDateTime(TimeOnly.MinValue)
        };

        if (preReserva.idClase.HasValue)
            parameters["@IdClase"] = preReserva.idClase.Value;

        if (!string.IsNullOrEmpty(preReserva.idEntrenador))
            parameters["@IdEntrenador"] = preReserva.idEntrenador;

        await GymWebApp.Tests.Integration.Common.DatabaseHelper.ExecuteNonQueryAsync(
            connectionString, sql, parameters);
    }
}
