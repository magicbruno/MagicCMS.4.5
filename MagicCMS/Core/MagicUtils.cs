////////////////////////////////////////////////////////////////////////////////////////////////////
/// @file   MagicCMS\MagicUtils.cs
///
/// @brief  Implements the magic utilities class.
////////////////////////////////////////////////////////////////////////////////////////////////////

using System;
using System.Collections.Generic;
using System.Globalization;
using System.IO;
using System.Text;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.Configuration;
using System.Web.UI;
using System.Web.UI.HtmlControls;

namespace MagicCMS.Core
{
	/// <summary>
	/// Class MagicUtils.
	/// </summary>
    public static class MagicUtils
    {
        /// <summary>
        /// Gets the allowed file types from Web.config.
        /// </summary>
        /// <value>
        /// The allowed file types extensions array.
        /// </value>
        public static string[] MagicAllowedFiletypes
        {
            get
            {
                return MagicCMSConfiguration.GetConfig().AllowedFileTypes.ToLower().Split(new Char[] { ',' });
            }
        }

        /// <summary>
        /// Gets the connection string from Web.config.
        /// </summary>
        /// <value>
        /// The magic connection string.
        /// </value>
        public static string MagicConnectionString
        {
            get
            {
                string nomeConnessione = MagicCMSConfiguration.GetConfig().ConnectionName;
                return WebConfigurationManager.ConnectionStrings[nomeConnessione].ToString();
            }
        }

        /// <summary>
        /// Create an Anchor Element
        /// </summary>
        /// <param name="cssClass">Class of element</param>
        /// <param name="href">Href of element</param>
        /// <param name="innerHTML">Inner html or text of element</param>
        /// <returns></returns>
        public static HtmlAnchor AnchorElement(string cssClass, string href, string innerHTML)
        {
            HtmlAnchor el = new HtmlAnchor();
            el.Attributes["class"] = cssClass;
            el.Attributes["href"] = href;
            el.InnerHtml = innerHTML;
            return el;
        }

        /// <summary>
        /// Caps and trunk a string.
        /// </summary>
        /// <param name="str">The string.</param>
        /// <param name="maxLength">The maxLength.</param>
        /// <param name="onlyAllUpper">if set to <c>true</c> [only all upper].</param>
        /// <returns></returns>
        public static string capAndTrunc(string str, int maxLength, Boolean onlyAllUpper)
        {
            if (str != str.ToUpper() && onlyAllUpper)
                return StringHtmlExtensions.TruncateWords(str, maxLength, "...");
            str = str.ToLower();
            str = Char.ToUpper(str[0]).ToString() + str.Substring(1);
            return StringHtmlExtensions.TruncateWords(str, maxLength, "...");
        }

		/// <summary>
		/// Lighten color.
		/// </summary>
		/// <param name="inputColor">Input color.</param>
		/// <returns>System.String. New color</returns>
        public static string ColorLighten(string inputColor)
        {
            System.Drawing.Color c = System.Drawing.ColorTranslator.FromHtml(inputColor);
            c = System.Windows.Forms.ControlPaint.Light(c, 0.5F);
            return System.Drawing.ColorTranslator.ToHtml(c);
        }

		/// <summary>
		/// Creates a random password.
		/// </summary>
		/// <param name="passwordLength">Length of the password.</param>
		/// <returns>System.String. Created password</returns>
        public static string CreateRandomPassword(int passwordLength)
        {
            string allowedChars = "abcdefghijkmnopqrstuvwxyzABCDEFGHJKLMNOPQRSTUVWXYZ0123456789";
            char[] chars = new char[passwordLength];
            Random rd = new Random();

            for (int i = 0; i < passwordLength; i++)
            {
                chars[i] = allowedChars[rd.Next(0, allowedChars.Length)];
            }

            return new string(chars);
        }

        /// <summary>
        /// Creates an unique file name.
        /// </summary>
        /// <param name="path">The path.</param>
        /// <param name="extension">The extension.</param>
        /// <returns>Corresponding url</returns>
        public static string CreateUniqueFileName(string path, string extension)
        {
            string fName = CreateRandomPassword(12);
            string url = path + fName + extension;
            while (File.Exists(HttpContext.Current.Server.MapPath(url)))
            {
                fName = MagicUtils.CreateRandomPassword(12);
                url = path + fName + extension;
            }
            return fName + extension;
        }

