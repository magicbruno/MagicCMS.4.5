using MagicCMS.Core;
using RestSharp;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Threading.Tasks;
using System.Web.Http;
using Newtonsoft.Json;
using System.Reflection;
using MagicCMS.MagicTranslator;

namespace MagicCMS.Api_Controllers
{
    public class TranslationLanguagesController : ApiController
    {
        // GET api/<controller>
        public async Task<AjaxJsonResponse> GetAsync()
        {
            AjaxJsonResponse response = new AjaxJsonResponse()
            {
                success = true,
                msg = "Ok",
                exitcode = 0,
                data = null
            };

            try
            {
                ServicePointManager.Expect100Continue = true;
                ServicePointManager.SecurityProtocol = SecurityProtocolType.SystemDefault;
                //List<KeyValuePair<string, string>> data = new List<KeyValuePair<string, string>>();
                //var client = new RestClient("https://api.cognitive.microsofttranslator.com/languages?api-version=3.0&scope=translation");
                //client.Timeout = -1;
                //var request = new RestRequest(Method.GET);
                //IRestResponse r = await client.ExecuteAsync(request);
                //response.data = r;
                //BingLanguageList langs = JsonConvert.DeserializeObject<BingLanguageList>(r.Content);
                //Newtonsoft.Json.Linq.JObject list = langs.translation as Newtonsoft.Json.Linq.JObject;
                //foreach (var item in list)
                //{
                //    var obj = item.Value.First();
                //    data.Add(new KeyValuePair<string, string>(item.Key, obj.First.ToString()));
                //}
                 RestClientOptions options = new RestClientOptions("https://api.cognitive.microsofttranslator.com")
                {
                    MaxTimeout = -1,
                };
                var client = new RestClient(options);
                var request = new RestRequest("/languages?api-version=3.0&scope=translation", Method.Get);
                RestResponse r = await client.ExecuteAsync(request);
                //Console.WriteLine(r.Content);

                response.data = r;
                //Type type = list.GetType();
                //PropertyInfo[] properties = type.GetProperties();
                //foreach (PropertyInfo property in properties)
                //{
                //    data.Add(property.Name, property.GetValue(list, null));
                //}

            }
            catch (Exception e)
            {
                response.success = false;
                response.msg = e.Message;
                response.exitcode = e.HResult;
            }
            return response;
        }


    }
}