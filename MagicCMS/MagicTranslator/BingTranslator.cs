using MagicCMS.Core;
using RestSharp;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Threading.Tasks;
using System.Web;
using Newtonsoft.Json;

namespace MagicCMS.MagicTranslator
{
    public static class BingTranslator
    {
        public static string BingSubscriptionKey
        {
            get
            {
                CMS_Config config = new CMS_Config();
                if (!string.IsNullOrWhiteSpace(config.TransSecretKey))
                    return config.TransSecretKey;
                else if (!string.IsNullOrWhiteSpace(config.TransClientId))
                    return config.TransClientId;
                return string.Empty;
            }
        }

        public static async Task<BingTranslatorResponse> TranslateAsync(string text, string to, string from = "", string textType = "plain")
        {
            ServicePointManager.SecurityProtocol = SecurityProtocolType.Tls12;

            if (string.IsNullOrWhiteSpace(from)) from = new CMS_Config().TransSourceLangId;
            string endPoint = @"https://api.cognitive.microsofttranslator.com/translate?api-version=3.0&to={0}&from={1}&textType={2}";

            RestClient client = new RestClient(string.Format(endPoint, to, from, textType));
            client.Timeout = -1;
            RestRequest request = new RestRequest(Method.POST);;
            request.AddHeader("Ocp-Apim-Subscription-Key", BingSubscriptionKey);
            request.AddHeader("Content-Type", "application/json");
            request.Timeout = -1;

            BingTranslatorRequest bT_Requests = new BingTranslatorRequest(text);

            System.Web.Script.Serialization.JavaScriptSerializer serializer = new System.Web.Script.Serialization.JavaScriptSerializer();
            string body = serializer.Serialize(bT_Requests);
            //request.Body = new RequestBody("application/json","body",body);
            request.AddParameter("application/json", body,  ParameterType.RequestBody);
            var response = await client.ExecuteAsync(request);
            if (response.StatusCode == HttpStatusCode.OK)
                return JsonConvert.DeserializeObject<BingTranslatorResponse>(response.Content);
            else
            {
                BingError error = JsonConvert.DeserializeObject<BingError>(response.Content);
                throw new Exception(string.Format("{0} ({1})", error.error.message, error.error.code));
            }    
        }

    }
}

