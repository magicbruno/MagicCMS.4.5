using MagicCMS.Routing;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Reflection;
using System.Web;

namespace MagicCMS.Core
{
	/// <summary>
	/// MagicPostTypeInfo is a wrapper class for MagicPost <see cref="MagicCMS.Core.MagicPost.Tipo"/> definition. It manages MagicPost types definitions stored in 
	/// MagicCMS database.<br></br>
	/// "Tipo" is the key property of MagicPost. Trough MagicPost type definition table where you can:
	/// <list type="bullet">
	///		<item>
	///			<description>Define if post is a container (can be parent of other posts). </description>
	///		</item>
	///		<item>
	///			<description>Specify which fields  are exposed (the editor can set values) an which are hidden in back end. </description>
	///		</item>
	///		<item>
	///			<description>Specify which labels are shown for every MagicPost field in back end. </description>
	///		</item>
	///		<item>
	///			<description>Define if post has an expiration. </description>
	///		</item>
	///		<item>
	///			<description>If post can be rendered as an html page, specify which page template (a ASP.NET MasterPage) will be used to render it.</description>
	///		</item>
	///		<item>
	///			<description>Specify an (HTML formatted) help text which editor can consult.</description>
	///		</item>
	/// </list>		
	/// The first purpose of MagicPost definition is to build a back end tailored on final user needs. The second is to allow the construction of MagicCMS templates based on 
	/// MasterPages writing the smallest possible number of lines of code.<br></br>
	/// MagicPostTypeInfo class define a number of integer constants corresponding to unique IDs of MagicPost type definition inserted by default in database types table. 
	/// In this way developers can exploit the advantages of editor code completion and enjoy a more friendly approach to MagicPost types.<br></br>
	/// Generally you can freely define, rename and add new MagicPost type definitions. The MagicCMS back end offers to you a friendly interface to do this. However few types 
	/// are handled by MagicCMS engine in some special way. See MagicPostTypeInfo Fields documentation for details.
	/// </summary>
	public class MagicPostTypeInfo
	{
		#region ContentTypes

		/// <exclude />
		public const int PaginaStandard = 1;
		/// <summary>
		/// <b>Aliases</b>: PaginaStandard.<br></br>
		/// <b>Type name</b>: Pagina Standard.<br></br>
		/// <b>Suggested use</b>: Render as HTML page using proper MasterPage o as home page section in mono page application depending on MagicCMS theme.<br></br>
		/// </summary>
		public const int Page = 1;


		/// <exclude />
		public const int PaginaConVideo = 2;
		/// <summary>
		/// <b>Aliases</b>: PaginaConVideo.<br></br>
		/// <b>Type name</b>: Pagina con video.<br></br>
		/// <b>Suggested use</b>: Render as HTML page using proper MasterPage o as home page section in mono page application depending on MagicCMS theme. 
		/// You may need a special rendering for pages with embedded video<br></br>
		/// </summary>
		public const int PageWithVideo = 2;

		/// <exclude />
		public const int ProgrammGiorno = 3;
		/// <exclude />
		public const int ProgrammaGiorno = 3;
		/// <exclude />
		public const int SchedulerDay = 3;

		/// <exclude />
		public const int ProgrammOra = 4;
		/// <exclude />
		public const int ProgrammaOra = 4;
		/// <exclude />
		public const int SchedulerHour = 4;

		/// <summary>
		/// <b>Type name</b>: Blog.<br></br>
		/// <b>Suggested use</b>: Group of children MagicPost (<see cref="MagicPostTypeInfo.Page"/> or other types) to be rendered as HTML page using proper MasterPage. 
		/// Similar to <see cref="MagicPostTypeInfo.Topic"/> and to <see cref="MagicPostTypeInfo.Cathegory"/>  Allow to design a special rendering for blog section of your site.<br></br>
		/// </summary>
		public const int Blog = 5;

		/// <summary>
		/// <b>Type name</b>: Coming soon.<br></br>
		/// <b>Suggested use</b>: Render as HTML page using proper MasterPage o as home page section in mono page application depending on MagicCMS theme. <br></br>
		/// <b>Note</b>: You may use this type to render a coming soon page. Code to implement page behavior is on your charge. <br></br>
		/// </summary>
		public const int ComingSoon = 10;

		/// <exclude />
		public const int Argomento = 13;
		/// <exclude />
		public const int Argument = 13;
		/// <summary>
		/// <b>Aliases</b>: Argument, Argomento.<br></br>
		/// <b>Type name</b>: Argomento.<br></br>
		/// <b>Suggested use</b>: Generic group of children MagicPost (<see cref="MagicPostTypeInfo.Page"/> or any other type) to be rendered as HTML page 
		/// using proper MasterPage o as home page section in mono page application depending on MagicCMS theme.o<br></br>
		/// </summary>
		public const int Topic = 13;

