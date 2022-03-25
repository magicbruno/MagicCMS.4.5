using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;

namespace MagicCMS.DirectoryTree
{
    /// <summary>
    /// DireNode versione ricorsiva
    /// </summary>
    public class DirNodeChildren
    {
        public string id { get; set; }
        public List<DirNodeChildren> children { get; set; }
        public string text { get; set; }
        public string icon { get; set; }
        public NodeState state { get; set; }

        public DirNodeChildren()
        {

        }

        public DirNodeChildren(string root)
        {
            DirectoryInfo directoryInfo = new DirectoryInfo(root);
            string globalroot = HttpContext.Current.Server.MapPath("/");
            string myid = "/" + directoryInfo.FullName.Replace(globalroot, "").Replace("\\", "/");
            id = myid;
            text = directoryInfo.Name;
            icon = "fa fa-folder-o text-primary";
            state = new NodeState();
            state.opened = true;
            children = new List<DirNodeChildren>();
            List<DirectoryInfo> childrenDirs = directoryInfo.EnumerateDirectories()
                .Where((f) => { return !f.Attributes.HasFlag(FileAttributes.Hidden); })
                .ToList();
            foreach (DirectoryInfo dir in childrenDirs)
            {
                DirNodeChildren node = new DirNodeChildren(dir.FullName);
                node.state.opened = false;
                children.Add(node);
            }
        }
    }

}