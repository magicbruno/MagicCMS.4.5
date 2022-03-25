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
    public class FileManGetRecentsController : ApiController
    {
        public IEnumerable<FileManFileInfo> Get(int max = 50)
        {
 
            string  root = ConfigurationManager.AppSettings["FileManagerRoot"];
            string physicalRoot = HttpContext.Current.Server.MapPath(root);
            DirectoryInfo dirInfo = new DirectoryInfo(physicalRoot);
            List<FileInfo> files;
            files = dirInfo.EnumerateFiles("*.*", SearchOption.AllDirectories)
                .OrderByDescending(f => f.LastAccessTime)
                .Take(max)
                .ToList();

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