using MagicCMS.Core;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;

namespace magiccms.org.Themes.Winstrap
{
	public partial class MasterTheme : MagicCMS.PageBase.MasterTheme
	{
		public string ContainerClass { get; set; }
		public MagicPost MainMenu { get; set; }
		new protected void Page_Load(object sender, EventArgs e)
		{
			string originalUrl = Request.Url.ToString();
			string newUrl = Request.Url.ToString();
			if (newUrl.Contains("//www."))
				newUrl = newUrl.Replace("www.", "");
			if(!Request.IsSecureConnection)
			{
				newUrl = newUrl.Replace("http", "https");
			}

			if (newUrl != originalUrl)
				Response.Redirect(newUrl);

			base.Page_Load(sender, e);
			int mainMenuId = CmsConfig.MainMenu;
			MainMenu = new MagicPost(mainMenuId);
			HtmlGenericControl navs = null;
			if (mainMenuId > 0)
			{
				navs = BootstrapMenu(mainMenuId, "nav navbar-nav", ThePost.Pk, false);
			}
			if (navs != null)
			{
				MainNav.Controls.Add(navs);
			}
			// ContainerClass property define if the page layout is full width (page containing full width iframe) or not 
			ContainerClass = ThePost.Tipo == MagicPostTypeInfo.CustomPage2 ? "container-fluid" : "container";

			int footerMenuId = CmsConfig.FooterMenu;
			HtmlGenericControl footerNav = null;
			if (footerMenuId > 0)
			{
				footerNav = BootstrapMenu(footerMenuId, "list-inline navbar-right dropup", ThePost.Pk, true);
			}
			if (footerNav != null)
			{
				Footer_navbar.Controls.Add(footerNav);
			}
		}
	}
}