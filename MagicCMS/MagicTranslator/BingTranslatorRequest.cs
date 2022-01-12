using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace MagicCMS.MagicTranslator
{
    public class BingTranslatorRequest : List<BT_Request>
    {
        public BingTranslatorRequest ()
        {

        }
        public BingTranslatorRequest(string Text)
        {
            Add(new BT_Request(Text));
        }

    }

    public class BT_Request
    {
        public String  Text { get; set; }

        public BT_Request(string text)
        {
            Text = text;
        }
    }
}