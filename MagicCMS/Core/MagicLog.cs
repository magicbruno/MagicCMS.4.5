using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using System.Diagnostics;
using MagicCMS.DataTable;
using System.Threading.Tasks;
using System.Text.RegularExpressions;

namespace MagicCMS.Core
{

	/// <summary>
	/// Enum LogAction. Define action logged in <see cref="MagicCMS.MagicLog"/>	/// </summary>
	public enum LogAction
	{
		/// <summary>
		/// Unknown action
		/// </summary>
		Unknown = -1,
		/// <summary>
		/// Delete a record
		/// </summary>
		Delete = 0,
		/// <summary>
		/// Insert a record
		/// </summary>
		Insert = 1,
		/// <summary>
		/// Update a record
		/// </summary>
		Update = 2,
		/// <summary>
		/// Read record(s)
		/// </summary>
		Read = 3,
		/// <summary>
		/// Undelete a record
		/// </summary>
		Undelete = 4
	}

	/// <summary>
	/// Class MagicLog. The MagicCMS log table register every write action and every error that happens in a MagicCMS application.
	/// </summary>
	/// <remarks></remarks>
	public class MagicLog
	{
		#region Properties
		private string _Error;

		private string _Tabella;

		/// <summary>
		/// Gets or sets the type of action that was tried or copleted.
		/// </summary>
		/// <value>The action.</value>
		public LogAction Action { get; set; }

		/// <summary>
		/// Gets the name of the action.
		/// </summary>
		/// <value>The action string.</value>
		public string ActionString
		{
			get
			{
				return Enum.GetName(typeof(LogAction), Action);
			}
		}

		/// <summary>
		/// Gets or sets the error message is any.
		/// </summary>
		/// <value>The error message.</value>
		public string Error
		{
			get
			{
				return (String.IsNullOrEmpty(_Error)) ? "SUCCESS" : _Error;
			}
			set
			{
				_Error = value;
			}
		}

		/// <summary>
		/// Gets or sets the name of the code file evolved in operation.
		/// </summary>
		/// <value>The name of the file.</value>
		public string FileName { get; set; }

		/// <summary>
		/// Gets or sets the name of the method evolved.
		/// </summary>
		/// <value>The name of the method.</value>
		public string MethodName { get; set; }

		/// <summary>
		/// Gets or sets the unique ID of record involved is any.
		/// </summary>
		/// <value>The pk.</value>
		public int Pk { get; set; }
		public int Record { get; set; }

		private string _recordName;

		/// <summary>
		/// Gets or sets the name of the record evolved.
		/// </summary>
		/// <value>The name of the record.</value>
		public string RecordName
		{
			get
			{
				if (string.IsNullOrEmpty(_recordName))
					return Record.ToString();
				return _recordName;
			}
			set { _recordName = value; }
		}


		/// <summary>
		/// Gets or sets the name database table.
		/// </summary>
		/// <value>The database table.</value>
		public string Tabella
		{
			get
			{
				return (String.IsNullOrEmpty(_Tabella)) ? "Unknown" : _Tabella;
			}
			set
			{
				_Tabella = value;
			}
		}
		/// <summary>
		/// Gets or sets the timestamp.
		/// </summary>
		/// <value>The timestamp.</value>
		public DateTime Timestamp { get; set; }

		/// <summary>
		/// Gets or sets the user logged in.
		/// </summary>
		/// <value>The user.</value>
		public int User { get; set; }
		/// <summary>
		/// Gets or sets the user email.
		/// </summary>
		/// <value>The user email.</value>
		public string Useremail { get; set; }

		public bool IsError
        {
			get
            {
				Regex regex = new Regex(@"success",RegexOptions.IgnoreCase);
				return !regex.IsMatch(Error);
            }
        }

		#endregion

		#region Constructor

		/// <summary>
		/// Initializes a new instance of the <see cref="MagicLog"/> class. Retrieving it from database
		/// </summary>
		/// <param name="pk">Unique ID value..</param>
		public MagicLog(int pk)
		{
			Init(pk);
		}

