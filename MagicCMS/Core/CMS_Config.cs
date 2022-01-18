using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Reflection;
using System.Web;

namespace MagicCMS.Core
{
	/// <summary>
	/// Class CMS_Config. Wrapper class for MagicCMS application configuration setting. 
	/// </summary>
	/// <remarks>
	/// Most initial value are fetched by Web.config file. All settings are stored in the MagicCMS database.
	/// </remarks>
    public class CMS_Config
    {
        #region Public Properties

        private MagicCMSConfiguration _defaults;
        private MagicCMSConfiguration Defaults
        {
            get
            {
                if (_defaults == null)
                    _defaults = MagicCMSConfiguration.GetConfig();

                return _defaults;
            }
        }

        // Google Analytics
		/// <summary>
		/// Gets or sets the Google Analytics ID for the web site. 
		/// </summary>
		/// <value>Google Analytics ID.</value>
		/// <remarks>
		/// If no ID is provided the Google Analytics Java script interface will be not inserted in Web Pages. 
		/// </remarks>
        public string GaProperty_ID { get; set; }

		/// <summary>
		/// Single page flag.
		/// </summary>
		/// <value>The single page.</value>
		/// <remarks>
		/// If this flag is set MagicCMS will check il menu links point to external pages or to local links in the home pages. Set this flag if your application 
		/// has a landing home page with menu items that points to sections on the same page.
		/// </remarks>
        public Boolean SinglePage { get; set; }
		/// <exclude />
        public Boolean MultiPage { get; set; }

        //Site Name

		/// <summary>
		/// Gets or sets the name of the site. Used in titles and in facebook meta data.
		/// </summary>
		/// <value>The name of the site.</value>
        public string SiteName { get; set; }

        private string _smtpServer;

		/// <summary>
		/// Gets or sets the SMTP server name.
		/// </summary>
		/// <value>The SMTP server name.</value>
		/// <remarks>
		/// SMTP server used by MagicCMS to send or resend passwords to user. Initial value is the value inserted in web.config. 
		/// IMPORTANT! Is very important define SMTP server and password in web.config file. 
		/// MagicCMS passwords are encrypted and, at the moment, the only way to receive the administrator password is to insert 
		/// Admin email address, smtp server, smtp user name and smtp password in the web.config file.
		/// </remarks> 
        public string SmtpServer
        {
            get
            {
                if (String.IsNullOrEmpty(_smtpServer))
                    return Defaults.SmtpServerName;
                return _smtpServer;
            }
            set { _smtpServer = value; }
        }


        private string _smtpUsername;

		/// <summary>
		/// Gets or sets the SMTP user name.
		/// </summary>
		/// <value>The SMTP user name.</value>
		/// <remarks>SMTP server used by MagicCMS to send or resend passwords to user. Initial value is the value inserted in web.config.
		/// IMPORTANT! Is very important define SMTP server and password in web.config file.
		/// MagicCMS passwords are encrypted and, at the moment, the only way to receive the administrator password is to insert
		/// Admin email address, smtp server, smtp user name and smtp password in the web.config file.</remarks>
		public string SmtpUsername
        {
            get
            {
                if (String.IsNullOrEmpty(_smtpUsername))
                    return Defaults.SmtpUserName;
                return _smtpUsername;
            }
            set { _smtpUsername = value; }
        }


        private string _smtpPassword;

		/// <summary>
		/// Gets or sets the SMTP user password.
		/// </summary>
		/// <value>The SMTP user password.</value>
		/// <remarks>SMTP server used by MagicCMS to send or resend passwords to user. Initial value is the value inserted in web.config.
		/// IMPORTANT! Is very important define SMTP server and password in web.config file.
		/// MagicCMS passwords are encrypted and, at the moment, the only way to receive the administrator password is to insert
		/// Admin email address, smtp server, smtp user name and smtp password in the web.config file.</remarks>
		public string SmtpPassword
        {
            get
            {
                if (String.IsNullOrEmpty(_smtpPassword))
                    return Defaults.SmtpPassword;
                return _smtpPassword;
            }
            set { _smtpPassword = value; }
        }


        private string _smtpDefaultFromMail;

		/// <summary>
		/// Gets or sets the SMTP default from mail.
		/// </summary>
		/// <value>The SMTP default from mail.</value>
        public string SmtpDefaultFromMail
        {
            get
            {
                if (String.IsNullOrEmpty(_smtpDefaultFromMail))
                    return Defaults.SmtpDefaultFromMail;
                return _smtpDefaultFromMail;
            }
            set { _smtpDefaultFromMail = value; }
        }


