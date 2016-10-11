using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace MagicCMS.Core
{
	/// <summary>
	/// Class MiniaturaInfo. Extract basic informations by <see cref="MagicCMS.Core.Miniatura"/>
	/// </summary>
	/// <seealso cref="MagicCMS.Core.Miniatura"/> 
    public class MiniaturaInfo
    {
		/// <summary>
		/// Gets or sets the <see cref="MagicCMS.Core.Miniatura.Pk"/>.
		/// </summary>
		/// <value>The pk.</value>
        public int Pk { get; set; }
		/// <summary>
		/// Gets or sets the <see cref="MagicCMS.Core.Miniatura.OriginalUrl"/>
		/// </summary>
		/// <value>The original URL.</value>
        public string OriginalUrl { get; set; }
		/// <summary>
		/// Gets or sets the <see cref="MagicCMS.Core.Miniatura.Width"/>.
		/// </summary>
		/// <value>The width.</value>
        public int Width { get; set; }
		/// <summary>
		/// Gets or sets the <see cref="MagicCMS.Core.Miniatura.Height"/>.
		/// </summary>
		/// <value>The height.</value>
        public int Height { get; set; }

		/// <summary>
		/// Initializes a new instance of the <see cref="MiniaturaInfo"/>.
		/// </summary>
		/// <param name="pk">The pk.</param>
		/// <param name="ourl">The original url.</param>
		/// <param name="w">The width.</param>
		/// <param name="h">The height.</param>
        public MiniaturaInfo(int pk, string ourl, int w, int h)
        {
            Pk = pk;
            OriginalUrl = ourl;
            Width = w;
            Height = h;
        }
    }
}