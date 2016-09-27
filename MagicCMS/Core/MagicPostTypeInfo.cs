using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Reflection;
using System.Web;

namespace MagicCMS.Core
{
    public class MagicPostTypeInfo
    {
        #region ContentTypes
        public const int AnnuncioPubblicitario = 49;

        public const int Argomento = 13;

        // Costanti che indicano i tipi di post
        public const int Banner = 50;
        public const int Blog = 5;

        public const int ButtonLanguage = 28;

        public const int BuonaPratica = 53;

        public const int Calendario = 43;

        public const int Cartella = 46;

        public const int Category = 37;
        public const int Categoria = 37;


        public const int CollegamentoInternet = 17;

        public const int CollegamentoInterno = 20;

        //custom
        public const int Custom_1 = 55;

        public const int Database = 41;

        public const int DocumentoScaricabile = 25;

        public const int FakeLink = 54;

        public const int FilmatoFlash = 32;

        public const int FormMail = 79;

        public const int FramePage = 32;

        public const int Galleria = 48;

        public const int GalleriaAutomatica = 29;

        public const int Geolocazione = 53;

        public const int GruppoPannelli = 44;

        public const int GruppoPannelliDefault = 44;

        public const int HomePage = 40;

        public const int ImmagineInGalleria = 30;

        public const int ImpresaCompleta = 62;

        public const int ImpresaDatiRidotti = 63;

        public const int ComingSoon = 10;

        public const int LinkFalso = 54;

        public const int ListaDiDistribuzione = 74;

        public const int Mappa = 57;


        public const int Menu = 15;

        public const int Messaggio = 77;

        public const int Negozio = 57;

        public const int News = 38;

        public const int PaginaAccordion = 51;

        public const int PaginaAutomatica = 29;

        public const int PaginaConPannelliPersonalizzati = 31;

        public const int PaginaContatti = 60;

        public const int PaginaConVideo = 2;

        public const int PaginaDiDownload = 45;

        public const int PaginaDiRicerca = 42;

        public const int PaginaStandard = 1;

        public const int PannelloContenitore = 29;

        public const int ParolaChiaveAreaMercato = 64;


        public const int ParolaChiaveAttStrategica = 66;

        public const int ParolaChiaveBuonePrassi = 70;

        public const int ParolaChiaveIdentificareImpresa = 73;

        public const int PopUp = 64;


        public const int ParolaChiaveProdotto = 65;

        public const int ParolaChiavePuntiDiForza = 71;

        public const int Plugin = 47;

        public const int Preferiti = 46;

        public const int ProductCathegory = 69;

        public const int Product = 68;

        public const int PrerogativaUtente = 75;

        public const int Progettisti = 59;

        public const int Progetto = 55;

        public const int ProgrammGiorno = 3;

        public const int ProgrammOra = 4;

        public const int Provincia = 76;

        public const int Risposta = 78;

        public const int Informativa = 80;

        public const int Section = 72;

        public const int Sequenza = 79;

        public const int SettoreAzienda = 67;


        public const int ShareButton = 65;

        public const int Slide = 56;

        public const int Social = 58;

        public const int Tag = 37;

        public const int Utente = 61;
        public const int User = 61;

        public const int VideoInGalleria = 33;

        public const int VoceGlossario = 52;

        #endregion

        #region Contructor

        public MagicPostTypeInfo(int typeId)
        {
            if (typeId == 0)
            {
                Init();
                return;
            }
            SqlConnection conn = new SqlConnection(MagicUtils.MagicConnectionString);
            SqlCommand cmd = new SqlCommand();
            try
            {
                conn.Open();
                cmd.CommandText = " SELECT " +
                                    " 	act.TYP_PK, " +
                                    " 	act.TYP_NAME, " +
                                    " 	act.TYP_HELP, " +
                                    " 	act.TYP_ContenutiPreferiti, " +
                                    " 	act.TYP_FlagContenitore, " +
                                    " 	act.TYP_label_Titolo, " +
                                    " 	act.TYP_label_ExtraInfo, " +
                                    " 	act.TYP_label_TestoBreve, " +
                                    " 	act.TYP_label_TestoLungo, " +
                                    " 	act.TYP_label_url, " +
                                    " 	act.TYP_label_url_secondaria, " +
                                    " 	act.TYP_label_scadenza, " +
                                    " 	act.TYP_label_altezza, " +
                                    " 	act.TYP_label_larghezza, " +
                                    " 	act.TYP_label_ExtraInfo_1, " +
                                    " 	act.TYP_label_ExtraInfo_2, " +
                                    " 	act.TYP_label_ExtraInfo_3, " +
                                    " 	act.TYP_label_ExtraInfo_4, " +
                                    " 	act.TYP_label_ExtraInfo_5, " +
                                    " 	act.TYP_label_ExtraInfo_6, " +
                                    " 	act.TYP_label_ExtraInfo_7, " +
                                    " 	act.TYP_label_ExtraInfo_8, " +
                                    " 	act.TYP_label_ExtraInfoNumber_1, " +
                                    " 	act.TYP_label_ExtraInfoNumber_2, " +
                                    " 	act.TYP_label_ExtraInfoNumber_3, " +
                                    " 	act.TYP_label_ExtraInfoNumber_4, " +
                                    " 	act.TYP_label_ExtraInfoNumber_5, " +
                                    " 	act.TYP_label_ExtraInfoNumber_6, " +
                                    " 	act.TYP_label_ExtraInfoNumber_7, " +
                                    " 	act.TYP_label_ExtraInfoNumber_8, " +
                                    " 	act.TYP_flag_cercaServer, " +
                                    " 	act.TYP_DataUltimaModifica, " +
                                    " 	act.TYP_Flag_Attivo, " +
                                    " 	act.TYP_Flag_Cancellazione, " +
                                    " 	act.TYP_Data_Cancellazione, " +
                                    " 	act.TYP_flag_breve, " +
                                    " 	act.TYP_flag_lungo, " +
                                    " 	act.TYP_flag_link, " +
                                    " 	act.TYP_flag_urlsecondaria, " +
                                    " 	act.TYP_flag_scadenza, " +
                                    " 	act.TYP_flag_specialTag, " +
                                    " 	act.TYP_flag_tags, " +
                                    " 	act.TYP_flag_altezza, " +
                                    " 	act.TYP_flag_larghezza, " +
                                    " 	act.TYP_flag_ExtraInfo, " +
                                    " 	act.TYP_flag_ExtraInfo1, " +
                                    "   act.TYP_flag_BtnGeolog, " +
                                    "   act.TYP_Icon, " +
                                    "   act.TYP_MasterPageFile " +
                                    " FROM ANA_CONT_TYPE act " +
                                    " WHERE act.TYP_PK = @Pk ";

                cmd.Connection = conn;
                cmd.Parameters.AddWithValue("@Pk", typeId);
                SqlDataReader reader = cmd.ExecuteReader(CommandBehavior.SingleRow);
                if (reader.Read())
                    Init(reader);
                else
                    Init();
            }
            catch (Exception e)
            {
                MagicLog log = new MagicLog("ANA_CONT_TYPE", typeId, LogAction.Read, e);
                log.Insert();
            }
            finally
            {
                conn.Close();
                //conn.Dispose();
                cmd.Dispose();
            }
        }