        private string _smtpAdminMail;

		/// <summary>
		/// Gets or sets the SMTP Admin mail.
		/// </summary>
		/// <value>The SMTP Admin email address.</value>
		/// <remarks>SMTP server used by MagicCMS to send or resend passwords to user. Initial value is the value inserted in web.config.
		/// IMPORTANT! Is very important define SMTP server and password in web.config file.
		/// MagicCMS passwords are encrypted and, at the moment, the only way to receive the administrator password is to insert
		/// Admin email address, smtp server, smtp user name and smtp password in the web.config file.</remarks>
		public string SmtpAdminMail
        {
            get
            {
                if (String.IsNullOrEmpty(_smtpAdminMail))
                    return Defaults.SmtpAdminMail;
                return _smtpAdminMail;
            }
            set { _smtpAdminMail = value; }
        }


        private Boolean _transAuto = true;
		/// <summary>
		/// Gets or sets the Bing Translation flag.
		/// </summary>
		/// <value>The Bing Translation flag.</value>
		/// <remarks>If activate you can call Bing Translation engine to translate post and then correct translations manually. You will need also to set 
		/// <see cref="TransClientId"/> and <see cref="TransSecretKey"/>. You can get this ids subscribing to Microsoft DataMarket Developers for free. </remarks>
        public Boolean TransAuto
        {
            get
            {
                return _transAuto && !(/*String.IsNullOrEmpty(TransClientId) || */String.IsNullOrEmpty(TransSecretKey));
            }
            set
            {
                _transAuto = value;
            }
        }

        private string _defaultContentMaster;

		/// <summary>
		/// Gets or sets the default Master Page File.
		/// </summary>
		/// <value>The default Master Page File.</value>
        public string DefaultContentMaster
        {
            get { return (_defaultContentMaster == null) ? Defaults.DefaultContentMaster : _defaultContentMaster; }
            set { _defaultContentMaster = value; }
        }
        

        private string _themePath;

		/// <summary>
		/// Gets or sets the theme path.
		/// </summary>
		/// <value>The theme path.</value>
		/// <remarks>This is the directory of MagicCMS will find all theme files.</remarks>
        public string ThemePath
        {
            get
            {
                if (String.IsNullOrEmpty(_themePath))
                    return Defaults.ThemePath;
                return _themePath;
            }
            set { _themePath = value; }
        }

        private string _imagePath;
		/// <summary>
		/// Gets or sets the images path.
		/// </summary>
		/// <value>The images path.</value>
		/// <remarks>This is the directory of MagicCMS will find all global images. (Favorites ico, Apple icons, Default Facebook image).</remarks>
		public string ImagesPath
        {
            get
            {
                if (String.IsNullOrEmpty(_imagePath))
                    return Defaults.ImagesPath;
                return _imagePath;
            }
            set { _imagePath = value; }
        }

        private string _defaultImage;
		/// <summary>
		/// Gets or sets the default image url.
		/// </summary>
		/// <value>The default image url.</value>
		/// <remarks>Image used when non image is available for a post.</remarks>
        public string DefaultImage
        {
            get
            {
                if (String.IsNullOrEmpty(_defaultImage))
                    return Defaults.DefaultImage;
                return _defaultImage;
            }
            set { _defaultImage = value; }
        }

		/// <summary>
		/// Gets or sets the registered application client ID for Bing Translator engine access.. 
		/// </summary>
		/// <value>The application client ID.</value>
        public String TransClientId { get; set; }
		/// <summary>
		/// Gets or sets the application secret key for Bing Translator engine access.
		/// </summary>
		/// <value>The application secret key.</value>
        public String TransSecretKey { get; set; }
		/// <summary>
		/// Gets or sets the default language ID (example: "it").
		/// </summary>
		/// <value>The trans source language ID.</value>
        public string TransSourceLangId { get; set; }
		/// <summary>
		/// Gets or sets the name of the default language. (example: "italiano").
		/// </summary>
		/// <value>The name of the trans source language.</value>
        public string TransSourceLangName { get; set; }
		/// <summary>
		/// Gets or sets the start page ID (<see cref="MagicCMS.Core.MagicPost.Pk"/>).
		/// </summary>
		/// <value>The start page ID .</value>
		/// <remarks>The MagicCMS application will stat showing this page.</remarks>
        public int StartPage { get; set; }
		/// <summary>
		/// Gets or sets the main menu ID (<see cref="MagicCMS.Core.MagicPost.Pk"/>).
		/// </summary>
		/// <value>The main menu ID.</value>
        public int MainMenu { get; set; }
		/// <summary>
		/// Gets or sets the secondary menu ID (<see cref="MagicCMS.Core.MagicPost.Pk"/>).
		/// </summary>
		/// <value>The secondary menu ID.</value>
        public int SecondaryMenu { get; set; }
		/// <summary>
		/// Gets or sets the footer menu ID (<see cref="MagicCMS.Core.MagicPost.Pk"/>).
		/// </summary>
		/// <value>The footer menu ID.</value>
        public int FooterMenu { get; set; }


