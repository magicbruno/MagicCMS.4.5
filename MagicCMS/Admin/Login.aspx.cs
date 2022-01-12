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
		public string BackEndLang { get; set; }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (IsPostBack)
            {
                if (!string.IsNullOrWhiteSpace(HF_AuthToken.Value))
                {
                    UserToken userToken = new UserToken(HF_AuthToken.Value);
                    MagicSession.Current.LoggedUser = new MagicUser(userToken.UserPk);
                    MagicSession.Current.SessionStart = DateTime.Now;
                    HttpCookie cookie = new HttpCookie("MB_AuthToken", HF_AuthToken.Value);
                    cookie.Secure = true;
                    cookie.Expires = DateTime.Now.AddDays(30);

                    Response.Cookies.Set(cookie);

                    if (!String.IsNullOrEmpty(MagicSession.Current.LastAccessTry))
                        Response.Redirect(MagicSession.Current.LastAccessTry);
                    else
                        Response.Redirect("/Admin");
                } 
            }

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

                UserToken userToken = new UserToken(user);
                string error = "";
                if (userToken.DaysToExpiration <= 1)
                    userToken.RefreshToken(out error);
                HttpCookie cookie = new HttpCookie("MB_AuthToken", userToken.Token);
                cookie.Secure = true;
                cookie.Expires = DateTime.Now.AddDays(30);

                Response.Cookies.Set(cookie);
                
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

		public string Translate(string term)
		{
			if (BackEndLang == "it")
				return term;
			return MagicTransDictionary.Translate(term, BackEndLang);
		}
    }
}