using MagicCMS.Core;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace $rootnamespace$.Themes.Winstrap
{
	public partial class TopicPage : MagicCMS.PageBase.MasterTheme
	{
		new protected void Page_Load(object sender, EventArgs e)
		{
			base.Page_Load(sender, e);
			MagicPostCollection articles = ThePost.GetChildren(MagicOrdinamento.Asc, -1);
			Repeater_TopicNavPills.DataSource = articles;
			Repeater_TopicNavPills.DataBind();

			Repeater_TopicSections.DataSource = articles;
			Repeater_TopicSections.DataBind();


		}
	}
}