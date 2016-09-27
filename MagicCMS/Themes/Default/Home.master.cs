using MagicCMS.Core;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace MagicCMS.Themes.Default
{
    public partial class Home : MagicCMS.PageBase.MasterTheme
    {
        public MagicPostCollection slides;
        new protected void Page_Load(object sender, EventArgs e)
        {
            base.Page_Load(sender, e);
            MagicPostCollection sq = ThePost.GetChildrenByType(MagicPostTypeInfo.Sequenza);
            MagicPost sequenza = (sq.Count > 0 ? sq[0] : null);

            if (sequenza != null)
            {
                slides = sequenza.GetChildren(MagicOrdinamento.Asc, 20);
            }
            else
            {
                slides = new MagicPostCollection();
            }
            RepeaterSequenza.DataSource = slides;
            RepeaterSequenza.DataBind();
        }
    }
}