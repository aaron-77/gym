using DataAccess.EntityFramework;
using Microsoft.EntityFrameworkCore;
using Quartz;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BL.BackGroundWork.Jobs
{
     
    public class RemaindersAppoinments : IJob
    {
        private readonly FitnessCenterDbContext _db;
        private readonly EmailManager _emailManager;
        public RemaindersAppoinments(FitnessCenterDbContext dbP,EmailManager emP ) {
            _db = dbP;
            _emailManager = emP;
        }
        public async Task Execute(IJobExecutionContext context)
        {
            try {
                 var usuariosParaNotificar = await _db.correosSP.FromSqlInterpolated($@"sp_consultarUsuariosProximosAcita").ToListAsync();

                foreach (var usuarioANotificar in usuariosParaNotificar)
                {
                    var emailToSend = _emailManager.buildHtmlEmail(usuarioANotificar.correo, "¡Te toca cita!", "recuerda acudir a tu cita el dia " + usuarioANotificar.fechaCita);
                    await _emailManager.sendEmail(emailToSend);
                }
            } catch (Exception ex) { 
                Console.WriteLine(ex.Message);
            }
        }
    }
}
