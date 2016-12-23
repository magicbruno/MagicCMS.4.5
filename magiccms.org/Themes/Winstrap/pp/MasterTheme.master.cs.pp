using MagicCMS.Core;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;

namespace $rootnamespace$.Themes.Winstrap
{
	public partial class MasterTheme : MagicCMS.PageBase.MasterTheme
	{
		public string ContainerClass { get; set; }
		public MagicPost MainMenu { get; set; }
		new protected void Page_Load(object sender, EventArgs e)
		{
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
			ContainerClass = ThePost.Tipo == MagicPostTypeInfo.CustomPage2 ? "container-fluid" : "container";

			//MagicPost footerMenu = new MagicPost(CmsConfig.FooterMenu);
			//if (footerMenu.Pk > 0) 
			//{
			//	MenuInfoCollection footerMenuIfos = new MenuInfoCollection(footerMenu, ThePost.Pk);
			//	RepeaterLegals.DataSource = footerMenuIfos;
			//	RepeaterLegals.DataBind();
			
			//}
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