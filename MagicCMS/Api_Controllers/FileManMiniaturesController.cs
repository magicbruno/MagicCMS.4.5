using MagicCMS.Imaging;
using MagicCMS.MBFileMan;
using System;
using System.Collections.Generic;
using System.Drawing;
using System.Drawing.Imaging;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Threading.Tasks;
using System.Web;
using System.Web.Http;

namespace MagicCMS.Api_Controllers
{
    public class FileManMiniaturesController : ApiController
    {
        // GET api/<controller>
        public HttpResponseMessage Get(string filename)
        {
;
            HttpResponseMessage response = null;
            try
            {
                string localPath = HttpContext.Current.Server.MapPath(HttpUtility.UrlDecode(filename));
                FileInfo fi = new FileInfo(localPath);
                
                string svgIcon = FileManIcons.GetIcon(fi);

                MemoryStream stream = null;

                if (string.IsNullOrEmpty(svgIcon))
                {
                    DateTime lastAccess = fi.LastAccessTime;
                    Image img = Image.FromFile(localPath);
                    
                    //ImageFormat format = img.RawFormat;
                    //ImageCodecInfo codec = ImageCodecInfo.GetImageDecoders().First(c => c.FormatID == format.Guid);
                    //string mimeType = codec.MimeType;

                    byte[] thumb = Thumbnails.ResizeImage(img, 240, 240, fi.Extension);
                    img.Dispose();
                    fi.LastAccessTime = lastAccess;

                    stream = new MemoryStream(thumb);
                    //StreamWriter sw = new StreamWriter(stream);
                    stream.Seek(0, SeekOrigin.Begin);
                    response = new HttpResponseMessage(HttpStatusCode.OK);

                    response.Content = new StreamContent(stream);
                    //response.Content.Headers.ContentDisposition = new System.Net.Http.Headers.ContentDispositionHeaderValue("attachment");
                    //response.Content.Headers.ContentDisposition.FileName = "thumb" + fi.Extension;
                    response.Content.Headers.ContentType = new MediaTypeHeaderValue("image/jpeg"); 
                }
                else
                {
                    //stream = new MemoryStream();
                    //StreamWriter sw = new StreamWriter(stream);
                    //sw.Write(svgIcon);
                    //stream.Seek(0, SeekOrigin.Begin);
                    response = new HttpResponseMessage(HttpStatusCode.OK);

                    response.Content = new StringContent(svgIcon);
                    //response.Content.Headers.ContentDisposition = new System.Net.Http.Headers.ContentDispositionHeaderValue("attachment");
                    //response.Content.Headers.ContentDisposition.FileName = "thumb" + fi.Extension;
                    response.Content.Headers.ContentType = new MediaTypeHeaderValue("image/svg+xml");
                }

            }
            catch (HttpException ex)
            {
                response = new HttpResponseMessage((HttpStatusCode)ex.GetHttpCode()) { Content = new StringContent(ex.Message) };
            }
            catch (Exception e)
            {
                response = new HttpResponseMessage(HttpStatusCode.InternalServerError) { Content = new StringContent(e.Message) };
            }

            return response;
        }
    }
}