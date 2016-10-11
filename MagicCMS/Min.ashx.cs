using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using MagicCMS.Core;

namespace MagicCMS
{
    /// <summary>
	/// Min.ashx Handler that display thumbnails (<see cref="MagicCMS.Core.Miniatura"/> objects) stored in MagicCMS database. On query string you must define a pk parameter corresponding to Miniatura <see cref="MagicCMS.Core.Miniatura.Pk"/>. Return images data (ContentType = "image/jpeg"). 
    /// </summary>
	/// <remarks>If the value provided doesn't corresponds to any existing thumbnails a 404 error status is returned.  </remarks>
    public class Min : IHttpHandler
    {

		/// <exclude />
        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "image/jpeg";
            int image_pk;
            int.TryParse(context.Request["pk"], out image_pk);

            Miniatura min = new Miniatura(image_pk);
            if (min.Pk != 0)
                min.BmpData.Save(context.Response.OutputStream, System.Drawing.Imaging.ImageFormat.Jpeg);
            else
            {
                context.Response.StatusCode = 404;
                context.Response.StatusDescription = "File not found";
            }
        }

		/// <exclude />
        public bool IsReusable
        {
            get
            {
                return false;
            }
        }
    }
}