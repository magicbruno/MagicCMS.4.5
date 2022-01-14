using MagicCMS.Core;
using System;
using System.Collections;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Threading.Tasks;
using System.Web;

namespace MagicCMS.DataTable
{
    public class MpForTable
    {
        #region PublicProperties
        /// <summary>
        /// Gets or sets the pk.
        /// </summary>
        /// <value>
        /// The pk.
        /// </value>
        public int Pk
        {
            get; private set;
        }

        /// <summary>
        /// Gets or sets the titolo.
        /// </summary>
        /// <value>
        /// The titolo.
        /// </value>
        public string Titolo
        {
            get; private set;
        }

        /// <summary>
        /// Gets or sets the nome tipo.
        /// </summary>
        /// <value>
        /// The nome tipo.
        /// </value>
        /// return _MagicPost.NomeTipo;
        public string NomeTipo
        {
            get; private set;
        }

        public string Url
        {
            get; private set;
        }

        public string Url2
        {
            get; private set;
        }

        private MagicPostWhichUrl _whichUrl = MagicPostWhichUrl.UrlMain;
        public MagicPostWhichUrl? WhichImage
        {
            get
            {
                if (_whichUrl == MagicPostWhichUrl.UrlMain)
                {
                    if (!String.IsNullOrEmpty(Url))
                        return MagicPostWhichUrl.UrlMain;
                    else if (!String.IsNullOrEmpty(Url2))
                        return MagicPostWhichUrl.UrlSEcondary;
                    else
                        return null;
                }
                else
                {
                    if (!String.IsNullOrEmpty(Url2))
                        return MagicPostWhichUrl.UrlSEcondary;
                    else if (!String.IsNullOrEmpty(Url))
                        return MagicPostWhichUrl.UrlMain;
                    else return null;
                }
            }
        }

        public int Miniature_pk
        {
            get
            {
                int pk = 0;
                try
                {
                    if (WhichImage.HasValue)
                    {
                        if (WhichImage.Value == MagicPostWhichUrl.UrlMain)
                        {
                            Miniatura min = new Miniatura(Url, 52, 39);
                            pk = min.Pk;
                        }
                        else if (WhichImage.Value == MagicPostWhichUrl.UrlSEcondary)
                        {
                            Miniatura min = new Miniatura(Url2, 52, 39);
                            pk = min.Pk;
                        }

                    }

                }
                catch (Exception)
                {
                    pk = 0;

                }
                return pk;
            }
        }

        //return _MagicPost.TypeInfo.Icon;
        public string Icon
        {
            get; private set;
        }

        /// <summary>
        /// Gets or sets the type.
        /// </summary>
        /// <value>
        /// The Type.
        /// </value>
        public int Tipo
        {
            get; private set;
        }

        /// <summary>
        /// Gets or sets a value indicating whether [special tag].
        /// </summary>
        /// <value>
        ///   <c>true</c> if [special tag]; otherwise, <c>false</c>.
        /// </value>
        ///  return _MagicPost.TypeInfo.FlagSpecialTag;
        public Boolean SpecialTag
        {
            get; private set;
        }

        /// <summary>
        /// Gets or sets the publishing date.
        /// </summary>
        /// <value>
        /// The publishing date.
        /// </value>
        public DateTime? DataPubblicazione
        {
            get; private set;
        }

        /// <summary>
        /// Gets or sets the expiry date.
        /// </summary>
        /// <value>
        /// The expiry date.
        /// </value>
        public DateTime? DataScadenza
        {
            get; private set;
        }

        /// <summary>
        /// Gets or sets the Last Modified Date.
        /// </summary>
        /// <value>
        /// Last Modified Date.
        /// </value>
        public DateTime DataUltimaModifica
        {
            get; private set;
        }


        /// <summary>
        /// Gets or sets a value indicating whether this <see cref="MagicTag"/> is container.
        /// </summary>
        /// <value>
        ///   <c>true</c> if container; otherwise, <c>false</c>.
        /// </value>
        /// return _MagicPost.Contenitore;
        public Boolean FlagContainer
        {
            get; private set;
        }

        /// <summary>
        /// Gets or sets a value indicating whether elementi is in the basket.
        /// </summary>
        /// <value>
        ///   <c>true</c> if [flag cancellazione]; otherwise, <c>false</c>.
        /// </value>
        public Boolean FlagCancellazione
        {
            get; private set;
        }

