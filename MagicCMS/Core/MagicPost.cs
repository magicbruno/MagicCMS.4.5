using MagicCMS.Routing;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Reflection;
using System.Web;
using System.Web.UI.HtmlControls;

namespace MagicCMS.Core
{
    /// <summary>
    /// Wrapper class for MagicCMS main object
    /// </summary>
    public class MagicPost
    {

        #region PrivateFields

        //private object _data_scadenza = null;

        Nullable<DateTime> _dataPubblicazione = null;

        //private string _nometipo = "";

        private List<int> _parents;

        private int _tipo;

        #endregion

        #region Constructor
        /// <summary>
        /// Initializes a new empty instance of the <see cref="MagicPost"/> class.
        /// </summary>
        public MagicPost()
        {
            Pk = 0;
            Active = true;
            ExtraInfo1 = "";
            ExtraInfo2 = "";
            ExtraInfo3 = "";
            ExtraInfo4 = "";
            Active = false;
            Translations = new MagicTranslationCollection();
        }

        /// <summary>
        /// Initializes a new empty instance of the <see cref="MagicPost"/> class of a choosen type.
        /// </summary>
        /// <param name="mpti">The type.</param>
        public MagicPost(MagicPostTypeInfo mpti)
        {
            Pk = 0;
            Tipo = mpti.Pk;
            DataPubblicazione = DateTime.Today;
            Active = true;
            Altezza = 0;
            if (TypeInfo.FlagScadenza)
                DataScadenza = DateTime.Today.Add(new TimeSpan(90, 0, 0, 0));
            ExtraInfo = "";
            ExtraInfo1 = "";
            ExtraInfo2 = "";
            ExtraInfo3 = "";
            ExtraInfo4 = "";
            ExtraInfo5 = "";
            ExtraInfo6 = "";
            ExtraInfo7 = "";
            ExtraInfo8 = "";
            ExtraInfoNumber1 = 0;
            ExtraInfoNumber2 = 0;
            ExtraInfoNumber3 = 0;
            ExtraInfoNumber4 = 0;
            ExtraInfoNumber5 = 0;
            ExtraInfoNumber6 = 0;
            ExtraInfoNumber7 = 0;
            ExtraInfoNumber8 = 0;
            Larghezza = 0;
            Ordinamento = 0;
            Parents = new List<int>();
            Tags = "";
            TestoBreve = "";
            TestoLungo = "";
            Url = "";
            Url2 = "";
            Translations = new MagicTranslationCollection();
        }

        /// <summary>
        /// Initializes a new instance of the <see cref="MagicPost"/> class. Fletching it from database.
        /// </summary>
        /// <param name="postId">The post id.</param>
        public MagicPost(int postId)
        {
            SqlConnection conn = new SqlConnection(MagicUtils.MagicConnectionString);
            SqlCommand cmd = new SqlCommand();

            #region cmdString

            string cmdString = " SELECT " +
                                " 	mc.Id, " +
                                " 	mc.Titolo, " +
                                " 	mc.Sottotitolo AS Url2, " +
                                " 	mc.Abstract AS TestoLungo, " +
                                " 	mc.Autore AS ExtraInfo, " +
                                " 	mc.Banner AS TestoBreve, " +
                                " 	mc.Link AS Url, " +
                                " 	mc.Larghezza, " +
                                " 	mc.Altezza, " +
                                " 	mc.Tipo, " +
                                " 	mc.Contenuto_parent AS Ordinamento, " +
                                " 	mc.DataPubblicazione, " +
                                " 	mc.DataScadenza, " +
                                " 	mc.DataUltimaModifica, " +
                                " 	mc.Flag_Attivo, " +
                                " 	mc.ExtraInfo1, " +
                                " 	mc.ExtraInfo4, " +
                                " 	mc.ExtraInfo3, " +
                                " 	mc.ExtraInfo2, " +
                                " 	mc.ExtraInfo5, " +
                                " 	mc.ExtraInfo6, " +
                                " 	mc.ExtraInfo7, " +
                                " 	mc.ExtraInfo8, " +
                                " 	mc.ExtraInfoNumber1, " +
                                " 	mc.ExtraInfoNumber2, " +
                                " 	mc.ExtraInfoNumber3, " +
                                " 	mc.ExtraInfoNumber4, " +
                                " 	mc.ExtraInfoNumber5, " +
                                " 	mc.ExtraInfoNumber6, " +
                                " 	mc.ExtraInfoNumber7, " +
                                " 	mc.ExtraInfoNumber8, " +
                                " 	mc.Tags, " +
                                " 	mc.Propietario AS Owner, " +
                                " 	mc.Flag_Cancellazione " +
                                " FROM MB_contenuti mc " +
                                " WHERE mc.Id = @Pk ";
            #endregion
            try
            {
                conn.Open();
                cmd.CommandText = cmdString;

                cmd.Connection = conn;
                cmd.Parameters.AddWithValue("@Pk", postId);
                SqlDataReader reader = cmd.ExecuteReader(CommandBehavior.SingleRow);
                if (reader.HasRows)
                {
                    reader.Read();
                    Init(reader);
                }
            }
            catch (Exception e)
            {
                MagicLog log = new MagicLog("MB_Contenuti", postId, LogAction.Read, e);
                log.Insert();
            }
            finally
            {
                conn.Close();
                //conn.Dispose();
                cmd.Dispose();
            }
        }


        /// <summary>
        /// Initializes a new instance of the <see cref="MagicPost"/> class. Fletching it from database.
        /// </summary>
        /// <param name="myRecord">SqlDataReader record.</param>
        public MagicPost(SqlDataReader myRecord)
        {
            Init(myRecord);
        }

        private void Init(SqlDataReader myRecord)
        {
            //  	mc.Id, " +
            Pk = Convert.ToInt32(myRecord.GetValue(0));

            //  	mc.Titolo, " +
            Titolo = Convert.ToString(myRecord.GetValue(1));

            //  	mc.Sottotitolo AS Url2, " +
            Url2 = Convert.ToString(myRecord.GetValue(2));

            //  	mc.Abstract AS TestoLungo, " +
            TestoLungo = Convert.ToString(myRecord.GetValue(3));

            //  	mc.Autore AS ExtraInfo, " +
            ExtraInfo = Convert.ToString(myRecord.GetValue(4));

            //  	mc.Banner AS TestoBreve, " +
            TestoBreve = Convert.ToString(myRecord.GetValue(5));

            //  	mc.Link AS Url, " +
            Url = Convert.ToString(myRecord.GetValue(6));

            //  	mc.Larghezza, " +
            Larghezza = !myRecord.IsDBNull(7) ? Convert.ToInt32(myRecord.GetValue(7)) : 0;

            //  	mc.Altezza, " +
            Altezza = !myRecord.IsDBNull(8) ? Convert.ToInt32(myRecord.GetValue(8)) : 0;

            //  	mc.Tipo, " +
            Tipo = Convert.ToInt32(myRecord.GetValue(9));

            //  	mc.Contenuto_parent AS Ordinamento, " +
            Ordinamento = !myRecord.IsDBNull(10) ? Convert.ToInt32(myRecord.GetValue(10)) : 0;

            //  	mc.DataPubblicazione, " +
            if (!myRecord.IsDBNull(11))
                DataPubblicazione = Convert.ToDateTime(myRecord.GetValue(11));
            else
                DataPubblicazione = null;

            //  	mc.DataScadenza, " +
            if (!myRecord.IsDBNull(12))
                DataScadenza = Convert.ToDateTime(myRecord.GetValue(12));
            else
                DataScadenza = null;

            //  	mc.DataUltimaModifica, " +
            if (!myRecord.IsDBNull(13))
                DataUltimaModifica = Convert.ToDateTime(myRecord.GetValue(13));
            else
                DataUltimaModifica = DateTime.MinValue;

            //  	mc.Flag_Attivo, " +
            Active = Convert.ToBoolean(myRecord.GetValue(14));

            //  	mc.ExtraInfo1, " +
            ExtraInfo1 = Convert.ToString(myRecord.GetValue(15));
            //  	mc.ExtraInfo4, " +
            ExtraInfo4 = Convert.ToString(myRecord.GetValue(16));
            //  	mc.ExtraInfo3, " +
            ExtraInfo3 = Convert.ToString(myRecord.GetValue(17));
            //  	mc.ExtraInfo2, " +
            ExtraInfo2 = Convert.ToString(myRecord.GetValue(18));
            //  	mc.ExtraInfo5, " +
            ExtraInfo5 = Convert.ToString(myRecord.GetValue(19));
            //  	mc.ExtraInfo6, " +
            ExtraInfo6 = Convert.ToString(myRecord.GetValue(20));
            //  	mc.ExtraInfo7, " +
            ExtraInfo7 = Convert.ToString(myRecord.GetValue(21));
            //  	mc.ExtraInfo8, " +
            ExtraInfo8 = Convert.ToString(myRecord.GetValue(22));
            //  	mc.ExtraInfoNumber1, " +
            ExtraInfoNumber1 = Convert.ToDecimal(myRecord.GetValue(23));
            //  	mc.ExtraInfoNumber2, " +
            ExtraInfoNumber2 = Convert.ToDecimal(myRecord.GetValue(24));
            //  	mc.ExtraInfoNumber3, " +
            ExtraInfoNumber3 = Convert.ToDecimal(myRecord.GetValue(25));
            //  	mc.ExtraInfoNumber4, " +
            ExtraInfoNumber4 = Convert.ToDecimal(myRecord.GetValue(26));
            //  	mc.ExtraInfoNumber5, " +
            ExtraInfoNumber5 = Convert.ToDecimal(myRecord.GetValue(27));
            //  	mc.ExtraInfoNumber6, " +
            ExtraInfoNumber6 = Convert.ToDecimal(myRecord.GetValue(28));
            //  	mc.ExtraInfoNumber7, " +
            ExtraInfoNumber7 = Convert.ToDecimal(myRecord.GetValue(29));
            //  	mc.ExtraInfoNumber8, " +
            ExtraInfoNumber8 = Convert.ToDecimal(myRecord.GetValue(30));
            //  	mc.Tags " +
            Tags = Convert.ToString(myRecord.GetValue(31));
            //NomeExtraInfo = Convert.ToString(myRecord.GetValue(7));
            //Contenitore = Convert.ToBoolean(myRecord.GetValue(15));
            Owner = !myRecord.IsDBNull(32) ? Convert.ToInt32(myRecord.GetValue(32)) : 0;
            Parents = ParentsIds();
            FlagCancellazione = !myRecord.IsDBNull(33) ? Convert.ToBoolean(myRecord.GetValue(33)) : false;
            Translations = new MagicTranslationCollection(Pk);
        }

        #endregion

        #region ReadOnly Properties

        public int AutoMiniaturePk { 
            get 
            {
                return GetMiniaturePk(Larghezza, Altezza, MagicPostWhichUrl.UrlMain);
            } 
        }


        public string Title_RT
        {
            get
            {
                Boolean hideNotTranslated = MagicSession.Current.TransAutoHide;
                string defTitle = String.IsNullOrEmpty(this.ExtraInfo1) ? this.Titolo : this.ExtraInfo1;
                string lang = MagicSession.Current.CurrentLanguage;
                if (lang == "default")
                    return defTitle;

                MagicTranslation mt;
                mt = Translations.GetByLangId(lang);

                if (mt != null)
                    return (String.IsNullOrEmpty(mt.TranslatedTitle) && !hideNotTranslated) ? defTitle : mt.TranslatedTitle;

                return !hideNotTranslated ? defTitle : "";
            }
        }

        public string TestoBreve_RT
        {
            get
            {
                int defLength = MagicCMSConfiguration.GetConfig().TestoBreveDefLenfth;
                MagicTranslation mt = Translations.GetByLangId(MagicSession.Current.CurrentLanguage);
                string defText = "", transText = "";

                Boolean hideNotTranslated = MagicSession.Current.TransAutoHide;
                if (TypeInfo.FlagAutoTestoBreve)
                {
                    defText = StringHtmlExtensions.TruncateHtml(TestoLungo, defLength, "...");
                    if (mt != null)
                    {
                        transText = StringHtmlExtensions.TruncateHtml(mt.TranslatedTestoLungo, defLength, "...");
                        return (String.IsNullOrEmpty(transText) && !hideNotTranslated) ? defText : transText;
                    }
                }
                else
                {
                    defText = !String.IsNullOrEmpty(TestoBreve) ? TestoBreve : StringHtmlExtensions.TruncateHtml(TestoLungo, defLength, "...");
                    if (mt != null)
                    {
                        transText = !String.IsNullOrEmpty(mt.TranslatedTestoBreve) ? mt.TranslatedTestoBreve :
                            StringHtmlExtensions.TruncateHtml(mt.TranslatedTestoLungo, defLength, "...");
                        return (String.IsNullOrEmpty(transText) && !hideNotTranslated) ? defText : transText;
                    }
                }


                return hideNotTranslated ? "" : defText;
            }
        }

        public string TestoNote_RT
        {
            get
            {
                MagicTranslation mt = Translations.GetByLangId(MagicSession.Current.CurrentLanguage);
                Boolean hideNotTranslated = MagicSession.Current.TransAutoHide;
                if (mt != null)
                {
                    if (hideNotTranslated)
                    {
                        return mt.TranslatedTestoBreve;
                    }
                    else
                        return (String.IsNullOrEmpty(mt.TranslatedTestoBreve) ? TestoBreve : mt.TranslatedTestoBreve);
                }

                return hideNotTranslated ? "" : TestoBreve;
            }
        }

        public string TestoLungo_RT
        {
            get
            {
                MagicTranslation mt = Translations.GetByLangId(MagicSession.Current.CurrentLanguage);
                Boolean hideNotTranslated = MagicSession.Current.TransAutoHide;
                if (mt != null)
                {
                    if (hideNotTranslated)
                    {
                        return mt.TranslatedTestoLungo;
                    }
                    else
                        return String.IsNullOrEmpty(mt.TranslatedTestoLungo) ? TestoLungo : mt.TranslatedTestoLungo;
                }

                return hideNotTranslated ? "" : TestoLungo;
            }
        }

        /// <summary>
        /// Gets truncayed and translated short text or description extracted from TestoBreve (if not empty) 
        /// or from TestoLungo
        /// </summary>
        /// <param name="maxlen">Text maxlen.</param>
        /// <returns>Well HTML formed truncated text</returns>
        public string GetTestoBreveCustom(int maxlen)
        {

            MagicTranslation mt = Translations.GetByLangId(MagicSession.Current.CurrentLanguage);
            string defText = String.IsNullOrEmpty(TestoBreve) ? TestoLungo : TestoBreve;

            if (mt != null)
            {
                string transText = String.IsNullOrEmpty(mt.TranslatedTestoBreve) ? mt.TranslatedTestoLungo : mt.TranslatedTestoBreve;
                defText = String.IsNullOrEmpty(transText) ? defText : transText;
            }

            return StringHtmlExtensions.TruncateHtml(defText, maxlen, "...");
        }

