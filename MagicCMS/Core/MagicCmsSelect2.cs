using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace MagicCMS.Core
{
	/// <summary>
	/// Class MagicCmsSelect2. Object used to populate select2  lists.
	/// </summary>
	/// <seealso cref="https://select2.github.io/"/>
    public class MagicCmsSelect2
    {
		/// <summary>
		/// Gets or sets the identifier.
		/// </summary>
		/// <value>The identifier.</value>
        public object id { get; set; }
		/// <summary>
		/// Gets or sets the text.
		/// </summary>
		/// <value>The text.</value>
        public string text { get; set; }
		/// <summary>
		/// Gets or sets the pk.
		/// </summary>
		/// <value>The pk.</value>
        public int Pk { get; set; }
    }
}