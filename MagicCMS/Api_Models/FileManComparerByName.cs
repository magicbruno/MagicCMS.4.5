using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace MagicCMS.Api_Models
{
    public class FileManComparerByName : IComparer<FileManFileInfo>
    {
        public int Compare (FileManFileInfo x, FileManFileInfo y)
        {
            int result = 0;
            if (x == null && y == null)
                return 0;
            else if(y == null)
                result = -1;
            else if (x.IsDirectory)
            {
                if(y.IsDirectory)
                {
                    result = string.Compare(x.Name, y.Name,StringComparison.InvariantCultureIgnoreCase);
                }
                else
                {
                    result = -1;
                }
            }
            else
            {
                if(y.IsDirectory)
                {
                    result = 1;
                }
                else
                {
                    result = string.Compare(x.Name, y.Name, StringComparison.InvariantCultureIgnoreCase);
                }
            }

            return result;
        }
    }
}