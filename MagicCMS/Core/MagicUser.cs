using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Security.Cryptography;
using System.IO;
using System.Text;
using System.Data;
using System.Data.SqlClient;
//using MagicCMS.Core;
using System.Net.Mail;


namespace MagicCMS.Core
{
	/// <summary>
	/// Enumeration: User login states
	/// </summary>
	/// <remarks>Values: Success, WrongUserName, WrongPassword, WrongUserNameOrPassword, PasswordResend, NotActivated, NotLogged, CheckError, PwdFormatError, GenericError, Activated</remarks>
	public enum MbUserLoginResult
	{
		Success, WrongUserName, WrongPassword, WrongUserNameOrPassword, PasswordResend, NotActivated, NotLogged, CheckError, PwdFormatError, GenericError, Activated
	}

	public class MagicUser
	{
        #region PublicProperties
		/// <summary>
		/// Gets or sets the pk. Unique ID
		/// </summary>
		/// <value>The pk.</value>
        public int Pk { get; set; }
		/// <summary>
		/// Gets or sets the email. 
		/// </summary>
		/// <value>The email.</value>
		/// <remarks>Email is also the login username.</remarks>
        public string Email { get; set; }
		/// <summary>
		/// Gets or sets the password.
		/// </summary>
		/// <value>The password.</value>
		/// <remarks>Passwords are encrypted. The only way to have your password the first time is receiving it by email </remarks>
        public string Password { get; set; }
		/// <summary>
		/// Gets or sets the complete name of the user.
		/// </summary>
		/// <value>The name.</value>
        public string Name { get; set; }
		/// <summary>
		/// Gets or sets the prerogative level <see cref="MagicCMS.Core.MagicPrerogativa.Prerogative"/>,
		/// </summary>
		/// <value>The level.</value>
        public int Level { get; set; }

		/// <summary>
		/// Gets prerogative description.
		/// </summary>
		/// <value>The level description.</value>
        public string LevelDescription
        {
            get
            {
                if (MagicPrerogativa.Prerogative.Keys.Contains<int>(Level))
                    return MagicPrerogativa.Prerogative[Level];
                else
                    return String.Empty;
            }

        }

		/// <summary>
		/// Gets or sets the last modify date.
		/// </summary>
		/// <value>The last modify date.</value>
        public DateTime LastModify { get; set; }
		/// <summary>
		/// Gets or sets the <see cref="MagicCMS.Core.MbUserLoginResult"/>. Login status of the user.
		/// </summary>
		/// <value>The login result.</value>
        public MbUserLoginResult LoginResult { get; set; }
		/// <summary>
		/// Gets or sets the profile pk.
		/// </summary>
		/// <value>The profile pk.</value>
		/// <remarks>Reserved for future extensions</remarks>
        public int Profile_PK { get; set; }
		/// <summary>
		/// Gets or sets the active.
		/// </summary>
		/// <value>The active.</value>
		/// <remarks>Reserved for future extensions</remarks>
		public Boolean Active { get; set; }

        #endregion

        #region Constructor
        private void Init(int pk)
        {
            Pk = 0;
            LastModify = DateTime.Now;
            LoginResult = MbUserLoginResult.NotLogged;
            SqlConnection conn = null;
            SqlCommand cmd = null;
            try
            {
                string cmdStr = " SELECT " +
                                    " 	au.usr_PK, " +
                                    " 	au.usr_EMAIL, " +
                                    " 	au.usr_NAME, " +
                                    " 	au.usr_PASSWORD, " +
                                    " 	au.usr_LEVEL, " +
                                    " 	au.usr_LAST_MODIFIED, " +
                                    " 	au.usr_PROFILE_PK, " +
                                    " 	au.usr_ACTIVE " +
                                    " FROM ANA_USR au " +
                                    " WHERE au.usr_PK= @pk ";

                conn = new SqlConnection(MagicUtils.MagicConnectionString);
                conn.Open();
                cmd = new SqlCommand(cmdStr, conn);
                cmd.Parameters.AddWithValue("@pk", pk);
                SqlDataReader reader = cmd.ExecuteReader(CommandBehavior.SingleRow);
                if (reader.HasRows)
                {
                    reader.Read();
                    Pk = Convert.ToInt32(reader.GetValue(0));
                    Email = Convert.ToString(reader.GetValue(1));
                    if (!reader.IsDBNull(2))
                        Name = Convert.ToString(reader.GetValue(2));
                    if (!reader.IsDBNull(3))
                        Password = Decrypt(Convert.ToString(reader.GetValue(3)));
                    Level = Convert.ToInt32(reader.GetValue(4));
                    if (!reader.IsDBNull(5))
                        LastModify = Convert.ToDateTime(reader.GetValue(5));
                    Profile_PK = Convert.ToInt32(reader.GetValue(6));
                    Active = Convert.ToBoolean(reader.GetValue(7));
                    if (Active)
                        LoginResult = MbUserLoginResult.Success;
                    else
                        LoginResult = MbUserLoginResult.NotActivated;
                }
                else
                    LoginResult = MbUserLoginResult.WrongUserNameOrPassword;
            }
            catch (Exception e)
            {
                MagicLog log = new MagicLog("ANA_USR", Pk, LogAction.Read, e);
                log.Insert();
            }
            finally
            {
                if (conn != null)
                    conn.Dispose();
                if (cmd != null)
                    cmd.Dispose();
            }

        }