        public MagicPostTypeInfo(SqlDataReader myRecord)
        {
            Init(myRecord);
        }

        private void Init()
        {
            Pk = 0;
            Nome = "Nuova configurazione";
            ContenutiPreferiti = "";
            Help = "";
            FlagAttivo = true;
            FlagBreve = true;
            FlagBtnGeolog = false;
            FlagCercaServer = true;
            FlagContenitore = false;
            FlagCancellazione = false;
            FlagDimensioni = false;
            FlagExtraInfo = true;
            FlagExtrInfo1 = true;
            FlagFull = true;
            FlagScadenza = false;
            FlagSpecializedInfo = false;
            FlagSpecialTag = false;
            FlagTags = true;
            FlagUrl = true;
            FlagUrlSecondaria = true;
            LabelAltezza = "Altezza";
            LabelExtraInfo = "Geolocazione";
            LabelExtraInfo1 = "Titolo visualizzato";
            LabelExtraInfo2 = "E-mail";
            LabelExtraInfo3 = "";
            LabelExtraInfo4 = "";
            LabelExtraInfo_5 = "";
            LabelExtraInfo_6 = "";
            LabelExtraInfo_7 = "";
            LabelExtraInfo_8 = "";
            LabelExtraInfoNumber_1 = "";
            LabelExtraInfoNumber_2 = "";
            LabelExtraInfoNumber_3 = "";
            LabelExtraInfoNumber_4 = "";
            LabelExtraInfoNumber_5 = "";
            LabelExtraInfoNumber_6 = "";
            LabelExtraInfoNumber_7 = "";
            LabelExtraInfoNumber_8 = "";
            LabelLarghezza = "Larghezza";
            LabelScadenza = "Scadenza";
            LabelTestoBreve = "Descrizione";
            LabelTestoLungo = "Testo";
            LabelUrl = "Url principale";
            LabelUrlSecondaria = "Url secondaria";
            Icon = (this.FlagContenitore ? "fa-folder" : "fa-file-text-o");
        }

