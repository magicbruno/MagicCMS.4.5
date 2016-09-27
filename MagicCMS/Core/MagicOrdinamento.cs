namespace MagicCMS.Core
{
    /// <summary>
    /// Order clauses for MagicPosts recotd sets
    /// </summary>
    public static class MagicOrdinamento
    {
        #region StaticProperties
        public const string AlphaAsc = "ALPHA";

        public const string AlphaDesc = "ALPHA DESC";

        /// <summary>   The ascending.</summary>
        public const string Asc = "ASC";

        public const string Cognome = "COGNOME";

        public const string CognomeDesc = "COGNOME DESC";

        /// <summary>   The date ascending.</summary>
        public const string DateAsc = "DATA ASC";

        /// <summary>   Information describing the date.</summary>
        public const string DateDesc = "DATA DESC";

        /// <summary>   The description.</summary>
        public const string Desc = "DESC";

        public const string ModDateAsc = "DATAMODIFICA ASC";
        public const string ModDateDesc = "DATAMODIFICA DESC";
        #endregion

        #region PublicMethods
        /// <summary>
        /// Buldi the order clause.
        /// </summary>
        /// <param name="order">Order clause type</param>
        /// <param name="prefix">Database prefix</param>
        /// <returns></returns>
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