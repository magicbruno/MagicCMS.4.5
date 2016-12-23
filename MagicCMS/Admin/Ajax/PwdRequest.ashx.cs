using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.SessionState;
using MagicCMS.Core;
using MagicCMS.reCAPTCHA;

namespace MagicCMS.Admin.Ajax
{
    /// <summary>
    /// Descrizione di riepilogo per PwdRequest
    /// </summary>
    public class PwdRequest : IHttpHandler, IRequiresSessionState
    {

		public Boolean Captcha { get; set; }
		public string BackEndLang { get; set; }

		public void ProcessRequest(HttpContext context)
        {
            AjaxJsonResponse response = new AjaxJsonResponse
            {
                data = "",
                exitcode = 0,
				msg = Localize.Translate("La nuova password è stata inviata al tuo indirizzo."),
                pk = 0,
                success = true
            };
			Captcha = !(String.IsNullOrEmpty(MagicCMSConfiguration.GetConfig().GoogleCaptchaSite) ||
				String.IsNullOrEmpty(MagicCMSConfiguration.GetConfig().GoogleCaptchaSecret));

			if (Captcha)
			{
				string secret = MagicCMSConfiguration.GetConfig().GoogleCaptchaSecret;
				GoogleReCaptcha grc = new GoogleReCaptcha(secret);
				CaptchaResponse result = grc.ValidateResponse(context.Request.Form["g-recaptcha-response"]);
				if (!result.success)
				{
					context.Response.StatusCode = 404;
					context.Response.StatusDescription = "Not found.";
					context.Response.ContentType = "text/html";
					return;
				}
			}

            string email = context.Request["email"];

            MbUserLoginResult r = MagicUser.ResetPassword(email);

            switch (r)
            {
                case MbUserLoginResult.Success:
                    break;
                case MbUserLoginResult.WrongUserName:
                    response.msg = Localize.Translate("L'utente non risulta registrato");
                    response.exitcode = 1;
                    response.success = false;
                    break;
                case MbUserLoginResult.WrongPassword:
                    response.msg = Localize.Translate("L'utente non risulta registrato");
                    response.exitcode = 1;
                    response.success = false;
                    break;
                case MbUserLoginResult.WrongUserNameOrPassword:
                    response.msg = Localize.Translate("L'utente non risulta registrato");
                    response.exitcode = 1;
                    response.success = false;
                    break;
                case MbUserLoginResult.PasswordResend:
                    break;
                case MbUserLoginResult.NotActivated:
                    response.msg = Localize.Translate("L'utente è stato disattivato");
                    response.exitcode = 2;
                    response.success = false;
                    break;
                case MbUserLoginResult.NotLogged:
                    response.msg = Localize.Translate("L'utente non risulta registrato");
                    response.exitcode = 1;
                    response.success = false;
                    break;
                case MbUserLoginResult.CheckError:
                    response.msg = Localize.Translate("Errore di sitema");
                    response.exitcode = 3;
                    response.success = false;
                    break;
                case MbUserLoginResult.PwdFormatError:
                    break;
                case MbUserLoginResult.GenericError:
					response.msg = Localize.Translate("Errore di sitema. Impossibile copletare l'operazione.");
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