using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using MagicCMS.Core;

namespace MagicCMS.Admin
{
    public partial class Config : System.Web.UI.Page
    {
        public MagicCMS.Core.CMS_Config CMS_config { get; set; }
        public List<string> StartPageList { get; set; }

        protected void Page_Load(object sender, EventArgs e)
        {
            Master.MinLevel = 10;
            CMS_config = new Core.CMS_Config();
            StartPageList = new List<string>(); 
            StartPageList.Add(MagicPostTypeInfo.Argomento.ToString());
            StartPageList.Add(MagicPostTypeInfo.HomePage.ToString());
            StartPageList.Add(MagicPostTypeInfo.News.ToString());
            StartPageList.Add(MagicPostTypeInfo.PaginaContatti.ToString());
            StartPageList.Add(MagicPostTypeInfo.PaginaConVideo.ToString());
            StartPageList.Add(MagicPostTypeInfo.PaginaStandard.ToString());
            StartPageList.Add(MagicPostTypeInfo.PaginaConPannelliPersonalizzati.ToString());
            StartPageList.Add(MagicPostTypeInfo.ComingSoon.ToString());
            StartPageList.Add(MagicPostTypeInfo.Mappa.ToString());
            StartPageList.Add(MagicPostTypeInfo.Calendario.ToString());
            StartPageList.Add(MagicPostTypeInfo.Galleria.ToString());
            StartPageList.Add(MagicPostTypeInfo.GalleriaAutomatica.ToString());
        }
    }
}