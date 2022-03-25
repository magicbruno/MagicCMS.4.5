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
    public class FileManController : ApiController
    {
        // GET api/<controller>
        public IEnumerable<FileManFileInfo> Get(string root = "", string order = "alpha", string dir = "ASC")
        {
            if (String.IsNullOrWhiteSpace(root))
                root = ConfigurationManager.AppSettings["FileManagerRoot"];
            string physicalRoot = HttpContext.Current.Server.MapPath(root);
       
            FileInfo fi = new FileInfo(physicalRoot);
             
            string folder = (fi.Attributes.HasFlag(FileAttributes.Directory)) ? physicalRoot : Path.GetDirectoryName(physicalRoot);

            if (!Directory.Exists(folder))
                folder = HttpContext.Current.Server.MapPath(ConfigurationManager.AppSettings["FileManagerRoot"]);

            

            //if ((fi.Attributes & FileAttributes.Directory) != FileAttributes.Directory)
            //    physicalRoot = fi.Directory.FullName;
            DirectoryInfo directoryInfo = new DirectoryInfo(folder);

            DateTime lastAccess = directoryInfo.LastAccessTime;

            


            List<FileSystemInfo> files = directoryInfo.EnumerateFileSystemInfos()
                .Where((f) => { return !f.Attributes.HasFlag(FileAttributes.Hidden); })
                .ToList();
            //directoryInfo.LastAccessTime = lastAccess;

            List<FileManFileInfo> result = new List<FileManFileInfo>();
            int id = 0;
            foreach (var file in files)
            {
                
                FileManFileInfo manFileInfo = new FileManFileInfo(file.FullName);

                // Il file è stato passato insieme al path
                manFileInfo.Selected = file.FullName.ToLower() == fi.FullName.ToLower();
                manFileInfo.Id = id;
                result.Add(manFileInfo);
                id++;
            }
            
            if (order == "alpha")
            {
                FileManComparerByName comparerByName = new FileManComparerByName();
                result.Sort(comparerByName);
            }
            else
            {
                FileManComparerByDate comparerByDate = new FileManComparerByDate();
                result.Sort(comparerByDate);
            }

            if ((dir == "ASC" && order == "date") || (dir == "DESC" && order == "alpha"))
            {
                List<FileManFileInfo> temp = new List<FileManFileInfo>();
                foreach(var item in result)
                {
                    if(!item.IsDirectory)
                        temp.Add(item);
                }
                foreach (var item in result)
                {
                    if (item.IsDirectory)
                        temp.Add(item);
                }
                temp.Reverse();
                return temp;
            };
            

            return result;
        }

        // GET api/<controller>/5
        public string Get(int id)
        {
            return "value";
        }

        // POST api/<controller>
        public void Post([FromBody] string value)
        {
        }

        // PUT api/<controller>/5
        public void Put(int id, [FromBody] string value)
        {
        }

        // DELETE api/<controller>/5
        public void Delete(int id)
        {
        }
    }
}