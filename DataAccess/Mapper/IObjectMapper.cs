using DTO.Dtos;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DataAccess.Mapper
{
    public interface IObjectMapper
    {
        BaseClass BuildObject(Dictionary<string, object> objectRows);
        List<BaseClass> BuildObjects(List<Dictionary<string, object>> objectRows);
    }
}
