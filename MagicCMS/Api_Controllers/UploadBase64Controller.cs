using HeyRed.Mime;
using MagicCMS.Api_Models;
using MagicCMS.Core;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Threading.Tasks;
using System.Web;
using System.Web.Http;

namespace MagicCMS.Api_Controllers
{
    public class UploadBase64Controller : ApiController
    {
        // GET api/<controller>
        public IEnumerable<string> Get()
        {
            return new string[] { "nulla", "niente" };
        }

        // POST api/<controller>
        public async Task<AjaxJsonResponse> PostAsync([FromBody] UploadBase64Model inputData)
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
                if(inputData.Codec != "base64")
                {
                    throw new InvalidOperationException("Codec non supportato");
                }
                var bytesData = Convert.FromBase64String(inputData.ImageData);

                string originalFull = HttpContext.Current.Server.MapPath(inputData.OriginalFullName);
                string originalName =Path.GetFileName(originalFull);
                string extension = MimeTypesMap.GetExtension(inputData.MineType);
                if (!string.IsNullOrWhiteSpace(extension))
                    extension = "." + extension;
                string newName = inputData.NewName;
                if (!string.IsNullOrWhiteSpace(newName))
                {
                    originalFull = Path.Combine(Path.GetDirectoryName(originalFull), newName);
                }
                originalFull = Path.Combine(Path.GetDirectoryName(originalFull), Path.GetFileNameWithoutExtension(originalFull) + extension);
                
                FileInfo info = new FileInfo(originalFull);
                if(inputData.Overwrite.Value && info.Exists)
                    info.Delete();
                else 
                {
                    int i = 0;
                    while (info.Exists)
                    {
                        originalFull = Path.Combine(
                             Path.GetDirectoryName(originalFull),
                             Path.GetFileNameWithoutExtension(originalFull) + String.Format("({0})", i) +
                             Path.GetExtension(originalFull));
                        i++;
                        info = new FileInfo(originalFull);
                    }
                }
                   
                FileStream fileStream = info.Create();
                await fileStream.WriteAsync(bytesData, 0, bytesData.Length);
                fileStream.Close();
                response.data = inputData.OriginalFullName.Replace(originalName, info.Name);
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