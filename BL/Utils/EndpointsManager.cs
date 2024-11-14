using Microsoft.Extensions.Configuration;
using Microsoft.AspNetCore.Http;

namespace BL.EnPointsLogic{
    
    public class EndPointsManager
    {
         
         private readonly IConfiguration config;
         private readonly IHttpContextAccessor _httpAccessor; 
        public EndPointsManager(IConfiguration configuration,IHttpContextAccessor httpAccesor){
            config=configuration;
            _httpAccessor =httpAccesor;
        }

        public string getBaseUrl(){
            string baseUrl = config["EndPoints:ssl"];
             if(!_httpAccessor.HttpContext.Request.IsHttps){
             baseUrl = config["EndPoints:nossl"];
            }
            return baseUrl; 
        }

    }
}
