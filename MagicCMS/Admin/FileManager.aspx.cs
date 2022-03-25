using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace MagicCMS.Admin
{
    public partial class FileManager : System.Web.UI.Page
    {
        public string UserRoot { get; set; }
        public string CurrentRoot { get; set; }
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!String.IsNullOrWhiteSpace(ConfigurationManager.AppSettings["FileManagerRoot"]))
                UserRoot = ConfigurationManager.AppSettings["FileManagerRoot"];

            int fnumber = 0;
            string caller, fn, root;

            // the caller is CKEditor
            if (!string.IsNullOrEmpty(Request["CKEditor"]))
            {
                caller = "ckeditor";
            }
            else
                caller = (String.IsNullOrEmpty(Request["caller"]) ? "parent" : Request["caller"]);

            CurrentRoot  = Request["root"];
            if (string.IsNullOrEmpty(CurrentRoot))
                CurrentRoot = UserRoot;

            HF_Opener.Value = caller;

            fn = Request["fn"];

            if (!String.IsNullOrEmpty(fn))
                HF_CallBack.Value = fn;

            if (int.TryParse(Request["CKEditorFuncNum"], out fnumber))
                HF_CKEditorFunctionNumber.Value = fnumber.ToString();

            if (!String.IsNullOrEmpty(Request["field"]))
                HF_Field.Value = Request["field"];

            string type = "myFiles";
 
            if(!string.IsNullOrEmpty(Request["type"]))
                type = Request["type"];
            HF_Type.Value = type;

        }
    }
}