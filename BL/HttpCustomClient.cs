using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http.Json;
using System.Text;
using System.Threading.Tasks;
using BL.EnPointsLogic;
using System.Net.Http;
using Microsoft.Extensions.DependencyInjection; // Add this for IHttpClientFactory
namespace BL
{
    public class HttpCustomClient
    {
        private readonly EndPointsManager emanager;
        //private  HttpClient client;
        private string requestAddress;
        private readonly HttpClient client;

        public HttpCustomClient(HttpClient _client)
        {
            client = _client;
        }
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
            try
            {
                using HttpResponseMessage response = await client.GetAsync(endPointUrl);
                var content = await response.Content.ReadAsStringAsync();
                Console.WriteLine(content);
                    if (response.IsSuccessStatusCode)
                {
                    string responseString = await response.Content.ReadAsStringAsync();
                    return responseString;
                }
                else
                {
                    Console.WriteLine($"Error: {response.StatusCode}");
                    return null;
                }
            }
            catch (HttpRequestException e)
            {
                Console.WriteLine($"Request error: {e.Message}");
                return null;
            }
        }
    }
}
