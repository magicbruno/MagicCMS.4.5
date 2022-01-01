using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Routing;
using System.Web.Http; 

namespace MagicCMS.Routing
{
	/// <summary>
	/// Class Register. Register routing rules
	/// </summary>
	public static class Register
	{
		/// <summary>
		/// Register the routes.
		/// </summary>
		/// <param name="routes">The routes.</param>
		public static void RegisterRoutes(RouteCollection routes)
		{
			string paramMatch = @"q=[\s\S]+";
			RouteValueDictionary defaults = new RouteValueDictionary {
				  {"locale", ""},
				  {"type", ""}
			};
			RouteValueDictionary constraints_locale = new RouteValueDictionary
			{
				  {"locale", "[a-z]{2}"},
				  {"params", paramMatch}
			};

			RouteValueDictionary constraints_home = new RouteValueDictionary
			{
				  {"pageId", "home"},
				  {"params", paramMatch}
			};

			RouteValueDictionary constraints_params = new RouteValueDictionary
			{
				  {"params", paramMatch}
			};

			routes.MapHttpRoute(name: "DefaultApi", routeTemplate: "api/{controller}/{id}", defaults: new { id = System.Web.Http.RouteParameter.Optional });
			routes.Ignore("Admin/");
			routes.Ignore("Admin/Ajax/");
			routes.Ignore("Admin/Session/");
			routes.MapPageRoute("error", "error/{errorNo}/{*subErrorNo}", "~/error.aspx");
			routes.MapPageRoute("home", "{pageId}", "~/Contenuti.aspx", true, new RouteValueDictionary { }, new RouteValueDictionary { 
				{"pageId", "home"}
			});
			routes.MapPageRoute("preview", "{pageId}", "~/Contenuti.aspx", true, new RouteValueDictionary { }, new RouteValueDictionary { 
				{"pageId", "preview"}
			});
			routes.MapPageRoute("home-params", "{pageId}/{params}", "~/Contenuti.aspx", true, new RouteValueDictionary { }, constraints_home);

			routes.MapPageRoute("locale_full_params", "{locale}/{type}/{subType}/{pageId}/{params}", "~/Contenuti.aspx", true, defaults, constraints_locale);
			routes.MapPageRoute("locale_short_params", "{locale}/{type}/{pageId}/{params}", "~/Contenuti.aspx", true, defaults, constraints_locale);
			routes.MapPageRoute("locale_xs_params", "{locale}/{pageId}/{params}", "~/Contenuti.aspx", true, defaults, constraints_locale);
			routes.MapPageRoute("short_params", "{type}/{pageId}/{params}", "~/Contenuti.aspx", true, new RouteValueDictionary { { "type", "" } }, constraints_params);
			routes.MapPageRoute("full_params", "{type}/{subType}/{pageId}/{params}", "~/Contenuti.aspx", true, new RouteValueDictionary { { "type", "" } }, constraints_params);

			routes.MapPageRoute("locale_full", "{locale}/{type}/{subType}/{pageId}", "~/Contenuti.aspx", true, defaults, new RouteValueDictionary
			{
				{"locale", "[a-z]{2}"}
			});
			routes.MapPageRoute("locale_short", "{locale}/{type}/{pageId}", "~/Contenuti.aspx", true, defaults, new RouteValueDictionary
			{
				{"locale", "[a-z]{2}"}
			});
			routes.MapPageRoute("locale_xs", "{locale}/{pageId}", "~/Contenuti.aspx", true, new RouteValueDictionary { { "locale", "" } }, new RouteValueDictionary
			{
				{"locale", "[a-z]{2}"}
			});
			routes.MapPageRoute("full", "{type}/{subType}/{pageId}", "~/Contenuti.aspx", true, new RouteValueDictionary { { "type", "" } });
			routes.MapPageRoute("short", "{type}/{pageId}", "~/Contenuti.aspx", true, new RouteValueDictionary { { "type", "" } });
            
		}

	}
}