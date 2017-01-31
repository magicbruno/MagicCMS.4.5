using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using MagicCMS.Core;

namespace magiccms.org.Themes.Winstrap
{
	public partial class ComingSoon : MagicCMS.PageBase.MasterTheme
	{
		public string ExpiryDate { get; set; }

		new protected void Page_Load(object sender, EventArgs e)
		{
			base.Page_Load(sender, e);
			Control headerNavbar = Master.FindControlRecursive("HeaderNavbar");
			if (headerNavbar != null)
			{
				headerNavbar.Visible = false;
			}
			Control footerNavbar = Master.FindControlRecursive("FooterNavbar");
			if (footerNavbar != null)
			{
				footerNavbar.Visible = false;
			}
			if (ThePost.DataScadenza.HasValue) {
				ExpiryDate = ThePost.DataScadenza.Value.ToString("yyyy/MM/dd") + " " + ThePost.ExtraInfo;
			}

		}
	}
}