using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace MagicCMS.reCAPTCHA
{
    public class CaptchaResponse
    {
        public bool success { get; set; }
        public List<string> errorCodes { get; set; }
    }
}