using MagicCMS.Api_Models;
using MagicCMS.Core;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Security.Authentication;
using System.Threading.Tasks;
using System.Web;
using System.Web.Http;

namespace MagicCMS.Api_Controllers
{
    public class CK_FileUploadController : ApiController
    {
        public async Task<CK_UploadResponse> PostAsync(string token)
        {
            CK_UploadResponse response = new CK_UploadResponse()
            {
                uploaded = 0,
                fileName = "",
                url = ""
            };
            
            try
            {
                
                //HttpRequestMessage re = Request;
                //string token = re.Headers.Authorization.Parameter;
                UserToken userToken = new UserToken(token);
                if (userToken.IsExpired)
                {
                    throw new AuthenticationException("Token di accesso non valido.");
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
                if (!dirInfo.Exists)
                {
                    dirInfo.Create();
                    dirInfo.Attributes = FileAttributes.Directory | FileAttributes.Hidden;
                }

                if (!dirInfo.Attributes.HasFlag(FileAttributes.Hidden))
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

                if (!Directory.Exists(dir))
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
                response.url = "/" + fullname.Replace(HttpContext.Current.Server.MapPath("/"), "").Replace("\\", "/");
                response.fileName = provider.FileData[0].Headers.ContentDisposition.FileName;
                response.uploaded = 1;

            }
            catch (Exception e)
            {
                throw e;
            }
            return response;
        }

    }
}