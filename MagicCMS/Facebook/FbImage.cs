using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace MagicCMS.Facebook
{
	/// <summary>
	/// Class FbImage.
	/// </summary>
	public class FbImage
	{
		/// <summary>
		/// Gets or sets the height.
		/// </summary>
		/// <value>The height.</value>
		public int Height { get; set; }
		/// <summary>
		/// Gets or sets the width.
		/// </summary>
		/// <value>The width.</value>
		public int Width { get; set; }
		/// <summary>
		/// Gets or sets the source.
		/// </summary>
		/// <value>The source.</value>
		public string Src { get; set; }
		/// <summary>
		/// Gets or sets the URL.
		/// </summary>
		/// <value>The URL.</value>
		public string Url { get; set; }
		/// <summary>
		/// Gets or sets the type.
		/// </summary>
		/// <value>The type.</value>
		public string Type { get; set; }
	}
}