		/// <summary>
		/// Gets or sets the specified property by property name.
		/// </summary>
		/// <param name="propertyName">Name of the property.</param>
		/// <returns>Property value</returns>
        public object this[string propertyName]
        {
            get
            {
                if (this.GetType().GetProperty(propertyName) == null)
                    return null;
                return this.GetType().GetProperty(propertyName).GetValue(this, null);
            }
            set
            {
                if (this.GetType().GetProperty(propertyName) != null)
                    this.GetType().GetProperty(propertyName).SetValue(this, value, null);
            }
        }

        #endregion

        #region Constructor

		/// <summary>
		/// An instance of the <see cref="CMS_Config"/> class is automatically created by the application
		/// </summary>
        public CMS_Config()
        {
            Init();
        }

        private void Init()
        {

            SqlConnection conn = new SqlConnection(MagicUtils.MagicConnectionString);
            SqlCommand cmd = new SqlCommand();

            string commandString = " SELECT " +
                                    "     c.CON_SinglePage, " +
                                    "     c.CON_MultiPage, " +
                                    "     c.CON_TRANS_Auto, " +
                                    "     c.CON_TRANS_Id, " +
                                    "     c.CON_TRANS_SecretKey, " +
                                    "     c.CON_TRANS_SourceLangId, " +
                                    "     c.CON_TransSourceLangName, " +
                                    "     c.CON_ThemePath, " +
                                    "     c.CON_ImagesPath, " +
                                    "     c.CON_DefaultImage, " +
                                    "     c.CON_SMTP_Server, " +
                                    "     c.CON_SMTP_Username, " +
                                    "     c.CON_SMTP_Password, " +
                                    "     c.CON_SMTP_DefaultFromMail, " +
                                    "     c.CON_SMTP_AdminMail, " +
                                    "     c.CON_ga_Property_ID, " +
                                    "     c.CON_DefaultContentMaster, " +
                                    "     c.CON_NAV_StartPage, " +
                                    "     c.CON_NAV_MainMenu, " +
                                    "     c.CON_NAV_SecondaryMenu, " +
                                    "     c.CON_NAV_FooterMenu, " +
                                    "     c.CON_SiteName " +
                                    " FROM CONFIG c " +
                                    " WHERE c.CON_PK = 0 ";

            try
            {
                conn.Open();
                cmd.CommandText = commandString;

                cmd.Connection = conn;

                SqlDataReader reader = cmd.ExecuteReader(CommandBehavior.SingleRow);
                if (reader.Read())
                    Init(reader);
                else
                {
                    SinglePage = false;
                    MultiPage = true;
                    TransAuto = true;
                    TransSecretKey = "";
                    TransClientId = "";
                    TransSourceLangId = "it";
                    TransSourceLangName = "Italiano";
                    SmtpServer = Defaults.SmtpServerName;
                    SmtpUsername = Defaults.SmtpUserName;
                    SmtpPassword = Defaults.SmtpPassword;
                    SmtpDefaultFromMail = Defaults.SmtpDefaultFromMail;
                    SmtpAdminMail = Defaults.SmtpAdminMail;
                    ThemePath = (!String.IsNullOrEmpty(Defaults.ThemePath) ? Defaults.ThemePath : Defaults.DefaultThemePath);
                    ImagesPath = Defaults.ImagesPath;
                    DefaultImage = Defaults.DefaultImage;
                    GaProperty_ID = "";
                    StartPage = MainMenu = SecondaryMenu = FooterMenu = 0;
                    SiteName = "MagicCMS Site";

                    Save();
                }

            }
            catch (Exception e)
            {
                MagicLog log = new MagicLog("CONFIG", 0, LogAction.Read, e);
                log.Insert();
            }
            finally
            {
                conn.Close();
                //conn.Dispose();
                cmd.Dispose();
            }
        }

