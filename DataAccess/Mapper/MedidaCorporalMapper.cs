using DataAccess.DAO;
using DTO.Dtos;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DataAccess.Mapper
{
    public class MedidaCorporalMapper: ICrudStatements, IObjectMapper
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
            //var medidaCorporal = new DTOMedida();
            /*{
                Id= int.Parse(result["medidaId"].ToString()),
                peso= double.Parse(result["peso"].ToString()),
                altura = double.Parse(result["altura"].ToString()),
                fkUsuario = int.Parse(result["fkUsuario"].ToString()),
                imc = double.Parse(result["imc"].ToString()),
                edad = int.Parse(result["edad"].ToString()),
                genero = result["genero"].ToString()
                
            };*/

            return null;
        }



        public SqlOperation GetCreateStatement(BaseClass entityDTO)
        {
            /*
            SqlOperation operation = new SqlOperation();
            operation.ProcedureName = "dbo.sp_registrarMedida";
            DTOMedida medida = (DTOMedida)entityDTO;
            operation.AddIntegerParam("@unidadDeMedidaId", medida.unidadDeMedidaId);
            operation.AddIntegerParam("@fkUsuario", medida.fkUsuario);
            operation.AddIntegerParam("@fkParametro", medida.fkParametro);
            operation.AddVarcharParam("@nombreParametro", medida.nombreParametro);
            operation.AddDecimalParam("@valor", medida.valor);
            return operation;
            */
            return null;
        }
        //Este metodo no es necesario implementarlo para las citas se resuelve con el update
        public SqlOperation GetDeleteStatement(BaseClass entityDTO)
        {
            throw new NotImplementedException();
        }

        //Este metodo no es necesario implementarlo para las medidas, todas se consultan por usuario
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
