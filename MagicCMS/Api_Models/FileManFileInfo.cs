using MagicCMS.Imaging;
using MagicCMS.MBFileMan;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;

namespace MagicCMS.Api_Models
{
    public class FileManFileInfo
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public string Extension { get; private set; }
        public string FullName { get; private set; }
        public string Url { get; private set; }
        public string EncodedUrl 
        {
            get
            {
                return HttpUtility.UrlEncode(Url);
            }
        }
        public long Length { get; set; }
        public bool IsDirectory { get; set; }
        public string FormattedLenght {
            get
            {
                if (Length < 1024)
                {
                    return Length.ToString() + " byte";
                }
                else if (Length < 1024 * 1024)
                {
                    return Math.Round((double)Length / 1024).ToString() + " Kb";
                }
                else if (Length < 1024 * 1024 * 1024 )
                {
                    return Math.Round((double)Length / (1024*1024),1).ToString() + " Mb";
                }
                else
                {
                    return Math.Round((double)Length / (1024 * 1024 * 1024), 3).ToString() + " Gb";
                }
            }
        }

        public DateTime CreationTime { get; private set; }
        public DateTime LastAccessTime { get; private set; }
        public DateTime LastWriteTime { get; private set; }
        public bool Selected { get; set; }
        public string Type { get; private set; }

        public string LastWriteTimeStr { 
            get 
            { 
                return LastWriteTime.ToString("dd/MM/yyyy HH:MM");
            } 
        }

        public string CreationTimeStr
        {
            get
            {
                return CreationTime.ToString("dd/MM/yyyy");
            }
        }

        public string LastAccessTimeStr
        {
            get
            {
                return LastAccessTime.ToString("dd/MM/yyyy HH:MM");
            }
        }

        private static string AppRoot() {
            return HttpContext.Current.Server.MapPath("~/");
        }

        private void Init(FileInfo fi)
        {
            
            Name = fi.Name;
            Extension = fi.Extension;
            FullName = "";
            Url ="/" + fi.FullName.Substring(HttpContext.Current.Request.PhysicalApplicationPath.Length).Replace("\\", "/");
            IsDirectory = (fi.Attributes & FileAttributes.Directory) == FileAttributes.Directory;
            if (!IsDirectory) Length = fi.Length;
            CreationTime = fi.CreationTime;
            LastAccessTime = fi.LastAccessTime;
            LastWriteTime = fi.LastWriteTime;
            Selected = false;
            Type = FileManIcons.GetIconType(fi).ToString();
        }
        private void Init(string path)
        {
            FileInfo fi = new FileInfo(path);
            Init(fi);
        }


        public FileManFileInfo(string path)
        {
            Init(path);
        }

        public FileManFileInfo(FileInfo fi)
        {
            Init(fi);
        }

    }

}