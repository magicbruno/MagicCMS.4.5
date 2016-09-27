using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

namespace MagicCMS.Core
{
	public class MagicLanguage
	{

		#region Properties

		private static Dictionary<string, string> _languages = null;
		public static Dictionary<string, string> Languages
		{
			get
			{
				if (_languages == null)
				{
					Reset();
				}
				return _languages;
			}

		}
		public string LangId { get; set; }
		public string LangName { get; set; }
		public Boolean Active { get; set; }
		public Boolean AutoHide { get; set; }
		
		#endregion

		#region Constructor

		public MagicLanguage(string langId)
		{
			Init(langId);
		}

		public MagicLanguage(SqlDataReader record)
		{
			Init(record);
		}

		private void Init(string langId)
		{
			SqlConnection conn = new SqlConnection(MagicUtils.MagicConnectionString);
			SqlCommand cmd = new SqlCommand();

			string commandString =  " SELECT  " + 
									"     al.LANG_Id,  " + 
									"     al.LANG_Name,  " +
									"     al.LANG_Active,  " +
									"     al.LANG_AutoHide  " +
									" FROM ANA_LANGUAGE al  " + 
									" WHERE al.LANG_Id = @LangId  ";

			try
			{
				conn.Open();
				cmd.CommandText = commandString;

				cmd.Connection = conn;
				cmd.Parameters.AddWithValue("@LangId", langId);

				SqlDataReader reader = cmd.ExecuteReader(CommandBehavior.SingleRow);
				if (reader.Read())
					Init(reader);
			}
			catch (Exception e)
			{
				MagicLog log = new MagicLog("ANA_LANGUAGE", 0, LogAction.Read, e);
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
			LangId = !record.IsDBNull(0) ? record.GetString(0) : "";
			LangName = !record.IsDBNull(1) ? record.GetString(1) : "";
			Active = !record.IsDBNull(2) ? Convert.ToBoolean(record.GetValue(2)) : true;
			AutoHide = !record.IsDBNull(3) ? Convert.ToBoolean(record.GetValue(3)) : false;
		}


		#endregion

		#region Public Methods
		public Boolean Save(out string  message)
		{
			// Se il record di log è già esistente non lo inserisco
			Boolean res = true;
			message = "Record salvato con successo.";
			SqlConnection conn = null;
			SqlCommand cmd = null;
			#region cmdString
			string cmdString =  " BEGIN TRY " +
								"     BEGIN TRANSACTION " +
								"         IF EXISTS (SELECT " +
								"                 al.LANG_Id " +
								"                     FROM ANA_LANGUAGE al " +
								"                     WHERE al.LANG_Id = @LANG_Id) " +
								"         BEGIN " +
								"             UPDATE ANA_LANGUAGE " +
								"             SET LANG_Name = @LANG_Name, " +
								"                 LANG_Active = @LANG_Active, " +
								"                 LANG_AutoHide = @LANG_AutoHide " +
								"             WHERE LANG_Id = @LANG_Id " +
								"         END " +
								"         ELSE " +
								"         BEGIN " +
								"             INSERT ANA_LANGUAGE (LANG_Id, LANG_Name, LANG_Active, LANG_AutoHide) " +
								"                 VALUES (@LANG_Id, @LANG_Name, @LANG_Active, @LANG_AutoHide); " +
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
				cmd.Parameters.AddWithValue("@LANG_Id", LangId);
				cmd.Parameters.AddWithValue("@LANG_Name", LangName);
				cmd.Parameters.AddWithValue("@LANG_Active", Active);
				cmd.Parameters.AddWithValue("@LANG_AutoHide", AutoHide);

				string result = cmd.ExecuteScalar().ToString();
				int error;
				if (int.TryParse(result, out error))
				{
					if (error == 0)
					{
						MagicLog log = new MagicLog("ANA_LANGUAGE", 0, LogAction.Insert, "", "");
						log.Error = "Success";
						log.Insert();
						Reset();
					}
					else
					{
						MagicLog log = new MagicLog("ANA_LANGUAGE", 0, LogAction.Insert, "", "");
						log.Error = "SQL Error n. " + result;
						log.Insert();
						message = log.Error;
					}
				}
				else
				{
					MagicLog log = new MagicLog("ANA_LANGUAGE", 0, LogAction.Insert, "", "");
					log.Error = result;
					log.Insert();
					message = log.Error;
				}
			}
			catch (Exception e)
			{
				MagicLog log = new MagicLog("ANA_LANGUAGE", 0, LogAction.Insert, e);
				log.Insert();
				message = log.Error;
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
		#endregion

		#region Static Methods

		public static void Reset()
		{
			if (_languages == null)
			{
				_languages = new Dictionary<string, string>();
			}
			else
			{
				_languages.Clear();
			}
			SqlConnection conn = null;
			SqlCommand cmd = null;

			try
			{
				string cmdText = " SELECT al.LANG_Id, al.LANG_Name FROM ANA_LANGUAGE al WHERE al.LANG_Active = 1 ORDER BY al.LANG_Id ";

				conn = new SqlConnection(MagicUtils.MagicConnectionString);
				conn.Open();
				cmd = new SqlCommand(cmdText, conn);
				SqlDataReader reader = cmd.ExecuteReader();
				if (reader.HasRows)
				{
					while (reader.Read())
					{
						_languages.Add(Convert.ToString(reader.GetValue(0)), Convert.ToString(reader.GetValue(1)));
					}


				}
			}
			catch (Exception e)
			{
				MagicLog log = new MagicLog("ANA_LANGUAGE", 0, LogAction.Read, e);
				log.Insert();
				//throw;
			}
			finally
			{
				if (conn != null)
					conn.Dispose();
				if (cmd != null)
					cmd.Dispose();
			}
		}

		public static string GetKey(string value)
		{
			string key = "";
			foreach (KeyValuePair<string, string> pair in Languages)
			{
				if (pair.Value == value)
					key = pair.Key;
			}
			return key;
		}

		public static bool IsMultilanguage()
		{
			return (Languages.Count > 0);
		}

		#endregion
	}
}