using MagicCMS.Core;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace MagicCMS.Api_Models
{
    public class MagicPostOpParameters
    {
        public List<int> PkList { get; set; }
        public string OperationStr { get; set; }

        public LogAction Operation 
        { get
            {
                if (Enum.TryParse<LogAction>(OperationStr, out LogAction op))
                    return op;
                return LogAction.Unknown;
            }

        }
    }
}