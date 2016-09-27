using MagicCMS.Core;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.SessionState;

namespace MagicCMS.Admin.Ajax
{
    /// <summary>
    /// Descrizione di riepilogo per LangActivate
    /// </summary>
    public class LangActivate : IHttpHandler, IRequiresSessionState
    {

        public void ProcessRequest(HttpContext context)
        {
            if (MagicSession.Current.LoggedUser.Level < 10)
            {
                context.Response.StatusCode = 403;
                context.Response.StatusDescription = "Prerogative non sufficienti";
                context.Response.ContentType = "text/html";
                return;
            }
            string langId, message = "Operazione conclusa con successo.";
            Boolean active, autohide;
            langId = context.Request["langId"];
            AjaxJsonResponse response = new AjaxJsonResponse
            {
                exitcode = 0,
                msg = "Operazione conclusa con successo.",
                pk = 0,
                success = true
            };

            if ((Boolean.TryParse(context.Request["active"], out active)) && Boolean.TryParse(context.Request["autohide"], out autohide) && (!String.IsNullOrEmpty(langId)))
            {
                MagicLanguage ml = new MagicLanguage(langId);
                ml.Active = active;
                ml.AutoHide = autohide;
                response.success = ml.Save(out message);
                response.msg = message;
                response.exitcode = response.success ? 0 : 1;
            }
            else
            {
                response.success = false;
                response.msg = "Dati insufficienti o incoerenti";
                response.exitcode = 2;
            }
            response.data = new MagicLanguageCollection();

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