        private void Init(string username, string pwd)
        {
            Pk = 0;
            LastModify = DateTime.Now;
            LoginResult = MbUserLoginResult.NotLogged;
            SqlConnection conn = null;
            SqlCommand cmd = null;
            try
            {
                string cmdStr = " SELECT " +
                                    " 	au.usr_PK, " +
                                    " 	au.usr_EMAIL, " +
                                    " 	au.usr_NAME, " +
                                    " 	au.usr_PASSWORD, " +
                                    " 	au.usr_LEVEL, " +
                                    " 	au.usr_LAST_MODIFIED, " +
                                    " 	au.usr_PROFILE_PK, " +
                                    " 	au.usr_ACTIVE " +
                                    " FROM ANA_USR au " +
                                    " WHERE au.usr_EMAIL = @usr_EMAIL " +
                                    " AND au.usr_PASSWORD = @usr_PASSWORD ";

                conn = new SqlConnection(MagicUtils.MagicConnectionString);
                conn.Open();
                cmd = new SqlCommand(cmdStr, conn);
                cmd.Parameters.AddWithValue("@usr_EMAIL", username);
                cmd.Parameters.AddWithValue("@usr_PASSWORD", Encrypt(pwd));
                SqlDataReader reader = cmd.ExecuteReader(CommandBehavior.SingleRow);
                if (reader.HasRows)
                {
                    reader.Read();
                    Pk = Convert.ToInt32(reader.GetValue(0));
                    Email = Convert.ToString(reader.GetValue(1));
                    if (!reader.IsDBNull(2))
                        Name = Convert.ToString(reader.GetValue(2));
                    if (!reader.IsDBNull(3))
                        Password = Decrypt(Convert.ToString(reader.GetValue(3)));
                    Level = Convert.ToInt32(reader.GetValue(4));
                    if (!reader.IsDBNull(5))
                        LastModify = Convert.ToDateTime(reader.GetValue(5));
                    Profile_PK = Convert.ToInt32(reader.GetValue(6));
                    Active = Convert.ToBoolean(reader.GetValue(7));
                    if (Active)
                        LoginResult = MbUserLoginResult.Success;
                    else
                        LoginResult = MbUserLoginResult.NotActivated;
                }
                else
                    LoginResult = MbUserLoginResult.WrongUserNameOrPassword;
            }
            catch (Exception e)
            {
                MagicLog log = new MagicLog("ANA_USR", Pk, LogAction.Read, e);
                log.Insert();
            }
            finally
            {
                if (conn != null)
                    conn.Dispose();
                if (cmd != null)
                    cmd.Dispose();
            }

        }


        /// <summary>
        /// Initializes a new empty instance of the <see cref="MagicUser"/> class.
        /// </summary>
        public MagicUser()
        {
            Pk = 0;
            LastModify = DateTime.Now;
            LoginResult = MbUserLoginResult.NotLogged;
            Name = "Anonimo";
        }

        /// <summary>
        /// Initializes a new instance of the <see cref="MagicUser"/> class fletching it from MagicCMS database.
        /// </summary>
        /// <param name="pk">The instance primary key.</param>
        public MagicUser(int pk)
        {
            Init(pk);
        }


