using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.SessionState;
using MagicCMS.Core;
using MagicCMS.DataTable;

namespace MagicCMS.Admin.Ajax
{
    /// <summary>
    /// Descrizione di riepilogo per UsersPaginated
    /// </summary>
    public class UsersPaginated : IHttpHandler, IRequiresSessionState
    {
        public void ProcessRequest(HttpContext context)
        {
            if (MagicSession.Current.LoggedUser.Level < 10)
            {
                context.Response.StatusCode = 403;
                context.Response.StatusDescription = "Prerogative non sufficienti";
                context.Response.ContentType = "text/html";
                //context.Response.Write("Sessione scaduta.");
                return;
            }

            InputParams_dt inputPar = new InputParams_dt(context, "ANA_USR", "usr_PK");
            //GestinvUserCollection users = new GestinvUserCollection(inputPar);

            System.Web.Script.Serialization.JavaScriptSerializer serializer = new System.Web.Script.Serialization.JavaScriptSerializer();


            OutputParams_dt output = inputPar.GetOutpuSimpleQuery();
            output.data = new MagicUserCollection(inputPar);

            string json = serializer.Serialize(output);

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
    //public class UsersJson
    //{
    //    public GestinvRicercaCollection data { get; set; }
    //}
}