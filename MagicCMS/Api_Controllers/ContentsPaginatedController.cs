using MagicCMS.Core;
using MagicCMS.DataTable;
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
    public class ContentsPaginatedController : ApiController
    {
        // GET api/<controller>
        public IEnumerable<string> Get()
        {
            return new string[] { "value1", "value2" };
        }



        // POST api/<controller>
        public async Task<OutputParams_dt> PostAsync([FromBody] FormDataCollection form, int parent_id = 0)
        {
            HttpRequestMessage re = Request;
            string token = re.Headers.Authorization.Parameter;
            UserToken userToken = new UserToken(token);
            if (userToken.IsExpired)
                return new OutputParams_dt()
                {
                    draw = 0,
                    recordsFiltered = 0,
                    recordsTotal = 0,
                    data = new { }
                };
            InputParams_dt inputParams = new InputParams_dt(form);
            OutputParams_dt output = await MpForTable.GelTablesRows(parent_id, inputParams);
            return output;

        }


    }
}