using Facebook;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace MagicCMS.Facebook
{
	/// <summary>
	/// Class FacebookPostCollection.
	/// </summary>
	/// <seealso cref="System.Collections.CollectionBase" />
    public class FacebookPostCollection: System.Collections.CollectionBase
    {
        #region Public Methods

		/// <summary>
		/// Initializes a new empty instance of the <see cref="FacebookPostCollection"/> class.
		/// </summary>
		public FacebookPostCollection()
		{

		}

		/// <summary>
		/// Initializes a new instance of the <see cref="FacebookPostCollection"/> class.
		/// </summary>
		/// <param name="accessKey">The Facebook Api access key.</param>
		/// <param name="facebookPage">The facebook page from which getting the posts. It MUST be a public Facebook Page (not a profile, neither a group).</param>
		/// <param name="max">The maximum number of returned posts (if max is 0 alla available posts are returned).</param>
		public FacebookPostCollection(string accessKey, string facebookPage, int max)
		{
			FacebookClient client = new FacebookClient(accessKey);
			if (max <= 0)
				max = int.MaxValue;

			JsonObject postList = client.Get(facebookPage + "/feed?fields=id,from,name,message,created_time,story,description,link,permalink_url,picture,object_id") as JsonObject;
			string strJson = postList.ToString();

			if (postList.ContainsKey("data"))
			{
				int maxPost = 0;
				JsonArray data = postList["data"] as JsonArray;

				for (int i = 0; i < data.Count && maxPost < max; i++)
				{
					FacebookPost fp = new FacebookPost(data[i] as JsonObject);
					List.Add(fp);
					maxPost++;

				}
			}
		}

		/// <summary>
		/// Adds the specified item.
		/// </summary>
		/// <param name="item">The item.</param>
		/// <returns>System.Int32.</returns>
        public int Add(FacebookPost item)
        {
            return List.Add(item);
        }

		/// <summary>
		/// Inserts the specified index.
		/// </summary>
		/// <param name="index">The index.</param>
		/// <param name="item">The item.</param>
        public void Insert(int index, FacebookPost item)
        {
            List.Insert(index, item);
        }

		/// <summary>
		/// Removes the specified item.
		/// </summary>
		/// <param name="item">The item.</param>
        public void Remove(FacebookPost item)
        {
            List.Remove(item);
        }

		/// <summary>
		/// Determines whether [contains] [the specified item].
		/// </summary>
		/// <param name="item">The item.</param>
		/// <returns><c>true</c> if [contains] [the specified item]; otherwise, <c>false</c>.</returns>
        public bool Contains(FacebookPost item)
        {
            return List.Contains(item);
        }

		/// <summary>
		/// Indexes the of.
		/// </summary>
		/// <param name="item">The item.</param>
		/// <returns>System.Int32.</returns>
        public int IndexOf(FacebookPost item)
        {
            return List.IndexOf(item);
        }

		/// <summary>
		/// Copies to.
		/// </summary>
		/// <param name="array">The array.</param>
		/// <param name="index">The index.</param>
        public void CopyTo(FacebookPost[] array, int index)
        {
            List.CopyTo(array, index);
        }

		/// <summary>
		/// Gets or sets the element at the specified index.
		/// </summary>
		/// <param name="index">The index.</param>
		/// <returns>FacebookPost.</returns>
        public FacebookPost this[int index]
        {
            get { return (FacebookPost)List[index]; }
            set { List[index] = value; }
        }

        #endregion
    }
}