using System;
/// <summary>
/// 
/// </summary>
namespace System
{
	////////////////////////////////////////////////////////////////////////////////////////////////////
	/// <summary>
	/// CheckUrl: Verifica della correttezza del formato di un url.
	/// Verify url format
	/// </summary>
	/// <remarks>
	/// Bruno, 14/01/2013.
	/// </remarks>
	////////////////////////////////////////////////////////////////////////////////////////////////////
	public static class CheckUrl
	{

		////////////////////////////////////////////////////////////////////////////////////////////////////
		/// <summary>
		/// Definisce i tipi di protocollo autorizzati. Define legal protocols
		/// </summary>
		/// <remarks>
		/// Bruno, 14/01/2013.
		/// </remarks>
		////////////////////////////////////////////////////////////////////////////////////////////////////
		public enum Protocol
		{
			///< An enum constant representing the HTTP option
			Http,
			///< An enum constant representing the HTTPS option
			Https,
			///< An enum constant representing the FTP option
			Ftp,
			///< An enum constant representing the SMTP option
			Smtp,
			///< An enum constant representing the POP option
			Pop,
			///< An enum constant representing the mail option
			Mail
		}

		////////////////////////////////////////////////////////////////////////////////////////////////////
		/// <summary>
		/// Se l'url inizia con uno dei controlli autorizzati non viene modificata altrimenti viene
		/// aggiunto il protocollo di default.
		/// </summary>
		/// <param name="url">URL of the document.</param>
		/// <param name="defaultProtocol">The default protocol.</param>
		/// <returns>
		/// Modified url.
		/// </returns>
		/// <remarks>
		/// Bruno, 14/01/2013.
		/// </remarks>
		////////////////////////////////////////////////////////////////////////////////////////////////////
		public static string EnsureProtocolDef(string url, Protocol defaultProtocol)
		{
			if (hasProtocol(url))
			{
				return url;
			}
			return EnsureProtocol(url, defaultProtocol);
		}

		////////////////////////////////////////////////////////////////////////////////////////////////////
		/// <summary>
		/// Controlla se l'url inizia con il protocollo specificato in caso contrario lo aggiunge.
		/// </summary>
		/// <param name="url">URL of the document.</param>
		/// <param name="protocol">The protocol.</param>
		/// <returns>
		/// .
		/// </returns>
		/// <remarks>
		/// Bruno, 14/01/2013.
		/// </remarks>
		////////////////////////////////////////////////////////////////////////////////////////////////////
		public static string EnsureProtocol(string url, Protocol protocol)
		{
			string output = url;

			if (!string.IsNullOrEmpty(output) && !output.StartsWith(protocol + "://", StringComparison.OrdinalIgnoreCase))
				output = string.Format("{0}://{1}", protocol.ToString().ToLower(), url);

			return output;
		}

		////////////////////////////////////////////////////////////////////////////////////////////////////
		/// <summary>
		/// Ritorna vero se l'url inizia con la definizione di un protocollo
		/// </summary>
		/// <param name="url">URL of the document.</param>
		/// <returns>
		/// true if protocol, false if not.
		/// </returns>
		/// <remarks>
		/// Bruno, 14/01/2013.
		/// </remarks>
		////////////////////////////////////////////////////////////////////////////////////////////////////
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