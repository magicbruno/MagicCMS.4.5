using System;
using System.Data.SqlClient;
using System.Diagnostics;

namespace MagicCMS.Core
{
    public class MagicLogCollection : System.Collections.CollectionBase
    {

        #region Constructor
        public MagicLogCollection()
        {
            Init();
        }

        public MagicLogCollection(DataTable.InputParams_dt pagination)
        {
            Init(pagination);
        }

        private void Init(DataTable.InputParams_dt pagination)
        {
            SqlConnection conn = null;
            SqlCommand cmd = null;

            try
            {
                string cmdText = " SELECT " +
                                    " 	vlr.reg_PK, " +
                                    " 	vlr.reg_TABELLA, " +
                                    " 	vlr.reg_RECORD_PK, " +
                                    " 	vlr.reg_act_PK, " +
                                    " 	vlr.reg_user_PK, " +
                                    " 	vlr.reg_ERROR, " +
                                    " 	vlr.reg_TIMESTAMP, " +
                                    " 	vlr.usr_EMAIL, " +
                                    " 	vlr.reg_fileName, " +
                                    " 	vlr.reg_methodName " +
                                    " FROM VW_LOG_REGISTRY vlr ";

                conn = new SqlConnection(MagicUtils.MagicConnectionString);
                conn.Open();
                if (pagination != null)
                {
                    cmd = new SqlCommand(pagination.BuildQuery(cmdText), conn);
                    if (!String.IsNullOrEmpty(pagination.search.value))
                        cmd.Parameters.AddWithValue(DataTable.InputParams_dt.SEARCHPARAM, "%" + pagination.search.value + "%");
                }
                else
                {
                    cmd = new SqlCommand(cmdText, conn);
                }
                SqlDataReader reader = cmd.ExecuteReader();
                while (reader.Read())
                {
                    this.Add(new MagicLog(reader));
                }
            }
            catch (Exception e)
            {
                MagicLog log = new MagicLog("_LOG_REGISTRY", 0, LogAction.Read, e);
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

        private void Init()
        {
            Init(null);
        }


        #endregion


        #region PublicMethods
        public MagicLog this[int index]
        {
            get { return (MagicLog)List[index]; }
            set { List[index] = value; }
        }

        public int Add(MagicLog item)
        {
            return List.Add(item);
        }

        public bool Contains(MagicLog item)
        {
            return List.Contains(item);
        }

        public void CopyTo(MagicLog[] array, int index)
        {
            List.CopyTo(array, index);
        }

        public int IndexOf(MagicLog item)
        {
            return List.IndexOf(item);
        }

        public void Insert(int index, MagicLog item)
        {
            List.Insert(index, item);
        }

        public void Remove(MagicLog item)
        {
            List.Remove(item);
        }

        #endregion
    }
}