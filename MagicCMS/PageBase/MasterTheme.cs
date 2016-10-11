using MagicCMS.Core;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;

namespace MagicCMS.PageBase
{
	/// <summary>
	/// Class MasterTheme. Descendant of <see cref="MagicCMS.PageBase.SiteMasterBase"/> 
	/// </summary>
	/// <seealso cref="MagicCMS.PageBase.SiteMasterBase" />
    public abstract partial class MasterTheme : SiteMasterBase
    {

		/// <summary>
		/// Gets or sets the error title.
		/// </summary>
		/// <value>The error title.</value>
        public string ErrorTitle { get; set; }
		/// <summary>
		/// Gets or sets the error message.
		/// </summary>
		/// <value>The error message.</value>
        public string ErrorMessage { get; set; }
		/// <summary>
		/// Gets or sets the start page identifier. Unique ID of the first page of MagicCMS application.
		/// </summary>
		/// <value>The start page identifier.</value>
        public int StartPageId { get; set; }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (CmsConfig == null)
                CmsConfig = new CMS_Config();
            if (TheTitle == null)
                TheTitle = CmsConfig.SiteName;
            if(PageImage == null)
                PageImage = (!String.IsNullOrEmpty(ThePost.Url) ? ThePost.Url : ThePost.Url2);
            
            //Memorizzo il valore dell'id della home page da usare come indirizzo nei temi monopagina
            //(vedi AggiungiVoci)

            StartPageId = (CmsConfig.StartPage > 0 ? CmsConfig.StartPage : MagicPost.GetSpecialItem(MagicPostTypeInfo.HomePage));

            SiteMasterBase MyMaster = this.Master as SiteMasterBase;
            MyMaster.ThePost = this.ThePost;
            MyMaster.TheTitle = this.TheTitle;
            MyMaster.CmsConfig = this.CmsConfig;
            MyMaster.Keywords = this.Keywords;
            MyMaster.Description = this.Description;
            MyMaster.PageImage = this.PageImage;
        }

