using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace MagicCMS.AccessToken
{
	/// <summary>
	/// Class AdmAccessToken. Define an access token necessary to access with proper credentials to Bing Translator.
	/// </summary>
    public class AdmAccessToken
    {
		/// <summary>
		/// Gets or sets the access token.
		/// </summary>
		/// <value>The access token.</value>
        public string access_token { get; set; }
		/// <summary>
		/// Gets or sets the type of the token.
		/// </summary>
		/// <value>The type of the token.</value>
        public string token_type { get; set; }
		/// <summary>
		/// Gets or sets the expires in.
		/// </summary>
		/// <value>The expires in.</value>
        public string expires_in { get; set; }
		/// <summary>
		/// Gets or sets the scope.
		/// </summary>
		/// <value>The scope.</value>
        public string scope { get; set; }
    }
}