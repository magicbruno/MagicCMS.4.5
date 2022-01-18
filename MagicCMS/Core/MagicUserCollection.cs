using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

namespace MagicCMS.Core
{
	/// <summary>
	/// Class MagicUserCollection.
	/// </summary>
	/// <seealso cref="System.Collections.CollectionBase" />
	/// <seealso cref="MagicCMS.Core.MagicUser"/>
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
            //Init(null);
        }

		/// <summary>
		/// Initializes an empty new instance of the <see cref="MagicUserCollection"/> class.
		/// </summary>
        public MagicUserCollection()
        {
            //Init();
        }


		/// <summary>
		/// Initializes a new instance of the <see cref="MagicUserCollection"/> class containing signed Users . 
		/// Use <see cref="MagicCMS.DataTable.InputParams_dt"/> pagination to paginate it into jQuery.DataTable.
		/// </summary>
		/// <param name="pagination">The pagination.</param>
        public MagicUserCollection(DataTable.InputParams_dt pagination)
        {
            Init(pagination);
        }

		/// <summary>
		/// Adds the specified item.
		/// </summary>
		/// <param name="item">The item.</param>
		/// <returns>System.Int32.</returns>
        public int Add(MagicUser item)
        {
            return List.Add(item);
        }

		/// <summary>
		/// Inserts the specified index.
		/// </summary>
		/// <param name="index">The index.</param>
		/// <param name="item">The item.</param>
        public void Insert(int index, MagicUser item)
        {
            List.Insert(index, item);
        }

		/// <summary>
		/// Removes the specified item.
		/// </summary>
		/// <param name="item">The item.</param>
        public void Remove(MagicUser item)
        {
            List.Remove(item);
        }

		/// <summary>
		/// Determines whether [contains] [the specified item].
		/// </summary>
		/// <param name="item">The item.</param>
		/// <returns><c>true</c> if [contains] [the specified item]; otherwise, <c>false</c>.</returns>
        public bool Contains(MagicUser item)
        {
            return List.Contains(item);
        }

		/// <summary>
		/// Indexes the of.
		/// </summary>
		/// <param name="item">The item.</param>
		/// <returns>System.Int32.</returns>
        public int IndexOf(MagicUser item)
        {
            return List.IndexOf(item);
        }

		/// <summary>
		/// Copies to.
		/// </summary>
		/// <param name="array">The array.</param>
		/// <param name="index">The index.</param>
        public void CopyTo(MagicUser[] array, int index)
        {
            List.CopyTo(array, index);
        }

		/// <summary>
		/// Gets or sets the element at the specified index.
		/// </summary>
		/// <param name="index">The index.</param>
		/// <returns>MagicUser.</returns>
        public MagicUser this[int index]
        {
            get { return (MagicUser)List[index]; }
            set { List[index] = value; }
        }
    }
}