        private void Init(SqlDataReader myRecord)
        {
            //" 	act.TYP_PK, " +
            Pk = Convert.ToInt32(myRecord.GetValue(0));
            //" 	act.TYP_NAME, " +
            Nome = !myRecord.IsDBNull(1) ? myRecord.GetValue(1).ToString() : "";
            //" 	act.TYP_HELP, " +
            Help = !myRecord.IsDBNull(2) ? myRecord.GetValue(2).ToString() : "";
            //" 	act.TYP_ContenutiPreferiti, " +
            ContenutiPreferiti = !myRecord.IsDBNull(3) ? myRecord.GetValue(3).ToString() : "";
            //" 	act.TYP_FlagContenitore, " +
            FlagContenitore = !myRecord.IsDBNull(4) ? Convert.ToBoolean(myRecord.GetValue(4)) : false;
            //" 	act.TYP_label_Titolo, " +
            LabelTitolo = !myRecord.IsDBNull(5) ? myRecord.GetValue(5).ToString() : "";
            //" 	act.TYP_label_ExtraInfo, " +
            LabelExtraInfo = !myRecord.IsDBNull(6) ? myRecord.GetValue(6).ToString() : "";
            //" 	act.TYP_label_TestoBreve, " +
            LabelTestoBreve = !myRecord.IsDBNull(7) ? myRecord.GetValue(7).ToString() : "";
            //" 	act.TYP_label_TestoLungo, " +
            LabelTestoLungo = !myRecord.IsDBNull(8) ? myRecord.GetValue(8).ToString() : "";
            //" 	act.TYP_label_url, " +
            LabelUrl = !myRecord.IsDBNull(9) ? myRecord.GetValue(9).ToString() : "";
            //" 	act.TYP_label_url_secondaria, " +
            LabelUrlSecondaria = !myRecord.IsDBNull(10) ? myRecord.GetValue(10).ToString() : "";
            //" 	act.TYP_label_scadenza, " +
            LabelScadenza = !myRecord.IsDBNull(11) ? myRecord.GetValue(11).ToString() : "";
            //" 	act.TYP_label_altezza, " +
            LabelAltezza = !myRecord.IsDBNull(12) ? myRecord.GetValue(12).ToString() : "";
            //" 	act.TYP_label_larghezza, " +
            LabelLarghezza = !myRecord.IsDBNull(13) ? myRecord.GetValue(13).ToString() : "";
            //" 	act.TYP_label_ExtraInfo_1, " +
            LabelExtraInfo1 = !myRecord.IsDBNull(14) ? myRecord.GetValue(14).ToString() : "";
            //" 	act.TYP_label_ExtraInfo_2, " +
            LabelExtraInfo2 = !myRecord.IsDBNull(15) ? myRecord.GetValue(15).ToString() : "";
            //" 	act.TYP_label_ExtraInfo_3, " +
            LabelExtraInfo3 = !myRecord.IsDBNull(16) ? myRecord.GetValue(16).ToString() : "";
            //" 	act.TYP_label_ExtraInfo_4, " +
            LabelExtraInfo4 = !myRecord.IsDBNull(17) ? myRecord.GetValue(17).ToString() : "";
            //" 	act.TYP_label_ExtraInfo_5, " +
            LabelExtraInfo_5 = !myRecord.IsDBNull(18) ? myRecord.GetValue(18).ToString() : "";
            //" 	act.TYP_label_ExtraInfo_6, " +
            LabelExtraInfo_6 = !myRecord.IsDBNull(19) ? myRecord.GetValue(19).ToString() : "";
            //" 	act.TYP_label_ExtraInfo_7, " +
            LabelExtraInfo_7 = !myRecord.IsDBNull(20) ? myRecord.GetValue(20).ToString() : "";
            //" 	act.TYP_label_ExtraInfo_8, " +
            LabelExtraInfo_8 = !myRecord.IsDBNull(21) ? myRecord.GetValue(21).ToString() : "";
            //" 	act.TYP_label_ExtraInfoNumber_1, " +
            LabelExtraInfoNumber_1 = !myRecord.IsDBNull(22) ? myRecord.GetValue(22).ToString() : "";
            //" 	act.TYP_label_ExtraInfoNumber_2, " +
            LabelExtraInfoNumber_2 = !myRecord.IsDBNull(23) ? myRecord.GetValue(23).ToString() : "";
            //" 	act.TYP_label_ExtraInfoNumber_3, " +
            LabelExtraInfoNumber_3 = !myRecord.IsDBNull(24) ? myRecord.GetValue(24).ToString() : "";
            //" 	act.TYP_label_ExtraInfoNumber_4, " +
            LabelExtraInfoNumber_4 = !myRecord.IsDBNull(25) ? myRecord.GetValue(25).ToString() : "";
            //" 	act.TYP_label_ExtraInfoNumber_5, " +
            LabelExtraInfoNumber_5 = !myRecord.IsDBNull(26) ? myRecord.GetValue(26).ToString() : "";
            //" 	act.TYP_label_ExtraInfoNumber_6, " +
            LabelExtraInfoNumber_6 = !myRecord.IsDBNull(27) ? myRecord.GetValue(27).ToString() : "";
            //" 	act.TYP_label_ExtraInfoNumber_7, " +
            LabelExtraInfoNumber_7 = !myRecord.IsDBNull(28) ? myRecord.GetValue(28).ToString() : "";
            //" 	act.TYP_label_ExtraInfoNumber_8, " +
            LabelExtraInfoNumber_8 = !myRecord.IsDBNull(29) ? myRecord.GetValue(29).ToString() : "";
            //" 	act.TYP_flag_cercaServer, " +
            FlagCercaServer = !myRecord.IsDBNull(30) ? Convert.ToBoolean(myRecord.GetValue(30)) : false;
            //" 	act.TYP_DataUltimaModifica, " +
            DataUltimaModifica = !myRecord.IsDBNull(31) ? Convert.ToDateTime(myRecord.GetValue(31)) : DateTime.Now;
            //" 	act.TYP_Flag_Attivo, " +
            FlagAttivo = !myRecord.IsDBNull(32) ? Convert.ToBoolean(myRecord.GetValue(32)) : true;
            //" 	act.TYP_Flag_Cancellazione, " +
            FlagCancellazione = !myRecord.IsDBNull(33) ? Convert.ToBoolean(myRecord.GetValue(33)) : false;
            //" 	act.TYP_Data_Cancellazione, " +
            if (!myRecord.IsDBNull(34))
                DataCancellazione = Convert.ToDateTime(myRecord.GetValue(34));
            else
                DataCancellazione = null;
            //" 	act.TYP_flag_breve, " +
            FlagBreve = !myRecord.IsDBNull(35) ? Convert.ToBoolean(myRecord.GetValue(35)) : false;
            //" 	act.TYP_flag_lungo, " +
            FlagFull = !myRecord.IsDBNull(36) ? Convert.ToBoolean(myRecord.GetValue(36)) : false;
            //" 	act.TYP_flag_link, " +
            FlagUrl = !myRecord.IsDBNull(37) ? Convert.ToBoolean(myRecord.GetValue(37)) : false;
            //" 	act.TYP_flag_urlsecondaria, " +
            FlagUrlSecondaria = !myRecord.IsDBNull(38) ? Convert.ToBoolean(myRecord.GetValue(38)) : false;
            //" 	act.TYP_flag_scadenza, " +
            FlagScadenza = !myRecord.IsDBNull(39) ? Convert.ToBoolean(myRecord.GetValue(39)) : false;
            //" 	act.TYP_flag_specialTag " +
            FlagSpecialTag = !myRecord.IsDBNull(40) ? Convert.ToBoolean(myRecord.GetValue(40)) : false;
            FlagTags = !myRecord.IsDBNull(41) ? Convert.ToBoolean(myRecord.GetValue(41)) : true;
            FlagAltezza = !myRecord.IsDBNull(42) ? Convert.ToBoolean(myRecord.GetValue(42)) : false;
            FlagLarghezza = !myRecord.IsDBNull(43) ? Convert.ToBoolean(myRecord.GetValue(43)) : false;
            FlagExtraInfo = !myRecord.IsDBNull(44) ? Convert.ToBoolean(myRecord.GetValue(44)) : true;
            FlagExtrInfo1 = !myRecord.IsDBNull(45) ? Convert.ToBoolean(myRecord.GetValue(45)) : true;
            FlagBtnGeolog = !myRecord.IsDBNull(46) ? Convert.ToBoolean(myRecord.GetValue(46)) : true;
            string defIcon = (this.FlagContenitore ? "fa-folder" : "fa-file-text-o");
            Icon = !myRecord.IsDBNull(47) ? myRecord.GetValue(47).ToString() : defIcon;
            MasterPageFile = !myRecord.IsDBNull(48) ? myRecord.GetValue(48).ToString() : "";
        }

        #endregion

        #region PublicProperties
        public string ContenutiPreferiti { get; private set; }

        public Nullable<DateTime> DataCancellazione { get; set; }


        public DateTime DataUltimaModifica { get; private set; }

        public string Help { get; private set; }
        public string Descrizione
        {
            get { return Help; }
            set { Help = value; }
        }

        public Boolean FlagAltezza { get; set; }

        public Boolean FlagAttivo { get; private set; }

        public Boolean FlagBreve { get; private set; }

        public Boolean FlagBtnGeolog { get; set; }

        public Boolean FlagCercaServer { get; private set; }

        public Boolean FlagContenitore { get; private set; }

