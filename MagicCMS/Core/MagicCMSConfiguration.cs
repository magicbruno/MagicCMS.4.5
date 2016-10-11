 ////////////////////////////////////////////////////////////////////////////////////////////////////
/// @file   MagicCMS\MagicCMSConfiguration.cs
///
/// @brief  Implements the magic CMS configuration class.
////////////////////////////////////////////////////////////////////////////////////////////////////

using System;
using System.Configuration;

namespace MagicCMS.Core
{
    /// <summary>
    /// Wrap Class for MagicCMSConfiguration Configuration Section in Web.config
    /// </summary>
    public class MagicCMSConfiguration : ConfigurationSection
    {
		/// <exclude />
        public MagicCMSConfiguration()
        {
        }

		/// <summary>
		/// Get the database connection Name
		/// </summary>
		/// <value>The name of the connection.</value>
        [ConfigurationProperty("ConnectionName", IsRequired = true)]
        public string ConnectionName
        {
            get { return this["ConnectionName"] as string; }
        }

		/// <summary>
		/// Default Path of MagicCMS theme
		/// </summary>
		/// <value>The theme path.</value>
        [ConfigurationProperty("ThemePath", IsRequired = true)]
        public string ThemePath
        {
            get { return this["ThemePath"] as string; }
        }

		/// <exclude />
        [ConfigurationProperty("DefaultThemePath", IsRequired = true)]
        public string DefaultThemePath
        {
            get { return this["DefaultThemePath"] as string; }
        }

		/// <summary>
		/// Gets the default content master page file.
		/// </summary>
		/// <value>The default content master page.</value>
        [ConfigurationProperty("DefaultContentMaster", IsRequired = true)]
        public string DefaultContentMaster
        {
            get { return this["DefaultContentMaster"] as string; }
        }

		/// <summary>
		/// Gets the name of the default SMTP server.
		/// </summary>
		/// <value>The name of the SMTP server.</value>
		/// <remarks>IMPORTANT: This field is REQUIRED. You must provide smtp data and email address where to receive admin password </remarks>
		[ConfigurationProperty("smtpServerName", DefaultValue = "smtp.magicbusmultimedia.it", IsRequired = false)]
        public string SmtpServerName
        {
            get { return this["smtpServerName"] as string; }
        }

		/// <summary>
		/// Gets the name of the SMTP user.
		/// </summary>
		/// <value>The name of the SMTP user.</value>
		/// <remarks>IMPORTANT: This field is REQUIRED. You must provide smtp data and email address where to receive admin password </remarks>
		[ConfigurationProperty("smtpUsername", DefaultValue = "username", IsRequired = false)]
        public string SmtpUserName
        {
            get { return this["smtpUsername"] as string; }
        }

		/// <summary>
		/// Gets the SMTP password.
		/// </summary>
		/// <value>The SMTP password.</value>
		/// <remarks>IMPORTANT: This field is REQUIRED. You must provide smtp data and email address where to receive admin password </remarks>
		[ConfigurationProperty("smtpPassword", DefaultValue = "password", IsRequired = false)]
        public string SmtpPassword
        {
            get { return this["smtpPassword"] as string; }
        }

		/// <summary>
		/// Gets the SMTP default from mail.
		/// </summary>
		/// <value>The SMTP default from mail.</value>
		/// <remarks>IMPORTANT: This field is REQUIRED. You must provide smtp data and email address where to receive admin password </remarks>
		[ConfigurationProperty("smtpDefaultFromMail", DefaultValue = "", IsRequired = false)]
        public string SmtpDefaultFromMail
        {
            get { return this["smtpDefaultFromMail"] as string; }
        }

		/// <summary>
		/// Gets the SMTP admin mail.
		/// </summary>
		/// <value>The SMTP admin mail.</value>
		/// <remarks>IMPORTANT: This field is REQUIRED. You must provide smtp data and email address where to receive admin password </remarks>
        [ConfigurationProperty("smtpAdminMail", DefaultValue = "", IsRequired = false)]
        public string SmtpAdminMail
        {
            get { return this["smtpAdminMail"] as string; }
        }

		/// <summary>
		/// Gets the support mail.
		/// </summary>
		/// <value>The support mail.</value>
        [ConfigurationProperty("supportMail", DefaultValue = "", IsRequired = false)]
        public string SupportMail
        {
            get { return this["supportMail"] as string; }
        }

		/// <summary>
		/// Gets the editors mail.
		/// </summary>
		/// <value>The editors mail.</value>
        [ConfigurationProperty("editorsMail", DefaultValue = "", IsRequired = false)]
        public string EditorsMail
        {
            get { return this["editorsMail"] as string; }
        }

		/// <summary>
		/// Gets the default image.
		/// </summary>
		/// <value>The default image.</value>
        [ConfigurationProperty("defaultImage", DefaultValue = "", IsRequired = false)]
        public string DefaultImage
        {
            get { return this["defaultImage"] as string; }
        }

