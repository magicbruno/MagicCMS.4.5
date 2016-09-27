using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace MagicCMS.Core
{
    public class MiniaturaInfo
    {
        public int Pk { get; set; }
        public string OriginalUrl { get; set; }
        public int Width { get; set; }
        public int Height { get; set; }

        public MiniaturaInfo(int pk, string ourl, int w, int h)
        {
            Pk = pk;
            OriginalUrl = ourl;
            Width = w;
            Height = h;
        }
    }
}