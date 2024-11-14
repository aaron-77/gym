using DataAccess.DAO;
using DTO.Dtos;


namespace DataAccess.Mapper
{
    public class ExerciseMapper : ICrudStatements, IObjectMapper

    {

        public List<BaseClass> BuildObjects(List<Dictionary<string, object>> objectRows)
        {
            var list = new List<BaseClass>();
            
            foreach( var row in objectRows)
            {
                var exercise = BuildObject(row);
                list.Add(exercise);
            }

            return list;
        }

        public BaseClass BuildObject(Dictionary<string, object> result)
        {
            var Exercise = new Exercise()
            {
                Id = int.Parse(result["Id"].ToString()),
                Name = result["Nombre"].ToString(),
                Description = result["Descripcion"].ToString(),
                PrimaryMuscle = result["Musculo_Primario"].ToString(),
                Type = result["Tipo"].ToString(),
                Difficulty = result["Dificultad"].ToString(),
            };

            return Exercise;
        }



        public SqlOperation GetCreateStatement(BaseClass entityDTO)
        {
            SqlOperation operation = new SqlOperation();
            operation.ProcedureName = "dbo.sp_addEjercicio";

            Exercise Exercise = (Exercise)entityDTO;

            operation.AddVarcharParam("Nombre", Exercise.Name);
            operation.AddVarcharParam("Musculo_Primario", Exercise.PrimaryMuscle);
            operation.AddVarcharParam("Descripcion", Exercise.Description);
            operation.AddVarcharParam("Dificultad", Exercise.Difficulty);
            operation.AddVarcharParam("Tipo", Exercise.Type);

            return operation;
        }

        public SqlOperation GetDeleteStatement(BaseClass entityDTO)
        {
            throw new NotImplementedException();
        }

        public SqlOperation GetRetrieveAllStatement()
        {
            SqlOperation operation = new SqlOperation();
            operation.ProcedureName = "dbo.sp_getAllExercises";

            return operation;
        }

        public SqlOperation GetRetrieveByIdStatement(int Id)
        {
            SqlOperation operation = new SqlOperation();
            operation.ProcedureName = "dbo.sp_getEjercicio";

            operation.AddIntegerParam("Id", Id);

            return operation;
        }

        public SqlOperation GetRetrieveByMuscle(string muscle)
        {
            SqlOperation operation = new SqlOperation();
            operation.ProcedureName = "dbo.sp_getExercisesByMuscle";

            operation.AddVarcharParam("Musculo_Primario", muscle);

            return operation;
        }

        public SqlOperation GetUpdateStatement(BaseClass entityDTO)
        {
            throw new NotImplementedException();
        }
    }
}