		/// <summary>
		/// <b>Type name</b>: Custom Page 2.<br></br>
		/// <b>Suggested use</b>: To be rendered as an HTML page using proper MasterPage. You may use to handle custom <see cref="MagicCMS.Core.MagicPost"/> type.
		/// </summary>
		public const int CustomPage2 = 14;


		/// <summary>
		/// <b>Type name</b>: Menu.<br></br>
		/// <b>Use</b>: Use Menu type to create menus and submenus. Children MagicPost in a Menu are rendered as menu item, children menus as submenu.<br></br>
		/// <b>Important</b>: Menu type is handled by MagicCMS engine in a special way.<br></br>
		/// </summary>
		public const int Menu = 15;

		/// <exclude />
		public const int CollegamentoInternet = 17;
		/// <summary>
		/// <b>Aliases</b>: CollegamentoInternet.<br></br>
		/// <b>Type name</b>: Collegamento internet.<br></br>
		/// <b>Use</b>: Simply a link to an other site over The Internet with some additional settings.<br></br>
		/// <b>Important</b>: ExternalLink type is handled by MagicCMS engine in a special way.<br></br>
		/// </summary>
		public const int ExternalLink = 17;


		/// <exclude />
		public const int CollegamentoInterno = 20;
		/// <summary>
		/// <b>Aliases</b>: CollegamentoInterno.<br></br>
		/// <b>Type name</b>: Collegamento a una pagina interna.<br></br>
		/// <b>Use</b>: Simply a link to an other page of the site with some additional settings.<br></br>
		/// <b>Important</b>: InternalLink type is handled by MagicCMS engine in a special way.<br></br>
		/// </summary>
		public const int InternalLink = 20;

		/// <exclude />
		public const int DocumentoScaricabile = 25;
		/// <summary>
		/// <b>Aliases</b>: DocumentoScaricabile.<br></br>
		/// <b>Type name</b>: Documento scaricabile.<br></br>
		/// <b>Use</b>: Link to a document address in the same domain of the site with some additional settings.<br></br>
		/// <b>Important</b>: DocumentDownload type is handled by MagicCMS engine in a special way.<br></br>
		/// </summary>
		public const int DocumentDownload = 25;

		/// <summary>
		/// <b>Type name</b>: Documento scaricabile.<br></br>
		/// <b>Use</b>: Button you may insert in a Menu to change current language of the site.<br></br>
		/// <b>Important</b>: ButtonLanguage type is handled by MagicCMS engine in a special way.<br></br>
		/// </summary>
		public const int ButtonLanguage = 28;

		/// <exclude />
		public const int GalleriaAutomatica = 29;
		/// <summary>
		/// <b>Aliases</b>: GalleriaAutomatica, PaginaAutomatica.<br></br>
		/// <b>Type name</b>: Galleria automatica<br></br>
		/// <b>Suggested use</b>: To be rendered as an HTML page presenting a photo gallery generated automatically from images contained in a directory. Handling of automatic 
		/// gallery is done writing proper MasterPage code using utilities provided by MagicCMS library. 
		/// </summary>
		public const int AutoImageGallery = 29;

		/// <exclude />
		public const int PaginaAutomatica = 29;

		/// <exclude />
		public const int PannelloContenitore = 29;

		/// <exclude />
		public const int ImmagineInGalleria = 30;
		/// <summary>
		/// <b>Aliases</b>: ImmagineInGalleria.<br></br>
		/// <b>Type name</b>: Immagine<br></br>
		/// <b>Suggested use</b>: Use this type to insert images in non Automatic Galleries or in other contexts. Using a MagicPost to define images let editor specify custom 
		/// properties on Back End side like dimensions, title, description, ecc. and then render it on front end with proper code.
		/// </summary>
		public const int Image = 30;

		/// <exclude />
		public const int PaginaConPannelliPersonalizzati = 31;
		/// <summary>
		/// <b>Aliases</b>: PaginaConPannelliPersonalizzati.<br></br>
		/// <b>Type name</b>: Pagina con Pannelli Personalizzati.<br></br>
		/// <b>Suggested use</b>: To be rendered as an HTML page using proper MasterPage o as home page section in mono page application. Same that 
		/// <see cref="MagicPostTypeInfo.Page"/> but it may have children MagicPost instances.
		/// </summary>
		public const int CustomPage = 31;

		/// <exclude />
		public const int FilmatoFlash = 32;
		/// <exclude />
		public const int FramePage = 32;

		/// <exclude />
		public const int VideoInGalleria = 33;
		/// <summary>
		/// <b>Aliases</b>: VideoInGalleria.<br></br>
		/// <b>Type name</b>: Video<br></br>
		/// <b>Suggested use</b>: Use this type to insert videos in Galleries or in other contexts. Using a MagicPost to define a video let specify custom 
		/// properties on Back End side like dimensions, title, description, ecc. and then render it on front end with proper code.
		/// </summary>
		public const int Video = 33;

