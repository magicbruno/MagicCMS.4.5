using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace MagicCMS.Core 
{
    public class MagicKeywordCollection : CollectionBase
    {
        #region Costructor

        #endregion

        #region Public Properties
        /// <summary>
        /// Indexer to get or set items within this collection using array index syntax.
        /// </summary>
        /// <param name="index">Zero-based index of the entry to access.</param>
        /// <returns>
        /// The indexed item.
        /// </returns>
        public MagicKeyword this[int index]
        {
            get { return (MagicKeyword)List[index]; }
            set { List[index] = value; }
        }

        /// <summary>
        /// Adds item.
        /// </summary>
        /// <param name="item">The item to add.</param>
        /// <returns>
        /// The List
        /// </returns>
        public int Add(MagicKeyword item)
        {
            return List.Add(item);
        }

        /// <summary>
        /// Query if this object contains the given item.
        /// </summary>
        /// <param name="item">The item to add.</param>
        /// <returns>
        /// true if the object is in this collection, false if not.
        /// </returns>
        public bool Contains(MagicKeyword item)
        {
            return List.Contains(item);
        }

        /// <summary>
        /// Copies collection to Array.
        /// </summary>
        /// <param name="array">The array.</param>
        /// <param name="index">Zero-based index of the starting index.</param>
        public void CopyTo(MagicKeyword[] array, int index)
        {
            List.CopyTo(array, index);
        }

        /// <summary>
        /// Index of the given item.
        /// </summary>
        /// <param name="item">The item to add.</param>
        /// <returns>
        /// Th index or -1 if not found
        /// </returns>
        public int IndexOf(MagicKeyword item)
        {
            return List.IndexOf(item);
        }

        /// <summary>
        /// Inserts item.
        /// </summary>
        /// <param name="index">Zero-based index of the.</param>
        /// <param name="item">The item to add.</param>
        public void Insert(int index, MagicKeyword item)
        {
            List.Insert(index, item);
        }

        /// <summary>
        /// Removes the given item.
        /// </summary>
        /// <param name="item">The item to remove.</param>
        public void Remove(MagicKeyword item)
        {
            List.Remove(item);
        }
        #endregion
    }
}