using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.SessionState;
using MagicCMS.Core;

namespace MagicCMS.Admin.Ajax
{
    /// <summary>
    /// Descrizione di riepilogo per ConvertTag
    /// </summary>
    public class ConvertTag : IHttpHandler, IRequiresSessionState
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
            string output = "<h1>Conversione tags</h1>";
            MagicPostCollection mpc = MagicPost.GetPostByParentType(MagicPostTypeInfo.Tag);
            foreach (MagicPost post in mpc)
            {
                MagicPostCollection parents = post.GetParents(new int[] { MagicPostTypeInfo.Tag });
                List<string> keywords = new List<string>();
                foreach (MagicPost p in parents)
                {
                    keywords.Add(p.Nome);
                }
                post.Tags = String.Join(",", keywords.ToArray());
                post.Update();
                output += post.Tags + "<br />";
            }

            context.Response.ContentType = "text/plain";
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