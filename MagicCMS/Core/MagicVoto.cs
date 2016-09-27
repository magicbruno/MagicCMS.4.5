using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

namespace MagicCMS.Core
{
    public class MagicVoto
    {
        public int Pk { get; set; }
        public string User { get; set; }
        public int Post_PK { get; set; }
        public int Voto { get; set; }
        public DateTime LastModify { get; set; }

        private void Init()
        {
            Pk = 0;
            User = "";
            Post_PK = 0;
            LastModify = DateTime.Now;
        }

        private void Init(int pk)
        {
            SqlConnection conn = null;
            SqlCommand cmd = null;

            try
            {
                string cmdText = " SELECT v.Voti_PK, v.Voti_USER, v.Voti_POST_PK, v.Voti_VOTO, v.Voti_LastModify FROM VOTI v WHERE v.Voti_PK = @Pk ";

                conn = new SqlConnection(MagicUtils.MagicConnectionString);
                conn.Open();
                cmd = new SqlCommand(cmdText, conn);
                cmd.Parameters.AddWithValue("@Pk", pk);
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
                MagicLog log = new MagicLog("VOTI", Pk, LogAction.Read, e);
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

        private void Init(SqlDataReader record)
        {
            Pk = Convert.ToInt32(record.GetValue(0));
            if (!record.IsDBNull(1))
                User = Convert.ToString(record.GetValue(1));
            if (!record.IsDBNull(2))
                Post_PK = Convert.ToInt32(record.GetValue(2));
            if (!record.IsDBNull(3))
                Voto = Convert.ToInt32(record.GetValue(3));
            if (!record.IsDBNull(4))
                LastModify = Convert.ToDateTime(record.GetValue(4));
        }

        public MagicVoto()
        {
            Init();
        }

        public MagicVoto(int pk)
        {
            Init(pk);
        }

        public Boolean Insert(out string message)
        {
            Boolean result = true;
            message = "Ok";
            SqlConnection conn = null;
            SqlCommand cmd = null;
            try
            {
                string cmdText =    " BEGIN TRY " +
                                    "     BEGIN TRANSACTION " +
                                    "         DELETE VOTI " +
                                    "         WHERE Voti_USER = @Voti_USER " +
                                    "             AND Voti_POST_PK = @Voti_POST_PK; " +
                                    "  " +
                                    "         INSERT VOTI (Voti_USER, Voti_POST_PK, Voti_VOTO, Voti_LastModify) " +
                                    "             VALUES (@Voti_USER, @Voti_POST_PK, @Voti_VOTO, GETDATE()); " +
                                    "  " +
                                    "         SELECT CONVERT(varchar(10), SCOPE_IDENTITY()) " +
                                    "     COMMIT TRANSACTION " +
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

                conn = new SqlConnection(MagicUtils.MagicConnectionString);
                conn.Open();
                cmd = new SqlCommand(cmdText, conn);
                cmd.Parameters.AddWithValue("@Voti_USER", User);
                cmd.Parameters.AddWithValue("@Voti_POST_PK", Post_PK);
                cmd.Parameters.AddWithValue("@Voti_VOTO", Voto);

                string sqlResult = Convert.ToString(cmd.ExecuteScalar());
                int r;
                int.TryParse(sqlResult, out r);
                Pk = r;
                if (r == 0)
                {
                    result = false;
                    message = sqlResult;
                }
            }
            catch (Exception e)
            {
                MagicLog log = new MagicLog("VOTI", Pk, LogAction.Insert, e);
                log.Insert();
                result = false;
                message = e.Message;
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

        public Boolean Delete()
        {
            Boolean result = true;
            SqlConnection conn = null;
            SqlCommand cmd = null;
            try
            {
                string cmdText = " BEGIN TRY " +
                                    "     BEGIN TRANSACTION " +
                                    "         DELETE VOTI " +
                                    "         WHERE Voti_PK = @pk " +
                                    "         SELECT CONVERT(varchar(10), @@error) " +
                                    "     COMMIT TRANSACTION " +
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

                conn = new SqlConnection(MagicUtils.MagicConnectionString);
                conn.Open();
                cmd = new SqlCommand(cmdText, conn);
                cmd.Parameters.AddWithValue("@pk", Pk);

                string sqlResult = Convert.ToString(cmd.ExecuteScalar());
                if (sqlResult != "0")
                {
                    MagicLog log = new MagicLog("VOTI", Pk, LogAction.Insert, "MagicVoto.cs", "Boolean Delete()");
                    log.Error = sqlResult;
                    log.Insert();
                    result = false;
                }
            }
            catch (Exception e)
            {
                MagicLog log = new MagicLog("VOTI", Pk, LogAction.Insert, e);
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
    }
}