using MagicCMS.Core;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace MagicCMS
{
    public partial class _Default : System.Web.UI.Page
    {
        public string Capability { get; set; }
        public MagicPost ThePost;
        public MagicPostCollection PostChildren;

        protected void Page_Load(object sender, EventArgs e)
        {
            Response.Redirect("/home");
			//System.Web.HttpBrowserCapabilities browser = Request.Browser;
			//string s = "<div>Browser Capabilities<br />"
			//	+ "User agent = " + Request.UserAgent + "<br />"
			//	+ "Type = " + browser.Type + "<br />"
			//	+ "Name = " + browser.Browser + "<br />"
			//	+ "Version = " + browser.Version + "<br />"
			//	+ "Major Version = " + browser.MajorVersion + "<br />"
			//	+ "Minor Version = " + browser.MinorVersion + "<br />"
			//	+ "Platform = " + browser.Platform + "<br />"
			//	+ "Is Beta = " + browser.Beta + "<br />"
			//	+ "Is Crawler = " + browser.Crawler + "<br />"
			//	+ "Is AOL = " + browser.AOL + "<br />"
			//	+ "Is Win16 = " + browser.Win16 + "<br />"
			//	+ "Is Win32 = " + browser.Win32 + "<br />"
			//	+ "Supports Frames = " + browser.Frames + "<br />"
			//	+ "Supports Tables = " + browser.Tables + "<br />"
			//	+ "Supports Cookies = " + browser.Cookies + "<br />"
			//	+ "Supports VBScript = " + browser.VBScript + "<br />"
			//	+ "Supports JavaScript = " +
			//		browser.EcmaScriptVersion.ToString() + "<br />"
			//	+ "Supports Java Applets = " + browser.JavaApplets + "<br />"
			//	+ "Supports ActiveX Controls = " + browser.ActiveXControls
			//		  + "<br />"
			//	+ "Supports JavaScript Version = " +
			//		browser["JavaScriptVersion"] + "<br /></div>";
			//Capability = s;
			//int pk;
			//int.TryParse(Request.QueryString["p"], out pk);
			//ThePost = new MagicPost(pk);
			//PostChildren = ThePost.GetChildrenByType(new int[] { MagicPostTypeInfo.Menu }, MagicOrdinamento.AlphaDesc, true, 2, true, MagicSearchActive.ActiveOnly);
			//ChildrenTest.DataSource = ThePost.GetParents();
			//ChildrenTest.DataBind();
        }
    }
}