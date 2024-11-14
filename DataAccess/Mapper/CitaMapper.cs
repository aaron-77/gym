using DataAccess.DAO;
using DTO.Dtos;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DataAccess.Mapper
{
    public class CitaMapper : ICrudStatements, IObjectMapper
    {
        public List<BaseClass> BuildObjects(List<Dictionary<string, object>> objectRows)
        {
            var list = new List<BaseClass>();

            foreach (var row in objectRows)
            {
                var exercise = BuildObject(row);
                list.Add(exercise);
            }

            return list;
        }

        public BaseClass BuildObject(Dictionary<string, object> result)
        {
            var cita = new Cita()
            {
                Id = int.Parse(result["CitaId"].ToString()),
                fkCliente = int.Parse(result["UsuarioId"].ToString()),
                fkEntrenador = int.Parse(result["EntrenadorId"].ToString()),
                fechaInicioCita = DateTime.Parse(result["FechaHora"].ToString()),
                fechaFinCita = DateTime.Parse(result["FechaHoraFin"].ToString()),
                tipoCita = "medicion",
                estado = result["Estado"].ToString(),

            };

            return cita;
        }



        public SqlOperation GetCreateStatement(BaseClass entityDTO)
        {
            SqlOperation operation = new SqlOperation();
            operation.ProcedureName = "dbo.sp_registrarCita";
            Cita cita = (Cita)entityDTO;
            operation.AddIntegerParam("@usuarioID", cita.fkCliente);
            operation.AddIntegerParam("@entrenadorID", cita.fkEntrenador);
            operation.AddDateTimeParam("@fechaInicio", cita.fechaInicioCita);
            operation.AddDateTimeParam("@fechaHoraFin", cita.fechaFinCita);
            operation.AddVarcharParam("@tipoCita", cita.tipoCita);
            operation.AddVarcharParam("@estado", cita.estado);

            return operation;
        }
        //Este metodo no es necesario implementarlo para las citas se resuelve con el update
        public SqlOperation GetDeleteStatement(BaseClass entityDTO)
        {
            /*SqlOperation operation = new SqlOperation();
            operation.ProcedureName = "dbo.sp_modificarCita";
            Cita cita = (Cita)entityDTO;
            operation.AddIntegerParam("@usuarioID", cita.fkCliente);
            operation.AddIntegerParam("@entrenadorID", cita.fkEntrenador);
            operation.AddDateTimeParam("@fechaInicio", cita.fechaInicioCita);
            operation.AddDateTimeParam("@fechaHoraFin", cita.fechaFinCita);
            operation.AddVarcharParam("@tipoCita", cita.tipoCita);
            operation.AddVarcharParam("@estado", cita.estado);
            return operation;*/
            throw new NotImplementedException();
        }

        //Este metodo no es necesario implementarlo para las citas
        public SqlOperation GetRetrieveAllStatement()
        {
            
            throw new NotImplementedException();
        }

        public SqlOperation GetRetrieveByIdStatement(int Id)
        {
            SqlOperation operation = new SqlOperation();
            operation.ProcedureName = "dbo.sp_obtenerCitasAgendadasPorUsuario";
            operation.AddIntegerParam("idUsuario", Id);

            return operation;
        }

        

        public SqlOperation GetUpdateStatement(BaseClass entityDTO)
        {
            SqlOperation operation = new SqlOperation();
            operation.ProcedureName = "dbo.sp_modificarCita";
            Cita cita = (Cita)entityDTO;
            operation.AddIntegerParam("@usuarioID", cita.fkCliente);
            operation.AddIntegerParam("@entrenadorID", cita.fkEntrenador);
            operation.AddDateTimeParam("@fechaInicio", cita.fechaInicioCita);
            operation.AddDateTimeParam("@fechaHoraFin", cita.fechaFinCita);
            operation.AddVarcharParam("@tipoCita", cita.tipoCita);
            operation.AddVarcharParam("@estado", cita.estado);
            return operation;
        }

       
    }
}
