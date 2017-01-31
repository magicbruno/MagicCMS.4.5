using Facebook;
using MagicCMS.Core;
using MagicCMS.Facebook;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace $rootnamespace$.Themes.Winstrap
{
	public partial class SlideShow : MagicCMS.PageBase.MasterTheme
	{
		new protected void Page_Load(object sender, EventArgs e)
		{
			base.Page_Load(sender, e);
			MagicPostCollection slides = ThePost.GetChildrenByType(MagicPostTypeInfo.Slide, MagicOrdinamento.Asc);
			RepeaterSequenza.DataSource = slides;
			RepeaterSequenza.DataBind();

			string FbPage = ThePost.ExtraInfo2;
			string FbAppID = MagicCMSConfiguration.GetConfig().FacebookApplicationID;
			string FbSecret = MagicCMSConfiguration.GetConfig().FacebookSecretKey;
			string FbAccessToken = FbAppID + "|" + FbSecret;

			if (!(String.IsNullOrEmpty(FbAppID) || String.IsNullOrEmpty(FbSecret) || String.IsNullOrEmpty(FbPage)))
			{
				FacebookPostCollection fpc = new FacebookPostCollection(FbAccessToken, FbPage,7);
				if (fpc.Count > 0)
				{
					Repeater_fb.DataSource = fpc;
					Repeater_fb.DataBind();
				}
			}

		}
	}
}