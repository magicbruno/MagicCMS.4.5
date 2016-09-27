using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.SessionState;
using MagicCMS.Core;

namespace MagicCMS.Admin.Ajax
{
	/// <summary>
	/// Descrizione di riepilogo per GetRecord
	/// </summary>
	public class GetRecord : IHttpHandler, IRequiresSessionState
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

			AjaxJsonResponse response = new AjaxJsonResponse
			{
				data = null,
				exitcode = 0,
				msg = "Operazione conclusa con successo.",
				pk = 0,
				success = true
			};

			int pk;
			string table;

			int.TryParse(context.Request["pk"], out  pk);
			table = context.Request["table"];

			if (pk >= 0)
			{
				response.pk = pk;
				switch (table) 

				{
					case "ANA_USR":
						MagicUser user = new MagicUser(pk);
						//Nascondo la password
						user.Password = null;
						response.data = user;    
						break;
					case "MB_contenuti":
						response.data = new MagicPost(pk);
						break;
					case "MB_contenuti_title":
						response.data = MagicPost.GetPageTitle(pk);
						break;
					case "ANA_CONT_TYPE":
						response.data = new MagicPostTypeInfo(pk);
						break;
					case "_LOG_REGISTRY":
						 response.data = new MagicLog(pk);
					   break;
					case "ANA_Dictionary":
					   response.data = new MagicTransDictionary(pk);
					   break;
					//case "PROVE":
					//   response.data = new GestinvProva(pk);
					//   break;
					default:
						response.data = new object() ;
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