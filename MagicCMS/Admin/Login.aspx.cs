using MagicCMS.Core;
using MagicCMS.reCAPTCHA;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace MagicCMS.Admin
{
    public partial class Login : System.Web.UI.Page
    {
        public Boolean Captcha { get; set; }
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
        }

        protected void Button_submit_Click(object sender, EventArgs e)
        {
            if (Captcha)
            {
                string secret = MagicCMSConfiguration.GetConfig().GoogleCaptchaSecret;
                GoogleReCaptcha grc = new GoogleReCaptcha(secret);
                CaptchaResponse response = grc.ValidateResponse(Request.Form["g-recaptcha-response"]);
                if (!response.success)
                    Response.Redirect(Request.Url.AbsoluteUri  );
            }
            MagicUser user = new MagicUser(email.Text, password.Text);
            if (user.LoginResult == MbUserLoginResult.Success)
            {
                MagicSession.Current.LoggedUser = user;
                MagicSession.Current.SessionStart = DateTime.Now;
                if (!String.IsNullOrEmpty(MagicSession.Current.LastAccessTry))
                    Response.Redirect(MagicSession.Current.LastAccessTry);
                else
                    Response.Redirect("/Admin");
            }
            else
            {
                Response.Redirect(Request.Url.AbsoluteUri);
            }
        }
    }
}