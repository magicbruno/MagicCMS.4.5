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
    public class LogPaginatedAsyncController : ApiController
    {
        // GET api/<controller>/id
        public MagicLog Get(int id)
        {
            HttpRequestMessage re = Request;
            string token = re.Headers.Authorization.Parameter;
            UserToken userToken = new UserToken(token);
            if (userToken.IsExpired)
                return new MagicLog(0);

            return new MagicLog(id);
        }

        public async Task<OutputParams_dt> PostAsync([FromBody] FormDataCollection form, bool onlyError = false)
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
            OutputParams_dt output = await MagicLog.GetTablesRowsAsync(onlyError,inputParams);
            return output;

        }
    }
}