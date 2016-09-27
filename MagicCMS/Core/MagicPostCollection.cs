using System;
using System.Collections;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

namespace MagicCMS.Core
{
    public class MagicPostCollection : CollectionBase
    {

        #region Constructor
        public MagicPostCollection(WhereClauseCollection query, string order, int maxNum, Boolean allowUnsafe)
        {
            Init(query, order, maxNum, allowUnsafe, false, false);
        }

        public MagicPostCollection(WhereClauseCollection query, string order, int maxNum, Boolean allowUnsafe, Boolean inbasket)
        {
            Init(query, order, maxNum, allowUnsafe, inbasket, false);
        }

        public MagicPostCollection(WhereClauseCollection query, string order, int maxNum, Boolean allowUnsafe, Boolean inbasket, Boolean onlyIfTranslated)
        {
            Init(query, order, maxNum, allowUnsafe, inbasket, onlyIfTranslated);
        }

        public MagicPostCollection()
        {
            Init();
        }

        private void Init()
        {

        }

        private void Init(WhereClauseCollection query, string order, int maxNum, Boolean allowUnsafe, Boolean inbasket, Boolean onlyIfTranslated)
        {
            SqlConnection conn = new SqlConnection(MagicUtils.MagicConnectionString);
            SqlCommand cmd = new SqlCommand();
            string basketfilter = inbasket ? " vmca.Flag_Cancellazione = 1 " : " vmca.Flag_Cancellazione = 0 ";
            string filter = query.ToString(allowUnsafe);
            if (!String.IsNullOrEmpty(filter))
                filter = " WHERE (" + basketfilter + ") AND " + filter;
            else
                filter = " WHERE (" + basketfilter + ") ";

            if (onlyIfTranslated && MagicSession.Current.CurrentLanguage != "default")
            {
                filter += " AND ( TRAN_LANG_Id = '" + MagicSession.Current.CurrentLanguage + "' ) ";
            }

            string orderClause = "";
            string topClause = maxNum > -1 ? "TOP " + maxNum.ToString() + " " : "";
            orderClause = MagicOrdinamento.GetOrderClause(order, "vmca");
            if (!String.IsNullOrEmpty(orderClause))
                orderClause = "ORDER BY " + orderClause;


            try
            {
                conn.Open();
                cmd.CommandText = "SELECT DISTINCT " + topClause +
                                    " 	vmca.Id, " +
                                    " 	vmca.Titolo, " +
                                    " 	vmca.Sottotitolo AS Url2, " +
                                    " 	vmca.Abstract AS TestoLungo, " +
                                    " 	vmca.Autore AS ExtraInfo, " +
                                    " 	vmca.Banner AS TestoBreve, " +
                                    " 	vmca.Link AS Url, " +
                                    " 	vmca.Larghezza, " +
                                    " 	vmca.Altezza, " +
                                    " 	vmca.Tipo, " +
                                    " 	vmca.Contenuto_parent AS Ordinamento, " +
                                    " 	vmca.DataPubblicazione, " +
                                    " 	vmca.DataScadenza, " +
                                    " 	vmca.DataUltimaModifica, " +
                                    " 	vmca.Flag_Attivo, " +
                                    " 	vmca.ExtraInfo1, " +
                                    " 	vmca.ExtraInfo4, " +
                                    " 	vmca.ExtraInfo3, " +
                                    " 	vmca.ExtraInfo2, " +
                                    " 	vmca.ExtraInfo5, " +
                                    " 	vmca.ExtraInfo6, " +
                                    " 	vmca.ExtraInfo7, " +
                                    " 	vmca.ExtraInfo8, " +
                                    " 	vmca.ExtraInfoNumber1, " +
                                    " 	vmca.ExtraInfoNumber2, " +
                                    " 	vmca.ExtraInfoNumber3, " +
                                    " 	vmca.ExtraInfoNumber4, " +
                                    " 	vmca.ExtraInfoNumber5, " +
                                    " 	vmca.ExtraInfoNumber6, " +
                                    " 	vmca.ExtraInfoNumber7, " +
                                    " 	vmca.ExtraInfoNumber8, " +
                                    " 	vmca.Tags, " +
                                    " 	vmca.Propietario AS Owner, " +
                                    " 	vmca.Flag_Cancellazione, " +
                                    " 	RIGHT(RTRIM(vmca.Titolo), CHARINDEX(' ', REVERSE(' ' + RTRIM(vmca.Titolo))) - 1) AS COGNOME " +
                                    " FROM MB_contenuti vmca " +
                                    " 	INNER JOIN ANA_CONT_TYPE act " +
                                    " 		ON vmca.Tipo = act.TYP_PK " +
                                    " 	LEFT JOIN REL_contenuti_Argomenti rca " +
                                    " 		ON vmca.Id = rca.Id_Contenuti " +
                                    " 	LEFT JOIN MB_contenuti mc " +
                                    " 		ON mc.Id = rca.Id_Argomenti " +
                                    "   LEFT JOIN ANA_TRANSLATION " +
                                    "       ON vmca.ID = TRAN_MB_contenuti_Id " +
                                    "   LEFT JOIN REL_KEYWORDS rk " +
                                    "	    ON vmca.Id = rk.key_content_PK " +
                                    filter + orderClause;


                cmd.Connection = conn;
                SqlDataReader reader = cmd.ExecuteReader();
                if (reader.HasRows)
                {
                    //mpc = new MagicPostCollection();
                    while (reader.Read())
                    {
                        List.Add(new MagicPost(reader));
                    }
                }
            }
            catch (Exception e)
            {
                MagicLog log = new MagicLog("MB_contenuti", 0, LogAction.Read, e);
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

        #region PublicMethods
        /// <summary>
        /// Adds item.
        /// </summary>
        /// <param name="item">The item to add.</param>
        /// <returns>
        /// Added item index.
        /// </returns>
        public int Add(MagicPost item)
        {
            return List.Add(item);
        }

        /// <summary>
        /// Inserts item to given index.
        /// </summary>
        /// <param name="index">Zero-based index of the.</param>
        /// <param name="item">The item to add.</param>
        public void Insert(int index, MagicPost item)
        {
            List.Insert(index, item);
        }

        /// <summary>
        /// Removes the given item.
        /// </summary>
        /// <param name="item">The item to remove.</param>
        public void Remove(MagicPost item)
        {
            List.Remove(item);
        }

        ////////////////////////////////////////////////////////////////////////////////////////////////////
        /// <summary>
        /// Query if this object contains the given item.
        /// </summary>
        /// <param name="item">The item to add.</param>
        /// <returns>
        /// true if the object is in this collection, false if not.
        /// </returns>
        public bool Contains(MagicPost item)
        {
            return List.Contains(item);
        }

        /// <summary>
        /// Index of the given item.
        /// </summary>
        /// <param name="item">The item to add.</param>
        /// <returns>
        /// Index of the found item or -1 if not found.
        /// </returns>
        public int IndexOf(MagicPost item)
        {
            return List.IndexOf(item);
        }

        /// <summary>
        /// Copies to array.
        /// </summary>
        /// <param name="array">The array.</param>
        /// <param name="index">Zero-based index of the start.</param>
        public void CopyTo(MagicPost[] array, int index)
        {
            List.CopyTo(array, index);
        }


        #endregion        /

        // <summary>
        /// Indexer to get or set items within this collection using array index syntax.
        /// </summary>
        /// <param name="index">Zero-based index of the entry to access.</param>
        /// <returns>
        /// The indexed item.
        /// </returns>
        public MagicPost this[int index]
        {
            get { return (MagicPost)List[index]; }
            set { List[index] = value; }
        }
    }
}