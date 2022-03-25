using MagicCMS.Api_Models;
using MagicCMS.Core;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Security.Authentication;
using System.Threading.Tasks;
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
        public AjaxJsonResponse Get(int id)
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
                HttpRequestMessage re = Request;
                string token = re.Headers.Authorization.Parameter;
                UserToken userToken = new UserToken(token);
                if (userToken.IsExpired)
                {
                    throw new AuthenticationException("Errore di autenticazione: token non valido.");
                }


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
        public async Task<AjaxJsonResponse> PostAsync([FromBody] MagicPostOpParameters op)
        {
            AjaxJsonResponse response = new AjaxJsonResponse()
            {
                exitcode = 0,
                msg = "Ok",
                success = true,
                data = null
            };

            try
            {
                HttpRequestMessage re = Request;
                string token = re.Headers.Authorization.Parameter;
                UserToken userToken = new UserToken(token);

                if (userToken.IsExpired)
                {
                    throw new AuthenticationException("Errore di autenticazione: token non valido.");
                }

                MagicUser user = new MagicUser(userToken.UserPk);
                if (user.Level < 4)
                {
                    throw new AuthenticationException("Errore di autenticazione: prerogative insufficienti.");
                }

                if (op.Operation == LogAction.Unknown)
                {
                    throw new Exception(String.Format("\"{0}\" non è un operazione valida!", op.OperationStr));
                }

                if(op.PkList == null)
                {
                    throw new Exception("Lista post vuota");
                }

                if (op.PkList.Count == 0)
                {
                    throw new Exception("Lista post vuota");
                }
                List<String> errors = new List<string>();
                switch (op.Operation)
                {
                    
                    case LogAction.Delete:
                        foreach (int pk in op.PkList)
                        {
                            string output = await MagicPost.DeleteAsync(pk);
                            if (!String.IsNullOrWhiteSpace(output))
                            {
                                errors.Add(String.Format("{0}: {1}", pk, output));
                            }
                               
                        }
                        break;
                    case LogAction.Insert:
                        throw new Exception("Non ancora implementato");
                        //break;
                    case LogAction.Update:
                        throw new Exception("Non ancora implementato");
                        //break;
                    case LogAction.Read:
                        response.data = new MagicPost(op.PkList[0]);
                        response.pk = op.PkList[0];
                        break;
                    case LogAction.Undelete:
                        throw new Exception("Non ancora implementato");
                        //break;
                    default:
                        break;
                }
                if (errors.Count > 0)
                {
                    throw new Exception(String.Format("Operazione completata con errori: {0}.", String.Join(", ", errors)));
                }
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

    }
}