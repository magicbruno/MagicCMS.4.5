using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using MagicCMS.Core;
using System.Web.UI.WebControls;

namespace MagicCMS.PageBase
{
	/// <summary>
	/// Class Monopage. <see cref="MagicCMS.PageBase.MasterTheme" /> descendant that define properties and methods for home monopage.  
	/// </summary>
	/// <seealso cref="MagicCMS.PageBase.MasterTheme" />
    public class Monopage: MasterTheme
    {
        public string ColClass { get; set; }
        new protected void Page_Load(object sender, EventArgs e)
        {
            base.Page_Load(sender, e);
            MagicPostCollection sections = ThePost.GetChildrenByType(MagicPostTypeInfo.Section);
            foreach (MagicPost section in sections)
            {
                Repeater sectionRepeater = this.FindControlRecursive(section.Titolo) as Repeater;
                if (sectionRepeater != null)
                {
                    MagicPostCollection sectionChildren = section.GetChildren();
                    if (sectionChildren.Count > 0)
                    {
                        sectionRepeater.DataSource = sectionChildren;
                        sectionRepeater.DataBind();
                    }
                }
            }
        }

        protected void Section_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            RepeaterItem item = e.Item;
            if (item.ItemType == ListItemType.AlternatingItem || item.ItemType == ListItemType.Item)
            {
                MagicPost mp = item.DataItem as MagicPost;
                int maxNum = (mp.Larghezza > 0 ? mp.Larghezza : -1);
                MagicPostCollection mpc = mp.GetChildren(mp.OrderChildrenBy, maxNum);
                Repeater selfChild = item.FindControlRecursive("SectionChildren") as Repeater;
                if (selfChild != null)
                {
                    selfChild.DataSource = mpc;
                    selfChild.DataBind();
                }
            }
        }


        protected void MultiRow_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            RepeaterItem theItem = e.Item;
            if (theItem.ItemType == ListItemType.AlternatingItem || theItem.ItemType == ListItemType.Item)
            {
                MagicPost mp = e.Item.DataItem as MagicPost;
                int maxNum = (mp.Larghezza > 0 ? mp.Larghezza : -1);
                MagicPostCollection mpc = mp.GetChildren(mp.OrderChildrenBy, maxNum);

                ColClass = String.IsNullOrEmpty(mp.CustomClass) ? "col-sm-3" : mp.CustomClass;
                int colsNum;

                switch (ColClass)
                {
                    case "col-sm-1":
                    case "col-md-1":
                        colsNum = 12;
                        break;
                    case "col-sm-2":
                    case "col-md-2":
                        colsNum = 6;
                        break;
                    case "col-sm-3":
                    case "col-md-3":
                        colsNum = 4;
                        break;
                    case "col-sm-4":
                    case "col-md-4":
                        colsNum = 3;
                        break;
                    case "col-sm-5":
                    case "col-sm-6":
                    case "col-md-5":
                    case "col-md-6":
                        colsNum = 2;
                        break;
                    default:
                        colsNum = 1; 
                        break;
                }

                List<MagicPostCollection> row_grpup = new List<MagicPostCollection>();
                while (mpc.Count > 0)
                {
                    MagicPostCollection row = new MagicPostCollection();
                    for (int i = 0; i < colsNum; i++)
                    {
                        if (mpc.Count > 0)
                        {
                            row.Add(mpc[0]);
                            mpc.RemoveAt(0);
                        }
                    }
                    row_grpup.Add(row);
                }
                Repeater rows = theItem.FindControlRecursive("Rows") as Repeater;
                if (rows != null)
                {
                    rows.DataSource = row_grpup;
                    rows.DataBind();
                }

            }
        }

        protected void Rows_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            RepeaterItem theItem = e.Item;
            if (theItem.ItemType == ListItemType.AlternatingItem || theItem.ItemType == ListItemType.Item)
            {
                MagicPostCollection row = theItem.DataItem as MagicPostCollection;

                Repeater cols = theItem.FindControlRecursive("Cols") as Repeater;
                if (cols != null)
                {
                    cols.DataSource = row;
                    cols.DataBind();
                }
            }
        }


    }
}