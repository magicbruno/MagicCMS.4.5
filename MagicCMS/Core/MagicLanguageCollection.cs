using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

namespace MagicCMS.Core
{
	/// <summary>
	/// Class MagicLanguageCollection.
	/// </summary>
	/// <seealso cref="System.Collections.CollectionBase" />
    public class MagicLanguageCollection : System.Collections.CollectionBase
    {
        #region Constructor

		/// <summary>
		/// Initializes a new instance of the <see cref="MagicLanguageCollection"/> class.
		/// </summary>
        public MagicLanguageCollection()
        {
            Init("");
        }

		/// <summary>
		/// Initializes a new instance of the <see cref="MagicLanguageCollection"/> class populating it with active language definition.
		/// </summary>
		/// <param name="active">The active flag.</param>
        public MagicLanguageCollection(Boolean active)
        {
            Init(" LANG_Active = " + (active ? 1 : 0));
        }

        private void Init(string whereClause)
        {
            SqlConnection conn = new SqlConnection(MagicUtils.MagicConnectionString);
            SqlCommand cmd = new SqlCommand();

            string commandString = " SELECT  " +
                                    "     al.LANG_Id,  " +
                                    "     al.LANG_Name,  " +
                                    "     al.LANG_Active,  " +
                                    "     al.LANG_AutoHide  " +
                                    " FROM ANA_LANGUAGE al  " +
                                    (!String.IsNullOrEmpty(whereClause) ? "WHERE " + whereClause : "");

            try
            {
                conn.Open();
                cmd.CommandText = commandString;

                cmd.Connection = conn;

                SqlDataReader reader = cmd.ExecuteReader(CommandBehavior.Default);
                while (reader.Read())
                    List.Add(new MagicLanguage(reader));

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

        #endregion

        #region Public Methods

		/// <summary>
		/// Adds the specified item.
		/// </summary>
		/// <param name="item">The item.</param>
		/// <returns>System.Int32.</returns>
        public int Add(MagicLanguage item)
        {
            return List.Add(item);
        }

		/// <summary>
		/// Inserts the specified index.
		/// </summary>
		/// <param name="index">The index.</param>
		/// <param name="item">The item.</param>
        public void Insert(int index, MagicLanguage item)
        {
            List.Insert(index, item);
        }

		/// <summary>
		/// Removes the specified item.
		/// </summary>
		/// <param name="item">The item.</param>
        public void Remove(MagicLanguage item)
        {
            List.Remove(item);
        }

		/// <summary>
		/// Determines whether [contains] [the specified item].
		/// </summary>
		/// <param name="item">The item.</param>
		/// <returns><c>true</c> if [contains] [the specified item]; otherwise, <c>false</c>.</returns>
        public bool Contains(MagicLanguage item)
        {
            return List.Contains(item);
        }

		/// <summary>
		/// Indexes the of.
		/// </summary>
		/// <param name="item">The item.</param>
		/// <returns>System.Int32.</returns>
        public int IndexOf(MagicLanguage item)
        {
            return List.IndexOf(item);
        }

		/// <summary>
		/// Copies to.
		/// </summary>
		/// <param name="array">The array.</param>
		/// <param name="index">The index.</param>
        public void CopyTo(MagicLanguage[] array, int index)
        {
            List.CopyTo(array, index);
        }

		/// <summary>
		/// Ottiene o imposta l'elemento in corrispondenza dell'indice specificato.
		/// </summary>
		/// <param name="index">The index.</param>
		/// <returns>MagicLanguage.</returns>
        public MagicLanguage this[int index]
        {
            get { return (MagicLanguage)List[index]; }
            set { List[index] = value; }
        }
        #endregion
    }
}