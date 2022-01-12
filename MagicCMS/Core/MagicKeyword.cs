using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Threading.Tasks;
using System.Web;

namespace MagicCMS.Core
{
	/// <summary>
	/// Class MagicKeyword. Wrapper class for storing and indexing <see cref="MagicCMS.MagicPost.Tags"/> assigned to a <see cref="MagicCMS.MagicPost"/>.
	/// </summary>
    public class MagicKeyword
    {
        #region Public Properties
		/// <summary>
		/// Gets or sets unique id of related post (<see cref="MagicCMS.Core.MagicPost.Pk"/>).
		/// </summary>
		/// <value>The id of related post.</value>
        public int ContentPk { get; set; }
		/// <summary>
		/// Gets or sets the keyword (tag).
		/// </summary>
		/// <value>The keyword.</value>
        public string Keyword { get; set; }
		/// <summary>
		/// Gets or sets the language identifier. Tags are language dependant. Every stored tag belong to a language.
		/// </summary>
		/// <value>The language identifier.</value>
		/// <remarks>Keyword (tag) language.</remarks>
        public string LangId { get; set; }
        #endregion

        #region Costructor

		/// <summary>
		/// Initializes a new instance of the <see cref="MagicKeyword"/> class containing a specific tag for the default language.
		/// </summary>
		/// <param name="contentPk">The id of related post.</param>
		/// <param name="keyword">The keyword.</param>
        public MagicKeyword(int contentPk, string keyword)
        {
            ContentPk = contentPk;
            Keyword = keyword;
            LangId = new CMS_Config().TransSourceLangId;
        }

		/// <summary>
		/// Initializes a new instance of the <see cref="MagicKeyword"/> class containing a specific tag for the a specific language.
		/// </summary>
		/// <param name="contentPk">The id of related post.</param>
		/// <param name="keyword">The keyword.</param>
		/// <param name="langId">The language identifier.</param>
        public MagicKeyword(int contentPk, string keyword, string langId)
        {
            ContentPk = contentPk;
            Keyword = keyword;
            LangId = langId;
        }

        #endregion

        #region Public Methods
		/// <summary>
		/// Inserts this keyword in the database.
		/// </summary>
        public void Insert()
        {
            SqlConnection conn = null;
            SqlCommand cmd = null;
            try
            {
                string cmdText =    " BEGIN TRY " +
                                    "         BEGIN TRANSACTION " +
                                    "                 IF NOT EXISTS (SELECT " +
                                    "                                 key_content_PK " +
                                    "                         FROM REL_KEYWORDS rk " +
                                    "                         WHERE rk.key_content_PK = @key_content_PK " +
                                    "                         AND rk.key_keyword = @key_keyword " +
                                    "                         AND rk.key_langId = @key_langId) " +
                                    "                 BEGIN " +
                                    "                         INSERT REL_KEYWORDS (key_content_PK, key_keyword, key_langId) " +
                                    "                                 VALUES (@key_content_PK, @key_keyword, @key_langId); " +
                                    "                 END " +
                                    "         COMMIT TRANSACTION " +
                                    "         SELECT " +
                                    "                 @@ERROR " +
                                    " END TRY " +
                                    " BEGIN CATCH " +
                                    "         IF XACT_STATE() <> 0 " +
                                    "         BEGIN " +
                                    "                 ROLLBACK TRANSACTION " +
                                    "         END " +
                                    "         SELECT " +
                                    "                 ERROR_MESSAGE() " +
                                    " END CATCH; ";

                conn = new SqlConnection(MagicUtils.MagicConnectionString);
                conn.Open();
                cmd = new SqlCommand(cmdText, conn);
                cmd.Parameters.AddWithValue("@key_content_PK", ContentPk);
                cmd.Parameters.AddWithValue("@key_keyword", Keyword.Trim());
                cmd.Parameters.AddWithValue("@key_langId", LangId);

                string r = Convert.ToString(cmd.ExecuteScalar());
                if (r != "0")
                {
                    MagicLog log = new MagicLog("REL_KEYWORDS", 0, LogAction.Insert, "", "");
                    log.Error = r;
                    log.Insert();
                }
            }
            catch (Exception e)
            {
                MagicLog log = new MagicLog("REL_KEYWORDS", 0, LogAction.Insert, e);
                log.Insert();
            }
            finally
            {
                if (conn != null)
                    conn.Dispose();
                if (cmd != null)
                    cmd.Dispose();
            }
            return;
        }
        
        #endregion


