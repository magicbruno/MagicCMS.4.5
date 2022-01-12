using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

namespace MagicCMS.Core
{
    public class MagicTranslationCollection : System.Collections.CollectionBase
    {
		public const int AllRecords = 0;
        #region Constructor

        /// <summary>
        /// Initializes a new empty instance of the <see cref="MagicTranslationCollection"/> class.
        /// </summary>
        public MagicTranslationCollection() : base()
        {
           
        }
        /// <summary>
        /// Initializes a new instance of the <see cref="MagicTranslationCollection"/> class containing the translations of a specified post.
        /// </summary>
        /// <param name="postPk">Primary key (Id) of the post to which apply translations.</param>
        public MagicTranslationCollection(int postPk)
        {
            Init(postPk, false);
        }

        /// <summary>
		/// Initializes a new instance of the <see cref="MagicTranslationCollection" /> class containing the translations of a specified post.
        /// </summary>
        /// <param name="postPk">Primary key (Id) of the post to which apply translations.</param>
        /// <param name="createBlankRecords">if set to <c>true</c> create empty records if translations don't exists.</param>
        public MagicTranslationCollection(int postPk, Boolean createBlankRecords)
        {
            Init(postPk, createBlankRecords);
        }



        private void Init(int postPk, Boolean createBlankRecords)
        {
            if (createBlankRecords)
            {
                foreach (string key in MagicLanguage.Languages.Keys)
                {
                    List.Add(new MagicTranslation(postPk, key));
                }
            }
            else
            {
				string whereClause;
				if (postPk == AllRecords)
					whereClause = "";
				else
					whereClause = " TRAN_MB_contenuti_Id = " + postPk.ToString() + " ";
                Init(whereClause);

            }
        }

        private void Init(string whereClause)
        {
            SqlConnection conn = new SqlConnection(MagicUtils.MagicConnectionString);
            SqlCommand cmd = new SqlCommand();

            string commandString = @"	SELECT
											vat.TRAN_Pk
										   ,vat.TRAN_Title
										   ,vat.TRAN_TestoBreve
										   ,vat.TRAN_TestoLungo
										   ,vat.TRAN_Tags
										   ,vat.TRAN_MB_contenuti_Id
										   ,vat.LANG_Id
										   ,vat.LANG_Name 
										   ,rmt.RMT_Title
										FROM VW_ANA_TRANSLATION vat
										LEFT JOIN REL_MagicTitle rmt
											ON rmt.RMT_LangId = vat.LANG_Id 
											AND rmt.RMT_Contenuti_Id = vat.TRAN_MB_contenuti_Id " +
                                    (!String.IsNullOrEmpty(whereClause) ? "WHERE " + whereClause : "");

            try
            {
                conn.Open();
                cmd.CommandText = commandString;

                cmd.Connection = conn;

                SqlDataReader reader = cmd.ExecuteReader(CommandBehavior.Default);
                while (reader.Read())
                    List.Add(new MagicTranslation(reader));

            }
            catch (Exception e)
            {
                MagicLog log = new MagicLog("VW_ANA_TRANSLATION", 0, LogAction.Read, e);
                log.Insert();
            }
            finally
            {
                conn.Close();
                //conn.Dispose();
                cmd.Dispose();
            }
        }

        #endregion

        #region Public Methods

		/// <summary>
		/// Adds the specified item.
		/// </summary>
		/// <param name="item">The item.</param>
		/// <returns>System.Int32.</returns>
        public int Add(MagicTranslation item)
        {
            return List.Add(item);
        }

		/// <summary>
		/// Inserts the specified index.
		/// </summary>
		/// <param name="index">The index.</param>
		/// <param name="item">The item.</param>
        public void Insert(int index, MagicTranslation item)
        {
            List.Insert(index, item);
        }

		/// <summary>
		/// Removes the specified item.
		/// </summary>
		/// <param name="item">The item.</param>
        public void Remove(MagicTranslation item)
        {
            List.Remove(item);
        }

		/// <summary>
		/// Determines whether [contains] [the specified item].
		/// </summary>
		/// <param name="item">The item.</param>
		/// <returns><c>true</c> if [contains] [the specified item]; otherwise, <c>false</c>.</returns>
        public bool Contains(MagicTranslation item)
        {
            return List.Contains(item);
        }

		/// <summary>
		/// Indexes the of.
		/// </summary>
		/// <param name="item">The item.</param>
		/// <returns>System.Int32.</returns>
        public int IndexOf(MagicTranslation item)
        {
            return List.IndexOf(item);
        }

		/// <summary>
		/// Copies to.
		/// </summary>
		/// <param name="array">The array.</param>
		/// <param name="index">The index.</param>
        public void CopyTo(MagicTranslation[] array, int index)
        {
            List.CopyTo(array, index);
        }

		/// <summary>
		/// Gets or sets the element at the specified index.
		/// </summary>
		/// <param name="index">The index.</param>
		/// <returns>MagicTranslation.</returns>
        public MagicTranslation this[int index]
        {
            get { return (MagicTranslation)List[index]; }
            set { List[index] = value; }
        }

        public MagicTranslation GetByLangId(string langid)
        {
            foreach (MagicTranslation mt in List)
            {
                if (mt.LangId == langid)
                    return mt;
            }
            return null;
        }
        #endregion
    }
}