		/// <exclude />
        [ConfigurationProperty("indexTypes", DefaultValue = "", IsRequired = false)]
        public string IndexTypes
        {
            get { return this["indexTypes"] as string; }
        }

		/// <exclude />
        [ConfigurationProperty("indexField", DefaultValue = "", IsRequired = false)]
        public string IndexField
        {
            get { return this["indexField"] as string; }
        }

		/// <summary>
		/// Gets the images path.
		/// </summary>
		/// <value>The images path.</value>
        [ConfigurationProperty("imagesPath", DefaultValue = "/db_images/", IsRequired = false)]
        public string ImagesPath
        {
            get { return this["imagesPath"] as string; }
        }

		/// <summary>
		/// Gets the allowed file types.
		/// </summary>
		/// <value>The allowed file types.</value>
		/// <remarks>A comma separates list of allowed file extension the user may transfer to the server</remarks>
        [ConfigurationProperty("allowedFileTypes", DefaultValue = "", IsRequired = false)]
        public string AllowedFileTypes
        {
            get
            {
                return this["allowedFileTypes"] as string;
            }
        }

		/// <summary>
		/// Gets the length of auto generated MagicPost <see cref="MagicCMS.Core.MagicPost.TestoBreve_RT"/>.
		/// </summary>
		/// <value>The length.</value>
        [ConfigurationProperty("testoBreveDefLength", DefaultValue = 300, IsRequired = true)]
        public int TestoBreveDefLength
        {
            get
            {
                return (int)this["testoBreveDefLength"];
            }
        }

		/// <summary>
		/// Gets the google recaptcha secret key.
		/// </summary>
		/// <value>The google recaptcha secret.</value>
		/// <remarks>If you provide a recaptcha secret key and a recaptcha site key, login will be protected by the only humans Google recaptcha control.</remarks>
        [ConfigurationProperty("GoogleCaptchaSecret", DefaultValue = "", IsRequired = false)]
        public string GoogleCaptchaSecret
        {
            get
            {
                return this["GoogleCaptchaSecret"] as string;
            }
        }

		/// <summary>
		/// Gets the google recaptcha site key.
		/// </summary>
		/// <value>The google captcha site.</value>
		/// <remarks>If you provide a recaptcha secret key and a recaptcha site key, login will be protected by the only humans Google recaptcha control.</remarks>
		[ConfigurationProperty("GoogleCaptchaSite", DefaultValue = "", IsRequired = false)]
        public string GoogleCaptchaSite
        {
            get
            {
                return this["GoogleCaptchaSite"] as string;
            }
        }

		/// <summary>
		/// Gets the ckeditor CDN url.
		/// </summary>
		/// <value>The ckeditor CDN url.</value>
		[ConfigurationProperty("CkeditorCdn", DefaultValue = "", IsRequired = false)]
		public string CkeditorCdn
		{
			get
			{
				return this["CkeditorCdn"] as string;
			}
		}

		/// <summary>
		/// Gets the jQuery 1 version. Default: 1.12.3
		/// </summary>
		/// <value>Gets the jQuery 1 version.</value>
		/// <remarks>Used when the browser less or equal to IE8.</remarks>
		[ConfigurationProperty("jQueryLow", DefaultValue = "1.12.3", IsRequired = true)]
		public string jQueryLow
		{
			get
			{
				return this["jQueryLow"] as string;
			}
		}

		/// <summary>
		/// Gets jQuery version for modern browser. Default: 2.2.3
		/// </summary>
		/// <value>The jQuery version.</value>
		[ConfigurationProperty("jQueryHigh", DefaultValue = "2.2.3", IsRequired = true)]
		public string jQueryHigh
		{
			get
			{
				return this["jQueryHigh"] as string;
			}
		}

		/// <exclude />
		[ConfigurationProperty("FileChangesMonitorStop", DefaultValue = false, IsRequired = false)]
        public bool? FileChangesMonitorStop
        {
            get
            {
                return this["FileChangesMonitorStop"] as bool?;
            }
        }

		/// <summary>
		/// Gets the google map API key.
		/// </summary>
		/// <value>The google map API key.</value>
		[ConfigurationProperty("GoogleMapApiKey", DefaultValue = "AIzaSyAVZbx9mgbVL3CFyN62HVR0mioD32sW_6Q", IsRequired = true)]
		public string GoogleMapApiKey
		{
			get
			{
				return this["GoogleMapApiKey"] as string;
			}
		}


		/// <summary>
		/// Gets the configuration.
		/// </summary>
		/// <returns>MagicCMSConfiguration.</returns>
        public static MagicCMSConfiguration GetConfig()
        {
            //return ConfigurationSettings.GetConfig("MagicCMSConfigSection") as MagicCMSConfiguration;
            return System.Web.Configuration.WebConfigurationManager.GetSection("MagicCMSConfigSection") as MagicCMSConfiguration;

        }

    }
}