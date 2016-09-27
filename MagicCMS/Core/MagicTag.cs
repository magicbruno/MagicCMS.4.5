////////////////////////////////////////////////////////////////////////////////////////////////////
/// @file   MagicCMS\MagicTag.cs
///
/// @brief  Implements the magic tag class.
////////////////////////////////////////////////////////////////////////////////////////////////////

using System;
using System.Collections;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Web;

namespace MagicCMS.Core
{
    /// <summary>
    /// Magic tag. Classe che gestisce nome e primarikey di un contenitore generico.
    /// </summary>
    /// <remarks>
    /// Bruno, 15/01/2013.
    /// </remarks>
    public class MagicTag
    {
        #region Private Fields
        private MagicPost _MagicPost;
        #endregion
        #region Constructor
        /// <summary>
        /// Constructor.
        /// </summary>
        /// <param name="pk">La Primary Key (o ID) del post.</param>
        public MagicTag(int pk)
        {
            _MagicPost = new MagicPost(pk);
        }

        public MagicTag(SqlDataReader record)
        {
            _MagicPost = new MagicPost(record);
        }

        #endregion

        #region PublicProperties
        /// <summary>
        /// Gets or sets the pk.
        /// </summary>
        /// <value>
        /// The pk.
        /// </value>
        public int Pk
        {
            get
            {
                return _MagicPost.Pk;
            }
        }

        /// <summary>
        /// Gets or sets the titolo.
        /// </summary>
        /// <value>
        /// The titolo.
        /// </value>
        public string Titolo
        {
            get
            {
                return _MagicPost.Titolo;
            }
        }

        /// <summary>
        /// Gets or sets the nome tipo.
        /// </summary>
        /// <value>
        /// The nome tipo.
        /// </value>
        public string NomeTipo
        {
            get
            {
                return _MagicPost.NomeTipo;
            }
        }

        public string Url
        {
            get
            {
                return _MagicPost.Url;
            }
        }

        public string Url2
        {
            get
            {
                return _MagicPost.Url2;
            }
        }

        private MagicPostWhichUrl _whichUrl = MagicPostWhichUrl.UrlMain;
        public MagicPostWhichUrl? WhichImage
        {
            get
            {
                if (_whichUrl == MagicPostWhichUrl.UrlMain)
                {
                    if (!String.IsNullOrEmpty(Url))
                        return MagicPostWhichUrl.UrlMain;
                    else if (!String.IsNullOrEmpty(Url2))
                        return MagicPostWhichUrl.UrlSEcondary;
                    else
                        return null;
                }
                else
                {
                    if (!String.IsNullOrEmpty(Url2))
                        return MagicPostWhichUrl.UrlSEcondary;
                    else if (!String.IsNullOrEmpty(Url))
                        return MagicPostWhichUrl.UrlMain;
                    else return null;
                }
            }
        }

        public int Miniature_pk
        {
            get
            {
                int pk = 0;
                try
                {
                    if (WhichImage.HasValue)
                    {
                        if (WhichImage.Value == MagicPostWhichUrl.UrlMain)
                        {
                            Miniatura min = new Miniatura(Url, 52, 39);
                            pk = min.Pk;
                        }
                        else if (WhichImage.Value == MagicPostWhichUrl.UrlSEcondary)
                        {
                            Miniatura min = new Miniatura(Url2, 52, 39);
                            pk = min.Pk;
                        }

                    }

                }
                catch (Exception)
                {
                    pk = 0;

                }
                return pk;
            }
        }

        public string Icon
        {
            get
            {
                return _MagicPost.TypeInfo.Icon;
            }
        }

        /// <summary>
        /// Gets or sets the type.
        /// </summary>
        /// <value>
        /// The Type.
        /// </value>
        public int Tipo
        {
            get
            {
                return _MagicPost.Tipo;
            }
        }

        /// <summary>
        /// Gets or sets a value indicating whether [special tag].
        /// </summary>
        /// <value>
        ///   <c>true</c> if [special tag]; otherwise, <c>false</c>.
        /// </value>
        public Boolean SpecialTag
        {
            get
            {
                return _MagicPost.TypeInfo.FlagSpecialTag;
            }
        }

        /// <summary>
        /// Gets or sets the publishing date.
        /// </summary>
        /// <value>
        /// The publishing date.
        /// </value>
        public DateTime? DataPubblicazione
        {
            get
            {
                return _MagicPost.DataPubblicazione;
            }
        }

        /// <summary>
        /// Gets or sets the expiry date.
        /// </summary>
        /// <value>
        /// The expiry date.
        /// </value>
        public DateTime? DataScadenza
        {
            get
            {
                return _MagicPost.DataScadenza;
            }
        }

        /// <summary>
        /// Gets or sets the Last Modified Date.
        /// </summary>
        /// <value>
        /// Last Modified Date.
        /// </value>
        public DateTime DataUltimaModifica
        {
            get
            {
                return _MagicPost.DataUltimaModifica;
            }
        }


        /// <summary>
        /// Gets or sets a value indicating whether this <see cref="MagicTag"/> is container.
        /// </summary>
        /// <value>
        ///   <c>true</c> if container; otherwise, <c>false</c>.
        /// </value>
        public Boolean FlagContainer
        {
            get
            {
                return _MagicPost.Contenitore;
            }
        }

        /// <summary>
        /// Gets or sets a value indicating whether elementi is in the basket.
        /// </summary>
        /// <value>
        ///   <c>true</c> if [flag cancellazione]; otherwise, <c>false</c>.
        /// </value>
        public Boolean FlagCancellazione
        {
            get
            {
                return _MagicPost.FlagCancellazione;
            }
        }

        /// <summary>
        /// Gets or sets Extra Information on the Post.
        /// </summary>
        /// <value>
        /// The Extra Informations.
        /// </value>
        public String ExtraInfo
        {
            get
            {
                return _MagicPost.ExtraInfo;
            }
        }

        /// <summary>
        /// Gets or sets the order.
        /// </summary>
        /// <value>
        /// The order.
        /// </value>
        public int Order
        {
            get
            {
                return _MagicPost.Ordinamento;
            }
        }

        #endregion

        #region Public Methods
        public MagicPostCollection GetParents()
        {
            return _MagicPost.GetParents();
        }
        #endregion
    }
}