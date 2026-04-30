using System;

namespace GymWebApp.Tests.Integration.Helpers
{
    /// <summary>
    /// DTO que contiene las FK necesarias para crear una pre-reserva de horario.
    /// </summary>
    public class TestDTOFkNecesariasParaPreReserva
    {
        public string UserId { get; set; } = string.Empty;
        public string TrainerId { get; set; } = string.Empty;
        public int ClaseId { get; set; }
        public int HoraLaboralId { get; set; }
        public DateTime FechaReservada { get; set; }
    }
}