        public Boolean FlagCancellazione { get; private set; }

        public Boolean FlagDimensioni { get; private set; }

        public Boolean FlagExtraInfo { get; private set; }

        public Boolean FlagExtrInfo1 { get; set; }

        public Boolean FlagExtrInfo2
        {
            get
            {
                return (LabelExtraInfo2 != "");
            }
        }

        public Boolean FlagExtrInfo3
        {
            get
            {
                return (LabelExtraInfo3 != "");
            }
        }

        public Boolean FlagExtrInfo4
        {
            get
            {
                return (LabelExtraInfo4 != "");
            }
        }


        public Boolean FlagFull { get; private set; }

        public Boolean FlagLarghezza { get; set; }

        public Boolean FlagScadenza { get; private set; }

        public Boolean FlagSpecializedInfo { get; set; }

        public Boolean FlagSpecialTag { get; set; }

        public Boolean FlagAutoTestoBreve
        {
            get
            {
                return FlagSpecialTag;
            }
            set
            {
                FlagSpecialTag = value; 
            }
        }

        public Boolean FlagTags { get; set; }

        public Boolean FlagUrl { get; private set; }

        public Boolean FlagUrlSecondaria { get; private set; }

        public string Icon { get; set; }

        public string LabelAltezza { get; set; }

        public string LabelExtraInfo { get; set; }

        public string LabelExtraInfo_5 { get; set; }

        public string LabelExtraInfo_6 { get; set; }

        public string LabelExtraInfo_7 { get; set; }

        public string LabelExtraInfo_8 { get; set; }


        public string LabelExtraInfo1 { get; set; }

        public string LabelExtraInfo2 { get; set; }

        public string LabelExtraInfo3 { get; set; }

        public string LabelExtraInfo4 { get; set; }

        public string LabelExtraInfoNumber_1 { get; set; }

        public string LabelExtraInfoNumber_2 { get; set; }

        public string LabelExtraInfoNumber_3 { get; set; }

        public string LabelExtraInfoNumber_4 { get; set; }

        public string LabelExtraInfoNumber_5 { get; set; }

        public string LabelExtraInfoNumber_6 { get; set; }

        public string LabelExtraInfoNumber_7 { get; set; }

        public string LabelExtraInfoNumber_8 { get; set; }

        public string LabelLarghezza { get; set; }

        public string LabelScadenza { get; set; }

        public string LabelTestoBreve { get; set; }

        public string LabelTestoLungo { get; set; }

        public string LabelTitolo { get; set; }

        public string LabelUrl { get; set; }

        public string LabelUrlSecondaria { get; set; }

        public string MasterPageFile { get; set; }

        public string Nome { get; private set; }

        public string NomeExtraInfo
        {
            get { return LabelExtraInfo; }
            set { LabelExtraInfo = value; }
        }

        public int Pk { get; private set; }

        #endregion

