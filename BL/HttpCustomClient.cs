using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http.Json;
using System.Text;
using System.Threading.Tasks;
using BL.EnPointsLogic;
namespace BL
{
    public class HttpCustomClient
    {
        private readonly EndPointsManager emanager;
        //private  HttpClient client;
        private string requestAddress;
        private static readonly HttpClient client = new()
        {
            BaseAddress = new Uri("http://localhost:5274/")
      
        };
       /*  public HttpCustomClient(){
            
        }
        public HttpCustomClient(EndPointsManager _emanager){
            client = new();
            emanager = _emanager;
            requestAddress = emanager.getBaseUrl("api");
             client.BaseAddress = new Uri("http://localhost:5274/");
        }
         */


        public async Task<string> post(string endPointUrl, HttpContent body)
        {
            //await client.PostAsJsonAsync(endPointUrl, body);
            using HttpResponseMessage response = await client.PostAsync(endPointUrl, body);
            string responseString = await response.Content.ReadAsStringAsync();
            return responseString;
        }

        public async Task<string> put(string endPointUrl, HttpContent body)
        {
            //await client.PostAsJsonAsync(endPointUrl, body);
            using HttpResponseMessage response = await client.PutAsync(endPointUrl, body);
            string responseString = await response.Content.ReadAsStringAsync();
            return responseString;
        }

        public async Task<string> get(string endPointUrl)
        {
            using HttpResponseMessage response = await client.GetAsync(endPointUrl);
            string responseString = await response.Content.ReadAsStringAsync();
            // Deserializar el JSON a una lista de objetos BebidaResumen
            return responseString;
        }
    }
}
