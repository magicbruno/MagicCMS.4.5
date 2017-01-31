using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using MagicCMS.Core;
using MagicCMS.Routing;

namespace $rootnamespace$.Themes.Winstrap
{
	public partial class TwoColumsTemplate : MagicCMS.PageBase.MasterTheme
	{
		public string TagSearchUrl { get; set; }
		new protected void Page_Load(object sender, EventArgs e)
		{
			base.Page_Load(sender, e);
			int BlogPk = 0;
			if (ThePost.Tipo == MagicPostTypeInfo.Blog)
				BlogPk = ThePost.Pk;
			else
				BlogPk = MagicPost.GetSpecialItem(MagicPostTypeInfo.Blog);
			if (BlogPk > 0)
				TagSearchUrl = RouteUtils.GetVirtualPath(BlogPk);

			string currLang = MagicSession.Current.CurrentLanguage == "default" ? MagicSession.Current.Config.TransSourceLangId : MagicSession.Current.CurrentLanguage;
			List<string> tagsCollection = MagicKeyword.GetKeywords("", currLang);
			if (tagsCollection.Count > 0)
			{
				Repeater_tags.DataSource = tagsCollection;
				Repeater_tags.DataBind();
			}
		}
	}
}