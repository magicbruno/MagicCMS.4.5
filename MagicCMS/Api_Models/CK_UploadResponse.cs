using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace MagicCMS.Api_Models
{
    public class CK_UploadResponse
    {
        public int uploaded { get; set; }
        public string   fileName { get; set; }
        public string url { get; set; }

    }
}