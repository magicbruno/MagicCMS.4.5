using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using MagicCMS.Core;

namespace MagicCMS
{
    /// <summary>
    /// Descrizione di riepilogo per Min
    /// </summary>
    public class Min : IHttpHandler
    {

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

        public bool IsReusable
        {
            get
            {
                return false;
            }
        }
    }
}