using MagicCMS.Core;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace MagicCMS
{
	/// <exclude />
    public partial class _Default : System.Web.UI.Page
    {
        public string Capability { get; set; }
        public MagicPost ThePost;
        public MagicPostCollection PostChildren;

        protected void Page_Load(object sender, EventArgs e)
        {
            Response.Redirect("/home");
        }
    }
}