        private void Init(SqlDataReader record)
        {
            SinglePage = (!record.IsDBNull(0) ? Convert.ToBoolean(record.GetValue(0)) : false);
            MultiPage = (!record.IsDBNull(1) ? Convert.ToBoolean(record.GetValue(1)) : true);
            TransAuto = (!record.IsDBNull(2) ? Convert.ToBoolean(record.GetValue(2)) : true);
            TransClientId = (!record.IsDBNull(3) ? Convert.ToString(record.GetValue(3)) : "");
            TransSecretKey = (!record.IsDBNull(4) ? Convert.ToString(record.GetValue(4)) : "");
            TransSourceLangId = (!record.IsDBNull(5) ? Convert.ToString(record.GetValue(5)) : "it");
            TransSourceLangName = (!record.IsDBNull(6) ? Convert.ToString(record.GetValue(6)) : "Italiano");
            ThemePath = (!record.IsDBNull(7) ? Convert.ToString(record.GetValue(7)) : Defaults.ThemePath);
            ImagesPath = (!record.IsDBNull(8) ? Convert.ToString(record.GetValue(8)) : Defaults.ImagesPath);
            DefaultImage = (!record.IsDBNull(9) ? Convert.ToString(record.GetValue(9)) : Defaults.DefaultImage);
            SmtpServer = (!record.IsDBNull(10) ? Convert.ToString(record.GetValue(10)) : Defaults.SmtpServerName);
            SmtpUsername = (!record.IsDBNull(11) ? Convert.ToString(record.GetValue(11)) : Defaults.SmtpUserName);
            SmtpPassword = (!record.IsDBNull(12) ? Convert.ToString(record.GetValue(12)) : Defaults.SmtpPassword);
            SmtpDefaultFromMail = (!record.IsDBNull(13) ? Convert.ToString(record.GetValue(13)) : Defaults.SmtpDefaultFromMail);
            SmtpAdminMail = (!record.IsDBNull(14) ? Convert.ToString(record.GetValue(14)) : Defaults.SmtpAdminMail);
            GaProperty_ID = (!record.IsDBNull(15) ? Convert.ToString(record.GetValue(15)) : "");
            DefaultContentMaster = (!record.IsDBNull(16) ? Convert.ToString(record.GetValue(16)) : Defaults.DefaultContentMaster);
            StartPage = (!record.IsDBNull(17) ? Convert.ToInt32(record.GetValue(17)) : 0);
            MainMenu = (!record.IsDBNull(18) ? Convert.ToInt32(record.GetValue(18)) : 0);
            SecondaryMenu = (!record.IsDBNull(19) ? Convert.ToInt32(record.GetValue(19)) : 0);
            FooterMenu = (!record.IsDBNull(20) ? Convert.ToInt32(record.GetValue(20)) : 0);
            SiteName = (!record.IsDBNull(21) ? Convert.ToString(record.GetValue(21)) : "MagicCMS Site");
        }

        #endregion

        #region Public Methods

