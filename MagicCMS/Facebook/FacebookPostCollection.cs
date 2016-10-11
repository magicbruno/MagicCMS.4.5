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