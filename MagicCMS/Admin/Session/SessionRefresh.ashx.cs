using MagicCMS.Core;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace MagicCMS.Admin.Session
{
    /// <summary>
    /// Descrizione di riepilogo per SessionRefresh
    /// </summary>
    public class SessionRefresh : IHttpHandler, System.Web.SessionState.IRequiresSessionState
    {
		public bool Captcha { get; set; }
        public void ProcessRequest(HttpContext context)
        {
            /// <summary>
            /// Risposta ajax impostata su successo
            /// </summary>
            AjaxJsonResponse response = new AjaxJsonResponse
            {
                data = "",
                exitcode = 0,
                msg = "La tua sessione di lavoro è stata estesa.",
                pk = 0,
                success = true
            };

            string email = context.Request["email"];
            string password = context.Request["password"];
            string checkpwd = context.Request["checkpwd"];
            string recaptchaResposne = context.Request.Form["g-recaptcha-response"];
            MagicUser currentUser = MagicSession.Current.LoggedUser;
			// Check if Google recaptcha Site id and Secret Key are define. If not hide recaptcha field.
			Captcha = !(String.IsNullOrEmpty(MagicCMSConfiguration.GetConfig().GoogleCaptchaSite) ||
				String.IsNullOrEmpty(MagicCMSConfiguration.GetConfig().GoogleCaptchaSecret));



            if (!RecaptchaCheck(recaptchaResposne) && Captcha)
            {
                response.success = false;
                response.exitcode = 5;
                response.msg = "L'accesso è riservato solo agli umani. Ripeti il controllo \"Non sono un robot\"";
            } 
            else if (currentUser.LoginResult != MbUserLoginResult.Success)
            {
            //Sessione scaduta
                response.success = false;
                response.exitcode = 1;
                response.msg = "Impossibile recuperare la sessione (sessione non valida).";
            }
            // Password sbagliata
            else if (currentUser.Password != password)
            {
                response.success = false;
                response.exitcode = 2;
                response.msg = "Password errata.";
            }
            // Nome Sbagliato
            else if (currentUser.Email != email)
            {
                response.success = false;
                response.exitcode = 3;
                response.msg = "Nome utente errato.";
            }
            // Rinnovo sessione
            else
            {
                MagicSession.Current.SessionStart = DateTime.Now; 
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

        private bool RecaptchaCheck(string response)
        {
            reCAPTCHA.GoogleReCaptcha gCaptcha = new reCAPTCHA.GoogleReCaptcha(MagicCMSConfiguration.GetConfig().GoogleCaptchaSecret);
            reCAPTCHA.CaptchaResponse resp = gCaptcha.ValidateResponse(response);
            return resp.success;
        }
    }
}