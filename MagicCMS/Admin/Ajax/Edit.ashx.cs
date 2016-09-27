using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.SessionState;
using MagicCMS.Core;

namespace MagicCMS.Admin.Ajax
{
    /// <summary>
    /// Modulo che consente di aggiornare/inserire record nelle tabelel complesse
    /// </summary>
    public class Edit : IHttpHandler, IRequiresSessionState
    {


        public void ProcessRequest(HttpContext context)
        {
            //Verifico prerogative minime (amministratore per gli utenti Editor per le altre tabelle)
			
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

            //Oggetto json restituito dal modulo
            AjaxJsonResponse response = new AjaxJsonResponse
            {
                data = null,
                exitcode = 0,
                msg = "Operazione conclusa con successo.",
                pk = 0,
                success = true
            };

            // pk: Record Primary Key
            // postPk: pk of Post which a Translation Object translates.
            // Record Table Name
            // message: Returne message after update/insert
            // langid: Lang id of Translation
            int pk = 0, postPk = 0;
            string table;
            string message;
            string langid;
            string source, translated;

            bool result = int.TryParse(context.Request["pk"], out  pk);
            table = context.Request["table"];
            langid = context.Request["LangId"];
            source = context.Request["Source"];
            translated = context.Request["Translation"];
            if(!result)
                result = int.TryParse(context.Request["PostPk"], out  postPk);

            if (result)
            {
                response.pk = pk;
                switch (table)
                {
                    // utenti
                    case "ANA_USR":
                        MagicUser user;
                        string email = context.Request["Email"];

                        if (String.IsNullOrEmpty(email))
                        {
                            response.exitcode = 1;
                            response.msg = "Il campo e-mail è obbligatorio.";
                            response.success = false;
                        }
                        //In caso di nuovo inserimento Controllo se l'utente esiste già
                        else if (pk == 0 && MagicUser.UsernameExists(email))
                        {
                            response.exitcode = 2;
                            response.msg = "Utente già registrato. L'indirizzo e-mail è già presente nel database.";
                            response.success = false;
                        }
                        else if (pk == 0)
                        {
                            user = new MagicUser();
                            user.MergeContext(context);
                            response.pk = user.Insert();
                            if (response.pk < 0)
                            {
                                response.exitcode = 3;
                                response.msg = "Si è verificato un errore. Contrllare il registro delle attività per maggiori informazioni.";
                                response.success = false;
                            }
                            else if (!String.IsNullOrEmpty(context.Request["sendmail"]))
                                MagicUser.ResetPassword(user.Email);
                        }
                        else
                        {
                            user = new MagicUser(pk);
                            user.MergeContext(context);
                            if (user.LoginResult != MbUserLoginResult.Success)
                            {
                                response.exitcode = 3;
                                response.msg = "Si è verificato un errore. Contrllare il registro delle attività per maggiori informazioni.";
                                response.success = false;
                            }
                            else if (!user.Update())
                            {
                                response.exitcode = 3;
                                response.msg = "Si è verificato un errore. Contrllare il registro delle attività per maggiori informazioni.";
                                response.success = false;
                            }
                        }
                        break;
                    //// Processi
                    case "ANA_CONT_TYPE":
                        MagicPostTypeInfo typeInfo;
                        if (pk == 0)
                        {
                            typeInfo = new MagicPostTypeInfo(0);
                            if (typeInfo.MergeContext(context, context.Request.Form.AllKeys, out message))
                            {
                                response.pk = typeInfo.Insert();
                                if (response.pk < 0)
                                {
                                    response.exitcode = 3;
                                    response.msg = "Si è verificato un errore. Contrllare il registro delle attività per maggiori informazioni.";
                                    response.success = false;
                                }

                            }
                            else
                            {
                                response.exitcode = 1;
                                response.msg = message;
                                response.success = false;
                            }
                        }
                        else
                        {
                            typeInfo = new MagicPostTypeInfo(pk);
                            if (typeInfo.MergeContext(context, context.Request.Form.AllKeys, out message))
                            {
                                if (!typeInfo.Update())
                                {
                                    response.exitcode = 3;
                                    response.msg = "Si è verificato un errore. Contrllare il registro delle attività per maggiori informazioni.";
                                    response.success = false;
                                }

                            }
                            else
                            {
                                response.exitcode = 1;
                                response.msg = message;
                                response.success = false;
                            }
                        }
                        break;

                    case "MB_contenuti":
                        MagicPost post;
                        if (pk == 0)
                        {
                            post = new MagicPost();
                            if (post.MergeContext(context, context.Request.Form.AllKeys, out message))
                            {
                                response.pk = post.Insert();
                                if (response.pk < 0)
                                {
                                    response.exitcode = 3;
                                    response.msg = "Si è verificato un errore. Contrllare il registro delle attività per maggiori informazioni.";
                                    response.success = false;
                                }

                            }
                            else
                            {
                                response.exitcode = 1;
                                response.msg = message;
                                response.success = false;
                            }
                        }
                        else
                        {
                            post = new MagicPost(pk);
                            if (post.MergeContext(context, context.Request.Form.AllKeys, out message))
                            {
                                if (post.Update() == 0)
                                {
                                    response.exitcode = 3;
                                    response.msg = "Si è verificato un errore. Contrllare il registro delle attività per maggiori informazioni.";
                                    response.success = false;
                                }

                            }
                            else
                            {
                                response.exitcode = 1;
                                response.msg = message;
                                response.success = false;
                            }
                        }
                        break;
                    case "ANA_TRANSLATION":
                        MagicTranslation translation;
                        if (postPk > 0)
                        {
                            translation = new MagicTranslation(postPk, langid);
                            if (translation.MergeContext(context, context.Request.Form.AllKeys, out message))
                            {
                                response.success = translation.Save();
                                response.pk = translation.PostPk;
                                if (!response.success)
                                {
                                    response.exitcode = 3;
                                    response.msg = "Si è verificato un errore. Contrllare il registro delle attività per maggiori informazioni.";
                                }

                            }
                            else
                            {
                                response.exitcode = 1;
                                response.msg = message;
                                response.success = false;
                            }
                        }
                        else
                        {
                            response.exitcode = 0;
                            response.msg = "Non è specificato l'id del post a cui si riferisce la traduzione";
                            response.success = false;
                        }
                        break;
                    case "ANA_Dictionary":
                        if (String.IsNullOrEmpty(source) || String.IsNullOrEmpty(langid) || String.IsNullOrEmpty(translated))
                        {
                            response.exitcode = 2;
                            response.msg = "Errore: Tutti i campi devono essere compilati!";
                            response.success = false;
                        }
                        else
                        {
                            MagicTransDictionary term = new MagicTransDictionary();
                            term.Source = source;
                            term.LangId = langid;
                            term.Translation = translated;
                            if (!term.Save())
                            {
                                response.exitcode = 3;
                                response.msg = "Si è verificato un errore. Contrllare il registro delle attività per maggiori informazioni.";
                                response.success = false;
                            }
                        }
                        break;
                    case "CONFIG":
                        CMS_Config cmsConfig = new CMS_Config();

                        if (cmsConfig.MergeContext(context, context.Request.Form.AllKeys, out message))
                        {
                            response.success = cmsConfig.Save();
                            response.pk = 0;
                            if (!response.success)
                            {
                                response.exitcode = 3;
                                response.msg = "Si è verificato un errore. Controllare il registro delle attività per maggiori informazioni.";
                            }

                        }
                        else
                        {
                            response.exitcode = 1;
                            response.msg = message;
                            response.success = false;
                        }
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

        public bool IsReusable
        {
            get
            {
                return false;
            }
        }
    }
}