        #endregion

        #region Private Methods
        private List<int> ParentsIds()
        {
            return MagicPost.GetParentsIds(Pk);
        }

        private List<int> StringToListint(string str)
        {
            List<int> theList = new List<int>();
            if (!String.IsNullOrEmpty(str))
            {
                string[] temp = str.Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries);
                int n;
                for (int i = 0; i < temp.Length; i++)
                {
                    if (int.TryParse(temp[i], out n))
                        theList.Add(n);
                    else
                    {
                        theList.Clear();
                        break;
                    }
                }
            }

            return theList;
        }
        #endregion

        #region PublicProperties
        public Boolean Active { get; set; }

        public int Altezza { get; set; }

        public Boolean Contenitore
        {
            get
            {
                if (TypeInfo != null)
                    return TypeInfo.FlagContenitore;
                return false;
            }
        }

        public string ContenutiPreferiti
        {
            get
            {
                if (TypeInfo != null)
                {
                    return TypeInfo.ContenutiPreferiti;
                }
                return "";
            }
        }

        public DateTime? DataPubblicazione
        {
            get
            {
                if (_dataPubblicazione.HasValue)
                    return _dataPubblicazione.Value;
                return DataUltimaModifica;
            }
            set
            {
                _dataPubblicazione = value;
            }
        }

        public Nullable<DateTime> DataScadenza { get; set; }



        public DateTime DataUltimaModifica { get; set; }

        public string ExtraInfo { get; set; }

        public string ExtraInfo1 { get; set; }

        public string ExtraInfo2 { get; set; }

        public string ExtraInfo3 { get; set; }

        public string ExtraInfo4 { get; set; }

        public string ExtraInfo5 { get; set; }

        public string ExtraInfo6 { get; set; }

        public string ExtraInfo7 { get; set; }

        public string ExtraInfo8 { get; set; }

        public decimal ExtraInfoNumber1 { get; set; }

        public decimal ExtraInfoNumber2 { get; set; }

        public decimal ExtraInfoNumber3 { get; set; }

        public decimal ExtraInfoNumber4 { get; set; }

        public decimal ExtraInfoNumber5 { get; set; }

        public decimal ExtraInfoNumber6 { get; set; }

        public decimal ExtraInfoNumber7 { get; set; }

        public decimal ExtraInfoNumber8 { get; set; }

        public Boolean FlagCancellazione { get; set; }

        public Boolean FlagExtraInfo1
        {
            get
            {
                if (TypeInfo != null)
                    return TypeInfo.FlagExtrInfo1;
                return false;
            }
        }

        public Boolean FlagExtraInfo2
        {
            get
            {
                if (TypeInfo != null)
                    return TypeInfo.FlagExtrInfo2;
                return false;
            }
        }

        public Boolean FlagExtraInfo3
        {
            get
            {
                if (TypeInfo != null)
                    return TypeInfo.FlagExtrInfo3;
                return false;
            }
        }

        public Boolean FlagExtraInfo4
        {
            get
            {
                if (TypeInfo != null)
                    return TypeInfo.FlagExtrInfo4;
                return false;
            }
        }


        public string LabelExtraInfo1
        {
            get
            {
                if (TypeInfo != null)
                    return TypeInfo.LabelExtraInfo1;
                return "";
            }
        }

        public string LabelExtraInfo2
        {
            get
            {
                if (TypeInfo != null)
                    return TypeInfo.LabelExtraInfo2;
                return "";
            }
        }

        public string LabelExtraInfo3
        {
            get
            {
                if (TypeInfo != null)
                    return TypeInfo.LabelExtraInfo3;
                return "";
            }
        }

        public string LabelExtraInfo4
        {
            get
            {
                if (TypeInfo != null)
                    return TypeInfo.LabelExtraInfo3;
                return "";
            }
        }

        public int Larghezza { get; set; }


        public string MetaInfo
        {
            get
            {
                string metainfo = "";
                if (DataPubblicazione != null)
                {
                    DateTime dp = Convert.ToDateTime(DataPubblicazione);
                    metainfo = "di " + ExtraInfo + " | " +
                    ExtraInfo3 + " | " +
                    "inviato " + dp.ToString("dddd d MMMM yyyy", new System.Globalization.CultureInfo("it-IT")) + " | " +
                    "<strong>voti: " + GetVoti().ToString() + "</strong>";
                }
                return metainfo;
            }
        }

        public string NomeExtraInfo
        {
            get
            {
                if (TypeInfo != null)
                    return TypeInfo.LabelExtraInfo;
                return "";

            }
        }

        public string NomeTipo
        {
            get
            {
                if (TypeInfo != null)
                    return TypeInfo.Nome;
                return "";
            }
        }

        public int Ordinamento { get; set; }

        public int Owner { get; set; }

        //public MagicUsr Owner
        //{
        //    get
        //    {
        //        if (Owners.Count > 0)
        //        {
        //            return new MagicLocalUsr(Owners[0]);
        //        }
        //        return null;
        //    }
        //}

        //public MagicPostCollection Owners
        //{
        //    get
        //    {
        //        return this.GetParents(new int[] { MagicPostTypeInfo.Utente });
        //    }
        //}

        public List<int> Parents
        {
            get
            {
                if (_parents == null)
                    _parents = new List<int>();
                return _parents;
            }
            set
            {
                _parents = value;
            }
        }

        public int Pk { get; set; }

        public List<int> Preferred
        {
            get
            {
                List<int> pref;
                // First: Try tu convert ExtraInfo2 in Int list
                pref = StringToListint(ExtraInfo2);
                if (pref.Count == 0)
                    pref = StringToListint(TypeInfo.ContenutiPreferiti);
                return pref;
            }
        }

        public string Tags { get; set; }

        private string _testoBreve;
        public string TestoBreve
        {
            get
            {
                return _testoBreve.Trim();
            }
            set
            {
                _testoBreve = value;
            }
        }

        private string _testoLungo;
        public string TestoLungo
        {
            get
            {
                return _testoLungo.Trim();
            }
            set
            {
                _testoLungo = value;
            }
        }


        public int Tipo
        {
            get { return _tipo; }
            set
            {
                if (value != _tipo)
                    TypeInfo = new MagicPostTypeInfo(value);
                _tipo = value;
            }
        }

        public string Titolo { get; set; }


        private MagicTranslationCollection _translations;

        public MagicTranslationCollection Translations
        {
            get
            {
                if (_translations == null)
                    _translations = new MagicTranslationCollection();
                return _translations;
            }
            set
            {
                _translations = value;
            }
        }

        public MagicPostTypeInfo TypeInfo { get; set; }

        public string Url { get; set; }

        public string Url2 { get; set; }

        public object this[string propertyName]
        {
            get
            {
                if (this.GetType().GetProperty(propertyName) == null)
                    return null;
                return this.GetType().GetProperty(propertyName).GetValue(this, null);
            }
            set
            {
                if (this.GetType().GetProperty(propertyName) != null)
                    this.GetType().GetProperty(propertyName).SetValue(this, value, null);
            }
        }

        #endregion

        #region Properties Alias



        public string CustomClass
        {
            get { return ExtraInfo3; }
            set { ExtraInfo3 = value; }
        }

        //public string AnnoFondazione
        //{
        //    get
        //    {
        //        System.Type t = DataFondazione.GetType();
        //        if (t.Name == "DateTime")
        //        {
        //            DateTime myDate = Convert.ToDateTime(DataFondazione);
        //            return myDate.Year.ToString();
        //        }
        //        return null;
        //    }
        //}

        //public DateTime? DataFondazione
        //{
        //    get { return DataScadenza; }
        //    set { DataScadenza = value; }
        //}

        public string DisplayTitle
        {
            get { return ExtraInfo1; }
            set { ExtraInfo1 = value; }
        }

        public string Email
        {
            get { return ExtraInfo2; }
            set { ExtraInfo2 = value; }
        }

        //public decimal Fatturato
        //{
        //    get { return ExtraInfoNumber1; }
        //    set { ExtraInfoNumber1 = value; }
        //}

        //public decimal FatturatoEstero
        //{
        //    get { return ExtraInfoNumber2; }
        //    set { ExtraInfoNumber2 = value; }
        //}

        //public decimal FornitoriEu
        //{
        //    get { return ExtraInfoNumber6; }
        //    set { ExtraInfoNumber6 = value; }
        //}

        //public decimal FornitoriIt
        //{
        //    get { return ExtraInfoNumber5; }
        //    set { ExtraInfoNumber5 = value; }
        //}

        //public decimal FornitoriProv
        //{
        //    get { return ExtraInfoNumber3; }
        //    set { ExtraInfoNumber3 = value; }
        //}

        //public decimal FornitoriReg
        //{
        //    get { return ExtraInfoNumber4; }
        //    set { ExtraInfoNumber4 = value; }
        //}

        //public decimal FornitoriWorld
        //{
        //    get { return ExtraInfoNumber7; }
        //    set { ExtraInfoNumber7 = value; }
        //}

        public string Fax { 
            get 
            {
                return ExtraInfo5;
            }
            set
            {
                ExtraInfo5 = value;
            } 
        }

        public string Geolocazione
        {
            get { return ExtraInfo; }
            set { ExtraInfo = value; }
        }

        public string IconClass
        {
            get { return ExtraInfo5; }
            set { ExtraInfo5 = value; }
        }

                
        public int MapZoom
        {
            get { return Altezza; }
            set { Altezza = value; }
        }

        public string MenuIcon
        {
            get { return ExtraInfo5; }
            set { ExtraInfo5 = value; }
        }
        public string Idirizzo
        {
            get { return ExtraInfo1; }
            set { ExtraInfo1 = value; }
        }
        //public string LegaleRappresentante
        //{
        //    get { return ExtraInfo5; }
        //    set { ExtraInfo5 = value; }
        //}

        public string Nome
        {
            get { return Titolo; }
            set { Titolo = value; }
        }
        public string OrderChildrenBy
        {
            get { return ExtraInfo; }
            set { ExtraInfo = value; }
        }

        public string PartitaIVA
        {
            get { return ExtraInfo3; }
            set { ExtraInfo3 = value; }
        }

        public string PreferredChildren
        {
            get { return ExtraInfo2; }
            set { ExtraInfo2 = value; }
        }

        public string RagioneSociale
        {
            get { return Titolo; }
            set { Titolo = value; }
        }

        public string Telefono
        {
            get { return ExtraInfo4; }
            set { ExtraInfo4 = value; }
        }
        #endregion
 
        #region Editing


        /// <summary>
        /// Inserts created MagicPost instance.
        /// </summary>
        /// <returns>Identifier of inserted post</returns>
        public int Insert()
        {

            #region cmdstring
            string cmdstring = " BEGIN TRY " +
                        " 	BEGIN TRANSACTION " +
                        " 		INSERT MB_contenuti (Titolo,  " +
                        " 			Sottotitolo,  " +
                        " 			Abstract,  " +
                        " 			Autore,  " +
                        " 			Banner,  " +
                        " 			Link,  " +
                        " 			Larghezza,  " +
                        " 			Altezza,  " +
                        " 			Tipo,  " +
                        " 			Contenuto_parent,  " +
                        " 			DataUltimaModifica,  " +
                        " 			DataPubblicazione,  " +
                        " 			DataScadenza,  " +
                        " 			ExtraInfo1,  " +
                        " 			ExtraInfo4,  " +
                        " 			ExtraInfo3,  " +
                        " 			ExtraInfo2,  " +
                        " 			ExtraInfo5,  " +
                        " 			ExtraInfo6,  " +
                        " 			ExtraInfo7,  " +
                        " 			ExtraInfo8,  " +
                        " 			ExtraInfoNumber1,  " +
                        " 			ExtraInfoNumber2,  " +
                        " 			ExtraInfoNumber3,  " +
                        " 			ExtraInfoNumber4,  " +
                        " 			ExtraInfoNumber5,  " +
                        " 			ExtraInfoNumber6,  " +
                        " 			ExtraInfoNumber7,  " +
                        " 			ExtraInfoNumber8,  " +
                        "           Propietario," +
                        "           Flag_Attivo," + 
                        " 			Tags) " +
                        " 				VALUES (@Titolo,  " +
                        " 					@Sottotitolo,  " +
                        " 					@Abstract,  " +
                        " 					@Autore,  " +
                        " 					@Banner,  " +
                        " 					@Link,  " +
                        " 					@Larghezza,  " +
                        " 					@Altezza,  " +
                        " 					@Tipo,  " +
                        " 					@Contenuto_parent,  " +
                        "                   GETDATE(), " +
                        " 					@DataPubblicazione,  " +
                        " 					@DataScadenza,  " +
                        " 					@ExtraInfo1,  " +
                        " 					@ExtraInfo4,  " +
                        " 					@ExtraInfo3,  " +
                        " 					@ExtraInfo2,  " +
                        " 					@ExtraInfo5,  " +
                        " 					@ExtraInfo6,  " +
                        " 					@ExtraInfo7,  " +
                        " 					@ExtraInfo8,  " +
                        " 					@ExtraInfoNumber1,  " +
                        " 					@ExtraInfoNumber2,  " +
                        " 					@ExtraInfoNumber3,  " +
                        " 					@ExtraInfoNumber4,  " +
                        " 					@ExtraInfoNumber5,  " +
                        " 					@ExtraInfoNumber6,  " +
                        " 					@ExtraInfoNumber7,  " +
                        " 					@ExtraInfoNumber8,  " +
                        " 					@Propietario,  " +
                        "                   @Flag_Attivo," +
                        " 					@Tags); " +
                        " 	COMMIT TRANSACTION " +
                        " 	SELECT SCOPE_IDENTITY() " +
                        " END TRY " +
                        " BEGIN CATCH " +
                        "   	IF XACT_STATE() <> 0 BEGIN " +
                        " 		ROLLBACK TRANSACTION " +
                        "   	END " +
                        " 	SELECT ERROR_MESSAGE(); " +
                        " END CATCH; ";
            #endregion

            SqlConnection conn = new SqlConnection(MagicUtils.MagicConnectionString);
            SqlCommand cmd = new SqlCommand(cmdstring, conn);

            try
            {
                conn.Open();
                cmd.Parameters.AddWithValue("@Titolo", Titolo);
                cmd.Parameters.AddWithValue("@Sottotitolo", Url2);
                cmd.Parameters.AddWithValue("@Abstract", TestoLungo);
                cmd.Parameters.AddWithValue("@Autore", ExtraInfo);
                cmd.Parameters.AddWithValue("@Banner", TestoBreve);
                cmd.Parameters.AddWithValue("@Link", Url);
                cmd.Parameters.AddWithValue("@Larghezza", Larghezza);
                cmd.Parameters.AddWithValue("@Altezza", Altezza);
                cmd.Parameters.AddWithValue("@Tipo", Tipo);
                cmd.Parameters.AddWithValue("@Contenuto_parent", Ordinamento);
                if (DataPubblicazione.HasValue)
                    cmd.Parameters.AddWithValue("@DataPubblicazione", DataPubblicazione.Value);
                else
                    cmd.Parameters.AddWithValue("@DataPubblicazione", DBNull.Value);

                if (DataScadenza.HasValue)
                    cmd.Parameters.AddWithValue("@DataScadenza", DataScadenza.Value.ToString("yyyy-MM-ddTHH:mm:ss.fff"));
                else
                    cmd.Parameters.AddWithValue("@DataScadenza", DBNull.Value);
                cmd.Parameters.AddWithValue("@ExtraInfo1", ExtraInfo1);
                cmd.Parameters.AddWithValue("@ExtraInfo4", ExtraInfo4);
                cmd.Parameters.AddWithValue("@ExtraInfo3", ExtraInfo3);
                cmd.Parameters.AddWithValue("@ExtraInfo2", ExtraInfo2);
                cmd.Parameters.AddWithValue("@ExtraInfo5", ExtraInfo5);
                cmd.Parameters.AddWithValue("@ExtraInfo6", ExtraInfo6);
                cmd.Parameters.AddWithValue("@ExtraInfo7", ExtraInfo7);
                cmd.Parameters.AddWithValue("@ExtraInfo8", ExtraInfo8);
                cmd.Parameters.AddWithValue("@ExtraInfoNumber1", ExtraInfoNumber1);
                cmd.Parameters.AddWithValue("@ExtraInfoNumber2", ExtraInfoNumber2);
                cmd.Parameters.AddWithValue("@ExtraInfoNumber3", ExtraInfoNumber3);
                cmd.Parameters.AddWithValue("@ExtraInfoNumber4", ExtraInfoNumber4);
                cmd.Parameters.AddWithValue("@ExtraInfoNumber5", ExtraInfoNumber5);
                cmd.Parameters.AddWithValue("@ExtraInfoNumber6", ExtraInfoNumber6);
                cmd.Parameters.AddWithValue("@ExtraInfoNumber7", ExtraInfoNumber7);
                cmd.Parameters.AddWithValue("@ExtraInfoNumber8", ExtraInfoNumber8);
                cmd.Parameters.AddWithValue("@Flag_Attivo", Active);
                cmd.Parameters.AddWithValue("@Tags", Tags);
                cmd.Parameters.AddWithValue("@Propietario", Owner);

                string result = cmd.ExecuteScalar().ToString();
                int pk;
                if (int.TryParse(result, out pk))
                {
                    MagicLog log = new MagicLog("MB_contenuti", pk, LogAction.Insert, "", "");
                    log.Error = "Success";
                    log.Insert();
                }
                else
                {
                    MagicLog log = new MagicLog("MB_contenuti", pk, LogAction.Insert, "", "");
                    log.Error = result;
                    log.Insert();
                }
                Pk = pk;
                if (Pk > 0)
                {
                    //Updating links with parent elements an tags/keyword table
                    ConnectTo(Parents.ToArray());
                    MagicKeyword.Update(Pk, Tags);
					MagicIndex mi = new MagicIndex(this);
					string errorMessage;
					if (mi.Save(out errorMessage) == 0)
					{
						MagicLog log = new MagicLog("MB_Contenuti", Pk, LogAction.Insert, MagicSession.Current.LoggedUser.Pk, DateTime.Now, "MagicPosst", "Insert - MagicIndex", errorMessage);
					}
                }
            }
            catch (Exception e)
            {
                MagicLog log = new MagicLog("MB_contenuti", Pk, LogAction.Insert, e);
                log.Insert();
            }
            finally
            {
                conn.Close();
                //conn.Dispose();
                cmd.Dispose();
            }
            return Pk;
        }

