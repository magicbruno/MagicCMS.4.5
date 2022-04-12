using System;
using System.Collections.Generic;
using System.Linq;
using System.Text.RegularExpressions;
using System.Web;

namespace MagicCMS.Api_Models
{
    public class UploadBase64Model
    {
        public string DataUrl { get; set; }
        public string OriginalFullName { get; set; }
        public string NewName { get; set; }

        private bool? _overwrite = false;
        public bool? Overwrite
        {
            get
            {
                if (!_overwrite.HasValue)
                    return false;
                return _overwrite.Value;
            }
            set { _overwrite = value; }
        }

        public string ImageData
        {
            get
            {
                return Regex.Match(DataUrl, @"data:(?<mimetype>\w+/\w+?);(?<codec>.+),(?<data>.+)").Groups["data"].Value;
            }
        }

        public string MineType
        {
            get
            {
                return Regex.Match(DataUrl, @"data:(?<mimetype>\w+/\w+?);(?<codec>.+),(?<data>.+)").Groups["mimetype"].Value;
            }
        }

        public string Codec
        {
            get
            {
                return Regex.Match(DataUrl, @"data:(?<mimetype>\w+/\w+?);(?<codec>.+),(?<data>.+)").Groups["codec"].Value;
            }
        }
    }
}