using MagicCMS.Core;
using MagicCMS.Routing;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Threading.Tasks;
using System.Web.Http;

namespace MagicCMS.Api_Controllers
{
    public class KeywordsController : ApiController
    {

        // GET api/<controller>/5
        public async Task<AjaxJsonResponse> GetAsync(string k = "", string langId = "")
        {
            AjaxJsonResponse response = new AjaxJsonResponse()
            {
                success = true,
                msg =   "Ok",
                exitcode = 0,
                data = null
            };

            try
            {
                if (string.IsNullOrEmpty(langId))
                    langId = new CMS_Config().TransSourceLangId;

                if (string.IsNullOrEmpty(k))
                    k = string.Empty;

                HttpRequestMessage re = Request;

                string token = re.Headers.Authorization.Parameter;
                UserToken userToken = new UserToken(token);
                if (userToken.IsExpired)
                {
                    throw new Exception("Credenziali di accesso non valide", new AccessViolationException());
                };

                response.data = await MagicKeyword.GetKeywordsAsync(k, langId);


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