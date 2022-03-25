using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;

namespace MagicCMS.DirectoryTree
{
    public class DirTree : List<DirTreeNode>
    {
        public DirTree()
        {

        }

        public DirTree(string root)
        {
            string directoryRoot = HttpContext.Current.Server.MapPath(root);
            string globalRoot = HttpContext.Current.Server.MapPath("/");
            DirectoryInfo directoryInfo = new DirectoryInfo(directoryRoot);
            string id = "/" + directoryInfo.FullName.Replace(globalRoot, "").Replace("\\", "/");
            Add(new DirTreeNode()
            {
                parent = "#",
                text = directoryInfo.Name,
                id = id,
                icon = "fa fa-folder-o text-primary"
            });

            List<DirectoryInfo> directoryInfos = directoryInfo.EnumerateDirectories("*.*", SearchOption.AllDirectories).ToList();
            foreach (DirectoryInfo di in directoryInfos)
            {
                id = "/" + di.FullName.Replace(globalRoot,"").Replace("\\","/");
                string parent = "/" + di.Parent.FullName.Replace(globalRoot, "").Replace("\\", "/");
                Add(new DirTreeNode()
                {
                    parent = parent,
                    text = di.Name,
                    id = id,
                    icon = "fa fa-folder-o text-primary"
                });
            }

        }
    }
}