		/// <summary>
		/// <b>Aliases</b>: Categoria.<br></br>
		/// <b>Type name</b>: Categoria.<br></br>
		/// <b>Suggested use</b>: Generic group of children MagicPost of any type to be rendered as HTML page using proper MasterPage or as home page section 
		/// in mono page application (behavior is defined by MagicCMS theme). Very similar to <see cref="MagicPostTypeInfo.Topic"/> allow an alternative type of grouping 
		/// with an alternative rendering.<br></br>
		/// </summary>
		public const int Category = 37;
		/// <exclude />
		public const int Categoria = 37;
		/// <exclude />
		public const int Tag = 37;

		/// <summary>
		/// <b>Type name</b>: News.<br></br>
		/// <b>Suggested use</b>: To be rendered as an HTML page using proper MasterPage. Same that 
		/// <see cref="MagicPostTypeInfo.Page"/> but normally it has an expiration and may have children MagicPost instances.
		/// </summary>
		public const int News = 38;

		/// <summary>
		/// <b>Type name</b>: Home page.<br></br>
		/// <b>Use</b>: An home landing page on monopage application or first page of a site with a specific rendering.<br></br>
		/// <b>Important</b>: HomePage type is handled by MagicCMS engine in a special way.<br></br>
		/// </summary>
		public const int HomePage = 40;

		/// <exclude />
		public const int Database = 41;

		/// <exclude />
		public const int PaginaDiRicerca = 42;
		/// <summary>
		/// <b>Aliases</b>: PaginaDiRicerca.<br></br>
		/// <b>Type name</b>: Pagina di ricerca.<br></br>
		/// <b>Suggested use</b>: Useful to implement a search page trough a specific MasterPage code behind.<br></br>
		/// </summary>
		public const int SearchPage = 42;

		/// <summary>
		/// <b>Aliases</b>: Calendario.<br></br>
		/// <b>Type name</b>: Calendario.<br></br>
		/// <b>Suggested use</b>: Useful to implement a calendar trough a specific MasterPage code behind.<br></br>
		/// </summary>
		public const int Calendar = 43;
		/// <exclude />
		public const int Calendario = 43;

		/// <exclude />
		public const int GruppoPannelli = 44;

		/// <exclude />
		public const int GruppoPannelliDefault = 44;

		/// <exclude />
		public const int PaginaDiDownload = 45;
		/// <summary>
		/// <b>Aliases</b>: PaginaDiDownload.<br></br>
		/// <b>Type name</b>: Pagina di download.<br></br>
		/// <b>Suggested use</b>: To be rendered as HTML page using proper MasterPage. You may use MB.FileBrowser (also distributed as a part of MagicCMS) to offer public or 
		/// private downloading interface to some server directories. (<see cref="http://filebrowser.magiccms.org/Home.aspx"/>  
		/// </summary>
		public const int DownloadPage = 45;

		/// <exclude />
		public const int Preferiti = 46;
		/// <exclude />
		public const int Cartella = 46;
		/// <summary>
		/// <b>Aliases</b>: Cartella.<br></br>
		/// <b>Type name</b>: Cartella.<br></br>
		/// <b>Use</b>: Generic container for MagicPost of any type.  Used to organize application resources.<br></br>
		/// <b>Important</b>: Folder type is handled by MagicCMS engine in a special way.<br></br>
		/// </summary>
		public const int Folder = 46;

		/// <exclude />
		public const int Plugin = 47;
		
		/// <exclude />
		public const int Galleria = 48;

		/// <summary>
		/// <b>Aliases</b>: Galleria.<br></br>
		/// <b>Type name</b>: Galleria.<br></br>
		/// <b>Use</b>: Use this container to let editor group MagicPost of type Image and of type Video and implement photo or video gallery. <br></br>
		/// </summary>
		public const int Gallery = 48;


		/// <exclude />
		public const int AnnuncioPubblicitario = 49;

		/// <exclude />
		public const int Banner = 50;
		/// <exclude />
		public const int PaginaAccordion = 51;

		/// <exclude />
		public const int Geolocazione = 53;

		/// <summary>
		/// <b>Aliases</b>: Geolocazione.<br></br>
		/// <b>Type name</b>: Locazione sulla mappa.<br></br>
		/// <b>Use</b>: Use this object to let editor define properties of a map marker over a Google Map. <br></br>
		/// <b>Important</b>: Folder type is handled by MagicCMS engine in a special way.<br></br>
		/// </summary>
		public const int Geolocation = 53;
		

		/// <exclude />
		public const int FakeLink = 54;
		public const int LinkFalso = 54;
		/// <summary>
		/// <b>Aliases</b>: FakeLink, LinkFalso.<br></br>
		/// <b>Type name</b>: FakeLink.<br></br>
		/// <b>Use</b>: Placeholder Item that you may insert in a Menu during design.<br></br>
		/// <b>Important</b>: DummyLink type is handled by MagicCMS engine in a special way.<br></br>
		/// </summary>
		public const int DummyLink = 54;