		/// <summary>
		/// Files size pretty formatted to string.
		/// </summary>
		/// <param name="fi">File <see cref="System.IO.FileInfo" />.</param>
		/// <returns>System.String. The size</returns>
        public static string FileSizeToStr(FileInfo fi)
        {
            string theSize = "";
            if (fi.Exists)
            {
                string misura = "byte";
                double fSize = fi.Length;
                if (fSize > 1024)
                {
                    fSize = Math.Round(fSize / 1024, 0);
                    misura = "Kb";
                }
                if (fSize > 1024)
                {
                    fSize = Math.Round(fSize / 1024, 2);
                    misura = "Mb";
                }
                if (fSize > 1024)
                {
                    fSize = Math.Round(fSize / 1024, 2);
                    misura = "Gb";
                }
                theSize = fSize.ToString(new System.Globalization.CultureInfo("it-IT")) + " " + misura;
            }
            return theSize;
        }

		/// <summary>
		/// Create an HTML element.
		/// </summary>
		/// <param name="tagName">Name of the tag.</param>
		/// <param name="cssClass">The CSS class.</param>
		/// <param name="innerHTML">The inner HTML.</param>
		/// <param name="id">The id.</param>
		/// <returns>HtmlGenericControl.</returns>
        public static HtmlGenericControl HTMLElement(string tagName, string cssClass, string innerHTML, string id)
        {
            HtmlGenericControl el = new HtmlGenericControl(tagName);
            if (!String.IsNullOrEmpty(cssClass))
                el.Attributes["class"] = cssClass;
            el.InnerHtml = innerHTML;
            if (!String.IsNullOrEmpty(id))
            {
                el.Attributes["id"] = id;
            }
            return el;
        }

		/// <summary>
		/// Create an HTML element.
		/// </summary>
		/// <param name="tagName">Name of the tag.</param>
		/// <param name="cssClass">The CSS class.</param>
		/// <param name="innerHTML">The inner HTML.</param>
		/// <returns>HtmlGenericControl.</returns>
		public static HtmlGenericControl HTMLElement(string tagName, string cssClass, string innerHTML)
        {
            return HTMLElement(tagName, cssClass, innerHTML, "");
        }

		/// <summary>
		/// Create an HTML element.
		/// </summary>
		/// <param name="tagName">Name of the tag.</param>
		/// <param name="cssClass">The CSS class.</param>
		/// <returns>HtmlGenericControl.</returns>
		public static HtmlGenericControl HTMLElement(string tagName, string cssClass)
        {
            return HTMLElement(tagName, cssClass, "", "");
        }

