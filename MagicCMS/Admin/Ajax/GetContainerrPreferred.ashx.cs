using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.SessionState;
using MagicCMS.Core;
using System.Web.UI.WebControls;
using System.Web.UI;
using System.IO;

namespace MagicCMS.Admin.Ajax
{
    /// <summary>
    /// List of preferred types formatted as a unordered list. Every item points to a page that load new element 
    /// of chosen type, child of current element.
    /// </summary>
    public class GetContainerrPreferred : IHttpHandler, IRequiresSessionState
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
            int parent;
            int.TryParse(context.Request["parent"], out parent);
            string output = "";
            if (parent > 0)
            {
                try
                {
                    MagicPost mp = new MagicPost(parent);
                    string myQuery = "";
                    if (mp.Preferred.Count > 0)
                    {

                        myQuery = "TYP_PK IN (" +String.Join(",", mp.Preferred.Select<int, string>(i => i.ToString()).ToArray()) + ")";
                    }

                    MagicPostTypeInfoCollection mptic = new MagicPostTypeInfoCollection(!MagicSession.Current.ShowInactiveTypes, false,
                        MagicPostTypeInfoOrder.Alpha, myQuery);

                    BulletedList prefList = new BulletedList();
                    prefList.DisplayMode = BulletedListDisplayMode.HyperLink;
                    foreach (MagicPostTypeInfo item in mptic)
                    {
                        ListItem li = new ListItem(item.Nome, "editcontents.aspx?parent=" + parent.ToString() + "&pk=0&type=" + item.Pk.ToString());
                        prefList.Items.Add(li);
                    }
                    output = StringHtmlExtensions.RenderControlToHtml(prefList);
               }
                catch (Exception e)
                {
                    output = e.Message;
                }
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