		/// <summary>
		/// Saves this instance.
		/// </summary>
		/// <returns>Boolean.</returns>
        public Boolean Save()
        {
            // Se il record di log è già esistente non lo inserisco
            Boolean res = true;
            SqlConnection conn = null;
            SqlCommand cmd = null;
            #region cmdString
            string cmdString = @"  BEGIN TRY 
                                     BEGIN TRANSACTION 
                                         IF EXISTS (SELECT 
                                                 c.CON_PK 
                                             FROM CONFIG c 
                                             WHERE c.CON_PK = 0) 
                                         BEGIN 
                                             UPDATE CONFIG 
                                             SET CON_SinglePage = @CON_SinglePage, 
                                                 CON_MultiPage = @CON_MultiPage, 
                                                 CON_TRANS_Auto = @CON_TRANS_Auto, 
                                                 CON_TRANS_Id = @CON_TRANS_Id, 
                                                 CON_TRANS_SecretKey = @CON_TRANS_SecretKey, 
                                                 CON_TRANS_SourceLangId = @CON_TRANS_SourceLangId,  
                                                 CON_TransSourceLangName = @CON_TransSourceLangName,  
                                                 CON_SMTP_Server = @CON_SMTP_Server, 
                                                 CON_SMTP_Username = @CON_SMTP_Username, 
                                                 CON_SMTP_Password = @CON_SMTP_Password, 
                                                 CON_SMTP_DefaultFromMail = @CON_SMTP_DefaultFromMail, 
                                                 CON_SMTP_AdminMail =@CON_SMTP_AdminMail, 
                                                 CON_ThemePath = @CON_ThemePath, 
                                                 CON_ImagesPath = @CON_ImagesPath, 
                                                 CON_DefaultImage = @CON_DefaultImage, 
                                                 CON_ga_Property_ID = @CON_ga_Property_ID, 
                                                 CON_DefaultContentMaster = @CON_DefaultContentMaster, 
                                                 CON_NAV_StartPage = @CON_NAV_StartPage, 
                                                 CON_NAV_MainMenu = @CON_NAV_MainMenu, 
                                                 CON_NAV_SecondaryMenu = @CON_NAV_SecondaryMenu, 
                                                 CON_NAV_FooterMenu = @CON_NAV_FooterMenu, 
                                                 CON_SiteName = @CON_SiteName 
                                             WHERE CON_PK = 0 
                                         END 
                                         ELSE 
                                         BEGIN 
                                             INSERT CONFIG (CON_PK, CON_SinglePage, CON_MultiPage, CON_TRANS_Auto, CON_TRANS_Id, CON_TRANS_SecretKey, CON_TRANS_SourceLangId, CON_TransSourceLangName, CON_ThemePath, CON_ImagesPath, CON_SMTP_Server, CON_SMTP_Username, CON_SMTP_Password, CON_SMTP_DefaultFromMail, CON_SMTP_AdminMail, CON_DefaultImage, CON_ga_Property_ID, CON_DefaultContentMaster, CON_NAV_StartPage, CON_NAV_MainMenu, CON_NAV_SecondaryMenu, CON_NAV_FooterMenu, CON_SiteName) 
                                                 VALUES (0, @CON_SinglePage, @CON_MultiPage, @CON_TRANS_Auto, @CON_TRANS_Id, @CON_TRANS_SecretKey, @CON_TRANS_SourceLangId, @CON_TransSourceLangName,  @CON_ThemePath, @CON_ImagesPath, @CON_SMTP_Server, @CON_SMTP_Username, @CON_SMTP_Password, @CON_SMTP_DefaultFromMail, @CON_SMTP_AdminMail, @CON_DefaultImage, @CON_ga_Property_ID, @CON_DefaultContentMaster, @CON_NAV_StartPage, @CON_NAV_MainMenu, @CON_NAV_SecondaryMenu, @CON_NAV_FooterMenu, @CON_SiteName); 
                                         END 
                                     COMMIT TRANSACTION 
                                 END TRY 
                                 BEGIN CATCH 
                                     IF XACT_STATE() <> 0 
                                     BEGIN 
                                         ROLLBACK TRANSACTION 
                                     END;
                                     THROW;
                                 END CATCH; ";
            #endregion
            try
            {
                string cmdText = cmdString;

                conn = new SqlConnection(MagicUtils.MagicConnectionString);
                conn.Open();
                cmd = new SqlCommand(cmdText, conn);
                cmd.Parameters.AddWithValue("@CON_SinglePage", SinglePage);
                cmd.Parameters.AddWithValue("@CON_MultiPage", MultiPage);
                cmd.Parameters.AddWithValue("@CON_TRANS_Auto", TransAuto);
                cmd.Parameters.AddWithValue("@CON_TRANS_Id", TransClientId);
                cmd.Parameters.AddWithValue("@CON_TRANS_SecretKey", TransSecretKey);
                cmd.Parameters.AddWithValue("@CON_TRANS_SourceLangId", TransSourceLangId);
                cmd.Parameters.AddWithValue("@CON_TransSourceLangName", TransSourceLangName);
                cmd.Parameters.AddWithValue("@CON_ThemePath", ThemePath);
                cmd.Parameters.AddWithValue("@CON_DefaultImage", DefaultImage);
                cmd.Parameters.AddWithValue("@CON_ImagesPath", ImagesPath);
                cmd.Parameters.AddWithValue("@CON_SMTP_Server", SmtpServer);
                cmd.Parameters.AddWithValue("@CON_SMTP_Username", SmtpUsername);
                cmd.Parameters.AddWithValue("@CON_SMTP_Password", SmtpPassword);
                cmd.Parameters.AddWithValue("@CON_SMTP_DefaultFromMail", SmtpDefaultFromMail);
                cmd.Parameters.AddWithValue("@CON_SMTP_AdminMail", SmtpAdminMail);
                cmd.Parameters.AddWithValue("@CON_ga_Property_ID", GaProperty_ID);
                cmd.Parameters.AddWithValue("@CON_DefaultContentMaster", DefaultContentMaster);
                cmd.Parameters.AddWithValue("@CON_NAV_StartPage", StartPage);
                cmd.Parameters.AddWithValue("@CON_NAV_MainMenu", MainMenu);
                cmd.Parameters.AddWithValue("@CON_NAV_SecondaryMenu", SecondaryMenu);
                cmd.Parameters.AddWithValue("@CON_NAV_FooterMenu", FooterMenu);
                cmd.Parameters.AddWithValue("@CON_SiteName", SiteName);

                int result = cmd.ExecuteNonQuery();

                if (result > 0)
                {
                    MagicLog log = new MagicLog("CONFIG", 0, LogAction.Insert, "", "");
                    log.Error = "SUCCESS";
                    log.Insert();
                }
                else
                {
                    MagicLog log = new MagicLog("CONFIG", 0, LogAction.Insert, "", "");
                    log.Error = "Record non aggiornato";
                    log.Insert();
                }
            }
            catch (Exception e)
            {
                MagicLog log = new MagicLog("CONFIG", 0, LogAction.Insert, e);
                log.Insert();
            }
            finally
            {
                if (conn != null)
                    conn.Dispose();
                if (cmd != null)
                    cmd.Dispose();
            }
            return res;
        }

