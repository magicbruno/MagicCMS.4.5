using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace MagicCMS.Core
{
    public class JTreeNodeCollection : List<JTreeNode>
    {
        public JTreeNodeCollection()
        {

        }

        public void AddNodeList(JTreeInfoList treeInfos, int treeInfosPart, int postPk, List<int> postParents, int level = 0)
        {
            JTreeInfoList children = treeInfos.GetChildren(treeInfosPart);  
            foreach (JTreeInfo info in children)
            {
                
                string uniqueId = new Random(DateTime.Now.Millisecond).Next(100000).ToString();
                if (postPk != info.Pk)
                {
                    JTreeNode node = new JTreeNode();
                    node.id = info.Pk.ToString() + "_" + info.Parent.ToString() + "_" + uniqueId;
                    node.text = info.Titolo;
                    node.icon = "fa " + info.Icon;
                    node.state = new JTreeNodeState();
                    node.state.disabled = false;
                    node.state.opened = false;
                    node.state.selected = postParents.Contains(info.Pk);
                    node.a_attr = new Dictionary<string, string>();
                    node.a_attr.Add("data-pk", info.Pk.ToString());
                    node.a_attr.Add("title", info.Titolo + " (" + info.NomeTipo + ")");
                    node.li_attr = new Dictionary<string, string>();
                    level++;
                    node.children = new JTreeNodeCollection();
                    if (level < 15)
                        node.children.AddNodeList(treeInfos, info.Pk, postPk, postParents, level);
                    Add(node);
                }

            }
        }
    }
}