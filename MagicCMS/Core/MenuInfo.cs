using MagicCMS.Routing;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.HtmlControls;

namespace MagicCMS.Core
{
	/// <summary>
	/// Class MenuInfo.
	/// </summary>
	/// <remarks>Define a subset of <see cref="MagicCMS.Core.MagicPost"/></remarks> the define a menu item. Suitable for use in menus management.
    public class MenuInfo
    {
        #region Private fields
        protected MagicPost _mp;
        private CMS_Config _config;
        private CMS_Config CmsConfig
        {
            get
            {
                if (_config == null)
                {
                    _config = new CMS_Config();
                }
                return _config;
            }
        }
        private HttpContext context = HttpContext.Current;
        private int currentPageId = 0;
        #endregion

        #region Public properties
		/// <summary>
		/// Gets the MagicPost.Pk. 
		/// </summary>
		/// <value>The pk.</value>
        public int Pk
        {
            get
            {
                return _mp.Pk;
            }
        }

		/// <summary>
		/// Gets the MagicPost.Titolo.
		/// </summary>
		/// <value>The titolo.</value>
        public string Titolo
        {
            get
            {
                return _mp.Titolo;
            }
        }

		/// <summary>
		/// Gets the MagicPost.Title_RT.
		/// </summary>
		/// <value>The title rt.</value>
        public string Title_RT
        {
            get
            {
                return _mp.Title_RT;
            }
        }

		/// <summary>
		/// Gets the MagicPost.TestoBreve_RT.
		/// </summary>
		/// <value>The testo breve rt.</value>
        public string TestoBreve_RT
        {
            get
            {
                return _mp.TestoBreve_RT;
            }
        }

		/// <summary>
		/// Gets the MagicPost.Tipo.
		/// </summary>
		/// <value>The tipo.</value>
        public int Tipo
        {
            get
            {
                return _mp.Tipo;
            }
        }

		/// <summary>
		/// Gets the target. Target attribute in anchor HTML element.
		/// </summary>
		/// <value>The target.</value>
        public string Target
        {
            get
            {
                string target = "_self";
                switch (_mp.Tipo)
                {
                    case MagicPostTypeInfo.CollegamentoInternet:
                        target = _mp.ExtraInfo.Trim();
                        break;
                    default:
                        target = "_self";
                        break;
                }
                return target;
            }
        }

		/// <summary>
		/// Gets the MagicPost.Url.
		/// </summary>
		/// <value>The URL.</value>
        public string Url
        {
            get
            {
                return _mp.Url;
            }
        }

		/// <summary>
		/// Gets the MagicPost.Url2.
		/// </summary>
		/// <value>The url2.</value>
        public string Url2
        {
            get
            {
                return _mp.Url2;
            }
        }

		/// <summary>
		/// Gets the MagicPost.IconClass.
		/// </summary>
		/// <value>The icon class.</value>
        public string IconClass
        {
            get
            {
                return _mp.IconClass;
            }
        }

		/// <summary>
		/// Gets the MagicPost.CustomClass.
		/// </summary>
		/// <value>The custom class.</value>
        public string CustomClass
        {
            get
            {
                return _mp.CustomClass;
            }
        }

        private MenuIcon _icon;