		/// <exclude />
		public const int Progetto = 55;

		/// <summary>
		/// <b>Type name</b>: Slide.<br></br>
		/// <b>Use</b>: Let editor to define a slide in a slide show. <br></br>
		/// </summary>
		public const int Slide = 56;


		/// <exclude />
		public const int Mappa = 57;

		/// <summary>
		/// <b>Type name</b>: Mappa.<br></br>
		/// <b>Use</b>: Let editor to define a map and map properties <br></br>
		/// </summary>
		public const int Map = 57;
		/// <exclude />
		public const int Negozio = 57;


		/// <summary>
		/// <b>Type name</b>: Collegamento social.<br></br>
		/// <b>Use</b>: You may define a specific MagicPost object (with specific rendering) to handle links tu profiles or pages on social networks. <br></br>
		/// </summary>
		public const int Social = 58;

		/// <exclude />
		public const int Progettisti = 59;

		/// <exclude />
		public const int PaginaContatti = 60;
		/// <summary>
		/// <b>Aliases</b>: PaginaContatti.<br></br>
		/// <b>Type name</b>: Pagina contatti.<br></br>
		/// <b>Suggested use</b>: Useful to implement a contact form trough a specific MasterPage code behind.<br></br>
		/// </summary>
		public const int Contacts = 60;

		/// <exclude />
		public const int Utente = 61;
		/// <summary>
		/// <b>Aliases</b>: Utente.<br></br>
		/// <b>Type name</b>: Utente.<br></br>
		/// <b>Suggested use</b>: You may use MagicPosts instances ti create user Profiles with custom properties connected to MagicCMS database users table.<br></br>
		/// </summary>
		public const int User = 61;

		/// <exclude />
		public const int ImpresaCompleta = 62;

		/// <exclude />
		public const int ImpresaDatiRidotti = 63;

		/// <exclude />
		public const int ParolaChiaveAreaMercato = 64;
		/// <exclude />
		public const int PopUp = 64;

		/// <exclude />
		public const int ParolaChiaveProdotto = 65;
		/// <exclude />
		public const int ShareButton = 65;

		/// <exclude />
		public const int ParolaChiaveAttStrategica = 66;

		/// <exclude />
		public const int SettoreAzienda = 67;

		/// <summary>
		/// <b>Type name</b>: Product.<br></br>
		/// <b>Suggested use</b>: You may use MagicPosts instances ti create products profiles with custom properties for product catalogs and/or e-commerce application.<br></br>
		/// </summary>
		public const int Product = 68;

		/// <summary>
		/// <b>Type name</b>: Product category.<br></br>
		/// <b>Suggested use</b>: You may use MagicPosts instances ti create products categories for product catalogs and/or e-commerce application.<br></br>
		/// </summary>
		public const int ProductCategory = 69;

		/// <exclude />
		public const int ParolaChiaveBuonePrassi = 70;

		/// <exclude />
		public const int ParolaChiavePuntiDiForza = 71;

		/// <summary>
		/// <b>Type name</b>: Sezione home.<br></br>
		/// <b>Use</b>: Special container type used to insert MagicPost instances in a Home Page in a mono page site.<br></br>
		/// <b>Important</b>: DummyLink type is handled by MagicCMS engine in a special way.<br></br>
		/// </summary>
		public const int Section = 72;
		/// <exclude />
		public const int ParolaChiaveIdentificareImpresa = 73;

		/// <exclude />
		public const int ListaDiDistribuzione = 74;

		/// <exclude />
		public const int PrerogativaUtente = 75;

		/// <exclude />
		public const int Provincia = 76;

		/// <exclude />
		public const int FormMail = 79;


		/// <exclude />
		public const int Messaggio = 77;
		/// <summary>
		/// <b>Aliases</b>: Messaggio.<br></br>
		/// <b>Type name</b>: Messaggio.<br></br>
		/// <b>Use</b>: You may use MagicPosts instances ti create a small message system and/or comments system. MagicPost offer some methods (<see cref="MagicCMS.MagicPost.GestAnswers()"/>, 
		/// <see cref="MagicCMS.MagicPost.GestAnswersByType()"/>, <see cref="MagicCMS.MagicPost.SetAnswerTo()"/>) that use <see cref="MagicCMS.MagicPostTypeInfo.Message"/> and 
		/// <see cref="MagicCMS.MagicPostTypeInfo.Answer"/> MagicPost types.<br></br>
		/// </summary>
		public const int Message = 77;

