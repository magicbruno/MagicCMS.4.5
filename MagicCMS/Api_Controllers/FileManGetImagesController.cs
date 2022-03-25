using MagicCMS.Api_Models;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web;
using System.Web.Http;

namespace MagicCMS.Api_Controllers
{
    public class FileManGetImagesController : ApiController
    {
        public static readonly string[] HanledImage = (".apng|.gif|.jpg|.jpeg|.jfif|.pjpeg|.pjp|.webp|.png|.svg").Split('|');
        // GET api/<controller>
        public IEnumerable<FileManFileInfo> Get(string root = "", string order = "date", string dir = "desc", int max = 0)
        {
            if (String.IsNullOrWhiteSpace(root))
                root = ConfigurationManager.AppSettings["FileManagerRoot"];
            string physicalRoot = HttpContext.Current.Server.MapPath(root);
            DirectoryInfo dirInfo = new DirectoryInfo(physicalRoot);
            List<FileInfo> files;
            if (order == "date")
            {
                if (dir == "desc")
                {
                    if(max == 0)
                        files = dirInfo.EnumerateFiles("*.*", SearchOption.AllDirectories)
                            .Where((f) => { return HanledImage.Contains(f.Extension.ToLower()); })
                            .OrderByDescending(f => f.LastWriteTime )
                            .ToList();
                    else
                        files = dirInfo.EnumerateFiles("*.*", SearchOption.AllDirectories)
                           .Where((f) => { return HanledImage.Contains(f.Extension.ToLower()); })
                           .OrderByDescending(f => f.LastWriteTime)
                           .Take(max)
                           .ToList();
                } 
                else
                {
                    if (max == 0)
                        files = dirInfo.EnumerateFiles("*.*", SearchOption.AllDirectories)
                            .Where((f) => { return HanledImage.Contains(f.Extension.ToLower()); })
                            .OrderBy(f => f.LastWriteTime )
                            .ToList();
                    else
                        files = dirInfo.EnumerateFiles("*.*", SearchOption.AllDirectories)
                            .Where((f) => { return HanledImage.Contains(f.Extension.ToLower()); })
                            .OrderBy(f => f.LastWriteTime)
                            .Take(max)
                            .ToList();
                }
            }
            else
            {
                if (dir == "desc")
                {
                    if (max == 0)
                        files = dirInfo.EnumerateFiles("*.*", SearchOption.AllDirectories)
                            .Where((f) => { return HanledImage.Contains(f.Extension.ToLower()); })
                            .OrderByDescending(f => f.Name)
                            .ToList();
                    else
                        files = dirInfo.EnumerateFiles("*.*", SearchOption.AllDirectories)
                           .Where((f) => { return HanledImage.Contains(f.Extension.ToLower()); })
                           .OrderByDescending(f => f.Name)
                           .Take(max)
                           .ToList();
                }
                else
                {
                    if (max == 0)
                        files = dirInfo.EnumerateFiles("*.*", SearchOption.AllDirectories)
                            .Where((f) => { return HanledImage.Contains(f.Extension.ToLower()); })
                            .OrderBy(f =>  f.Name)
                            .ToList();
                    else
                        files = dirInfo.EnumerateFiles("*.*", SearchOption.AllDirectories)
                           .Where((f) => { return HanledImage.Contains(f.Extension.ToLower()); })
                           .OrderBy(f => f.Name)
                           .Take(max)
                           .ToList();
                }
            }

            List<FileManFileInfo> result = new List<FileManFileInfo>();
            int id = 0;
            foreach (var file in files)
            {
                FileManFileInfo manFileInfo = new FileManFileInfo(file);

                // Il file è stato passato insieme al path
                manFileInfo.Selected = file.FullName.ToLower() == root.ToLower();
                manFileInfo.Id = id;
                result.Add(manFileInfo);
                id++;
            }

            return result;
        }

    }
}