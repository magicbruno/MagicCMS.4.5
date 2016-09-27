using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace MagicCMS.Core
{
    public class JTreeNode
    {
        public string id { get; set; }
        public string text { get; set; }
        public string icon { get; set; }
        public JTreeNodeState state { get; set; }
        public List<JTreeNode> children { get; set; }
        public Dictionary<string,string> li_attr { get; set; }
        public Dictionary<string, string> a_attr { get; set; }
    }

    public class JTreeNodeState
    {
        public Boolean opened { get; set; }
        public Boolean disabled { get; set; }
        public Boolean selected { get; set; }
    }
}