        #region Static Mathods
		/// <summary>
		/// Keywords count.
		/// </summary>
		/// <returns>System.Int32.</returns>
        public static int RecordCount()
        {
            int c = 0;
            SqlConnection conn = null;
            SqlCommand cmd = null;

            try
            {
                string cmdText = "SELECT COUNT(*) FROM REL_KEYWORDS ";

                conn = new SqlConnection(MagicUtils.MagicConnectionString);
                conn.Open();
                cmd = new SqlCommand(cmdText, conn);
                c = Convert.ToInt32(cmd.ExecuteScalar());
            }
            catch (Exception e)
            {
                MagicLog log = new MagicLog("REL_KEYWORDS", 0, LogAction.Read, e);
                log.Insert();
            }
            finally
            {
                if (conn != null)
                    conn.Dispose();
                if (cmd != null)
                    cmd.Dispose();
            }
            return c;
        }

        public static async Task<int> RecordCountAsync()
        {
            int c = 0;
            SqlConnection conn = null;
            SqlCommand cmd = null;

            try
            {
                string cmdText = "SELECT COUNT(*) FROM REL_KEYWORDS ";

                conn = new SqlConnection(MagicUtils.MagicConnectionString);
                await conn.OpenAsync();
                cmd = new SqlCommand(cmdText, conn);
                c = Convert.ToInt32(await cmd.ExecuteScalarAsync());
            }
            catch (Exception e)
            {
                MagicLog log = new MagicLog("REL_KEYWORDS", 0, LogAction.Read, e);
                log.Insert();
            }
            finally
            {
                if (conn != null)
                    conn.Dispose();
                if (cmd != null)
                    cmd.Dispose();
            }
            return c;
        }

        public static async Task<bool> IsPopulated()
        {
            int result = 1;
            SqlConnection conn = null;
            SqlCommand cmd = null;

            try
            {
                string cmdText = @" IF EXISTS(
	                                    SELECT 1
	                                    FROM MB_contenuti mc WHERE ISNULL(mc.Tags, '') <> ''
                                    ) AND NOT EXISTS( SELECT 1 FROM REL_MagicTitle rmt)
                                    BEGIN
	                                    SELECT 0
                                    END 
                                    ELSE
	                                    SELECT 1 ";

                conn = new SqlConnection(MagicUtils.MagicConnectionString);
                await conn.OpenAsync();
                cmd = new SqlCommand(cmdText, conn);
                result = Convert.ToInt32(await cmd.ExecuteScalarAsync());
            }
            catch (Exception e)
            {
                MagicLog log = new MagicLog("REL_KEYWORDS", 0, LogAction.Read, e);
                log.Insert();
            }
            finally
            {
                if (conn != null)
                    conn.Dispose();
                if (cmd != null)
                    cmd.Dispose();
            }
            return (result == 1);
        }


        /// <summary>
        /// Updates the specified Post keywords.
        /// </summary>
        /// <param name="contentPk">The id of related post.</param>
        /// <param name="keywords">Comma separated list of keywords.</param>
        /// <returns>Boolean.</returns>
        public static Boolean Update(int contentPk, string keywords)
        {
            return Update(contentPk, keywords, new CMS_Config().TransSourceLangId);
        }