		/// <summary>
		/// Initializes a new instance of the <see cref="MagicLog"/> class.
		/// </summary>
		/// <param name="record">SqlReader instance.</param>
		public MagicLog(SqlDataReader record)
		{
			Init(record);
		}

		/// <summary>
		/// Initializes a new instance of the <see cref="MagicLog"/> class.
		/// </summary>
		/// <param name="tabella">Processed table</param>
		/// <param name="record">Processed record.</param>
		/// <param name="action">Database action.</param>
		/// <param name="filename">Filename where error is thrown.</param>
		/// <param name="methodname">Method where error is thrown.</param>
		public MagicLog(string tabella, int record, LogAction action, string filename, string methodname)
		{
			Init(tabella, record, action, filename, methodname);
		}

		/// <summary>
		/// Initializes a new instance of the <see cref="MagicLog"/> class.
		/// </summary>
		/// <param name="tabella">Processed table.</param>
		/// <param name="record">Processed record.</param>
		/// <param name="action">Database action.</param>
		/// <param name="e">Exception caught.</param>
		public MagicLog(string tabella, int record, LogAction action, Exception e)
		{
			Init(tabella, record, action, e);
			this.Error = e.Message;
		}

		/// <summary>
		/// Initializes a new instance of the <see cref="MagicLog"/> class.
		/// </summary>
		/// <param name="tabella">Processed table</param>
		/// <param name="record">Processed record.</param>
		/// <param name="action">Database action.</param>
		/// <param name="user">The user.</param>
		/// <param name="timestamp">Timestamp.</param>
		/// <param name="filename">Filename where error is thrown.</param>
		/// <param name="methodname">Method where error is thrown.</param>
		public MagicLog(string tabella, int record, LogAction action, int user, DateTime timestamp, string filename, string methodname)
		{
			Init(tabella, record, action, user, timestamp, filename, methodname);
		}

		public MagicLog(string tabella, int record, LogAction action, int user, DateTime timestamp, string filename, string methodname, string errormessage)
		{
			Init(tabella, record, action, user, timestamp, filename, methodname, errormessage);
		}

		private void Init(int pk)
		{
			SqlConnection conn = null;
			SqlCommand cmd = null;
			Pk = 0;
			Tabella = "";
			Record = 0;
			Action = LogAction.Unknown;
			User = 0;
			Error = "";
			Timestamp = DateTime.Now;

			try
			{
				string cmdText = @"	SELECT
										lr.reg_PK,
										lr.reg_TABELLA,
										lr.reg_RECORD_PK,
										lr.reg_act_PK,
										lr.reg_user_PK,
										lr.reg_ERROR,
										lr.reg_TIMESTAMP,
										lr.reg_fileName,
										lr.reg_methodName,
										au.usr_EMAIL AS usr_EMAIL
									FROM _LOG_REGISTRY lr
										LEFT JOIN ANA_USR au
											ON lr.reg_user_PK = au.usr_PK 
									WHERE lr.reg_PK = @Pk  ";

				conn = new SqlConnection(MagicUtils.MagicConnectionString);
				conn.Open();
				cmd = new SqlCommand(cmdText, conn);
				cmd.Parameters.AddWithValue("@Pk", pk);
				SqlDataReader reader = cmd.ExecuteReader(CommandBehavior.SingleRow);
				if(reader.Read())
					Init(reader);
			}
			catch (Exception e)
			{
				Error = e.Message;
			}
			finally
			{
				if (conn != null)
					conn.Dispose();
				if (cmd != null)
					cmd.Dispose();
			}
		}

