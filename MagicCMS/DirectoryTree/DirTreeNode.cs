using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace MagicCMS.DirectoryTree
{
    public class DirTreeNode
    {
        public string id { get; set; }
        public string parent { get; set; }
        public string text { get; set; }
        public string icon { get; set; }
        public NodeState state { get; set; }

        public DirTreeNode()
        {
            id = parent = text = icon = "";
            state = new NodeState()
            {
                opened = true,
                disabled = false,
                selected = false
            };
        }
    }

    public class NodeState
    {
        public bool opened { get; set; }
        public bool disabled { get; set; }
        public bool selected { get; set; }
    }
}