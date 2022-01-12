using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Threading.Tasks;
using System.Web.Http;
using MagicCMS.Core;
using MagicCMS.MagicTranslator;

namespace MagicCMS.Api_Controllers
{
    public class TextTranslatorController : ApiController
    {
        // GET api/<controller>
        public IEnumerable<string> Get()
        {
            return new string[] { "tutto", "e niente" };
        }

        // GET api/<controller>/5
        public string Get(int id)
        {
            return "value";
        }

        // POST api/<controller>
        public async Task<AjaxJsonResponse> PostAsync([FromBody] TranslationWithParams translation)
        {

            AjaxJsonResponse response = new AjaxJsonResponse()
            {
                success = true,
                pk = 0,
                data = null,
                msg = String.Empty,
                exitcode = 0
            };
            try
            {
                HttpRequestMessage re = Request;
                string token = re.Headers.Authorization.Parameter;

                UserToken userToken = new UserToken(token);
                if (userToken.IsExpired)
                    throw new Exception("Token non valido", new AccessViolationException());
                string text = translation.Text;
                if (text.Length > 10000)
                {               
                    if (translation.TextType == "html")
                    {
                        text = StringHtmlExtensions.TruncateHtml(text, 10000);
                        if (text.Length > 10000)
                        {
                            string temp = StringHtmlExtensions.StripHtml(text);
                            int htmlLenght = text.Length - temp.Length;
                            text = StringHtmlExtensions.TruncateHtml(text, 10000 - htmlLenght);
                        }
                    }
                    else
                    {
                        text = StringHtmlExtensions.TruncateWords(text, 10000);
                    };
                    response.success = false;
                    response.msg = "Il testo da tradurre supera i 10000 caratteri: la traduzione verrà troncata!";
                    response.exitcode = -1;
                }

                BingTranslatorResponse translations = await MagicTranslator.BingTranslator.TranslateAsync(text, translation.To, translation.From, translation.TextType.ToString());
                response.data = translations[0].translations[0].text;
            }
            catch (Exception e)
            {

                response.success = false;
                response.msg = e.Message;
                response.exitcode = e.HResult;
            }
            return response;

        }


    }
}