		private void Init(SqlDataReader reader)
		{
			Useremail = "Sconosciuto";
			Pk = Convert.ToInt32(reader.GetValue(0));
			if (!reader.IsDBNull(1))
			{
				Tabella = Convert.ToString(reader.GetValue(1));
			}
			if (!reader.IsDBNull(2))
			{
				Record = Convert.ToInt32(reader.GetValue(2));
			}
			if (!reader.IsDBNull(3))
			{
				Action = (LogAction)Convert.ToInt32(reader.GetValue(3));
			}
			if (!reader.IsDBNull(4))
			{
				User = Convert.ToInt32(reader.GetValue(4));
			}
			if (!reader.IsDBNull(5))
			{
				Error = Convert.ToString(reader.GetValue(5));
			}
			if (!reader.IsDBNull(6))
			{
				Timestamp = Convert.ToDateTime(reader.GetValue(6));
			}

			if (!reader.IsDBNull(7))
			{
				FileName = Convert.ToString(reader.GetValue(7));
			}

			if (!reader.IsDBNull(8))
			{
				MethodName = Convert.ToString(reader.GetValue(8));
			}

			if (!reader.IsDBNull(9))
			{
				Useremail = Convert.ToString(reader.GetValue(9));
			}
			if (Record > 0)
			{
				string tab = Tabella.ToUpper();
				switch (tab)
				{
					case "MB_CONTENUTI":
						RecordName = MagicPost.GetPageTitle(Record);
						break;
					case "ANA_CONT_TYPE":
						MagicPostTypeInfo ti = new MagicPostTypeInfo(Record);
						RecordName = ti.Nome;
						break;
					default:
						RecordName = "";
						break;
				}
			}
		}


		private void Init(string tabella, int record, LogAction action, int user, DateTime timestamp, string filename, string methodname)
		{
			Pk = 0;
			Tabella = tabella;
			Record = record;
			Action = action;
			User = user;
			Timestamp = timestamp;
			FileName = filename;
			MethodName = methodname;
		}

		private void Init(string tabella, int record, LogAction action, int user, DateTime timestamp, string filename, string methodname, string error)
		{
			Pk = 0;
			Tabella = tabella;
			Record = record;
			Action = action;
			User = user;
			Timestamp = timestamp;
			FileName = filename;
			MethodName = methodname;
			Error = error;
		}

		private void Init(string tabella, int record, LogAction action, string filename, string methodname)
		{
			Init(tabella, record, action, MagicSession.Current.LoggedUser.Pk, DateTime.Now, filename, methodname);
		}

		private void Init(string tabella, int record, LogAction action, string filename, string methodname, string error)
		{
			Init(tabella, record, action, MagicSession.Current.LoggedUser.Pk, DateTime.Now, filename, methodname, error);
		}

		private void Init(string tabella, int record, LogAction action, Exception e)
		{
			string filename = "", methodname = "";
			List<string> filenames = new List<string>();
			List<string> methods = new List<string>(); 
			StackTrace st = new StackTrace(e);
			//StackFrame frame = st.GetFrame(st.FrameCount - 1);
			int maxlen = Math.Min(5, st.FrameCount);
			int first = st.FrameCount - maxlen;
            for (int i = st.FrameCount - 1; i >= first; i--)
            {
				StackFrame frame = st.GetFrame(i);
				string fname = frame.GetFileName();
                if (string.IsNullOrEmpty(fname))
                    filenames.Add(string.Format("{0}:, linea:{1}, col:{2}", frame.GetFileName(), frame.GetFileLineNumber(), frame.GetFileColumnNumber()));
                methods.Add(frame.GetMethod().ToString());
			}
			filename = string.Join(";<br />", filenames);

			methodname = string.Join(";<br />", methods);

			Init(tabella, record, action, MagicSession.Current.LoggedUser.Pk, DateTime.Now, filename, methodname, e.Message);
		}

		#endregion

		#region PublicMethods

