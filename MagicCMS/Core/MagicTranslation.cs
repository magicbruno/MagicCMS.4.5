using MagicCMS.Routing;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Reflection;
using System.Web;

namespace MagicCMS.Core
{
	/// <summary>
	/// Class MagicTranslation.
	/// </summary>
	/// <remarks>Wrapper class for MagicCMS database table containing post translations</remarks>
	public class MagicTranslation
	{
		#region Public Properties

		/// <summary>
		/// Gets or sets the pk. (Unique ID of translation)
		/// </summary>
		/// <value>The pk.</value>
		public int Pk { get; set; }
		/// <summary>
		/// Gets or sets the language identifier of the language to which translation belong.
		/// </summary>
		/// <value>The language identifier.</value>
		public string LangId { get; set; }
		/// <summary>
		/// Gets or sets the name of the language to which translation belong..
		/// </summary>
		/// <value>The name of the language.</value>
		public string LangName {get; set;}
		/// <summary>
		/// Gets or sets the post pk. Unique ID of the post that owns the translation.
		/// </summary>
		/// <value>The post pk.</value>
		public int PostPk { get; set; }
		/// <summary>
		/// Gets or sets the translated title. Translation of the post pretty title rendered as <see cref="MagicCMS.Core.MagicPost.Title_RT"/>.
		/// </summary>
		/// <value>The translated title.</value>
		public string TranslatedTitle { get; set; }

		private string _translatedTestoBreve;

		/// <summary>
		/// Gets or sets the translated testo breve. Translation of <see cref="MagicCMS.Core.MagicPost.TestoBreve"/> 
		/// rendered as <see cref="MagicCMS.Core.MagicPost.TestoBreve_RT"/>.
		/// </summary>
		/// <value>The translated testo breve.</value>
		public string TranslatedTestoBreve {
			get
			{
				return _translatedTestoBreve.Trim();
			}
			set
			{
				_translatedTestoBreve = value;
			}
		}



		private string _translatedTestoLungo;

		/// <summary>
		/// Gets or sets the translated testo lungo. Translation of <see cref="MagicCMS.Core.MagicPost.TestoLungo" />
		/// rendered as <see cref="MagicCMS.Core.MagicPost.TestoLungo_RT" />.
		/// </summary>
		/// <value>The translated testo lungo.</value>
		public string TranslatedTestoLungo
		{
			get
			{
				return _translatedTestoLungo.Trim();
			}
			set
			{
				_translatedTestoLungo = value;
			}
		}

		/// <summary>
		/// Gets or sets the translated tags. Translation of <see cref="MagicCMS.Core.MagicPost.Tags"/>.
		/// </summary>
		/// <value>The translated tags.</value>
		public string TranslatedTags { get; set; }

		/// <summary>
		/// Gets or sets the property with the specified property name.
		/// </summary>
		/// <param name="propertyName">Name of the property.</param>
		/// <returns>The value of property with provided property name</returns>
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
		// Private

		/// <summary>
		/// Initializes a new instance of the <see cref="MagicTranslation"/> class.
		/// </summary>
		/// <param name="postPk">The translated post primary Key.</param>
		/// <param name="langId">The language id of translation.</param>
		public MagicTranslation(int postPk, string langId)
		{
			Init(postPk, langId);
		}

		/// <exclude />
		public MagicTranslation(SqlDataReader record)
		{
			Init(record);
		}

		private void Init(int postPk, string langId)
		{
			Pk = 0;
			LangId = langId;
			PostPk = postPk;
			TranslatedTitle = "";
			TranslatedTestoBreve = "";
			TranslatedTestoLungo = "";
			TranslatedTags = "";

			SqlConnection conn = new SqlConnection(MagicUtils.MagicConnectionString);
			SqlCommand cmd = new SqlCommand();

			string commandString =  " SELECT " +
									"     vat.TRAN_Pk, " +
									"     vat.TRAN_Title, " +
									"     vat.TRAN_TestoBreve, " +
									"     vat.TRAN_TestoLungo, " +
									"     vat.TRAN_Tags, " +
									"     vat.TRAN_MB_contenuti_Id, " +
									"     vat.LANG_Id, " +
									"     vat.LANG_Name " +
									" FROM VW_ANA_TRANSLATION vat " +
									" WHERE vat.TRAN_MB_contenuti_Id = @postPk " +
									" AND vat.LANG_Id = @langId "; 

			try
			{
				conn.Open();
				cmd.CommandText = commandString;

				cmd.Connection = conn;
				cmd.Parameters.AddWithValue("@postPk", postPk);
				cmd.Parameters.AddWithValue("@langId", langId);

				SqlDataReader reader = cmd.ExecuteReader(CommandBehavior.SingleRow);

				if (reader.Read())
					Init(reader);
				else
				{
					if (MagicLanguage.Languages.Keys.Contains(langId))
					{
						LangName = MagicLanguage.Languages[langId];
					}
					else
					{
						MagicLog log = new MagicLog("VW_ANA_TRANSLATION", postPk, LogAction.Read, "MagicTranslation.cs", 
							"private void Init(int, string)" );
						log.Error = "LangId non attivo o illegale.";
						log.Insert();
					}

				}

			}
			catch (Exception e)
			{
				MagicLog log = new MagicLog("VW_ANA_TRANSLATION", postPk, LogAction.Read, e);
				log.Insert();
			}
			finally
			{
				conn.Close();
				//conn.Dispose();
				cmd.Dispose();
			}
		}

