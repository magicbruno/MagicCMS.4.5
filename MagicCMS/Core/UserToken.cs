using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

namespace MagicCMS.Core
{
    public class UserToken
    {
        #region Proprietà
        const int EXPIRY = 30;
        public int UserPk { get; set; }
        public string UserEmail { get; set; }
        public string Token { get; set; }

        public DateTime UserLastModified { get; private set; }

        public bool IsExpired
        {
            get
            {
                DateTime expiryDate = UserLastModified.AddDays(EXPIRY);
                return expiryDate < DateTime.Now;
            }
        }

        public int DaysToExpiration
        {
            get
            {
                DateTime expiryDate = UserLastModified.AddDays(EXPIRY);
                TimeSpan timeSpan = expiryDate.Date - DateTime.Today;
                return timeSpan.Days;
            }
        }
        #endregion

        #region constructor
        public UserToken(int pk)
        {
            Init();
        }
        public UserToken(string token)
        {
            string query = string.Format("su.STAT_USER_PASSWORD = '{0}'", token);
            Init(query);
        }

        public UserToken (SqlDataReader reader)
        {
            Init(reader);
        }

        public  UserToken (MagicUser user)
        {
            if (user.LoginResult == MbUserLoginResult.Success)
            {
                string token = CreateToken();
                Init(user.Pk);
                if(UserPk == 0)
                {
                    string error = "";
                    UserPk = user.Pk;
                    Token = token;
                    Save(out error);
                }
            }
            else
            {
                Init();
            }
        }

        private void Init()
        {
            UserPk = 0;
            Token = string.Empty;
            UserEmail = string.Empty;
        }

        private void Init(int userPk)
        {
            string query = "su.STAT_USER_PK = " + userPk.ToString();
            Init(query);
         }

        private void Init(SqlDataReader reader)
        {
            UserPk = reader.GetInt32(0);
            if (!reader.IsDBNull(1)) Token = reader.GetString(1);
            if (!reader.IsDBNull(2)) UserLastModified = reader.GetDateTime(2);
            if (!reader.IsDBNull(3)) UserEmail = reader.GetString(3);
        }

        private void Init(string query)
        {
            SqlConnection conn = null;
            SqlCommand cmd = null;

            try
            {
                string cmdText = @" SELECT
	                                    su.STAT_USER_PK
                                       ,su.STAT_USER_PASSWORD 
                                       ,au.usr_LAST_MODIFIED
                                       ,au.usr_EMAIL
                                    FROM STAT_USER su
                                    INNER JOIN ANA_USR au
	                                    ON au.usr_PK = su.STAT_USER_PK " + 
                                    (string.IsNullOrWhiteSpace(query) ? "" : " WHERE " + query);

                conn = new SqlConnection(MagicUtils.MagicConnectionString);
                conn.Open();
                cmd = new SqlCommand(cmdText, conn);
                SqlDataReader reader = cmd.ExecuteReader(CommandBehavior.SingleRow);
                if (reader.Read())
                {
                    Init(reader);
                }
                else
                {
                    Init();
                }
            }
            catch (Exception e)
            {
                MagicLog log = new MagicLog("User Token: Constructor", 0, LogAction.Read, e);
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

        #endregion

        #region Insert/Delete/Update 

        public bool RefreshToken(out string error)
        {
            Token = CreateToken();
            return Save(out error);
        }

        public bool Save(out string error)
        {
            error = string.Empty;
            bool success = true;

            SqlConnection conn = null;
            SqlCommand cmd = null;
            try
            {
                string cmdText = @" BEGIN TRY
	                                    BEGIN TRANSACTION
	                                    IF EXISTS (SELECT
				                                    1
			                                    FROM STAT_USER su
			                                    WHERE su.STAT_USER_PK = @UserPk)
	                                    BEGIN

		                                    UPDATE STAT_USER
		                                    SET STAT_USER_PASSWORD = @Token
		                                    WHERE STAT_USER_PK = @UserPk;

	                                    END
	                                    ELSE
	                                    BEGIN
		                                    INSERT STAT_USER (STAT_USER_PK, STAT_USER_PASSWORD)
			                                    VALUES (@UserPk, @Token);
	                                    END;

	                                    UPDATE ANA_USR SET usr_LAST_MODIFIED = DEFAULT WHERE usr_PK = @UserPk

	                                    COMMIT TRANSACTION
                                    END TRY
                                    BEGIN CATCH
	                                    IF XACT_STATE() <> 0
	                                    BEGIN
		                                    ROLLBACK TRANSACTION
	                                    END;
	                                    THROW;
                                    END CATCH;";

                conn = new SqlConnection(MagicUtils.MagicConnectionString);
                conn.Open();
                cmd = new SqlCommand(cmdText, conn);
                cmd.Parameters.AddWithValue("@UserPk", UserPk);
                cmd.Parameters.AddWithValue("@Token", Token);
                int result = cmd.ExecuteNonQuery();

            }
            catch (Exception e)
            {
                MagicLog log = new MagicLog("User Token: Constructor", 0, LogAction.Read, e);
                log.Insert();
                error = e.Message;
                success = false;
            }
            finally
            {
                if (conn != null)
                    conn.Dispose();
                if (cmd != null)
                    cmd.Dispose();
            }

            return success;
        }

        public static bool Delete(int pk)
        {
            SqlConnection conn = null;
            SqlCommand cmd = null;
            bool success = true;
            try
            {
                string cmdText = @" DELETE STAT_USER WHERE STAT_USER_PK = " + pk.ToString();

                conn = new SqlConnection(MagicUtils.MagicConnectionString);
                conn.Open();
                cmd = new SqlCommand(cmdText, conn);
                int result = cmd.ExecuteNonQuery();
                success = (result > 0);
            }
            catch (Exception e)
            {
                MagicLog log = new MagicLog("User Token: Constructor", 0, LogAction.Read, e);
                log.Insert();
                success = false;
            }
            finally
            {
                if (conn != null)
                    conn.Dispose();
                if (cmd != null)
                    cmd.Dispose();
            }
            return success;
        }



        public bool Delete()
        {
            return Delete(UserPk);
        }

        #endregion

        #region utilities

        public static bool TokenExist (string token)
        {
            SqlConnection conn = null;
            SqlCommand cmd = null;
            bool exist = false;
            try
            {
                string cmdText = @" SELECT
	                                    COUNT(*)
                                    FROM STAT_USER su
                                    WHERE su.STAT_USER_PASSWORD = @Token " ;

                conn = new SqlConnection(MagicUtils.MagicConnectionString);
                conn.Open();
                cmd = new SqlCommand(cmdText, conn);
                cmd.Parameters.AddWithValue("@Token", token);
                int result = Convert.ToInt32(cmd.ExecuteScalar());
                exist = (result > 0);
            }
            catch (Exception e)
            {
                MagicLog log = new MagicLog("User Token: Constructor", 0, LogAction.Read, e);
                log.Insert();
            }
            finally
            {
                if (conn != null)
                    conn.Dispose();
                if (cmd != null)
                    cmd.Dispose();
            }
            return exist;
        }

        private static string CreateToken()
        {
            string token = MagicUtils.CreateRandomPassword(20);
            while (TokenExist(token))
                token = MagicUtils.CreateRandomPassword(20);
            return token;
        }

        #endregion

    }
}