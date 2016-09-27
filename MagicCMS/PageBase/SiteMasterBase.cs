using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using MagicCMS.Core;

namespace MagicCMS.PageBase
{
    public abstract class SiteMasterBase : System.Web.UI.MasterPage
    {
        public MagicPost ThePost { get; set; }
        public String TheTitle { get; set; }
        public CMS_Config CmsConfig { get; set; }
        public string Keywords { get; set; }
        public string Description { get; set; }
        public string PageImage { get; set; }

        /// <summary>
        /// Gets the connection string.
        /// </summary>
        /// <value>
        /// The connection string.
        /// </value>
        public string ConnectionString
        {
            get
            {
                return MagicUtils.MagicConnectionString;
            }
        }

    }
}