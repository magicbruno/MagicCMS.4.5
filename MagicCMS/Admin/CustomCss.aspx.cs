using MagicCMS.CustomCss;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace MagicCMS.Admin
{
	public partial class CustomCss : System.Web.UI.Page
	{
		public string CssText { get; set; }
		protected void Page_Load(object sender, EventArgs e)
		{
			System.Web.Script.Serialization.JavaScriptSerializer serializer = new System.Web.Script.Serialization.JavaScriptSerializer();
			MagicCss customCss = MagicCss.GetCurrent();
			
			CssText = serializer.Serialize( customCss.CssText);
		}
	}
}