        #region PublicMethod
        public int Insert()
        {
            // Se il record di log è già esistente non lo inserisco
            if (Pk > 0) return Pk;

            SqlConnection conn = null;
            SqlCommand cmd = null;
            #region cmdString
            string cmdString = " BEGIN TRY " +
                            " 	BEGIN TRANSACTION " +
                            " 		INSERT ANA_CONT_TYPE ( " +
                            " 			TYP_NAME,  " +
                            " 			TYP_HELP,  " +
                            " 			TYP_ContenutiPreferiti,  " +
                            " 			TYP_FlagContenitore,  " +
                            " 			TYP_label_Titolo,  " +
                            " 			TYP_label_ExtraInfo,  " +
                            " 			TYP_label_TestoBreve,  " +
                            " 			TYP_label_TestoLungo,  " +
                            " 			TYP_label_url,  " +
                            " 			TYP_label_url_secondaria,  " +
                            " 			TYP_label_scadenza,  " +
                            " 			TYP_label_altezza,  " +
                            " 			TYP_label_larghezza,  " +
                            " 			TYP_label_ExtraInfo_1,  " +
                            " 			TYP_label_ExtraInfo_2,  " +
                            " 			TYP_label_ExtraInfo_3,  " +
                            " 			TYP_label_ExtraInfo_4,  " +
                            " 			TYP_label_ExtraInfo_5,  " +
                            " 			TYP_label_ExtraInfo_6,  " +
                            " 			TYP_label_ExtraInfo_7,  " +
                            " 			TYP_label_ExtraInfo_8,  " +
                            " 			TYP_label_ExtraInfoNumber_1,  " +
                            " 			TYP_label_ExtraInfoNumber_2,  " +
                            " 			TYP_label_ExtraInfoNumber_3,  " +
                            " 			TYP_label_ExtraInfoNumber_4,  " +
                            " 			TYP_label_ExtraInfoNumber_5,  " +
                            " 			TYP_label_ExtraInfoNumber_6,  " +
                            " 			TYP_label_ExtraInfoNumber_7,  " +
                            " 			TYP_label_ExtraInfoNumber_8,  " +
                            " 			TYP_flag_cercaServer,  " +
                            " 			TYP_Flag_Attivo,  " +
                            " 			TYP_flag_breve,  " +
                            " 			TYP_flag_lungo,  " +
                            " 			TYP_flag_link,  " +
                            " 			TYP_flag_urlsecondaria,  " +
                            " 			TYP_flag_scadenza,  " +
                            " 			TYP_flag_specialTag,  " +
                            " 	        TYP_flag_tags, " +
                            " 	        TYP_flag_altezza, " +
                            " 	        TYP_flag_larghezza, " +
                            " 	        TYP_flag_ExtraInfo, " +
                            " 	        TYP_flag_ExtraInfo1, " +
                            " 	        TYP_flag_BtnGeolog, " +
                            " 	        TYP_MasterPageFile, " +
                            " 	        TYP_Icon) " +
                            "  " +
                            " 			VALUES ( " +
                            " 				@TYP_NAME,  " +
                            " 				@TYP_HELP,  " +
                            " 				@TYP_ContenutiPreferiti,  " +
                            " 				@TYP_FlagContenitore,  " +
                            " 				@TYP_label_Titolo,  " +
                            " 				@TYP_label_ExtraInfo,  " +
                            " 				@TYP_label_TestoBreve,  " +
                            " 				@TYP_label_TestoLungo,  " +
                            " 				@TYP_label_url,  " +
                            " 				@TYP_label_url_secondaria,  " +
                            " 				@TYP_label_scadenza,  " +
                            " 				@TYP_label_altezza,  " +
                            " 				@TYP_label_larghezza,  " +
                            " 				@TYP_label_ExtraInfo_1,  " +
                            " 				@TYP_label_ExtraInfo_2,  " +
                            " 				@TYP_label_ExtraInfo_3,  " +
                            " 				@TYP_label_ExtraInfo_4,  " +
                            " 				@TYP_label_ExtraInfo_5,  " +
                            " 				@TYP_label_ExtraInfo_6,  " +
                            " 				@TYP_label_ExtraInfo_7,  " +
                            " 				@TYP_label_ExtraInfo_8,  " +
                            " 				@TYP_label_ExtraInfoNumber_1,  " +
                            " 				@TYP_label_ExtraInfoNumber_2,  " +
                            " 				@TYP_label_ExtraInfoNumber_3,  " +
                            " 				@TYP_label_ExtraInfoNumber_4,  " +
                            " 				@TYP_label_ExtraInfoNumber_5,  " +
                            " 				@TYP_label_ExtraInfoNumber_6,  " +
                            " 				@TYP_label_ExtraInfoNumber_7,  " +
                            " 				@TYP_label_ExtraInfoNumber_8,  " +
                            " 				@TYP_flag_cercaServer,  " +
                            " 				@TYP_Flag_Attivo,  " +
                            " 				@TYP_flag_breve,  " +
                            " 				@TYP_flag_lungo,  " +
                            " 				@TYP_flag_link,  " +
                            " 				@TYP_flag_urlsecondaria,  " +
                            " 				@TYP_flag_scadenza,  " +
                            " 				@TYP_flag_specialTag,  " +
                            " 	            @TYP_flag_tags, " +
                            " 	            @TYP_flag_altezza, " +
                            " 	            @TYP_flag_larghezza, " +
                            " 	            @TYP_flag_ExtraInfo, " +
                            " 	            @TYP_flag_ExtraInfo1, " +
                            " 	            @TYP_flag_BtnGeolog, " +
                            " 	            @TYP_MasterPageFile, " +
                            " 	            @TYP_Icon); " +
                            " 				 " +
                            " 	COMMIT TRANSACTION " +
                            " 	SELECT SCOPE_IDENTITY() " +
                            " END TRY " +
                            " BEGIN CATCH " +
                            " 	IF XACT_STATE() <> 0 " +
                            " 	BEGIN " +
                            " 		ROLLBACK TRANSACTION " +
                            " 	END " +
                            " 	SELECT " +
                            " 		ERROR_MESSAGE(); " +
                            " END CATCH; ";


            #endregion
            try
            {
                string cmdText = cmdString;

                conn = new SqlConnection(MagicUtils.MagicConnectionString);
                conn.Open();
                cmd = new SqlCommand(cmdText, conn);
                cmd.Parameters.AddWithValue("@TYP_NAME", Nome);
                cmd.Parameters.AddWithValue("@TYP_HELP", Help);
                cmd.Parameters.AddWithValue("@TYP_ContenutiPreferiti", ContenutiPreferiti);
                cmd.Parameters.AddWithValue("@TYP_FlagContenitore", FlagContenitore);
                cmd.Parameters.AddWithValue("@TYP_label_Titolo", LabelTitolo);
                cmd.Parameters.AddWithValue("@TYP_label_ExtraInfo", LabelExtraInfo);
                cmd.Parameters.AddWithValue("@TYP_label_TestoBreve", LabelTestoBreve);
                cmd.Parameters.AddWithValue("@TYP_label_TestoLungo", LabelTestoLungo);
                cmd.Parameters.AddWithValue("@TYP_label_url", LabelUrl);
                cmd.Parameters.AddWithValue("@TYP_label_url_secondaria", LabelUrlSecondaria);
                cmd.Parameters.AddWithValue("@TYP_label_scadenza", LabelScadenza);
                cmd.Parameters.AddWithValue("@TYP_label_altezza", LabelAltezza);
                cmd.Parameters.AddWithValue("@TYP_label_larghezza", LabelLarghezza);
                cmd.Parameters.AddWithValue("@TYP_label_ExtraInfo_1", LabelExtraInfo1);
                cmd.Parameters.AddWithValue("@TYP_label_ExtraInfo_2", LabelExtraInfo2);
                cmd.Parameters.AddWithValue("@TYP_label_ExtraInfo_3", LabelExtraInfo3);
                cmd.Parameters.AddWithValue("@TYP_label_ExtraInfo_4", LabelExtraInfo4);
                cmd.Parameters.AddWithValue("@TYP_label_ExtraInfo_5", LabelExtraInfo_5);
                cmd.Parameters.AddWithValue("@TYP_label_ExtraInfo_6", LabelExtraInfo_6);
                cmd.Parameters.AddWithValue("@TYP_label_ExtraInfo_7", LabelExtraInfo_7);
                cmd.Parameters.AddWithValue("@TYP_label_ExtraInfo_8", LabelExtraInfo_8);
                cmd.Parameters.AddWithValue("@TYP_label_ExtraInfoNumber_1", LabelExtraInfoNumber_1);
                cmd.Parameters.AddWithValue("@TYP_label_ExtraInfoNumber_2", LabelExtraInfoNumber_2);
                cmd.Parameters.AddWithValue("@TYP_label_ExtraInfoNumber_3", LabelExtraInfoNumber_3);
                cmd.Parameters.AddWithValue("@TYP_label_ExtraInfoNumber_4", LabelExtraInfoNumber_4);
                cmd.Parameters.AddWithValue("@TYP_label_ExtraInfoNumber_5", LabelExtraInfoNumber_5);
                cmd.Parameters.AddWithValue("@TYP_label_ExtraInfoNumber_6", LabelExtraInfoNumber_6);
                cmd.Parameters.AddWithValue("@TYP_label_ExtraInfoNumber_7", LabelExtraInfoNumber_7);
                cmd.Parameters.AddWithValue("@TYP_label_ExtraInfoNumber_8", LabelExtraInfoNumber_8);
                cmd.Parameters.AddWithValue("@TYP_flag_cercaServer", FlagCercaServer);
                cmd.Parameters.AddWithValue("@TYP_Flag_Attivo", FlagAttivo);
                cmd.Parameters.AddWithValue("@TYP_flag_breve", FlagBreve);
                cmd.Parameters.AddWithValue("@TYP_flag_lungo", FlagFull);
                cmd.Parameters.AddWithValue("@TYP_flag_link", FlagUrl);
                cmd.Parameters.AddWithValue("@TYP_flag_urlsecondaria", FlagUrlSecondaria);
                cmd.Parameters.AddWithValue("@TYP_flag_scadenza", FlagScadenza);
                cmd.Parameters.AddWithValue("@TYP_flag_specialTag", FlagSpecialTag);
                cmd.Parameters.AddWithValue("@TYP_flag_tags", FlagTags);
                cmd.Parameters.AddWithValue("@TYP_flag_altezza", FlagAltezza);
                cmd.Parameters.AddWithValue("@TYP_flag_larghezza", FlagLarghezza);
                cmd.Parameters.AddWithValue("@TYP_flag_ExtraInfo", FlagExtraInfo);
                cmd.Parameters.AddWithValue("@TYP_flag_ExtraInfo1", FlagExtrInfo1);
                cmd.Parameters.AddWithValue("@TYP_flag_BtnGeolog", FlagBtnGeolog);
                cmd.Parameters.AddWithValue("@TYP_Icon", Icon);
                cmd.Parameters.AddWithValue("@TYP_MasterPageFile", MasterPageFile);
                string result = cmd.ExecuteScalar().ToString();
                int pk;
                if (int.TryParse(result, out pk))
                {
                    MagicLog log = new MagicLog("ANA_CONT_type", pk, LogAction.Insert, "", "");
                    log.Error = "Success";
                    log.Insert();
                }
                else
                {
                    MagicLog log = new MagicLog("ANA_CONT_type", pk, LogAction.Insert, "", "");
                    log.Error = result;
                    log.Insert();
                }
                Pk = pk;
            }
            catch (Exception e)
            {
                MagicLog log = new MagicLog("ANA_CONT_TYPE", Pk, LogAction.Insert, e);
                log.Insert();
            }
            finally
            {
                if (conn != null)
                    conn.Dispose();
                if (cmd != null)
                    cmd.Dispose();
            }
            return Pk;
        }