		/// <exclude />
        public Boolean MergeContext(HttpContext context, string[] propertyList, out string msg)
        {
            Boolean result = true;
            msg = "Success";
            Type TheType = typeof(CMS_Config);
            try
            {
                for (int i = 0; i < propertyList.Length; i++)
                {
                    string propName = propertyList[i];
                    PropertyInfo pi = TheType.GetProperty(propName);
                    if (pi != null)
                    {
                        Type propType = pi.PropertyType;
                        if (propType.Equals(typeof(int)))
                        {
                            int n = 0;
                            int.TryParse(context.Request[propName], out n);
                            this[propName] = n;
                        }
                        else if (propType.Equals(typeof(decimal)))
                        {
                            decimal nd = 0;
                            decimal.TryParse(context.Request[propName], out nd);
                            this[propName] = nd;
                        }
                        else if (propType.Equals(typeof(Boolean)))
                        {
                            bool b;
                            bool.TryParse(context.Request[propName], out b);
                            this[propName] = b;
                        }
                        else if (propType.Equals(typeof(DateTime)))
                        {
                            DateTime d;
                            if (!String.IsNullOrEmpty(context.Request[propName]))
                            {
                                if (DateTime.TryParse(context.Request[propName],
                                    System.Globalization.CultureInfo.CurrentCulture,
                                    System.Globalization.DateTimeStyles.None, out d))
                                    this[propName] = d;
                            }
                        }
                        else if (propType.Equals(typeof(DateTime?)))
                        {
                            DateTime d;
                            if (!String.IsNullOrEmpty(context.Request[propName]))
                            {
                                if (DateTime.TryParseExact(
                                    context.Request[propName],
                                    "s",
                                    System.Globalization.CultureInfo.InvariantCulture,
                                    System.Globalization.DateTimeStyles.AssumeUniversal, out d))
                                    this[propName] = d;
                            }
                            else
                                this[propName] = null;
                        }
                        else if (propType.Equals(typeof(List<int>)))
                        {
                            List<int> list = new List<int>();
                            string[] strArray = context.Request[propName].Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries);
                            int n;
                            for (int k = 0; k < strArray.Length; k++)
                            {
                                if (int.TryParse(strArray[k], out n))
                                    list.Add(n);
                            }
                            //remove duplicates from list
                            list.Sort();
                            int index = 0;
                            while (index < list.Count - 1)
                            {
                                if (list[index] == list[index + 1])
                                    list.RemoveAt(index);
                                else
                                    index++;
                            }
                            this[propName] = list;
                        }
                        else
                        {
                            this[propName] = context.Request[propName].ToString();
                        }
                    }
                }
            }
            catch (Exception e)
            {
                MagicLog log = new MagicLog("CONFIG", 0, LogAction.Read, e);
                log.Insert();
                msg = e.Message;
                result = false;
            }

            return result;
        }


        #endregion
    }
}