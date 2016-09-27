using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

namespace MagicCMS.Core
{
    public class MagicLanguageCollection : System.Collections.CollectionBase
    {
        #region Constructor

        public MagicLanguageCollection()
        {
            Init("");
        }

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

        public int Add(MagicLanguage item)
        {
            return List.Add(item);
        }

        public void Insert(int index, MagicLanguage item)
        {
            List.Insert(index, item);
        }

        public void Remove(MagicLanguage item)
        {
            List.Remove(item);
        }

        public bool Contains(MagicLanguage item)
        {
            return List.Contains(item);
        }

        public int IndexOf(MagicLanguage item)
        {
            return List.IndexOf(item);
        }

        public void CopyTo(MagicLanguage[] array, int index)
        {
            List.CopyTo(array, index);
        }

        public MagicLanguage this[int index]
        {
            get { return (MagicLanguage)List[index]; }
            set { List[index] = value; }
        }
        #endregion
    }
}