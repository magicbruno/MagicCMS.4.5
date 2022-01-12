using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.SessionState;
using MagicCMS.Core;

namespace MagicCMS.Admin.Ajax
{
    /// <summary>
    /// Descrizione di riepilogo per GetParentsTreeJSON
    /// </summary>
    public class GetParentsTreeJSON : IHttpHandler, IRequiresSessionState
    {

        public void ProcessRequest(HttpContext context)
        {
            if (MagicSession.Current.LoggedUser.Level < 4)
            {
                context.Response.StatusCode = 403;
                context.Response.StatusDescription = "Prerogative non sufficienti";
                context.Response.ContentType = "text/html";
                //context.Response.Write("Sessione scaduta.");
                return;
            }
            int pk = 0, defaultParent = 0;
            int.TryParse(context.Request["pk"], out pk);
            int.TryParse(context.Request["parent"], out defaultParent);

            System.Web.Script.Serialization.JavaScriptSerializer serializer = new System.Web.Script.Serialization.JavaScriptSerializer();
             JTreeNodeCollection output = AddNodeList(0, pk, 0, defaultParent);
            string json = serializer.Serialize(output);

            context.Response.ContentType = "application/json";
            context.Response.Charset = "UTF-8";
            context.Response.Write(json);
        }

        private  JTreeNodeCollection AddNodeList(int parent_id, int id_articolo, int level, int defaultParent)
        {

             JTreeNodeCollection theList = new JTreeNodeCollection();
            if (parent_id == id_articolo && parent_id != 0)  
                return theList;
            MagicTag mp_parent = new MagicTag(parent_id);
            int tipo = mp_parent.Tipo;
            if (tipo == MagicPostTypeInfo.Calendario /*|| tipo == MagicPostTypeInfo.Tag*/)
                return theList;

            MagicPostCollection parents = mp_parent.GetParents();
            List<int> checkList = MagicPost.GetParentsIds(id_articolo);

            MagicTagCollection mtc = new MagicTagCollection(parent_id, MagicTagContainer.Container, null, 0);
            foreach (MagicTag tag in mtc)
            {
                if (tag.Pk != id_articolo)
                {
                    string uniqueId = new Random(DateTime.Now.Millisecond).Next(100000).ToString();
                    Boolean loadChildren = true;
                    JTreeNode node = new JTreeNode();
                    node.id = tag.Pk.ToString() + "_" + parent_id.ToString() + "_" + level.ToString() + "_" + uniqueId;
                    node.text = tag.Titolo;
                    node.icon = "fa " + tag.Icon;
                    node.state = new JTreeNodeState();
                    node.state.disabled = false;
                    node.state.opened = false;
                    node.state.selected = checkList.Contains(tag.Pk) || tag.Pk == defaultParent;
                    node.a_attr = new Dictionary<string,string>();
                    node.a_attr.Add("data-pk", tag.Pk.ToString());
                    node.a_attr.Add("title", tag.Titolo + " (" + tag.NomeTipo + ")");
                    node.li_attr = new Dictionary<string, string>();
                    for (int i = 0; i < parents.Count; i++)
                    {
                        if (parents[i].Pk == tag.Pk)
                        {
                            loadChildren = false;
                        }
                    }
                     JTreeNodeCollection subitems;
                    if (level < 10 && loadChildren && (!tag.SpecialTag))
                    {
                        int l = level + 1;
                        subitems = AddNodeList(tag.Pk, id_articolo, l, defaultParent);
                        node.children = subitems;
                        foreach (JTreeNode item in node.children)
                        {
                            if (item.state.selected)
                                node.state.opened = true;
                        }
                    }
                    theList.Add(node);
                }
            }
            return theList;
        }

        public bool IsReusable
        {
            get
            {
                return false;
            }
        }
    }
}