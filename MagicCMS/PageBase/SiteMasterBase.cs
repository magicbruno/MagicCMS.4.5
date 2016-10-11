using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using MagicCMS.Core;

namespace MagicCMS.PageBase
{
	/// <summary>
	/// Class SiteMasterBase. Define global properties inherited by all <see cref="System.Web.UI.MasterPage"/> descendant of a MagicCMS application.
	/// </summary>
	/// <seealso cref="System.Web.UI.MasterPage" />
	public abstract class SiteMasterBase : System.Web.UI.MasterPage
	{
		/// <summary>
		/// Gets or sets the <see cref="MagicCMS.Core.MagicPost"/> to be rendered on current page.
		/// </summary>
		/// <value>The post.</value>
		public MagicPost ThePost { get; set; }
		/// <summary>
		/// Gets or sets the title of the HTML page.
		/// </summary>
		/// <value>The title.</value>
		public String TheTitle { get; set; }
		/// <summary>
		/// Gets the CMS configuration.
		/// </summary>
		/// <value>The CMS configuration.</value>
		public CMS_Config CmsConfig { get; set; }
		/// <summary>
		/// Gets or sets the keywords (tags) of current page.
		/// </summary>
		/// <value>The keywords.</value>
		public string Keywords { get; set; }
		/// <summary>
		/// Gets or sets the description. (Used for HTML meta description tag)
		/// </summary>
		/// <value>The description.</value>
		public string Description { get; set; }
		/// <summary>
		/// Gets or sets the page image. Uset for the Facebook "og:image" meta tag.
		/// </summary>
		/// <value>The page image.</value>
		public string PageImage { get; set; }

		/// <summary>
		/// Gets the connection string.
		/// </summary>
		/// <value>
		/// The connection string.
		/// </value>
		public string ConnectionString
		{
			get
			{
				return MagicUtils.MagicConnectionString;
			}
		}

	}
}