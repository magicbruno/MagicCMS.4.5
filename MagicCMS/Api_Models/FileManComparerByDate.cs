using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace MagicCMS.Api_Models
{
    public class FileManComparerByDate : IComparer<FileManFileInfo>
    {
        public int Compare(FileManFileInfo x, FileManFileInfo y)
        {
            int result = 0;
            if (x == null && y == null)
                return 0;
            else if (y == null)
                result = -1;
            else if (x.IsDirectory)
            {
                if (y.IsDirectory)
                {
                    result = x.LastAccessTime > y.LastAccessTime ? -1 : 1;
                }
                else
                {
                    result = -1;
                }
            }
            else
            {
                if (y.IsDirectory)
                {
                    result = 1;
                }
                else
                {
                    result = x.LastAccessTime > y.LastAccessTime ? -1 : 1;
                }
            }

            return result;
        }
    }
}