        /// <summary>
        /// Save modified MagicPost instance.
        /// </summary>
        /// <returns>Identifier of saved post</returns>
        public int Update()
        {
            #region cmdString
            string cmdstring = " BEGIN TRY " +
                        " 	BEGIN TRANSACTION " +
                        " 		UPDATE [dbo].[MB_contenuti] " +
                        " 		SET	 " +
                        " 			[Titolo] = @Titolo, " +
                        " 			[Sottotitolo] = @Sottotitolo, " +
                        " 			[Abstract] = @Abstract, " +
                        " 			[Autore] = @Autore, " +
                        " 			[Banner] = @Banner, " +
                        " 			[Link] = @Link, " +
                        " 			[Larghezza] = @Larghezza, " +
                        " 			[Altezza] = @Altezza, " +
                        " 			[Tipo] = @Tipo, " +
                        " 			[Contenuto_parent] = @Contenuto_parent, " +
                        " 			[Propietario] = @Proprietario, " +
                        " 			[DataUltimaModifica] = GETDATE(), " +
                        " 			[DataPubblicazione] = @DataPubblicazione, " +
                        " 			[DataScadenza] = @DataScadenza, " +
                        " 			ExtraInfo1 = @ExtraInfo1, " +
                        " 			ExtraInfo2 = @ExtraInfo2, " +
                        " 			ExtraInfo3 = @ExtraInfo3, " +
                        " 			ExtraInfo4 = @ExtraInfo4, " +
                        " 			ExtraInfo5 = @ExtraInfo5, " +
                        " 			ExtraInfo6 = @ExtraInfo6, " +
                        " 			ExtraInfo7 = @ExtraInfo7, " +
                        " 			ExtraInfo8 = @ExtraInfo8, " +
                        " 			ExtraInfoNumber1 = @ExtraInfoNumber1, " +
                        " 			ExtraInfoNumber2 = @ExtraInfoNumber2, " +
                        " 			ExtraInfoNumber3 = @ExtraInfoNumber3, " +
                        " 			ExtraInfoNumber4 = @ExtraInfoNumber4, " +
                        " 			ExtraInfoNumber5 = @ExtraInfoNumber5, " +
                        " 			ExtraInfoNumber6 = @ExtraInfoNumber6, " +
                        " 			ExtraInfoNumber7 = @ExtraInfoNumber7, " +
                        " 			ExtraInfoNumber8 = @ExtraInfoNumber8, " +
                        " 			Flag_Attivo = @Flag_Attivo, " +
                        " 			Tags = @Tags " +
                        " 		WHERE [Id] = @Pk " +
                        " 	COMMIT TRANSACTION " +
                        " 	SELECT @Pk " +
                        " END TRY " +
                        " BEGIN CATCH " +
                        "   	IF XACT_STATE() <> 0 BEGIN " +
                        " 		ROLLBACK TRANSACTION " +
                        "   	END " +
                        " 	SELECT ERROR_MESSAGE(); " +
                        " END CATCH; ";

            #endregion

            SqlConnection conn = new SqlConnection(MagicUtils.MagicConnectionString);
            SqlCommand cmd = new SqlCommand(cmdstring, conn);
            int pk = 0;

            try
            {
                conn.Open();
                cmd.Parameters.AddWithValue("@Titolo", Titolo);
                cmd.Parameters.AddWithValue("@Sottotitolo", Url2);
                cmd.Parameters.AddWithValue("@Abstract", TestoLungo);
                cmd.Parameters.AddWithValue("@Autore", ExtraInfo);
                cmd.Parameters.AddWithValue("@Banner", TestoBreve);
                cmd.Parameters.AddWithValue("@Link", Url);
                cmd.Parameters.AddWithValue("@Larghezza", Larghezza);
                cmd.Parameters.AddWithValue("@Altezza", Altezza);
                cmd.Parameters.AddWithValue("@Tipo", Tipo);
                cmd.Parameters.AddWithValue("@Contenuto_parent", Ordinamento);
                if (DataPubblicazione.HasValue)
                    cmd.Parameters.AddWithValue("@DataPubblicazione", (DataPubblicazione.Value));
                else
                    cmd.Parameters.AddWithValue("@DataPubblicazione", DBNull.Value);

                if (DataScadenza.HasValue)
                    cmd.Parameters.AddWithValue("@DataScadenza", DataScadenza.Value);
                else
                    cmd.Parameters.AddWithValue("@DataScadenza", DBNull.Value);
                cmd.Parameters.AddWithValue("@ExtraInfo1", ExtraInfo1);
                cmd.Parameters.AddWithValue("@ExtraInfo4", ExtraInfo4);
                cmd.Parameters.AddWithValue("@ExtraInfo3", ExtraInfo3);
                cmd.Parameters.AddWithValue("@ExtraInfo2", ExtraInfo2);
                cmd.Parameters.AddWithValue("@ExtraInfo5", ExtraInfo5);
                cmd.Parameters.AddWithValue("@ExtraInfo6", ExtraInfo6);
                cmd.Parameters.AddWithValue("@ExtraInfo7", ExtraInfo7);
                cmd.Parameters.AddWithValue("@ExtraInfo8", ExtraInfo8);
                cmd.Parameters.AddWithValue("@ExtraInfoNumber1", ExtraInfoNumber1);
                cmd.Parameters.AddWithValue("@ExtraInfoNumber2", ExtraInfoNumber2);
                cmd.Parameters.AddWithValue("@ExtraInfoNumber3", ExtraInfoNumber3);
                cmd.Parameters.AddWithValue("@ExtraInfoNumber4", ExtraInfoNumber4);
                cmd.Parameters.AddWithValue("@ExtraInfoNumber5", ExtraInfoNumber5);
                cmd.Parameters.AddWithValue("@ExtraInfoNumber6", ExtraInfoNumber6);
                cmd.Parameters.AddWithValue("@ExtraInfoNumber7", ExtraInfoNumber7);
                cmd.Parameters.AddWithValue("@ExtraInfoNumber8", ExtraInfoNumber8);
                cmd.Parameters.AddWithValue("@Tags", Tags);
                cmd.Parameters.AddWithValue("@Proprietario", Owner);
                cmd.Parameters.AddWithValue("@Flag_Attivo", Active);
                cmd.Parameters.AddWithValue("@Pk", Pk);

                string result = cmd.ExecuteScalar().ToString();
                if (int.TryParse(result, out pk))
                {
                    MagicLog log = new MagicLog("MB_contenuti", pk, LogAction.Update, "", "");
                    log.Error = "Success";
                    log.Insert();
                    //Updating links with parent elements an tags/keyword table
                    ConnectTo(Parents.ToArray());
                    MagicKeyword.Update(Pk, Tags);
                }
                else
                {
                    MagicLog log = new MagicLog("MB_contenuti", pk, LogAction.Update, "", "");
                    log.Error = result;
                    log.Insert();
                }

            }
            catch (Exception e)
            {
                MagicLog log = new MagicLog("MB_contenuti", Pk, LogAction.Update, e);
                log.Insert();
            }
            finally
            {
                conn.Close();
                //conn.Dispose();
                cmd.Dispose();
            }
            return pk;
        }

        /// <summary>
        /// Deletes this instance.
        /// </summary>
        /// <param name="message">Returning message.</param>
        /// <returns>
        /// True if successful
        /// </returns>
        public Boolean Delete(out string message)
        {
            message = "Record cancellato cn successo.";

            string cmdstring;
            if (FlagCancellazione)
            {
                cmdstring = " BEGIN TRY " +
                            " 	BEGIN TRANSACTION " +
                            " 		DELETE MB_contenuti " +
                            " 		WHERE Id = @PK; " +
                            " 		DELETE REL_contenuti_Argomenti " +
                            " 		WHERE Id_Contenuti = @PK " +
                            " 			OR Id_Argomenti = @PK " +
                            " 	COMMIT TRANSACTION " +
                            " 	SELECT " +
                            " 		@PK " +
                            " END TRY " +
                            " BEGIN CATCH " +
                            " 	IF XACT_STATE() <> 0 " +
                            " 	BEGIN " +
                            " 		ROLLBACK TRANSACTION " +
                            " 	END " +
                            " 	SELECT " +
                            " 		ERROR_MESSAGE(); " +
                            " END CATCH; ";

            }
            else
            {
                cmdstring = " BEGIN TRY " +
                            " 	BEGIN TRANSACTION " +
                            " 		UPDATE MB_contenuti " +
                            " 		SET	Flag_Cancellazione = 1, " +
                            " 			Data_Cancellazione = GETDATE() " +
                            " 		WHERE Id = @PK; " +
                            " 		DELETE REL_contenuti_Argomenti " +
                            " 		WHERE Id_Contenuti = @PK " +
                            " 			OR Id_Argomenti = @PK " +
                            " 	COMMIT TRANSACTION " +
                            " 	SELECT " +
                            " 		@PK " +
                            " END TRY " +
                            " BEGIN CATCH " +
                            " 	IF XACT_STATE() <> 0 " +
                            " 	BEGIN " +
                            " 		ROLLBACK TRANSACTION " +
                            " 	END " +
                            " 	SELECT " +
                            " 		ERROR_MESSAGE(); " +
                            " END CATCH; ";
            }

            SqlCommand cmd = null;
            SqlConnection conn = null;
            int pk = 0;
            try
            {
                conn = new SqlConnection(MagicUtils.MagicConnectionString);
                conn.Open();
                cmd = new SqlCommand(cmdstring, conn);
                cmd.Parameters.AddWithValue("@PK", Pk);
                string result = cmd.ExecuteScalar().ToString();

                if (int.TryParse(result, out pk))
                {
                    MagicLog log = new MagicLog("MB_contenuti", pk, LogAction.Delete, "", "");
                    log.Error = "Success";
                    log.Insert();
                    MagicKeyword.Update(Pk, "");
                }
                else
                {
                    MagicLog log = new MagicLog("MB_contenuti", pk, LogAction.Delete, "", "");
                    log.Error = result;
                    log.Insert();
                    message = result;
                }

            }
            catch (Exception e)
            {
                MagicLog log = new MagicLog("MB_contenuti", Pk, LogAction.Delete, e);
                log.Insert();
                message = e.Message;
            }
            finally
            {
                conn.Close();
                //conn.Dispose();
                cmd.Dispose();
            }
            return (pk > 0);
        }


