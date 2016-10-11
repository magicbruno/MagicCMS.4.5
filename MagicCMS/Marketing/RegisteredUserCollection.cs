using MagicCMS.Core;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace MagicCMS.Marketing
{
    public class RegisteredUserCollection : System.Collections.CollectionBase
    {
        #region Costructor
		/// <summary>
		/// Initializes a new instance of the <see cref="RegisteredUserCollection"/> class.
		/// </summary>
		/// <param name="order">The order.</param>
		/// <param name="inclusive">The inclusive.</param>
		/// <param name="max">The maximum.</param>
		/// <param name="active">The active.</param>
        public RegisteredUserCollection(string order, Boolean inclusive, int max, MagicSearchActive active)
        {
            Init(order, inclusive, max, active);
        }

		/// <summary>
		/// Initializes a new instance of the <see cref="RegisteredUserCollection"/> class.
		/// </summary>
		/// <param name="active">The active.</param>
        public RegisteredUserCollection(MagicSearchActive active)
        {
            Init(MagicOrdinamento.Cognome, true, -1, active);
        }

		/// <summary>
		/// Initializes a new instance of the <see cref="RegisteredUserCollection"/> class.
		/// </summary>
		/// <param name="mpc">The MPC.</param>
        public RegisteredUserCollection(MagicPostCollection mpc)
        {
            Init(mpc);
        }


		/// <summary>
		/// Initializes a new instance of the <see cref="RegisteredUserCollection"/> class.
		/// </summary>
        public RegisteredUserCollection()
        {
            Init(MagicOrdinamento.Cognome, true, -1, MagicSearchActive.ActiveOnly);
        }

        private void Init(MagicPostCollection mpc)
        {
            foreach (MagicPost mp in mpc)
            {
                List.Add(new RegisteredUser(mp));
            }
        }

        private void Init(string order, Boolean inclusive, int max, MagicSearchActive active)
        {
            MagicPostCollection mpc = MagicPost.GetByType(new int[] { MagicPostTypeInfo.User },order, inclusive, max, false, active);
            Init(mpc);
        }
        #endregion

        #region Public Methods

		/// <summary>
		/// Adds the specified item.
		/// </summary>
		/// <param name="item">The item.</param>
		/// <returns>System.Int32.</returns>
        public int Add(RegisteredUser item)
        {
            return List.Add(item);
        }

		/// <summary>
		/// Inserts the specified index.
		/// </summary>
		/// <param name="index">The index.</param>
		/// <param name="item">The item.</param>
        public void Insert(int index, RegisteredUser item)
        {
            List.Insert(index, item);
        }

		/// <summary>
		/// Removes the specified item.
		/// </summary>
		/// <param name="item">The item.</param>
        public void Remove(RegisteredUser item)
        {
            List.Remove(item);
        }

		/// <summary>
		/// Determines whether [contains] [the specified item].
		/// </summary>
		/// <param name="item">The item.</param>
		/// <returns><c>true</c> if [contains] [the specified item]; otherwise, <c>false</c>.</returns>
        public bool Contains(RegisteredUser item)
        {
            return List.Contains(item);
        }

		/// <summary>
		/// Indexes the of.
		/// </summary>
		/// <param name="item">The item.</param>
		/// <returns>System.Int32.</returns>
        public int IndexOf(RegisteredUser item)
        {
            return List.IndexOf(item);
        }

		/// <summary>
		/// Copies to.
		/// </summary>
		/// <param name="array">The array.</param>
		/// <param name="index">The index.</param>
        public void CopyTo(RegisteredUser[] array, int index)
        {
            List.CopyTo(array, index);
        }

		/// <summary>
		/// Gets or sets the element at the specified index.
		/// </summary>
		/// <param name="index">The index.</param>
		/// <returns>RegisteredUser.</returns>
        public RegisteredUser this[int index]
        {
            get { return (RegisteredUser)List[index]; }
            set { List[index] = value; }
        }
        #endregion

        #region Static Mathods
        static bool CleanExpired(out string message)
        {
            message = "";
            bool result = true;
            RegisteredUserCollection ruc = new RegisteredUserCollection(MagicSearchActive.Both);
            try
            {
                foreach (RegisteredUser user in ruc)
                {
                    if (user.Expired)
                    {
                        if (!user.Delete(out message))
                        {
                            return false;
                        }
                    }
                }

            }
            catch (Exception e)
            {
                message = e.Message;
                result = false;
            }
            return result;
        }
        #endregion
    }
}