		/// <exclude />
		public const int Risposta = 78;
		/// <summary>
		/// <b>Aliases</b>: Risposta.<br></br>
		/// <b>Type name</b>: Risposta.<br></br>
		/// <b>Use</b>: You may use MagicPosts instances ti create a small message system and/or comments system. MagicPost offer some methods (<see cref="MagicCMS.MagicPost.GestAnswers()"/>, 
		/// <see cref="MagicCMS.MagicPost.GestAnswersByType()"/>, <see cref="MagicCMS.MagicPost.SetAnswerTo()"/>) that use <see cref="MagicCMS.MagicPostTypeInfo.Message"/> and 
		/// <see cref="MagicCMS.MagicPostTypeInfo.Answer"/> MagicPost types.<br></br>
		/// </summary>
		public const int Answer = 78;


		/// <summary>
		/// <b>Type name</b>: Sequenza.<br></br>
		/// <b>Use</b>: Let editor to define a slide show. <br></br>
		/// </summary>
		public const int SlideShow = 79;
		/// <exclude />
		public const int Sequenza = 79;

		/// <exclude />
		public const int Informativa = 80;

		#endregion

		#region Contructor

		/// <summary>
		/// Initializes a new instance of the <see cref="MagicPostTypeInfo"/> class fetching definition by MagicCMS database.
		/// </summary>
		/// <param name="typeId">The type unique identifier (<see cref="MagicPostTypeInfo.PK"/>) .</param>
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

		/// <exclude />
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
		/// <summary>
		/// Preferred children that will be suggested  during editing in back end.
		/// </summary>
		/// <value>Comma separated list of Post Types IDs.</value>
		public string ContenutiPreferiti { get; private set; }

		/// <summary>
		/// Gets or sets deletion date.
		/// </summary>
		/// <value>The deletion date.</value>
		public Nullable<DateTime> DataCancellazione { get; set; }


		/// <summary>
		/// Gets the last modified date.
		/// </summary>
		/// <value>The data ultima modifica.</value>
		public DateTime DataUltimaModifica { get; private set; }

		/// <summary>
		/// Gets the help text (html formatted).
		/// </summary>
		/// <value>The help text.</value>
		public string Help { get; private set; }
		
		/// <summary>
		/// Gets or sets the description of the post type. Alias for <see cref="MagicPostTypeInfo.Help"/>
		/// </summary>
		/// <value>The description.</value>
		public string Descrizione
		{
			get { return Help; }
			set { Help = value; }
		}

		/// <summary>
		/// Gets or sets the flag altezza. Determines if field Altezza is exposed.
		/// </summary>
		/// <value>The flag altezza.</value>
		public Boolean FlagAltezza { get; set; }

		/// <summary>
		/// Gets the flag attivo.
		/// </summary>
		/// <value>The flag attivo.</value>
		public Boolean FlagAttivo { get; private set; }

		/// <summary>
		/// Gets the flag breve. Determines if field TestoBreve is exposed.
		/// </summary>
		/// <value>The flag breve.</value>
		public Boolean FlagBreve { get; private set; }

		/// <summary>
		/// Gets or sets the flag Button Geolocation.  Determines if button Geolocation that open an interactive map is shown.
		/// </summary>
		/// <value>The flag BTN geolog.</value>
		public Boolean FlagBtnGeolog { get; set; }

		/// <summary>
		/// Gets the flag cerca server. Determines if button Search on server that open an interactive interface to server disc is shown.
		/// </summary>
		/// <value>The flag cerca server.</value>
		public Boolean FlagCercaServer { get; private set; }

		/// <summary>
		/// Gets the flag contenitore. Determines the post is a container (may have children) or not.
		/// </summary>
		/// <value>The flag contenitore.</value>
		public Boolean FlagContenitore { get; private set; }

		/// <summary>
		/// Gets the flag cancellazione. Determines if the post type definition is in trash can.
		/// </summary>
		/// <value>The flag cancellazione.</value>
		public Boolean FlagCancellazione { get; private set; }

		/// <summary>
		/// Gets the flag dimensioni. Determines if fields Altezza and Larghezza are exposed.
		/// </summary>
		/// <value>The flag dimensioni.</value>
		public Boolean FlagDimensioni { get; private set; }

		/// <summary>
		/// Gets the flag ExtraInfo. Determines if field ExtraInfo is exposed.
		/// </summary>
		/// <value>The flag ExtraInfo.</value>
		public Boolean FlagExtraInfo { get; private set; }

		/// <summary>
		/// Gets the flag ExtrInfo1. Determines if field ExtraInfo1 is exposed.
		/// </summary>
		/// <value>The flag ExtrInfo1.</value>
		public Boolean FlagExtrInfo1 { get; set; }

		/// <summary>
		/// Gets the flag ExtrInfo2. Determines if field ExtraInfo2 is exposed.
		/// </summary>
		/// <value>The flag ExtrInfo2.</value>
		public Boolean FlagExtrInfo2
		{
			get
			{
				return (LabelExtraInfo2 != "");
			}
		}

		/// <summary>
		/// Gets the flag ExtrInfo3. Determines if field ExtraInfo3 is exposed.
		/// </summary>
		/// <value>The flag ExtrInfo3.</value>
		public Boolean FlagExtrInfo3
		{
			get
			{
				return (LabelExtraInfo3 != "");
			}
		}

