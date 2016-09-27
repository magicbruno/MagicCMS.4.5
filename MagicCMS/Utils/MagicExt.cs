using System;
using System.IO;
using System.Web;

namespace System
{
    public static class MagicExt
    {
        /// <summary>
        /// Gets a random Url in a folder.
        /// </summary>
        /// <param name="url">The URL of the folder where the file is searched</param>
        /// <param name="filter">Optional filter. (Ex.: "*.png")</param>
        /// <returns></returns>
        public static Uri GetRandomUrl(Uri url, string filter)
        {
            if (HttpContext.Current == null)
                return null;

            DirectoryInfo di = new DirectoryInfo(HttpContext.Current.Server.MapPath(url.AbsolutePath));
            if (!di.Exists)
                return null;

            FileInfo[] fileList = di.GetFiles(filter);
            Random rnd = new Random(DateTime.Now.Millisecond);
            int index = rnd.Next(fileList.Length);
            Uri myUri = new Uri(url, fileList[index].Name);
            return myUri;
        }

        /// <summary>
        /// Gets a random Url in a folder.
        /// </summary>
        /// <param name="url">The URL of the folder where the file is searched</param>
        /// <returns></returns>
        public static Uri GetRandomUrl(Uri url)
        {
            return GetRandomUrl(url, "*.*");
        }
    }
}