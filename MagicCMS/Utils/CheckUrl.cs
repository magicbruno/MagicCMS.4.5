using System;
/// <summary>
/// 
/// </summary>
namespace System
{
	/// <summary>
	/// Class CheckUrl.
	/// </summary>
	public static class CheckUrl
	{

		/// <summary>
		/// Enum Protocol. Difines protocol types
		/// </summary>
		public enum Protocol
		{
			/// <summary>
			/// HTTP - An enum constant representing the HTTP option
			/// </summary>
			Http,
			/// <summary>
			/// HTTPS - An enum constant representing the HTTPS option
			/// </summary>
			Https,
			/// <summary>
			/// FTP - An enum constant representing the FTP option
			/// </summary>
			Ftp,
			/// <summary>
			/// SMTP - An enum constant representing the SMTP option
			/// </summary>
			Smtp,
			/// <summary>
			/// POP - An enum constant representing the POP option
			/// </summary>
			Pop,
			/// <summary>
			/// The mail - An enum constant representing the mail option
			/// </summary>
			Mail
		}

		/// <summary>
		/// If url doesn't have a protocol, add default protocol.
		/// </summary>
		/// <param name="url">The URL.</param>
		/// <param name="defaultProtocol">The default protocol.</param>
		/// <returns>System.String.</returns>
		public static string EnsureProtocolDef(string url, Protocol defaultProtocol)
		{
			if (hasProtocol(url))
			{
				return url;
			}
			return EnsureProtocol(url, defaultProtocol);
		}


		/// <summary>
		/// Check if the URL begins with the specified protocol otherwise, it adds.
		/// </summary>
		/// <param name="url">URL of the document.</param>
		/// <param name="protocol">The protocol.</param>
		/// <returns>System.String. Url</returns>
		public static string EnsureProtocol(string url, Protocol protocol)
		{
			string output = url;

			if (!string.IsNullOrEmpty(output) && !output.StartsWith(protocol + "://", StringComparison.OrdinalIgnoreCase))
				output = string.Format("{0}://{1}", protocol.ToString().ToLower(), url);

			return output;
		}

		/// <summary>
		/// Returns true if the url starts with the definition of a protocol
		/// </summary>
		/// <param name="url">URL of the document.</param>
		/// <returns>
		/// true if protocol, false if not.
		/// </returns>
		public static bool hasProtocol(string url)
		{
			string prot;
			foreach (string p in Enum.GetNames(typeof(Protocol)))
			{
				prot = p + "://";
				if (url.StartsWith(prot, StringComparison.OrdinalIgnoreCase))
				{
					return true;
				}
			}
			return false;
		}
	}
}