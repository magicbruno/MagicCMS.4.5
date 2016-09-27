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
        /// Initializes a new instance of the <see cref="MagicTranslationCollection"/> class.
        /// </summary>
        public MagicTranslationCollection() : base()
        {
           
        }
        /// <summary>
        /// Initializes a new instance of the <see cref="MagicTranslationCollection"/> class.
        /// </summary>
        /// <param name="postPk">Primary key (Id) of the post to whch apply translations.</param>
        public MagicTranslationCollection(int postPk)
        {
            Init(postPk, false);
        }

        /// <summary>
        /// Initializes a new instance of the <see cref="MagicTranslationCollection" /> class.
        /// </summary>
        /// <param name="postPk">Primary key (Id) of the post to whch apply translations.</param>
        /// <param name="createBlankRecords">if set to <c>true</c> create brank records if translations don't exists.</param>
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

            string commandString = " SELECT " +
                                    "     vat.TRAN_Pk, " +
                                    "     vat.TRAN_Title, " +
                                    "     vat.TRAN_TestoBreve, " +
                                    "     vat.TRAN_TestoLungo, " +
                                    "     vat.TRAN_Tags, " +
                                    "     vat.TRAN_MB_contenuti_Id, " +
                                    "     vat.LANG_Id, " +
                                    "     vat.LANG_Name " +
                                    " FROM VW_ANA_TRANSLATION vat " +
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

        public int Add(MagicTranslation item)
        {
            return List.Add(item);
        }

        public void Insert(int index, MagicTranslation item)
        {
            List.Insert(index, item);
        }

        public void Remove(MagicTranslation item)
        {
            List.Remove(item);
        }

        public bool Contains(MagicTranslation item)
        {
            return List.Contains(item);
        }

        public int IndexOf(MagicTranslation item)
        {
            return List.IndexOf(item);
        }

        public void CopyTo(MagicTranslation[] array, int index)
        {
            List.CopyTo(array, index);
        }

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