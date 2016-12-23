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
		new protected void Page_Load(object sender, EventArgs e)
		{
			base.Page_Load(sender, e);
			MagicPostCollection slides = ThePost.GetChildrenByType(MagicPostTypeInfo.Slide, MagicOrdinamento.Asc);
			RepeaterSequenza.DataSource = slides;
			RepeaterSequenza.DataBind();

			FacebookClient client = new FacebookClient(ThePost.ExtraInfo);

			Facebook.JsonObject postList = client.Get(ThePost.ExtraInfo2 + "/feed?fields=id,from,name,message,created_time,story,description,link,permalink_url,picture,object_id") as JsonObject;
			string strJson = postList.ToString();

			if (postList.ContainsKey("data"))
			{
				int maxPost = 0; 
				JsonArray data = postList["data"] as JsonArray;
				FacebookPostCollection fpc = new FacebookPostCollection();

				for (int i = 0; i < data.Count && maxPost < 7; i++)
				{
					FacebookPost fp = new FacebookPost(data[i] as JsonObject);
					fpc.Add(fp);
					maxPost++;

				}
				if (fpc.Count > 0)
				{
					Repeater_fb.DataSource = fpc;
					Repeater_fb.DataBind();
				}
			}
		}
	}
}