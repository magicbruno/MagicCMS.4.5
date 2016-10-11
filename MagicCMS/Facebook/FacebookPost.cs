using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Facebook;

namespace MagicCMS.Facebook
{
	/// <summary>
	/// Class FacebookPost. Manage a Facebook Post received by a Facebook API Ajax query using Facebook.dll
	/// </summary>
	public class FacebookPost
	{
		// Originals
		/// <summary>
		/// Gets the post identifier.
		/// </summary>
		/// <value>The identifier.</value>
		public string Id { get; set; }
		/// <summary>
		/// Gets author pf the post from as <see cref="MagicCMS.Facebook.FbFrom"/>.
		/// </summary>
		/// <value>From.</value>
		public FbFrom From { get; set; }
		/// <summary>
		/// Gets the name of the post.
		/// </summary>
		/// <value>The name.</value>
		public string Name { get; set; }
		/// <summary>
		/// Gets the message text.
		/// </summary>
		/// <value>The message.</value>
		public string Message { get; set; }
		/// <summary>
		/// Gets the creation time.
		/// </summary>
		/// <value>The creation time.</value>
		public DateTime Created_Time { get; set; }
		/// <summary>
		/// Gets or sets the permalink URL of the post.
		/// </summary>
		/// <value>The permalink URL.</value>
		public string Permalink_Url { get; set; }
		/// <summary>
		/// Gets the link associated with the post.
		/// </summary>
		/// <value>The link.</value>
		public string Link { get; set; }
		/// <summary>
		/// Gets the picture associated with the post.
		/// </summary>
		/// <value>The picture.</value>
		public string Picture { get; set; }
		/// <summary>
		/// Gets or sets the object identifier.
		/// </summary>
		/// <value>The object identifier.</value>
		public string Object_id { get; set; }
		/// <summary>
		/// Gets the attached image.
		/// </summary>
		/// <value>The attached image.</value>
		public FbImage AttachedImage { get; set; }

		// Calculated
		/// <summary>
		/// Gets the attachment.
		/// </summary>
		/// <value>The attachment.</value>
		public string Attachment { 
			get 
			{
				if (AttachedImage != null)
					return String.IsNullOrEmpty(AttachedImage.Src) ? "https://graph.facebook.com/" + Object_id + "/picture" : AttachedImage.Src;
				return "https://graph.facebook.com/" + Object_id + "/picture";
			} 
		}

		/// <exclude />
		public string AutorPicture
		{
			get
			{
				return "https://graph.facebook.com/" + From.Id + "/picture";
			}
		}

		/// <summary>
		/// Gets the author picture.
		/// </summary>
		/// <value>The author picture.</value>
		public string AuthorPicture
		{
			get
			{
				return "https://graph.facebook.com/" + From.Id + "/picture";
			}
		}

		/// <summary>
		/// Gets the author link.
		/// </summary>
		/// <value>The author link.</value>
		public string AuthorLink
		{
			get
			{
				return "http://facebook.com/" + From.Id;
			}

		}
		/// <exclude />
		public string AuhorLink
		{
			get
			{
				return "http://facebook.com/" + From.Id;
			}

		}

		/// <summary>
		/// Gets the time elapsed form in a pretty format. 
		/// </summary>
		/// <value>The time ago.</value>
		public string Time_ago
		{
			get
			{
			 string result = string.Empty;
			 TimeSpan  timeSpan = DateTime.Now.Subtract(Created_Time);
 
			 if (timeSpan <= TimeSpan.FromSeconds(60))
			 {
				 result = timeSpan.Seconds > 0 ? string.Format("{0} secondi fa", timeSpan.Seconds) : "un secondo fa";
			 }
			 else if (timeSpan <= TimeSpan.FromMinutes(60))
			 {
				 result = timeSpan.Minutes > 1 ? 
					 String.Format("{0} minuti fa", timeSpan.Minutes) :
					 "circa un minuto fa";
			 }
			 else if (timeSpan <= TimeSpan.FromHours(24))
			 {
				 result = timeSpan.Hours > 1 ? 
					 String.Format("circa {0} ore fa", timeSpan.Hours) : 
					 "circa un'ora fa";
			 }
			 else if (timeSpan <= TimeSpan.FromDays(30))
			 {
				 result = timeSpan.Days > 1 ? 
					 String.Format("{0} giorni fa", timeSpan.Days) : 
					 "ieri";
			 }
			 else if (timeSpan <= TimeSpan.FromDays(365))
			 {
				 result = (timeSpan.Days / 30) > 1 ? 
					 String.Format("{0} mesi fa", timeSpan.Days / 30) : 
					 "circa un mese fa";
			 }
			 else
			 {
				 result = (timeSpan.Days / 365) > 1 ? 
					 String.Format("{0} anni fa", timeSpan.Days / 365) : 
					 "circa un anno fa";
			 }
 
			 return result;            }
		}

		/// <summary>
		/// Initializes a new instance of the <see cref="FacebookPost"/> class.
		/// </summary>
		/// <param name="fbPost">The fbPost in Facebook.JsonObject form/>.</param>
		public FacebookPost (JsonObject fbPost)
		{
			AttachedImage = new FbImage();
			foreach (string  key in fbPost.Keys)
			{
				switch (key)
				{
					case "id":
						Id = fbPost[key].ToString();
						break;
					case "from": 
						JsonObject from = fbPost[key] as JsonObject;
						string name = "";
						string id = "";
						if (from.ContainsKey("name"))
							name = from["name"].ToString();
						if (from.ContainsKey("id"))
							id = from["id"].ToString();
						From = new FbFrom()
						{
							Name = name,
							Id = id
						};
						break;
					case "name":
						Name = fbPost[key].ToString();
						break;
					case "message":
						Message = fbPost[key].ToString();
						break;
					case "created_time":
						Created_Time = DateTimeConvertor.FromIso8601FormattedDateTime(fbPost[key].ToString());
						break;
					case "link":
						Link = fbPost[key].ToString();
						break;
					case "permalink_url":
						Permalink_Url = fbPost[key].ToString();
						break;
					case "picture":
						Picture = fbPost[key].ToString();
						break;
					case "object_id":
						Object_id = fbPost[key].ToString();
						break;
					case "attachments":
						JsonObject attachments = fbPost[key] as JsonObject;
						if (attachments.ContainsKey("data"))
						{
							JsonArray data = attachments["data"] as JsonArray;
							if (data.Count > 0)
							{
								JsonObject attach = data[0] as JsonObject;
								if (attach.ContainsKey("url"))
									AttachedImage.Url = attach["url"].ToString();
								if (attach.ContainsKey("type"))
									AttachedImage.Url = attach["type"].ToString();
								if (attach.ContainsKey("media"))
								{
									JsonObject media = attach["media"] as JsonObject;
									if (media.ContainsKey("image"))
									{
										JsonObject image = media["image"] as JsonObject;
										if (image.ContainsKey("src"))
											AttachedImage.Src = image["src"].ToString();
										int h, w;
										if (image.ContainsKey("height"))
										{
											int.TryParse(image["height"].ToString(), out h);
											AttachedImage.Height = h;
										}
										if (image.ContainsKey("width"))
										{
											int.TryParse(image["width"].ToString(), out w);
											AttachedImage.Width = w;
										}
									}
								}
								
							}
						}
						break;
					default:
						break;
				}
			}
		}
	}
}