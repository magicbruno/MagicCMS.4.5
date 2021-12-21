using Facebook;
using MagicCMS.Core;
using MagicCMS.Facebook;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace magiccms.org.Themes.Winstrap
{
	public partial class SlideShow : MagicCMS.PageBase.MasterTheme
	{
		public bool FbColumn { get; set; }
		new protected void Page_Load(object sender, EventArgs e)
		{
			base.Page_Load(sender, e);
			MagicPostCollection slides = ThePost.GetChildrenByType(MagicPostTypeInfo.Slide, MagicOrdinamento.Asc);
			RepeaterSequenza.DataSource = slides;
			RepeaterSequenza.DataBind();

			string FbPage = "";
			string FbAppID = MagicCMSConfiguration.GetConfig().FacebookApplicationID;
			string FbSecret = MagicCMSConfiguration.GetConfig().FacebookSecretKey;
			string FbAccessToken = "EAAXsPw4T92ABAEjP3ZCaHbriYbhiLU9lYKap1JYh56VEPJDwS5eznD6vw9WyZARkqCuEVDQrZB4p13lIZCUZBMJxFCq97UeLNExC6v4f6ZCKFeRd61xNlZAgcf4OndzeOes1vcHdg4gezsvZBwed9ZCLXjgWn8JUBjJcZD";

            FbColumn = false;
			if (!(String.IsNullOrEmpty(FbAppID) || String.IsNullOrEmpty(FbSecret) || String.IsNullOrEmpty(FbPage)))
			{
				FacebookPostCollection fpc = new FacebookPostCollection(FbAccessToken, FbPage,7);
				if (fpc.Count > 0)
				{
					FbColumn = true;
					Repeater_fb.DataSource = fpc;
					Repeater_fb.DataBind();
				}
			}

		}
	}
}