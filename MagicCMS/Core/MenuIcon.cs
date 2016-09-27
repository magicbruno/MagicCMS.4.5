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

        public static MenuIconType GetType(string value)
        {
           MenuIconType _type = MenuIconType.None;

           Regex tagRegex = new Regex(@"fa-|glyphicon-");
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

    public enum MenuIconType
    {
        Image, ClassIcon, None
    }
}