		/// <summary>
		/// Gets the href attribute of the anchor HTML element.
		/// </summary>
		/// <value>The href.</value>
        public string Href
        {
            get
            {
                string href = "";
                bool local = false;
                if (CmsConfig.SinglePage)
                {
                    local = _mp.IsLocalLink();
                }
                switch (Tipo)
                {
                    case MagicPostTypeInfo.PopUp:
					case MagicPostTypeInfo.CollegamentoInternet:
                        href = _mp.Url;
                        break;
                    case MagicPostTypeInfo.Menu:
                    case MagicPostTypeInfo.LinkFalso:
                        href = "javascript:;";
                        break;
                    case MagicPostTypeInfo.ButtonLanguage:
						string buttonLang = _mp.ExtraInfo;
						string parentName = "";
						if (HttpContext.Current.Request.RequestContext.RouteData != null)
						{
							if (HttpContext.Current.Request.RequestContext.RouteData.Values["type"] != null)
							{
								parentName = HttpContext.Current.Request.RequestContext.RouteData.Values["type"].ToString();
							}
						}
                        href = RouteUtils.GetVirtualPath(currentPageId, parentName, buttonLang);
                        break;
                    case MagicPostTypeInfo.ShareButton:
                        href = "";
                        break;
                    default:
                        if (local)
                        {
                            href = "#" + MagicIndex.GetTitle(_mp.Pk, MagicSession.Current.CurrentLanguage);
                            if (currentPageId != CmsConfig.StartPage)
                                href = "/home" + href;
                        }
                        else
                            href = RouteUtils.GetVirtualPath(_mp.Pk, new int[] {MagicPostTypeInfo.Argomento, MagicPostTypeInfo.Categoria });
                        break;
                }
                return href;
            }
        }

		/// <summary>
		/// Gets the whole HTML anchor element as <see cref="System.Web.UI.HtmlControls.HtmlGenericControl"/>
		/// </summary>
		/// <value>The link element.</value>
        public HtmlGenericControl LinkElement
        {
            get
            {
                HtmlGenericControl a;
                if(_mp.Tipo == MagicPostTypeInfo.ShareButton)
                    return new HtmlGenericControl("share-button");
                else 
                    a = new HtmlGenericControl("a");
                a.Attributes["href"] = Href;
                a.Attributes["data-pk"] = _mp.Pk.ToString();
                //titolo e link di default
                string titolo_val = "",
                        iconClass = _mp.IconClass.Trim();

                if (!String.IsNullOrEmpty(iconClass))
                    titolo_val = "<i class=\"fa " + iconClass + "\"></i> ";

                titolo_val += _mp.Title_RT;
                

                switch (_mp.Tipo)
                {
                    case MagicPostTypeInfo.Menu:
                        a.Attributes["class"] = "dropdown-toggle";
                        a.Attributes["data-toggle"] = "dropdown";
                        a.InnerHtml = titolo_val;
                        break;
                    case MagicPostTypeInfo.LinkFalso:
                        a.InnerHtml = titolo_val;
                        break;
                    case MagicPostTypeInfo.CollegamentoInternet:
                        a.Attributes["target"] = String.IsNullOrEmpty(Target) ? "_blank" : Target;
                        if (!string.IsNullOrEmpty(_mp.TestoBreve_RT))
                            a.Attributes["title"] = _mp.TestoBreve_RT;
                        a.InnerHtml = titolo_val;
                        break;
                    case MagicPostTypeInfo.CollegamentoInterno:
                       if (!string.IsNullOrEmpty(_mp.TestoBreve_RT))
                            a.Attributes["title"] = _mp.TestoBreve_RT;
                        if (String.IsNullOrEmpty(_mp.Url2))
                            a.InnerHtml = titolo_val;
                        else
                        {
                            HtmlImage img = new HtmlImage();
                            img.Src = _mp.Url2;
                            a.Controls.Add(img);
                        }
                        break;
                    case MagicPostTypeInfo.ButtonLanguage:
                        if (String.IsNullOrEmpty(_mp.Url2))
                            a.InnerHtml = titolo_val;
                        else
                        {
                            HtmlImage img = new HtmlImage();
                            img.Src = _mp.Url2;
                            a.Controls.Add(img);
                        }
                        if (!string.IsNullOrEmpty(_mp.ExtraInfo2))
                            a.Attributes["class"] = _mp.CustomClass;
						string currentLanguage = MagicSession.Current.CurrentLanguage == "default" ? MagicSession.Current.Config.TransSourceLangId : MagicSession.Current.CurrentLanguage;
						if (currentLanguage == _mp.ExtraInfo)
						{
							a.Style.Add(HtmlTextWriterStyle.Display, "none");
						}
                        break;
                    case MagicPostTypeInfo.PopUp:
                        HtmlGenericControl aContent = new HtmlGenericControl("span");
                        aContent.InnerHtml = titolo_val;
                        a.Attributes.Add("data-toggle", "modal");
                        a.Attributes.Add("data-popuptitle", _mp.ExtraInfo);
                        HtmlGenericControl hiddenContent = MagicUtils.HTMLElement("div", "hidden", _mp.TestoBreve_RT);
                        hiddenContent.Attributes.Add("hidden", "hidden");
                        hiddenContent.Attributes.Add("data-popup", "body");
                        HtmlGenericControl hiddenFooter = MagicUtils.HTMLElement("span", "hidden", _mp.TestoLungo_RT);
                        hiddenFooter.Attributes.Add("hidden", "hidden");
                        hiddenFooter.Attributes.Add("data-popup", "footer");
                        a.Controls.Add(aContent);
                        a.Controls.Add(hiddenContent);
                        a.Controls.Add(hiddenFooter);
                        break;
                    default:
                        a.InnerHtml = titolo_val;
                        break;
                }
                return a;
            }
        }

