using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.SessionState;
using System.Text.RegularExpressions;
using MagicCMS.Core;

namespace MagicCMS.Admin.Ajax
{
    /// <summary>
    /// Descrizione di riepilogo per PdwChange
    /// Cambia la password dell'utente loggato via ajax
    /// </summary>
    public class PdwChange : IHttpHandler, IRequiresSessionState 
    {
        public void ProcessRequest(HttpContext context)
        {
            /// <summary>
            /// Risposta ajax impostata su successo
            /// </summary>
            AjaxJsonResponse response = new AjaxJsonResponse
            {
                data = "",
                exitcode = 0,
				msg = Localize.Translate("Password modificata con successo."),
                pk = 0,
                success = true
            };

            string oldpwd = context.Request["oldpwd"];
            string pwd = context.Request["pwd"];
            string checkpwd = context.Request["checkpwd"];
            Regex pwdPattern = new Regex("^[A-Za-z0-9#_%&]{6,20}$");
            MagicUser currentUser = MagicSession.Current.LoggedUser;
            //Sessione scaduta
            if (currentUser.LoginResult != MbUserLoginResult.Success)
            {
                response.success = false;
                response.exitcode = 1;
                response.msg = Localize.Translate("Sessione scaduta.");
            }
            // Vecchia password sbagliata
            else if (currentUser.Password != oldpwd)
            {
                response.success = false;
                response.exitcode = 2;
                response.msg = Localize.Translate("Vecchia password errata.");
            }
            // Fallito controllo
            else if (pwd != checkpwd)
            {
                response.success = false;
                response.exitcode = 3;
                response.msg = Localize.Translate("La nuova password inserita non corrisponde a quella inserita per controllo.");
            }
            // Formato sbagliato
            else if (!pwdPattern.IsMatch(pwd))
            {
                response.success = false;
                response.exitcode = 4;
                response.msg = Localize.Translate("Formato password: tra 6 e 20 caratteri, nessun spazio, lettere, numeri e #_%&");
            }
            else
            {
                currentUser.ChangePassword(pwd);
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