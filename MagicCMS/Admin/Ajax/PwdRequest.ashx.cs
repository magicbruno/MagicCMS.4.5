using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.SessionState;
using MagicCMS.Core;

namespace MagicCMS.Admin.Ajax
{
    /// <summary>
    /// Descrizione di riepilogo per PwdRequest
    /// </summary>
    public class PwdRequest : IHttpHandler, IRequiresSessionState
    {

        public void ProcessRequest(HttpContext context)
        {
            AjaxJsonResponse response = new AjaxJsonResponse
            {
                data = "",
                exitcode = 0,
                msg = "La nuova password è stata inviata al tuo indirizzo.",
                pk = 0,
                success = true
            };

            string email = context.Request["email"];

            MbUserLoginResult r = MagicUser.ResetPassword(email);

            switch (r)
            {
                case MbUserLoginResult.Success:
                    break;
                case MbUserLoginResult.WrongUserName:
                    response.msg = "L'utente non risulta registrato";
                    response.exitcode = 1;
                    response.success = false;
                    break;
                case MbUserLoginResult.WrongPassword:
                    response.msg = "L'utente non risulta registrato";
                    response.exitcode = 1;
                    response.success = false;
                    break;
                case MbUserLoginResult.WrongUserNameOrPassword:
                    response.msg = "L'utente non risulta registrato";
                    response.exitcode = 1;
                    response.success = false;
                    break;
                case MbUserLoginResult.PasswordResend:
                    break;
                case MbUserLoginResult.NotActivated:
                    response.msg = "L'utente è stato disattivato";
                    response.exitcode = 2;
                    response.success = false;
                    break;
                case MbUserLoginResult.NotLogged:
                    response.msg = "L'utente non risulta registrato";
                    response.exitcode = 1;
                    response.success = false;
                    break;
                case MbUserLoginResult.CheckError:
                    response.msg = "Errore di sitema";
                    response.exitcode = 3;
                    response.success = false;
                    break;
                case MbUserLoginResult.PwdFormatError:
                    break;
                case MbUserLoginResult.GenericError:
                    response.msg = "Errore di sitema. Impossibile copletare l'operazione.";
                    response.exitcode = 3;
                    response.success = false;
                    break;
                case MbUserLoginResult.Activated:
                    break;
                default:
                    break;
            }
            System.Web.Script.Serialization.JavaScriptSerializer serializer = new System.Web.Script.Serialization.JavaScriptSerializer();
            string json = serializer.Serialize(response);

            context.Response.ContentType = "application/json";
            context.Response.Charset = "UTF-8";
            context.Response.Write(json);
        }

        public bool IsReusable
        {
            get
            {
                return false;
            }
        }
    }
}