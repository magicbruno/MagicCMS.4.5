using MagicCMS.Core;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

namespace MagicCMS.DataTable
{
    /// <summary>
	/// Parameters passed to the server by DataTable
    /// </summary>
    public class InputParams_dt
    {
		/// <summary>
		/// The searchparam
		/// </summary>
        public const string SEARCHPARAM = "@searchpar";
        /// <summary>
		/// Gets or sets the draw. Parameter used internally by DataTable.
        /// </summary>
        /// <value>
        /// The draw.
        /// </value>
        public int draw { get; set; }

        /// <summary>
        /// Gets or sets the columns.
        /// </summary>
        /// <value>
		/// The columns. <see cref="MagiCMS.DataTable.Column_dt"/>  list containing information about columns.
        /// </value>
        public List<Column_dt> columns { get; set; }

		/// <summary>
		/// Gets or sets the order.
		/// </summary>
		/// <value>The order. <see cref="MagiCMS.DataTable.Order_dt"/>  list containing information about ordering by columns.</value>
        public List<Order_dt> order { get; set; }
        /// <summary>
        /// Gets or sets the start.
        /// </summary>
        /// <value>
        /// The start.  First row displayed.
        /// </value>
        public int start { get; set; }

        /// <summary>
        /// Gets or sets the length.
        /// </summary>
        /// <value>
        /// The length. Page length.
        /// </value>
        public int length { get; set; }
        /// <summary>
        /// Gets or sets the search.
        /// </summary>
        /// <value>
        /// The search. Filter.
        /// </value>
        public Search_dt search { get; set; }
        /// <summary>
        /// Gets or sets the name of the table.
        /// </summary>
        /// <value>
        /// The name of the table. Table on which query is applied.
        /// </value>
        public string TableName { get; set; }

        /// <summary>
        /// Gets or sets the name of the pk.
        /// </summary>
        /// <value>
        /// The name of the pk. Name of primary key field.
        /// </value>
        public string PkName { get; set; }

		/// <summary>
		/// Gets or sets the join tables.
		/// </summary>
		/// <value>The join tables.</value>
        public string JoinTables { get; set; }


        /// <summary>
        /// Initializes a new instance of the <see cref="InputParams_dt"/> class.
        /// </summary>
        /// <param name="draw_dt">The draw_dt. </param>
        /// <param name="tableName">Name of the table. </param>
		/// <param name="pkName">The pkName. Name of primary key field.</param> 
        public InputParams_dt(int draw_dt, string tableName, string pkName)
        {
            draw = draw_dt;
            columns = new List<Column_dt>();
            order = new List<Order_dt>();
            start = 0;
            length = 10;
            search = new Search_dt();
            TableName = tableName;
            PkName = pkName;
        }

		/// <summary>
		/// Initializes a new instance of the <see cref="InputParams_dt"/> class.
		/// </summary>
		/// <param name="draw_dt">The draw_dt. </param>
		/// <param name="tableName">Name of the table. </param>
		/// <param name="pkName">The pkName. Name of primary key field.</param> 
		/// <param name="joints">The joints.</param>
		public InputParams_dt(int draw_dt, string tableName, string pkName, string joints)
        {
            draw = draw_dt;
            columns = new List<Column_dt>();
            order = new List<Order_dt>();
            start = 0;
            length = 10;
            search = new Search_dt();
            TableName = tableName;
            PkName = pkName;
            JoinTables = joints;
        }


        /// <summary>
		/// Initializes a new instance of the <see cref="InputParams_dt"/> class. Deriving it from the parameters passed from jQuery.DataTable.
        /// </summary>
        /// <param name="context">The context.</param>
        /// <param name="tableName">Name of the table.</param>
        /// <param name="pkName">The pkName.</param>
        public InputParams_dt(HttpContext context, string tableName, string pkName)
        {
            Init(context, tableName, pkName, "");
        }