		/// <summary>
		/// Gets the flag ExtrInfo4. Determines if field ExtraInfo4 is exposed.
		/// </summary>
		/// <value>The flag ExtrInfo4.</value>
		public Boolean FlagExtrInfo4
		{
			get
			{
				return (LabelExtraInfo4 != "");
			}
		}


		/// <summary>
		/// Gets the flag full. Determines if field TestoLungo is exposed.
		/// </summary>
		/// <value>The flag full.</value>
		public Boolean FlagFull { get; private set; }

		/// <summary>
		/// Gets or sets the flag larghezza. Determines if field Larghezza is exposed.
		/// </summary>
		/// <value>The flag larghezza.</value>
		public Boolean FlagLarghezza { get; set; }

		/// <summary>
		/// Gets the flag scadenza. Determines if field DataDiScadenza is exposed.
		/// </summary>
		/// <value>The flag scadenza.</value>
		public Boolean FlagScadenza { get; private set; }

		/// <summary>
		/// Gets or sets the specialized information flag.
		/// </summary>
		/// <value>The flag specialized information.</value>
		public Boolean FlagSpecializedInfo { get; set; }

		/// <exclude />
		public Boolean FlagSpecialTag { get; set; }

		/// <summary>
		/// Gets or sets the FlagAutoTestoBreve flag. Determines if TestoBreve_RT is generated automatically 
		/// using <see cref="MagicCMS.Core.MagicCMSConfiguration.TestoBreveDefLength"/>.
		/// </summary>
		/// <value>The FlagAutoTestoBreve flag.</value>
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

		/// <summary>
		/// Gets or sets the flag tags. Determines if field Tags is exposed.
		/// </summary>
		/// <value>The flag tags.</value>
		public Boolean FlagTags { get; set; }

		/// <summary>
		/// Gets the flag URL. Determines if field Url is exposed.
		/// </summary>
		/// <value>The flag URL.</value>
		public Boolean FlagUrl { get; private set; }

		/// <summary>
		/// Gets the flag URL secondaria. Determines if field Url2 is exposed.
		/// </summary>
		/// <value>The flag URL secondaria.</value>
		public Boolean FlagUrlSecondaria { get; private set; }

		/// <summary>
		/// Gets or sets the icon for this post type.
		/// </summary>
		/// <value>The icon.</value>
		public string Icon { get; set; }

		/// <summary>
		/// Gets or sets the label used for the field altezza.
		/// </summary>
		/// <value>The label altezza.</value>
		public string LabelAltezza { get; set; }

		/// <summary>
		/// Gets or sets the label used for the field extra information.
		/// </summary>
		/// <value>The label extra information.</value>
		public string LabelExtraInfo { get; set; }

		/// <summary>
		/// Gets or sets the label used for the field  extra information 5.
		/// </summary>
		/// <value>The label extra information 5.</value>
		public string LabelExtraInfo_5 { get; set; }

		/// <summary>
		/// Gets or sets the label used for the field extra information 6.
		/// </summary>
		/// <value>The label extra information 6.</value>
		public string LabelExtraInfo_6 { get; set; }

		/// <summary>
		/// Gets or sets the label used for the field extra information 7.
		/// </summary>
		/// <value>The label extra information 7.</value>
		public string LabelExtraInfo_7 { get; set; }

		/// <summary>
		/// Gets or sets the label used for the field  extra information 8.
		/// </summary>
		/// <value>The label extra information 8.</value>
		public string LabelExtraInfo_8 { get; set; }


		/// <summary>
		/// Gets or sets the label used for the field extra info1.
		/// </summary>
		/// <value>The label extra info1.</value>
		public string LabelExtraInfo1 { get; set; }

		/// <summary>
		/// Gets or sets the label used for the field extra info2.
		/// </summary>
		/// <value>The label extra info2.</value>
		public string LabelExtraInfo2 { get; set; }

		/// <summary>
		/// Gets or sets the label used for the field extra info3.
		/// </summary>
		/// <value>The label extra info3.</value>
		public string LabelExtraInfo3 { get; set; }

		/// <summary>
		/// Gets or sets the label used for the field extra info4.
		/// </summary>
		/// <value>The label extra info4.</value>
		public string LabelExtraInfo4 { get; set; }

		/// <summary>
		/// Gets or sets the label used for the field extra information number 1.
		/// </summary>
		/// <value>The label extra information number 1.</value>
		public string LabelExtraInfoNumber_1 { get; set; }

		/// <summary>
		/// Gets or sets the label used for the field extra information number 2.
		/// </summary>
		/// <value>The label extra information number 2.</value>
		public string LabelExtraInfoNumber_2 { get; set; }

		/// <summary>
		/// Gets or sets the label used for the field extra information number 3.
		/// </summary>
		/// <value>The label extra information number 3.</value>
		public string LabelExtraInfoNumber_3 { get; set; }

