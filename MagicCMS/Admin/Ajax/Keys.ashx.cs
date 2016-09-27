using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.SessionState;
using MagicCMS.Core;

namespace MagicCMS.Admin.Ajax
{
    /// <summary>
    /// Descrizione di riepilogo per Keys
    /// </summary>
    public class Keys : IHttpHandler, IRequiresSessionState
    {

        public void ProcessRequest(HttpContext context)
        {
            if (MagicSession.Current.LoggedUser.Level < 4)
            {
                context.Response.StatusCode = 403;
                context.Response.StatusDescription = "Prerogative non sufficienti";
                context.Response.ContentType = "text/html";
                //context.Response.Write("Sessione scaduta.");
                return;
            }

            AjaxJsonResponse response = new AjaxJsonResponse
            {
                data = null,
                exitcode = 0,
                msg = "Operazione conclusa con successo.",
                pk = 0,
                success = true
            };

            string k = context.Request["k"];
            string langId = context.Request["lang"];
            if (String.IsNullOrEmpty(langId))
                langId = MagicSession.Current.CurrentLanguage;

            if (langId == "default")
                langId = new CMS_Config().TransSourceLangId;

            try
            {
                List<string> keywords;
                if (String.IsNullOrEmpty(k))
                    keywords = MagicKeyword.GetKeywords("",langId);
                else
                    keywords = MagicKeyword.GetKeywords(k,langId);
                response.data = keywords;
            }
            catch (Exception e)
            {
                response.success = false;
                response.msg = e.Message;
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