		/// <exclude />
        protected HtmlGenericControl AggiungiVoci(int menuId, string mainClass, string dropdownClass, string dropDownParentClass,
                                                  string submenuParentClass, string activeClass, int level, Boolean defaultToLocal)
        {
            // adattamento al menu bootstrap
            HtmlGenericControl ul = new HtmlGenericControl("ul");
            ul.Attributes["class"] = mainClass;
            MagicPost mp = new MagicPost(menuId);
            // Elemeti puntati dal menu
            MagicPostCollection mpc = mp.GetChildren(mp.ExtraInfo, -1);

            //id della pagina corrente
            int p;
            int.TryParse(Request["p"], out p);
            if (CmsConfig == null)
                CmsConfig = new CMS_Config();

            foreach (MagicPost post in mpc)
            {
                //titolo e link di default
                string titolo_val = "",
                        link_val = Request.Url.LocalPath + "?p=" + post.Pk.ToString(),
                        iconClass = post.IconClass.Trim();

                //se Titolo è impostato usa Titolo per il testo della voce del menù
                HtmlGenericControl li = new HtmlGenericControl("li");
                //HtmlAnchor a = new HtmlAnchor();
                HtmlGenericControl a = new HtmlGenericControl("a");

                if (!String.IsNullOrEmpty(iconClass))
                    titolo_val = "<i class=\"fa " + iconClass + "\"></i> ";

                titolo_val += post.Title_RT;

                if (post.Pk == p)
                    li.Attributes["class"] = activeClass;
                
                // Collego a un pagina on a una sezione di Home per i siti Signle page ?
                bool local = false;
                if (CmsConfig.SinglePage)
                {
                    // Assumo che tutti i link del menù sono local ?
                    local = defaultToLocal;
                    // se no verifico se il post è figlio di una Section
                    if (!local)
                        local = post.IsLocalLink();
                }

                 //a.NavigateUrl = Request.Url.LocalPath + "?p=" + post.Pk.ToString();
                switch (post.Tipo)
                {
                    case MagicPostTypeInfo.Menu:
                    case MagicPostTypeInfo.LinkFalso:
                        a.Attributes["href"] = "javascript:;";
                        break;
                    case MagicPostTypeInfo.CollegamentoInternet:
                        a.Attributes["href"] = post.Url;
                        a.Attributes["target"] = "_blank";
                        a.Attributes["class"] = post.ExtraInfo;
                        if (!string.IsNullOrEmpty(post.TestoBreve_RT))
                            a.Attributes["title"] = post.TestoBreve_RT;
                        break;
                    case MagicPostTypeInfo.CollegamentoInterno:
                        int linkPk;
                        if (int.TryParse(post.ExtraInfo, out linkPk))
                            a.Attributes["href"] = "Contenuti.aspx?p=" + post.ExtraInfo;
                        else
                            a.Attributes["href"] = post.Url;
                        if (!string.IsNullOrEmpty(post.TestoBreve_RT))
                            a.Attributes["title"] = post.TestoBreve_RT;
                        break;
                    case MagicPostTypeInfo.ButtonLanguage:
                        if (!String.IsNullOrEmpty(post.Url2) && String.IsNullOrEmpty(post.ExtraInfo1))
                            titolo_val = "";
                        string query = "?";
                        List<string> queryList = new List<string>();
                        foreach (string key in HttpContext.Current.Request.QueryString)
                        {
                            if (key != "lang")
                                queryList.Add( key + "=" + HttpContext.Current.Request.QueryString[key]);
                        }
                        if (queryList.Count > 0)
                            query += String.Join("&", queryList.ToArray());

                        a.Attributes["href"] = Request.Url.AbsolutePath + query + (query != "?" ? "&" : "") + "lang=" + post.ExtraInfo;
                        if (!string.IsNullOrEmpty(post.ExtraInfo2))
                            a.Attributes["class"] = post.ExtraInfo2;
                        break;
                    default:
                        if (local && ThePost != null)
                        {
                            a.Attributes["href"] = "#section_" + post.Pk.ToString();
                            if (ThePost.Pk != StartPageId)
                                a.Attributes["href"] = Request.Url.LocalPath + "?p=" + StartPageId.ToString() + "#section_" + post.Pk.ToString();
                        }
                        else
                            a.Attributes["href"] = Request.Url.LocalPath + "?p=" + post.Pk.ToString();
                        break;
                }

                if (post.Url2 != "" && (post.Tipo == MagicPostTypeInfo.CollegamentoInterno || post.Tipo == MagicPostTypeInfo.ButtonLanguage))
                {
                    HtmlImage img = new HtmlImage();
                    img.Src = post.Url2;
                    a.Controls.Add(img);
                    a.Attributes["title"] = post.Title_RT;
                }
                else
                {
                    a.InnerHtml  = titolo_val;
                    if (!String.IsNullOrEmpty(post.TestoBreve))
                    {
                        //a.Title = post.TestoBreve;
                    }
                }

                li.Controls.Add(a);
                a.Attributes["data-pk"] = post.Pk.ToString();

                if (post.Tipo == MagicPostTypeInfo.Menu)
                {
                    a.Attributes["class"] = "dropdown-toggle";
                    a.Attributes["data-toggle"] = "dropdown";
                    HtmlGenericControl submenu = AggiungiVoci(post.Pk, dropdownClass, dropdownClass, dropDownParentClass, submenuParentClass, activeClass, level + 1, defaultToLocal);
                    if (level == 0)
                        li.Attributes["class"] = dropDownParentClass;
                    else
                        li.Attributes["class"] = submenuParentClass;
                    li.Controls.Add(submenu);
                }
                if (Request["p"] == post.Pk.ToString())
                    a.Attributes["class"] += " active";
                ul.Controls.Add(li);
            }
            return ul;
        }

        protected HtmlGenericControl AggiungiVoci(int menuId, string mainClass, string dropdownClass, string dropDownParentClass,
                                            string submenuParentClass, string activeClass, int level)
        {
            return AggiungiVoci(menuId, mainClass, dropdownClass, dropDownParentClass, submenuParentClass, activeClass, level, true);
        }


		/// <exclude />
        protected HtmlGenericControl AggiungiVoci(int menuId, string cssClass)
        {
            return AggiungiVoci(menuId, cssClass, "submenu", "", "", "", 0, true);
        }

		/// <summary>
		/// Bootstraps menu. Create a Bootstrap compatible menu extracting definition from MagicCMS database.
		/// </summary>
		/// <param name="menuId">The menu <see cref="MagicCMS.MagicPost.Pk"/>. </param>
		/// <param name="cssClass">The CSS class assigned to the menu (ul html element).</param>
		/// <param name="currentPagePk">The current page pk.</param>
		/// <returns>HtmlGenericControl.</returns>
		protected HtmlGenericControl BootstrapMenu(int menuId, string cssClass, int currentPagePk)
		{
			MenuInfoCollection myMenu = new MenuInfoCollection(new MagicPost(menuId), currentPagePk);
			HtmlGenericControl ul = MagicUtils.HTMLElement("ul", cssClass);
			foreach (MenuInfo mi in myMenu)
			{
				HtmlGenericControl li = MagicUtils.HTMLElement("li", mi.ActiveClass);
				li.Controls.Add(mi.LinkElement);
				if (mi.Submenu.Count > 0)
				{
					li.Controls.Add(BootstrapMenu(mi.Pk, "dropdown-menu", currentPagePk));
				}
				ul.Controls.Add(li);
			}
			return ul;
		}

    }
}