using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Threading.Tasks;
using System.Web;

namespace MagicCMS.Core
{
    public class JTreeInfoList : List<JTreeInfo>
    {
        public JTreeInfoList()
        {

        }

        public JTreeInfoList(int parent)
        {
            SqlConnection conn = null;
            SqlCommand cmd = null;

            try
            {
                string cmdText = @" SELECT DISTINCT
	                                    mc.Id
                                       ,mc.Titolo
                                       ,act.TYP_Icon AS Icon
                                       ,ISNULL(rca1.Id_Argomenti, 0) AS parent 
                                       ,act.TYP_NAME AS NomeTipo
                                    FROM REL_contenuti_Argomenti rca
                                    INNER JOIN MB_contenuti mc
	                                    ON mc.Id = rca.Id_Argomenti
                                    INNER JOIN ANA_CONT_TYPE act
	                                    ON act.TYP_PK = mc.Tipo
                                    INNER JOIN MB_contenuti mc1
	                                    ON mc1.Id = rca.Id_Contenuti
                                    LEFT JOIN REL_contenuti_Argomenti rca1
	                                    ON mc.Id = rca1.Id_Contenuti
                                    WHERE mc.Flag_Cancellazione = 0
                                    AND (ISNULL(rca1.Id_Argomenti, 0) = @parent
                                    OR @parent = -1)
                                    ORDER BY parent, Titolo ";

                conn = new SqlConnection(MagicUtils.MagicConnectionString);
                conn.Open();
                cmd = new SqlCommand(cmdText, conn);
                cmd.Parameters.AddWithValue("@parent", parent);
                SqlDataReader reader = cmd.ExecuteReader();
                while (reader.Read())
                {
                    Add(new JTreeInfo(reader));
                }

            }
            catch (Exception e)
            {
                MagicLog log = new MagicLog("JTreeInfoList()", 0, LogAction.Read, e);
                log.Insert();
                throw e;
            }
            finally
            {
                if (conn != null)
                    conn.Dispose();
                if (cmd != null)
                    cmd.Dispose();
            }
        }
        public JTreeInfoList GetChildren(int parent)
        {
            JTreeInfoList list = new JTreeInfoList();
            foreach (JTreeInfo item in this)
            {
                if (item.Parent == parent)
                    list.Add(item);
            }
            return list;
        }

        public async static Task<JTreeInfoList> CreateAsync()
        {
            JTreeInfoList infos = new JTreeInfoList();
            SqlConnection conn = null;
            SqlCommand cmd = null;

            try
            {
                string cmdText = @" SELECT DISTINCT
	                                    mc.ID
                                       ,mc.Titolo
                                       ,act.TYP_Icon AS Icon
                                       ,ISNULL(rca1.Id_Argomenti, 0) AS parent
                                       ,act.TYP_NAME AS NomeTipo
                                    FROM  MB_contenuti mc
                                    INNER JOIN ANA_CONT_TYPE act
	                                    ON act.TYP_PK = mc.Tipo
                                    LEFT JOIN REL_contenuti_Argomenti rca1
	                                    ON mc.ID = rca1.Id_Contenuti
                                    WHERE mc.Flag_Cancellazione = 0 AND act.TYP_FlagContenitore = 1
                                    ORDER BY parent, Titolo";

                conn = new SqlConnection(MagicUtils.MagicConnectionString);
                await conn.OpenAsync();
                cmd = new SqlCommand(cmdText, conn);
                SqlDataReader reader = await cmd.ExecuteReaderAsync();
                while (reader.Read())
                {
                    infos.Add(new JTreeInfo(reader));
                }

            }
            catch (Exception e)
            {
                MagicLog log = new MagicLog("JTreeInfoList()", 0, LogAction.Read, e);
                log.Insert();
                throw e;
            }
            finally
            {
                if (conn != null)
                    conn.Dispose();
                if (cmd != null)
                    cmd.Dispose();
            }
            return infos;
        }

        public static JTreeInfoList Create()
        {
            JTreeInfoList infos = new JTreeInfoList();
            SqlConnection conn = null;
            SqlCommand cmd = null;

            try
            {
                string cmdText = @" SELECT DISTINCT
	                                    mc.Id
                                       ,mc.Titolo
                                       ,act.TYP_Icon AS Icon
                                       ,ISNULL(rca1.Id_Argomenti, 0) AS parent 
                                       ,act.TYP_NAME AS NomeTipo
                                    FROM REL_contenuti_Argomenti rca
                                    INNER JOIN MB_contenuti mc
	                                    ON mc.Id = rca.Id_Argomenti
                                    INNER JOIN ANA_CONT_TYPE act
	                                    ON act.TYP_PK = mc.Tipo
                                    INNER JOIN MB_contenuti mc1
	                                    ON mc1.Id = rca.Id_Contenuti
                                    LEFT JOIN REL_contenuti_Argomenti rca1
	                                    ON mc.Id = rca1.Id_Contenuti
                                    WHERE mc.Flag_Cancellazione = 0
                                    ORDER BY parent, Titolo ";

                conn = new SqlConnection(MagicUtils.MagicConnectionString);
                conn.Open();
                cmd = new SqlCommand(cmdText, conn);
                SqlDataReader reader = cmd.ExecuteReader();
                while (reader.Read())
                {
                    infos.Add(new JTreeInfo(reader));
                }

            }
            catch (Exception e)
            {
                MagicLog log = new MagicLog("JTreeInfoList()", 0, LogAction.Read, e);
                log.Insert();
                throw e;
            }
            finally
            {
                if (conn != null)
                    conn.Dispose();
                if (cmd != null)
                    cmd.Dispose();
            }
            return infos;
        }

    }

    public class JTreeInfo
    {
        public int Pk { get; set; }
        public string Titolo { get; set; }
        public string Icon { get; set; }
        public int Parent { get; set; }
        public string NomeTipo { get; set; }

        public JTreeInfo(SqlDataReader reader)
        {
            Pk = reader.GetInt32(0);
            Titolo =!reader.IsDBNull(1) ? reader.GetString(1) : "";
            Icon = !reader.IsDBNull(2) ? reader.GetString(2) : "fa-file-text";
            Parent = !reader.IsDBNull(3) ? reader.GetInt32(3) : 0;
            NomeTipo = !reader.IsDBNull(4) ? reader.GetString(4) : "";
        }
    }
}