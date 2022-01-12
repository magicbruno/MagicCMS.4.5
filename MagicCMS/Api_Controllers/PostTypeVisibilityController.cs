using MagicCMS.Core;
using MagicCMS.Routing;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace MagicCMS.Api_Controllers
{
    public class PostTypeVisibilityController : ApiController
    {
        // GET api/<controller>
        public IEnumerable<string> Get()
        {
            return new string[] { "value1", "value2" };
        }

        // GET api/<controller>/5
        public string Get(int id)
        {
            MagicPostTypeInfo typeInfo = new MagicPostTypeInfo(id);
            return typeInfo.VisibilityStyles;
        }
    }
}