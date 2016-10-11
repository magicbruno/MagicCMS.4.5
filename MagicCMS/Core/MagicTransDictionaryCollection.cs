using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

namespace MagicCMS.Core
{
	/// <summary>
	/// Class MagicTransDictionaryCollection.
	/// </summary>
	/// <seealso cref="System.Collections.CollectionBase" />
	/// <seealso cref="MagicCMS.Core.MagicTransDictionary"/>
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

		/// <summary>
		/// Initializes an empty new instance of the <see cref="MagicTransDictionaryCollection"/> class.
		/// </summary>
        public MagicTransDictionaryCollection()
        {
            Init();
        }

		/// <summary>
		/// Initializes a new instance of the <see cref="MagicTransDictionaryCollection"/> class containing Translations Dictionary. 
		/// Use <see cref="MagicCMS.DataTable.InputParams_dt"/> pagination to paginate it into jQuery.DataTable.
		/// </summary>
		/// <param name="pagination">The pagination.</param>
        public MagicTransDictionaryCollection(DataTable.InputParams_dt pagination)
        {
            Init(pagination);
        }

		/// <summary>
		/// Adds the specified item.
		/// </summary>
		/// <param name="item">The item.</param>
		/// <returns>System.Int32.</returns>
        public int Add(MagicTransDictionary item)
        {
            return List.Add(item);
        }

		/// <summary>
		/// Inserts the specified index.
		/// </summary>
		/// <param name="index">The index.</param>
		/// <param name="item">The item.</param>
        public void Insert(int index, MagicTransDictionary item)
        {
            List.Insert(index, item);
        }

		/// <summary>
		/// Removes the specified item.
		/// </summary>
		/// <param name="item">The item.</param>
        public void Remove(MagicTransDictionary item)
        {
            List.Remove(item);
        }

		/// <summary>
		/// Determines whether [contains] [the specified item].
		/// </summary>
		/// <param name="item">The item.</param>
		/// <returns><c>true</c> if [contains] [the specified item]; otherwise, <c>false</c>.</returns>
        public bool Contains(MagicTransDictionary item)
        {
            return List.Contains(item);
        }

		/// <summary>
		/// Indexes the of.
		/// </summary>
		/// <param name="item">The item.</param>
		/// <returns>System.Int32.</returns>
        public int IndexOf(MagicTransDictionary item)
        {
            return List.IndexOf(item);
        }

		/// <summary>
		/// Copies to.
		/// </summary>
		/// <param name="array">The array.</param>
		/// <param name="index">The index.</param>
        public void CopyTo(MagicTransDictionary[] array, int index)
        {
            List.CopyTo(array, index);
        }

		/// <summary>
		/// Gets or sets the element at the specified index.
		/// </summary>
		/// <param name="index">The index.</param>
		/// <returns>MagicTransDictionary.</returns>
        public MagicTransDictionary this[int index]
        {
            get { return (MagicTransDictionary)List[index]; }
            set { List[index] = value; }
        }
    }
}