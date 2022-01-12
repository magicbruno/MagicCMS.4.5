using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace MagicCMS.MagicTranslator
{
    public class PostTranslationResponse
    {
        public PT_response Title { get; set; }
        public PT_response TestoBreve { get; set; }
        public PT_response TestoLungo { get; set; }
        public PT_response Tags { get; set; }
        public bool Success { get; set; }
        public string Error { get; set; }
    }
}