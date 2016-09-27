using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.SessionState;
using MagicCMS.Core;
using System.Text.RegularExpressions;
using System.IO;

namespace MagicCMS.Admin.Ajax
{
    /// <summary>
    /// Used in select2 chose icon element. Compose a select2 formatted list of
    /// available fa- Fontawesome icon classes. Dependencies "/Admin/css/icons.css" 
    /// file.
    /// </summary>
    public class GetFaIconClasses : IHttpHandler, IRequiresSessionState
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

            if (File.Exists(context.Server.MapPath("/Admin/css/icons.css"))) 
            {
                FileInfo fi = new FileInfo(context.Server.MapPath("/Admin/css/icons.css"));
                StreamReader fileReader = fi.OpenText();
                string css = fileReader.ReadToEnd();
                Regex regex = new Regex(@"\.[a-z0-9\-]*" + k + @"[a-z0-9\-]*",RegexOptions.Compiled);
                MatchCollection mc = regex.Matches(css);
                foreach (Match match in mc) 
                {
                    string str = match.Value.Substring(1);
                    MagicCmsSelect2 select = new MagicCmsSelect2();
                    select.id = str;
                    select.text = "<i class=\"fa " + str + "\" ></i>";
                    lista.Add(select);
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