		/// <summary>
		/// Updates the specified Post keywords.
		/// </summary>
		/// <param name="contentPk">The id of related post.</param>
		/// <param name="keywords">Comma separated list of keywords.</param>
		/// <param name="langId">The language identifier.</param>
		/// <returns>Boolean.</returns>
		public static Boolean Update(int contentPk, string keywords, string langId)
        {
            var result = true;
            SqlConnection conn = null;
            SqlCommand cmd = null;

            try
            {
                string[] keyList = keywords.Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries);
                Boolean first = true;
                string values = "";

                if (keyList.Length > 0)
                {
                    values = "         INSERT REL_KEYWORDS (key_content_PK, key_keyword, key_langId) " +
                             "             VALUES  ";
                    for (int i = 0; i < keyList.Length; i++)
                    {
                        if (!first)
                        {
                            values += ",";
                        }
                        first = false;
                        values += " (@pk, '" + keyList[i].Trim().Replace("'", "''") + "', @langId) ";
                    }
                    values += ";";
                }

                string cmdText = " BEGIN TRY " +
                                "     BEGIN TRANSACTION " +
                                "         DELETE REL_KEYWORDS " +
                                "         WHERE (key_content_PK = @pk) AND (key_langId = @langId) ; " +
                                values +
                                "     COMMIT TRANSACTION " +
                                "     SELECT @@ERROR " +
                                " END TRY " +
                                " BEGIN CATCH " +
                                "     SELECT " +
                                "         ERROR_MESSAGE()" +
                                "     IF XACT_STATE() <> 0 " +
                                "     BEGIN " +
                                "         ROLLBACK TRANSACTION " +
                                "     END " +
                                " END CATCH; ";

                conn = new SqlConnection(MagicUtils.MagicConnectionString);
                conn.Open();
                cmd = new SqlCommand(cmdText, conn);
                cmd.Parameters.AddWithValue("@pk", contentPk);
                cmd.Parameters.AddWithValue("@langId", langId);

                string r = Convert.ToString(cmd.ExecuteScalar());
                if (r == "0")
                {
                    MagicLog log = new MagicLog("REL_KEYWORDS", contentPk, LogAction.Update, "", "");
                    log.Insert();
                }
                else
                {
                    MagicLog log = new MagicLog("REL_KEYWORDS", contentPk, LogAction.Update, "", "");
                }
                result = (r == "0");
            }
            catch (Exception e)
            {
                MagicLog log = new MagicLog("REL_KEYWORDS", contentPk, LogAction.Update, e);
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
		/// Populates tags table.
		/// </summary>
		/// <returns>Boolean.</returns>
        public static Boolean Populate()
        {
            var result = true;
            SqlConnection conn = null;
            SqlCommand cmd = null;

            try
            {
                string cmdText =    " SELECT DISTINCT " +
                                    "         mc.Id, " +
                                    "         mc.Tags, " +
                                    "         at.TRAN_Tags,  " +
                                    "         at.TRAN_LANG_Id " +
                                    " FROM MB_contenuti mc " +
                                    "         LEFT JOIN ANA_TRANSLATION at " +
                                    "                 ON at.TRAN_MB_contenuti_Id = mc.Id " +
                                    " WHERE ISNULL(mc.Tags, '') <> '' " +
                                    " AND mc.Flag_Cancellazione = 0 ";

                conn = new SqlConnection(MagicUtils.MagicConnectionString);
                conn.Open();
                cmd = new SqlCommand(cmdText, conn);
                SqlDataReader reader = cmd.ExecuteReader();
                if (reader.HasRows)
                {
                    while (reader.Read())
                    {
                        // Tags in default language
                        int pk = reader.GetInt32(0);
                        string tagsField = reader.GetString(1);
                        string tagsTranslated = reader.GetString(2);
                        string langId = reader.GetString(3);
                        string[] keywords = tagsField.Split(',');
                        for (int i = 0; i < keywords.Length; i++)
                        {
                            string keyword = keywords[i].Trim();
                            if (!String.IsNullOrEmpty(keyword))
                            {
                                MagicKeyword key = new MagicKeyword(pk, keyword);
                                key.Insert();
                            }
                        }
                        // Translated tags
                        if (!(String.IsNullOrEmpty(tagsTranslated) || String.IsNullOrEmpty(langId)))
                        {
                            string[] trKeywords = tagsTranslated.Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries);
                            for (int i = 0; i < trKeywords.Length; i++)
                            {
                                MagicKeyword trKey = new MagicKeyword(pk, trKeywords[i].Trim(), langId);
                                trKey.Insert();
                            }
                        }

                    }


                }
            }
            catch (Exception e)
            {
                MagicLog log = new MagicLog("REL_KEYWORDS", 0, LogAction.Read, e);
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

        public static async Task<Boolean> PopulateAsync()
        {
            var result = true;
            SqlConnection conn = null;
            SqlCommand cmd = null;

            try
            {
                string cmdText = " SELECT DISTINCT " +
                                    "         mc.Id, " +
                                    "         mc.Tags, " +
                                    "         at.TRAN_Tags,  " +
                                    "         at.TRAN_LANG_Id " +
                                    " FROM MB_contenuti mc " +
                                    "         LEFT JOIN ANA_TRANSLATION at " +
                                    "                 ON at.TRAN_MB_contenuti_Id = mc.Id " +
                                    " WHERE ISNULL(mc.Tags, '') <> '' " +
                                    " AND mc.Flag_Cancellazione = 0 ";

                conn = new SqlConnection(MagicUtils.MagicConnectionString);
                await conn.OpenAsync();
                cmd = new SqlCommand(cmdText, conn);
                SqlDataReader reader = await cmd.ExecuteReaderAsync();
                if (reader.HasRows)
                {
                    while (reader.Read())
                    {
                        // Tags in default language
                        int pk = reader.GetInt32(0);
                        string tagsField = reader.GetString(1);
                        string tagsTranslated = reader.GetString(2);
                        string langId = reader.GetString(3);
                        string[] keywords = tagsField.Split(',');
                        for (int i = 0; i < keywords.Length; i++)
                        {
                            string keyword = keywords[i].Trim();
                            if (!String.IsNullOrEmpty(keyword))
                            {
                                MagicKeyword key = new MagicKeyword(pk, keyword);
                                key.Insert();
                            }
                        }
                        // Translated tags
                        if (!(String.IsNullOrEmpty(tagsTranslated) || String.IsNullOrEmpty(langId)))
                        {
                            string[] trKeywords = tagsTranslated.Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries);
                            for (int i = 0; i < trKeywords.Length; i++)
                            {
                                MagicKeyword trKey = new MagicKeyword(pk, trKeywords[i].Trim(), langId);
                                trKey.Insert();
                            }
                        }

                    }


                }
            }
            catch (Exception e)
            {
                MagicLog log = new MagicLog("REL_KEYWORDS", 0, LogAction.Read, e);
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
        /// Gets the keywords.
        /// </summary>
        /// <returns>List&lt;System.String&gt;.</returns>
        public static List<string> GetKeywords()
        {
            return GetKeywords("", new CMS_Config().TransSourceLangId);
        }

		/// <summary>
		/// Gets the keywords filtered by a partial match.
		/// </summary>
		/// <param name="key">Partial match. If key is an ampty string all keywords are returned.</param>
		/// <returns>List&lt;System.String&gt;.</returns>
        public static List<string> GetKeywords(string key)
        {
            return GetKeywords(key, new CMS_Config().TransSourceLangId);
        }


		/// <summary>
		/// Gets the keywords filtered by a partial match and language.
		/// </summary>
		/// <param name="key">Partial match. If key is an ampty string all keywords are returned.</param>
		/// <param name="langId">Two or three characters language code.</param>
		/// <returns>List&lt;System.String&gt;.</returns>
		public static List<string> GetKeywords(string key, string langId)
        {
            List<string> lista = new List<string>();
            if (RecordCount() == 0)
            {
                if (!Populate())
                    return lista;
            }
            SqlConnection conn = null;
            SqlCommand cmd = null;
            key = key.Trim();
            key = "%" + key + "%";
            try
            {
                string cmdText =    " SELECT DISTINCT " +
                                    " 	rk.key_keyword FROM REL_KEYWORDS rk " +
                                    " WHERE (rk.key_keyword LIKE @p) AND (rk.key_langId = @langId) " +
                                    " ORDER BY  rk.key_keyword ";

                conn = new SqlConnection(MagicUtils.MagicConnectionString);
                conn.Open();
                cmd = new SqlCommand(cmdText, conn);
                cmd.Parameters.AddWithValue("@p", key);
                cmd.Parameters.AddWithValue("@langId", langId);
                SqlDataReader reader = cmd.ExecuteReader();
                if (reader.HasRows)
                {
                    while (reader.Read())
                    {
                        string parola = reader.GetString(0);
                        lista.Add(parola);
                    }
                }
            }
            catch (Exception e)
            {
                MagicLog log = new MagicLog("REL_KEYWORDS", 0, LogAction.Read, e);
                log.Insert();
            }
            finally
            {
                if (conn != null)
                    conn.Dispose();
                if (cmd != null)
                    cmd.Dispose();
            }


            return lista;
        }

        public static async Task<List<string>> GetKeywordsAsync(string key, string langId)
        {
            List<string> lista = new List<string>();
            bool pop = await IsPopulated();
            if (!pop )
            {
                if (! await PopulateAsync())
                    return lista;
            }

            SqlConnection conn = null;
            SqlCommand cmd = null;
            key = key.Trim();
            key = "%" + key + "%";
            try
            {
                string cmdText = " SELECT DISTINCT " +
                                    " 	rk.key_keyword FROM REL_KEYWORDS rk " +
                                    " WHERE (rk.key_keyword LIKE @p) AND (rk.key_langId = @langId) " +
                                    " ORDER BY  rk.key_keyword ";

                conn = new SqlConnection(MagicUtils.MagicConnectionString);
                await conn.OpenAsync();
                cmd = new SqlCommand(cmdText, conn);
                cmd.Parameters.AddWithValue("@p", key);
                cmd.Parameters.AddWithValue("@langId", langId);
                SqlDataReader reader = await cmd.ExecuteReaderAsync();
                if (reader.HasRows)
                {
                    while (reader.Read())
                    {
                        string parola = reader.GetString(0);
                        lista.Add(parola);
                    }
                }
            }
            catch (Exception e)
            {
                MagicLog log = new MagicLog("REL_KEYWORDS", 0, LogAction.Read, e);
                log.Insert();
            }
            finally
            {
                if (conn != null)
                    conn.Dispose();
                if (cmd != null)
                    cmd.Dispose();
            }


            return lista;
        }



        #endregion
    }
}