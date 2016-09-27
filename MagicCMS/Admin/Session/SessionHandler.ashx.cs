using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.SessionState;
using MagicCMS.Core;

namespace MagicCMS.Admin.Session
{
    /// <summary>
    /// Descrizione di riepilogo per SessionHandler. Gestione personalizzate della scadenza di Sessione.
    /// </summary>
    public class SessionHandler : IHttpHandler, IRequiresSessionState
    {

        public void ProcessRequest(HttpContext context)
        {
            AjaxJsonResponse response = new AjaxJsonResponse
            {
                exitcode = 0,
                msg = "Sessione attiva.",
                success = true
            };

            //sessione scaduta
            if (MagicSession.Current.LoggedUser.LoginResult != MbUserLoginResult.Success)
            {
                response.success = false;
                response.msg = "Sessione scaduta. È necessario ripetere il login";
                response.exitcode = -1;

            }
            else
            {
                int expiretime = Convert.ToInt32((DateTime.Now - MagicSession.Current.SessionStart).TotalSeconds);
                if (expiretime > 3600)
                {
                    response.success = false;
                    response.msg = "Sessione scaduta. È necessario ripetere il login";
                    response.exitcode = -1;
                    MagicSession.Current.LoggedUser = new MagicUser();
                }
                else if (expiretime > 3480)
                {
                    int remaining = 3600 - expiretime;
                    response.data = remaining;
                    response.success = true;
                    response.msg = "Attenzione: " + (remaining / 60).ToString() + " minuti e " + (remaining % 60).ToString() + " secondi alla fine della sessione. Salva il lavoro e preparati a ripetere il login";
                    response.exitcode = 1;
                }
                else
                {
                    response.data = 3600 - expiretime;
                }
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