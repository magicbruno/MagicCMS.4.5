using MagicCMS.Core;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.SessionState;

namespace MagicCMS.Admin.Ajax
{
    /// <summary>
    /// Cancella un record da una tabella.
    /// </summary>
    public class Delete : IHttpHandler, IRequiresSessionState
    {

        public void ProcessRequest(HttpContext context)
        {
            int minlevel = MagicPrerogativa.GetKey("Editor");
            if (context.Request["table"] == "ANA_USR")
            {
                minlevel = MagicPrerogativa.GetKey("Administrator");
            }


            if (MagicSession.Current.LoggedUser.Level < minlevel)
            {
                context.Response.StatusCode = 403;
                context.Response.StatusDescription = "Sessione non valida o prerogative insufficienti.";
                context.Response.ContentType = "text/html";
                //context.Response.Write("Sessione scaduta.");
                return;
            }
            AjaxJsonResponse response = new AjaxJsonResponse
            {
                data = null,
                exitcode = 0,
                msg = "Record cancellato con successo.",
                pk = 0,
                success = true
            };

            int pk, undelete;
            string table, pkName = "";

            bool result = int.TryParse(context.Request["pk"], out  pk);
            int.TryParse(context.Request["undelete"], out undelete);
            table = context.Request["table"];
            string message, langId;
            langId = context.Request["LangId"];

            if (result)
            {
                response.pk = pk;
                switch (table)
                {
                    // Gestione Utenti
                    case "ANA_USR":
                        pkName = "usr_PK";
                        response = DeleteRecord(table, pkName, pk);
                        break;
                    case "ANA_TRANSLATION":
                        pkName = "TRAN_Pk";
                        MagicTranslation translation = new MagicTranslation(pk, langId);
                        if (translation.Pk > 0)
                        {
                            response = DeleteRecord(table, pkName, translation.Pk);
                            response.data = new MagicTranslation(0, langId);
                        }
                        else
                        {
                            response.success = false;
                            response.msg = "Nessun record da eliminare ";
                            response.exitcode = 1;
                        }
                        break;
                    case "ANA_Dictionary":
                        pkName = "DICT_PK";
                        response = DeleteRecord(table, pkName, pk);
                        break;
                    case "ANA_CONT_TYPE":
                        MagicPostTypeInfo mpti = new MagicPostTypeInfo(pk);
                        if (undelete == 0)
                            response.success = mpti.Delete(out message);
                        else
                            response.success = mpti.UnDelete(out message);
                        response.msg = message;
                        response.exitcode = (response.success ? 0 : 5);
                        break;
                    case "MB_Contenuti":
                        MagicPost mp = new MagicPost(pk);
                        if (undelete == 0)
                            response.success = mp.Delete(out message);
                        else
                            response.success = mp.UnDelete(out message);
                        response.msg = message;
                        response.exitcode = (response.success ? 0 : 5);
                        break;
                    default:
                        response.data = new object();
                        response.pk = 0;
                        response.exitcode = 2;
                        response.msg = "Errore: la tabella \"" + table + "\" non esiste.";
                        response.success = false;

                        break;
                }
            }
            else
            {
                response.data = new object();
                response.exitcode = 1;
                response.msg = "Dati insuffucienti o non pervenuti.";
                response.success = false;
            }
            System.Web.Script.Serialization.JavaScriptSerializer serializer = new System.Web.Script.Serialization.JavaScriptSerializer();
            string json = serializer.Serialize(response);

            context.Response.ContentType = "application/json";
            context.Response.Charset = "UTF-8";
            context.Response.Write(json);
        }

        private AjaxJsonResponse DeleteRecord(string table, string pkName, int pk)
        {
            AjaxJsonResponse response = new AjaxJsonResponse();
            response.data = new object();
            response.pk = pk;
            response.exitcode = 0;
            response.msg = "Record cancellato con successo.";
            response.success = true;

            SqlConnection conn = null;
            SqlCommand cmd = null;
            try
            {
                string cmdText = " BEGIN TRY " +
                                    " 	BEGIN TRANSACTION " +
                                    " 		DELETE " + table + " " +
                                    " 			WHERE " + pkName + " = @pk " +
                                    " 	COMMIT TRANSACTION " +
                                    " 	SELECT @Pk " +
                                    " END TRY " +
                                    " BEGIN CATCH " +
                                    "   	IF XACT_STATE() <> 0 BEGIN " +
                                    " 		    ROLLBACK TRANSACTION " +
                                    "   	END " +
                                    " 	SELECT ERROR_MESSAGE(); " +
                                    " END CATCH; ";

                conn = new SqlConnection(MagicUtils.MagicConnectionString);
                conn.Open();
                cmd = new SqlCommand(cmdText, conn);
                cmd.Parameters.AddWithValue("@pk", pk);

                int r;
                string result = Convert.ToString(cmd.ExecuteScalar());


                if (!int.TryParse(result, out r))
                {
                    MagicLog log = new MagicLog(table, pk, LogAction.Delete, "", "");
                    log.Error = result;
                    log.Insert();
                    response.exitcode = 5;
                    response.msg = "Errore SQL: " + result;
                    response.success = false;
                }
            }
            catch (Exception e)
            {
                MagicLog log = new MagicLog(table, pk, LogAction.Delete, e);
                log.Insert();
                response.exitcode = 5;
                response.msg = e.Message;
                response.success = false;
            }
            finally
            {
                if (conn != null)
                    conn.Dispose();
                if (cmd != null)
                    cmd.Dispose();
            }
            return response;
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