using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.SessionState;
using MagicCMS.Core;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;

namespace MagicCMS.Admin.Ajax
{
    /// <summary>
    /// Descrizione di riepilogo per GetTypesCheckboxed
    /// </summary>
    public class GetTypesCheckboxed : IHttpHandler, IRequiresSessionState
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
            string output = "";
            try
            {
                Boolean activeOnly = !MagicSession.Current.ShowInactiveTypes;
                MagicPostTypeInfoCollection mptic = new MagicPostTypeInfoCollection(activeOnly, false, MagicPostTypeInfoOrder.Alpha);

                HtmlGenericControl prefList = new HtmlGenericControl("ul");
                Random rnd = new Random(DateTime.Now.Millisecond);
                prefList.ID = "CL_" + (rnd.NextDouble() * 1000000).ToString().Replace(",", "") ;
                
                foreach (MagicPostTypeInfo item in mptic)
                {
                    HtmlGenericControl li = new HtmlGenericControl("li");
                    li.InnerHtml =  "  <label>" +
                                    "    <input type=\"checkbox\" value=\"" + item.Pk.ToString() +"\"> " +
                                    item.Nome +
                                    "  </label>";
                    prefList.Controls.Add(li);
                }
                output = StringHtmlExtensions.RenderControlToHtml(prefList);
            }
            catch (Exception e)
            {
                output = e.Message;
            }

            context.Response.ContentType = "text/html";
            context.Response.Write(output);
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