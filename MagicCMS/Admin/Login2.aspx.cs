using MagicCMS.Core;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace MagicCMS.Admin
{
    public partial class Login2 : System.Web.UI.Page
    {
		public Boolean Captcha { get; set; }
		public string BackEndLang { get; set; }

		protected void Page_Load(object sender, EventArgs e)
        {
			Captcha = !(String.IsNullOrEmpty(MagicCMSConfiguration.GetConfig().GoogleCaptchaSite) ||
				String.IsNullOrEmpty(MagicCMSConfiguration.GetConfig().GoogleCaptchaSecret));
			if (Captcha)
			{
				recaptchaVerify.Attributes.Add("data-sitekey", MagicCMSConfiguration.GetConfig().GoogleCaptchaSite);
			}
			else
				recaptchaVerify.Visible = false;
			BackEndLang = MagicCMSConfiguration.GetConfig().BackEndLang;
		}

		public string Translate(string term)
		{
			if (BackEndLang == "it")
				return term;
			return MagicTransDictionary.Translate(term, BackEndLang);
		}
	}
}