        /// <summary>
        /// Initializes a new instance of the <see cref="MagicUser"/> class on user login, checking username (email) and password.
        /// </summary>
        /// <param name="username">The username.</param>
        /// <param name="pwd">The password.</param>
        public MagicUser(string username, string pwd)
        {
            Init(username, pwd);
        } 
        #endregion

        #region Public Methods
		/// <exclude />
        public Boolean MergeContext(HttpContext context)
        {
            Boolean result = true;
            try
            {
                Type t = typeof(MagicUser);
                foreach (System.Reflection.PropertyInfo pinfo in t.GetProperties())
                {
                    if (!String.IsNullOrEmpty(context.Request[pinfo.Name]))
                    {
                        if (pinfo.PropertyType.Equals(typeof(int)))
                        {
                            pinfo.SetValue(this, Convert.ToInt32(context.Request[pinfo.Name]), null);
                        }
                        else
                            pinfo.SetValue(this, Convert.ToString(context.Request[pinfo.Name]), null);
                    }

                }

            }
            catch (Exception e)
            {
                MagicLog log = new MagicLog("ANA_USR", Pk, LogAction.Read, e);
                log.Error = e.Message;
                result = false;
            }
            return result;
        }

        /// <summary>
        /// Change the password.
        /// </summary>
        /// <param name="newPassword">The new password.</param>
        /// <returns>True on success otherwise false</returns>
        public Boolean ChangePassword(string newPassword)
        {
             Boolean result = true;
            SqlConnection conn = null;
            SqlCommand cmd = null;
            String retValue;
            try
            {
                conn = new SqlConnection(MagicUtils.MagicConnectionString);
                string cmdStr = " BEGIN TRY " +
                                " 	BEGIN TRANSACTION " +
                                " 		UPDATE ANA_USR " +
                                " 		SET usr_PASSWORD = @pwd " +
                                " 		WHERE usr_PK = @pk " +
                                " 	COMMIT TRANSACTION " +
                                " 	SELECT @@error " +
                                " END TRY " +
                                " BEGIN CATCH " +
                                " 	SELECT ERROR_MESSAGE(); " +
                                "  " +
                                " 	IF XACT_STATE() <> 0 " +
                                " 	BEGIN " +
                                " 		ROLLBACK TRANSACTION " +
                                " 	END " +
                                " END CATCH; ";
                conn.Open();
                cmd = new SqlCommand(cmdStr, conn);
                cmd.Parameters.AddWithValue("@pwd", Encrypt(newPassword));
                cmd.Parameters.AddWithValue("@pk", Pk);

                retValue = Convert.ToString(cmd.ExecuteScalar());
                int r;
                if (int.TryParse(retValue, out r))
                {
                    Init(Pk);
                    MagicLog log = new MagicLog("ANA_USR", Pk, LogAction.Update, "", "");
                    log.Error = "SUCCESS";
                    log.Insert();
                }
                else
                {
                    MagicLog log = new MagicLog("ANA_USR", Pk, LogAction.Update, "", "");
                    log.Error = retValue;
                    log.Insert();
                    result = false;
                }
            }
            catch (Exception e)
            {
                MagicLog log = new MagicLog("ANA_USR", Pk, LogAction.Update, e);
                log.Insert();
                result = false;
            }
            finally
            {
                if (conn != null)
                    conn.Dispose();
                if (cmd != null)
                    cmd.Dispose();
            }
            return result;
        }

