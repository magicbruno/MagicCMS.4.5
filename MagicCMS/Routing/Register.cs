using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Routing;

namespace MagicCMS.Routing
{
	/// <summary>
	/// Class Register. Register routing rules
	/// </summary>
	public static class Register
	{
		/// <summary>
		/// Registers the routes.
		/// </summary>
		/// <param name="routes">The routes.</param>
		public static void RegisterRoutes(RouteCollection routes)
		{
			RouteValueDictionary defaults = new RouteValueDictionary {
				  {"locale", ""},
				  {"type", ""}
			};
			RouteValueDictionary constraints = new RouteValueDictionary
			{
				  {"locale", "[a-z]{2}"}
			};

			routes.Ignore("Admin/");
			routes.Ignore("Admin/Ajax/");
			routes.Ignore("Admin/Session/");
			routes.MapPageRoute("error", "error/{errorNo}/{*subErrorNo}", "~/error.aspx");
			routes.MapPageRoute("home", "{pageId}", "~/Contenuti.aspx", true, new RouteValueDictionary {}, new RouteValueDictionary { 
				{"pageId", "home"}
			});
			routes.MapPageRoute("locale_full", "{locale}/{type}/{subType}/{pageId}", "~/Contenuti.aspx", true, defaults, constraints);
			routes.MapPageRoute("locale_short", "{locale}/{type}/{pageId}", "~/Contenuti.aspx", true, defaults, constraints);
			routes.MapPageRoute("locale_xs", "{locale}/{pageId}", "~/Contenuti.aspx", true, new RouteValueDictionary { { "locale", "" } }, constraints);
			routes.MapPageRoute("full", "{type}/[subType]/{pageId}", "~/Contenuti.aspx", true, new RouteValueDictionary { { "type", "" } });
			routes.MapPageRoute("short", "{type}/{pageId}", "~/Contenuti.aspx", true, new RouteValueDictionary { { "type", "" } });
			//routes.MapPageRoute("xs", "{pageId}", "~/Contenuti.aspx", true);
		}

	}
}