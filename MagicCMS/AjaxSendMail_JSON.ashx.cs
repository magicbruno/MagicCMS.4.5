using MagicCMS.Core;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Mail;
using System.Web;

namespace MagicCMS
{
	/// <exclude />
    public class AjaxSendMail_JSON : IHttpHandler
    {
        public void ProcessRequest(HttpContext context)
        {

            AjaxJsonResponse response = new AjaxJsonResponse
            {
                data = null,
                exitcode = 0,
                msg = "E-mail spedita con successo.",
                pk = 0,
                success = true
            };

            try
            {
                string[] formCollection = context.Request.Form.AllKeys;
                string mailBody = "";
                CMS_Config config = new CMS_Config();

                MailMessage notificaAdmin = new MailMessage();
                MailMessage notificaUser = new MailMessage();
                SmtpClient smtp = new SmtpClient(config.SmtpServer, 25);

                string header = "<p>Hai ricevuto una richiesta di informazioni dal sito " + config.SiteName + ":</p>";
                Boolean firstLoop = true;
                for (int i = 0; i < formCollection.Length; i++)
                {
                    if (!String.IsNullOrEmpty(context.Request.Form[formCollection[i]]))
                    {
                        if (firstLoop)
                        {
                            firstLoop = false;
                            mailBody = "<p>";
                        }
                        mailBody += "<strong>" + formCollection[i] + "</strong> " + context.Request.Form[formCollection[i]] + "<br />";
                    }
                }
                if (!String.IsNullOrEmpty(mailBody))
                {
                    try
                    {
                        mailBody = header + mailBody + "</p>";
                        smtp.UseDefaultCredentials = false;
                        smtp.Credentials = new System.Net.NetworkCredential(config.SmtpUsername, config.SmtpPassword);
                        notificaAdmin.From = new MailAddress(config.SmtpDefaultFromMail);
                        notificaAdmin.To.Add(config.SmtpAdminMail);
                        notificaAdmin.Bcc.Add(MagicCMSConfiguration.GetConfig().SmtpAdminMail);
                        notificaAdmin.Subject = "Richiesta di informazioni dal sito " + config.SiteName;
                        notificaAdmin.IsBodyHtml = true;
                        notificaAdmin.Body = mailBody;
                        smtp.Send(notificaAdmin);
                        if (!String.IsNullOrEmpty(context.Request.Form["email"]))
                        {
                            notificaUser.From = new MailAddress(config.SmtpDefaultFromMail);
                            notificaUser.To.Add(context.Request.Form["email"]);
                            notificaUser.Subject = "R: Richiesta di informazioni";
                            notificaUser.IsBodyHtml = true;
                            notificaUser.Body = "<p>Egr. signora/signor, <br />" +
                                            "La sua richiesta di infromazioni è arrivata allo staff di " + config.SiteName + ".</p>" +
                                            "<p>Verrà contattata/o al più presto.</p>" +
                                            "<p>Cordiali Saluti</p>";
                            smtp.Send(notificaUser);

                        }

                    }
                    catch (Exception e)
                    {
                        response.msg = e.Message;
                        response.exitcode = 1;
                        response.success = false;
                    }
                    finally
                    {
                        if (notificaAdmin != null)
                            notificaAdmin.Dispose();
                        if (notificaUser != null)
                            notificaUser.Dispose();
                    }
                }
                else
                {
                    response.msg = "Non è stato inviato alcun dato!"; ;
                    response.exitcode = 2;
                    response.success = false;
                }
            }
            catch (Exception e)
            {
                response.msg = e.Message;
                response.exitcode = 1;
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