		/// <summary>
		/// Resets the password.
		/// </summary>
		/// <param name="username">The username.</param>
		/// <returns>MbUserLoginResult.</returns>
        public static MbUserLoginResult ResetPassword(string username)
        {
            if (String.IsNullOrEmpty(username))
                return MbUserLoginResult.WrongUserName;

            SqlConnection conn = null;
            SqlCommand cmd = null;
            try
            {
                string cmdStr = " SELECT " +
                                    " au.usr_PK " +
                                    " FROM ANA_USR au " +
                                    " WHERE au.usr_EMAIL = @usr_EMAIL ";

                conn = new SqlConnection(MagicUtils.MagicConnectionString);
                conn.Open();
                cmd = new SqlCommand(cmdStr, conn);
                cmd.Parameters.AddWithValue("@usr_EMAIL", username);
                SqlDataReader reader = cmd.ExecuteReader(CommandBehavior.SingleRow);
                if (reader.HasRows)
                {
                    reader.Read();
                    int pk = Convert.ToInt32(reader.GetValue(0));
                    MagicUser user = new MagicUser(pk);
                    string newPassword = MagicUtils.CreateRandomPassword(10);
                    if (user.ChangePassword(newPassword))
                    {
                        if (user.SendPwdMail(""))
                            return MbUserLoginResult.Success;
                        else
                            return MbUserLoginResult.GenericError;
                    }
                    else
                        return MbUserLoginResult.GenericError;
                }
                else
                    return MbUserLoginResult.WrongUserName;
            }
            catch (Exception e)
            {
                MagicLog log = new MagicLog("ANA_USR", 0, LogAction.Read, e);
                log.Insert();
            }
            finally
            {
                if (conn != null)
                    conn.Dispose();
                if (cmd != null)
                    cmd.Dispose();
            }
            return MbUserLoginResult.Success;
        }

		/// <summary>
		/// Verifies if the username exists in users database.
		/// </summary>
		/// <param name="username">The username.</param>
		/// <returns>Boolean. True is exists</returns>
        public static Boolean UsernameExists(string username)
        {
              Boolean result = true;

            SqlConnection conn = null;
            SqlCommand cmd = null;
            try
            {
                string cmdStr = " SELECT " +
                                    " au.usr_PK " +
                                    " FROM ANA_USR au " +
                                    " WHERE au.usr_EMAIL = @usr_EMAIL ";

                conn = new SqlConnection(MagicUtils.MagicConnectionString);
                conn.Open();
                cmd = new SqlCommand(cmdStr, conn);
                cmd.Parameters.AddWithValue("@usr_EMAIL", username);
                SqlDataReader reader = cmd.ExecuteReader(CommandBehavior.SingleRow);
                if (!reader.HasRows)
                {
                    result = false;
                }
            }
            catch (Exception e)
            {
                MagicLog log = new MagicLog("ANA_USR", 0, LogAction.Read, e);
                log.Insert();
            }
            finally
            {
                if (conn != null)
                    conn.Dispose();
                if (cmd != null)
                    cmd.Dispose();
            }
            return result;
        }



		/// <summary>
		/// Sends the password to user email address adding a message.
		/// </summary>
		/// <param name="msg">The message.</param>
		/// <returns>Boolean. True on success</returns>
        public Boolean SendPwdMail(string msg)
        {
            CMS_Config config = new CMS_Config();
            MailMessage notifyUser = new MailMessage();
            notifyUser.Priority = MailPriority.High;
            SmtpClient smtp = new SmtpClient(config.SmtpServer, 25);
            try
            {
                string siteName = HttpContext.Current.Request.Url.Host;
                smtp.UseDefaultCredentials = false;
                smtp.Credentials = new System.Net.NetworkCredential(config.SmtpUsername, config.SmtpPassword);
                notifyUser.From = new MailAddress(config.SmtpDefaultFromMail);
                notifyUser.To.Add(Email);
                notifyUser.Subject = "Invio credenziali di accesso per il sito " + siteName;
                notifyUser.IsBodyHtml = true;
                notifyUser.Body = "<p>Egr. Sig./ Gent.le Sig.ra " + Name + ", <br />" +
                                "<p>" + msg + "</p>" +
                                "<p>Per accedere all'area riservata dovrà usare come username il Suo indirizzo di posta " +
                                " e come password questa serie di caratteri generata automaticamente: <br />" +
                                "<b>" + Password + "</b><br /></p>" +
                                "<p>Una volta effettutato l'accesso potrà sostituire la password generata dal sistema con una di Suo gusto.</p>" +
                                "<p>Cordiali Saluti</p>" +
                                "<p>Il team di " + siteName + "</p>";
                smtp.Send(notifyUser);
            }
            catch
            {
                return false;
            }
            finally
            {
                notifyUser.Dispose();
            }
            return true;
        }

