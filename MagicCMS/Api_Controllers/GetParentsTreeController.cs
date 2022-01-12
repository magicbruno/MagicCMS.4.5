using MagicCMS.Core;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Threading.Tasks;
using System.Web.Http;

namespace MagicCMS.Api_Controllers
{
    public class GetParentsTreeController : ApiController
    {

        // GET api/<controller>/5
        public async Task<JTreeNodeCollection> Get(int pk, int parent)
        {

            HttpRequestMessage re = Request;
            string token = re.Headers.Authorization.Parameter;

            UserToken userToken = new UserToken(token);
            JTreeNodeCollection nodes = new JTreeNodeCollection();
            if (!userToken.IsExpired)
            {

                MagicPost mp = new MagicPost(pk);
                JTreeInfoList jtree = await JTreeInfoList.CreateAsync();
                nodes.AddNodeList(jtree, 0, pk, mp.Parents);

            }
            return nodes;
        }


    }
}