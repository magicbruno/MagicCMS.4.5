namespace MagicCMS.Core
{
	/// <summary>
	/// Order clauses for MagicPosts recotd sets
	/// </summary>
	public static class MagicOrdinamento
	{
		#region StaticProperties
		/// <summary>
		/// Order by title (A-Z order) 
		/// </summary>
		public const string AlphaAsc = "ALPHA";

		/// <summary>
		/// Order by title (Z-A order)
		/// </summary>
		public const string AlphaDesc = "ALPHA DESC";
		/// <summary>
		/// Order by <see cref="MagicCMS.Core.MagicPost.Order"/> field, ascending
		/// </summary>
		public const string Asc = "ASC";

		/// <exclude />
		public const string Cognome = "COGNOME";

		/// <exclude />
		public const string CognomeDesc = "COGNOME DESC";

		/// <summary>Order by date ascending (<see cref="MagicCMS.Core.MagicPost.DataPubblicazione"/>). </summary>
		public const string DateAsc = "DATA ASC";

		/// <summary>Order by date descending (<see cref="MagicCMS.Core.MagicPost.DataPubblicazione"/>).</summary>
		public const string DateDesc = "DATA DESC";

		/// <summary>
		/// Order by <see cref="MagicCMS.Core.MagicPost.Order"/> field, ascending
		/// </summary>
		public const string Desc = "DESC";

		/// <summary>
		/// Order by last modified date ascending (<see cref="MagicCMS.Core.MagicPost.DataUltimaModifica"/>). 
		/// </summary>       
		public const string ModDateAsc = "DATAMODIFICA ASC";
		/// <summary>
		/// Order by last modified date descending (<see cref="MagicCMS.Core.MagicPost.DataUltimaModifica"/>). 
		/// </summary>       
		public const string ModDateDesc = "DATAMODIFICA DESC";
		#endregion

		#region PublicMethods
		/// <exclude />
		public static string GetOrderClause(string order, string prefix)
		{
			string orderClause = "";
			int l = prefix.Length;
			if (l > 0 && prefix.Substring(prefix.Length - 1) != ".")
				prefix += ".";

			if (string.IsNullOrEmpty(order))
				return orderClause;

			switch (order.ToUpper().Trim())
			{
				case "ALPHA ASC":
				case "ALPHA":
					orderClause = " " + prefix + "Titolo ASC ";
					break;

				case "ALPHA DESC":
					orderClause = " " + prefix + "Titolo DESC ";
					break;

				case "COGNOME ASC":
				case "COGNOME":
					// orderClause = " RIGHT(RTRIM(" + prefix + "Titolo), CHARINDEX(' ', REVERSE(' ' + RTRIM(" + prefix + "Titolo))) - 1) ";
					orderClause = " COGNOME ";
					break;

				case "COGNOME DESC":
					//					orderClause = " RIGHT(" + prefix + "Titolo, CHARINDEX(' ', REVERSE(' ' + " + prefix + "Titolo)) - 1) DESC ";
					orderClause = " COGNOME DESC ";
					break;

				case "DESC":
					orderClause = " " + prefix + "Contenuto_parent DESC," + prefix + "DataPubblicazione DESC ";
					break;

				case "DATA DESC":
				case "DESC DATA":
					orderClause = " " + prefix + "DataPubblicazione DESC," + prefix + "Contenuto_parent ASC ";
					break;

				case "DATA ASC":
				case "ASC DATA":
					orderClause = " " + prefix + "DataPubblicazione ASC," + prefix + "Contenuto_parent ASC ";
					break;

				case "DATAMODIFICA DESC":
				case "DESC DATAMODIFICA":
					orderClause = " " + prefix + "DataUltimaModifica DESC ";
					break;

				case "DATAMODIFICA ASC":
				case "ASC DATAMODIFICA":
					orderClause = " " + prefix + "DataUltimaModifica ASC ";
					break;

				default:
					orderClause = " " + prefix + "Contenuto_parent, " + prefix + "Titolo";
					break;
			}

			return orderClause;
		}

		#endregion
	}
}