using MagicCMS.Core;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.SessionState;

namespace MagicCMS.Admin.Ajax
{
	/// <summary>
	/// Descrizione di riepilogo per PreviewPost
	/// </summary>
	public class PreviewPost : IHttpHandler, IRequiresSessionState
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
				msg = Localize.Translate("Operazione conclusa con successo."),
				success = true
			};
			int pk;
			string table = context.Request["table"];
			string message = "";
			MagicPost post;
			int.TryParse(context.Request["pk"], out  pk);

			if (table == "MB_contenuti")
			{
				if (pk == 0)
					post = new MagicPost();
				else
					post = new MagicPost(pk);

				if (post.MergeContext(context, context.Request.Form.AllKeys, out message))
				{
					if (!String.IsNullOrEmpty(post.TypeInfo.MasterPageFile))
						MagicSession.Current.PreviewPost = post;
					else
					{
						response.exitcode = 2;
						response.msg = Localize.Translate("Impossibile creare l'anteprima: non è stata definita alcuna MasterPage per il rendering di questo tipo di oggetto.");
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
				response.exitcode = 1;
				response.msg = "Dati incoerenti.";
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