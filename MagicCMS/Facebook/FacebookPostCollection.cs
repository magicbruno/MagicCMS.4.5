using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace MagicCMS.Facebook
{
    public class FacebookPostCollection: System.Collections.CollectionBase
    {
        #region Public Methods

        public int Add(FacebookPost item)
        {
            return List.Add(item);
        }

        public void Insert(int index, FacebookPost item)
        {
            List.Insert(index, item);
        }

        public void Remove(FacebookPost item)
        {
            List.Remove(item);
        }

        public bool Contains(FacebookPost item)
        {
            return List.Contains(item);
        }

        public int IndexOf(FacebookPost item)
        {
            return List.IndexOf(item);
        }

        public void CopyTo(FacebookPost[] array, int index)
        {
            List.CopyTo(array, index);
        }

        public FacebookPost this[int index]
        {
            get { return (FacebookPost)List[index]; }
            set { List[index] = value; }
        }

        #endregion
    }
}