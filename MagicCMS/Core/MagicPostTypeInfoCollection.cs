using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using MagicCMS.DataTable;

namespace MagicCMS.Core
{
    public enum MagicPostTypeInfoOrder
    {
        Alpha, InsertionOrder, None
    }
    public class MagicPostTypeInfoCollection : System.Collections.CollectionBase
    {

        #region Constructor
        /// <summary>
        /// Initializes a new instance of the <see cref="MagicPostTypeInfoCollection"/> class.
        /// </summary>
        public MagicPostTypeInfoCollection()
        {
            Init();
        }

        /// <summary>
        /// Initializes a new instance of the <see cref="MagicPostTypeInfoCollection"/> class. Using 
        /// parameters passed by jquery.DataTable
        /// </summary>
        /// <param name="pagination">The pagination.</param>
        public MagicPostTypeInfoCollection(InputParams_dt pagination)
        {
            Init(pagination, false);
        }

        /// <summary>
        /// Initializes a new instance of the <see cref="MagicPostTypeInfoCollection"/> class. Using 
        /// parameters passed by jquery.DataTable 
        /// </summary>
        /// <param name="pagination">The pagination.</param>
        /// <param name="basket">Show basket (deleted elements).</param>
        public MagicPostTypeInfoCollection(InputParams_dt pagination, Boolean basket)
        {
            Init(pagination, basket);
        }

        /// <summary>
        /// Initializes a new instance of the <see cref="MagicPostTypeInfoCollection"/> class.
        /// </summary>
        /// <param name="onlyActive">if set to <c>true</c> [only active].</param>
        public MagicPostTypeInfoCollection(Boolean onlyActive)
        {
            Init(onlyActive, false, MagicPostTypeInfoOrder.None, "");
        }

        public MagicPostTypeInfoCollection(Boolean onlyActive, Boolean deleted, MagicPostTypeInfoOrder order)
        {
            Init(onlyActive, deleted, order, "");
        }

        public MagicPostTypeInfoCollection(Boolean onlyActive, MagicPostTypeInfoOrder order)
        {
            Init(onlyActive, false, order, "");
        }

        public MagicPostTypeInfoCollection(Boolean onlyActive, Boolean deleted)
        {
            Init(onlyActive, deleted, MagicPostTypeInfoOrder.None, "");
        }

        public MagicPostTypeInfoCollection(Boolean onlyActive, Boolean deleted, string whereClause)
        {
            Init(onlyActive, deleted, MagicPostTypeInfoOrder.None, whereClause);
        }

        public MagicPostTypeInfoCollection(Boolean onlyActive, Boolean deleted, MagicPostTypeInfoOrder order, string whereClause)
        {
            Init(onlyActive, deleted, order, whereClause);
        }

        private void Init()
        {
            Init(true, false, MagicPostTypeInfoOrder.None, "");
        }