		/// <summary>
		/// Gets or sets the label used for the field extra information number 4.
		/// </summary>
		/// <value>The label extra information number 4.</value>
		public string LabelExtraInfoNumber_4 { get; set; }

		/// <summary>
		/// Gets or sets the label used for the field extra information number 5.
		/// </summary>
		/// <value>The label extra information number 5.</value>
		public string LabelExtraInfoNumber_5 { get; set; }

		/// <summary>
		/// Gets or sets the label used for the field extra information number 6.
		/// </summary>
		/// <value>The label extra information number 6.</value>
		public string LabelExtraInfoNumber_6 { get; set; }

		/// <summary>
		/// Gets or sets the label used for the field extra information number 7.
		/// </summary>
		/// <value>The label extra information number 7.</value>
		public string LabelExtraInfoNumber_7 { get; set; }

		/// <summary>
		/// Gets or sets the label used for the field extra information number 8.
		/// </summary>
		/// <value>The label extra information number 8.</value>
		public string LabelExtraInfoNumber_8 { get; set; }

		/// <summary>
		/// Gets or sets the label used for the field larghezza.
		/// </summary>
		/// <value>The label larghezza.</value>
		public string LabelLarghezza { get; set; }

		/// <summary>
		/// Gets or sets the label used for the field DataDiScadenza.
		/// </summary>
		/// <value>The label scadenza.</value>
		public string LabelScadenza { get; set; }

		/// <summary>
		/// Gets or sets the label used for the field TestoBreve.
		/// </summary>
		/// <value>The label testo breve.</value>
		public string LabelTestoBreve { get; set; }

		/// <summary>
		/// Gets or sets the label used for the field TestoLungo.
		/// </summary>
		/// <value>The label testo lungo.</value>
		public string LabelTestoLungo { get; set; }

		/// <summary>
		/// Gets or sets the label used for the field titolo.
		/// </summary>
		/// <value>The label titolo.</value>
		public string LabelTitolo { get; set; }

		/// <summary>
		/// Gets or sets the label used for the field URL.
		/// </summary>
		/// <value>The label URL.</value>
		public string LabelUrl { get; set; }

		/// <summary>
		/// Gets or sets the label used for the field URL2.
		/// </summary>
		/// <value>The label URL secondaria.</value>
		public string LabelUrlSecondaria { get; set; }

		/// <summary>
		/// Gets or sets the master page file used for render the post of this type.
		/// </summary>
		/// <value>The master page file.</value>
		public string MasterPageFile { get; set; }

		/// <summary>
		/// Gets the nome. Name of the post type.
		/// </summary>
		/// <value>The nome.</value>
		public string Nome { get; private set; }

		/// <exclude />
		public string NomeExtraInfo
		{
			get { return LabelExtraInfo; }
			set { LabelExtraInfo = value; }
		}

		/// <summary>
		/// Gets the pk. Unique ID of the post type
		/// </summary>
		/// <value>The pk.</value>
		public int Pk { get; private set; }

