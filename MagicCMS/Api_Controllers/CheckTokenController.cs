using MagicCMS.Core;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace MagicCMS.Api_Controllers
{
    public class CheckTokenController : ApiController
    {
        // GET api/<controller>
        public IEnumerable<string> Get()
        {
            return new string[] { "niente", "nulla" };
        }

        // GET api/<controller>/5
        public AjaxJsonResponse Get(string token)
        {
            AjaxJsonResponse response = new AjaxJsonResponse()
            {
                pk = 0,
                exitcode = 0,
                msg = "Ok",
                success = true,
                data = null
            };
            try
            {
                string error = string.Empty;
                UserToken userToken = new UserToken(token);
                if (userToken.IsExpired)
                    throw new Exception("Token scaduto");
                if (!userToken.RefreshToken(out error))
                    throw new Exception("Errore nel rinnovo del token");
                response.data = userToken.Token;
            }
            catch (Exception e)
            {

                response.pk = 0;
                response.exitcode = e.HResult;
                response.msg = e.Message;
                response.success = false;
            }

            return response;
        }

        // POST api/<controller>
        public void Post([FromBody] string value)
        {
        }

        // PUT api/<controller>/5
        public void Put(int id, [FromBody] string value)
        {
        }

        // DELETE api/<controller>/5
        public void Delete(int id)
        {
        }
    }
}