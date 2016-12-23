using MagicCMS.Core;
using MagicCMS.Routing;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.SessionState;

namespace MagicCMS.Admin.Ajax
{
	/// <summary>
	/// Descrizione di riepilogo per PopulateMagicIndex
	/// </summary>
	public class PopulateMagicIndex : IHttpHandler, IRequiresSessionState
	{

		public void ProcessRequest(HttpContext context)
		{
			//Verifico prerogative minime (amministratore per gli utenti Editor per le altre tabelle)

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
				msg = Localize.Translate("Indice delle url parlanti creato con successo."),
				pk = 0,
				success = true
			};
			string errorMessage = "";
			if (MagicIndex.CreateMagicIndex(out errorMessage))
			{
				int processed;
				if (MagicIndex.Populate(out processed, out errorMessage))
				{
					response.success = true;
					response.msg = Localize.Translate("Indice delle url parlanti creato con successo. Inserite") + " " + processed.ToString() + " " + Localize.Translate("voci.");
				}
				else
				{
					response.success = false;
					response.msg = Localize.Translate("La creazione dell'indice delle url parlanti è fallita o si è interrotta.") + " " + Localize.Translate("Errore") + ": " + errorMessage + 
						" " + processed.ToString() + " " + Localize.Translate("voci.");
				}
			}
			else
			{
				response.success = false;
				response.exitcode = 1;
				response.msg = Localize.Translate("Impossibile creare la tabella MagicTitle.");
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