using MagicCMS.Core;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.SessionState;

namespace MagicCMS.Admin.Ajax
{
    /// <summary>
    /// Descrizione di riepilogo per GetThemeMasters
    /// </summary>
    public class GetThemeMasters : IHttpHandler, IRequiresSessionState
    {

        public void ProcessRequest(HttpContext context)
        {
            if (MagicSession.Current.LoggedUser.Level < 1)
            {
                context.Response.StatusCode = 403;
                context.Response.StatusDescription = "Prerogative non sufficienti";
                context.Response.ContentType = "text/html";
                //context.Response.Write("Sessione scaduta.");
                return;
            }

            string k = context.Request["k"];                    // Stringa di ricerca

            List<MagicCmsSelect2> lista = new List<MagicCmsSelect2>();
            CMS_Config config = new CMS_Config();

            string themePath = config.ThemePath.TrimEnd(new char[] { '/' }) + "/";

            if (Directory.Exists(context.Server.MapPath(themePath)))
            {
                DirectoryInfo di = new DirectoryInfo(context.Server.MapPath(themePath));
                FileInfo[] masterFiles = di.GetFiles("*.master");

                for (int i = 0; i < masterFiles.Length; i++)
                {
                    lista.Add(new MagicCmsSelect2() { id = masterFiles[i].Name, Pk = 0, text = masterFiles[i].Name });
                }
            }

            System.Web.Script.Serialization.JavaScriptSerializer serializer = new System.Web.Script.Serialization.JavaScriptSerializer();
            string json = serializer.Serialize(lista);
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