using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

/// <exclude />
namespace MagicCMS.Admin
{
    public partial class BaseAdmin : System.Web.UI.MasterPage
    {
        private string _ckeditorCdn = "//cdn.ckeditor.com/4.4.5.1/standard/ckeditor.js";

        public string CkeditorCdn
        {
            get { return _ckeditorCdn; }
            set { _ckeditorCdn = value; }
        }

        public string JQueryVersion
        {
            get
            {
                if (!String.IsNullOrEmpty(MagicCMS.Core.MagicCMSConfiguration.GetConfig().jQueryHigh))
                    return MagicCMS.Core.MagicCMSConfiguration.GetConfig().jQueryHigh;
                return "3.6.0";
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!String.IsNullOrEmpty(MagicCMS.Core.MagicCMSConfiguration.GetConfig().CkeditorCdn))
                CkeditorCdn = MagicCMS.Core.MagicCMSConfiguration.GetConfig().CkeditorCdn;

            System.Web.HttpBrowserCapabilities browser = Request.Browser;
                if (browser.MajorVersion < 9)
                {
                    LiteralLoadRespond.Visible = true;
                    LiteralLoadRespond.Text = "<script src=\"Scripts/respond.min.js\" ></script>";
                }
        }
    }
}