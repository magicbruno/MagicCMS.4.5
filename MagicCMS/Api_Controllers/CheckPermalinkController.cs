using MagicCMS.Core;
using MagicCMS.Routing;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Net.Http.Formatting;
using System.Threading.Tasks;
using System.Web.Http;

namespace MagicCMS.Api_Controllers
{
    public class CheckPermalinkController : ApiController
    {
        // GET api/<controller>
        public IEnumerable<string> Get()
        {
            return new string[] { "value1", "value2" };
        }


        // POST api/<controller>
        public async Task<AjaxJsonResponse> PostAsync([FromBody] FormDataCollection form)
        {
            AjaxJsonResponse response = null;
            int.TryParse(form["pk"], out int pk);
            //string token = form["k"];
            string title = form["title"];
            string lang = form["lang"];            
            try
            {
                HttpRequestMessage re = Request;
                string token = re.Headers.Authorization.Parameter;
                
                UserToken userToken = new UserToken(token);
                if (userToken.IsExpired)
                    throw new Exception("Token non valido", new AccessViolationException());
                if (string.IsNullOrWhiteSpace(lang))
                    lang = new CMS_Config().TransSourceLangId;

                response = await MagicIndex.CheckTitle(title, pk, lang);
            }
            catch (Exception e)
            {

                response = new AjaxJsonResponse()
                {
                    success = false,
                    msg = e.Message,
                    pk = pk,
                    exitcode = e.HResult
                };
            }
            return response;
        }


    }
}