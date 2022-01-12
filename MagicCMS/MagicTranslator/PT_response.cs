using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace MagicCMS.MagicTranslator
{
    public class PT_response
    {
        public int OriginalLength { get; set; }
        public int TranslatedLength { get; set; }
        public bool Success { get; set; }
        public string Error { get; set; }
        public string Translation { get; set; }
        public string Lang { get; set; }

        public PT_response ()
        {
            OriginalLength = 0;
            TranslatedLength = 0;
            Success = true;
            Error = "Ok";
            Translation = String.Empty;
            Lang = String.Empty;
        }
    }
}