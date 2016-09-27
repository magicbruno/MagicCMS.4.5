using MagicCMS.Core;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace MagicCMS.Marketing
{
    /// <summary>
    /// Wrapper class of MagicPost to handle user registered with no access like for 
    /// conventions or newsletters
    /// </summary>
    public class RegisteredUser
    {
        #region Private fields

        /// <summary>
        /// Underlaying MagicPost object
        /// </summary>
        private MagicPost _mp;
        
        #endregion

        #region costructor

        /// <summary>
        /// Initializes a new empty instance of the <see cref="RegisteredUser"/> class.
        /// User is not active. A confirmation procedure is needed.
        /// </summary>
        public RegisteredUser()
        {
            Init(false);
        }

        /// <summary>
        /// Initializes a new instance of the <see cref="RegisteredUser"/> class with 
        /// defining if a confirmation procedure is needed.
        /// </summary>
        /// <param name="active">if set to <c>true</c> non confirmation is needed.</param>
        public RegisteredUser(bool active)
        {
            Init(active);
        }

        /// <summary>
        /// Initializes a new instance of the <see cref="RegisteredUser"/> class 
        /// retriving it frm database
        /// </summary>
        /// <param name="pk">The pk.</param>
        public RegisteredUser(int pk)
        {
            _mp = new MagicPost(pk);
        }

        /// <summary>
        /// Initializes a new instance of the <see cref="RegisteredUser"/> class using 
        /// underlaying MagicPost object.
        /// </summary>
        /// <param name="mp">The magicpost object.</param>
        public RegisteredUser(MagicPost mp)
        {
            _mp = mp;
        }

        private void Init(bool active)
        {
            _mp = new MagicPost(new MagicPostTypeInfo(MagicPostTypeInfo.User));
            Secret = MagicUtils.CreateRandomPassword(32);
            Active = active;
        }

        #endregion

        #region public properties
        /// <summary>
        /// Gets or sets the primary key.
        /// </summary>
        /// <value>
        /// The primary key.
        /// </value>
        public int Pk
        {
            get
            {
                return _mp.Pk;
            }
            set
            {
                _mp.Pk = value;
            }
        }

        /// <summary>
        /// Gets or sets a value indicating whether this <see cref="RegisteredUser"/> ha been activated (confirmed) by the user.
        /// </summary>
        /// <value>
        ///   <c>true</c> if active; otherwise, <c>false</c>.
        /// </value>
        public bool Active
        {
            get
            {
                return _mp.Active;
            }
            set
            {
                _mp.Active = value;
            }
        }

        /// <summary>
        /// Gets or sets the address.
        /// </summary>
        /// <value>
        /// The address.
        /// </value>
        public string Address
        {
            get { return _mp.ExtraInfo6; }
            set { _mp.ExtraInfo6 = value; }
        }

        /// <summary>
        /// Gets or sets the city.
        /// </summary>
        /// <value>
        /// The city.
        /// </value>
        public string City
        {
            get
            {
                return _mp.ExtraInfo;
            }
            set
            {
                _mp.ExtraInfo = value;
            }
        }
        /// <summary>
        /// Gets a value indicating whether this <see cref="RegisteredUser"/> is deleted.
        /// </summary>
        /// <value>
        ///   <c>true</c> if deleted; otherwise, <c>false</c>.
        /// </value>
        public bool Deleted
        {
            get
            {
                return _mp.FlagCancellazione;
            }
            private set
            {
                _mp.FlagCancellazione = value;
            }
        }

        /// <summary>
        /// Gets or sets the email.
        /// </summary>
        /// <value>
        /// The email.
        /// </value>
        public string Email
        {
            get
            {
                return _mp.Titolo;
            }
            set
            {
                _mp.Titolo = value;
            }
        }

        /// <summary>
        /// Gets a value indicating whether this <see cref="RegisteredUser"/> is expired 
        /// (not confirmed by user in 24 hours).
        /// </summary>
        /// <value>
        ///   <c>true</c> if expired; otherwise, <c>false</c>.
        /// </value>
        public bool Expired
        {
            get
            {
                bool expired = (DateTime.Now > InsertDate.AddHours(30) );
                if (Active)
                    return false;
                else
                    return  expired || Deleted;
            }
        }
        /// <summary>
        /// Gets or sets the full name.
        /// </summary>
        /// <value>
        /// The full name.
        /// </value>
        public string FullName
        {
            get
            {
                return _mp.ExtraInfo1;
            }
            set
            {
                _mp.ExtraInfo1 = value;
            }
        }

        /// <summary>
        /// Gets the first name trying to compose name segments.
        /// </summary>
        /// <value>
        /// The first name.
        /// </value>
        public string FirstName
        {
            get
            {
                string fn =  "";
                int i = 0;
                bool firstTime = true;
                do
                {
                    if (!firstTime)
                    {
                        fn += " ";
                    }
                    firstTime = false;
                    fn += NameSegments[i];
                    i++;
                } while (i < NameSegments.Count -1);
                return fn;
            }
        }

        /// <summary>
        /// Gets the insert date.
        /// </summary>
        /// <value>
        /// The insert date.
        /// </value>
        public DateTime InsertDate
        {
            get
            {
                if (_mp.DataPubblicazione.HasValue)
                    return _mp.DataPubblicazione.Value;
                else
                    return _mp.DataUltimaModifica;
            }
            private set
            {
                _mp.DataPubblicazione = value;
            }
        }
        /// <summary>
        /// Gets or sets last modify date.
        /// </summary>
        /// <value>
        /// The last modify date.
        /// </value>
        public DateTime LastModified
        {
            get
            {
                return _mp.DataUltimaModifica;
            }
            set
            {
                _mp.DataUltimaModifica = value;
            }
        }

        /// <summary>
        /// Gets the last name trying to extract fron name segments.
        /// </summary>
        /// <value>
        /// The last name.
        /// </value>
        string LastName
        {
            get
            {
                return NameSegments.Last();
            }
        }

        /// <summary>
        /// Gets the name as segments (list of strings).
        /// </summary>
        /// <value>
        /// The name as segments.
        /// </value>
        public List<string> NameSegments
        {
            get
            {
                return FullName.Split(' ').ToList<string>();
            }
        }


        /// <summary>
        /// Gets or sets the parents.
        /// </summary>
        /// <value>
        /// The parents.
        /// </value>
        public List<int> Parents
        {
            get
            {
                return _mp.Parents;
            }
            set
            {
                _mp.Parents = value;
            }
        }

        /// <summary>
        /// Gets or sets the phone number.
        /// </summary>
        /// <value>
        /// The phone number.
        /// </value>
        public string Phone
        {
            get { return _mp.ExtraInfo4; }
            set { _mp.ExtraInfo4 = value; }
        }

        /// <summary>
        /// Gets or sets the seminar.
        /// </summary>
        /// <value>
        /// The seminar.
        /// </value>
        public string Seminar
        {
            get
            {
                return _mp.ExtraInfo2;
            }
            set
            {
                _mp.ExtraInfo2 = value;
            }

        }

        /// <summary>
        /// Gets the secret key used to check identity of user on confirmation.
        /// </summary>
        /// <value>
        /// The secret key.
        /// </value>
        public string Secret
        {
            get
            {
                return _mp.ExtraInfo8;
            }
            private set
            {
                _mp.ExtraInfo8 = value;
            }
        }

        /// <summary>
        /// Gets the tipo.
        /// </summary>
        /// <value>
        /// The tipo. MUSTO BE ALWAYS 61
        /// </value>
        public int Tipo
        {
            get
            {
                return _mp.Tipo;
            }
        }

        /// <summary>
        /// Gets or sets the undelaying MagicPost object properties. 
        /// </summary>
        /// <value>
        /// The <see cref="System.Object"/>.
        /// </value>
        /// <param name="propertyName">Name of the property.</param>
        /// <returns></returns>
        public object this[string propertyName]
        {
            get
            {
                if (_mp.GetType().GetProperty(propertyName) == null)
                    return null;
                return _mp.GetType().GetProperty(propertyName).GetValue(this, null);
            }
            set
            {
                if (_mp.GetType().GetProperty(propertyName) != null)
                    _mp.GetType().GetProperty(propertyName).SetValue(this, value, null);
            }
        }

        #endregion

        #region Public Methods

        /// <summary>
        /// Inserts this instance in the database.
        /// </summary>
        /// <returns>Primary key of inserted record</returns>
        public int Insert()
        {
            // Aggiorno data inserimento
            InsertDate = DateTime.Now;
            return _mp.Insert();
        }

        /// <summary>
        /// Updates this instance underlaying record.
        /// </summary>
        /// <returns>True if success</returns>
        public bool Update()
        {
            return (_mp.Update() != 0);
        }

        /// <summary>
        /// Deletes the specified instance underlyaing recod message.
        /// </summary>
        /// <param name="message">Returned error message.</param>
        /// <returns>True if success</returns>
        public bool Delete(out string message)
        {
            return _mp.Delete(out message);
        }

        /// <summary>
        /// Tries to activate (confirm) user registration.
        /// </summary>
        /// <param name="SegretKey">The segret key.</param>
        /// <returns>RegisteredUserStatus (Activated = success)</returns>
        public RegisteredUserStatus TryActivate(string SegretKey)
        {
            if (Expired)
            {
                return RegisteredUserStatus.Expired;
            }
            else if (Active)
            {
                return RegisteredUserStatus.AlreadyActivated;
            }
            else if (Secret != SegretKey)
            {
                return RegisteredUserStatus.WrongKey;
            }
            else
            {
                Active = true;
                if (!Update())
                {
                    return RegisteredUserStatus.SaveError;
                }
                return RegisteredUserStatus.Activated;
            }
        }
        #endregion

        #region Static Methods
        public static RegisteredUserStatus UserExists(string email)
        {
            RegisteredUserStatus result = RegisteredUserStatus.NotExists;
            WhereClauseCollection query = new WhereClauseCollection();

            // Email clause
            WhereClause titleClause = new WhereClause();
            titleClause.FieldName = "vmca.Titolo";
            titleClause.LogicalOperator = WhereClause.AND;
            titleClause.Operator = WhereClause.EQUAL;
            titleClause.Value = new ClauseValue(email, ClauseValueType.String);
            query.Add(titleClause);

            //Tipo clause
            WhereClause tipoClause = new WhereClause();
            tipoClause.FieldName = "vmca.Tipo";
            titleClause.LogicalOperator = WhereClause.AND;
            titleClause.Operator = WhereClause.EQUAL;
            titleClause.Value = new ClauseValue(MagicPostTypeInfo.User, ClauseValueType.Number);
            query.Add(titleClause);

            WhereClause activeClause = new WhereClause()
            {
                LogicalOperator = "AND",
                FieldName = "vmca.Flag_Attivo",
                Operator = "=",
                Value = new ClauseValue(1, ClauseValueType.Number)
            };
            query.Add(activeClause);

            MagicPostCollection mpc = new MagicPostCollection(query, MagicOrdinamento.Cognome, -1, true);
            if (mpc.Count > 0) {
                result = RegisteredUserStatus.Activated;
            }
            else
            {
                query[2].Value = new ClauseValue(0, ClauseValueType.Number);

                WhereClause expiryClause = new WhereClause()
                {
                    LogicalOperator= WhereClause.AND,
                    FieldName = "DATEDIFF(hh,vmca.DataPubblicazione,GETDATE())",
                    Operator = WhereClause.LESS_OR_EQUAL,
                    Value = new ClauseValue(30,ClauseValueType.Number)
                };
                query.Add(expiryClause);
                mpc = new MagicPostCollection(query, MagicOrdinamento.Cognome, -1, true);
                if (mpc.Count > 0)
                {
                    result = RegisteredUserStatus.NotYetActivated;
                }
            }

            return result;
        }
        #endregion
    }
}