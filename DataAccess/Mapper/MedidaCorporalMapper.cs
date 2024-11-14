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
            var medidaCorporal = new MedidaCorporal();
            /*{
                Id= int.Parse(result["medidaId"].ToString()),
                peso= double.Parse(result["peso"].ToString()),
                altura = double.Parse(result["altura"].ToString()),
                fkUsuario = int.Parse(result["fkUsuario"].ToString()),
                imc = double.Parse(result["imc"].ToString()),
                edad = int.Parse(result["edad"].ToString()),
                genero = result["genero"].ToString()
                
            };*/

            return medidaCorporal;
        }



        public SqlOperation GetCreateStatement(BaseClass entityDTO)
        {
            SqlOperation operation = new SqlOperation();
            operation.ProcedureName = "dbo.sp_registrarMedida";
            MedidaCorporal medidaCorporal = (MedidaCorporal)entityDTO;
            operation.AddIntegerParam("@fkUsuario", medidaCorporal.fkUsuario);
            operation.AddDecimalParam("@peso", medidaCorporal.peso);
            operation.AddDecimalParam("@altura", medidaCorporal.altura);
            operation.AddDecimalParam("@imc", medidaCorporal.imc);
            operation.AddIntegerParam("@edad", medidaCorporal.edad);
            operation.AddVarcharParam("@genero", medidaCorporal.genero);

            return operation;
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
