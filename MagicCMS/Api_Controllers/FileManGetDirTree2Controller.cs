using MagicCMS.Core;
using MagicCMS.DirectoryTree;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web;
using System.Web.Http;

namespace MagicCMS.Api_Controllers
{
    public class FileManGetDirTree2Controller : ApiController
    {
        // GET api/<controller>
        public DirNodeChildren Get(string root)
        {

            HttpRequestMessage re = Request;
            string token = re.Headers.Authorization.Parameter;
            UserToken userToken = new UserToken(token);
            if (!userToken.IsExpired)
            {
                string path = HttpContext.Current.Server.MapPath(root); 
                return new DirNodeChildren(path);

            }

            return new DirNodeChildren();
        }

    }
}