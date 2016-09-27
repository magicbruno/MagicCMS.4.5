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
        public int Pk
        {
            get
            {
                return _mp.Pk;
            }
        }

        public string Titolo
        {
            get
            {
                return _mp.Titolo;
            }
        }

        public string Title_RT
        {
            get
            {
                return _mp.Title_RT;
            }
        }

        public string TestoBreve_RT
        {
            get
            {
                return _mp.TestoBreve_RT;
            }
        }

        public int Tipo
        {
            get
            {
                return _mp.Tipo;
            }
        }

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

        public string Url
        {
            get
            {
                return _mp.Url;
            }
        }

        public string Url2
        {
            get
            {
                return _mp.Url2;
            }
        }

        public string IconClass
        {
            get
            {
                return _mp.IconClass;
            }
        }

        public string CustomClass
        {
            get
            {
                return _mp.CustomClass;
            }
        }

        private MenuIcon _icon;

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

        public string ActiveClass
        {
            get
            {
                if (currentPageId == Pk)
                    return "active";
                return "";
            }
        }

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