        /// <summary>
        /// Gets or sets Extra Information on the Post.
        /// </summary>
        /// <value>
        /// The Extra Informations.
        /// </value>
        public String ExtraInfo
        {
            get; private set;
        }

        /// <summary>
        /// Gets or sets the order.
        /// </summary>
        /// <value>
        /// The order.
        /// </value>
        public int Order
        {
            get; private set;
        }

        #endregion

        #region Constructor

        public MpForTable(SqlDataReader reader)
        {
            Init(reader);
        }

        private void Init()
        {
            Pk = 0;
            Titolo = "";
            NomeTipo = "";
            Url = "";
            Url2 = "";
            Icon = "";
            Tipo = 0;
            SpecialTag = false;
            DataPubblicazione = null;
            DataScadenza = null;
            DataUltimaModifica = DateTime.Now;
            FlagContainer = false;
            FlagCancellazione = false;
            ExtraInfo = "";
            Order = 0;
        }

        private void Init(string query)
        {
            SqlConnection conn = null;
            SqlCommand cmd = null;

            try
            {
                string cmdText = @" SELECT
	                                    mc.Id
                                       ,mc.Titolo 
                                       ,act.TYP_NAME AS NomeTipo
                                       ,mc.Link AS Url 
                                       ,mc.Sottotitolo AS Url2
                                       ,act.TYP_Icon AS Icon 
                                       ,mc.Tipo 
                                       ,act.TYP_flag_specialTag AS SpecialTag 
                                       ,mc.DataPubblicazione
                                       ,mc.DataScadenza 
                                       ,mc.DataUltimaModifica 
                                       ,act.TYP_FlagContenitore 
                                       ,mc.Flag_Cancellazione
                                       ,mc.Autore AS ExtraInfo 
                                       ,mc.Contenuto_parent AS Ordinamento
                                    FROM MB_contenuti mc
                                    INNER JOIN ANA_CONT_TYPE act
	                                    ON act.TYP_PK = mc.Tipo  " + 
                                    (string.IsNullOrWhiteSpace(query) ? "" : " WHERE ") + query;

                conn = new SqlConnection(MagicUtils.MagicConnectionString);
                conn.Open();
                cmd = new SqlCommand(cmdText, conn);
                SqlDataReader reader = cmd.ExecuteReader(CommandBehavior.SingleRow);
                if (reader.Read())
                {
                    Init(reader);
                }
                else
                {
                    Init();
                }
            }
            catch (Exception e)
            {
                MagicLog log = new MagicLog("VOTI", Pk, LogAction.Read, e);
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

        private void Init(SqlDataReader reader)
        {
            if (!reader.IsDBNull(0)) Pk = Convert.ToInt32(reader.GetValue(0));
            if (!reader.IsDBNull(1)) Titolo = Convert.ToString(reader.GetValue(1));
            if (!reader.IsDBNull(2)) NomeTipo = Convert.ToString(reader.GetValue(2));
            if (!reader.IsDBNull(3)) Url = Convert.ToString(reader.GetValue(3));
            if (!reader.IsDBNull(4)) Url2 = Convert.ToString(reader.GetValue(4));
            if (!reader.IsDBNull(5)) Icon = Convert.ToString(reader.GetValue(5));
            if (!reader.IsDBNull(6)) Tipo = Convert.ToInt32(reader.GetValue(6));
            if (!reader.IsDBNull(7)) SpecialTag = Convert.ToBoolean(reader.GetValue(7));
            if (!reader.IsDBNull(8)) DataPubblicazione = Convert.ToDateTime(reader.GetValue(8));
            if (!reader.IsDBNull(9)) DataScadenza = Convert.ToDateTime(reader.GetValue(9));
            if (!reader.IsDBNull(10)) DataUltimaModifica = Convert.ToDateTime(reader.GetValue(10));
            if (!reader.IsDBNull(11)) FlagContainer = Convert.ToBoolean(reader.GetValue(11));
            if (!reader.IsDBNull(12)) FlagCancellazione = Convert.ToBoolean(reader.GetValue(12));
            if (!reader.IsDBNull(13)) ExtraInfo = Convert.ToString(reader.GetValue(13));
            if (!reader.IsDBNull(14)) Order = Convert.ToInt32(reader.GetValue(14));
        }

        #endregion

        #region Liste per tabella

        async public static Task<OutputParams_dt> GelTablesRows(int parent_id, InputParams_dt inputParams)
        {
            MpFotTableCollection mps = new MpFotTableCollection();
            OutputParams_dt outputParams = new OutputParams_dt();

            SqlConnection conn = null;
            SqlCommand cmd = null;
            string whereClause = "", filter = "", ordinamento = "";

            try
            {


                whereClause = " WHERE ";

                if (parent_id > 0)
                    whereClause += " (Id_Argomenti = " + parent_id.ToString() + ") AND (Flag_Cancellazione = 0) ";
                else if (parent_id == 0)
                    whereClause += " (Id_Argomenti IS NULL)  AND (Flag_Cancellazione = 0) ";
                else if (parent_id == -1)
                    whereClause += " (Flag_Cancellazione = 0) ";
                else if (parent_id == -2)
                    whereClause += " (Flag_Cancellazione = 1) ";

                filter = "";

                if (!string.IsNullOrWhiteSpace(inputParams.search.value))
                    filter += String.Format(" AND ( CONVERT(VARCHAR(10), mc.Id) = '{0}' OR mc.Titolo LIKE '%{0}%') ", inputParams.search.value);

                string[] columnNames = new string[]
                {
                    "mc.Id", "mc.Titolo","NomeTipo","DataPubblicazione","DataScadenza","DataUltimaModifica","Ordinamento"
                };

                ordinamento = string.Format(" ORDER BY {0} {1} ", columnNames[inputParams.order[0].column], inputParams.order[0].dir);
                if (columnNames[inputParams.order[0].column] != "mc.Id")
                    ordinamento += ", mc.Id DESC ";

                string pagination = string.Format(" OFFSET {0} ROWS FETCH NEXT {1} ROWS ONLY ", inputParams.start, inputParams.length);

                string cmdText = @" DECLARE @unfiltered INT, @filtered INT
                                    
                                    SELECT
	                                    @unfiltered = COUNT(*)
                                    FROM MB_contenuti mc
                                    INNER JOIN ANA_CONT_TYPE act
	                                    ON act.TYP_PK = mc.Tipo
                                    LEFT JOIN REL_contenuti_Argomenti rca
	                                    ON mc.Id = rca.Id_Contenuti" +
                                whereClause + ";" +

                                @"  SELECT
	                                    @filtered = COUNT(*)
                                    FROM MB_contenuti mc
                                    INNER JOIN ANA_CONT_TYPE act
	                                    ON act.TYP_PK = mc.Tipo
                                    LEFT JOIN REL_contenuti_Argomenti rca
	                                    ON mc.Id = rca.Id_Contenuti" +
                                whereClause + filter + ";" +

                                @"  SELECT
	                                    mc.Id
                                        ,mc.Titolo 
                                        ,act.TYP_NAME AS NomeTipo
                                        ,mc.Link AS Url 
                                        ,mc.Sottotitolo AS Url2
                                        ,act.TYP_Icon AS Icon 
                                        ,mc.Tipo 
                                        ,act.TYP_flag_specialTag AS SpecialTag 
                                        ,mc.DataPubblicazione
                                        ,mc.DataScadenza 
                                        ,mc.DataUltimaModifica 
                                        ,act.TYP_FlagContenitore 
                                        ,mc.Flag_Cancellazione
                                        ,mc.Autore AS ExtraInfo 
                                        ,mc.Contenuto_parent AS Ordinamento 
                                        ,@unfiltered 
                                        ,@filtered
                                    FROM MB_contenuti mc
                                    INNER JOIN ANA_CONT_TYPE act
	                                    ON act.TYP_PK = mc.Tipo  
                                    LEFT JOIN REL_contenuti_Argomenti rca
	                                    ON mc.Id = rca.Id_Contenuti" +
                                whereClause + filter + ordinamento + pagination;

                conn = new SqlConnection(MagicUtils.MagicConnectionString);
                await conn.OpenAsync();
                cmd = new SqlCommand(cmdText, conn);
                SqlDataReader reader = await cmd.ExecuteReaderAsync();
                while (reader.Read())
                {
                    mps.Add(new MpForTable(reader));
                    outputParams.recordsTotal = reader.GetInt32(15);
                    outputParams.recordsFiltered = reader.GetInt32(16);
                }
            }
            catch (Exception e)
            {
                MagicLog log = new MagicLog("VOTI", 0, LogAction.Read, e);
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
            outputParams.draw = inputParams.draw;
            outputParams.data = mps;

            return outputParams;
        }

        #endregion

    }
}