        private void Init( Boolean onlyActive,  Boolean del, MagicPostTypeInfoOrder order, string whereClause)
        {
            SqlConnection conn = new SqlConnection(MagicUtils.MagicConnectionString);
            SqlCommand cmd = new SqlCommand();
            string orderClause = "";

            switch (order)
            {
                case MagicPostTypeInfoOrder.Alpha:
                    orderClause = " ORDER BY act.TYP_NAME ";
                    break;
                case MagicPostTypeInfoOrder.InsertionOrder:
                    orderClause = " ORDER BY act.TYP_PK ";
                    break;
                case MagicPostTypeInfoOrder.None:
                    orderClause = "";
                    break;

            }
            try
            {
                conn.Open();
                cmd.CommandText = " SELECT " +
                                    " 	act.TYP_PK, " +
                                    " 	act.TYP_NAME, " +
                                    " 	act.TYP_HELP, " +
                                    " 	act.TYP_ContenutiPreferiti, " +
                                    " 	act.TYP_FlagContenitore, " +
                                    " 	act.TYP_label_Titolo, " +
                                    " 	act.TYP_label_ExtraInfo, " +
                                    " 	act.TYP_label_TestoBreve, " +
                                    " 	act.TYP_label_TestoLungo, " +
                                    " 	act.TYP_label_url, " +
                                    " 	act.TYP_label_url_secondaria, " +
                                    " 	act.TYP_label_scadenza, " +
                                    " 	act.TYP_label_altezza, " +
                                    " 	act.TYP_label_larghezza, " +
                                    " 	act.TYP_label_ExtraInfo_1, " +
                                    " 	act.TYP_label_ExtraInfo_2, " +
                                    " 	act.TYP_label_ExtraInfo_3, " +
                                    " 	act.TYP_label_ExtraInfo_4, " +
                                    " 	act.TYP_label_ExtraInfo_5, " +
                                    " 	act.TYP_label_ExtraInfo_6, " +
                                    " 	act.TYP_label_ExtraInfo_7, " +
                                    " 	act.TYP_label_ExtraInfo_8, " +
                                    " 	act.TYP_label_ExtraInfoNumber_1, " +
                                    " 	act.TYP_label_ExtraInfoNumber_2, " +
                                    " 	act.TYP_label_ExtraInfoNumber_3, " +
                                    " 	act.TYP_label_ExtraInfoNumber_4, " +
                                    " 	act.TYP_label_ExtraInfoNumber_5, " +
                                    " 	act.TYP_label_ExtraInfoNumber_6, " +
                                    " 	act.TYP_label_ExtraInfoNumber_7, " +
                                    " 	act.TYP_label_ExtraInfoNumber_8, " +
                                    " 	act.TYP_flag_cercaServer, " +
                                    " 	act.TYP_DataUltimaModifica, " +
                                    " 	act.TYP_Flag_Attivo, " +
                                    " 	act.TYP_Flag_Cancellazione, " +
                                    " 	act.TYP_Data_Cancellazione, " +
                                    " 	act.TYP_flag_breve, " +
                                    " 	act.TYP_flag_lungo, " +
                                    " 	act.TYP_flag_link, " +
                                    " 	act.TYP_flag_urlsecondaria, " +
                                    " 	act.TYP_flag_scadenza, " +
                                    " 	act.TYP_flag_specialTag, " +
                                    " 	act.TYP_flag_tags, " +
                                    " 	act.TYP_flag_altezza, " +
                                    " 	act.TYP_flag_larghezza, " +
                                    " 	act.TYP_flag_ExtraInfo, " +
                                    " 	act.TYP_flag_ExtraInfo1, " +
                                    " 	act.TYP_flag_BtnGeolog, " +
                                    " 	act.TYP_Icon, " +
                                    " 	act.TYP_MasterPageFile " +
                                    " FROM ANA_CONT_TYPE act " +
                                    " WHERE (act.TYP_Flag_Cancellazione = @Del) " +
                                    (onlyActive ? " AND (act.TYP_Flag_Attivo = 1) ": "") + 
                                    (!String.IsNullOrEmpty(whereClause) ? " AND (" + whereClause + ") " : "") +
                                    orderClause;


                cmd.Connection = conn;
                if (del)
                    cmd.Parameters.AddWithValue("@Del", 1);
                else
                    cmd.Parameters.AddWithValue("@Del", 0);

                SqlDataReader reader = cmd.ExecuteReader(CommandBehavior.Default);
                if (reader.HasRows)
                    while (reader.Read())
                    {
                        List.Add(new MagicPostTypeInfo(reader));
                    }
            }
            catch (Exception e)
            {
                MagicLog log = new MagicLog("ANA_CONT_TYPE", 0, LogAction.Read, e);
                log.Insert();
            }
            finally
            {
                conn.Close();
                cmd.Dispose();
            }
        }

