using MagicCMS.Core;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.SessionState;

namespace MagicCMS.CustomCss
{
	/// <summary>
	/// Descrizione di riepilogo per Save
	/// </summary>
	public class Save : IHttpHandler, IRequiresSessionState
	{

		public void ProcessRequest(HttpContext context)
		{
			int minlevel = MagicPrerogativa.GetKey("Editor");

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
				msg = "Il CSS personalizzato è stato aggiornato con successo.",
				pk = 0,
				success = true
			};

			string cssText = context.Request.Form["cssText"].ToString();
			int insert = 0;
			int.TryParse(context.Request.Form["insert"], out insert);
			MagicCss customCss;

			if (insert == 0) {
				customCss = MagicCss.GetCurrent();
				customCss.CssText = cssText;
			
			}
			else
			{
				customCss = new MagicCss(cssText);
				response.msg = "Una copia del CSS corrente è stata salvata con successo";
			}

			if (!customCss.Save())
			{
				response.msg = "Si è verificato un errore durante il salvatoggio del CSS. Non è stata apportata alcuna modifica.";
				response.success = false;
				response.exitcode = 1;
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