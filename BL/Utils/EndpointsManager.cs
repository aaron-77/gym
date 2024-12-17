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

        public string getBaseUrl(string typeUrl){
            string baseUrl = config["EndPoints:api:ssl"];
             if(typeUrl == "frontend"){
                baseUrl =config["EndPoints:frontend:ssl"];
             }  
             if(!_httpAccessor.HttpContext.Request.IsHttps){
                baseUrl = config["EndPoints:nossl"];
                if(typeUrl == "frontend"){
                    baseUrl =config["EndPoints:frontend:nossl"];
                }
             
            }
            return baseUrl; 
        }

    }
}
