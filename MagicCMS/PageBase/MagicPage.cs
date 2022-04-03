using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using MagicCMS.Core;
using System.IO;
using MagicCMS.Routing;

namespace MagicCMS.PageBase
{
	/// <summary>
	/// Class MagicPage. MagicCMS content pages must inherit from this class.
	/// </summary>
	/// <seealso cref="System.Web.UI.Page" />
    public partial class MagicPage : System.Web.UI.Page
    {
		/// <summary>
		/// Store <see cref="MagicCMS.Core.MagicPost"/> to be rendered in the page.
		/// </summary>
		/// <value>The post.</value>
        public MagicPost ThePost { get; set; }

		/// <summary>
		/// Store the  configuration settings.
		/// </summary>
		/// <value>The configuration.</value>
        public CMS_Config Config { get; set; }

		/// <summary>
		/// If MagicPage is used for previewing a post, store the temporary id of the previewed page.
		/// </summary>
		/// <value>The preview identifier.</value>
		public int PreviewPk { get; set; } 

        /// <summary>
        /// Handles the PreInit event of the Page control.
        /// Set language. Load Proper Master Pagerect and if in case redirect to home page.
        /// </summary>
        /// <param name="sender">The source of the event.</param>
        /// <param name="e">The <see cref="EventArgs"/> instance containing the event data.</param>
        protected void Page_PreInit(object sender, EventArgs e)
        {
            int p = 0;
			// Route data
			string rd_locale = "",
					rd_type = "",
					rd_pageId = "";

			if (Page.RouteData != null)
			{
				rd_locale = RouteData.Values["locale"] != null ? RouteData.Values["locale"].ToString() : "";
				rd_type = RouteData.Values["type"] != null ? RouteData.Values["type"].ToString() : "";
				rd_pageId = RouteData.Values["pageId"] != null ? RouteData.Values["pageId"].ToString() : "";
			}

            string lang = Request["lang"];
			if (String.IsNullOrEmpty(lang))
			{
				lang = rd_locale;					
			}

			string pageId = Request["p"];
			if (String.IsNullOrEmpty(pageId))
				pageId = rd_pageId;

			// Se il sito è multilingua se necessario imposto la lingua di default e reindirizzo
			if (MagicLanguage.IsMultilanguage())
			{
				string currLang = MagicSession.Current.CurrentLanguage == "default" ? MagicSession.Current.Config.TransSourceLangId : MagicSession.Current.CurrentLanguage;
				// Se manca il parametro lingua reindirizzo aggiungendolo
				if (String.IsNullOrEmpty(lang))
				{
					string vp = "/" + currLang + (!String.IsNullOrEmpty(rd_type) ? "/" + rd_type : "") + (!String.IsNullOrEmpty(pageId) ? "/" + pageId : "");
					Response.Redirect(vp);
				}
				// Altrimenti setto la lingua
				else
				{
					MagicSession.Current.CurrentLanguage = lang;
				}
			}
			// Altrimenti imposto la lingua di default ed elimino il parametro lingua
			else
			{
				if (!String.IsNullOrEmpty(lang))
				{
					string vp = (!String.IsNullOrEmpty(rd_type) ? "/" + rd_type : "") + (!String.IsNullOrEmpty(pageId) ? "/" + pageId : "");
					Response.Redirect(vp);
				}
				// Altrimenti setto la lingua di default
				else
				{
					MagicSession.Current.CurrentLanguage = "default";
				}
			}


			//Load theme config setting
			Config = new CMS_Config();

			// Home page?
			if (rd_pageId == "home" /*|| rd_type == "home"*/)
			{
				p = (Config.StartPage > 0 ? Config.StartPage : MagicPost.GetSpecialItem(MagicPostTypeInfo.HomePage));
			}
			else if (rd_pageId == "preview" || rd_type == "preview")
			{
				if (MagicSession.Current.PreviewPost != null)
				{
					ThePost = MagicSession.Current.PreviewPost;
					int originalPk = ThePost.Pk;
					ThePost.Pk = 0;
					p = ThePost.Insert();
					PreviewPk = p;
					if (p > 0 && originalPk > 0)
						ThePost.CloneChildrenFrom(originalPk);
				}
					
			}
			else if (!int.TryParse(pageId, out p))
			{
				p = MagicIndex.GetPostId(rd_pageId);
			}

			ThePost = new MagicPost(p);
			// If main page is called with no par load home page
			if (ThePost.Pk <= 0)
            {
				Response.Redirect("/error/404");
            }
				


            if (ThePost.Pk != 0) {
                //Current language
                string currentLang = MagicSession.Current.CurrentLanguage;

                // Is language setting pessimistic (show only tranlated objects) or optimistic (show not translate object
                // in original - source - language)
                Boolean onlyIfTranslated = MagicSession.Current.TransAutoHide;

                // If pessimistic redirect to home page if page is not translated
                if (currentLang != "default" && onlyIfTranslated)
                {
                    MagicTranslation mt = ThePost.Translations.GetByLangId(currentLang);
                    if (mt == null)
                        Response.Redirect("/home");
                }

                // Load proper Master Page according to the page type
				string vp;
				int pk;
                switch (ThePost.Tipo)
                {
                    // Page types that must be redirected to other resources
                    case MagicPostTypeInfo.CollegamentoInternet:
					case MagicPostTypeInfo.ImmagineInGalleria:
                    case MagicPostTypeInfo.DocumentoScaricabile:
                        Response.Redirect(ThePost.Url);
                        break;
                    case MagicPostTypeInfo.CollegamentoInterno:
                        int tipo = 0, tag_id = 0;
                        int.TryParse(ThePost.ExtraInfo2, out tipo);
                        int.TryParse(ThePost.ExtraInfo3, out tag_id);
                        if (ThePost.ExtraInfo.ToUpper() == "AUTO" && tipo > 0)
                        {
                            pk = MagicPost.GetSpecialItem(tipo, tag_id, MagicOrdinamento.DateDesc);
							vp = RouteUtils.GetVirtualPath(pk, new int[] { tag_id });
                            Response.Redirect(vp);
                        }
                        else if (int.TryParse(ThePost.ExtraInfo, out pk))
						{
							Response.Redirect(RouteUtils.GetVirtualPath(pk));					
						}
                        else
                            Response.Redirect(ThePost.Url);
                        break;

                    default:
                        // Try to load type specific master page
						if (LoadMaster(ThePost.TypeInfo.MasterPageFile))
						{
							MagicCMS.PageBase.MasterTheme myMaster = Master as MagicCMS.PageBase.MasterTheme;
							myMaster.ThePost = ThePost;
							myMaster.TheTitle = ThePost.Title_RT;
							myMaster.CmsConfig = Config;
							myMaster.Keywords = ThePost.Tags;
							myMaster.Description = HtmlRemoval.StripTagsRegex(HttpUtility.HtmlDecode(ThePost.TestoBreve_RT));
							Uri theUri = HttpContext.Current.Request.Url;
							string absoluteUrl = theUri.Scheme + "://" + theUri.Host + (!theUri.IsDefaultPort ? ":" + theUri.Port.ToString() : "");
							string image = !String.IsNullOrEmpty(ThePost.Url) ? ThePost.Url : ThePost.Url2;
							if (String.IsNullOrEmpty(image))
								image = Config.DefaultImage;
							myMaster.PageImage = absoluteUrl + image;
						}
						// Else try to load default error master page and throws an error
						//else if (LoadMaster(MagicCMSConfiguration.GetConfig().DefaultContentMaster))
						//{
						//	MagicCMS.PageBase.MasterTheme myMaster = Master as MagicCMS.PageBase.MasterTheme;
						//	myMaster.TheTitle = Config.SiteName;
						//	myMaster.ErrorTitle = "La pagina non esiste";
						//	myMaster.ErrorMessage = "Risorsa non visualizzabile.";
						//};
						else
						{
							Response.Redirect("/error/404/100");
						}
                        break;
                }            
            }
            // Not existing paramete error
//
        }

		protected void Page_Unload(object sender, EventArgs e)
		{
			if (ThePost == null)
				return;

			if (ThePost.Pk == PreviewPk)
			{
				ThePost.FlagCancellazione = true;
				string message;
				ThePost.Delete(out message);
			}
		}


        /// <summary>
        /// It try to load the master for page rendering.
        /// </summary>
        /// <param name="MasterFile">The master file.</param>
        /// <returns>True if file was loded, false if it doesn't exist</returns>
        protected Boolean LoadMaster(string MasterFile)
        {
            string themePath = Config.ThemePath.TrimEnd(new char[] { '/' }) + "/" + MasterFile;
            if (File.Exists(Server.MapPath(themePath)))
            {
                this.MasterPageFile = themePath;
                return true;
            }
            return false;
        }

    }
}