using MagicCMS.Core;
using MagicCMS.CustomCss;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.SessionState;

namespace MagicCMS.CustomCss
{
	/// <summary>
	/// Descrizione di riepilogo per GetRecord
	/// </summary>
	public class GetRecord : IHttpHandler, IRequiresSessionState
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
				msg = "Ok",
				pk = 0,
				success = true
			};
			int pk;
			try
			{
				if (int.TryParse(context.Request["pk"], out pk))
				{
					MagicCss mc = new MagicCss(pk);
					response.data = mc.CssText;
				}
				else
				{
					response.exitcode = 2;
					response.success = false;
					response.msg = "Parametro non corretto.";
				}
				
			}
			catch (Exception e)
			{
				response.success = false;
				response.exitcode = 1;
				response.msg = e.Message;
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