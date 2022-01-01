using MagicCMS.Core;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace MagicCMS.Api_Controllers
{
    public class MagicPostController : ApiController
    {
        // GET api/<controller>
        public IEnumerable<string> Get()
        {
            return new string[] { "value1", "value2" };
        }

        // GET api/<controller>/5
        public AjaxJsonResponse GetAsync(int id)
        {
            AjaxJsonResponse response = new AjaxJsonResponse()
            {
                pk = id,
                exitcode = 0,
                msg = "Ok",
                success = true,
                data = null
            };
            try
            {
                response.data = new MagicPost(id);
            }
            catch (Exception e)
            {

                response.success = false;
                response.msg = e.Message;
                response.data = e.StackTrace;
                response.exitcode = 500;            
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