        /// <summary>
        /// Undelete this istance.
        /// </summary>
        /// <returns>True if successful</returns>
        public Boolean UnDelete(out string message)
        {
            message = "Record recuperato con successo.";
            string cmdstring = " BEGIN TRY " +
                                " 	BEGIN TRANSACTION " +
                                " 		UPDATE MB_contenuti " +
                                " 		SET	Flag_Cancellazione = 0 " +
                                " 		WHERE Id = @PK; " +
                                " 	COMMIT TRANSACTION " +
                                " 	SELECT " +
                                " 		@PK " +
                                " END TRY " +
                                " BEGIN CATCH " +
                                " 	IF XACT_STATE() <> 0 " +
                                " 	BEGIN " +
                                " 		ROLLBACK TRANSACTION " +
                                " 	END " +
                                " 	SELECT " +
                                " 		ERROR_MESSAGE(); " +
                                " END CATCH; ";
            SqlCommand cmd = null;
            SqlConnection conn = null;
            int pk = 0;
            try
            {
                conn = new SqlConnection(MagicUtils.MagicConnectionString);
                conn.Open();
                cmd = new SqlCommand(cmdstring, conn);
                cmd.Parameters.AddWithValue("@PK", Pk);
                string result = cmd.ExecuteScalar().ToString();

                if (int.TryParse(result, out pk))
                {
                    MagicLog log = new MagicLog("MB_contenuti", pk, LogAction.Undelete, "", "");
                    log.Error = "Success";
                    log.Insert();
                }
                else
                {
                    MagicLog log = new MagicLog("MB_contenuti", pk, LogAction.Undelete, "", "");
                    log.Error = result;
                    message = result;
                    log.Insert();
                }

            }
            catch (Exception e)
            {
                message = e.Message;
                MagicLog log = new MagicLog("MB_contenuti", Pk, LogAction.Undelete, e);
                log.Insert();

            }
            finally
            {
                conn.Close();
                //conn.Dispose();
                cmd.Dispose();
            }
            return (pk > 0);
        }

        /// <summary>
        /// Connects to parent MagicPost object.
        /// </summary>
        /// <param name="parentId">The parent identifier.</param>
        /// <returns>True if successful</returns>
        public Boolean ConnectTo(int parentId)
        {
            if (parentId == 0)
                return ConnectTo(new int[] { });
            return ConnectTo(new int[] { parentId });
        }

        /// <summary>
        /// Connects to parent MagicPost objects.
        /// </summary>
        /// <param name="parents">The parent posts.</param>
        /// <returns>
        /// True if successful
        /// </returns>
        public Boolean ConnectTo(int[] parents)
        {
            string cmdstring = " BEGIN TRY " +
                                " 	BEGIN TRANSACTION " +
                                " 		DELETE REL_contenuti_Argomenti WHERE Id_Contenuti = @Pk; ";
            for (int i = 0; i < parents.Length; i++)
            {
                cmdstring += String.Format(" INSERT REL_contenuti_Argomenti (Id_Contenuti, Id_Argomenti) " +
                                            " VALUES (@Pk, {0} ); ", parents[i]);
            }

            cmdstring += " 	COMMIT TRANSACTION " +
                            " 	SELECT " +
                            " 		@PK " +
                            " END TRY " +
                            " BEGIN CATCH " +
                            " 	IF XACT_STATE() <> 0 " +
                            " 	BEGIN " +
                            " 		ROLLBACK TRANSACTION " +
                            " 	END " +
                            " 	SELECT " +
                            " 		ERROR_MESSAGE(); " +
                            " END CATCH; ";


            SqlCommand cmd = null;
            SqlConnection conn = null;
            int pk = 0;
            try
            {
                conn = new SqlConnection(MagicUtils.MagicConnectionString);
                conn.Open();
                cmd = new SqlCommand(cmdstring, conn);
                cmd.Parameters.AddWithValue("@PK", Pk);
                string result = cmd.ExecuteScalar().ToString();

                if (int.TryParse(result, out pk))
                {
                    MagicLog log = new MagicLog("REL_contenuti_Argomenti", pk, LogAction.Insert, "", "");
                    log.Error = "Success";
                    log.Insert();
                }
                else
                {
                    MagicLog log = new MagicLog("REL_contenuti_Argomenti", pk, LogAction.Insert, "", "");
                    log.Error = result;
                    log.Insert();
                }

            }
            catch (Exception e)
            {
                MagicLog log = new MagicLog("REL_contenuti_Argomenti", Pk, LogAction.Insert, e);
                log.Insert();
            }
            finally
            {
                conn.Close();
                //conn.Dispose();
                cmd.Dispose();
            }
            return (pk > 0);
        }

        public Boolean MergeContext(HttpContext context, string[] propertyList, out string msg)
        {
            Boolean result = true;
            msg = "Success";
            Type TheType = typeof(MagicPost);
            try
            {
                for (int i = 0; i < propertyList.Length; i++)
                {
                    string propName = propertyList[i];
                    PropertyInfo pi = TheType.GetProperty(propName);
                    if (pi != null)
                    {
                        Type propType = pi.PropertyType;
                        if (propType.Equals(typeof(int)))
                        {
                            int n = 0;
                            int.TryParse(context.Request[propName], out n);
                            this[propName] = n;
                        }
                        else if (propType.Equals(typeof(decimal)))
                        {
                            decimal nd = 0;
                            decimal.TryParse(context.Request[propName], out nd);
                            this[propName] = nd;
                        }
                        else if (propType.Equals(typeof(Boolean)))
                        {
                            bool b;
                            bool.TryParse(context.Request[propName], out b);
                            this[propName] = b;
                        }
                        else if (propType.Equals(typeof(DateTime)))
                        {
                            if (!String.IsNullOrEmpty(context.Request[propName]))
                            {
                                //if (DateTime.TryParseExact(
                                //    context.Request[propName],
                                //    "o",
                                //    System.Globalization.CultureInfo.InvariantCulture,
                                //    System.Globalization.DateTimeStyles.AssumeUniversal, out d))
                                //this[propName] = d;
                                this[propName] = MagicUtils.ParseISO8601String(context.Request[propName]);
                            }
                        }
                        else if (propType.Equals(typeof(DateTime?)))
                        {
                            if (!String.IsNullOrEmpty(context.Request[propName]))
                            {
                                //if (DateTime.TryParseExact(
                                //    context.Request[propName],
                                //    "o",
                                //    System.Globalization.CultureInfo.InvariantCulture,
                                //    System.Globalization.DateTimeStyles.AssumeUniversal, out d))
                                //    this[propName] = d;
                                this[propName] = MagicUtils.ParseISO8601String(context.Request[propName]);
                            }
                            else
                                this[propName] = null;
                        }
                        else if (propType.Equals(typeof(List<int>)))
                        {
                            List<int> list = new List<int>();
                            string[] strArray = context.Request[propName].Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries);
                            int n;
                            for (int k = 0; k < strArray.Length; k++)
                            {
                                if (int.TryParse(strArray[k], out n))
                                    list.Add(n);
                            }
                            //remove duplicates from list
                            list.Sort();
                            int index = 0;
                            while (index < list.Count - 1)
                            {
                                if (list[index] == list[index + 1])
                                    list.RemoveAt(index);
                                else
                                    index++;
                            }
                            this[propName] = list;
                        }
                        else
                        {
                            this[propName] = context.Request[propName].ToString();
                        }
                    }
                }
            }
            catch (Exception e)
            {
                MagicLog log = new MagicLog("ANA_CONT_TYPE", Pk, LogAction.Read, e);
                log.Insert();
                msg = e.Message;
                result = false;
            }

