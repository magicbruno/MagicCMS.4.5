using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

namespace MagicCMS.Core
{
    public class MagicTransDictionary
    {
        #region Public Properties

        public int Pk { get; set; }
        public string Source { get; set; }
        public string LangId { get; set; }
        public string Translation { get; set; }

        #endregion

        #region Constructor
        public MagicTransDictionary()
        {
            Init();
        }

        public MagicTransDictionary(int pk)
        {
            Init(pk);
        }

        public MagicTransDictionary(SqlDataReader record)
        {
            Init(record);
        }

        public MagicTransDictionary(string source, string langid)
        {
            Init(source, langid);
        }

        private void Init()
        {
            Pk = 0;
            Source = "";
            LangId = "";
            Translation = "";
        }

        private void Init(int pk)
        {
            SqlConnection conn = new SqlConnection(MagicUtils.MagicConnectionString);
            SqlCommand cmd = new SqlCommand();

            string commandString =  " SELECT " +
                                    "     ad.DICT_Pk, " +
                                    "     ad.DICT_Source, " +
                                    "     ad.DICT_LANG_Id, " +
                                    "     ad.DICT_Translation " +
                                    " FROM ANA_Dictionary ad " +
                                    " WHERE ad.DICT_Pk = @Pk ";

            try
            {
                conn.Open();
                cmd.CommandText = commandString;

                cmd.Connection = conn;
                cmd.Parameters.AddWithValue("@Pk", pk);

                SqlDataReader reader = cmd.ExecuteReader(CommandBehavior.SingleRow);

                if (reader.Read())
                    Init(reader);
                else
                    Pk = 0;

            }
            catch (Exception e)
            {
                MagicLog log = new MagicLog("ANA_Dictionary", pk, LogAction.Read, e);
                log.Insert();
            }
            finally
            {
                conn.Close();
                cmd.Dispose();
            }
        }

        private void Init(string source, string langid)
        {
            SqlConnection conn = new SqlConnection(MagicUtils.MagicConnectionString);
            SqlCommand cmd = new SqlCommand();

            string commandString = " SELECT " +
                                    "     ad.DICT_Pk, " +
                                    "     ad.DICT_Source, " +
                                    "     ad.DICT_LANG_Id, " +
                                    "     ad.DICT_Translation " +
                                    " FROM ANA_Dictionary ad " +
                                    " WHERE ad.DICT_Source = @Source AND ad.DICT_LANG_Id = @Langid ";

            try
            {
                conn.Open();
                cmd.CommandText = commandString;

                cmd.Connection = conn;
                cmd.Parameters.AddWithValue("@Source", source);
                cmd.Parameters.AddWithValue("@Langid", langid);

                SqlDataReader reader = cmd.ExecuteReader(CommandBehavior.SingleRow);

                if (reader.Read())
                    Init(reader);
                else
                    Pk = 0;

            }
            catch (Exception e)
            {
                MagicLog log = new MagicLog("ANA_Dictionary", Pk, LogAction.Read, e);
                log.Insert();
            }
            finally
            {
                conn.Close();
                cmd.Dispose();
            }
        }

        private void Init(SqlDataReader record)
        {
            Pk = (!record.IsDBNull(0) ? Convert.ToInt32(record.GetValue(0)) : 0);
            Source = (!record.IsDBNull(1) ? Convert.ToString(record.GetValue(1)) : "");
            LangId = (!record.IsDBNull(2) ? Convert.ToString(record.GetValue(2)) : "");
            Translation = (!record.IsDBNull(3) ? Convert.ToString(record.GetValue(3)) : "");
        }

        #endregion

        #region Public methds
        public bool Save()
        {
            bool ret = true;
            SqlConnection conn = new SqlConnection(MagicUtils.MagicConnectionString);
            SqlCommand cmd = new SqlCommand();

            string commandString =  " BEGIN TRY " +
                                    "     BEGIN TRANSACTION " +
                                    "         IF EXISTS (SELECT " +
                                    "                 1 " +
                                    "             FROM dbo.ANA_Dictionary " +
                                    "             WHERE DICT_Source = @DICT_Source " +
                                    "             AND DICT_LANG_Id = @DICT_LANG_Id) " +
                                    "         BEGIN " +
                                    "             UPDATE ANA_Dictionary " +
                                    "             SET DICT_Translation = @DICT_Translation " +
                                    "             WHERE DICT_Source = @DICT_Source " +
                                    "             AND DICT_LANG_Id = @DICT_LANG_Id; " +
                                    "             SELECT " +
                                    "                 @Pk " +
                                    "         END " +
                                    "         ELSE " +
                                    "         BEGIN " +
                                    "             INSERT ANA_Dictionary (DICT_Source, DICT_LANG_Id, DICT_Translation) " +
                                    "                 VALUES (@DICT_Source, @DICT_LANG_Id, @DICT_Translation); " +
                                    "             SELECT " +
                                    "                 SCOPE_IDENTITY() " +
                                    "         END " +
                                    "  " +
                                    "     COMMIT TRANSACTION " +
                                    " END TRY " +
                                    " BEGIN CATCH " +
                                    "     SELECT " +
                                    "         ERROR_MESSAGE(); " +
                                    "  " +
                                    "     IF XACT_STATE() <> 0 " +
                                    "     BEGIN " +
                                    "         ROLLBACK TRANSACTION " +
                                    "     END " +
                                    " END CATCH; ";

            try
            {
                conn.Open();
                cmd.CommandText = commandString;

                cmd.Connection = conn;
                cmd.Parameters.AddWithValue("@DICT_Source", Source);
                cmd.Parameters.AddWithValue("@DICT_LANG_Id", LangId);
                cmd.Parameters.AddWithValue("@DICT_Translation", Translation);
                cmd.Parameters.AddWithValue("@Pk", Pk);

                string result = cmd.ExecuteScalar().ToString();
                int pk;
                if (int.TryParse(result, out pk))
                    Pk = (pk > 0) ? pk : Pk;
                else
                {
                    MagicLog log = new MagicLog("ANA_Dictionary", Pk, LogAction.Update,"MagicTransDictionary.cs", "bool Save");
                    log.Error = result;
                    log.Insert();
                    ret = false;
                }

            }
            catch (Exception e)
            {
                MagicLog log = new MagicLog("ANA_Dictionary", Pk, LogAction.Update, e);
                log.Insert();
                ret = false;
            }
            finally
            {
                conn.Close();
                cmd.Dispose();
            }
            return ret;
        }
        #endregion

        #region Static Methods
        public static string Translate(string sentence, string langid)
        {
            
            MagicTransDictionary item = new MagicTransDictionary(sentence, langid);
            if (item.Pk > 0)
                return item.Translation;
            else
                return sentence;
        }

        public static string Translate(string sentence)
        {
            string currentLang = MagicSession.Current.CurrentLanguage;
            if (currentLang == "default")
                return sentence;
            else
                return Translate(sentence, currentLang);
        }

        #endregion
    }
}