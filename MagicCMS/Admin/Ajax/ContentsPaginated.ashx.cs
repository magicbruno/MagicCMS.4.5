using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using MagicCMS.Core;
using MagicCMS.DataTable;
using System.Web.SessionState;

namespace MagicCMS.Admin.Ajax
{
    /// <summary>
    /// Descrizione di riepilogo per ContentsPaginated
    /// </summary>
    public class ContentsPaginated : IHttpHandler, IRequiresSessionState
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
            
            int parent_id = 0;
            int.TryParse(context.Request["parent_id"], out parent_id);
            if (basket > 0)
                parent_id = -2;

            InputParams_dt inputPar = new InputParams_dt(context, " MB_contenuti mc ", "mc.Id", " INNER JOIN ANA_CONT_TYPE ON Tipo = TYP_PK LEFT JOIN REL_contenuti_Argomenti ON mc.Id = Id_Contenuti");

            System.Web.Script.Serialization.JavaScriptSerializer serializer = new System.Web.Script.Serialization.JavaScriptSerializer();

            string whereClause = "";
            if (parent_id > 0)
                whereClause = " (Id_Argomenti = " + parent_id.ToString() + ") AND (Flag_Cancellazione = 0) ";
            else if (parent_id == 0)
                whereClause = " (Id_Argomenti IS NULL)  AND (Flag_Cancellazione = 0) ";
            else if (parent_id == -1)
                whereClause = " (Flag_Cancellazione = 0) ";
            else if (parent_id == -2)
                whereClause = " (Flag_Cancellazione = 1) ";

            OutputParams_dt output = inputPar.GetOutpuSimpleQuery(whereClause);
            output.data = new MagicTagCollection(parent_id, inputPar);

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