		/// <summary>
		/// Initializes a new instance of the <see cref="InputParams_dt"/> class. Deriving it from the parameters passed from jQuery.DataTable.
		/// </summary>
		/// <param name="context">The context.</param>
		/// <param name="tableName">Name of the table.</param>
		/// <param name="pkName">The pkName.</param>
		/// <param name="joins">Join clause.</param>
        public InputParams_dt(HttpContext context, string tableName, string pkName, string joins)
        {
            Init(context, tableName, pkName, joins);
        }



        private void Init(HttpContext context, string tableName, string pkname, string joins)
        {
            int d, st, len, orderColumn;

            columns = new List<Column_dt>();
            order = new List<Order_dt>();

            TableName = tableName;
            PkName = pkname;
            JoinTables = joins;

            int.TryParse(context.Request["draw"], out d);
            draw = d;

            int.TryParse(context.Request["start"], out st);
            start = st;

            int.TryParse(context.Request["length"], out len);
            length = len;

            search = new Search_dt();
            if (!String.IsNullOrEmpty(context.Request["search[value]"]))
                search.value = context.Request["search[value]"];

            if (!String.IsNullOrEmpty(context.Request["search[regex]"]))
                search.regex = Convert.ToBoolean(context.Request["search[regex]"]);

            Order_dt odt = new Order_dt();
            int.TryParse(context.Request["order[0][column]"], out orderColumn);
            odt.column = orderColumn;

            if (!String.IsNullOrEmpty(context.Request["order[0][dir]"]))
                odt.dir = context.Request["order[0][dir]"];

            order.Add(odt);

            string colonna = "columns[0]";
            int i = 0;
            while (!String.IsNullOrEmpty(context.Request[colonna + "[data]"]))
            {
                Column_dt col = new Column_dt(context.Request[colonna + "[data]"], context.Request[colonna + "[search][value]"]);
                if (!String.IsNullOrEmpty(context.Request[colonna + "[name]"]))
                    col.name = context.Request[colonna + "[name]"];
                if (!String.IsNullOrEmpty(context.Request[colonna + "[searchable]"]))
                    col.searchable = Convert.ToBoolean(context.Request[colonna + "[searchable]"]);

                if (!String.IsNullOrEmpty(context.Request[colonna + "[orderable]"]))
                    col.orderable = Convert.ToBoolean(context.Request[colonna + "[orderable]"]);

                if (!String.IsNullOrEmpty(context.Request[colonna + "[search][regex]"]))
                    col.search.regex = Convert.ToBoolean(context.Request[colonna + "[search][regex]"]);
                columns.Add(col);
                i++;
                colonna = "columns[" + i.ToString() + "]";
            }
        }

        /// <summary>
		/// Builds the query. It takes the original query and transforms it into a sub query 
		/// from which extracts the first length records from start record.
        /// </summary>
        /// <param name="originalSelectCmd">The original select command.</param>
        /// <param name="originalWhereClause">The original where clause.</param>
        /// <returns>SQL Command String</returns>
        /// <remarks>
		/// The original query must be a "SELECT TOP..." statement.
        /// </remarks>
        public string BuildQuery(string originalSelectCmd, string originalWhereClause)
        {
            string orderClause = "";
            if (columns.Count > 0)
            {
                orderClause = " ORDER BY " + columns[0].name + " ";
                if (columns.Count > order[0].column)
                {
                    if (columns[order[0].column].orderable)
                    {
                        orderClause = " ORDER BY " + columns[order[0].column].name + " " + order[0].dir.ToUpper() + " ";
                    }
                }

            }

            string filtro = "";
            if (!String.IsNullOrEmpty(originalWhereClause))
                filtro = " WHERE (" + originalWhereClause + ") ";

            if (!string.IsNullOrEmpty(search.value))
            {
                if (String.IsNullOrEmpty(filtro))
                    filtro += " WHERE ( ";
                else
                    filtro += " AND ( ";

                Boolean first = true;
                foreach (Column_dt col in columns)
                {
                    if (col.searchable && !String.IsNullOrEmpty(col.name))
                    {
                        if (!first)
                            filtro += " OR ";
                        filtro += col.name + " LIKE " + SEARCHPARAM + " ";
                        first = false;
                    }

                }
                filtro += ") ";
            }

            string cmd = " WITH query " +
                        " AS ( " +
                        " SELECT *, ROW_NUMBER() OVER(" + orderClause + ") AS line FROM " +
                        " 	( " +
                        originalSelectCmd + filtro +
                        "   ) dataset ) " +
                        "  " +
                        " SELECT TOP  " + length.ToString() + " " +
                        " 	* " +
                        " FROM query " +
                        " WHERE line > " + start.ToString() +
                        " ORDER BY line ";

            return cmd;
        }

