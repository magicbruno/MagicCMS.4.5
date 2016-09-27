using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Reflection;
using System.Web;

namespace MagicCMS.Core
{
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

        // Google Analitycs
        public string GaProperty_ID { get; set; }

        // Sigle Multipage
        public Boolean SinglePage { get; set; }
        public Boolean MultiPage { get; set; }

        //Site Name

        public string SiteName { get; set; }

        private string _smtpServer;

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
        public Boolean TransAuto
        {
            get
            {
                return _transAuto && !(String.IsNullOrEmpty(TransClientId) || String.IsNullOrEmpty(TransSecretKey));
            }
            set
            {
                _transAuto = value;
            }
        }

        private string _defaultContentMaster;

        public string DefaultContentMaster
        {
            get { return (_defaultContentMaster == null) ? Defaults.DefaultContentMaster : _defaultContentMaster; }
            set { _defaultContentMaster = value; }
        }
        

        private string _themePath;

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

        public String TransClientId { get; set; }
        public String TransSecretKey { get; set; }
        public string TransSourceLangId { get; set; }
        public string TransSourceLangName { get; set; }
        public int StartPage { get; set; }
        public int MainMenu { get; set; }
        public int SecondaryMenu { get; set; }
        public int FooterMenu { get; set; }


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

        public Boolean Save()
        {
            // Se il record di log è già esistente non lo inserisco
            Boolean res = true;
            SqlConnection conn = null;
            SqlCommand cmd = null;
            #region cmdString
            string cmdString = " BEGIN TRY " +
                                "     BEGIN TRANSACTION " +
                                "         IF EXISTS (SELECT " +
                                "                 c.CON_PK " +
                                "             FROM CONFIG c " +
                                "             WHERE c.CON_PK = 0) " +
                                "         BEGIN " +
                                "             UPDATE CONFIG " +
                                "             SET CON_SinglePage = @CON_SinglePage, " +
                                "                 CON_MultiPage = @CON_MultiPage, " +
                                "                 CON_TRANS_Auto = @CON_TRANS_Auto, " +
                                "                 CON_TRANS_Id = @CON_TRANS_Id, " +
                                "                 CON_TRANS_SecretKey = @CON_TRANS_SecretKey, " +
                                "                 CON_TRANS_SourceLangId = @CON_TRANS_SourceLangId,  " +
                                "                 CON_TransSourceLangName = @CON_TransSourceLangName,  " +
                                "                 CON_SMTP_Server = @CON_SMTP_Server, " +
                                "                 CON_SMTP_Username = @CON_SMTP_Username, " +
                                "                 CON_SMTP_Password = @CON_SMTP_Password, " +
                                "                 CON_SMTP_DefaultFromMail = @CON_SMTP_DefaultFromMail, " +
                                "                 CON_SMTP_AdminMail =@CON_SMTP_AdminMail, " +
                                "                 CON_ThemePath = @CON_ThemePath, " +
                                "                 CON_ImagesPath = @CON_ImagesPath, " +
                                "                 CON_DefaultImage = @CON_DefaultImage, " +
                                "                 CON_ga_Property_ID = @CON_ga_Property_ID, " +
                                "                 CON_DefaultContentMaster = @CON_DefaultContentMaster, " +
                                "                 CON_NAV_StartPage = @CON_NAV_StartPage, " +
                                "                 CON_NAV_MainMenu = @CON_NAV_MainMenu, " +
                                "                 CON_NAV_SecondaryMenu = @CON_NAV_SecondaryMenu, " +
                                "                 CON_NAV_FooterMenu = @CON_NAV_FooterMenu, " +
                                "                 CON_SiteName = @CON_SiteName " +
                                "             WHERE CON_PK = 0 " +
                                "         END " +
                                "         ELSE " +
                                "         BEGIN " +
                                "             INSERT CONFIG (CON_PK, CON_SinglePage, CON_MultiPage, CON_TRANS_Auto, CON_TRANS_Id, CON_TRANS_SecretKey, CON_TRANS_SourceLangId, CON_TransSourceLangName, CON_ThemePath, CON_ImagesPath, CON_SMTP_Server, CON_SMTP_Username, CON_SMTP_Password, CON_SMTP_DefaultFromMail, CON_SMTP_AdminMail, CON_DefaultImage, CON_ga_Property_ID, CON_DefaultContentMaster, CON_NAV_StartPage, CON_NAV_MainMenu, CON_NAV_SecondaryMenu, CON_NAV_FooterMenu, CON_SiteName) " +
                                "                 VALUES (0, @CON_SinglePage, @CON_MultiPage, @CON_TRANS_Auto, @CON_TRANS_Id, @CON_TRANS_SecretKey, @CON_TRANS_SourceLangId, @CON_TransSourceLangName,  @CON_ThemePath, @CON_ImagesPath, @CON_SMTP_Server, @CON_SMTP_Username, @CON_SMTP_Password, @CON_SMTP_DefaultFromMail, @CON_SMTP_AdminMail, @CON_DefaultImage, @CON_ga_Property_ID, @CON_DefaultContentMaster, @CON_NAV_StartPage, @CON_NAV_MainMenu, @CON_NAV_SecondaryMenu, @CON_NAV_FooterMenu, @CON_SiteName); " +
                                "         END " +
                                "     COMMIT TRANSACTION " +
                                "     SELECT " +
                                "         @@error " +
                                " END TRY " +
                                " BEGIN CATCH " +
                                "  " +
                                "     SELECT " +
                                "         ERROR_MESSAGE(); " +
                                "  " +
                                "     IF XACT_STATE() <> 0 " +
                                "     BEGIN " +
                                "         ROLLBACK TRANSACTION " +
                                "     END " +
                                " END CATCH; ";
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

                string result = cmd.ExecuteScalar().ToString();
                int error;
                if (int.TryParse(result, out error))
                {
                    if (error == 0)
                    {
                        MagicLog log = new MagicLog("CONFIG", 0, LogAction.Insert, "", "");
                        log.Error = "Success";
                        log.Insert();

                    }
                    else
                    {
                        MagicLog log = new MagicLog("CONFIG", 0, LogAction.Insert, "", "");
                        log.Error = "SQL Error n. " + result;
                        log.Insert();

                    }
                }
                else
                {
                    MagicLog log = new MagicLog("CONFIG", 0, LogAction.Insert, "", "");
                    log.Error = result;
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