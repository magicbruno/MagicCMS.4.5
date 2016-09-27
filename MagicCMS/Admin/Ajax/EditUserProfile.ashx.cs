using MagicCMS.Core;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.SessionState;

namespace MagicCMS.Admin.Ajax
{
    /// <summary>
    /// Descrizione di riepilogo per EditUserProfile
    /// </summary>
    public class EditUserProfile : IHttpHandler, IRequiresSessionState
    {

        public void ProcessRequest(HttpContext context)
        {
            MagicUser currentUser = MagicSession.Current.LoggedUser;
            if (currentUser.Level == 0)
            {
                context.Response.StatusCode = 403;
                context.Response.StatusDescription = "Sessione non valida o prerogative insufficienti.";
                context.Response.ContentType = "text/html";
                //context.Response.Write("Sessione scaduta.");
                return;
            }

            //Oggetto json restituito dal modulo
            AjaxJsonResponse response = new AjaxJsonResponse
            {
                data = null,
                exitcode = 0,
                msg = "Operazione conclusa con successo.",
                pk = currentUser.Pk,
                success = true
            };
            string userFirstName = context.Request["userFirstName"];
            string userLastName = context.Request["userLastName"];
            string name = userFirstName + (!String.IsNullOrEmpty(userLastName) ? " " + userLastName : "");

            if (String.IsNullOrEmpty(name))
            {
                response.exitcode = 1;
                response.success = false;
                response.msg = "È necessario inserire al meno il nome o il cognome.";
            }
            else
            {
                try 
	            {	        
                    currentUser.Name = name;
                    if (!currentUser.Update())
                    {
                        response.exitcode = 2;
                        response.success = false;
                        response.msg = "Impossibile salvare la modifica.";
                    }
		
	            }
	            catch (Exception e)
	            {
                    response.exitcode = 100;
                    response.success = false;
                    response.msg = "Errore del server: " + e.Message;
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