		public string VisibilityStyles
        {
			get
            {
				List<string> _list = new List<string>();


				if (!FlagAltezza)
				{
					_list.Add("." + ("FlagAltezza"));
				}

				if (!FlagBreve)
				{
					_list.Add("." + ("FlagBreve"));
				}
				if (!FlagBreve && !FlagFull)
				{
					_list.Add("." + ("FlagTesti"));
				}

				if (!FlagBtnGeolog)
				{
					_list.Add("." + ("FlagBtnGeolog"));
				}

				if (!FlagCercaServer)
				{
					_list.Add("." + ("FlagCercaServer"));
				}

				if (!FlagAltezza)
				{
					_list.Add("." + ("FlagAltezza"));
				}

				if (!FlagLarghezza)
				{
					_list.Add("." + ("FlagLarghezza"));
				}

				if (!FlagAltezza && !FlagLarghezza)
				{
					_list.Add("." + ("FlagDimensioni"));
				}

				if (!FlagExtraInfo)
				{
					_list.Add("." + ("FlagExtraInfo"));
				}

				if (!FlagExtrInfo1)
				{
					_list.Add("." + ("FlagExtraInfo1"));
				}

				if (String.IsNullOrEmpty(LabelExtraInfo2))
				{
					_list.Add("." + ("FlagExtraInfo2"));
				}

				if (String.IsNullOrEmpty(LabelExtraInfo3))
				{
					_list.Add("." + ("FlagExtraInfo3"));
				}

				if (String.IsNullOrEmpty(LabelExtraInfo4))
				{
					_list.Add("." + ("FlagExtraInfo4"));
				}

				if (!FlagFull)
				{
					_list.Add("." + ("FlagFull"));
				}


				if (!FlagScadenza)
				{
					_list.Add("." + ("FlagScadenza"));
				}

				if (!FlagTags)
				{
					_list.Add("." + ("FlagTags"));
				}

				if (!FlagUrl)
				{
					_list.Add("." + ("FlagUrl"));
				}

				if (!FlagUrlSecondaria)
				{
					_list.Add("." + ("FlagUrlSecondaria"));
				}

				if (String.IsNullOrEmpty(LabelExtraInfo_5))
				{
					_list.Add("." + ("FlagExtraInfo5"));
				}

				if (String.IsNullOrEmpty(LabelExtraInfo_6))
				{
					_list.Add("." + ("FlagExtraInfo6"));
				}


				if (String.IsNullOrEmpty(LabelExtraInfo_7))
				{
					_list.Add("." + ("FlagExtraInfo7"));
				}


				if (String.IsNullOrEmpty(LabelExtraInfo_8))
				{
					_list.Add("." + ("FlagExtraInfo8"));
				}


				if (String.IsNullOrEmpty(LabelExtraInfoNumber_1))
				{
					_list.Add("." + ("FlagExtraInfoNumber_1"));
				}


				if (String.IsNullOrEmpty(LabelExtraInfoNumber_2))
				{
					_list.Add("." + ("FlagExtraInfoNumber_2"));
				}


				if (String.IsNullOrEmpty(LabelExtraInfoNumber_3))
				{
					_list.Add("." + ("FlagExtraInfoNumber_3"));
				}


				if (String.IsNullOrEmpty(LabelExtraInfoNumber_4))
				{
					_list.Add("." + ("FlagExtraInfoNumber_4"));
				}


				if (String.IsNullOrEmpty(LabelExtraInfoNumber_5))
				{
					_list.Add("." + ("FlagExtraInfoNumber_5"));
				}


				if (String.IsNullOrEmpty(LabelExtraInfoNumber_6))
				{
					_list.Add("." + ("FlagExtraInfoNumber_6"));
				}


				if (String.IsNullOrEmpty(LabelExtraInfoNumber_7))
				{
					_list.Add("." + ("FlagExtraInfoNumber_7"));
				}


				if (String.IsNullOrEmpty(LabelExtraInfoNumber_8))
				{
					_list.Add("." + ("FlagExtraInfoNumber_8"));
				}

				if (String.IsNullOrEmpty(LabelExtraInfoNumber_1 + LabelExtraInfoNumber_2 + LabelExtraInfoNumber_3 + LabelExtraInfoNumber_4
					+ LabelExtraInfoNumber_5 + LabelExtraInfoNumber_6 + LabelExtraInfoNumber_7 + LabelExtraInfoNumber_8))
				{
					_list.Add("." + ("FlagExtraInfoNumberAll"));
				}


				if (MagicIndex.TipiEsclusi.Contains(Pk))
				{
					_list.Add("." + ("Permalink"));
				}

				string template = @"{0} 
                                {{
                                    display: none!important;
                                }}";


				return string.Format(template, string.Join(",", _list));

			}
        }

		#endregion

		#region PublicMethod
		/// <summary>
		/// Inserts this instance in the MagicCMS database.
		/// </summary>
		/// <returns>System.Int32. Unique ID of Inserted Post Type Definition</returns>
		/// <remarks>
		/// Errors are handled by code and stored in <see cref="MagicCMS.Code.MagicLog"/> table.
		/// </remarks>
		public int Insert()
		{
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

		/// <summary>
		/// Updates this modified instance replacing it in MagicCMS database.
		/// </summary>
		/// <returns>Boolean.</returns>
		/// <remarks>
		/// Errors are handled by code and stored in <see cref="MagicCMS.Code.MagicLog"/> table.
		/// </remarks>
		public Boolean Update()
		{
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

		/// <summary>
		/// Deletes this instance.
		/// </summary>
		/// <returns>Boolean.</returns>
		/// <remarks>
		/// Errors are handled by code and stored in <see cref="MagicCMS.Code.MagicLog"/> table.
		/// </remarks>
		public Boolean Delete()
		{
			string message;
			return Delete(out  message);
		}

		/// <summary>
		/// Deletes this instance.
		/// </summary>
		/// <param name="message">Return message.</param>
		/// <returns>Boolean.</returns>
		/// <remarks>
		/// Errors are handled by code and stored in <see cref="MagicCMS.Code.MagicLog"/> table.
		/// </remarks>
		public Boolean Delete(out string message)
		{
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

		/// <summary>
		/// Undelete record in trash can.
		/// </summary>
		/// <param name="message">The message.</param>
		/// <returns>Boolean.</returns>
		/// <remarks>
		/// Errors are handled by code and stored in <see cref="MagicCMS.Code.MagicLog"/> table.
		/// </remarks>
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

		/// <exclude />
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

		/// <summary>
		/// Gets or sets property with the specified property name.
		/// </summary>
		/// <param name="propertyName">Name of the property.</param>
		/// <returns>Value of property</returns>
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

		/// <summary>
		/// Count the records.
		/// </summary>
		/// <returns>System.Int32. Count of records</returns>
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