		/// <summary>
		/// Inserts this instance in user table.
		/// </summary>
		/// <returns>System.Int32. Unique ID of the user</returns>
        public int Insert()
        {
            int pk = 0;
            if (Pk > 0) return Pk;

            SqlConnection conn = null;
            SqlCommand cmd = null;
            string retvalue = "";
            try
            {
                string cmdText = " BEGIN TRY " +
                                    " 	BEGIN TRANSACTION " +
                                    " 		INSERT ANA_USR (usr_EMAIL, usr_NAME, usr_LEVEL, usr_LAST_MODIFIED, usr_PROFILE_PK) " +
                                    " 			VALUES (@usr_EMAIL, @usr_NAME,  @usr_LEVEL, GETDATE(), @usr_PROFILE_PK); " +
                                    " 	COMMIT TRANSACTION " +
                                    " 	SELECT SCOPE_IDENTITY() " +
                                    " END TRY " +
                                    " BEGIN CATCH " +
                                    "  " +
                                    "   	IF XACT_STATE() <> 0 BEGIN " +
                                    " 		ROLLBACK TRANSACTION " +
                                    "   	END " +
                                    " 	SELECT ERROR_MESSAGE();  " +
                                    " END CATCH; ";

                conn = new SqlConnection(MagicUtils.MagicConnectionString);
                conn.Open();
                cmd = new SqlCommand(cmdText, conn);
                cmd.Parameters.AddWithValue("@usr_EMAIL", Email);
                cmd.Parameters.AddWithValue("@usr_NAME", Name);
                cmd.Parameters.AddWithValue("@usr_LEVEL", Level);
                cmd.Parameters.AddWithValue("@usr_PROFILE_PK", Profile_PK);

                retvalue = Convert.ToString(cmd.ExecuteScalar());

                if (int.TryParse(retvalue, out pk))
                {
                    MagicLog log = new MagicLog("ANA_USR", Pk, LogAction.Insert, "", "");
                    log.Error = "SUCCESS";
                    log.Insert();
                }
                else
                {
                    MagicLog log = new MagicLog("ANA_USR", Pk, LogAction.Insert, "", "");
                    log.Error = retvalue;
                    log.Insert();
                }
            }
            catch (Exception e)
            {
                MagicLog log = new MagicLog("ANA_MATERIE", Pk, LogAction.Insert, e);
                log.Error = e.Message;
                log.Insert();
            }
            finally
            {
                if (conn != null)
                    conn.Dispose();
                if (cmd != null)
                    cmd.Dispose();
            }
            Pk = pk;
            return pk;
        }

		/// <summary>
		/// Save this modified instance updating MagicCMS database.
		/// </summary>
		/// <returns>Boolean.</returns>
        public Boolean Update()
        {
            if (Pk == 0) return false;
            Boolean result = true;
            SqlConnection conn = null;
            SqlCommand cmd = null;
            string retValue = "";

            try
            {
                string cmdText = " BEGIN TRY " +
                                    " 	BEGIN TRANSACTION " +
                                    "       UPDATE ANA_USR " +
                                    "           SET	usr_EMAIL = @usr_EMAIL, " +
                                    " 	        usr_NAME = @usr_NAME, " +
                                    " 	        usr_LEVEL = @usr_LEVEL, " +
                                    " 	        usr_PROFILE_PK = @usr_PROFILE_PK " +
                                    "       WHERE usr_PK = @pk " +
                                    " 	COMMIT TRANSACTION " +
                                    " 	SELECT @pk " +
                                    " END TRY " +
                                    " BEGIN CATCH " +
                                    " 	IF XACT_STATE() <> 0 " +
                                    " 	BEGIN " +
                                    " 		ROLLBACK TRANSACTION " +
                                    " 	END " +
                                    " 	SELECT " +
                                    " 		(ERROR_MESSAGE()) " +
                                    " END CATCH; ";

                conn = new SqlConnection(MagicUtils.MagicConnectionString);
                conn.Open();
                cmd = new SqlCommand(cmdText, conn);
                cmd.Parameters.AddWithValue("@usr_EMAIL", Email);
                cmd.Parameters.AddWithValue("@usr_NAME", Name);
                cmd.Parameters.AddWithValue("@usr_LEVEL", Level);
                cmd.Parameters.AddWithValue("@usr_PROFILE_PK", Profile_PK);
                cmd.Parameters.AddWithValue("@pk", Pk);

                int r = 0;
                retValue = Convert.ToString(cmd.ExecuteScalar());

                if (int.TryParse(retValue, out r))
                {
                    MagicLog log = new MagicLog("ANA_USR", Pk, LogAction.Update, "", "");
                    log.Error = "SUCCESS";
                    log.Insert();
                }
                else
                {
                    MagicLog log = new MagicLog("ANA_USR", Pk, LogAction.Update, "", "");
                    log.Error = retValue;
                    log.Insert();
                }
                result = (r > 0);
            }
            catch (Exception e)
            {
                MagicLog log = new MagicLog("ANA_USR", Pk, LogAction.Update, e);
                log.Error = e.Message;
                log.Insert();
                result = false;
            }
            finally
            {
                if (conn != null)
                    conn.Dispose();
                if (cmd != null)
                    cmd.Dispose();
            }
            return result;
        }


