using System;
using System.Collections.Generic;
using System.Linq;
using System.Text.RegularExpressions;
using System.Web;

namespace MagicCMS.Core
{
    public class MenuIcon
    {
        static readonly string[] IMAGE_EXTENSIONS = { ".jpeg", ".jpg", ".png", ".gif", ".svg", ".bmp" };

		/// <summary>
		/// Gets or sets the icon value.
		/// </summary>
		/// <value>The icon value.</value>
        public string Value { get; set; }
        public MenuIconType Type 
        {
            get
            {
                if (String.IsNullOrEmpty(Value))
                    Value = ""; 
                return GetType(Value);
            }
        }

		/// <summary>
		/// Gets the type.
		/// </summary>
		/// <param name="value">The value.</param>
		/// <returns>MenuIconType.</returns>
        public static MenuIconType GetType(string value)
        {
           MenuIconType _type = MenuIconType.None;

		   Regex tagRegex = new Regex(@"fa-|glyphicon-|glyph-");
            if (tagRegex.IsMatch(value))
                _type = MenuIconType.ClassIcon;
            else 
            {
                string ext = "";
                int pos = value.LastIndexOf(".");
                if (pos > -1)
                    ext = value.Substring(pos);
                if (IMAGE_EXTENSIONS.Contains(ext))
                {
                    _type = MenuIconType.Image;
                }
            }
            return _type;

        }
    }

	/// <summary>
	/// Enum MenuIconType
	/// </summary>
    public enum MenuIconType
    {
        Image, ClassIcon, None
    }
}