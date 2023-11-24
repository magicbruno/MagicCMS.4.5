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
            //ServicePointManager.SecurityProtocol = SecurityProtocolType.Tls12;

            CMS_Config config = new CMS_Config();

            if (string.IsNullOrWhiteSpace(from)) from = config.TransSourceLangId;
            string key = config.TransSecretKey;
            string endPoint = $"/api/translate?api-version=3.0&to={to}&from={from}&textType={textType}";
            var options = new RestClientOptions("https://traduci.magiccms.org")
            {
                MaxTimeout = -1,
            };
            var client = new RestClient(options);
            var request = new RestRequest(endPoint, Method.Post);
            request.AddHeader("Ocp-Apim-Subscription-Key", key);
            request.AddHeader("Content-Type", "application/json");
            BingTranslatorRequest bT_Requests = new BingTranslatorRequest(text);
            var body = JsonConvert.SerializeObject(bT_Requests);
            request.AddStringBody(body, DataFormat.Json);
            RestResponse response = await client.ExecuteAsync(request);

            if (response.StatusCode == HttpStatusCode.OK)
            {
                return JsonConvert.DeserializeObject<BingTranslatorResponse>(response.Content);
            }  
            else if (response.ErrorException != null)
            {
                throw response.ErrorException;
            }
            else 
            {
                BingError error = JsonConvert.DeserializeObject<BingError>(response.Content);
                throw new Exception(string.Format("{0} ({1})", error.error.message, error.error.code));
            }
        }

    }
}

