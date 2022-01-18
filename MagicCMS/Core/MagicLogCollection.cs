using System;
using System.Data.SqlClient;
using System.Diagnostics;

namespace MagicCMS.Core
{
	/// <summary>
	/// Class MagicLogCollection.
	/// </summary>
	/// <seealso cref="System.Collections.CollectionBase" />
    public class MagicLogCollection : System.Collections.CollectionBase
    {

        #region Constructor
		/// <summary>
		/// Initializes a new empty instance of the <see cref="MagicLogCollection"/> class.
		/// </summary>
        public MagicLogCollection()
        {
            Init();
        }

		/// <summary>
		/// Initializes a new instance of the <see cref="MagicLogCollection"/> class. Uses <see cref="MagicCMS.Core.DataTable.InputParams_dt"/> pagination 
		/// to shown it paginated in a jQuery DataTable instance.
		/// </summary>
		/// <param name="pagination">The pagination. (<see cref="MagicCMS.Core.DataTable.InputParams_dt"/>)</param>
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
            //Init(null);
        }


        #endregion


        #region PublicMethods
        public MagicLog this[int index]
        {
            get { return (MagicLog)List[index]; }
            set { List[index] = value; }
        }

		/// <summary>
		/// Adds the specified item.
		/// </summary>
		/// <param name="item">The item.</param>
		/// <returns>System.Int32.</returns>
        public int Add(MagicLog item)
        {
            return List.Add(item);
        }

		/// <summary>
		/// Determines whether [contains] [the specified item].
		/// </summary>
		/// <param name="item">The item.</param>
		/// <returns><c>true</c> if [contains] [the specified item]; otherwise, <c>false</c>.</returns>
        public bool Contains(MagicLog item)
        {
            return List.Contains(item);
        }

		/// <summary>
		/// Copies to.
		/// </summary>
		/// <param name="array">The array.</param>
		/// <param name="index">The index.</param>
        public void CopyTo(MagicLog[] array, int index)
        {
            List.CopyTo(array, index);
        }

		/// <summary>
		/// Indexes the of.
		/// </summary>
		/// <param name="item">The item.</param>
		/// <returns>System.Int32.</returns>
        public int IndexOf(MagicLog item)
        {
            return List.IndexOf(item);
        }

		/// <summary>
		/// Inserts the specified index.
		/// </summary>
		/// <param name="index">The index.</param>
		/// <param name="item">The item.</param>
        public void Insert(int index, MagicLog item)
        {
            List.Insert(index, item);
        }

		/// <summary>
		/// Removes the specified item.
		/// </summary>
		/// <param name="item">The item.</param>
        public void Remove(MagicLog item)
        {
            List.Remove(item);
        }

        #endregion
    }
}