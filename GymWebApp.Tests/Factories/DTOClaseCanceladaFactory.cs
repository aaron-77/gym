using Bogus;
using DTO.Dtos;

namespace GymWebApp.Tests.Factories;

public static class DTOClaseCanceladaFactory
{
    /// <summary>
    /// Creates DTOClaseCancelada with Bogus data by default.
    /// Use parameters to override specific values.
    /// </summary>
    public static DTOClaseCancelada Crear(
        int? idProgramacionClase = null,
        int? fkClase = null,
        string? fkEntrenador = null,
        int? cupoMaximo = null,
        int? fkEstadoClaseProgramada = null,
        DateOnly? fechaDeLaClase = null,
        string? idUsuarioQueReserva = null,
        int? fkHoraLaboral = null,
        int? idPreservaDeHorario = null,
        DTODatosClaseProgramada? claseReagendada = null)
    {
        var faker = new Faker("es");
        
        return new DTOClaseCancelada
        {
            claseCancelada = new DTODatosCancelacionClaseProgramada
            {
                idProgramacionClase = idProgramacionClase ?? faker.Random.Int(1, 1000),
                fkClase = fkClase ?? faker.Random.Int(1, 50),
                fkEntrenador = fkEntrenador ?? Guid.NewGuid().ToString(),
                cupoMaximo = cupoMaximo ?? faker.Random.Int(5, 30),
                fkEstadoClaseProgramada = fkEstadoClaseProgramada ?? faker.PickRandom(1, 2, 3),
                fechaDeLaClase = fechaDeLaClase ?? DateOnly.FromDateTime(faker.Date.Future(1)),
                idUsuarioQueReserva = idUsuarioQueReserva ?? Guid.NewGuid().ToString(),
                fkHoraLaboral = fkHoraLaboral ?? faker.Random.Int(1, 10),
                idPreservaDeHorario = idPreservaDeHorario ?? 0
            },
            claseReagendada = claseReagendada
        };
    }
    
    /// <summary>
    /// Creates DTOClaseCancelada with full Bogus data (no parameters)
    /// </summary>
    public static DTOClaseCancelada CrearConBogus()
    {
        return Crear();
    }
    
    /// <summary>
    /// Creates DTOClaseCancelada with all specified values
    /// </summary>
    public static DTOClaseCancelada CrearConValoresEspecificos(
        int idProgramacionClase,
        int fkClase,
        string fkEntrenador,
        int cupoMaximo,
        int fkEstadoClaseProgramada,
        DateOnly fechaDeLaClase,
        string idUsuarioQueReserva,
        int fkHoraLaboral,
        int idPreservaDeHorario = 0,
        DTODatosClaseProgramada? claseReagendada = null)
    {
        return Crear(
            idProgramacionClase: idProgramacionClase,
            fkClase: fkClase,
            fkEntrenador: fkEntrenador,
            cupoMaximo: cupoMaximo,
            fkEstadoClaseProgramada: fkEstadoClaseProgramada,
            fechaDeLaClase: fechaDeLaClase,
            idUsuarioQueReserva: idUsuarioQueReserva,
            fkHoraLaboral: fkHoraLaboral,
            idPreservaDeHorario: idPreservaDeHorario,
            claseReagendada: claseReagendada
        );
    }
}
