using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace MagicCMS.reCAPTCHA
{
	/// <summary>
	/// Class CaptchaResponse. Wrapper class for Google Captcha response.
	/// </summary>
    public class CaptchaResponse
    {
		/// <summary>
		/// Gets  a value indicating whether this <see cref="CaptchaResponse"/> is success.
		/// </summary>
		/// <value><c>true</c> if success; otherwise, <c>false</c>.</value>
        public bool success { get; set; }
		/// <summary>
		/// Gets the error codes.
		/// </summary>
		/// <value>The error codes.</value>
        public List<string> errorCodes { get; set; }
    }
}