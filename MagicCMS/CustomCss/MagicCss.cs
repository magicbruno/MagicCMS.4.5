﻿using MagicCMS.Core;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Text.RegularExpressions;

namespace MagicCMS.CustomCss
{
	/// <summary>
	/// Class MagicCss. Manages CostomCss editing
	/// </summary>
	public class MagicCss
	{
		#region Public properties

		/// <summary>
		/// Gets or sets the pk. Unique ID of custom css.
		/// </summary>
		/// <value>The pk.</value>
		public int Pk { get; set; }
		/// <summary>
		/// Gets or sets the last modified.
		/// </summary>
		/// <value>The last modified.</value>
		public DateTime LastModified { get; set; }

		private string _title = "";
		/// <summary>
		/// Gets the title. The title is generated by comments at the beginning of css code.
		/// </summary>
		/// <value>The title.</value>
		public string Title 
		{
			get
			{
				return _title;
			} 
		}

		private string _cssText = "";
		/// <summary>
		/// Gets or sets the CSS code.
		/// </summary>
		/// <value>The CSS text.</value>
		public string CssText
		{
			get
			{
				return _cssText;
			}
			set
			{
				_cssText = value;
				Regex reg = new Regex(@"(?<=\*\*\[).+?(?=\]\*\*)", RegexOptions.None);
				if (!String.IsNullOrEmpty(_cssText))
				{
					Match m = reg.Match(_cssText);
					if (m.Success)
						_title = m.Value; 
				}
			}
		}

		#endregion

		#region Constructor

		/// <summary>
		/// Initializes a new empty instance of the <see cref="MagicCss"/> class.
		/// </summary>
		/// <param name="text">The CSS text.</param>
		public MagicCss(string text)
		{
			Pk = 0;
			CssText = text;
			LastModified = DateTime.Now;
		}


		/// <summary>
		/// Initializes a new instance of the <see cref="MagicCss"/> class fletching it from the MagicCMS database.
		/// </summary>
		/// <param name="pk">Primary Key of Row.</param>
		public MagicCss(int pk)
		{
			Init(pk);
		}

