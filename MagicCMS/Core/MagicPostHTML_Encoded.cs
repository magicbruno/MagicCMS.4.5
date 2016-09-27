using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

namespace MagicCMS.Core
{
    /// <summary>
    /// Wrapper of MagicPost classe. Returns HTML encoded version of MagicPost string properties
    /// </summary>
    public class MagicPostHTML_Encoded
    {
        private MagicPost _mp;

        private string MyEscape(string str)
        {
            if (String.IsNullOrEmpty(str))
            {
                return String.Empty;
            }
            return str.Replace("\"", "&quot;");
        }

        #region Constructor
        public MagicPostHTML_Encoded()
        {
            _mp = new MagicPost();
        }

        public MagicPostHTML_Encoded(MagicPost mp)
        {
            _mp = mp;
        }

        /// <summary>
        /// Initializes a new empty instance of the <see cref="MagicPostTypeInfo" /> class of a choosen type.
        /// </summary>
        /// <param name="mpti">The type.</param>
        public MagicPostHTML_Encoded(MagicPostTypeInfo mpti)
        {
            _mp = new MagicPost(mpti);
        }

        /// <summary>
        /// Initializes a new instance of the <see cref="MagicPostTypeInfo"/> class. Fletching it from database.
        /// </summary>
        /// <param name="postId">The post id.</param>
        public MagicPostHTML_Encoded(int postId)
        {
            _mp = new MagicPost(postId);
        }


        /// <summary>
        /// Initializes a new instance of the <see cref="MagicPost"/> class. Fletching it from database.
        /// </summary>
        /// <param name="myRecord">SqlDataReader record.</param>
        internal MagicPostHTML_Encoded(SqlDataReader myRecord)
        {
            _mp = new MagicPost(myRecord);
        }

        #endregion

        #region PublicProperties
        public Boolean Active
        {
            get
            {
                return _mp.Active;
            }
        }

        public int Altezza
        {
            get
            {
                return _mp.Altezza;
            }
        }

        public Boolean Contenitore
        {
            get
            {
                return _mp.Contenitore;
            }
        }

        public string ContenutiPreferiti
        {
            get
            {
                return MyEscape(_mp.ContenutiPreferiti);
            }
        }

        public DateTime? DataPubblicazione
        {
            get
            {
                return _mp.DataPubblicazione;
            }
        }

        public Nullable<DateTime> DataScadenza
        {
            get
            {
                return _mp.DataScadenza;
            }
        }



        public DateTime DataUltimaModifica
        {
            get
            {
                return _mp.DataUltimaModifica;
            }
        }

        public string ExtraInfo
        {
            get
            {
                return MyEscape(_mp.ExtraInfo);
            }
        }

        public string ExtraInfo1
        {
            get
            {
                return MyEscape(_mp.ExtraInfo1);
            }
        }

        public string ExtraInfo2
        {
            get
            {
                return MyEscape(_mp.ExtraInfo2);
            }
        }

        public string ExtraInfo3
        {
            get
            {
                return MyEscape(_mp.ExtraInfo3);
            }
        }

        public string ExtraInfo4
        {
            get
            {
                return MyEscape(_mp.ExtraInfo4);
            }
        }

        public string ExtraInfo5
        {
            get
            {
                return MyEscape(_mp.ExtraInfo5);
            }
        }

        public string ExtraInfo6
        {
            get
            {
                return MyEscape(_mp.ExtraInfo6);
            }
        }

        public string ExtraInfo7
        {
            get
            {
                return MyEscape(_mp.ExtraInfo7);
            }
        }

        public string ExtraInfo8
        {
            get
            {
                return MyEscape(_mp.ExtraInfo8);
            }
        }

        public decimal ExtraInfoNumber1
        {
            get
            {
                return _mp.ExtraInfoNumber1;
            }
        }

        public decimal ExtraInfoNumber2
        {
            get
            {
                return _mp.ExtraInfoNumber2;
            }
        }

        public decimal ExtraInfoNumber3
        {
            get
            {
                return _mp.ExtraInfoNumber3;
            }
        }

        public decimal ExtraInfoNumber4
        {
            get
            {
                return _mp.ExtraInfoNumber4;
            }
        }

        public decimal ExtraInfoNumber5
        {
            get
            {
                return _mp.ExtraInfoNumber5;
            }
        }

        public decimal ExtraInfoNumber6
        {
            get
            {
                return _mp.ExtraInfoNumber6;
            }
        }

        public decimal ExtraInfoNumber7
        {
            get
            {
                return _mp.ExtraInfoNumber7;
            }
        }

        public decimal ExtraInfoNumber8
        {
            get
            {
                return _mp.ExtraInfoNumber8;
            }
        }


        public int Larghezza
        {
            get
            {
                return _mp.Larghezza;
            }
        }


        public string MetaInfo
        {
            get
            {
                return _mp.MetaInfo;
            }
        }

        public string NomeTipo
        {
            get
            {
                return _mp.NomeTipo;
            }
        }

        public int Ordinamento
        {
            get
            {
                return _mp.Ordinamento;
            }
        }

        public int Owner
        {
            get
            {
                return _mp.Owner;
            }
        }


        public List<int> Parents
        {
            get
            {
                return _mp.Parents;
            }
        }

        public int Pk
        {
            get
            {
                return _mp.Pk;
            }
        }

        public string Tags
        {
            get
            {
                return MyEscape(_mp.Tags);
            }
        }

        public string TestoBreve
        {
            get
            {
                return HttpUtility.HtmlEncode(_mp.TestoBreve);
            }
        }

        public string TestoLungo
        {
            get
            {
                return HttpUtility.HtmlEncode(_mp.TestoLungo);
            }
        }

        public int Tipo
        {
            get { return _mp.Tipo; }
        }

        public MagicPostTypeInfo TypeInfo
        {
            get
            {
                return _mp.TypeInfo;
            }
        }

        public string Titolo
        {
            get
            {
                return MyEscape(_mp.Titolo);
            }
        }


        public string Url
        {
            get
            {
                return MyEscape(_mp.Url);
            }
        }

        public string Url2
        {
            get
            {
                return MyEscape(_mp.Url2);
            }
        }

        #endregion
    }
}