        /// <summary>
        /// Builds the query.
        /// </summary>
        /// <param name="originalSelectCmd">The original select command.</param>
        /// <returns></returns>
        public string BuildQuery(string originalSelectCmd)
        {
            return BuildQuery(originalSelectCmd, "");
        }

        /// <summary>
		/// Returns the return parameter for Data Table no data for a simple search without sub query.
        /// </summary>
        /// <returns></returns>
        public OutputParams_dt GetOutpuSimpleQuery(string whereClause)
        {
            OutputParams_dt outPar = new OutputParams_dt();
            outPar.draw = draw;
            outPar.recordsFiltered = GetRecordsNum(true, whereClause);
            outPar.recordsTotal = GetRecordsNum(false, whereClause);
            return outPar;
        }

		/// <summary>
		/// Returns the return parameter for Data Table no data for a simple search without sub query.
		/// </summary>
		/// <returns>OutputParams_dt.</returns>
        public OutputParams_dt GetOutpuSimpleQuery()
        {
            OutputParams_dt outPar = new OutputParams_dt();
            outPar.draw = draw;
            outPar.recordsFiltered = GetRecordsNum(true);
            outPar.recordsTotal = GetRecordsNum(false);
            return outPar;
        }


        private int GetRecordsNum(bool filtered)
        {
            return GetRecordsNum(filtered, "");
        }

        private int GetRecordsNum(bool filtered, string whereClause)
        {
            int c = 0;
            SqlConnection conn = null;
            SqlCommand cmd = null;

            try
            {
                string cmdText = "SELECT COUNT(DISTINCT " + PkName + ") FROM  " + TableName + " " + JoinTables;
                var filtro = "";
                var first = true;
                if (filtered && !String.IsNullOrEmpty(search.value))
                {
                    filtro = " (";
                    foreach (Column_dt col in columns)
                    {
                        if (col.searchable && !String.IsNullOrEmpty(col.name))
                        {
                            if (!first)
                                filtro += " OR ";
                            filtro += col.name + " LIKE " + SEARCHPARAM + " ";
                            first = false;
                        }

                    }
                    filtro += ") ";

                }
                if (!String.IsNullOrEmpty(whereClause))
                    filtro += (String.IsNullOrEmpty(filtro) ? whereClause : " AND " + whereClause);
                if (!String.IsNullOrEmpty(filtro))
                    cmdText += " WHERE " + filtro;
                conn = new SqlConnection(MagicUtils.MagicConnectionString);
                conn.Open();
                cmd = new SqlCommand(cmdText, conn);
                if (!string.IsNullOrEmpty(filtro))
                {
                    cmd.Parameters.AddWithValue(SEARCHPARAM, "%" + search.value + "%");
                }
                c = Convert.ToInt32(cmd.ExecuteScalar());
            }
            catch (Exception e)
            {
                MagicLog log = new MagicLog(TableName, 0, LogAction.Read, e);
                log.Insert();
            }
            finally
            {
                if (conn != null)
                    conn.Dispose();
                if (cmd != null)
                    cmd.Dispose();
            }
            return c;
        }

    }

	/// <summary>
	/// Class Search_dt. Object used for instant search on jQuery.DataTable
	/// </summary>
    public class Search_dt
    {
		/// <summary>
		/// Gets or sets the value.
		/// </summary>
		/// <value>The value.</value>
        public string value { get; set; }
		/// <summary>
		/// Gets or sets the regex flag.
		/// </summary>
		/// <value>The regex flag.</value>
        public Boolean regex { get; set; }

