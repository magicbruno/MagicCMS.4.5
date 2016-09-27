using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Facebook;

namespace MagicCMS.Facebook
{
	public class FacebookPost
	{
		// Originals
		public string Id { get; set; }
		public FbFrom From { get; set; }
		public string Name { get; set; }
		public string Message { get; set; }
		public DateTime Created_Time { get; set; }
		public string Permalink_Url { get; set; }
		public string Link { get; set; }
		public string Picture { get; set; }
		public string Object_id { get; set; }
		public FbImage AttachedImage { get; set; }

		// Calculated
		public string Attachment { 
			get 
			{
				if (AttachedImage != null)
					return String.IsNullOrEmpty(AttachedImage.Src) ? "https://graph.facebook.com/" + Object_id + "/picture" : AttachedImage.Src;
				return "https://graph.facebook.com/" + Object_id + "/picture";
			} 
		}

		public string AutorPicture
		{
			get
			{
				return "https://graph.facebook.com/" + From.Id + "/picture";
			}
		}

		public string AuhorLink
		{
			get
			{
				return "http://facebook.com/" + From.Id;
			}

		}

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

		public FacebookPost (JsonObject fbpost)
		{
			AttachedImage = new FbImage();
			foreach (string  key in fbpost.Keys)
			{
				switch (key)
				{
					case "id":
						Id = fbpost[key].ToString();
						break;
					case "from": 
						JsonObject from = fbpost[key] as JsonObject;
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
						Name = fbpost[key].ToString();
						break;
					case "message":
						Message = fbpost[key].ToString();
						break;
					case "created_time":
						Created_Time = DateTimeConvertor.FromIso8601FormattedDateTime(fbpost[key].ToString());
						break;
					case "link":
						Link = fbpost[key].ToString();
						break;
					case "permalink_url":
						Permalink_Url = fbpost[key].ToString();
						break;
					case "picture":
						Picture = fbpost[key].ToString();
						break;
					case "object_id":
						Object_id = fbpost[key].ToString();
						break;
					case "attachments":
						JsonObject attachments = fbpost[key] as JsonObject;
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