		void Init(SqlDataReader record)
		{
			Pk = (!record.IsDBNull(0) ? Convert.ToInt32(record.GetValue(0)) : 0);
			TranslatedTitle = (!record.IsDBNull(1) ? Convert.ToString(record.GetValue(1)) : "");
			TranslatedTestoBreve = (!record.IsDBNull(2) ? Convert.ToString(record.GetValue(2)) : "");
			TranslatedTestoLungo = (!record.IsDBNull(3) ? Convert.ToString(record.GetValue(3)) : "");
			TranslatedTags = (!record.IsDBNull(4) ? Convert.ToString(record.GetValue(4)) : "");
			PostPk = (!record.IsDBNull(5) ? Convert.ToInt32(record.GetValue(5)) : 0);
			LangId = (!record.IsDBNull(6) ? Convert.ToString(record.GetValue(6)) : "");
			LangName = (!record.IsDBNull(7) ? Convert.ToString(record.GetValue(7)) : "");
		}

		#endregion

		#region Public Methods

		/// <summary>
		/// Saves this translation in MagicCMS database.
		/// </summary>
		/// <returns>Boolean.</returns>
		public Boolean Save()
		{
			// Se il record di log è già esistente non lo inserisco
			Boolean res = true;
			SqlConnection conn = null;
			SqlCommand cmd = null;
			#region cmdString
			string cmdString =  " BEGIN TRY " +
								"     BEGIN TRANSACTION " +
								"         IF EXISTS (SELECT " +
								"                 TRAN_Pk " +
								"             FROM ANA_TRANSLATION " +
								"             WHERE TRAN_LANG_Id = @LANG_Id " +
								"             AND TRAN_MB_contenuti_Id = @PostPk) " +
								"         BEGIN " +
								"             UPDATE ANA_TRANSLATION " +
								"             SET TRAN_Title = @TRAN_Title, " +
								"                 TRAN_TestoBreve = @TRAN_TestoBreve, " +
								"                 TRAN_TestoLungo = @TRAN_TestoLungo, " +
								"                 TRAN_Tags = @TRAN_Tags " +
								"             WHERE TRAN_LANG_Id = @LANG_Id " +
								"             AND TRAN_MB_contenuti_Id = @PostPk " +
								"         END " +
								"         ELSE " +
								"         BEGIN " +
								"             INSERT ANA_TRANSLATION (TRAN_LANG_Id, TRAN_Title, TRAN_TestoBreve, TRAN_TestoLungo, TRAN_Tags, TRAN_MB_contenuti_Id) " +
								"                 VALUES (@LANG_Id, @TRAN_Title, @TRAN_TestoBreve, @TRAN_TestoLungo, @TRAN_Tags, @PostPk); " +
								"         END " +
								"     COMMIT TRANSACTION " + 
								"     SELECT @@error  " + 
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
				cmd.Parameters.AddWithValue("@PostPk", PostPk);
				cmd.Parameters.AddWithValue("@TRAN_Title", TranslatedTitle);
				cmd.Parameters.AddWithValue("@TRAN_TestoBreve", TranslatedTestoBreve);
				cmd.Parameters.AddWithValue("@TRAN_TestoLungo", TranslatedTestoLungo);
				cmd.Parameters.AddWithValue("@TRAN_Tags", TranslatedTags);

				string result = cmd.ExecuteScalar().ToString();
				int error;
				if (int.TryParse(result, out error))
				{
					if (error == 0)
					{
						MagicLog log = new MagicLog("ANA_TRANSLATION", PostPk, LogAction.Insert, "", "");
						log.Error = "Success";
						log.Insert();
						if (!MagicKeyword.Update(PostPk, TranslatedTags, LangId))
							res = false;
						MagicIndex mi = new MagicIndex(PostPk, TranslatedTitle,LangId);
						string errorMessage;
						if (mi.Save(out errorMessage) == 0)
						{
							MagicLog log1 = new MagicLog("MB_Translations", Pk, LogAction.Insert, MagicSession.Current.LoggedUser.Pk, DateTime.Now, "MagicTranslation", "Insert - MagicIndex", errorMessage);
							log1.Insert();
						}
					}
					else
					{
						MagicLog log = new MagicLog("ANA_TRANSLATION", PostPk, LogAction.Insert, "", "");
						log.Error = "SQL Error n. " + result;
						log.Insert();
						res = false;
					}
				}
				else
				{
					MagicLog log = new MagicLog("ANA_TRANSLATION", PostPk, LogAction.Insert, "", "");
					log.Error = result;
					log.Insert();
					res = false;
				}
				if (res)
				{
					MagicIndex mi = new MagicIndex(PostPk, TranslatedTitle, LangId);
					string errorMessage = "";
					if (mi.Save(out errorMessage) == 0)
					{
						MagicLog log = new MagicLog("ANA_TRANSLATION", PostPk, LogAction.Insert, MagicSession.Current.LoggedUser.Pk, DateTime.Now, "MagicTramslation", "Save", errorMessage);
						log.Insert();
						res = false;
					}
				}
			}
			catch (Exception e)
			{
				MagicLog log = new MagicLog("ANA_TRANSLATION", PostPk, LogAction.Insert, e);
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

		/// <exclude />
		public Boolean MergeContext(HttpContext context, string[] propertyList, out string msg)
		{
			Boolean result = true;
			msg = "Success";
			Type TheType = typeof(MagicTranslation);
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
				if (String.IsNullOrEmpty(TranslatedTitle))
				{
					msg = "La traduzione del campo \"Titolo\" è obbligatoria!";
					result = false;
				}
			}
			catch (Exception e)
			{
				MagicLog log = new MagicLog("ANA_TRANSLATION", Pk, LogAction.Read, e);
				log.Insert();
				msg = e.Message;
				result = false;
			}

			return result;
		}


		#endregion
	}
}