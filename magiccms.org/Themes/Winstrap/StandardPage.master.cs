using MagicCMS.Core;
using MagicCMS.Routing;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace magiccms.org.Themes.Winstrap
{
	public partial class StandardPage : MagicCMS.PageBase.MasterTheme
	{
		public string TagSearchUrl { get; set; }
		new protected void Page_Load(object sender, EventArgs e)
		{
			base.Page_Load(sender, e);
			PlaceHolderVideo.DataBind();
			int BlogPk = 0;
			BlogPk = MagicPost.GetSpecialItem(MagicPostTypeInfo.Blog);
			if (BlogPk > 0)
				TagSearchUrl = RouteUtils.GetVirtualPath(BlogPk);

			List<string> postTags = ThePost.Tags.Split(',').ToList<string>();
			if (postTags.Count > 0)
			{
				Repeater_tags.DataSource = postTags;
				Repeater_tags.DataBind();

				string[] tagsArray = postTags.ToArray();
				MagicPostCollection related = MagicPost.SearchByKeyword(tagsArray, MagicOrdinamento.DateDesc, -1, false, new WhereClauseCollection());
				int index = -1;
				for (int i = 0; i < related.Count; i++)
				{
					if (related[i].Pk == ThePost.Pk)
					{
						index = i;
					}
				}
				if (index > -1)
					related.RemoveAt(index);

				if (related.Count > 0)
				{
					Repeater_related.DataSource = related;
					Repeater_related.DataBind();

				}

			}

		}
	}
}