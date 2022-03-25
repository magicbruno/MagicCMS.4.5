using MagicCMS.Api_Models;
using MagicCMS.Core;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web;
using System.Web.Http;

namespace MagicCMS.Api_Controllers
{
    public class FileManOpController : ApiController
    {
        // GET api/<controller>
        public IEnumerable<string> Get()
        {
            return new string[] { "nessun", "valore" };
        }

        // POST api/<controller>
        public AjaxJsonResponse Post([FromBody] FileManOpParameters par)
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

                if(par.Operation == null)
                {
                    throw new Exception(String.Format("\"{0}\" non è un operazione valida!", par.OperationStr));
                }

                FileInfo origin = new FileInfo(HttpContext.Current.Server.MapPath(par.Input));
                FileInfo destinfo = null;
                string destination;
                switch (par.Operation)
                {
                    case FileManOperation.Delete:
                        if ((origin.Attributes & FileAttributes.Directory) != FileAttributes.Directory)
                            origin.Delete();
                        else
                            Directory.Delete(origin.FullName, true);
                        break;
                    case FileManOperation.Move:
                    case FileManOperation.Copy:
                        destination = HttpContext.Current.Server.MapPath(par.Destination);
                        if((origin.Attributes & FileAttributes.Directory) != FileAttributes.Directory)
                            destination = Path.Combine(destination, origin.Name);
                        destinfo = new FileInfo(destination);
                      break;
                    case FileManOperation.Rename:
                        destination = Path.Combine(origin.Directory.FullName, par.Destination);
                        destinfo = new FileInfo(destination);
                        break;
                    case FileManOperation.Create:
                        destination = Path.Combine(origin.FullName, par.Destination);
                        //destinfo = new FileInfo(destination);
                        Directory.CreateDirectory(destination);
                        break;
                    default:
                        break;
                }
                if (destinfo != null )
                {
                    if(destinfo.Exists)
                    {
                        if(par.Overwrite.Value)
                        {
                            destinfo.Delete();
                        }
                        else
                        {
                            response.success = false;
                            response.exitcode = 0;
                            response.msg = "Impossibile completare l'operazione. Nome file esistente!";
                            return response;
                        }
                    }
                    if (par.Operation == FileManOperation.Copy)
                    {
                        if ((origin.Attributes & FileAttributes.Directory) != FileAttributes.Directory)
                            origin.CopyTo(destinfo.FullName);
                        else
                        {
                            DirectoryInfo target = Directory.CreateDirectory(Path.Combine(destinfo.FullName, origin.Name));
                            CopyAll(new DirectoryInfo(origin.FullName), target);
                        }
                            
                    }
                    else if (par.Operation == FileManOperation.Move)
                    {
                        if ((origin.Attributes & FileAttributes.Directory) != FileAttributes.Directory)
                            origin.MoveTo(destinfo.FullName);
                        else
                        {
                            Directory.Move(origin.FullName, Path.Combine(destinfo.FullName, origin.Name));
                        }
                            
                    }
                    else
                    {
                        origin.MoveTo(destinfo.FullName);
                    }
                }

            }
            catch (Exception e)
            {
                response.success = false;
                response.exitcode = e.HResult;
                response.msg = e.Message;
            }
            return response;
        }

        private static void CopyAll(DirectoryInfo source, DirectoryInfo target)
        {
            Directory.CreateDirectory(target.FullName);

            // Copy each file into the new directory.
            foreach (FileInfo fi in source.GetFiles())
            {
                fi.CopyTo(Path.Combine(target.FullName, fi.Name), true);
            }

            // Copy each subdirectory using recursion.
            foreach (DirectoryInfo diSourceSubDir in source.GetDirectories())
            {
                DirectoryInfo nextTargetSubDir = target.CreateSubdirectory(diSourceSubDir.Name);
                CopyAll(diSourceSubDir, nextTargetSubDir);
            }
        }
    }
}