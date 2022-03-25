using MagicCMS.Core;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Threading.Tasks;
using System.Web;
using System.Web.Http;

namespace MagicCMS.Api_Controllers
{
    public class FileUploadController : ApiController
    {
        // GET api/<controller>
        public IEnumerable<string> Get()
        {
            return new string[] { "value1", "value2" };
        }

        // POST api/<controller>
        public async Task<AjaxJsonResponse> PostAsync()
        {
            AjaxJsonResponse response = new AjaxJsonResponse()
            {
                success = true,
                exitcode = 0,
                data = null,
                msg = "Ok"
            };
            try
            {
                HttpRequestMessage re = Request;
                string token = re.Headers.Authorization.Parameter;
                UserToken userToken = new UserToken(token);
                if (userToken.IsExpired)
                {
                    throw new Exception("Token non valido");
                }

                if (!Request.Content.IsMimeMultipartContent())
                {
                    throw new HttpResponseException(HttpStatusCode.UnsupportedMediaType);
                }
                string globalRoot = ConfigurationManager.AppSettings["FileManagerRoot"];

                //string temp = Path.GetTempPath();
                string temp = HttpContext.Current.Server.MapPath(globalRoot);
                if (!Directory.Exists(temp))
                {
                    temp = "c:\\temp";
                }
                else
                {
                    temp = Path.Combine(temp, "__temp__");
                }
                DirectoryInfo dirInfo = new DirectoryInfo(temp);
                if(!dirInfo.Exists)
                {
                    dirInfo.Create();
                    dirInfo.Attributes = FileAttributes.Directory | FileAttributes.Hidden;
                }
                    
                if(!dirInfo.Attributes.HasFlag(FileAttributes.Hidden))
                    dirInfo.Attributes |= FileAttributes.Hidden;

                var provider = new MultipartFormDataStreamProvider(temp);
                await Request.Content.ReadAsMultipartAsync(provider);
                if (provider.FileData.Count == 0)
                {
                    throw new Exception("Non è stato iviato alcun file.");
                }
                string root, destname, rootname, fullname;

                if (!string.IsNullOrEmpty(provider.FormData["root"]))
                    root = provider.FormData["root"];
                else
                    root = globalRoot;



                // Show all the key-value pairs.
                MultipartFileData filedata = provider.FileData[0];

                if (!string.IsNullOrEmpty(provider.FormData["destination"]))
                {
                    fullname = HttpContext.Current.Server.MapPath(provider.FormData["destination"]) + @"\" + filedata.Headers.ContentDisposition.FileName.Replace("\"", "");
                }                 
                else
                {
                    destname = @"uploads\" + DateTime.Today.ToString("yyyy-MM") + @"\" + filedata.Headers.ContentDisposition.FileName.Replace("\"", "");
                    rootname = HttpContext.Current.Server.MapPath(root);
                    fullname = Path.Combine(rootname, destname);
                }
                    

                string filename = filedata.LocalFileName;

                string dir = Path.GetDirectoryName(fullname);

                if(!Directory.Exists(dir))
                    Directory.CreateDirectory(dir);

                FileInfo fileInfo = new FileInfo(filename);
                int i = 1;
                while (File.Exists(fullname))
                {
                    fullname = Path.Combine(
                         Path.GetDirectoryName(fullname),
                         Path.GetFileNameWithoutExtension(fullname) + String.Format("({0})", i) +
                         Path.GetExtension(fullname));
                    i++;
                }
                fileInfo.MoveTo(fullname);
                response.data = "/" + fullname.Replace(HttpContext.Current.Server.MapPath("/"), "").Replace("\\", "/");
            }
            catch (Exception e)
            {
                response.success = false;
                response.exitcode = e.HResult;
                response.msg = e.Message;
            }
            return response;
        }

    }
}