        #endregion

        #region Static methods

		/// <summary>
		/// Count the record.
		/// </summary>
		/// <returns>System.Int32. The count</returns>
        public static int RecordCount()
        {
            SqlConnection conn = null;
            SqlCommand cmd = null;
            int count = 0;
            #region cmdString
            string cmdString = " BEGIN TRY " +
                                " 	SELECT " +
                                " 		COUNT(*) " +
                                " 	FROM ANA_USR " +
                                " END TRY " +
                                " BEGIN CATCH " +
                                " 	SELECT " +
                                " 		ERROR_MESSAGE(); " +
                                " END CATCH; ";
            #endregion
            try
            {
                string cmdText = cmdString;

                conn = new SqlConnection(MagicUtils.MagicConnectionString);
                conn.Open();

                cmd = new SqlCommand(cmdText, conn);

                string result = cmd.ExecuteScalar().ToString();
                if (!int.TryParse(result, out count))
                {
                    MagicLog log = new MagicLog("ANA_USR", 0, LogAction.Read, "", "");
                    log.Error = result;
                    log.Insert();
                }

            }
            catch (Exception e)
            {
                MagicLog log = new MagicLog("ANA_USR", 0, LogAction.Read, e);
                log.Insert();
            }
            finally
            {
                if (conn != null)
                    conn.Dispose();
                if (cmd != null)
                    cmd.Dispose();
            }
            return count;
        }

        #endregion

        #region Utility
        static private string Encrypt(string clearText)
        {
            string EncryptionKey = "MAKV2SPBNI99212";
            byte[] clearBytes = Encoding.Unicode.GetBytes(clearText);
            using (Aes encryptor = Aes.Create())
            {
                Rfc2898DeriveBytes pdb = new Rfc2898DeriveBytes(EncryptionKey, new byte[] { 0x49, 0x76, 0x61, 0x6e, 0x20, 0x4d, 0x65, 0x64, 0x76, 0x65, 0x64, 0x65, 0x76 });
                encryptor.Key = pdb.GetBytes(32);
                encryptor.IV = pdb.GetBytes(16);
                using (MemoryStream ms = new MemoryStream())
                {
                    using (CryptoStream cs = new CryptoStream(ms, encryptor.CreateEncryptor(), CryptoStreamMode.Write))
                    {
                        cs.Write(clearBytes, 0, clearBytes.Length);
                        cs.Close();
                    }
                    clearText = Convert.ToBase64String(ms.ToArray());
                }
            }
            return clearText;
        }

        static private string Decrypt(string cipherText)
        {
            string EncryptionKey = "MAKV2SPBNI99212";
            byte[] cipherBytes = Convert.FromBase64String(cipherText);
            using (Aes encryptor = Aes.Create())
            {
                Rfc2898DeriveBytes pdb = new Rfc2898DeriveBytes(EncryptionKey, new byte[] { 0x49, 0x76, 0x61, 0x6e, 0x20, 0x4d, 0x65, 0x64, 0x76, 0x65, 0x64, 0x65, 0x76 });
                encryptor.Key = pdb.GetBytes(32);
                encryptor.IV = pdb.GetBytes(16);
                using (MemoryStream ms = new MemoryStream())
                {
                    using (CryptoStream cs = new CryptoStream(ms, encryptor.CreateDecryptor(), CryptoStreamMode.Write))
                    {
                        cs.Write(cipherBytes, 0, cipherBytes.Length);
                        cs.Close();
                    }
                    cipherText = Encoding.Unicode.GetString(ms.ToArray());
                }
            }
            return cipherText;
        }
        
        #endregion
	}

}