		/// <summary>
		/// Initializes a new instance of the <see cref="Search_dt"/> class.
		/// </summary>
		/// <param name="v">The value.</param>
		/// <param name="r">The regex flag.</param>
        public Search_dt(string v, Boolean r)
        {
            value = v;
            regex = r;
        }
		/// <summary>
		/// Initializes a new instance of the <see cref="Search_dt"/> class.
		/// </summary>
		/// <param name="v">The value.</param>
        public Search_dt(string v)
        {
            value = v;
            regex = false;
        }
		/// <summary>
		/// Initializes a new empty instance of the <see cref="Search_dt"/> class.
		/// </summary>
        public Search_dt()
        {
            value = "";
            regex = false;
        }
    }
	/// <summary>
	/// Class Order_dt.
	/// </summary>
    public class Order_dt
    {
		/// <summary>
		/// Gets or sets the column.
		/// </summary>
		/// <value>The column on which perform ordering</value>
        public int column { get; set; }
		/// <summary>
		/// Gets or sets the direction.
		/// </summary>
		/// <value>The direction. (ascending or descending)</value>
        public string dir { get; set; }

		/// <summary>
		/// Initializes a new instance of the <see cref="Order_dt"/> class.
		/// </summary>
		/// <param name="c">The column.</param>
		/// <param name="d">The direction.</param>
        public Order_dt(int c, string d)
        {
            column = c;
            dir = d;
        }
		/// <summary>
		/// Initializes a new instance of the <see cref="Order_dt"/> class.
		/// </summary>
		/// <param name="c">The column.</param>
        public Order_dt(int c)
        {
            column = c;
            dir = "asc";
        }
		/// <summary>
		/// Initializes a new empty instance of the <see cref="Order_dt"/> class.
		/// </summary>
        public Order_dt()
        {
            column = 0;
            dir = "asc";
        }

    }
	/// <summary>
	/// Class Column_dt. jQuery.DataTable column definition.
	/// </summary>
    public class Column_dt
    {
        /// <summary>
        /// Gets or sets the data.
        /// </summary>
        /// <value>
		/// The data. Field name that the column displays.
        /// </value>
        public string data { get; set; }
        /// <summary>
        /// Gets or sets the name.
        /// </summary>
        /// <value>
        /// The name. Custom column name (optional)
        /// </value>
        public string name { get; set; }
        /// <summary>
        /// Gets or sets a value indicating whether this <see cref="Column_dt"/> is searchable. 
        /// </summary>
        /// <value>
        ///   <c>true</c> if searchable; otherwise, <c>false</c>.
        /// </value>
        public Boolean searchable { get; set; }
        /// <summary>
        /// Gets or sets a value indicating whether this <see cref="Column_dt"/> is orderable. 
        /// </summary>
        /// <value>
        ///   <c>true</c> if orderable; otherwise, <c>false</c>.
        /// </value>
        public Boolean orderable { get; set; }
		/// <summary>
		/// Gets or sets the search. Value searched.
		/// </summary>
		/// <value>The search.</value>
        public Search_dt search { get; set; }

		/// <summary>
		/// Initializes a new instance of the <see cref="Column_dt"/> class.
		/// </summary>
		/// <param name="d">The data.</param>
		/// <param name="n">The name.</param>
		/// <param name="s">The searchable.</param>
		/// <param name="o">The orderable.</param>
		/// <param name="searchStr">The search string.</param>
		/// <param name="regex">The regex.</param>
        public Column_dt(string d, string n, Boolean s, Boolean o, string searchStr, Boolean regex)
        {
            data = d;
            name = n;
            searchable = s;
            orderable = o;
            search = new Search_dt(searchStr, regex);
        }
		/// <summary>
		/// Initializes a new instance of the <see cref="Column_dt"/> class.
		/// </summary>
		/// <param name="d">The data.</param>
		/// <param name="searchStr">The search string.</param>
        public Column_dt(string d, string searchStr)
        {
            data = d;
            name = "";
            searchable = true;
            orderable = true;
            search = new Search_dt(searchStr, false);
        }
    }
}