            return result;
        }

        #endregion

        #region PublicMethods
        public Boolean AddChild(int childId)
        {
            if (childId == 0)
                return false;
            SqlConnection conn = new SqlConnection(MagicUtils.MagicConnectionString);
            SqlCommand cmd = new SqlCommand();
            try
            {
                conn.Open();
                cmd.Connection = conn;
                cmd.CommandText = "	IF NOT EXISTS (SELECT  " +
                                    "			* " +
                                    "		FROM REL_contenuti_Argomenti rca " +
                                    "		WHERE rca.Id_Contenuti = @PK AND rca.Id_Argomenti = @ID_ARG) " +
                                    "	BEGIN " +
                                    "		INSERT INTO REL_contenuti_Argomenti (Id_Contenuti, Id_Argomenti) " +
                                    "			VALUES (@PK, @ID_ARG) " +
                                    "	END ";
                cmd.Parameters.AddWithValue("@PK", childId);
                cmd.Parameters.AddWithValue("@ID_ARG", Pk);
                cmd.ExecuteNonQuery();
                return true;
            }
            catch (Exception e)
            {
                MagicLog log = new MagicLog("REL_contenuti_Argomenti", Pk, LogAction.Insert, e);
                log.Insert();
                return false;
            }

            finally
            {
                conn.Dispose();
                cmd.Dispose();
            }
        }

        private int CountChildren(string query)
        {
            int conto = 0;
            string q = "";
            if (query.Length > 0)
                q = "   AND " + query;
            SqlConnection conn = new SqlConnection(MagicUtils.MagicConnectionString);
            SqlCommand cmd = new SqlCommand();
            try
            {
                conn.Open();
                cmd.CommandText = "SELECT " +
                                    "	conto = count(*) " +
                                    "FROM " +
                                    "	REL_contenuti_Argomenti rca  " +
                                    "	INNER JOIN VW_MB_contenuti_attivi vmca ON Id_Contenuti = vmca.Id " +
                                    "WHERE " +
                                    "	Id_Argomenti =  " + Pk.ToString() + q;

                cmd.Connection = conn;
                SqlDataReader reader = cmd.ExecuteReader(CommandBehavior.SingleRow);
                if (reader.Read())
                {
                    conto = reader.GetInt32(0);
                }
            }
            catch (Exception e)
            {
                MagicLog log = new MagicLog("REL_contenuti_Argomenti", Pk, LogAction.Read, e);
                log.Insert();
                return 0;
            }
            finally
            {
                conn.Close();
                //conn.Dispose();
                cmd.Dispose();
            }

            return conto;
        }

        /// <summary>
        /// Counts the children by type.
        /// </summary>
        /// <param name="type">The type.</param>
        /// <returns></returns>
        public int CountChildren(int type)
        {
            return CountChildren(" Tipo = " + type.ToString());
        }

        /// <summary>
        /// Counts the children by types.
        /// </summary>
        /// <param name="types">The types.</param>
        /// <returns></returns>
        public int CountChildren(int[] types)
        {
            string typeList = "";
            string filter = "";

            for (int i = 0; i < types.Length; i++)
            {
                if (i != 0)
                    typeList += ",";
                typeList += types[i].ToString();
            }
            filter = "Tipo IN (" + typeList + ") ";

            return CountChildren(filter);
        }


        /// <summary>
        /// Gets the answers to messages.
        /// </summary>
        /// <param name="order">The order.</param>
        /// <returns>Collection of Answers or Comments</returns>
        public MagicPostCollection GetAnswers(string order)
        {
            return GetAnswersByType(new int[] { MagicPostTypeInfo.Risposta }, order, true, 30, false);
        }

        /// <summary>
        /// Gets the answers to messages by default order.
        /// </summary>
        /// <returns>Collection of Answers or Comments</returns>
        public MagicPostCollection GetAnswers()
        {
            return GetAnswers(MagicOrdinamento.ModDateAsc);
        }

        /// <summary>
        /// Get anwswers or comments to a posts or messages (MagicPostCollection)
        /// </summary>
        /// <param name="types">Types filter (Array of int)</param>
        /// <param name="order">Order of list</param>
        /// <param name="inclusive">Esclude or include types</param>
        /// <param name="max">Max number of recods</param>
        /// <param name="escludiScaduti">Filter expired records</param>
        /// <returns>Collection of Answers or Comments</returns>
        public MagicPostCollection GetAnswersByType(int[] types, string order, Boolean inclusive, int max, Boolean escludiScaduti)
        {
            MagicPostCollection mpc = new MagicPostCollection();
            SqlConnection conn = new SqlConnection(MagicUtils.MagicConnectionString);
            SqlCommand cmd = new SqlCommand();
            string typeList = "";
            string orderClause = "";
            string filter = "";
            string idClause = "";
            string topClause = "";

            if (Pk > 0)
                idClause = "	AND REL_REPL_MESSAGE_PK = " + Pk.ToString() + " ";

            if (max > 0)
                topClause = " TOP " + max.ToString() + " ";

            for (int i = 0; i < types.Length; i++)
            {
                if (i != 0)
                    typeList += ",";
                typeList += types[i].ToString();
            }
            if (inclusive)
                filter = "	AND Tipo IN (" + typeList + ") ";
            else
                filter = "	AND Tipo NOT IN (" + typeList + ") ";



            orderClause = MagicOrdinamento.GetOrderClause(order, "mc");
            string checkScadenza = "";
            if (escludiScaduti)
            {
                checkScadenza = " (DataScadenza >= getdate() OR DataScadenza IS NULL) AND ";
            }


            try
            {
                conn.Open();
                cmd.CommandText = "SELECT DISTINCT " + topClause +
                                    " 	mc.Id, " +
                                    " 	mc.Titolo, " +
                                    " 	mc.Sottotitolo AS Url2, " +
                                    " 	mc.Abstract AS TestoLungo, " +
                                    " 	mc.Autore AS ExtraInfo, " +
                                    " 	mc.Banner AS TestoBreve, " +
                                    " 	mc.Link AS Url, " +
                                    " 	mc.Larghezza, " +
                                    " 	mc.Altezza, " +
                                    " 	mc.Tipo, " +
                                    " 	mc.Contenuto_parent AS Ordinamento, " +
                                    " 	mc.DataPubblicazione, " +
                                    " 	mc.DataScadenza, " +
                                    " 	mc.DataUltimaModifica, " +
                                    " 	mc.Flag_Attivo, " +
                                    " 	mc.ExtraInfo1, " +
                                    " 	mc.ExtraInfo4, " +
                                    " 	mc.ExtraInfo3, " +
                                    " 	mc.ExtraInfo2, " +
                                    " 	mc.ExtraInfo5, " +
                                    " 	mc.ExtraInfo6, " +
                                    " 	mc.ExtraInfo7, " +
                                    " 	mc.ExtraInfo8, " +
                                    " 	mc.ExtraInfoNumber1, " +
                                    " 	mc.ExtraInfoNumber2, " +
                                    " 	mc.ExtraInfoNumber3, " +
                                    " 	mc.ExtraInfoNumber4, " +
                                    " 	mc.ExtraInfoNumber5, " +
                                    " 	mc.ExtraInfoNumber6, " +
                                    " 	mc.ExtraInfoNumber7, " +
                                    " 	mc.ExtraInfoNumber8, " +
                                    " 	mc.Tags, " +
                                    " 	mc.Propietario AS Owner, " +
                                    "   RIGHT(RTRIM(mc.Titolo), CHARINDEX(' ', REVERSE(' ' + RTRIM(mc.Titolo))) - 1) AS COGNOME " +
                                    "FROM " +
                                    "	MB_contenuti mc " +
                                    "	INNER JOIN MB_tipi_contenuto mtc " +
                                    "		ON Tipo = mtc.id " +
                                    "	INNER JOIN REL_MESSAGE_REPL_MESSAGE RMRM  " +
                                    "		ON REL_REPL_MESSAGE_REPLTO_PK = mc.Id " +
                                    "WHERE " +
                                    checkScadenza +
                                    "	mc.Flag_Cancellazione = 0 " +
                                    idClause +
                                    filter +
                                    "ORDER BY " +
                                    orderClause + " ";


                cmd.Connection = conn;
                SqlDataReader reader = cmd.ExecuteReader();
                if (reader.HasRows)
                {
                    //mpc = new MagicPostCollection();
                    while (reader.Read())
                    {
                        mpc.Add(new MagicPost(reader));
                    }
                }
            }
            catch (Exception e)
            {
                MagicLog log = new MagicLog("MB_contenuti", Pk, LogAction.Read, e);
                log.Insert();
            }
            finally
            {
                conn.Close();
                //conn.Dispose();
                cmd.Dispose();
            }
            return mpc;
        }

        public MagicPostCollection GetChildren()
        {
            return GetChildren(MagicOrdinamento.Asc, -1);
        }

        /// <summary>
        /// Ottiene la collezione di record collegati (figli) del Post contenitore
        /// </summary>
        /// <param name="ordine">Ordianmento.</param>
        /// <param name="numRecords">Numero massimo di records restituiti.</param>
        /// <returns>
        /// The children.
        /// </returns>
        /// <remarks>
        /// Bruno, 14/01/2013.
        /// </remarks>
        public MagicPostCollection GetChildren(string ordine, int numRecords)
        {
            return GetChildren(ordine, numRecords, false);
        }



        /// <summary>
        /// Ottiene la collezione di record collegati (figli) del Post contenitore
        /// </summary>
        /// <param name="ordine">Ordine con cui vengono restituiti i post..</param>
        /// <param name="numRecords">Numero massimo di records restituiti.</param>
        /// <param name="escludiScaduti">Se vero esclude i record con data di scadenza minore di oggi.</param>
        /// <returns>
        /// The children.
        /// </returns>
        /// <remarks>
        /// Bruno, 14/01/2013.
        /// </remarks>
        public MagicPostCollection GetChildren(string ordine, int numRecords, Boolean escludiScaduti)
        {
            WhereClauseCollection query = new WhereClauseCollection();

            WhereClause areChildren = new WhereClause();
            areChildren.LogicalOperator = "AND";
            areChildren.FieldName = "Id_Argomenti";
            areChildren.Operator = "=";
            areChildren.Value = new ClauseValue(Pk, ClauseValueType.Number);

            query.Add(areChildren);

            if (escludiScaduti)
            {
                WhereClause scad1 = new WhereClause()
                {
                    LogicalOperator = "AND",
                    FieldName = " ( vmca.DataScadenza",
                    Operator = ">=",
                    Value = new ClauseValue(" getdate() OR vmca.DataScadenza IS NULL) ", ClauseValueType.Function)
                };
                query.Add(scad1);
            }

            return new MagicPostCollection(query, ordine, numRecords, true, false, MagicSession.Current.TransAutoHide);

        }

        /// <summary>
        /// Restituische i figli di un elemento contenitore per tipo.
        /// </summary>
        /// <param name="date">The date.</param>
        /// <param name="order">Ordinamento.</param>
        /// <returns>
        /// Collezione di post.
        /// </returns>
        /// <remarks>
        /// Bruno, 14/01/2013.
        /// </remarks>
        public MagicPostCollection GetChildrenByDate(DateTime date, string order)
        {

            WhereClauseCollection query = new WhereClauseCollection();

            WhereClause areChildren = new WhereClause();
            areChildren.LogicalOperator = "AND";
            areChildren.FieldName = "Id_Argomenti";
            areChildren.Operator = "=";
            areChildren.Value = new ClauseValue(Pk, ClauseValueType.Number);

            query.Add(areChildren);

            WhereClause theDate = new WhereClause()
            {
                LogicalOperator = "AND",
                FieldName = "0",
                Operator = "=",
                Value = new ClauseValue(" datediff(day, vmca.DataPubblicazione, convert(DATETIME, '" + date.ToString("dd/MM/yyyy") + "', 103)) ", ClauseValueType.Function)
            };
            query.Add(theDate);

            return new MagicPostCollection(query, order, -1, true, false, MagicSession.Current.TransAutoHide);


        }

        /// <summary>
        /// Gets the children by type.
        /// </summary>
        /// <param name="types">The types.</param>
        /// <param name="order">The order.</param>
        /// <param name="inclusive">if set to <c>true</c> include filtered otherwise esclude.</param>
        /// <param name="max">The maximum.</param>
        /// <returns>Fetched post collection</returns>
        public MagicPostCollection GetChildrenByType(int[] types, string order, Boolean inclusive, int max)
        {
            return GetChildrenByType(types, order, inclusive, max, true, MagicSearchActive.Both);
        }

        /// <summary>
        /// Restituische i figli di un elemento contenitore per tipo.
        /// </summary>
        /// <param name="types">            Array di interi che enumera i tipi da restituire.</param>
        /// <param name="order">            Ordinamento.</param>
        /// <param name="inclusive">        Includi/escludi i tipi elencati.</param>
        /// <param name="max">              Numero massimo di elementi restituiti.</param>
        /// <param name="escludiScaduti">   Restituisci soli i record con data di scadenza maggiore della data corrente</param>
        /// <param name="active">           Seleziona i record in base al Flag Attivo</param>
        /// <returns>Fetched post collection</returns>
        public MagicPostCollection GetChildrenByType(int[] types, string order, Boolean inclusive, int max, Boolean escludiScaduti, MagicSearchActive active)
        {
            return GetChildrenByType(types, order, inclusive, max, escludiScaduti, active, MagicSession.Current.TransAutoHide);
        }


        /// <summary>
        /// Restituische i figli di un elemento contenitore per tipo.
        /// </summary>
        /// <param name="types">Array di interi che enumera i tipi da restituire.</param>
        /// <param name="order">Ordinamento.</param>
        /// <param name="inclusive">Includi/escludi i tipi elencati.</param>
        /// <param name="max">Numero massimo di elementi restituiti.</param>
        /// <param name="escludiScaduti">Restituisci soli i record con data di scadenza maggiore della data corrente</param>
        /// <param name="active">Seleziona i record in base al Flag Attivo</param>
        /// <param name="onlyIfTranslated">Restituisce solo i record che hanno una traduzione.</param>
        /// <returns>
        /// Fetched post collection
        /// </returns>
        public MagicPostCollection GetChildrenByType(int[] types, string order, Boolean inclusive, int max, Boolean escludiScaduti, MagicSearchActive active, Boolean onlyIfTranslated)
        {

            WhereClauseCollection query = new WhereClauseCollection();

            WhereClause areChildren = new WhereClause();
            areChildren.LogicalOperator = "AND";
            areChildren.FieldName = "Id_Argomenti";
            areChildren.Operator = "=";
            areChildren.Value = new ClauseValue(Pk, ClauseValueType.Number);

            query.Add(areChildren);

            if (escludiScaduti)
            {
                WhereClause scad1 = new WhereClause()
                {
                    LogicalOperator = "AND",
                    FieldName = " ( vmca.DataScadenza",
                    Operator = ">=",
                    Value = new ClauseValue(" getdate() OR vmca.DataScadenza IS NULL) ", ClauseValueType.Function)
                };
                query.Add(scad1);
            }
            string typeList = "";
            for (int i = 0; i < types.Length; i++)
            {
                if (i != 0)
                    typeList += ",";
                typeList += types[i].ToString();
            }

            WhereClause typeClause = new WhereClause()
            {
                LogicalOperator = "AND",
                FieldName = "vmca.Tipo",
                Operator = "IN",
                Value = new ClauseValue("(" + typeList + ")", ClauseValueType.Function)
            };
            if (!inclusive)
                typeClause.Operator = "NOT IN";

            query.Add(typeClause);

            WhereClause activeClause;
            switch (active)
            {
                case MagicSearchActive.ActiveOnly:
                    activeClause = new WhereClause()
                    {
                        LogicalOperator = "AND",
                        FieldName = "vmca.Flag_Attivo",
                        Operator = "=",
                        Value = new ClauseValue(1, ClauseValueType.Number)
                    };
                    query.Add(activeClause);
                    break;
                case MagicSearchActive.NotActiveOnly:
                    activeClause = new WhereClause()
                    {
                        LogicalOperator = "AND",
                        FieldName = "vmca.Flag_Attivo",
                        Operator = "=",
                        Value = new ClauseValue(0, ClauseValueType.Number)
                    };
                    query.Add(activeClause);
                    break;
                case MagicSearchActive.Both:
                    break;
                default:
                    break;
            }



            return new MagicPostCollection(query, order, max, true, false, onlyIfTranslated);


        }

        /// <summary>
        /// Restituische i figli di un elemento contenitore per tipo.
        /// </summary>
        /// <param name="types">            Array di interi che enumera i tipi da restituire.</param>
        /// <param name="order">            Ordinamento.</param>
        /// <param name="inclusive">        Includi/escludi i tipi elencati.</param>
        /// <param name="max">              Numero massimo di elementi restituiti.</param>
        /// <param name="escludiScaduti">   Restituisci soli i record con data di scadenza maggiore della data corrente</param>
        /// <returns>Fetched post collection</returns>
        public MagicPostCollection GetChildrenByType(int[] types, string order, Boolean inclusive, int max, Boolean escludiScaduti)
        {
            return GetChildrenByType(types, order, inclusive, max, escludiScaduti, MagicSearchActive.Both);
        }

        ////////////////////////////////////////////////////////////////////////////////////////////////////
        /// <summary>   Restituische i figli di un elemento contenitore per tipo.</summary>
        ///
        /// <remarks>   Bruno, 14/01/2013.</remarks>
        ///
        /// <param name="tipo">     Tipo.</param>
        /// <param name="ordine">   Ordianmento.</param>
        ///
        /// <returns>   Collezione di post.</returns>
        ////////////////////////////////////////////////////////////////////////////////////////////////////

        public MagicPostCollection GetChildrenByType(int tipo, string ordine)
        {
            return GetChildrenByType(new int[] { tipo }, ordine, true, -1);
        }

        ////////////////////////////////////////////////////////////////////////////////////////////////////
        /// <summary>   Restituische i figli di un elemento contenitore per tipo.</summary>
        ///
        /// <remarks>   Bruno, 14/01/2013.</remarks>
        ///
        /// <param name="tipo"> Tipo.</param>
        ///
        /// <returns>   Collezione di post.</returns>
        ////////////////////////////////////////////////////////////////////////////////////////////////////

        public MagicPostCollection GetChildrenByType(int tipo)
        {
            return GetChildrenByType(new int[] { tipo }, "ASC", true, -1);
        }

        /// <summary>
        /// Restituische i figli di un elemento contenitore per tipo.
        /// </summary>
        /// <param name="tipi">Filtro che limita la ricerca solo a determinati tipi. Se vuoto verranno
        /// reuperati tutti i post.</param>
        /// <returns>
        /// Collezzione di MagicPost.
        /// </returns>
        /// <remarks>
        /// Bruno, 14/01/2013.
        /// </remarks>
        public MagicPostCollection GetChildrenByType(int[] tipi)
        {
            return GetChildrenByType(tipi, "ASC", true, -1);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="order"></param>
        /// <param name="inclusive"></param>
        /// <param name="max"></param>
        /// <returns></returns>
        public MagicPostCollection GetGrandSons(string order, Boolean inclusive, int max)
        {
            return GetGrandSons(order, inclusive, max, false);
        }

        /// <summary>
        /// Restituisce i nipoti di un post contenitore
        /// </summary>
        /// <param name="granpa_id">Id del post</param>
        /// <param name="order">Ordinamento</param>
        /// <param name="inclusive">Includi o escludi i tipi elencati</param>
        /// <param name="max">Numero masso di record da trovare</param>
        /// <param name="escludiScaduti">Escludi i racord con data scadenza inferiore a oggi</param>
        /// <returns>Collezizone di MagicPost</returns>
        public MagicPostCollection GetGrandSons(string order, Boolean inclusive, int max, Boolean escludiScaduti)
        {
            return GetGrandSonsByType(new int[] { }, order, inclusive, max, escludiScaduti);
        }

        /// <summary>
        /// Restituisce i nipoti di un post contenitore
        /// </summary>
        /// <param name="types">Array di tipi</param>
        /// <param name="order">Ordinamento</param>
        /// <param name="inclusive">Includi o escludi i tipi elencati</param>
        /// <param name="max">Numero masso di record da trovare</param>
        /// <param name="escludiScaduti">Escludi i racord con data scadenza inferiore a oggi</param>
        /// <returns>Collezizone di MagicPost</returns>
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Security", "CA2100:Controllare l'eventuale vulnerabilità di sicurezza delle query SQL")]
        public MagicPostCollection GetGrandSonsByType(int[] types, string order, Boolean inclusive, int max, Boolean escludiScaduti)
        {
            MagicPostCollection mpc = new MagicPostCollection();
            SqlConnection conn = new SqlConnection(MagicUtils.MagicConnectionString);
            SqlCommand cmd = new SqlCommand();
            string typeList = "";
            string orderClause = "";
            string filter = "";
            string idClause = "";
            string topClause = "";

            if (Pk > 0)
                idClause = "	AND granpa_rel.Id_Argomenti = " + Pk.ToString() + " ";

            if (max > 0)
                topClause = " TOP " + max.ToString() + " ";

            for (int i = 0; i < types.Length; i++)
            {
                if (i != 0)
                    typeList += ",";
                typeList += types[i].ToString();
            }
            if (!String.IsNullOrEmpty(typeList))
            {
                if (inclusive)
                    filter = "	AND Tipo IN (" + typeList + ") ";
                else
                    filter = "	AND Tipo NOT IN (" + typeList + ") ";
            }

            Boolean onlyIfTranslated = MagicSession.Current.TransAutoHide;
            if (onlyIfTranslated && MagicSession.Current.CurrentLanguage != "default")
            {
                filter += " AND ( TRAN_LANG_Id = '" + MagicSession.Current.CurrentLanguage + "' ) ";
            }


            string checkScadenza = "";
            if (escludiScaduti)
            {
                checkScadenza = " (DataScadenza >= getdate() OR DataScadenza IS NULL) AND ";
            }

            orderClause = MagicOrdinamento.GetOrderClause(order, "vmca");

            try
            {
                conn.Open();
                cmd.CommandText = "  SELECT DISTINCT " + topClause +
                                    " 	vmca.Id, " +
                                    " 	vmca.Titolo, " +
                                    " 	vmca.Sottotitolo AS Url2, " +
                                    " 	vmca.Abstract AS TestoLungo, " +
                                    " 	vmca.Autore AS ExtraInfo, " +
                                    " 	vmca.Banner AS TestoBreve, " +
                                    " 	vmca.Link AS Url, " +
                                    " 	vmca.Larghezza, " +
                                    " 	vmca.Altezza, " +
                                    " 	vmca.Tipo, " +
                                    " 	vmca.Contenuto_parent AS Ordinamento, " +
                                    " 	vmca.DataPubblicazione, " +
                                    " 	vmca.DataScadenza, " +
                                    " 	vmca.DataUltimaModifica, " +
                                    " 	vmca.Flag_Attivo, " +
                                    " 	vmca.ExtraInfo1, " +
                                    " 	vmca.ExtraInfo4, " +
                                    " 	vmca.ExtraInfo3, " +
                                    " 	vmca.ExtraInfo2, " +
                                    " 	vmca.ExtraInfo5, " +
                                    " 	vmca.ExtraInfo6, " +
                                    " 	vmca.ExtraInfo7, " +
                                    " 	vmca.ExtraInfo8, " +
                                    " 	vmca.ExtraInfoNumber1, " +
                                    " 	vmca.ExtraInfoNumber2, " +
                                    " 	vmca.ExtraInfoNumber3, " +
                                    " 	vmca.ExtraInfoNumber4, " +
                                    " 	vmca.ExtraInfoNumber5, " +
                                    " 	vmca.ExtraInfoNumber6, " +
                                    " 	vmca.ExtraInfoNumber7, " +
                                    " 	vmca.ExtraInfoNumber8, " +
                                    " 	vmca.Tags, " +
                                    " 	vmca.Propietario AS Owner, " +
                                    " 	vmca.Flag_Cancellazione, " +
                                    "   RIGHT(RTRIM(vmca.Titolo), CHARINDEX(' ', REVERSE(' ' + RTRIM(vmca.Titolo))) - 1) AS COGNOME " +
                                    "   FROM MB_contenuti vmca  " +
                                    "  	INNER JOIN ANA_CONT_TYPE mtc  " +
                                    "  		ON vmca.Tipo = mtc.TYP_PK  " +
                                    "  	INNER JOIN REL_contenuti_Argomenti parents_rel  " +
                                    "  		ON vmca.Id = parents_rel.Id_Contenuti  " +
                                    "  	INNER JOIN REL_contenuti_Argomenti granpa_rel  " +
                                    "  		ON parents_rel.Id_Argomenti = granpa_rel.Id_Contenuti " +
                                    "   LEFT JOIN ANA_TRANSLATION " +
                                    "       ON vmca.ID = TRAN_MB_contenuti_Id " +
                                    "  WHERE vmca.Flag_Cancellazione = 0  " + checkScadenza +
                                    idClause +
                                    filter +
                                    (!String.IsNullOrEmpty(orderClause) ? " ORDER BY " + orderClause : " ");


                cmd.Connection = conn;
                SqlDataReader reader = cmd.ExecuteReader();
                if (reader.HasRows)
                {
                    //mpc = new MagicPostCollection();
                    while (reader.Read())
                    {
                        mpc.Add(new MagicPost(reader));
                    }
                }
            }
            catch (Exception e)
            {
                MagicLog log = new MagicLog("MB_contenuti", Pk, LogAction.Read, e);
                log.Insert();
            }
            finally
            {
                conn.Close();
                //conn.Dispose();
                cmd.Dispose();
            }
            return mpc;
        }

        /// <summary>
        /// Restituisce i nipoti di un post contenitore
        /// </summary>
        /// <param name="types">Array di tipi</param>
        /// <param name="order">Ordinamento</param>
        /// <param name="inclusive">Includi o escludi i tipi elencati</param>
        /// <param name="max">Numero masso di record da trovare</param>
        /// <returns>Collezizone di MagicPost</returns>
        public MagicPostCollection GetGrandSonsByType(int[] types, string order, Boolean inclusive, int max)
        {
            return GetGrandSonsByType(types, order, inclusive, max, false);
        }

        /// <summary>
        /// Restituisce i nipoti di un post contenitore
        /// </summary>
        /// <param name="granpa_id">Id del post</param>
        /// <param name="type">Tipo</param>
        /// <returns></returns>
        public MagicPostCollection GetGrandSonsByType(int type)
        {
            return GetGrandSonsByType(new int[] { type }, MagicOrdinamento.Asc, true, -1, false);
        }


        /// <summary>
        /// Recupera la media dei voti.
        /// </summary>
        /// <returns></returns>
        public decimal GetMediatVoti()
        {
            decimal voti = 0;
            SqlConnection conn = null;
            SqlCommand cmd = null;
            try
            {
                string cmdText = " DECLARE @utenti numeric, " +
                                    "         @voti numeric " +
                                    "  " +
                                    " SELECT " +
                                    "     @utenti = COUNT(DISTINCT Voti_USER) " +
                                    " FROM VOTI; " +
                                    " SELECT " +
                                    "     @voti = ISNULL((SELECT " +
                                    "         SUM(v.Voti_VOTO) " +
                                    "     FROM VOTI v " +
                                    "     WHERE v.Voti_POST_PK = @pk) " +
                                    "     , 0); " +
                                    " IF @utenti = 0 " +
                                    " BEGIN " +
                                    "     SELECT " +
                                    "         0 " +
                                    " END " +
                                    " ELSE " +
                                    " BEGIN " +
                                    "     SELECT " +
                                    "         @voti / @utenti " +
                                    " END ";

                conn = new SqlConnection(MagicUtils.MagicConnectionString);
                conn.Open();
                cmd = new SqlCommand(cmdText, conn);
                cmd.Parameters.AddWithValue("@pk", Pk);

                voti = Convert.ToDecimal(cmd.ExecuteScalar());
            }
            catch (Exception e)
            {
                MagicLog log = new MagicLog("Voti", Pk, LogAction.Read, e);
                log.Insert();
            }
            finally
            {
                if (conn != null)
                    conn.Dispose();
                if (cmd != null)
                    cmd.Dispose();
            }
            return voti;
        }

        /// <summary>
        /// Gets the miniature primary. Create miniature if it does'ny exist
        /// </summary>
        /// <param name="width">The width of the miniature</param>
        /// <param name="height">The height of the miniature</param>
        /// <param name="which">Use main or secondaru url of MagicPost</param>
        /// <returns>The unique id of existing or just created miniature</returns>
        public int GetMiniaturePk(int width, int height, MagicPostWhichUrl which)
        {
            int minpk = 0;
            Miniatura m = null;
            string userImagePath;
            if (which == MagicPostWhichUrl.UrlMain)
                userImagePath = HttpContext.Current.Server.MapPath(this.Url);
            else
                userImagePath = HttpContext.Current.Server.MapPath(this.Url2);

            string defaltImagePath = HttpContext.Current.Server.MapPath(MagicCMSConfiguration.GetConfig().DefaultImage);
            try
            {
                if (File.Exists(userImagePath))
                {
                    FileInfo fi = new FileInfo(userImagePath);
                    m = new Miniatura(userImagePath, width, height, fi.LastWriteTime);
                    if (m.Pk != 0)
                        minpk = m.Pk;
                }
                else if (File.Exists(defaltImagePath))
                {
                    FileInfo fi = new FileInfo(defaltImagePath);
                    m = new Miniatura(defaltImagePath, width, height, fi.LastWriteTime);
                    if (m.Pk != 0)
                        minpk = m.Pk;
                }

            }
            finally
            {
                if (m != null)
                    m.Dispose();
            }
            return minpk;
        }

        public int GetMiniaturePk(int width, int height)
        {
            return GetMiniaturePk(width, height, MagicPostWhichUrl.UrlSEcondary);
        }

        /// <summary>
        /// Gets parents of this post.
        /// </summary>
        /// <returns></returns>
        public MagicPostCollection GetParents()
        {
            return GetParents(new int[] { });
        }

        /// <summary>
        /// Gets the parents of this Post Filtered by type.
        /// </summary>
        /// <param name="tipi">The types.</param>
        /// <returns></returns>
        public MagicPostCollection GetParents(int[] tipi)
        {
            return GetParents(tipi, MagicOrdinamento.DateDesc);
        }

        /// <summary>
        /// Restituisce i parent al livello immediatamente sopra al post ecentualmente filtrati
        /// per tipo.
        /// </summary>
        /// <param name="tipi">Filtro che limita la ricerca solo a determinati tipi. Se vuoto verranno
        /// reuperati tutti i post.</param>
        /// <param name="order">The order.</param>
        /// <returns>
        /// Una collezione di oggetti MagicPost.
        /// </returns>
        /// <remarks>
        /// Bruno, 14/01/2013.
        /// </remarks>
        public MagicPostCollection GetParents(int[] tipi, string order)
        {
            MagicPostCollection mpc = new MagicPostCollection();
            SqlConnection conn = new SqlConnection(MagicUtils.MagicConnectionString);
            SqlCommand cmd = new SqlCommand();
            string typeList = "";
            string filter = "";
            string orderClause = "";
            orderClause = MagicOrdinamento.GetOrderClause(order, "vmca");

            for (int i = 0; i < tipi.Length; i++)
            {
                if (i != 0)
                    typeList += ",";
                typeList += tipi[i].ToString();
            }

            if (typeList != "")
                filter = "	AND Tipo IN (" + typeList + ") ";

            if (MagicSession.Current.TransAutoHide)
            {
                filter += " AND ( TRAN_LANG_Id = '" + MagicSession.Current.CurrentLanguage + "' ) ";
            }


            try
            {
                conn.Open();
                cmd.CommandText = "SELECT DISTINCT " +
                                    " 	vmca.Id, " +
                                    " 	vmca.Titolo, " +
                                    " 	vmca.Sottotitolo AS Url2, " +
                                    " 	vmca.Abstract AS TestoLungo, " +
                                    " 	vmca.Autore AS ExtraInfo, " +
                                    " 	vmca.Banner AS TestoBreve, " +
                                    " 	vmca.Link AS Url, " +
                                    " 	vmca.Larghezza, " +
                                    " 	vmca.Altezza, " +
                                    " 	vmca.Tipo, " +
                                    " 	vmca.Contenuto_parent AS Ordinamento, " +
                                    " 	vmca.DataPubblicazione, " +
                                    " 	vmca.DataScadenza, " +
                                    " 	vmca.DataUltimaModifica, " +
                                    " 	vmca.Flag_Attivo, " +
                                    " 	vmca.ExtraInfo1, " +
                                    " 	vmca.ExtraInfo4, " +
                                    " 	vmca.ExtraInfo3, " +
                                    " 	vmca.ExtraInfo2, " +
                                    " 	vmca.ExtraInfo5, " +
                                    " 	vmca.ExtraInfo6, " +
                                    " 	vmca.ExtraInfo7, " +
                                    " 	vmca.ExtraInfo8, " +
                                    " 	vmca.ExtraInfoNumber1, " +
                                    " 	vmca.ExtraInfoNumber2, " +
                                    " 	vmca.ExtraInfoNumber3, " +
                                    " 	vmca.ExtraInfoNumber4, " +
                                    " 	vmca.ExtraInfoNumber5, " +
                                    " 	vmca.ExtraInfoNumber6, " +
                                    " 	vmca.ExtraInfoNumber7, " +
                                    " 	vmca.ExtraInfoNumber8, " +
                                    " 	vmca.Tags, " +
                                    " 	vmca.Propietario AS Owner, " +
                                    " 	vmca.Flag_Cancellazione, " +
                                    "   RIGHT(RTRIM(Titolo), CHARINDEX(' ', REVERSE(' ' + RTRIM(Titolo))) - 1) AS COGNOME " +
                                    " FROM " +
                                    "	REL_contenuti_Argomenti rca " +
                                    "	INNER JOIN VW_MB_contenuti_attivi vmca " +
                                    "		ON rca.Id_Argomenti = vmca.Id  " +
                                    "	INNER JOIN ANA_CONT_TYPE act  " +
                                    "		ON act.TYP_PK = Tipo " +
                                    "   LEFT JOIN ANA_TRANSLATION " +
                                    "       ON vmca.ID = TRAN_MB_contenuti_Id " +
                                    " WHERE " +
                                    "	rca.Id_Contenuti = " + Pk.ToString() + " " +
                                    filter + " ORDER BY " + orderClause;


                cmd.Connection = conn;
                SqlDataReader reader = cmd.ExecuteReader();
                if (reader.HasRows)
                {
                    //mpc = new MagicPostCollection();
                    while (reader.Read())
                    {
                        mpc.Add(new MagicPost(reader));
                    }
                }
            }
            catch (Exception e)
            {
                MagicLog log = new MagicLog("MB_contenuti", Pk, LogAction.Read, e);
                log.Insert();
            }
            finally
            {
                conn.Close();
                //conn.Dispose();
                cmd.Dispose();
            }
            return mpc;
        }

        public MagicPost GetRandomChild()
        {
            MagicPost mp = null;
            MagicPostCollection mpc = GetChildren();
            int c = mpc.Count;
            if (c > 0)
            {
                Random r = new Random(DateTime.Now.Millisecond);
                c = r.Next(c);
                mp = mpc[c];
            }
            return mp;
        }

        /// <summary>
        /// Gets the siblings posts (same parent) of current post.
        /// </summary>
        /// <param name="order">The order.</param>
        /// <param name="parentTypes">Limita i parent in comune ad un elenco di tipi.</param>
        /// <returns>
        /// Sibling posts collection
        /// </returns>
        public MagicPostCollection GetSiblings(string order, int[] parentTypes)
        {
            MagicPostCollection mpc = new MagicPostCollection();
            SqlConnection conn = new SqlConnection(MagicUtils.MagicConnectionString);
            SqlCommand cmd = new SqlCommand();
            string orderClause = "";
            orderClause = MagicOrdinamento.GetOrderClause(order, "vmca");

            string parentClauseTypes = "";
            if (parentTypes.Length > 0)
            {
                parentClauseTypes = " AND mc.Tipo IN (";
                for (int i = 0; i < parentTypes.Length; i++)
                {
                    if (i == parentTypes.Length - 1)
                        parentClauseTypes += parentTypes[i].ToString() + ") ";
                    else
                        parentClauseTypes += parentTypes[i].ToString() + ",";
                }
            }

            try
            {
                conn.Open();
                cmd.CommandText =   " SELECT DISTINCT " +
                                    " 	vmca.Id, " +
                                    " 	vmca.Titolo, " +
                                    " 	vmca.Sottotitolo AS Url2, " +
                                    " 	vmca.Abstract AS TestoLungo, " +
                                    " 	vmca.Autore AS ExtraInfo, " +
                                    " 	vmca.Banner AS TestoBreve, " +
                                    " 	vmca.Link AS Url, " +
                                    " 	vmca.Larghezza, " +
                                    " 	vmca.Altezza, " +
                                    " 	vmca.Tipo, " +
                                    " 	vmca.Contenuto_parent AS Ordinamento, " +
                                    " 	vmca.DataPubblicazione, " +
                                    " 	vmca.DataScadenza, " +
                                    " 	vmca.DataUltimaModifica, " +
                                    " 	vmca.Flag_Attivo, " +
                                    " 	vmca.ExtraInfo1, " +
                                    " 	vmca.ExtraInfo4, " +
                                    " 	vmca.ExtraInfo3, " +
                                    " 	vmca.ExtraInfo2, " +
                                    " 	vmca.ExtraInfo5, " +
                                    " 	vmca.ExtraInfo6, " +
                                    " 	vmca.ExtraInfo7, " +
                                    " 	vmca.ExtraInfo8, " +
                                    " 	vmca.ExtraInfoNumber1, " +
                                    " 	vmca.ExtraInfoNumber2, " +
                                    " 	vmca.ExtraInfoNumber3, " +
                                    " 	vmca.ExtraInfoNumber4, " +
                                    " 	vmca.ExtraInfoNumber5, " +
                                    " 	vmca.ExtraInfoNumber6, " +
                                    " 	vmca.ExtraInfoNumber7, " +
                                    " 	vmca.ExtraInfoNumber8, " +
                                    " 	vmca.Tags, " +
                                    " 	vmca.Propietario AS Owner, " +
                                    " 	vmca.Flag_Cancellazione, " +
                                    " 	RIGHT(RTRIM(vmca.Titolo), CHARINDEX(' ', REVERSE(' ' + RTRIM(vmca.Titolo))) - 1) AS COGNOME " +
                                    " FROM REL_contenuti_Argomenti rca " +
                                    " INNER JOIN VW_MB_contenuti_attivi vmca " +
                                    " 	ON rca.Id_Contenuti = vmca.Id " +
                                    " INNER JOIN REL_contenuti_Argomenti rca1 " +
                                    " 	ON rca1.Id_Argomenti = rca.Id_Argomenti " +
                                    " INNER JOIN MB_contenuti mc " +
                                    " 	ON rca1.Id_Argomenti = mc.Id " +
                                    " INNER JOIN ANA_CONT_TYPE act " +
                                    " 	ON act.TYP_PK = vmca.Tipo " +
                                    " LEFT JOIN ANA_TRANSLATION " +
                                    " 	ON vmca.Id = TRAN_MB_contenuti_Id " +
                                    " WHERE rca1.Id_Contenuti = @pk " +
                                    " AND rca.Id_Contenuti <> @pk  " +
                                    parentClauseTypes +
                                    " ORDER BY " + orderClause;


                cmd.Connection = conn;
                cmd.Parameters.AddWithValue("@pk", Pk);
                SqlDataReader reader = cmd.ExecuteReader();
                if (reader.HasRows)
                {
                    //mpc = new MagicPostCollection();
                    while (reader.Read())
                    {
                        mpc.Add(new MagicPost(reader));
                    }
                }
            }
            catch (Exception e)
            {
                MagicLog log = new MagicLog("MB_contenuti", Pk, LogAction.Read, e);
                log.Insert();
            }
            finally
            {
                conn.Close();
                //conn.Dispose();
                cmd.Dispose();
            }
            return mpc;
        }

        public MagicPostCollection GetSiblings()
        {
            return GetSiblings(MagicOrdinamento.DateDesc, new int[] { });
        }

        public MagicPostCollection GetSiblings(string order)
        {
            return GetSiblings(order, new int[] { });
        }

        public MagicPostCollection GetSiblings(string order, int type)
        {
            return GetSiblings(order, new int[] { type });
        }

        /// <summary>
        /// Recupera la somma dei voti.
        /// </summary>
        /// <returns></returns>
        public int GetVoti()
        {
            int voti = 0;
            SqlConnection conn = null;
            SqlCommand cmd = null;
            try
            {
                string cmdText = "SELECT ISNULL((SELECT SUM(v.Voti_VOTO) FROM VOTI v WHERE v.Voti_POST_PK = @pk), 0)";

                conn = new SqlConnection(MagicUtils.MagicConnectionString);
                conn.Open();
                cmd = new SqlCommand(cmdText, conn);
                cmd.Parameters.AddWithValue("@pk", Pk);

                voti = Convert.ToInt32(cmd.ExecuteScalar());
            }
            catch (Exception e)
            {
                MagicLog log = new MagicLog("VOTI", Pk, LogAction.Read, e);
                log.Insert();
            }
            finally
            {
                if (conn != null)
                    conn.Dispose();
                if (cmd != null)
                    cmd.Dispose();
            }
            return voti;
        }

        public bool IsLocalLink()
        {
            MagicPostCollection parents = GetParents(new int[] { MagicPostTypeInfo.Section });
            return (parents.Count > 0);
        }

        /// <summary>
        /// Restituisce un pannello formattato (div) con immagine e link al post
        /// </summary>
        /// <param name="imgWidth">Larghezza della miniatura</param>
        /// <param name="imgHeight">Altezza della miniatura della miniatura</param>
        /// <param name="cssClass">Classe css attriuita la pannello div</param>
        /// <param name="maxLen">Massima lunghezza del testo</param>
        /// <param name="maxTitleLen">Massima lughezza del titotlo (0 = nessun troncamento o modifica)</param>
        /// <returns></returns>
        public HtmlGenericControl HomePanel(int imgWidth, int imgHeight, string cssClass, int maxLen, int maxTitleLen)
        {
            HtmlGenericControl panel = MagicUtils.HTMLElement("div", cssClass);

            //Link al post
            string permalink = System.Web.HttpContext.Current.Request.Url.AbsolutePath + "?p=" + Pk.ToString();
            //Cerca l'immagine da usare come link 
            string imgPath = System.Web.HttpContext.Current.Server.MapPath(Url2);
            if (!File.Exists(imgPath))
            {
                MagicPostCollection linkedImages = GetChildrenByType(new int[] { MagicPostTypeInfo.ImmagineInGalleria },
                                                                     MagicOrdinamento.Asc, true, 1, false, MagicSearchActive.Both,
                                                                     false);
                if (linkedImages.Count > 0)
                    imgPath = System.Web.HttpContext.Current.Server.MapPath(linkedImages[0].Url);
                else
                    imgPath = System.Web.HttpContext.Current.Server.MapPath(new CMS_Config().DefaultImage);
                if (String.IsNullOrEmpty(imgPath))
                    imgPath = MagicCMSConfiguration.GetConfig().DefaultImage;
            }

            // Se esiste la inserisco nel pannello
            if (File.Exists(imgPath))
            {
                Miniatura min = null;
                try
                {
                    FileInfo fi = new FileInfo(imgPath);
                    min = new Miniatura(imgPath, imgWidth, imgHeight, fi.LastWriteTime);
                    if (min.Pk > 0)
                    {
                        HtmlAnchor a_img = new HtmlAnchor();
                        a_img.Attributes["class"] = "innershadow";
                        a_img.HRef = permalink;
                        HtmlImage img = new HtmlImage();
                        img.Src = "/Min.ashx?pk=" + min.Pk.ToString();
                        img.Attributes["class"] = "banner-img";
                        img.Alt = this.Titolo;
                        a_img.Controls.Add(img);
                        panel.Controls.Add(a_img);
                    }
                }
                finally
                {
                    if (min != null)
                        min.Dispose();
                }

            }

            //Aggiungo il testo

            //Titolo alternativa
            string ilTitolo = this.Title_RT;
            //if (!(String.IsNullOrEmpty(ExtraInfo1) || this.Tipo == MagicPostTypeInfo.Progetto))
            //    ilTitolo = ExtraInfo1;

            if (maxTitleLen > 0)
                ilTitolo = MagicUtils.capAndTrunc(ilTitolo, maxTitleLen, true);

            //Testo alternativo
            string panel_HTMLcontent = TestoBreve_RT;
            //if (String.IsNullOrEmpty(panel_HTMLcontent))
            //    panel_HTMLcontent = TestoLungo_RT;
            panel_HTMLcontent = StringHtmlExtensions.TruncateHtml(panel_HTMLcontent, maxLen, "...");

            //Contenuto
            HtmlGenericControl content = MagicUtils.HTMLElement("div", "content");
            content.Controls.Add(MagicUtils.HTMLElement("h3", "primary-color", ilTitolo));
            content.Controls.Add(MagicUtils.HTMLElement("div", "", panel_HTMLcontent));
            content.Controls.Add(MagicUtils.HTMLElement("p", "text-right last", "<a href=\"" + permalink + "\" class=\"btn custom-btn btn-small btn-very-subtle\">" +
                MagicTransDictionary.Translate("Per saperne di più") + "... </a>"));
            panel.Controls.Add(content);
            return panel;
        }

        public Boolean SetAnswerTo(int postPk)
        {
            if (postPk == 0)
                return false;
            SqlConnection conn = new SqlConnection(MagicUtils.MagicConnectionString);
            SqlCommand cmd = new SqlCommand();
            try
            {
                conn.Open();
                cmd.Connection = conn;
                cmd.CommandText = "  IF NOT EXISTS (SELECT " +
                                    "  		* " +
                                    "  	FROM REL_MESSAGE_REPL_MESSAGE RMRM " +
                                    "  	WHERE RMRM.REL_REPL_MESSAGE_PK = @PostPk " +
                                    "  	AND RMRM.REL_REPL_MESSAGE_REPLTO_PK = @Answer) " +
                                    "  BEGIN " +
                                    "  	INSERT REL_MESSAGE_REPL_MESSAGE (REL_REPL_MESSAGE_PK, " +
                                    "  	REL_REPL_MESSAGE_REPLTO_PK) " +
                                    "  		VALUES (@PostPk, @Answer) " +
                                    "  END ";
                cmd.Parameters.AddWithValue("@PostPk", postPk);
                cmd.Parameters.AddWithValue("@Answer", Pk);
                cmd.ExecuteNonQuery();
                return true;
            }
            catch
            {
                return false;
            }

            finally
            {
                conn.Dispose();
                cmd.Dispose();
            }
        }

        #endregion

        #region StaticMethods

        /// <summary>
        /// Gets Posts by type.
        /// </summary>
        /// <param name="types">The types.</param>
        /// <param name="order">The order.</param>
        /// <param name="inclusive">if set to <c>true</c> include filtered otherwise esclude.</param>
        /// <param name="max">The maximum.</param>
        /// <returns>Fetched post collection</returns>
        public static MagicPostCollection GetByType(int[] types, string order, Boolean inclusive, int max)
        {
            return GetByType(types, order, inclusive, max, true, MagicSearchActive.Both);
        }

        public static MagicPostCollection GetByType(int[] types, string[] keywords, string order, Boolean inclusive, int max)
        {
            WhereClauseCollection query = new WhereClauseCollection();
            string typeList = "";
            for (int i = 0; i < types.Length; i++)
            {
                if (i != 0)
                    typeList += ",";
                typeList += types[i].ToString();
            }

            WhereClause typeClause = new WhereClause()
            {
                LogicalOperator = "AND",
                FieldName = "vmca.Tipo",
                Operator = "IN",
                Value = new ClauseValue("(" + typeList + ")", ClauseValueType.Function)
            };
            if (!inclusive)
                typeClause.Operator = "NOT IN";

            query.Add(typeClause);

            return SearchByKeyword(keywords, order, max, false, query);
        }



        /// <summary>
        /// Gets Posts by type.
        /// </summary>
        /// <param name="types">            Array di interi che enumera i tipi da restituire.</param>
        /// <param name="order">            Ordinamento.</param>
        /// <param name="inclusive">        Includi/escludi i tipi elencati.</param>
        /// <param name="max">              Numero massimo di elementi restituiti.</param>
        /// <param name="escludiScaduti">   Restituisci soli i record con data di scadenza maggiore della data corrente</param>
        /// <param name="active">           Seleziona i record in base al Flag Attivo</param>
        /// <returns>Fetched post collection</returns>
        public static MagicPostCollection GetByType(int[] types, string order, Boolean inclusive, int max, Boolean escludiScaduti, MagicSearchActive active)
        {
            return GetByType(types, order, inclusive, max, escludiScaduti, active, MagicSession.Current.TransAutoHide);
        }


        /// <summary>
        /// Gets Posts by type.
        /// </summary>
        /// <param name="types">            Array di interi che enumera i tipi da restituire.</param>
        /// <param name="order">            Ordinamento.</param>
        /// <param name="inclusive">        Includi/escludi i tipi elencati.</param>
        /// <param name="max">              Numero massimo di elementi restituiti.</param>
        /// <param name="escludiScaduti">   Restituisci soli i record con data di scadenza maggiore della data corrente</param>
        /// <param name="active">           Seleziona i record in base al Flag Attivo</param>
        /// <returns>Fetched post collection</returns>
        public static MagicPostCollection GetByType(int[] types, string order, Boolean inclusive, int max, Boolean escludiScaduti, MagicSearchActive active, Boolean onlyIfTranslated)
        {

            WhereClauseCollection query = new WhereClauseCollection();


            if (escludiScaduti)
            {
                WhereClause scad1 = new WhereClause()
                {
                    LogicalOperator = "AND",
                    FieldName = " ( vmca.DataScadenza",
                    Operator = ">=",
                    Value = new ClauseValue(" getdate() OR vmca.DataScadenza IS NULL) ", ClauseValueType.Function)
                };
                query.Add(scad1);
            }
            string typeList = "";
            for (int i = 0; i < types.Length; i++)
            {
                if (i != 0)
                    typeList += ",";
                typeList += types[i].ToString();
            }

            WhereClause typeClause = new WhereClause()
            {
                LogicalOperator = "AND",
                FieldName = "vmca.Tipo",
                Operator = "IN",
                Value = new ClauseValue("(" + typeList + ")", ClauseValueType.Function)
            };
            if (!inclusive)
                typeClause.Operator = "NOT IN";

            query.Add(typeClause);

            WhereClause activeClause;
            switch (active)
            {
                case MagicSearchActive.ActiveOnly:
                    activeClause = new WhereClause()
                    {
                        LogicalOperator = "AND",
                        FieldName = "vmca.Flag_Attivo",
                        Operator = "=",
                        Value = new ClauseValue(1, ClauseValueType.Number)
                    };
                    query.Add(activeClause);
                    break;
                case MagicSearchActive.NotActiveOnly:
                    activeClause = new WhereClause()
                    {
                        LogicalOperator = "AND",
                        FieldName = "vmca.Flag_Attivo",
                        Operator = "=",
                        Value = new ClauseValue(0, ClauseValueType.Number)
                    };
                    query.Add(activeClause);
                    break;
                case MagicSearchActive.Both:
                    break;
                default:
                    break;
            }



            return new MagicPostCollection(query, order, max, true, false, onlyIfTranslated);


        }

        /// <summary>
        /// Gets Posts by type.
        /// </summary>
        /// <param name="types">            Array di interi che enumera i tipi da restituire.</param>
        /// <param name="order">            Ordinamento.</param>
        /// <param name="inclusive">        Includi/escludi i tipi elencati.</param>
        /// <param name="max">              Numero massimo di elementi restituiti.</param>
        /// <param name="escludiScaduti">   Restituisci soli i record con data di scadenza maggiore della data corrente</param>
        /// <returns>Fetched post collection</returns>
        public static MagicPostCollection GetByType(int[] types, string order, Boolean inclusive, int max, Boolean escludiScaduti)
        {
            return GetByType(types, order, inclusive, max, escludiScaduti, MagicSearchActive.Both);
        }

        ////////////////////////////////////////////////////////////////////////////////////////////////////
        /// <summary>   Restituische i figli di un elemento contenitore per tipo.</summary>
        ///
        /// <remarks>   Bruno, 14/01/2013.</remarks>
        ///
        /// <param name="tipo">     Tipo.</param>
        /// <param name="ordine">   Ordianmento.</param>
        ///
        /// <returns>   Collezione di post.</returns>
        ////////////////////////////////////////////////////////////////////////////////////////////////////

        public static MagicPostCollection GetByType(int tipo, string ordine)
        {
            return GetByType(new int[] { tipo }, ordine, true, -1);
        }

        ////////////////////////////////////////////////////////////////////////////////////////////////////
        /// <summary>   Restituische i figli di un elemento contenitore per tipo.</summary>
        ///
        /// <remarks>   Bruno, 14/01/2013.</remarks>
        ///
        /// <param name="tipo"> Tipo.</param>
        ///
        /// <returns>   Collezione di post.</returns>
        ////////////////////////////////////////////////////////////////////////////////////////////////////

        public static MagicPostCollection GetByType(int tipo)
        {
            return GetByType(new int[] { tipo }, "ASC", true, -1);
        }

        /// <summary>
        /// Restituische i figli di un elemento contenitore per tipo.
        /// </summary>
        /// <param name="tipi">Filtro che limita la ricerca solo a determinati tipi. Se vuoto verranno
        /// reuperati tutti i post.</param>
        /// <returns>
        /// Collezzione di MagicPost.
        /// </returns>
        /// <remarks>
        /// Bruno, 14/01/2013.
        /// </remarks>
        public static MagicPostCollection GetByType(int[] tipi)
        {
            return GetByType(tipi, "ASC", true, -1);
        }

        public static List<int> GetParentsIds(int pk)
        {
            List<int> parents = new List<int>();
            string cmdstring = " SELECT " +
                                " 	rca.Id_Argomenti " +
                                " FROM REL_contenuti_Argomenti rca " +
                                " WHERE rca.Id_Contenuti = @Pk ";
            SqlCommand cmd = null;
            SqlConnection conn = null;
            try
            {
                conn = new SqlConnection(MagicUtils.MagicConnectionString);
                conn.Open();
                cmd = new SqlCommand(cmdstring, conn);
                cmd.Parameters.AddWithValue("@PK", pk);
                SqlDataReader reader = cmd.ExecuteReader();
                if (reader.HasRows)
                {
                    while (reader.Read())
                    {
                        parents.Add(Convert.ToInt32(reader.GetValue(0)));
                    }
                }


            }
            catch (Exception e)
            {
                MagicLog log = new MagicLog("MB_contenuti", pk, LogAction.Delete, e);
                log.Insert();
            }
            finally
            {
                conn.Close();
                //conn.Dispose();
                cmd.Dispose();
            }
            return parents;
        }

        /// <summary>
        /// Gets the page title.
        /// </summary>
        /// <param name="page_id">The page_id.</param>
        /// <returns>Title of the page.</returns>
        public static string GetPageTitle(int page_id)
        {
            string titolo = "";
            SqlConnection conn = new SqlConnection(MagicUtils.MagicConnectionString);
            SqlCommand cmd = new SqlCommand();
            try
            {
                conn.Open();
                cmd.CommandText = "SELECT " +
                                    "	Titolo " +
                                    "FROM " +
                                    "	MB_contenuti " +
                                    "WHERE " +
                                    "	id =  @Pk";

                cmd.Connection = conn;
                cmd.Parameters.AddWithValue("@Pk", page_id);
                SqlDataReader reader = cmd.ExecuteReader(CommandBehavior.SingleRow);
                if (reader.Read())
                {
                    titolo = reader.GetString(0);
                }
            }
            catch (Exception e)
            {
                MagicLog log = new MagicLog("MB_contenuti", page_id, LogAction.Read, e);
                log.Insert();
            }
            finally
            {
                conn.Close();
                //conn.Dispose();
                cmd.Dispose();
            }

            return titolo;
        }


        /// <summary>
        /// Restituisce l'id del menù principale.
        /// </summary>
        /// <returns>
        /// Id del menu (int).
        /// </returns>
        public static int GetMainMenu()
        {
            return GetSpecialItem(MagicPostTypeInfo.Menu);
        }


        /// <summary>
        /// Restituisce l'id del menù secondario.
        /// </summary>
        /// <returns>
        /// Id del menu (int).
        /// </returns>
        public static int GetSecondaryMenu()
        {
            return GetSpecialItem(MagicPostTypeInfo.Menu, "menù secondario", 1000);
        }

        /// <summary>
        /// Restituisce l'id della prima occorenza di una pagina appartenente ad un certo tipo. 
        ///             Utile per recuperare i tipi speciali unici come Home Page, Menù principale, Gruppo 
        ///             pannelli di default, Per recuperare la prima news ecc.
        /// </summary>
        /// <param name="type">Tipo del post da recuperare</param>
        /// <param name="parent_tag">(Opzionale) Il tag a cui appartiene</param>
        /// <param name="ordine">(Opzionale) ordine in cui vanno ordinati i tag</param>
        /// <returns></returns>
        public static int GetSpecialItem(int type, int parent_tag, string ordine)
        {
            return GetSpecialItem(type, parent_tag, ordine, MagicSession.Current.TransAutoHide);
        }
        /// <summary>
        /// Restituisce l'id della prima occorenza di una pagina appartenente ad un certo tipo.
        /// Utile per recuperare i tipi speciali unici come Home Page, Menù principale, Gruppo
        /// pannelli di default, Per recuperare la prima news ecc.
        /// </summary>
        /// <param name="type">Tipo del post da recuperare</param>
        /// <param name="parent_tag">(Opzionale) Il tag a cui appartiene</param>
        /// <param name="ordine">(Opzionale) ordine in cui vanno ordinati i tag</param>
        /// <param name="onlyIfTranslated">if set to <c>true</c> return only records that have 
        /// a translation in the current language.</param>
        /// <returns></returns>
        public static int GetSpecialItem(int type, int parent_tag, string ordine, Boolean onlyIfTranslated)
        {
            string ordinamento = "";
            switch (ordine.ToUpper().Trim())
            {
                case "DESC":
                    ordinamento = " Contenuto_parent DESC, mc.DataPubblicazione DESC ";
                    break;

                case "DATA DESC":
                case "DESC DATA":
                    ordinamento = " mc.DataPubblicazione DESC, Contenuto_parent ASC ";
                    break;

                case "DATA ASC":
                case "ASC DATA":
                    ordinamento = " mc.DataPubblicazione ASC, Contenuto_parent ASC ";
                    break;

                default:
                    ordinamento = " Contenuto_parent ASC, mc.DataPubblicazione DESC ";
                    break;
            }
            int itemId = 0;

            string filter = "";
            if (onlyIfTranslated && MagicSession.Current.CurrentLanguage != "default")
            {
                filter += " AND ( TRAN_LANG_Id = '" + MagicSession.Current.CurrentLanguage + "' ) ";
            }



            SqlConnection conn = new SqlConnection(MagicUtils.MagicConnectionString);
            SqlCommand cmd = new SqlCommand();
            try
            {
                conn.Open();
                cmd.CommandText = "	SELECT TOP 1 " +
                                    "		mc.id " +
                                    "	FROM MB_contenuti mc " +
                                    "	LEFT JOIN REL_contenuti_Argomenti rca " +
                                    "		ON mc.id = rca.Id_Contenuti " +
                                    "   LEFT JOIN ANA_TRANSLATION " +
                                    "       ON mc.id = TRAN_MB_contenuti_Id " +
                                    "	WHERE (mc.Tipo = @tipo AND mc.Flag_Cancellazione = 0) AND (rca.Id_Argomenti = @tag_id OR @tag_id = 0) " +
                                    filter +
                                    "	ORDER BY " + ordinamento;

                cmd.Connection = conn;
                cmd.Parameters.AddWithValue("@tipo", type);
                cmd.Parameters.AddWithValue("@tag_id", parent_tag);

                object result = cmd.ExecuteScalar();
                if (result != null)
                {
                    itemId = (Int32)result;
                }
            }
            catch (Exception e)
            {
                MagicLog log = new MagicLog("MB_contenuti", 0, LogAction.Read, e);
                log.Insert();
            }
            finally
            {
                conn.Close();
                //conn.Dispose();
                cmd.Dispose();
            }

            return itemId;
        }

        public static int GetSpecialItem(int type)
        {
            return GetSpecialItem(type, 0, "");
        }

        /// <summary>
        /// Restituisce l'id della prima occorenza di una pagina appartenente ad un certo
        /// tipo. Utile per recuperare i tipi speciali unici come Home Page, Menù principale, Grppo
        /// pannelli di default ecc.
        /// </summary>
        /// <param name="type">Tipo dell'elemto da reuperare (int).</param>
        /// <param name="title">Titolo dell'elemto da reuperare.</param>
        /// <param name="order">Ordine dell'elemto da reuperare.</param>
        /// <returns>
        /// Id dell'oggetto trovato.
        /// </returns>
        public static int GetSpecialItem(int type, string title, int order)
        {
            int itemId = 0;

            SqlConnection conn = new SqlConnection(MagicUtils.MagicConnectionString);
            SqlCommand cmd = new SqlCommand();
            try
            {
                conn.Open();
                cmd.CommandText = "SELECT TOP 1 " +
                                    "	Id " +
                                    "FROM " +
                                    "	MB_contenuti mc " +
                                    "WHERE " +
                                    "	(Tipo = @type) " +
                                    "	AND (Contenuto_parent =  @order " +
                                    "	OR Titolo =  @title) " +
                                    "	AND Flag_Cancellazione = 0 " +
                                    "ORDER BY " +
                                    " DataPubblicazione DESC ";

                cmd.Connection = conn;
                cmd.Parameters.AddWithValue("@type", type);
                cmd.Parameters.AddWithValue("@order", order);
                cmd.Parameters.AddWithValue("@title", title);

                SqlDataReader reader = cmd.ExecuteReader();
                if (reader.Read())
                {
                    itemId = reader.GetInt32(0);
                }
            }
            catch (Exception e)
            {
                MagicLog log = new MagicLog("MB_contenuti", 0, LogAction.Read, e);
                log.Insert();
            }
            finally
            {
                conn.Close();
                //conn.Dispose();
                cmd.Dispose();
            }

            return itemId;
        }

        /// <summary>
        /// Restituisce l'id della prima occorenza di una pagina appartenente ad un certo
        /// tipo. Utile per recuperare i tipi speciali unici come Home Page, Menù principale, Grppo
        /// pannelli di default ecc.
        /// </summary>
        /// <param name="type">Tipo dell'elemto da reuperare (int).</param>
        /// <param name="title">Titolo dell'elemto da reuperare.</param>
        /// <returns>
        /// Id dell'oggetto trovato.
        /// </returns>
        public static int GetSpecialItem(int type, string title)
        {
            int itemId = 0;

            SqlConnection conn = new SqlConnection(MagicUtils.MagicConnectionString);
            SqlCommand cmd = new SqlCommand();
            try
            {
                conn.Open();
                cmd.CommandText = "SELECT TOP 1 " +
                                    "	Id " +
                                    "FROM " +
                                    "	MB_contenuti mc " +
                                    "WHERE " +
                                    "	((Tipo = @type) OR (@type = 0)) " +
                                    "	AND (Titolo =  @title) " +
                                    "	AND Flag_Cancellazione = 0 " +
                                    "ORDER BY " +
                                    " DataPubblicazione DESC ";

                cmd.Connection = conn;
                cmd.Parameters.AddWithValue("@type", type);
                cmd.Parameters.AddWithValue("@title", title);

                SqlDataReader reader = cmd.ExecuteReader();
                if (reader.Read())
                {
                    itemId = reader.GetInt32(0);
                }
            }
            catch (Exception e)
            {
                MagicLog log = new MagicLog("MB_contenuti", 0, LogAction.Read, e);
                log.Insert();
            }
            finally
            {
                conn.Close();
                //conn.Dispose();
                cmd.Dispose();
            }

            return itemId;
        }

        public static MagicPostCollection GetPostByParentType(int parentType)
        {
            WhereClauseCollection query = new WhereClauseCollection();
            WhereClause q = new WhereClause();
            q.FieldName = "mc.Tipo";
            q.Operator = "=";
            q.Value = new ClauseValue(parentType, ClauseValueType.Number);
            query.Add(q);
            return new MagicPostCollection(query, MagicOrdinamento.Asc, -1, false);
        }

        /// <summary>
        /// Searches Posts by keyword.
        /// </summary>
        /// <param name="keyword">The keyword.</param>
        /// <param name="order">Output order</param>
        /// <returns>Post Collection</returns>
        public static MagicPostCollection SearchByKeyword(string keyword, string order)
        {
            return SearchByKeyword(new string[] { keyword }, order, -1, false, new WhereClauseCollection());
        }

        /// <summary>
        /// Searches Posts by keyword.
        /// </summary>
        /// <param name="keywords">Keywords.</param>
        /// <param name="order">Output order.</param>
        /// <param name="max">Max numeber of post returned.</param>
        /// <param name="onlyIfTranslated">If current lenguare is not defaul language and is <c>true</c> 
        /// posts are returned only if a tranlated version is present, otherwise default language version is returned.</param>
        /// <param name="query">WhereClauseCollection object.</param>
        /// <returns>Post Collection</returns>
        public static MagicPostCollection SearchByKeyword(string[] keywords, string order, int max, Boolean onlyIfTranslated, WhereClauseCollection query)
        {
            if (query == null)
            {
                query = new WhereClauseCollection();
            }

            string keyList = "";
            for (int i = 0; i < keywords.Length; i++)
            {
                if (i != 0)
                    keyList += ",";
                keyList += "'" + keywords[i] + "'";
            }

            WhereClause keyClause = new WhereClause()
            {
                LogicalOperator = WhereClause.AND,
                FieldName = "rk.key_keyword",
                Operator = WhereClause.IN,
                Value = new ClauseValue("(" + keyList + ")", ClauseValueType.Function)
            };
            query.Add(keyClause);

            return new MagicPostCollection(query, order, max, true, false, onlyIfTranslated);
        }

        #endregion
        #region Utilities
        private object StringaData(string str)
        {
            if (str == "")
                return DBNull.Value;
            try
            {
                return DateTime.ParseExact(str, "dd/MM/yyyy", System.Globalization.CultureInfo.InvariantCulture);
            }
            catch (Exception)
            {
                return DBNull.Value;
            }
        }

        #endregion

    }
}