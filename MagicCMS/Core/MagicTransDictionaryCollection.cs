using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

namespace MagicCMS.Core
{
    public class MagicTransDictionaryCollection : System.Collections.CollectionBase
    {
        private void Init(DataTable.InputParams_dt pagination)
        {
            SqlConnection conn = null;
            SqlCommand cmd = null;

            try
            {
                string cmdText = " SELECT " +
                                    "     ad.DICT_Pk, " +
                                    "     ad.DICT_Source, " +
                                    "     ad.DICT_LANG_Id, " +
                                    "     ad.DICT_Translation " +
                                    " FROM ANA_Dictionary ad ";

                conn = new SqlConnection(MagicUtils.MagicConnectionString);
                conn.Open();
                if (pagination != null)
                {
                    cmd = new SqlCommand(pagination.BuildQuery(cmdText), conn);
                    cmd.Parameters.AddWithValue(DataTable.InputParams_dt.SEARCHPARAM, "%" + pagination.search.value + "%");
                }
                else
                {
                    cmd = new SqlCommand(cmdText, conn);
                }
                SqlDataReader reader = cmd.ExecuteReader();
                if (reader.HasRows)
                {
                    while (reader.Read())
                    {
                        List.Add(new MagicTransDictionary(reader));
                    }

                }
            }
            catch (Exception e)
            {
                MagicLog log = new MagicLog("ANA_Dictionary", 0, LogAction.Read, e);
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

        public MagicTransDictionaryCollection()
        {
            Init();
        }

        public MagicTransDictionaryCollection(DataTable.InputParams_dt pagination)
        {
            Init(pagination);
        }

        public int Add(MagicTransDictionary item)
        {
            return List.Add(item);
        }

        public void Insert(int index, MagicTransDictionary item)
        {
            List.Insert(index, item);
        }

        public void Remove(MagicTransDictionary item)
        {
            List.Remove(item);
        }

        public bool Contains(MagicTransDictionary item)
        {
            return List.Contains(item);
        }

        public int IndexOf(MagicTransDictionary item)
        {
            return List.IndexOf(item);
        }

        public void CopyTo(MagicTransDictionary[] array, int index)
        {
            List.CopyTo(array, index);
        }

        public MagicTransDictionary this[int index]
        {
            get { return (MagicTransDictionary)List[index]; }
            set { List[index] = value; }
        }
    }
}