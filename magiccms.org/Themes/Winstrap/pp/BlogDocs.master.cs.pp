using MagicCMS.Core;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using MagicCMS.Facebook;
using MagicCMS.Routing;

namespace $rootnamespace$.Themes.Winstrap
{
	public partial class BlogDocs : MagicCMS.PageBase.MasterTheme
	{
		public string TagSearchUrl { get; set; }
		new protected void Page_Load(object sender, EventArgs e)
		{
			base.Page_Load(sender, e);
			TagSearchUrl = RouteUtils.GetVirtualPath(ThePost.Pk);
			string keyParam = "";
			if (Page.RouteData.Values["params"] != null)
			{
				keyParam = Page.RouteData.Values["params"].ToString();
			}
			MagicPostCollection mpc;
			if (!String.IsNullOrEmpty(keyParam))
			{
				string keyword = keyParam.Substring(2);
				mpc = MagicPost.SearchByKeyword(keyword, MagicOrdinamento.DateDesc);
			}
			else
				mpc = ThePost.GetChildren(MagicOrdinamento.DateDesc, 12);
			if (mpc.Count > 0)
			{
				Repeater_Articles.DataSource = mpc;
				Repeater_Articles.DataBind();
			}

			MagicPost theHome = new MagicPost(CmsConfig.StartPage);
			if (theHome.Pk > 0)
			{
				string fbAccessKey = theHome.ExtraInfo;
				string fbPageName = theHome.ExtraInfo2;
				try
				{
					FacebookPostCollection news = new FacebookPostCollection(fbAccessKey, fbPageName, 12);
					if (news.Count > 0)
					{
						Repeater_fb.DataSource = news;
						Repeater_fb.DataBind();
					}
				}
				catch (Exception)
				{

				}
			}
		}

		protected void Repeater_tags_ItemDataBound(object sender, RepeaterItemEventArgs e)
		{
			RepeaterItem item = e.Item;
			if (item.ItemType == ListItemType.Item || item.ItemType == ListItemType.AlternatingItem)
			{
				MagicPost post = item.DataItem as MagicPost;
				if (!String.IsNullOrEmpty(post.Tags))
				{
					List<string> tags = post.Tags.Split(',').ToList<string>();
					if (tags.Count > 0)
					{
						Repeater tagsRepeater = item.FindControlRecursive("Repeater_tags") as Repeater;
						if (tagsRepeater != null)
						{
							tagsRepeater.DataSource = tags;
							tagsRepeater.DataBind();
						}
					}

				}

			}
		}
	}
}