        public Boolean Update()
        {
            // Se il record di log è già esistente non lo inserisco
            SqlConnection conn = null;
            SqlCommand cmd = null;
            #region cmdString
            string cmdString = " BEGIN TRY " +
                                " 	BEGIN TRANSACTION " +
                                " 		UPDATE ANA_CONT_TYPE " +
                                " 		SET	TYP_NAME = @TYP_NAME, " +
                                " 			TYP_HELP = @TYP_HELP, " +
                                " 			TYP_ContenutiPreferiti = @TYP_ContenutiPreferiti, " +
                                " 			TYP_FlagContenitore = @TYP_FlagContenitore, " +
                                " 			TYP_label_Titolo = @TYP_label_Titolo, " +
                                " 			TYP_label_ExtraInfo = @TYP_label_ExtraInfo, " +
                                " 			TYP_label_TestoBreve = @TYP_label_TestoBreve, " +
                                " 			TYP_label_TestoLungo = @TYP_label_TestoLungo, " +
                                " 			TYP_label_url = @TYP_label_url, " +
                                " 			TYP_label_url_secondaria = @TYP_label_url_secondaria, " +
                                " 			TYP_label_scadenza = @TYP_label_scadenza, " +
                                " 			TYP_label_altezza = @TYP_label_altezza, " +
                                " 			TYP_label_larghezza = @TYP_label_larghezza, " +
                                " 			TYP_label_ExtraInfo_1 = @TYP_label_ExtraInfo_1, " +
                                " 			TYP_label_ExtraInfo_2 = @TYP_label_ExtraInfo_2, " +
                                " 			TYP_label_ExtraInfo_3 = @TYP_label_ExtraInfo_3, " +
                                " 			TYP_label_ExtraInfo_4 = @TYP_label_ExtraInfo_4, " +
                                " 			TYP_label_ExtraInfo_5 = @TYP_label_ExtraInfo_5, " +
                                " 			TYP_label_ExtraInfo_6 = @TYP_label_ExtraInfo_6, " +
                                " 			TYP_label_ExtraInfo_7 = @TYP_label_ExtraInfo_7, " +
                                " 			TYP_label_ExtraInfo_8 = @TYP_label_ExtraInfo_8, " +
                                " 			TYP_label_ExtraInfoNumber_1 = @TYP_label_ExtraInfoNumber_1, " +
                                " 			TYP_label_ExtraInfoNumber_2 = @TYP_label_ExtraInfoNumber_2, " +
                                " 			TYP_label_ExtraInfoNumber_3 = @TYP_label_ExtraInfoNumber_3, " +
                                " 			TYP_label_ExtraInfoNumber_4 = @TYP_label_ExtraInfoNumber_4, " +
                                " 			TYP_label_ExtraInfoNumber_5 = @TYP_label_ExtraInfoNumber_5, " +
                                " 			TYP_label_ExtraInfoNumber_6 = @TYP_label_ExtraInfoNumber_6, " +
                                " 			TYP_label_ExtraInfoNumber_7 = @TYP_label_ExtraInfoNumber_7, " +
                                " 			TYP_label_ExtraInfoNumber_8 = @TYP_label_ExtraInfoNumber_8, " +
                                " 			TYP_flag_cercaServer = @TYP_flag_cercaServer, " +
                                " 			TYP_DataUltimaModifica = GETDATE(), " +
                                " 			TYP_Flag_Attivo = @TYP_Flag_Attivo, " +
                                " 			TYP_flag_breve = @TYP_flag_breve, " +
                                " 			TYP_flag_lungo = @TYP_flag_lungo, " +
                                " 			TYP_flag_link = @TYP_flag_link, " +
                                " 			TYP_flag_urlsecondaria = @TYP_flag_urlsecondaria, " +
                                " 			TYP_flag_scadenza = @TYP_flag_scadenza, " +
                                " 			TYP_flag_specialTag = @TYP_flag_specialTag, " +
                                " 			TYP_flag_tags = @TYP_flag_tags, " +
                                " 			TYP_flag_altezza = @TYP_flag_altezza, " +
                                " 			TYP_flag_larghezza = @TYP_flag_larghezza, " +
                                " 			TYP_flag_ExtraInfo = @TYP_flag_ExtraInfo, " +
                                " 			TYP_flag_ExtraInfo1 = @TYP_flag_ExtraInfo1, " +
                                " 			TYP_flag_BtnGeolog = @TYP_flag_BtnGeolog, " +
                                " 			TYP_Icon = @TYP_Icon, " +
                                " 			TYP_MasterPageFile = @TYP_MasterPageFile " +
                                " 		WHERE TYP_PK = @PK " +
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


            #endregion
            try
            {
                string cmdText = cmdString;

                conn = new SqlConnection(MagicUtils.MagicConnectionString);
                conn.Open();
                cmd = new SqlCommand(cmdText, conn);
                cmd.Parameters.AddWithValue("@TYP_NAME", Nome);
                cmd.Parameters.AddWithValue("@TYP_HELP", Help);
                cmd.Parameters.AddWithValue("@TYP_ContenutiPreferiti", ContenutiPreferiti);
                cmd.Parameters.AddWithValue("@TYP_FlagContenitore", FlagContenitore);
                cmd.Parameters.AddWithValue("@TYP_label_Titolo", LabelTitolo);
                cmd.Parameters.AddWithValue("@TYP_label_ExtraInfo", LabelExtraInfo);
                cmd.Parameters.AddWithValue("@TYP_label_TestoBreve", LabelTestoBreve);
                cmd.Parameters.AddWithValue("@TYP_label_TestoLungo", LabelTestoLungo);
                cmd.Parameters.AddWithValue("@TYP_label_url", LabelUrl);
                cmd.Parameters.AddWithValue("@TYP_label_url_secondaria", LabelUrlSecondaria);
                cmd.Parameters.AddWithValue("@TYP_label_scadenza", LabelScadenza);
                cmd.Parameters.AddWithValue("@TYP_label_altezza", LabelAltezza);
                cmd.Parameters.AddWithValue("@TYP_label_larghezza", LabelLarghezza);
                cmd.Parameters.AddWithValue("@TYP_label_ExtraInfo_1", LabelExtraInfo1);
                cmd.Parameters.AddWithValue("@TYP_label_ExtraInfo_2", LabelExtraInfo2);
                cmd.Parameters.AddWithValue("@TYP_label_ExtraInfo_3", LabelExtraInfo3);
                cmd.Parameters.AddWithValue("@TYP_label_ExtraInfo_4", LabelExtraInfo4);
                cmd.Parameters.AddWithValue("@TYP_label_ExtraInfo_5", LabelExtraInfo_5);
                cmd.Parameters.AddWithValue("@TYP_label_ExtraInfo_6", LabelExtraInfo_6);
                cmd.Parameters.AddWithValue("@TYP_label_ExtraInfo_7", LabelExtraInfo_7);
                cmd.Parameters.AddWithValue("@TYP_label_ExtraInfo_8", LabelExtraInfo_8);
                cmd.Parameters.AddWithValue("@TYP_label_ExtraInfoNumber_1", LabelExtraInfoNumber_1);
                cmd.Parameters.AddWithValue("@TYP_label_ExtraInfoNumber_2", LabelExtraInfoNumber_2);
                cmd.Parameters.AddWithValue("@TYP_label_ExtraInfoNumber_3", LabelExtraInfoNumber_3);
                cmd.Parameters.AddWithValue("@TYP_label_ExtraInfoNumber_4", LabelExtraInfoNumber_4);
                cmd.Parameters.AddWithValue("@TYP_label_ExtraInfoNumber_5", LabelExtraInfoNumber_5);
                cmd.Parameters.AddWithValue("@TYP_label_ExtraInfoNumber_6", LabelExtraInfoNumber_6);
                cmd.Parameters.AddWithValue("@TYP_label_ExtraInfoNumber_7", LabelExtraInfoNumber_7);
                cmd.Parameters.AddWithValue("@TYP_label_ExtraInfoNumber_8", LabelExtraInfoNumber_8);
                cmd.Parameters.AddWithValue("@TYP_flag_cercaServer", FlagCercaServer);
                cmd.Parameters.AddWithValue("@TYP_Flag_Attivo", FlagAttivo);
                cmd.Parameters.AddWithValue("@TYP_flag_breve", FlagBreve);
                cmd.Parameters.AddWithValue("@TYP_flag_lungo", FlagFull);
                cmd.Parameters.AddWithValue("@TYP_flag_link", FlagUrl);
                cmd.Parameters.AddWithValue("@TYP_flag_urlsecondaria", FlagUrlSecondaria);
                cmd.Parameters.AddWithValue("@TYP_flag_scadenza", FlagScadenza);
                cmd.Parameters.AddWithValue("@TYP_flag_specialTag", FlagSpecialTag);
                cmd.Parameters.AddWithValue("@TYP_flag_tags", FlagTags);
                cmd.Parameters.AddWithValue("@TYP_flag_altezza", FlagAltezza);
                cmd.Parameters.AddWithValue("@TYP_flag_larghezza", FlagLarghezza);
                cmd.Parameters.AddWithValue("@TYP_flag_ExtraInfo", FlagExtraInfo);
                cmd.Parameters.AddWithValue("@TYP_flag_ExtraInfo1", FlagExtrInfo1);
                cmd.Parameters.AddWithValue("@TYP_flag_BtnGeolog", FlagBtnGeolog);
                cmd.Parameters.AddWithValue("@TYP_Icon", Icon);
                cmd.Parameters.AddWithValue("@TYP_MasterPageFile", MasterPageFile);
                cmd.Parameters.AddWithValue("@PK", Pk);

                string result = cmd.ExecuteScalar().ToString();
                int pk;
                if (int.TryParse(result, out pk))
                {
                    MagicLog log = new MagicLog("ANA_CONT_TYPE", pk, LogAction.Update, "", "");
                    log.Error = "Success";
                    log.Insert();
                }
                else
                {
                    MagicLog log = new MagicLog("ANA_CONT_TYPE", pk, LogAction.Update, "", "");
                    log.Error = result;
                    log.Insert();
                }
                Pk = pk;
            }
            catch (Exception e)
            {
                MagicLog log = new MagicLog("ANA_CONT_TYPE", Pk, LogAction.Update, e);
                log.Insert();
            }
            finally
            {
                if (conn != null)
                    conn.Dispose();
                if (cmd != null)
                    cmd.Dispose();
            }
            return (Pk > 0);
        }