		private void Init(int pk)
		{
			if (!CreateIfNotExists())
			{
				Pk = 0;
				CssText = "";
				LastModified = DateTime.Now;
				return;
			}

			string cmdString;
			if (pk == 0)
				cmdString = " SELECT TOP 1 " +
							" 	cc.CSS_PK, " +
							" 	cc.CSS_MODIFIED, " +
							" 	cc.CSS_TEXT " +
							" FROM CustomCSS cc ";
			else
				cmdString = " SELECT " +
							" 	cc.CSS_PK, " +
							" 	cc.CSS_MODIFIED, " +
							" 	cc.CSS_TEXT " +
							" FROM CustomCSS cc " +
							" WHERE cc.CSS_PK = " +
							pk.ToString();


			SqlConnection conn = null;
			SqlCommand cmd = null;
			SqlDataReader reader = null;

			try
			{
				string cmdText = cmdString;

				conn = new SqlConnection(MagicUtils.MagicConnectionString);
				conn.Open();
				cmd = new SqlCommand(cmdText, conn);
				reader = cmd.ExecuteReader(System.Data.CommandBehavior.SingleRow);
				if (reader.Read())
				{
					Pk = Convert.ToInt32(reader.GetValue(0));
					LastModified = Convert.ToDateTime(reader.GetValue(1));
					CssText = Convert.ToString(reader.GetValue(2));
				}
				else
				{
					Pk = 0;
					LastModified = DateTime.Now;
					CssText = "";
				}

			}
			catch (Exception e)
			{
				MagicLog log = new MagicLog("CustomCSS", 0, LogAction.Read, e);
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

		#region Public Methods

		/// <summary>
		/// Inserts a new record in CustomCss table.
		/// </summary>
		/// <returns>True on success</returns>
		public bool Insert()
		{

			string cmdString =	" IF OBJECT_ID(N'CustomCSS', N'U') IS NULL " +
								" BEGIN " +
								" 	SELECT " +
								" 		-1 " +
								" END " +
								" ELSE " +
								" BEGIN " +
								" BEGIN TRY " +
								" 	BEGIN TRANSACTION " +
								" 		INSERT CustomCSS (CSS_MODIFIED, CSS_TEXT) " +
								" 			VALUES (DEFAULT, @CSS_TEXT); " +
								" 	COMMIT TRANSACTION " +
								" 	SELECT " +
								" 		@@identity " +
								" END TRY " +
								" BEGIN CATCH " +
								" 	IF XACT_STATE() <> 0 " +
								" 	BEGIN " +
								" 		ROLLBACK TRANSACTION " +
								" 	END " +
								" 	SELECT ERROR_MESSAGE() " +
								" END CATCH; " +
								" END ";

			SqlConnection conn = null;
			SqlCommand cmd = null;
			try
			{
				string cmdText = cmdString;

				conn = new SqlConnection(MagicUtils.MagicConnectionString);
				conn.Open();
				cmd = new SqlCommand(cmdText, conn);
				cmd.Parameters.AddWithValue("@CSS_TEXT", CssText);
				string temp = cmd.ExecuteScalar().ToString();

				int pk = 0;
				if (int.TryParse(temp, out pk))
				{
					Pk = pk;
				}
				else
				{
					string errorMessage = temp;
					MagicLog log = new MagicLog("CustomCSS", 0, LogAction.Insert, MagicSession.Current.LoggedUser.Pk, DateTime.Now, "CustomCSS.cs", "Insert", errorMessage);
					log.Insert();
					Pk = 0;
				}

			}
			catch (Exception e)
			{
				MagicLog log = new MagicLog("CustomCSS", 0, LogAction.Insert, e);
				log.Insert();
				Pk = 0;
			}
			finally
			{
				if (conn != null)
					conn.Dispose();
				if (cmd != null)
					cmd.Dispose();
			}
			return (Pk > 0);
		}

		/// <summary>
		/// Update existing record in CustomCSS table
		/// </summary>
		/// <returns>True on success</returns>
		public bool Save()
		{

			if (Pk == 0)
				return this.Insert();
			int rowcont;

			string cmdString =	" IF OBJECT_ID(N'CustomCSS', N'U') IS NULL " +
								" BEGIN " +
								" 	SELECT " +
								" 		-1 " +
								" END " +
								" ELSE " +
								" BEGIN " +
								" BEGIN TRY " +
								" 	BEGIN TRANSACTION " +
								" 		UPDATE CustomCSS " +
								" 		SET	CSS_MODIFIED = DEFAULT, " +
								" 			CSS_TEXT = @CSS_TEXT " +
								" 		WHERE CSS_PK = @CSS_PK; " +
								" 		SELECT " +
								" 			@@rowcount " +
								" 	COMMIT TRANSACTION " +
								" END TRY " +
								" BEGIN CATCH " +
								" 	IF XACT_STATE() <> 0 " +
								" 	BEGIN " +
								" 		ROLLBACK TRANSACTION " +
								" 	END " +
								" 	SELECT " +
								" 		ERROR_MESSAGE() " +
								" END CATCH; " +
								" END ";

			SqlConnection conn = null;
			SqlCommand cmd = null;
			try
			{
				string cmdText = cmdString;

				conn = new SqlConnection(MagicUtils.MagicConnectionString);
				conn.Open();
				cmd = new SqlCommand(cmdText, conn);
				cmd.Parameters.AddWithValue("@CSS_TEXT", CssText);
				cmd.Parameters.AddWithValue("@CSS_PK", Pk);
				string temp = cmd.ExecuteScalar().ToString();

				rowcont = 0;
				if (!int.TryParse(temp, out rowcont))
				{
					string errorMessage = temp;
					MagicLog log = new MagicLog("CustomCSS", 0, LogAction.Insert, MagicSession.Current.LoggedUser.Pk, DateTime.Now, "CustomCSS.cs", "Insert", errorMessage);
					log.Insert();
				}

			}
			catch (Exception e)
			{
				MagicLog log = new MagicLog("CustomCSS", 0, LogAction.Insert, e);
				log.Insert();
				rowcont = 0;
			}
			finally
			{
				if (conn != null)
					conn.Dispose();
				if (cmd != null)
					cmd.Dispose();
			}
			return (rowcont > 0);
		}

		#endregion

		#region Static Methods

		/// <summary>
		/// Gets the current custom CSS.
		/// </summary>
		/// <returns>MagicCss.</returns>
		public static MagicCss GetCurrent()
		{
			return new MagicCss(0);
		}

		/// <summary>
		/// Creates CustomCSS table if not exists.
		/// </summary>
		/// <returns><c>true</c> on success, <c>false</c> otherwise.</returns>
		public static bool CreateIfNotExists()
		{
			bool result = true;
			string cmdString =	" BEGIN TRY " +
								" 	IF OBJECT_ID(N'CustomCSS', N'U') IS NOT NULL  " +
								"     BEGIN " +
								"     	SELECT -1 " +
								"     END " +
								" 	ELSE  " +
								" 	BEGIN " +
								" 		BEGIN TRANSACTION " +
								" 			CREATE TABLE [dbo].[CustomCSS] ( " +
								" 				[CSS_PK] INT NOT NULL PRIMARY KEY IDENTITY, " +
								" 				[CSS_MODIFIED] DATETIME2 NULL DEFAULT GETDATE(), " +
								" 				[CSS_TEXT] NVARCHAR(MAX) NULL " +
								" 			) " +
								" 		COMMIT TRANSACTION " +
								" 		SELECT 0  	 " +
								"     END " +
								" END TRY " +
								" BEGIN CATCH " +
								" 	IF XACT_STATE() <> 0 " +
								" 	BEGIN " +
								" 		ROLLBACK TRANSACTION " +
								" 	END " +
								" 	SELECT ERROR_NUMBER() " +
								" END CATCH; ";

			SqlConnection conn = null;
			SqlCommand cmd = null;

			try
			{
				string cmdText = cmdString;

				conn = new SqlConnection(MagicUtils.MagicConnectionString);
				conn.Open();
				cmd = new SqlCommand(cmdText, conn);
				int sqlResult = Convert.ToInt32(cmd.ExecuteScalar());

				if (sqlResult > 0)
				{
					string errorMessage = "Sql error number: " + sqlResult.ToString();
					MagicLog log = new MagicLog("CustomCSS", 0, LogAction.Insert, MagicSession.Current.LoggedUser.Pk, DateTime.Now, "CustomCSS.cs", "CreateIfNotExists", errorMessage);
					log.Insert();
					result = false;
				}
				else if (sqlResult == 0)
				{
					MagicCss mc = new MagicCss("");
					result = mc.Insert();
					if (result)
					{
						MagicLog log = new MagicLog("CustomCSS", 0, LogAction.Insert, "CustomCSS.cs", "CreateIfNotExists");
						log.Error = "SUCCESS";
						log.Insert();
					}
				}

			}
			catch (Exception e)
			{
				MagicLog log = new MagicLog("CustomCSS", 0, LogAction.Update, e);
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
		/// Gets the versions.
		/// </summary>
		/// <returns>List&lt;MagicCss&gt;.</returns>
		public static List<MagicCss> GetVersions()
		{
			List<MagicCss> versioni = new List<MagicCss>();
			if (!CreateIfNotExists())
				return versioni;

			string cmdString =	" DECLARE @first INT; " +
								" SET @first = (SELECT TOP 1 " +
								" 	cc.CSS_PK " +
								" FROM CustomCSS cc " +
								" ORDER BY cc.CSS_PK) " +
								" SELECT " +
								" 	cc.CSS_PK, " +
								" 	cc.CSS_MODIFIED, " +
								" 	cc.CSS_TEXT " +
								" FROM CustomCSS cc " +
								" WHERE cc.CSS_PK > @first " +
								" ORDER BY cc.CSS_PK ";

			SqlConnection conn = null;
			SqlCommand cmd = null;
			SqlDataReader reader = null;

			try
			{
				string cmdText = cmdString;

				conn = new SqlConnection(MagicUtils.MagicConnectionString);
				conn.Open();
				cmd = new SqlCommand(cmdText, conn);
				reader = cmd.ExecuteReader(System.Data.CommandBehavior.Default);
				while (reader.Read())
				{
					MagicCss mc = new MagicCss(reader.GetValue(2).ToString());
					mc.Pk = Convert.ToInt32(reader.GetValue(0));
					mc.LastModified = Convert.ToDateTime(reader.GetValue(1));
					versioni.Add(mc);
				}
				

			}
			catch (Exception e)
			{
				MagicLog log = new MagicLog("CustomCSS", 0, LogAction.Read, e);
				log.Insert();
			}
			finally
			{
				if (conn != null)
					conn.Dispose();
				if (cmd != null)
					cmd.Dispose();
			}
			return versioni;
		}

		#endregion
	}
}