		/// <summary>
		/// Inserts this event log into database.
		/// </summary>
		/// <returns></returns>
		public int Insert()
		{
			// Se il record di log è già esistente enon lo inserisco
			if (Pk > 0) return Pk;


			SqlConnection conn = null;
			SqlCommand cmd = null;
			try
			{
				string cmdText = " SET NOCOUNT ON " +
									" SET XACT_ABORT ON " +
									"  " +
									" BEGIN TRY " +
									" 	BEGIN TRANSACTION " +
									" 		INSERT _LOG_REGISTRY (reg_TABELLA " +
									" 		, reg_RECORD_PK " +
									" 		, reg_act_PK " +
									" 		, reg_user_PK " +
									" 		, reg_ERROR " +
									" 		, reg_TIMESTAMP " +
									" 		, reg_fileName " +
									" 		, reg_methodName) " +
									" 			VALUES (@reg_TABELLA, @reg_RECORD_PK, @reg_act_PK, @reg_user_PK, @reg_ERROR, @reg_TIMESTAMP, @reg_fileName, @reg_methodName); " +
									" 	COMMIT TRANSACTION " +
									" 	SELECT " +
									" 		SCOPE_IDENTITY() " +
									" END TRY " +
									" BEGIN CATCH " +
									"  " +
									" 	IF XACT_STATE() <> 0 " +
									" 	BEGIN " +
									" 		ROLLBACK TRANSACTION " +
									" 	END " +
									" 	SELECT " +
									" 		-1 * ERROR_NUMBER() " +
									" END CATCH ";

				conn = new SqlConnection(MagicUtils.MagicConnectionString);
				conn.Open();
				cmd = new SqlCommand(cmdText, conn);
				cmd.Parameters.AddWithValue("@reg_TABELLA", Tabella);
				cmd.Parameters.AddWithValue("@reg_RECORD_PK", Record);
				cmd.Parameters.AddWithValue("@reg_act_PK", (int)Action);
				cmd.Parameters.AddWithValue("@reg_user_PK", User);
				cmd.Parameters.AddWithValue("@reg_ERROR", Error);
				cmd.Parameters.AddWithValue("@reg_TIMESTAMP", Timestamp);
				cmd.Parameters.AddWithValue("@reg_fileName", FileName);
				cmd.Parameters.AddWithValue("@reg_methodName", MethodName);

				Pk = Convert.ToInt32(cmd.ExecuteScalar());
			}
			catch (Exception)
			{
				throw;
			}
			finally
			{
				if (conn != null)
					conn.Dispose();
				if (cmd != null)
					cmd.Dispose();
			}
			return Pk;
		}

		public async Task<int> InsertAsync()
		{
			// Se il record di log è già esistente enon lo inserisco
			if (Pk > 0) return Pk;


			SqlConnection conn = null;
			SqlCommand cmd = null;
			try
			{
				string cmdText = " SET NOCOUNT ON " +
									" SET XACT_ABORT ON " +
									"  " +
									" BEGIN TRY " +
									" 	BEGIN TRANSACTION " +
									" 		INSERT _LOG_REGISTRY (reg_TABELLA " +
									" 		, reg_RECORD_PK " +
									" 		, reg_act_PK " +
									" 		, reg_user_PK " +
									" 		, reg_ERROR " +
									" 		, reg_TIMESTAMP " +
									" 		, reg_fileName " +
									" 		, reg_methodName) " +
									" 			VALUES (@reg_TABELLA, @reg_RECORD_PK, @reg_act_PK, @reg_user_PK, @reg_ERROR, @reg_TIMESTAMP, @reg_fileName, @reg_methodName); " +
									" 	COMMIT TRANSACTION " +
									" 	SELECT " +
									" 		SCOPE_IDENTITY() " +
									" END TRY " +
									" BEGIN CATCH " +
									"  " +
									" 	IF XACT_STATE() <> 0 " +
									" 	BEGIN " +
									" 		ROLLBACK TRANSACTION " +
									" 	END " +
									" 	SELECT " +
									" 		-1 * ERROR_NUMBER() " +
									" END CATCH ";

				conn = new SqlConnection(MagicUtils.MagicConnectionString);
				await conn.OpenAsync();
				cmd = new SqlCommand(cmdText, conn);
				cmd.Parameters.AddWithValue("@reg_TABELLA", Tabella);
				cmd.Parameters.AddWithValue("@reg_RECORD_PK", Record);
				cmd.Parameters.AddWithValue("@reg_act_PK", (int)Action);
				cmd.Parameters.AddWithValue("@reg_user_PK", User);
				cmd.Parameters.AddWithValue("@reg_ERROR", Error);
				cmd.Parameters.AddWithValue("@reg_TIMESTAMP", Timestamp);
				cmd.Parameters.AddWithValue("@reg_fileName", FileName);
				cmd.Parameters.AddWithValue("@reg_methodName", MethodName);

				Pk = Convert.ToInt32(await cmd.ExecuteScalarAsync());
			}
			catch (Exception)
			{
				throw;
			}
			finally
			{
				if (conn != null)
					conn.Dispose();
				if (cmd != null)
					cmd.Dispose();
			}
			return Pk;
		}