        /// <summary>
        /// Determines whether is mobile browser.
        /// </summary>
        /// <returns>True if mobile browser</returns>
        public static Boolean isMobileBrowser()
        {
            string u = HttpContext.Current.Request.ServerVariables["HTTP_USER_AGENT"];
            Regex b = new Regex(@"android.+mobile|avantgo|bada\/|blackberry|blazer|compal|elaine|fennec|hiptop|iemobile|ip(hone|od)|iris|kindle|lge |maemo|meego.+mobile|midp|mmp|netfront|opera m(ob|in)i|palm( os)?|phone|p(ixi|re)\/|plucker|pocket|psp|series(4|6)0|symbian|treo|up\.(browser|link)|vodafone|wap|windows (ce|phone)|xda|xiino", RegexOptions.IgnoreCase | RegexOptions.Multiline);
            Regex v = new Regex(@"1207|6310|6590|3gso|4thp|50[1-6]i|770s|802s|a wa|abac|ac(er|oo|s\-)|ai(ko|rn)|al(av|ca|co)|amoi|an(ex|ny|yw)|aptu|ar(ch|go)|as(te|us)|attw|au(di|\-m|r |s )|avan|be(ck|ll|nq)|bi(lb|rd)|bl(ac|az)|br(e|v)w|bumb|bw\-(n|u)|c55\/|capi|ccwa|cdm\-|cell|chtm|cldc|cmd\-|co(mp|nd)|craw|da(it|ll|ng)|dbte|dc\-s|devi|dica|dmob|do(c|p)o|ds(12|\-d)|el(49|ai)|em(l2|ul)|er(ic|k0)|esl8|ez([4-7]0|os|wa|ze)|fetc|fly(\-|_)|g1 u|g560|gene|gf\-5|g\-mo|go(\.w|od)|gr(ad|un)|haie|hcit|hd\-(m|p|t)|hei\-|hi(pt|ta)|hp( i|ip)|hs\-c|ht(c(\-| |_|a|g|p|s|t)|tp)|hu(aw|tc)|i\-(20|go|ma)|i230|iac( |\-|\/)|ibro|idea|ig01|ikom|im1k|inno|ipaq|iris|ja(t|v)a|jbro|jemu|jigs|kddi|keji|kgt( |\/)|klon|kpt |kwc\-|kyo(c|k)|le(no|xi)|lg( g|\/(k|l|u)|50|54|\-[a-w])|libw|lynx|m1\-w|m3ga|m50\/|ma(te|ui|xo)|mc(01|21|ca)|m\-cr|me(di|rc|ri)|mi(o8|oa|ts)|mmef|mo(01|02|bi|de|do|t(\-| |o|v)|zz)|mt(50|p1|v )|mwbp|mywa|n10[0-2]|n20[2-3]|n30(0|2)|n50(0|2|5)|n7(0(0|1)|10)|ne((c|m)\-|on|tf|wf|wg|wt)|nok(6|i)|nzph|o2im|op(ti|wv)|oran|owg1|p800|pan(a|d|t)|pdxg|pg(13|\-([1-8]|c))|phil|pire|pl(ay|uc)|pn\-2|po(ck|rt|se)|prox|psio|pt\-g|qa\-a|qc(07|12|21|32|60|\-[2-7]|i\-)|qtek|r380|r600|raks|rim9|ro(ve|zo)|s55\/|sa(ge|ma|mm|ms|ny|va)|sc(01|h\-|oo|p\-)|sdk\/|se(c(\-|0|1)|47|mc|nd|ri)|sgh\-|shar|sie(\-|m)|sk\-0|sl(45|id)|sm(al|ar|b3|it|t5)|so(ft|ny)|sp(01|h\-|v\-|v )|sy(01|mb)|t2(18|50)|t6(00|10|18)|ta(gt|lk)|tcl\-|tdg\-|tel(i|m)|tim\-|t\-mo|to(pl|sh)|ts(70|m\-|m3|m5)|tx\-9|up(\.b|g1|si)|utst|v400|v750|veri|vi(rg|te)|vk(40|5[0-3]|\-v)|vm40|voda|vulc|vx(52|53|60|61|70|80|81|83|85|98)|w3c(\-| )|webc|whit|wi(g |nc|nw)|wmlb|wonu|x700|yas\-|your|zeto|zte\-", RegexOptions.IgnoreCase | RegexOptions.Multiline);
            return (b.IsMatch(u) || v.IsMatch(u.Substring(0, 4)));
        }

        /// <summary>
        /// Loads a script avoiding to load already loaded scripts.
        /// </summary>
        /// <param name="cs">The cs.</param>
        /// <param name="type">The type.</param>
        /// <param name="scripUrl">The scrip URL.</param>
        public static void LoadScript(ClientScriptManager cs, Type type, string scripUrl)
        {
            if (!cs.IsClientScriptBlockRegistered(type, scripUrl))
            {
                StringBuilder scriptTag = new StringBuilder();
                scriptTag.Append("<script type=\"text/javascript\" src=\"");
                scriptTag.Append(scripUrl);
                scriptTag.Append("\"></script>");
                cs.RegisterClientScriptBlock(type, scripUrl, scriptTag.ToString(), false);
            }
        }

		/// <summary>
		/// Convert null string to empty string.
		/// </summary>
		/// <param name="str">The string.</param>
		/// <returns>System.String.</returns>
        public static string nullToStr(string str)
        {
            return (String.IsNullOrEmpty(str)) ? "" : str;
        }

		/// <summary>
		/// Convert null string to string.
		/// </summary>
		/// <param name="str">The string.</param>
		/// <param name="def">Default value.</param>
		/// <returns>System.String.</returns>
        public static string nullToStr(string str, string def)
        {
            return (String.IsNullOrEmpty(str)) ? def : str;
        }

		/// <summary>
		/// Convert a Web Control or HTML Control to string
		/// </summary>
		/// <param name="control">The control to render</param>
		/// <returns>Rendered string</returns>
        public static string RenderControlToString(Control control)
        {
            string renderedControl = null;
            if (control != null)
            {
                using (StringWriter tempStringWriter = new StringWriter())
                {
                    using (HtmlTextWriter tempHtmlTextWriter = new HtmlTextWriter(tempStringWriter))
                    {
                        control.RenderControl(tempHtmlTextWriter);
                        renderedControl = tempStringWriter.ToString();
                        tempHtmlTextWriter.Close();
                    }
                    tempStringWriter.Close();
                }
            }
            return renderedControl;
        }

