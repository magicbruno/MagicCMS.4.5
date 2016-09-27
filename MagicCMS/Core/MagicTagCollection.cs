using MagicCMS.DataTable;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

namespace MagicCMS.Core
{
    public enum MagicTagContainer
    {
        Container, NonContainer, Both
    }

    /// <summary>
    /// Collection of magic tags.
    /// </summary>
    /// <remarks>
    /// Bruno, 15/01/2013.
    /// </remarks>
    public class MagicTagCollection : CollectionBase
    {

        #region Constructor
        public MagicTagCollection()
        {
            Init(0, MagicTagContainer.Both, null, 1000, false);
        }

        public MagicTagCollection(int parent_id)
        {
            Init(parent_id, MagicTagContainer.Both, null, 0, false);
        }

        public MagicTagCollection(int parent_id, InputParams_dt pagination)
        {
            Init(parent_id, MagicTagContainer.Both, pagination, 0, false);
        }

        /// <summary>
        /// Initializes a new instance of the <see cref="MagicTagCollection"/> class.
        /// </summary>
        /// <param name="parent_id">The parent_id: 0 = No parent, -1 All records, -2 = deleted records</param>
        /// <param name="isContainer">The is container.</param>
        /// <param name="pagination">The pagination.</param>
        /// <param name="maxNum">The maximum number.</param>
        public MagicTagCollection(int parent_id, MagicTagContainer isContainer, InputParams_dt pagination, int maxNum)
        {
            Init(parent_id, isContainer, pagination, maxNum, false);
        }

        /// <summary>
        /// Initializes a new instance of the <see cref="MagicTagCollection"/> class.
        /// </summary>
        /// <param name="parent_id">The parent_id: 0 = No parent, -1 All records, -2 = deleted records</param>
        /// <param name="isContainer">The is container.</param>
        /// <param name="pagination">The pagination.</param>
        /// <param name="maxNum">The maximum number.</param>
        public MagicTagCollection(int parent_id, MagicTagContainer isContainer, InputParams_dt pagination, int maxNum, Boolean onlyIfTranslated)
        {
            Init(parent_id, isContainer, pagination, maxNum, onlyIfTranslated);
        }

        private void Init(int parent_id, MagicTagContainer isContainer, InputParams_dt pagination, int maxNum, Boolean onlyIfTranslated)
        {
            SqlConnection conn = null;
            SqlCommand cmd = null;

            try
            {
                string topClause = (maxNum > 0) ? " TOP " + maxNum.ToString() : " TOP 100000 ";
                string selectCmd =  "SELECT DISTINCT " + topClause +
                                    "         vmca.ID, " +
                                    "         vmca.Titolo, " +
                                    "         vmca.Sottotitolo AS Url2, " +
                                    "         vmca.Abstract AS TestoLungo, " +
                                    "         vmca.Autore AS ExtraInfo, " +
                                    "         vmca.Banner AS TestoBreve, " +
                                    "         vmca.Link AS Url, " +
                                    "         vmca.Larghezza, " +
                                    "         vmca.Altezza, " +
                                    "         vmca.Tipo, " +
                                    "         vmca.Contenuto_parent AS Ordinamento, " +
                                    "         vmca.DataPubblicazione, " +
                                    "         vmca.DataScadenza, " +
                                    "         vmca.DataUltimaModifica, " +
                                    "         vmca.Flag_Attivo, " +
                                    "         vmca.ExtraInfo1, " +
                                    "         vmca.ExtraInfo4, " +
                                    "         vmca.ExtraInfo3, " +
                                    "         vmca.ExtraInfo2, " +
                                    "         vmca.ExtraInfo5, " +
                                    "         vmca.ExtraInfo6, " +
                                    "         vmca.ExtraInfo7, " +
                                    "         vmca.ExtraInfo8, " +
                                    "         vmca.ExtraInfoNumber1, " +
                                    "         vmca.ExtraInfoNumber2, " +
                                    "         vmca.ExtraInfoNumber3, " +
                                    "         vmca.ExtraInfoNumber4, " +
                                    "         vmca.ExtraInfoNumber5, " +
                                    "         vmca.ExtraInfoNumber6, " +
                                    "         vmca.ExtraInfoNumber7, " +
                                    "         vmca.ExtraInfoNumber8, " +
                                    "         vmca.Tags, " +
                                    "         vmca.Propietario AS Owner, " +
                                    "         vmca.Flag_Cancellazione, " +
                                    "         act.TYP_NAME " +
                                    " FROM MB_contenuti vmca " +
                                    "         INNER JOIN ANA_CONT_TYPE act " +
                                    "                 ON vmca.Tipo = act.TYP_PK " +
                                    "         LEFT JOIN REL_contenuti_Argomenti rca " +
                                    "                 ON vmca.ID = rca.Id_Contenuti " +
                                    "         LEFT JOIN ANA_TRANSLATION " +
                                    "                 ON vmca.ID = TRAN_MB_contenuti_Id "; 
                string whereClause = "";

                if (parent_id > 0)
                    whereClause = " (Id_Argomenti = " + parent_id.ToString() + ") AND (Flag_Cancellazione = 0) ";
                else if (parent_id == 0)
                    whereClause = " (Id_Argomenti IS NULL)  AND (Flag_Cancellazione = 0) ";
                else if (parent_id == -1)
                    whereClause = " (Flag_Cancellazione = 0) ";
                else if (parent_id == -2)
                    whereClause = " (Flag_Cancellazione = 1) ";

                if (isContainer != MagicTagContainer.Both)
                {
                    whereClause += (whereClause != "") ? " AND (" : " (";
                    if (isContainer == MagicTagContainer.Container)
                        whereClause += " act.TYP_FlagContenitore = 1)";
                    else
                        whereClause += " act.TYP_FlagContenitore = 0)";
                }

                if (onlyIfTranslated && MagicSession.Current.CurrentLanguage != "default")
                {
                    whereClause += (whereClause != "") ? " AND (" : " (";
                    whereClause += "TRAN_LANG_Id = '" + MagicSession.Current.CurrentLanguage + "') ";
                }

                conn = new SqlConnection(MagicUtils.MagicConnectionString);
                conn.Open();
                string cmdText;

                if (pagination != null)
                {
                    cmdText = pagination.BuildQuery(selectCmd, whereClause);
                    cmd = new SqlCommand(cmdText, conn);
                    if (!String.IsNullOrEmpty(pagination.search.value))
                        cmd.Parameters.AddWithValue(DataTable.InputParams_dt.SEARCHPARAM, "%" + pagination.search.value + "%");
                }
                else
                {
                    cmdText = selectCmd + (!string.IsNullOrEmpty(whereClause) ? " WHERE " + whereClause + " " : "");
                    cmd = new SqlCommand(cmdText, conn);
                }
                SqlDataReader reader = cmd.ExecuteReader();
                while (reader.Read())
                {
                    List.Add(new MagicTag(reader));
                }

            }
            catch (Exception e)
            {
                MagicLog log = new MagicLog("VW_MB_contenuti_attivi", 0, LogAction.Read, e);
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

     }
}