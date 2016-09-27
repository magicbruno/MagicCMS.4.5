using MagicCMS.Core;
using MagicCMS.DataTable;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.SessionState;

namespace MagicCMS.Admin.Ajax
{
    /// <summary>
    /// Descrizione di riepilogo per TypesPaginated
    /// </summary>
    public class TypesPaginated : IHttpHandler, IRequiresSessionState
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
            int basket;
            int.TryParse(context.Request["basket"], out basket);
            InputParams_dt inputPar = new InputParams_dt(context, "ANA_CONT_TYPE", "TYP_PK");

            System.Web.Script.Serialization.JavaScriptSerializer serializer = new System.Web.Script.Serialization.JavaScriptSerializer();


            OutputParams_dt output = inputPar.GetOutpuSimpleQuery(" TYP_Flag_Cancellazione = " + (basket == 0 ? " 0 " : " 1 "));
            output.data = new MagicPostTypeInfoCollection(inputPar, (basket != 0));

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
}