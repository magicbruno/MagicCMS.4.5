using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Security.Cryptography.X509Certificates;
using System.Web;

namespace MagicCMS.reCAPTCHA
{
    public class NoCheckPolicy : ICertificatePolicy
    {
        public bool CheckValidationResult(ServicePoint srvPoint,
          X509Certificate certificate, WebRequest request,
          int certificateProblem)
        {
            //Return True to force the certificate to be accepted.
            return true;
        }
    }
}