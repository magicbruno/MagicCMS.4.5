using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

namespace MagicCMS.Core
{
    public class MagicUserCollection : System.Collections.CollectionBase
    {
        private void Init(DataTable.InputParams_dt pagination)
        {
            SqlConnection conn = null;
            SqlCommand cmd = null;

            try
            {
                string cmdText = " SELECT TOP 100 PERCENT" +
                                    " 	au.usr_PK, " +
                                    " 	au.usr_EMAIL, " +
                                    " 	au.usr_NAME, " +
                                    " 	au.usr_LEVEL, " +
                                    " 	au.usr_LAST_MODIFIED, " +
                                    " 	au.usr_PASSWORD " +
                                    " FROM ANA_USR au ";

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
                        MagicUser user = new MagicUser();
                        user.Pk = Convert.ToInt32(reader.GetValue(0));
                        user.Email = Convert.ToString(reader.GetValue(1));
                        user.Name = Convert.ToString(reader.GetValue(2));
                        user.Level = Convert.ToInt32(reader.GetValue(3));
                        user.LastModify = Convert.ToDateTime(reader.GetValue(4));
                        user.Password = Convert.ToString(reader.GetValue(5));
                        this.Add(user);
                    }

                }
            }
            catch (Exception e)
            {
                MagicLog log = new MagicLog("ANA_USR", 0, LogAction.Read, e);
                log.Error = e.Message;
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

        private void Init()
        {
            Init(null);
        }

        public MagicUserCollection()
        {
            Init();
        }

        public MagicUserCollection(DataTable.InputParams_dt pagination)
        {
            Init(pagination);
        }

        public int Add(MagicUser item)
        {
            return List.Add(item);
        }

        public void Insert(int index, MagicUser item)
        {
            List.Insert(index, item);
        }

        public void Remove(MagicUser item)
        {
            List.Remove(item);
        }

        public bool Contains(MagicUser item)
        {
            return List.Contains(item);
        }

        public int IndexOf(MagicUser item)
        {
            return List.IndexOf(item);
        }

        public void CopyTo(MagicUser[] array, int index)
        {
            List.CopyTo(array, index);
        }

        public MagicUser this[int index]
        {
            get { return (MagicUser)List[index]; }
            set { List[index] = value; }
        }
    }
}