using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Security;
using System.Security.Cryptography.X509Certificates;
using System.Text;
using System.Web;
using System.Web.Script.Serialization;

namespace MagicCMS.reCAPTCHA
{
	/// <summary>
	/// Class GoogleReCaptcha. This class handles Google recaptcha2 check.
	/// </summary>
    public class GoogleReCaptcha
    {
		/// <summary>
		/// Gets or sets the secret key.
		/// </summary>
		/// <value>The secret key.</value>
        public string SecretKey { get; set; }
		/// <summary>
		/// Gets or sets the site key.
		/// </summary>
		/// <value>The site key.</value>
        public string SiteKey { get; set; }

		/// <summary>
		/// Initializes a new instance of the <see cref="GoogleReCaptcha"/> class.
		/// </summary>
		/// <param name="secretKey">The secret key.</param>
        public GoogleReCaptcha(string secretKey)
        {
            System.Net.ServicePointManager.ServerCertificateValidationCallback = CheckValidationResult;
            // this is what we are sending
            SecretKey = secretKey;
        }

		/// <summary>
		/// Validates the response.
		/// </summary>
		/// <param name="CaptchaResponse">The captcha response.</param>
		/// <returns>CaptchaResponse.</returns>
        public CaptchaResponse ValidateResponse(string CaptchaResponse)
        {
            string remoteIp = HttpContext.Current.Request.UserHostAddress;
            string post_data = "secret=" + SecretKey + "&response=" + CaptchaResponse + "&remoteip=" + remoteIp;
            string uri = "https://www.google.com/recaptcha/api/siteverify";
            CaptchaResponse capResponse = new reCAPTCHA.CaptchaResponse();

            // create a request
            HttpWebRequest request = (HttpWebRequest)
            WebRequest.Create(uri); 
            request.KeepAlive = false;
            request.ProtocolVersion = HttpVersion.Version10;
            request.Method = "POST";

            // turn our request string into a byte stream
            byte[] postBytes = Encoding.ASCII.GetBytes(post_data);

            // this is important - make sure you specify type this way
            request.ContentType = "application/x-www-form-urlencoded";
            request.ContentLength = postBytes.Length;
            Stream requestStream = request.GetRequestStream();

            // now send it
            requestStream.Write(postBytes, 0, postBytes.Length);
            requestStream.Close();

            // grab te response and print it out to the console along with the status code
            HttpWebResponse response = (HttpWebResponse)request.GetResponse();
            StreamReader sr = new StreamReader(response.GetResponseStream());
            string responseStr = sr.ReadToEnd();
            JavaScriptSerializer serializer = new JavaScriptSerializer();
            return serializer.Deserialize<CaptchaResponse>(responseStr.Replace("error-codes", "errorCodes"));

        }

        private bool CheckValidationResult(Object sender,
                    X509Certificate certificate,
                    X509Chain chain,
                    SslPolicyErrors sslPolicyErrors )
        {
            //Return True to force the certificate to be accepted.
            return true;
        }
    }
}