        public Boolean Delete()
        {
            string message;
            return Delete(out  message);
        }

        /// <summary>
        /// Deletes this instance.
        /// </summary>
        /// <param name="message">Return message.</param>
        /// <returns></returns>
        public Boolean Delete(out string message)
        {
            // Se il record di log è già esistente non lo inserisco
            message = "Record cancellato con successo.";
            SqlConnection conn = null;
            SqlCommand cmd = null;
            #region cmdString
            string cmdString;
            if (FlagCancellazione)
            {
                cmdString = " BEGIN TRY " +
                                " 	BEGIN TRANSACTION " +
                                " 		DELETE ANA_CONT_TYPE " +
                                " 		WHERE TYP_PK = @PK " +
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
                cmdString = " BEGIN TRY " +
                                " 	BEGIN TRANSACTION " +
                                " 		UPDATE ANA_CONT_TYPE " +
                                " 		SET  " +
                                " 			TYP_Flag_Cancellazione = 1, " +
                                " 			TYP_Data_Cancellazione = GETDATE() " +
                                " 		WHERE TYP_PK = @PK " +
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

            #endregion
            try
            {
                string cmdText = cmdString;

                conn = new SqlConnection(MagicUtils.MagicConnectionString);
                conn.Open();
                cmd = new SqlCommand(cmdText, conn);

                cmd.Parameters.AddWithValue("@PK", Pk);

                string result = cmd.ExecuteScalar().ToString();
                int pk;
                if (int.TryParse(result, out pk))
                {
                    MagicLog log = new MagicLog("ANA_CONT_TYPE", pk, LogAction.Delete, "", "");
                    log.Error = "Success";
                    log.Insert();
                }
                else
                {
                    MagicLog log = new MagicLog("ANA_CONT_TYPE", pk, LogAction.Delete, "", "");
                    log.Error = result;
                    log.Insert();
                    message = result;
                }
                Pk = pk;
            }
            catch (Exception e)
            {
                MagicLog log = new MagicLog("ANA_CONT_TYPE", Pk, LogAction.Delete, e);
                log.Insert();
                message = e.Message;
            }
            finally
            {
                if (conn != null)
                    conn.Dispose();
                if (cmd != null)
                    cmd.Dispose();
            }
            return (Pk > 0);
        }

        public Boolean UnDelete(out string message)
        {
            message = "Record recuperato con successo";
            SqlConnection conn = null;
            SqlCommand cmd = null;
            #region cmdString
            string cmdString = " BEGIN TRY " +
                                " 	BEGIN TRANSACTION " +
                                " 		UPDATE ANA_CONT_TYPE " +
                                " 		SET  " +
                                " 			TYP_Flag_Cancellazione = 0 " +
                                " 		WHERE TYP_PK = @PK " +
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
            #endregion
            try
            {
                string cmdText = cmdString;

                conn = new SqlConnection(MagicUtils.MagicConnectionString);
                conn.Open();
                cmd = new SqlCommand(cmdText, conn);

                cmd.Parameters.AddWithValue("@PK", Pk);

                string result = cmd.ExecuteScalar().ToString();
                int pk;
                if (int.TryParse(result, out pk))
                {
                    MagicLog log = new MagicLog("ANA_CONT_TYPE", pk, LogAction.Undelete, "", "");
                    log.Error = "Success";
                    log.Insert();
                }
                else
                {
                    MagicLog log = new MagicLog("ANA_CONT_TYPE", pk, LogAction.Undelete, "", "");
                    log.Error = result;
                    log.Insert();
                    message = result;
                }
                Pk = pk;
            }
            catch (Exception e)
            {
                MagicLog log = new MagicLog("ANA_CONT_TYPE", Pk, LogAction.Undelete, e);
                log.Insert();
                message = e.Message;
            }
            finally
            {
                if (conn != null)
                    conn.Dispose();
                if (cmd != null)
                    cmd.Dispose();
            }
            return (Pk > 0);
        }

        public Boolean MergeContext(HttpContext context, string[] propertyList, out string msg)
        {
            Boolean result = true;
            msg = "Success";
            Type TheType = typeof(MagicPostTypeInfo);
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
                        else if (propType.Equals(typeof(Boolean)))
                        {
                            bool b;
                            bool.TryParse(context.Request[propName], out b);
                            this[propName] = b;
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

        #region Static methods

        public static int RecordCount()
        {
            SqlConnection conn = null;
            SqlCommand cmd = null;
            int count = 0;
            #region cmdString
            string cmdString = " BEGIN TRY " +
                                " 	SELECT " +
                                " 		COUNT(*) " +
                                " 	FROM vw_ANA_CONT_TYPE_ACTIVE vacta " +
                                " END TRY " +
                                " BEGIN CATCH " +
                                " 	SELECT " +
                                " 		ERROR_MESSAGE(); " +
                                " END CATCH; ";
            #endregion
            try
            {
                string cmdText = cmdString;

                conn = new SqlConnection(MagicUtils.MagicConnectionString);
                conn.Open();

                cmd = new SqlCommand(cmdText, conn);
                string result = cmd.ExecuteScalar().ToString();
                if (!int.TryParse(result, out count))
                //{
                //    MagicLog log = new MagicLog("vw_ANA_CONT_TYPE_ACTIVE", 0, LogAction.Read, "", "");
                //    log.Error = "Success";
                //    log.Insert();
                //}
                //else
                {
                    MagicLog log = new MagicLog("vw_ANA_CONT_TYPE_ACTIVE", 0, LogAction.Read, "", "");
                    log.Error = result;
                    log.Insert();
                }

            }
            catch (Exception e)
            {
                MagicLog log = new MagicLog("ANA_CONT_TYPE", 0, LogAction.Read, e);
                log.Insert();
            }
            finally
            {
                if (conn != null)
                    conn.Dispose();
                if (cmd != null)
                    cmd.Dispose();
            }
            return count;
        }

        #endregion
    }
}