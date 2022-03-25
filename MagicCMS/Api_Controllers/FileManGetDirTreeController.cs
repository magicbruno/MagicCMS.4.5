using MagicCMS.Core;
using MagicCMS.DirectoryTree;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace MagicCMS.Api_Controllers
{
    public class FileManGetDirTreeController : ApiController
    {
        // GET api/<controller>/5
        public DirTree Get(string root)
        {

            HttpRequestMessage re = Request;
            string token = re.Headers.Authorization.Parameter;
            UserToken userToken = new UserToken(token);
            if (!userToken.IsExpired)
            {

;               return new DirTree(root);

            }

            return new DirTree();
        }


    }
}