
namespace MagicCMS.Core
{
    public class AjaxJsonResponse
    {
        public bool success { get; set; }
        public int pk { get; set; }
        public int exitcode { get; set; }
        public string msg { get; set; }
        public object data { get; set; }
    }
}