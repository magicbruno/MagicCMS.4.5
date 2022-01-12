using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace MagicCMS.MagicTranslator
{
    public class BingTranslatorResponse : List<BingTranslations>
    {
    }

    public class BingTranslations 
    {
        public List<BT_Translation> translations { get; set; }
    }

    public class BT_Translation
    {
        public string text { get; set; }
        public string to { get; set; }
    }
}