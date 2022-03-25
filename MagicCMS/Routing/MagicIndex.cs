using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Text.RegularExpressions;
using System.Data.SqlClient;
using MagicCMS.Core;
using System.Threading.Tasks;

/// <summary>
/// The Routing namespace.
/// </summary>
namespace MagicCMS.Routing
{
	/// <summary>
	/// Class MagicIndex. MagicIndex entries wrapper class. Used to maintain table of post title used in routing
	/// </summary>
	public class MagicIndex
	{
		private MagicTranslation magicTranslation;

		#region Properties
		/// <summary>
		/// Gets or sets the pk. Unique ID of routing name.
		/// </summary>
		/// <value>The pk.</value>
		public int Pk { get; set; }
		/// <summary>
		/// Gets or sets the magic post pk. Unique ID of the <see cref="MagicCMS.Core.MagicPost"/> to which routing name is assigned.
		/// </summary>
		/// <value>The magic post pk.</value>
		public int MagicPost_Pk { get; set; }
		/// <summary>
		/// Gets or sets the title. The assigned routing name
		/// </summary>
		/// <value>The title.</value>
		public string Title { get; set; }
		/// <summary>
		/// Language identifier to wich this routing name belong.
		/// </summary>
		/// <value>The language identifier.</value>
		public string LangId { get; set; }

        public static int[] TipiEsclusi
        {
            get
            {
                return new int[] {
                         MagicPostTypeInfo.ButtonLanguage,
                         MagicPostTypeInfo.Calendario,
                         MagicPostTypeInfo.Cartella,
                         MagicPostTypeInfo.CollegamentoInternet,
                         MagicPostTypeInfo.CollegamentoInterno,
                         MagicPostTypeInfo.DocumentoScaricabile,
                         MagicPostTypeInfo.FakeLink,
                         MagicPostTypeInfo.FilmatoFlash,
                         MagicPostTypeInfo.Geolocazione,
                         MagicPostTypeInfo.ListaDiDistribuzione,
                         MagicPostTypeInfo.Menu,
                         MagicPostTypeInfo.Plugin,
                         MagicPostTypeInfo.Preferiti,
                         MagicPostTypeInfo.ShareButton,
                         MagicPostTypeInfo.Section };
            }
        }
        #endregion

        #region Constructor

        /// <summary>
        /// Initializes a new instance of the <see cref="MagicIndex"/> class.
        /// </summary>
        /// <param name="record">SqlDataReader object from database query</param>
        public MagicIndex(SqlDataReader record)
		{
			Init(record);
		}

		/// <summary>
		/// Initializes a new instance of the <see cref="MagicIndex"/> class.
		/// </summary>
		/// <param name="pk">Pk of MagicIndex entry.</param>
		public MagicIndex(int pk)
		{
			Init(pk);
		}

		/// <summary>
		/// Initializes a new instance of the <see cref="MagicIndex"/> class.
		/// </summary>
		/// <param name="mpPk">The MagicPost pk.</param>
		/// <param name="mpTitle">The MagicPost title.</param>
		/// <param name="langId">The language identifier.</param>
		public MagicIndex(int mpPk, string mpTitle, string langId)
		{
			Init(mpPk, mpTitle, langId);
		}

		/// <summary>
		/// Initializes a new instance of the <see cref="MagicIndex"/> class. 
		/// Default language is used.
		/// </summary>
		/// <param name="mpPk">The MagicPost pk..</param>
		/// <param name="mpTitle">The MagicPost title..</param>
		public MagicIndex(int mpPk, string mpTitle)
		{
			Init(mpPk, mpTitle);
		}

		/// <summary>
		/// Initializes a new instance of the <see cref="MagicIndex"/> class.
		/// </summary>
		/// <param name="mp">The MagicPost whose title must be indexed.</param>
		public MagicIndex(MagicPost mp)
		{
			string title = "";
			if (mp.Tipo == MagicPostTypeInfo.ImmagineInGalleria)
			{
				title = "immage-" + mp.Pk.ToString();
			}
			else
			{
				title = String.IsNullOrEmpty(mp.ExtraInfo1) ? mp.Titolo : mp.ExtraInfo1;
			}
			Init(mp.Pk, title);
		}

		protected MagicIndex(string whereClause)
		{
			Init(whereClause);
		}

