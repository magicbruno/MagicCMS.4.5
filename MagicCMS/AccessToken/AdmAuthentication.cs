using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Net;
using System.IO;
using System.Runtime.Serialization.Json;
using System.Runtime.Serialization;
using System.Web;
using System.ServiceModel.Channels;
using System.ServiceModel;

namespace MagicCMS.AccessToken
{
	/// <summary>
	/// Class AdmAuthentication. Get an access token from Microsoft Datamarket sending proper credentials.
	/// </summary>
	public class AdmAuthentication
	{
		public static readonly string DatamarketAccessUri = "https://datamarket.accesscontrol.windows.net/v2/OAuth2-13";
		private string clientId;
		private string clientSecret;
		private string request;

		/// <summary>
		/// Initializes a new instance of the <see cref="AdmAuthentication"/> class.
		/// </summary>
		/// <param name="clientId">The client identifier.</param>
		/// <param name="clientSecret">The client secret.</param>
		public AdmAuthentication(string clientId, string clientSecret)
		{
			this.clientId = clientId;
			this.clientSecret = clientSecret;
			//If clientId or client secret has special characters, encode before sending request
			this.request = string.Format("grant_type=client_credentials&client_id={0}&client_secret={1}&scope=http://api.microsofttranslator.com", HttpUtility.UrlEncode(clientId), HttpUtility.UrlEncode(clientSecret));
		}

		/// <summary>
		/// Gets the access token.
		/// </summary>
		/// <returns>AdmAccessToken.</returns>
		public AdmAccessToken GetAccessToken()
		{
			return HttpPost(DatamarketAccessUri, this.request);
		}

		private AdmAccessToken HttpPost(string DatamarketAccessUri, string requestDetails)
		{
			//Prepare OAuth request 
			WebRequest webRequest = WebRequest.Create(DatamarketAccessUri);
			webRequest.ContentType = "application/x-www-form-urlencoded";
			webRequest.Method = "POST";
			byte[] bytes = Encoding.ASCII.GetBytes(requestDetails);
			webRequest.ContentLength = bytes.Length;
			using (Stream outputStream = webRequest.GetRequestStream())
			{
				outputStream.Write(bytes, 0, bytes.Length);
			}
			using (WebResponse webResponse = webRequest.GetResponse())
			{
				System.Runtime.Serialization.Json.DataContractJsonSerializer serializer = new System.Runtime.Serialization.Json.DataContractJsonSerializer(typeof(AdmAccessToken));
			  
				//Get deserialized object from JSON stream
				AdmAccessToken token = (AdmAccessToken)serializer.ReadObject(webResponse.GetResponseStream());
				return token;
			}
		}
	}
}