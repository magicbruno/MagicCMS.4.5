using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace MagicCMS
{
	public partial class error : System.Web.UI.Page
	{
		public string ShortMessage { get; set; }
		public string LongMessage { get; set; }
		public string ErrorNo { get; set; }

		protected void Page_Load(object sender, EventArgs e)
		{
			string errorNo = "???";
			string subErrorNo = "";
			if (Page.RouteData != null)
			{
				if (Page.RouteData.Values["errorNo"] != null)
				{
					errorNo = Page.RouteData.Values["errorNo"].ToString();
				}
				if (Page.RouteData.Values["subErrorNo"] != null)
				{
					subErrorNo = Page.RouteData.Values["subErrorNo"].ToString();
				}
			}
			errorNo += !String.IsNullOrEmpty(subErrorNo) ? "." + subErrorNo : "";
			switch (errorNo)
			{
				case "400":
					ShortMessage = "Bad Request";
					LongMessage = "Il server ha respinto la richiesta perché l'url è troppo lunga o non è ben formata. ";
					break;
				case "401":
					ShortMessage = "Authorization Required.";
					LongMessage = "La richiesta è sprovvista dell'autorizzazione necessaria. ";
					break;
				case "403":
					ShortMessage = "Forbidden";
					LongMessage = "L'accesso alla risorsa è proibito. ";
					break;
				case "404":
					ShortMessage = "Not Found";
					LongMessage = "La risorsa richiesta non esiste su questo server. ";
					break;
				case "404.100":
					ShortMessage = "Not Found";
					LongMessage = "Master Page non trovata o non configurata. ";
					break;
				case "405":
					ShortMessage = "Method not allowed.";
					LongMessage = "La richiesta è stata eseguita usando un metodo non permesso.";
					break;
				case "406":
					ShortMessage = "Not acceptable.";
					LongMessage = "La risorsa richiesta è solo in grado di generare contenuti non accettabili secondo la header Accept inviato dal client.";
					break;
				case "408":
					ShortMessage = "Request Timed Out";
					LongMessage = "Il tempo massimo di attesa del server è scaduto.";
					break;
				case "412":
					ShortMessage = "Precondition Failed";
					LongMessage = "";
					break;
				case "500":
					ShortMessage = "Internal Server Error";
					LongMessage = "Duesto errore si può verificare quando si tenta di accedere alla amministrazione del sito dopo un lungo periodo di inattvità (Sessione Scaduta) o " +
						"durante la manutenzione del server. Prova a ripetere il login o a ricaricare la home page. Se l'errore persiste rivolgiti all'aministraqtore del server.";
					break;
				case "501":
					ShortMessage = "Not Implemented";
					LongMessage = "Il server non è in grado di soddisfare il metodo della richiesta.";
					break;
				case "502":
					ShortMessage = "Bad gateway";
					LongMessage = "";
					break;
				case "503":
					ShortMessage = "Service unavailable";
					LongMessage = "Il server è temporaneamente offline. Rirpova più tardi. Se l'errore persiste rivolgiti all'aministraqtore del server.";
					break;
				default:
					ShortMessage = "Unespected error";
					LongMessage = "Errore sconosciuto o parametro illegale.";
					break;
			}
			ErrorNo = errorNo;

			
		}
	}
}