﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.SessionState;
using MagicCMS.Core;

namespace MagicCMS.Admin.Session
{
	/// <summary>
	/// Handler used for custom management of the session expires. 
	/// </summary>
	public class SessionHandler : IHttpHandler, IRequiresSessionState
	{

		/// <exclude />
		public void ProcessRequest(HttpContext context)
		{
			AjaxJsonResponse response = new AjaxJsonResponse
			{
				exitcode = 0,
				msg = "Sessione attiva.",
				success = true
			};

			//sessione scaduta
			if (MagicSession.Current.LoggedUser.LoginResult != MbUserLoginResult.Success)
			{
				response.success = false;
				response.msg = "Sessione scaduta. È necessario ripetere il login";
				response.exitcode = -1;

			}
			else
			{
				int expiretime = Convert.ToInt32((DateTime.Now - MagicSession.Current.SessionStart).TotalSeconds);
				if (expiretime > 5400)
				{
					response.success = false;
					response.msg = "Sessione scaduta. È necessario ripetere il login";
					response.exitcode = -1;
					MagicSession.Current.LoggedUser = new MagicUser();
				}
				else if (expiretime > 5280)
				{
					int remaining = 5400 - expiretime;
					response.data = remaining;
					response.success = true;
					response.msg = "Attenzione: " + (remaining / 60).ToString() + " minuti e " + (remaining % 60).ToString() + " secondi alla fine della sessione. Salva il lavoro e preparati a ripetere il login";
					response.exitcode = 1;
				}
				else
				{
					response.data = 5400 - expiretime;
				}
			}


			System.Web.Script.Serialization.JavaScriptSerializer serializer = new System.Web.Script.Serialization.JavaScriptSerializer();
			string json = serializer.Serialize(response);

			context.Response.ContentType = "application/json";
			context.Response.Charset = "UTF-8";
			context.Response.Write(json);
		}

		/// <exclude />
		public bool IsReusable
		{
			get
			{
				return false;
			}
		}
	}
}