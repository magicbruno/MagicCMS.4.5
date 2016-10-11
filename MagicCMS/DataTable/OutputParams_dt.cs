using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace MagicCMS.DataTable
{
    public class OutputParams_dt
    {
		/// <summary>
		/// Gets or sets the draw. Used internally.
		/// </summary>
		/// <value>The draw.</value>
        public int draw { get; set; }
		/// <summary>
		/// Gets the records total number.
		/// </summary>
		/// <value>The records total.</value>
        public int recordsTotal { get; set; }
		/// <summary>
		/// Gets the records remained after applying filter.
		/// </summary>
		/// <value>The records filtered.</value>
        public int recordsFiltered { get; set; }
		/// <summary>
		/// Gets or sets the data.
		/// </summary>
		/// <value>The data.</value>
        public object data { get; set; }
    }
}