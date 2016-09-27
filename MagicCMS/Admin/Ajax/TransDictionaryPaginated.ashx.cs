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
    /// Descrizione di riepilogo per TransDictionaryPaginated
    /// </summary>
    public class TransDictionaryPaginated : IHttpHandler, IRequiresSessionState
    {

        public void ProcessRequest(HttpContext context)
        {
            if (MagicSession.Current.LoggedUser.Level < 4)
            {
                context.Response.StatusCode = 403;
                context.Response.StatusDescription = "Prerogative non sufficienti";
                context.Response.ContentType = "text/html";
                return;
            }

            InputParams_dt inputPar = new InputParams_dt(context, "ANA_Dictionary", "DICT_Pk");
            //GestinvUserCollection users = new GestinvUserCollection(inputPar);

            System.Web.Script.Serialization.JavaScriptSerializer serializer = new System.Web.Script.Serialization.JavaScriptSerializer();


            OutputParams_dt output = inputPar.GetOutpuSimpleQuery();
            output.data = new MagicTransDictionaryCollection(inputPar);

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