		/// <summary>
		/// Strings to json.
		/// </summary>
		/// <param name="o">Any type.</param>
		/// <returns>System.String.</returns>
        public static string strToJSON(object o)
        {
            if (o == null)
            {
                return "\"\"";
            }
            else
            {
                return strToJSON(o.ToString());
            }
        }

        /// <summary>
        /// Strings to json.
        /// </summary>
        /// <param name="s">The string.</param>
        /// <returns></returns>
        public static string strToJSON(string s)
        {
            StringBuilder sb = new StringBuilder();
            //s = s.Replace("\\", "\\\\");
            s = s.Replace("\"", "\\\"");
            s = s.Replace("\0", "\\u0000");
            s = s.Replace("/", "\\/");
            s = s.Replace("\b", "\\b");
            s = s.Replace("\f", "\\f");
            s = s.Replace("\n", "\\n");
            s = s.Replace("\r", "\\r");
            s = s.Replace("\t", "\\t");
            foreach (char c in s)
            {
                int i = (int)c;
                if (i > 127)
                {
                    sb.Append("\\u" + i.ToString("X4"));
                }
                else
                {
                    sb.Append(c);
                }
            }
            return "\"" + sb.ToString() + "\"";
        }

        // Parse ISO8601 Date

        static readonly string[] formats = { 
            // Basic formats
            "yyyyMMddTHHmmsszzz",
            "yyyyMMddTHHmmsszz",
            "yyyyMMddTHHmmssZ",
            // Extended formats
            "yyyy-MM-ddTHH:mm:sszzz",
            "yyyy-MM-ddTHH:mm:sszz",
            "yyyy-MM-ddTHH:mm:ssZ",
            @"yyyy-MM-ddTHH:mm:ss.fff\Z",
            "yyyy-MM-ddTHH:mm:ss.fffZ",
            // All of the above with reduced accuracy
            "yyyyMMddTHHmmzzz",
            "yyyyMMddTHHmmzz",
            "yyyyMMddTHHmmZ",
            "yyyy-MM-ddTHH:mmzzz",
            "yyyy-MM-ddTHH:mmzz",
            "yyyy-MM-ddTHH:mmZ",
            // Accuracy reduced to hours
            "yyyyMMddTHHzzz",
            "yyyyMMddTHHzz",
            "yyyyMMddTHHZ",
            "yyyy-MM-ddTHHzzz",
            "yyyy-MM-ddTHHzz",
            "yyyy-MM-ddTHHZ",
            "yyyy-MM-ddTHH:mm:ss.fffffff",
            "yyyy-MM-ddTHH:mm:ss"
        };

        public static DateTime ParseISO8601String(string str)
        {
            if (str.Length > 19)
                str = str.Substring(0, 19);
            return DateTime.ParseExact(str, formats,
                CultureInfo.InvariantCulture, DateTimeStyles.None);
        }

		/// <summary>
		/// Gets the image list from folder.
		/// </summary>
		/// <param name="url">The URL. (Image path or folder path)</param>
		/// <param name="isPath">if set to <c>true</c> url is a path otherwise is an image. Default is false</param>
		/// <returns>List of images urls.</returns>
        public static List<string> getImageList(string url, Boolean isPath)
        {
            List<string> theList = new List<string>();
            List<string> extensions = new List<string>() { ".gif", ".jpeg", ".jpg", ".png" };
            string galpath;
            if (isPath)
                url = url + "/";

            galpath = url.Substring(0, url.LastIndexOf("/")) + "/";
            string[] filenames = Directory.GetFiles(HttpContext.Current.Server.MapPath(galpath));

            for (int i = 0; i < filenames.Length; i++)
            {
                FileInfo fi = new FileInfo(filenames[i]);
                string ext = fi.Extension.ToLower();
                if (extensions.Contains(ext))
                {
                    theList.Add(galpath + fi.Name);
                }
            }
            return theList;
        }

		/// <summary>
		/// Gets the image list from folder.
		/// </summary>
		/// <param name="url">The URL. (Image path or folder path)</param>
		/// <returns>List of images urls.</returns>
		public static List<string> getImageList(string url)
        {
            return getImageList(url, false);
        }
    }
}