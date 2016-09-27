using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Web;


namespace MagicCMS.Core
{
    public class MagicPrerogativa
    {
        private static Dictionary<int, string> _prerogative = null;
        public static Dictionary<int, string> Prerogative 
        {
            get
            {
                if (_prerogative == null)
                {
                    Reset();
                }
                return _prerogative;
            } 
 
        }

        public static void Reset()
        {
            if (_prerogative == null)
            {
                _prerogative = new Dictionary<int, string>();
            }
            else 
            {
                _prerogative.Clear();
            }
            SqlConnection conn = null;
            SqlCommand cmd = null;

            try
            {
                string cmdText = " SELECT ap.pre_PK, ap.pre_PREROGATIVA FROM ANA_PREROGATIVE ap ";

                conn = new SqlConnection(MagicUtils.MagicConnectionString);
                conn.Open();
                cmd = new SqlCommand(cmdText, conn);
                SqlDataReader reader = cmd.ExecuteReader();
                if (reader.HasRows)
                {
                    while (reader.Read())
                    {
                        _prerogative.Add(Convert.ToInt32(reader.GetValue(0)), Convert.ToString(reader.GetValue(1)));
                    }
                    

                }
            }
            catch (Exception e)
            {
                MagicLog log = new MagicLog("ANA_PREROGATIVE", 0, LogAction.Read, e);
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

        public static int GetKey(string value)
        {
            if (Prerogative.Count == 0)
                throw new Exception("La tabella prerogative non contiene dat.");

            int key = int.MaxValue;
            foreach (KeyValuePair<int,string> pair in Prerogative)
            {
                if (pair.Value == value)
                    key = pair.Key;
            }
            return key;
        }
    }
}