		public MagicIndex(MagicTranslation magicTranslation)
		{
			// TODO: Complete member initialization
			this.magicTranslation = magicTranslation;
		}

		private void Init(string whereClause)
		{
			string cmdString = " SELECT " +
								" 	rmt.RMT_PK, " +
								" 	rmt.RMT_Contenuti_Id, " +
								" 	rmt.RMT_Title, " +
								" 	rmt.RMT_LangId " +
								" FROM REL_MagicTitle rmt  " +
								" WHERE  " + whereClause;
			SqlConnection conn = null;
			SqlCommand cmd = null;
			SqlDataReader reader = null;

			try
			{
				string cmdText = cmdString;

				conn = new SqlConnection(MagicUtils.MagicConnectionString);
				conn.Open();
				cmd = new SqlCommand(cmdText, conn);
				reader = cmd.ExecuteReader();
				Init(reader);

			}
			catch (Exception e)
			{
				MagicLog log = new MagicLog("REL_MagicTitle", 0, LogAction.Read, e);
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
			if (record.Read())
			{
				Pk = Convert.ToInt32(record.GetValue(0));
				MagicPost_Pk = Convert.ToInt32(record.GetValue(1));
				Title = Convert.ToString(record.GetValue(2));
				LangId = Convert.ToString(record.GetValue(3));
			}
			else
			{
				Pk = 0;
				MagicPost_Pk = 0;
				Title = "";
				LangId = "";
			}

		}
		private void Init(int pk)
		{
			Init(" rmt.RMT_PK = " + pk.ToString() + " ");
		}

		private void Init(int mpPk, string mpTitle, string langId)
		{
			if (langId == "default")
				langId = MagicSession.Current.Config.TransSourceLangId;
			Pk = 0;
			MagicPost_Pk = mpPk;
			Title = EncodeTitle(mpTitle);
			LangId = langId;
		}

		private void Init (int mpPk, string mpTitle) {
			string langId = MagicSession.Current.Config.TransSourceLangId;
			Init(mpPk, mpTitle, langId);
		}


		#endregion

		#region Public Methods
		/*
		 ================= TO DO ==================
		 Controllare che gli elementi salvati non 
		 appartengano ai tipi esclusi dall'indicizzazione
		*/
		/// <summary>
		/// Saves MagicIndex Entry.
		/// </summary>
		/// <returns>Pk of record inserted or updated (Success if != 0).</returns>
		public int  Save(out string errorMessage)
		{
			// If table not exists and table creation failed return unsaved record
			if (!CreateMagicIndex(out errorMessage))
				return Pk;

			// Save record. If Post Pk and Language exists Update else Insert.
			string cmdString =	" DECLARE @TheTitle NVARCHAR(1000) " +
								" SET @TheTitle = @RMT_Title " +
								" BEGIN TRY " +
								" 	IF EXISTS (SELECT " +
								" 			1 " +
								" 		FROM REL_MagicTitle " +
								" 		WHERE RMT_Title = @RMT_Title " +
								" 		AND RMT_LangId = @RMT_LangId " +
								" 		AND @RMT_Contenuti_Id <> RMT_Contenuti_Id) " +
								" 	BEGIN " +
								" 		SET @TheTitle = @RMT_AltTitle " +
								" 	END " +
								" 	BEGIN TRANSACTION " +
								" 		UPDATE REL_MagicTitle " +
								" 		SET RMT_Title = @TheTitle, " +
								" 		@RMT_PK = RMT_PK " +
								" 		WHERE RMT_Contenuti_Id = @RMT_Contenuti_Id " +
								" 		AND RMT_LangId = @RMT_LangId; " +
								" 		IF @@rowcount = 0 " +
								" 		BEGIN " +
								" 			INSERT REL_MagicTitle (RMT_Contenuti_Id, RMT_Title, RMT_LangId) " +
								" 				VALUES (@RMT_Contenuti_Id, @TheTitle, @RMT_LangId); " +
								" 			SET @RMT_PK = SCOPE_IDENTITY() " +
								" 		END " +
								" 	COMMIT TRANSACTION " +
								" 	SELECT " +
								" 		@RMT_PK  " +
								" END TRY " +
								" BEGIN CATCH " +
								" 	SELECT " +
								" 		ERROR_MESSAGE() " +
								" 	IF XACT_STATE() <> 0 " +
								" 	BEGIN " +
								" 		ROLLBACK TRANSACTION " +
								" 	END " +
								" END CATCH; ";
			SqlConnection conn = null;
			SqlCommand cmd = null;
			try
			{
				string cmdText = cmdString;

				conn = new SqlConnection(MagicUtils.MagicConnectionString);
				conn.Open();
				cmd = new SqlCommand(cmdText, conn);
				cmd.Parameters.AddWithValue("@RMT_Contenuti_Id", MagicPost_Pk);
				cmd.Parameters.AddWithValue("@RMT_Title", Title);
				cmd.Parameters.AddWithValue("@RMT_AltTitle", Title + "-" + MagicPost_Pk.ToString());
				cmd.Parameters.AddWithValue("@RMT_LangId", LangId);
				cmd.Parameters.AddWithValue("@RMT_PK", Pk);
				string temp = cmd.ExecuteScalar().ToString();
				int pk = 0;
				if (int.TryParse(temp, out pk))
				{
					Pk = pk;
				}
				else
				{
					errorMessage = temp;
					MagicLog log = new MagicLog("REL_MagicTitle", 0, LogAction.Insert, MagicSession.Current.LoggedUser.Pk, DateTime.Now, "MagicLog.cs", "Save", errorMessage);
					log.Insert();
					Pk = 0;
				}

			}
			catch (Exception e)
			{
				MagicLog log = new MagicLog("REL_MagicTitle", 0, LogAction.Insert, e);
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
			return Pk;
		}
		#endregion

		#region Static Public Methods
		/// <summary>
		/// Deletes a post title and its translations from the titles table.
		/// </summary>
		/// <param name="mp">The Magic Post.</param>
		/// <param name="message">Returned message.</param>
		/// <returns><c>true</c> if success, <c>false</c> otherwise.</returns>
		public static bool DeletePostTitle(int pk, out string message)
		{
			bool success = true;
			message = "Elementi eliminati con successo.";

			string cmdString = @"	BEGIN TRY
										BEGIN TRANSACTION
										DELETE REL_MagicTitle
										WHERE RMT_Contenuti_Id = @PostPk
										COMMIT TRANSACTION
									END TRY
									BEGIN CATCH

										IF XACT_STATE() <> 0
										BEGIN
											ROLLBACK TRANSACTION
										END;
										THROW;
									END CATCH; ";
			SqlConnection conn = null;
			SqlCommand cmd = null;
			try
			{
				string cmdText = cmdString;

				conn = new SqlConnection(MagicUtils.MagicConnectionString);
				conn.Open();
				cmd = new SqlCommand(cmdText, conn);
				cmd.Parameters.AddWithValue("@PostPk", pk);
				cmd.ExecuteNonQuery();

			}
			catch (Exception e)
			{
				MagicLog log = new MagicLog("REL_MagicTitle", 0, LogAction.Delete, e);
				log.Insert();
				success = false;
			}
			return success;
		}

		public static bool DeletePostTitle(MagicPost mp, out string message)
        {
			return DeletePostTitle(mp.Pk, out message);
        }


		/// <summary>
		/// Updates or insert  a post title and its translations in the titles table.
		/// </summary>
		/// <param name="mp">The Magic Post.</param>
		/// <param name="message">Returned message.</param>
		/// <returns><c>true</c> if success, <c>false</c> otherwise.</returns>
		public static bool UpdatePostTitle(MagicPost mp, out string message)
		{
			bool success = true;
			message = "Elemento aggiornato con successo";
			
			MagicIndex mi = new MagicIndex(mp);
			if (mi.Save(out message) <= 0)
			{
				success = false;
				foreach (MagicTranslation mt in mp.Translations)
				{
					MagicIndex mit = new MagicIndex(mt.PostPk, mt.TranslatedTitle, mt.LangId);
					if (mit.Save(out message) <= 0)
						success = false;
				} 
			}
			return success;
		}

		/// <summary>
		/// Return all titles indexed for a Post. (one for every active language)
		/// </summary>
		/// <param name="PostId">The post identifier.</param>
		/// <returns>MagicIndex entries List</returns>
		public static List<MagicIndex> GetTitles(int PostId)
		{
			return GetRecord("rmt.RMT_Contenuti_Id = " + PostId.ToString() + " ");
		}

		private static List<MagicIndex> GetRecord(string whereClause)
		{
			string cmdString =	" SELECT " +
								" 	rmt.RMT_PK, " +
								" 	rmt.RMT_Contenuti_Id, " +
								" 	rmt.RMT_Title, " +
								" 	rmt.RMT_LangId " +
								" FROM REL_MagicTitle rmt  " +
								" WHERE  " + whereClause;
			SqlConnection conn = null;
			SqlCommand cmd = null;
			List<MagicIndex> titles = new List<MagicIndex>();
			SqlDataReader reader = null;
			try
			{
				string cmdText = cmdString;

				conn = new SqlConnection(MagicUtils.MagicConnectionString);
				conn.Open();
				cmd = new SqlCommand(cmdText, conn);
				reader = cmd.ExecuteReader();
				
			}
			catch (Exception e)
			{
				MagicLog log = new MagicLog("REL_MagicTitle", 0, LogAction.Read, e);
				log.Insert();
			}
			return titles;
		}



		/// <summary>
		/// Gets a post title indexed for a specific language. In no tile is found return Post Pk converted to string.
		/// </summary>
		/// <param name="postId">The post identifier.</param>
		/// <param name="langId">The language identifier.</param>
		/// <returns>The indexed routing title</returns>
		public static string GetTitle(int postId, string langId)
		{
			if (langId == "default")
				langId = MagicSession.Current.Config.TransSourceLangId;

			string title = postId.ToString();

			MagicIndex mi = new MagicIndex("rmt.RMT_Contenuti_Id = " + postId.ToString() + " AND rmt.RMT_LangId = '" + langId.Replace("'", "''") + "' ");
			if (mi.Pk > 0)
			{
				title = mi.Title;
			}
			else
			{

				mi = new MagicIndex("rmt.RMT_Contenuti_Id = " + postId.ToString() + " AND rmt.RMT_LangId = '" + new CMS_Config().TransSourceLangId + "' ");
				if (mi.Pk > 0)
				{
					title = mi.Title; 
				}
			}

			return title;
		}

		/// <summary>
		/// Gets the post identifier.
		/// </summary>
		/// <param name="title">The indexed title.</param>
		/// <returns>The MagicPost Pk or 0 if failed</returns>
		public static int GetPostId(string title)
		{

			MagicIndex mi = new MagicIndex(" rmt.RMT_Title = '" + title.Replace("'", "''") + "' ");
			if (mi.Pk > 0)
				return mi.MagicPost_Pk;
			return 0;
		}

		/// <summary>
		/// Does exists the title table?
		/// </summary>
		/// <returns>True if table exists otherwise false.</returns>
		public static bool ExistsMagicIndex()
		{
			string cmdString =	" IF OBJECT_ID(N'REL_MagicTitle',N'U') IS NOT NULL BEGIN   " +
								" 	SELECT 1 " +
								" END " +
								" ELSE " +
								" BEGIN " +
								" 	SELECT 0 " +
								" END ";
			SqlConnection conn = null;
			SqlCommand cmd = null;
			bool res = true;

			try
			{
				string cmdText = cmdString;

				conn = new SqlConnection(MagicUtils.MagicConnectionString);
				conn.Open();
				cmd = new SqlCommand(cmdText, conn);
				int temp = Convert.ToInt32(cmd.ExecuteScalar());
				res = (temp == 1);

			}
			catch (Exception e)
			{
				MagicLog log = new MagicLog("REL_MagicTitle", 0, LogAction.Read, e);
				log.Insert();
				res = false;
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

		/// <summary>
		/// Creates the title table.
		/// </summary>
		/// <returns>True if table exists or if it was succesfully created, false on fail.</returns>
		public static bool CreateMagicIndex(out string errorMessage)
		{
			string cmdString =	" BEGIN TRY " +
								" 	IF OBJECT_ID(N'REL_MagicTitle', N'U') IS NOT NULL " +
								" 	BEGIN " +
								" 		SELECT " +
								" 			0 " +
								" 	END " +
								" 	ELSE " +
								" 	BEGIN " +
								" 		BEGIN TRANSACTION " +
								" 			CREATE TABLE [dbo].[REL_MagicTitle] ( " +
								" 				[RMT_PK] INT IDENTITY (1, 1) NOT NULL, " +
								" 				[RMT_Contenuti_Id] INT NOT NULL, " +
								" 				[RMT_Title] NVARCHAR(1000) NULL, " +
								" 				[RMT_LangId] NVARCHAR(5) NULL, " +
								" 				PRIMARY KEY CLUSTERED ([RMT_PK] ASC) " +
								" 			); " +
								" 		COMMIT TRANSACTION " +
								" 		SELECT " +
								" 			0 " +
								"  " +
								" 	END " +
								" END TRY " +
								" BEGIN CATCH " +
								" 	IF XACT_STATE() <> 0 " +
								" 	BEGIN " +
								" 		ROLLBACK TRANSACTION " +
								" 	END " +
								" 	SELECT " +
								" 		ERROR_MESSAGE() " +
								" END CATCH; ";

			SqlConnection conn = null;
			SqlCommand cmd = null;
			bool res = true;
			errorMessage = "Success";

			try
			{
				string cmdText = cmdString;

				conn = new SqlConnection(MagicUtils.MagicConnectionString);
				conn.Open();
				cmd = new SqlCommand(cmdText, conn);
				string temp = cmd.ExecuteScalar().ToString();
				if (temp != "0")
				{
					errorMessage = temp;
					MagicLog log = new MagicLog("REL_MagicTitle", 0, LogAction.Insert, MagicSession.Current.LoggedUser.Pk, DateTime.Now, "MagicIndex.cs", "CreateMagicIndex", errorMessage);
					log.Insert();
					res = false;
				}
				else
				{
					MagicLog log = new MagicLog("REL_MagicTitle", 0, LogAction.Insert, "MagicIndex", "CreateMagicIndex");
					log.Error = "SUCCESS";
					log.Insert(); 
				}

			}
			catch (Exception e)
			{
				MagicLog log = new MagicLog("REL_MagicTitle", 0, LogAction.Update, e);
				log.Insert();
				res = false;
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

		/// <summary>
		/// Empties the title table.
		/// </summary>
		/// <returns>Number of deleted rows or a number less the 0 if some error occurred.</returns>
		static public int Empty(out string errorMessage)
		{
			int deleted = 0;
			string cmdString =	" IF OBJECT_ID(N'REL_MagicTitle', N'U') IS NOT NULL " +
								" BEGIN " +
								" BEGIN TRY " +
								" 	BEGIN TRANSACTION " +
								" 		DELETE REL_MagicTitle " +
								" 	COMMIT TRANSACTION " +
								" 	SELECT " +
								" 		@@rowcount " +
								" END TRY " +
								" BEGIN CATCH " +
								" 	IF XACT_STATE() <> 0 " +
								" 	BEGIN " +
								" 		ROLLBACK TRANSACTION " +
								" 	END " +
								" 	SELECT " +
								" 		ERROR_MESSAGE() " +
								" END CATCH; " +
								" END " +
								" ELSE " +
								" BEGIN " +
								" 	SELECT " +
								" 		0 " +
								" END ";

			SqlConnection conn = null;
			SqlCommand cmd = null;
			errorMessage = "";
			try
			{
				string cmdText = cmdString;

				conn = new SqlConnection(MagicUtils.MagicConnectionString);
				conn.Open();
				cmd = new SqlCommand(cmdText, conn);
				string temp = cmd.ExecuteScalar().ToString();
				if (!int.TryParse(temp, out deleted))
				{
					errorMessage = temp;
					MagicLog log = new MagicLog("REL_MagicTitle", 0, LogAction.Delete, MagicSession.Current.LoggedUser.Pk, DateTime.Now, "MagicIndex .cs", "Empty", errorMessage);
					log.Insert();
				}

			}
			catch (Exception e)
			{
				MagicLog log = new MagicLog("REL_MagicTitle", 0, LogAction.Update, e);
				log.Insert();
				deleted = -1;
			}
			finally
			{
				if (conn != null)
					conn.Dispose();
				if (cmd != null)
					cmd.Dispose();
			}

			return deleted;
		}


		/// <summary>
		/// Populates Title table.
		/// </summary>
		/// <returns>True if succesfully populated.</returns>
		static public bool Populate(out int processed, out string errorMessage)
		{
			processed = 0;
			if (Empty(out errorMessage) < 0)
			{
				processed = 0;
				return false;

			}

			bool success = true;

			//int[] tipiEsclusi = new int[] {
			//			 MagicPostTypeInfo.ButtonLanguage,
			//			 MagicPostTypeInfo.Calendario,
			//			 MagicPostTypeInfo.Cartella,
			//			 MagicPostTypeInfo.CollegamentoInternet,
			//			 MagicPostTypeInfo.CollegamentoInterno,
			//			 MagicPostTypeInfo.DocumentoScaricabile,
			//			 MagicPostTypeInfo.FakeLink,
			//			 MagicPostTypeInfo.FilmatoFlash,
			//			 MagicPostTypeInfo.Geolocazione,
			//			 MagicPostTypeInfo.ListaDiDistribuzione,
			//			 MagicPostTypeInfo.Menu,
			//			 MagicPostTypeInfo.Plugin,
			//			 MagicPostTypeInfo.Preferiti,
			//			 MagicPostTypeInfo.ShareButton,
			//			 MagicPostTypeInfo.Section
			//};
			if (CreateMagicIndex(out errorMessage))
			{
				try
				{
					MagicPostCollection tutteLePagine = MagicPost.GetByType(TipiEsclusi, MagicOrdinamento.Asc, false, -1);
					MagicTranslationCollection traduzioni = new MagicTranslationCollection(MagicTranslationCollection.AllRecords);
					foreach (MagicPost mp in tutteLePagine)
					{
						MagicIndex mi = new MagicIndex(mp);
						if (mi.Save(out errorMessage) > 0)
							processed++;
						else
							success = false;
						foreach (MagicTranslation mt in mp.Translations)
						{
							MagicIndex mit = new MagicIndex(mt.PostPk, mt.TranslatedTitle, mt.LangId);
							if (mit.Save(out errorMessage) > 0)
								processed++;
							else
								success = false;

						}
					}
					if (success)
					{
						MagicLog log = new MagicLog("REL_MagicTitle", processed, LogAction.Insert, "MagicIndex", "Populate");
						log.Error = "SUCCESS: Inserted " + processed.ToString() + " item(s).";
						log.Insert();

					}
				}
				catch (Exception)
				{
					success = false;
				}

			}
			else
				success = false;
			return success;
		}

		/// <summary>
		/// Custom encoding of the title.
		/// </summary>
		/// <param name="originalTitle">The original title.</param>
		/// <returns>Encoded title</returns>
		static public String EncodeTitle(string originalTitle)
		{
			string ot = HtmlRemoval.StripTagsRegexCompiled(originalTitle).ToLower();
			ot = Regex.Replace(ot, @"[^\w\(\)-]", "-");
			ot = Regex.Replace(ot, @"(---*)", "-"); 
			ot = Regex.Replace(ot, @"(-$)", "");
			return ot;
		}

		static public async Task<AjaxJsonResponse> CheckTitle(string title, int pk, string lang = "")
        {
			AjaxJsonResponse response = new AjaxJsonResponse()
            {
				success = true,
				pk = pk,
				exitcode = 0,
				msg = "Ok",
				data = null
            };
			string newTitle = EncodeTitle(title);
			

			string cmdString = @"	SELECT
										COUNT(*)
									FROM REL_MagicTitle rmt
									WHERE rmt.RMT_Title = @title
									AND rmt.RMT_Contenuti_Id <> @pk
									AND rmt.RMT_LangId = @lang";

			SqlConnection conn = null;
			SqlCommand cmd = null;
			try
			{

				conn = new SqlConnection(MagicUtils.MagicConnectionString);
				await conn.OpenAsync();
				cmd = new SqlCommand(cmdString, conn);
				cmd.Parameters.AddWithValue("@title", newTitle);
				cmd.Parameters.AddWithValue("@pk", pk);
				cmd.Parameters.AddWithValue("@lang", (string.IsNullOrEmpty(lang) ? new CMS_Config().TransSourceLangId : lang));
				int result = Convert.ToInt32(cmd.ExecuteScalar());
				if (result > 0)
                {
					response.data = newTitle + "-" + pk.ToString();
					throw new Exception("Permalink esistente!");
                }
				else if (newTitle != title)
                {
					response.data = newTitle;
					throw new Exception("Permalink non correttamente formattato!");
				}
				else
                {
					response.data = title;
                }
			}
			catch (Exception e)
			{
				MagicLog log = new MagicLog("REL_MagicTitle", 0, LogAction.Delete, e);
				log.Insert();
				response.success = false;
				response.msg = e.Message;
			}
			return response;
		}
		#endregion
	}
}