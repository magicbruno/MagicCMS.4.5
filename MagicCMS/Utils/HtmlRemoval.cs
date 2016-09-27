using System.Text.RegularExpressions;

/// <summary>
/// Convert HTML to plain text
/// </summary>
/// <remarks>
/// Bruno, 14/01/2013.
/// </remarks>
namespace System
{

    public static class HtmlRemoval
    {

        /// <summary>
        /// The _HTML regex compiled version
        /// </summary>
        static Regex _htmlRegex = new Regex("<.*?>", RegexOptions.Compiled);


        /// <summary>
        /// Strips tags using character array.
        /// </summary>
        /// <param name="source">The HTML source.</param>
        /// <returns>Corresponding plain text.</returns>
        public static string StripTagsCharArray(string source)
        {
            char[] array = new char[source.Length];
            int arrayIndex = 0;
            bool inside = false;

            for (int i = 0; i < source.Length; i++)
            {
                char let = source[i];
                if (let == '<')
                {
                    inside = true;
                    continue;
                }
                if (let == '>')
                {
                    inside = false;
                    continue;
                }
                if (!inside)
                {
                    array[arrayIndex] = let;
                    arrayIndex++;
                }
            }
            return new string(array, 0, arrayIndex);
        }


        /// <summary>
        /// Strips the tags using regex.
        /// </summary>
        /// <param name="source">The HTML source.</param>
        /// <returns>Corresponding plain text</returns>
        public static string StripTagsRegex(string source)
        {
            return Regex.Replace(source, "<.*?>", string.Empty);
        }


        /// <summary>
        /// Strips the tags using regex compiled.
        /// </summary>
        /// <param name="source">The HTML source.</param>
        /// <returns>Corresponding plain text</returns>
        public static string StripTagsRegexCompiled(string source)
        {
            return _htmlRegex.Replace(source, string.Empty);
        }

    }
}