        public void Init (InputParams_dt pagination, Boolean basket)
        {
            SqlConnection conn = null;
            SqlCommand cmd = null;
           
            try
            {
                string cmdText =    " SELECT " +
                                    " 	act.TYP_PK, " +
                                    " 	act.TYP_NAME, " +
                                    " 	act.TYP_HELP, " +
                                    " 	act.TYP_ContenutiPreferiti, " +
                                    " 	act.TYP_FlagContenitore, " +
                                    " 	act.TYP_label_Titolo, " +
                                    " 	act.TYP_label_ExtraInfo, " +
                                    " 	act.TYP_label_TestoBreve, " +
                                    " 	act.TYP_label_TestoLungo, " +
                                    " 	act.TYP_label_url, " +
                                    " 	act.TYP_label_url_secondaria, " +
                                    " 	act.TYP_label_scadenza, " +
                                    " 	act.TYP_label_altezza, " +
                                    " 	act.TYP_label_larghezza, " +
                                    " 	act.TYP_label_ExtraInfo_1, " +
                                    " 	act.TYP_label_ExtraInfo_2, " +
                                    " 	act.TYP_label_ExtraInfo_3, " +
                                    " 	act.TYP_label_ExtraInfo_4, " +
                                    " 	act.TYP_label_ExtraInfo_5, " +
                                    " 	act.TYP_label_ExtraInfo_6, " +
                                    " 	act.TYP_label_ExtraInfo_7, " +
                                    " 	act.TYP_label_ExtraInfo_8, " +
                                    " 	act.TYP_label_ExtraInfoNumber_1, " +
                                    " 	act.TYP_label_ExtraInfoNumber_2, " +
                                    " 	act.TYP_label_ExtraInfoNumber_3, " +
                                    " 	act.TYP_label_ExtraInfoNumber_4, " +
                                    " 	act.TYP_label_ExtraInfoNumber_5, " +
                                    " 	act.TYP_label_ExtraInfoNumber_6, " +
                                    " 	act.TYP_label_ExtraInfoNumber_7, " +
                                    " 	act.TYP_label_ExtraInfoNumber_8, " +
                                    " 	act.TYP_flag_cercaServer, " +
                                    " 	act.TYP_DataUltimaModifica, " +
                                    " 	act.TYP_Flag_Attivo, " +
                                    " 	act.TYP_Flag_Cancellazione, " +
                                    " 	act.TYP_Data_Cancellazione, " +
                                    " 	act.TYP_flag_breve, " +
                                    " 	act.TYP_flag_lungo, " +
                                    " 	act.TYP_flag_link, " +
                                    " 	act.TYP_flag_urlsecondaria, " +
                                    " 	act.TYP_flag_scadenza, " +
                                    " 	act.TYP_flag_specialTag, " +
                                    " 	act.TYP_flag_tags, " +
                                    " 	act.TYP_flag_altezza, " +
                                    " 	act.TYP_flag_larghezza, " +
                                    " 	act.TYP_flag_ExtraInfo, " +
                                    " 	act.TYP_flag_ExtraInfo1, " +
                                    " 	act.TYP_flag_BtnGeolog, " +
                                    " 	act.TYP_Icon, " +
                                    " 	act.TYP_MasterPageFile " +
                                    " FROM ANA_CONT_TYPE act ";

                string deletedClause = (basket) ? " 1 " : " 0 ";
                

                conn = new SqlConnection(MagicUtils.MagicConnectionString);
                conn.Open();
                if (pagination != null)
                {
                    cmd = new SqlCommand(pagination.BuildQuery(cmdText, " act.TYP_Flag_Cancellazione =" + deletedClause), conn);
                    if (!String.IsNullOrEmpty(pagination.search.value))
                        cmd.Parameters.AddWithValue(DataTable.InputParams_dt.SEARCHPARAM, "%" + pagination.search.value + "%");
                }
                else
                {
                    cmd = new SqlCommand(cmdText + " WHERE act.TYP_Flag_Cancellazione =" + deletedClause , conn);
                }

                SqlDataReader reader = cmd.ExecuteReader();
                if (reader.HasRows)
                {
                    while (reader.Read())
                    {
                        MagicPostTypeInfo pro = new MagicPostTypeInfo(reader);
                        List.Add(pro);
                    }


                }
            }
            catch (Exception e)
            {
                MagicLog log = new MagicLog("ANA_CONT_TYPE", 0, LogAction.Read, e);
                log.Insert();
                //throw;
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

        #region PublicMethods

        public int Add(MagicPostTypeInfo item)
        {
            return List.Add(item);
        }

        public void Insert(int index, MagicPostTypeInfo item)
        {
            List.Insert(index, item);
        }

        public void Remove(MagicPostTypeInfo item)
        {
            List.Remove(item);
        }

        public bool Contains(MagicPostTypeInfo item)
        {
            return List.Contains(item);
        }

        public int IndexOf(MagicPostTypeInfo item)
        {
            return List.IndexOf(item);
        }

        public void CopyTo(MagicPostTypeInfo[] array, int index)
        {
            List.CopyTo(array, index);
        }

        public MagicPostTypeInfo this[int index]
        {
            get { return (MagicPostTypeInfo)List[index]; }
            set { List[index] = value; }
        }

        #endregion

    }
}