using MagicCMS.Core;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Threading.Tasks;
using System.Web.Http;

namespace MagicCMS.Api_Controllers
{
    public class UserCsvAsyncController : ApiController
    {
        // GET api/<controller>
        public async Task<HttpResponseMessage> GetAsync(string k)
        {
            //HttpRequestMessage re = Request;
            ////string token = re.Headers.Authorization.Parameter;
            //if (string.IsNullOrEmpty(token))
            string token = k;

            UserToken userToken = new UserToken(token);
            if(userToken.IsExpired)
                return new HttpResponseMessage(HttpStatusCode.Unauthorized);
            HttpResponseMessage response = null;
            try
            {
                MagicUserCollection userCollection = await MagicUser.GetUsersAsync();
                MemoryStream stream = new MemoryStream();
                StreamWriter sw = new StreamWriter(stream);
                sw.WriteLine("{0};{1};{2};{3};{4}", "Id", "Nome", "EMail", "Prerogative", "Attivo");

                foreach (MagicUser user in userCollection)
                {
                    sw.WriteLine(String.Format("{0};{1};{2};{3};{4}", user.Pk, user.Name, user.Email, user.LevelDescription, user.Active));
                }
                
                stream.Seek(0, SeekOrigin.Begin);
                response = new HttpResponseMessage(HttpStatusCode.OK);

                response.Content = new StreamContent(stream);
                response.Content.Headers.ContentDisposition = new System.Net.Http.Headers.ContentDispositionHeaderValue("attachment");
                response.Content.Headers.ContentDisposition.FileName = "Utenti.csv";
                response.Content.Headers.ContentType = new MediaTypeHeaderValue("text/csv");
            }
            catch (Exception )
            {
               response = new HttpResponseMessage(HttpStatusCode.InternalServerError);
            }

            return response;
        }


    }
}