		/// <summary>
		/// Gets the whole HTML anchor element as string.
		/// </summary>
		/// <value>The link string.</value>
        public string LinkString
        {
            get
            {
                StringBuilder generatedHtml = new StringBuilder();
                HtmlTextWriter htw = new HtmlTextWriter(new StringWriter(generatedHtml));
                LinkElement.RenderControl(htw);
                return generatedHtml.ToString();
            }
        }

		/// <summary>
		/// Gets the active class. Mark menu item as active if the page to which it points is the current page.
		/// </summary>
		/// <value>"active" or ""</value>
        public string ActiveClass
        {
            get
            {
                if (currentPageId == Pk)
                    return "active";
                return "";
            }
        }

		/// <summary>
		/// Gets the menu item icon in string version.
		/// </summary>
		/// <value>The icon string.</value>
        public string IconString
        {
            get
            {
                HtmlGenericControl iconElement = null;
                String output = "";
                if (_icon.Type == MenuIconType.ClassIcon)
                {
                    iconElement = MagicUtils.HTMLElement("span", _icon.Value);
                }
                else if (_icon.Type == MenuIconType.Image)
                {
                    iconElement = new HtmlGenericControl("img");
                    iconElement.Attributes.Add("src", _icon.Value);
                    iconElement.Attributes.Add("alt", Title_RT);
                }
                if (iconElement != null)
                {
                    StringBuilder generatedHtml = new StringBuilder();
                    HtmlTextWriter htw = new HtmlTextWriter(new StringWriter(generatedHtml));
                    iconElement.RenderControl(htw);
                    output = generatedHtml.ToString();
                }
                return output;
            }
        }

        private MenuInfoCollection _submenu;
		/// <summary>
		/// Gets the submenu.
		/// </summary>
		/// <value>The submenu.</value>
        public MenuInfoCollection Submenu
        {
            get
            {
                if (_submenu == null)
                {
                    if (Tipo == MagicPostTypeInfo.Menu)
                    {
                        _submenu = new MenuInfoCollection(_mp, currentPageId);
                    }
                    else
                    {
                        _submenu = new MenuInfoCollection();
                    }
                }
                return _submenu;
            }
        }

        #endregion

        #region Constructor
		/// <summary>
		/// Initializes a new instance of the <see cref="MenuInfo"/> class extracting definition by a MagicPost element. If element post type is "Menu" the menu item is a sub menu 
		/// otherwise is a link to a page or to a section of home page or to an external url, ecc.
		/// </summary>
		/// <param name="mp">The mp.</param>
		/// <param name="pageId">Current page identifier.</param>
        public MenuInfo (MagicPost mp, int pageId)
        {
            currentPageId = pageId;
            _mp = mp;
            _icon = new MenuIcon();
            if (MenuIcon.GetType(_mp.IconClass) == MenuIconType.ClassIcon)
            {
                _icon.Value = _mp.IconClass;
            }
            else if (MenuIcon.GetType(_mp.Url) == MenuIconType.Image)
            {
                _icon.Value = _mp.Url;
            }
            else
                _icon.Value = _mp.Url2;
        }
        #endregion
    }
}