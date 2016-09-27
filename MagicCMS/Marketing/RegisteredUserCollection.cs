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
        public RegisteredUserCollection(string order, Boolean inclusive, int max, MagicSearchActive active)
        {
            Init(order, inclusive, max, active);
        }

        public RegisteredUserCollection(MagicSearchActive active)
        {
            Init(MagicOrdinamento.Cognome, true, -1, active);
        }

        public RegisteredUserCollection(MagicPostCollection mpc)
        {
            Init(mpc);
        }


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

        public int Add(RegisteredUser item)
        {
            return List.Add(item);
        }

        public void Insert(int index, RegisteredUser item)
        {
            List.Insert(index, item);
        }

        public void Remove(RegisteredUser item)
        {
            List.Remove(item);
        }

        public bool Contains(RegisteredUser item)
        {
            return List.Contains(item);
        }

        public int IndexOf(RegisteredUser item)
        {
            return List.IndexOf(item);
        }

        public void CopyTo(RegisteredUser[] array, int index)
        {
            List.CopyTo(array, index);
        }

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