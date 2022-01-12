using MagicCMS.Core;
using MagicCMS.MagicTranslator;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Threading.Tasks;
using System.Web.Http;

namespace MagicCMS.Api_Controllers
{
    public class PostTranslatorController : ApiController
    {
        // GET api/<controller>
        public IEnumerable<string> Get()
        {
            return new string[] { "value1", "value2" };
        }


        // POST api/<controller>
        public async Task<PostTranslationResponse> PostAsync([FromBody] PostTranslation daTradurre)
        {

            PostTranslationResponse response = new PostTranslationResponse()
            {
                Title = new PT_response(),
                TestoBreve = new PT_response(),
                TestoLungo = new PT_response(),
                Tags = new PT_response(),
                Error = string.Empty,
                Success = true
            };

            try
            {
                HttpRequestMessage re = Request;
                string token = re.Headers.Authorization.Parameter;

                UserToken userToken = new UserToken(token);
                if (userToken.IsExpired)
                    throw new Exception("Token non valido", new AccessViolationException());
                string text;

                // Traduzione titolo
                text = daTradurre.Title;
                response.Title.OriginalLength = text.Length;
                if (text.Length > 1000)
                {
                    text = StringHtmlExtensions.TruncateWords(text, 1000);
                    response.Title.Error = "Il titolo da tradurre supera i 1000 caratteri: la traduzione verrà troncata!";
                    response.Title.Success = false;
                }              
                response.Title.TranslatedLength = text.Length;

                BingTranslatorResponse translations = await MagicTranslator.BingTranslator.TranslateAsync(text, daTradurre.To, daTradurre.From, "plain");
                if (translations != null)
                    response.Title.Translation = translations[0].translations[0].text;
                else
                {
                    response.Title.Error = "Errore imprevisto";
                    response.Title.Success = false;
                }

                // Traduzionr Testo Breve
                text = daTradurre.TestoBreve;
                response.TestoBreve.OriginalLength = text.Length;
                if (text.Length > 10000)
                {

                    text = StringHtmlExtensions.TruncateHtml(text, 10000);
                    response.TestoBreve.Success = false;
                    response.TestoBreve.Error = "Il testo da tradurre supera i 10000 caratteri: la traduzione verrà troncata!";

                }
                response.TestoBreve.TranslatedLength = text.Length;

                translations = await MagicTranslator.BingTranslator.TranslateAsync(daTradurre.TestoBreve,daTradurre.To, daTradurre.From, "html");

                if (translations != null)
                    response.TestoBreve.Translation = translations[0].translations[0].text;
                else
                {
                    response.TestoBreve.Error = "Errore imprevisto";
                    response.TestoBreve.Success = false;
                }

                // Traduzione testo lungo
                text = daTradurre.TestoLungo;
                response.TestoLungo.OriginalLength = text.Length;
                if (text.Length > 10000)
                {

                    text = StringHtmlExtensions.TruncateHtml(text, 10000);
                    response.TestoLungo.Success = false;
                    response.TestoLungo.Error = "Il testo da tradurre supera i 10000 caratteri: la traduzione verrà troncata!";

                }
                response.TestoLungo.TranslatedLength = text.Length;

                translations = await MagicTranslator.BingTranslator.TranslateAsync(daTradurre.TestoLungo, daTradurre.To, daTradurre.From, "html");

                if (translations != null)
                    response.TestoLungo.Translation = translations[0].translations[0].text;
                else
                {
                    response.TestoLungo.Error = "Errore imprevisto";
                    response.TestoLungo.Success = false;
                }

                // Traduzione tags
                text = daTradurre.Tags;
                response.Tags.OriginalLength = text.Length;
                if (text.Length > 1000)
                {
                    text = StringHtmlExtensions.TruncateWords(text, 1000);
                    response.Tags.Error = "Il titolo da tradurre supera i 1000 caratteri: la traduzione verrà troncata!";
                    response.Tags.Success = false;
                }
                response.Tags.TranslatedLength = text.Length;

                translations = await MagicTranslator.BingTranslator.TranslateAsync(text, daTradurre.To, daTradurre.From, "plain");
                if (translations != null)
                    response.Tags.Translation = translations[0].translations[0].text;
                else
                {
                    response.Tags.Error = "Errore imprevisto";
                    response.Tags.Success = false;
                }



                response.Error = string.Format(@"   <table class=""table"">
                                                        <thead>
                                                            <tr>
                                                                <th scope=""col"">&nbsp;</th>
                                                                <th scope=""col"">Originale</th>
                                                                <th scope=""col"">Tradotta</th>
                                                                <th scope=""col"">Esito</th>
                                                            </tr>
                                                        </thead>
                                                        <tbody>
                                                            <tr>
                                                                <th scope=""row"">Titolo</th>
                                                                <td>{0}</td>
                                                                <td>{1}</td>
                                                                <td>{2}</td>
                                                            </tr>
                                                            <tr>
                                                                <th scope=""row"">Testo breve</th>
                                                                <td>{3}</td>
                                                                <td>{4}</td>
                                                                <td>{5}</td>
                                                            </tr>
                                                            <tr>
                                                                <th scope=""row"">Testo lungo</th>
                                                                <td>{6}</td>
                                                                <td>{7}</td>
                                                                <td>{8}</td>
                                                            </tr>
                                                            <tr>
                                                                <th scope=""row"">Tagso</th>
                                                                <td>{9}</td>
                                                                <td>{10}</td>
                                                                <td>{11}</td>
                                                            </tr>
                                                        </tbody>
                                                    </table>", response.Title.OriginalLength, response.Title.TranslatedLength, response.Title.Error,
                                                    response.TestoBreve.OriginalLength, response.TestoBreve.TranslatedLength, response.TestoBreve.Error,
                                                    response.TestoLungo.OriginalLength, response.TestoLungo.TranslatedLength, response.TestoLungo.Error,
                                                    response.Tags.OriginalLength, response.Tags.TranslatedLength, response.Tags.Error);
            }
            catch (Exception e)
            {

                response.Success = false;
                response.Error = string.Format("{0} ({1})", e.Message, e.HResult);
            }
            return response;

        }



    }
}