		async public static Task<OutputParams_dt> GetTablesRowsAsync(bool onlyErrors, InputParams_dt inputParams)
		{
			MagicLogCollection logs = new MagicLogCollection();
			OutputParams_dt outputParams = new OutputParams_dt();

			SqlConnection conn = null;
			SqlCommand cmd = null;
			string whereClause = "", filter = "", ordinamento = "";

            try
            {


                whereClause = onlyErrors ? " WHERE (lr.reg_ERROR <> 'SUCCESS' AND lr.reg_ERROR  NOT LIKE '% SUCCESSO%') " : "";

                if (!string.IsNullOrWhiteSpace(inputParams.search.value))
                {
					filter = String.Format(@"	(lr.reg_TABELLA LIKE '%{0}%' OR 
												CONVERT(VARCHAR(20), lr.reg_TIMESTAMP) LIKE '%{0}%' OR 
												au.usr_EMAIL LIKE '%{0}%' OR 
												CONVERT(VARCHAR(10), lr.reg_RECORD_PK) = '{0}' OR
												lr.reg_ERROR LIKE '%{0}%')", inputParams.search.value);

					if (string.IsNullOrWhiteSpace(whereClause))
						filter = " WHERE " + filter;
					else
						filter = " AND " + filter;
                }

				List<string> columnNames = new List<string>();

                foreach (var column in inputParams.columns)
                {
					columnNames.Add(column.name);
                }


                ordinamento = string.Format(" ORDER BY {0} {1} ", columnNames[inputParams.order[0].column], inputParams.order[0].dir);


                string pagination = string.Format(" OFFSET {0} ROWS FETCH NEXT {1} ROWS ONLY ", inputParams.start, inputParams.length);

                string cmdText = @" DECLARE @unfiltered INT, @filtered INT
                                    
                                    SELECT
										@unfiltered = COUNT(*)
									FROM _LOG_REGISTRY lr
									LEFT JOIN ANA_USR au
										ON lr.reg_user_PK = au.usr_PK " +
                                whereClause + ";" +

								@"  SELECT
										@filtered = COUNT(*)
									FROM _LOG_REGISTRY lr
									LEFT JOIN ANA_USR au
										ON lr.reg_user_PK = au.usr_PK " +
                                whereClause + filter + ";" +

								@"  SELECT
										lr.reg_PK
									   ,lr.reg_TABELLA
									   ,lr.reg_RECORD_PK
									   ,lr.reg_act_PK
									   ,lr.reg_user_PK
									   ,lr.reg_ERROR
									   ,lr.reg_TIMESTAMP
									   ,lr.reg_fileName
									   ,lr.reg_methodName
									   ,au.usr_EMAIL AS usr_EMAIL 
									   ,@unfiltered
									   ,@filtered
									FROM _LOG_REGISTRY lr
									LEFT JOIN ANA_USR au
										ON lr.reg_user_PK = au.usr_PK  " +
                                whereClause + filter + ordinamento + pagination;

                conn = new SqlConnection(MagicUtils.MagicConnectionString);
                await conn.OpenAsync();
                cmd = new SqlCommand(cmdText, conn);
                SqlDataReader reader = await cmd.ExecuteReaderAsync();
                while (reader.Read())
                {
                    logs.Add(new MagicLog(reader));
                    outputParams.recordsTotal = reader.GetInt32(10);
                    outputParams.recordsFiltered = reader.GetInt32(11);
                }
            }
            catch (Exception e)
            {
                MagicLog log = new MagicLog("MagicLogs", 0, LogAction.Read, e);
                log.Insert();
                throw e;
            }
            finally
            {
                if (conn != null)
                    conn.Dispose();
                if (cmd != null)
                    cmd.Dispose();
            }
            outputParams.draw = inputParams.draw;
            outputParams.data = logs;

            return outputParams;
		}

		#endregion
	}
}