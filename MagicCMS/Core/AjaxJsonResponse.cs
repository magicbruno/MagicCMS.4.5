
namespace MagicCMS.Core
{
	/// <summary>
	/// Class AjaxJsonResponse. Object return by MagicCMS Ajax requests.
	/// </summary>
	public class AjaxJsonResponse
	{
		/// <summary>
		/// A value indicating whether action performed by the Ajax request was completed successfully.
		/// </summary>
		/// <value><c>true</c> if success; otherwise, <c>false</c>.</value>
		public bool success { get; set; }
		/// <summary>
		/// The unique identifier (Pk) of involved object if one.
		/// </summary>
		/// <value>The pk.</value>
		public int pk { get; set; }
		/// <summary>
		/// Gets or sets the exitcode. Numeric code of exception. 0 if success.
		/// </summary>
		/// <value>The exitcode.</value>
		public int exitcode { get; set; }
		/// <summary>
		/// Returned message. On error it contains error message.
		/// </summary>
		/// <value>The MSG.</value>
		public string msg { get; set; }
		/// <summary>
		/// Data (of any type) returned by the Ajax request.
		/// </summary>
		/// <value>The data.</value>
		public object data { get; set; }
	}
}