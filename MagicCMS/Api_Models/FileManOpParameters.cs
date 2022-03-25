using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace MagicCMS.Api_Models
{
    public class FileManOpParameters
    {
        public string OperationStr { get; set; }
        public string Input { get; set; }
        public string Destination { get; set; }

        private bool? _overwrite = false;
        public bool? Overwrite
        {
            get 
            { 
                if (!_overwrite.HasValue)
                    return false; 
                return _overwrite.Value;
            }
            set { _overwrite = value; }
        }

        public FileManOperation? Operation {
            get
            {
                if (Enum.TryParse<FileManOperation>(OperationStr, out FileManOperation op))
                    return op;
                return null;
            } 
        }
    }

    public enum FileManOperation
    {
        Rename, Delete, Move, Copy, Create
    }
}