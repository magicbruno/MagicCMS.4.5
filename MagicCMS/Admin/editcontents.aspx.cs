using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using MagicCMS.Core;
using MagicCMS.MagicTranslator;
using Newtonsoft.Json;
using RestSharp;

namespace MagicCMS.Admin
{

    public partial class editcontents : System.Web.UI.Page
    {

        #region Page Public Properties

        public int Pk { get; set; }
        public MagicPostTypeInfo TypeInfo { get; set; }
        public MagicPost ThePost { get; set; }

        public MagicPostHTML_Encoded ThePostEnc { get; set; }

        public int TheParent { get; set; }
        public string PostParents
        {
            get
            {
                List<string> par = new List<string>();
                foreach (int p in ThePost.Parents)
                {
                    par.Add(p.ToString());
                }
                return String.Join(",", par.ToArray());
            }
        }
        public string DataPubblicazioneStr
        {
            get
            {
                //if(ThePost.DataPubblicazione.HasValue)
                //{
                //    ThePost.DataPubblicazione = ThePost.DataPubblicazione.Value.AddHours(12 - ThePost.DataPubblicazione.Value.Hour);
                //}
                return (ThePost.DataPubblicazione.HasValue ? ThePost.DataPubblicazione.Value.ToString("yyyy-MM-ddTHH:mm:ss.fffffffK") : "");
            }
        }
        public string DataScadenzaStr
        {
            get
            {
                //if (ThePost.DataScadenza.HasValue)
                //{
                //    ThePost.DataScadenza = ThePost.DataScadenza.Value.AddHours(12 - ThePost.DataScadenza.Value.Hour);
                //}
                return (ThePost.DataScadenza.HasValue ? ThePost.DataScadenza.Value.ToString("yyyy-MM-ddTHH:mm:ss.fffffffK") : "");
            }
        }
        public string PostEditTitle { get; set; }

        public MagicTranslationCollection Languages { get; set; }

        private CMS_Config _cmsconfig = new CMS_Config();

        public CMS_Config CmsConfig { get { return _cmsconfig; } }

        #region Visibility


        public string FlagAltezza
        {
            get
            {
                if (TypeInfo.FlagAltezza)
                {
                    return "";
                }
                return "hidden";
            }
        }


        public string FlagBreve
        {
            get
            {
                if (TypeInfo.FlagBreve)
                {
                    return "";
                }
                return "hidden";
            }
        }

        public string FlagTesti
        {
            get
            {
                if (TypeInfo.FlagBreve || TypeInfo.FlagFull)
                    return "";
                else 
                    return "hidden";

            }
        }

        public string FlagBtnGeolog
        {
            get
            {
                if (TypeInfo.FlagBtnGeolog)
                {
                    return "input-group";
                }
                return "input-group-btn-hidden";
            }
        }

        public string FlagCercaServer
        {
            get
            {
                if (TypeInfo.FlagCercaServer)
                {
                    return "";
                }
                return "hidden";
            }
        }

        public string FlagDimensioni
        {
            get
            {
                if (TypeInfo.FlagAltezza || TypeInfo.FlagLarghezza)
                {
                    return "";
                }
                return "hidden";
            }
        }

        public string FlagExtraInfo
        {
            get
            {
                if (TypeInfo.FlagExtraInfo)
                {
                    return "";
                }
                return "hidden";
            }
        }

        public string FlagExtrInfo1
        {
            get
            {
                if (TypeInfo.FlagExtrInfo1)
                {
                    return "";
                }
                return "hidden";
            }
        }

        public string FlagExtrInfo2
        {
            get
            {
                if (TypeInfo.FlagExtrInfo2)
                {
                    return "";
                }
                return "hidden";
            }
        }

        public string FlagExtrInfo3
        {
            get
            {
                if (TypeInfo.FlagExtrInfo3)
                {
                    return "";
                }
                return "hidden";
            }
        }

        public string FlagExtrInfo4
        {
            get
            {
                if (TypeInfo.FlagExtrInfo4)
                {
                    return "";
                }
                return "hidden";
            }
        }

        public string FlagFull
        {
            get
            {
                if (TypeInfo.FlagFull)
                {
                    return "";
                }
                return "hidden";
            }
        }

        public string FlagLarghezza
        {
            get
            {
                if (TypeInfo.FlagLarghezza)
                {
                    return "";
                }
                return "hidden";
            }
        }

        public string FlagScadenza
        {
            get
            {
                if (TypeInfo.FlagScadenza)
                {
                    return "";
                }
                return "hidden";
            }
        }

        public string FlagTags
        {
            get
            {
                if (TypeInfo.FlagTags)
                {
                    return "";
                }
                return "hidden";
            }
        }

        public string FlagUrl
        {
            get
            {
                if (TypeInfo.FlagUrl)
                {
                    return "";
                }
                return "hidden";
            }
        }

        public string FlagUrlSecondaria
        {
            get
            {
                if (TypeInfo.FlagUrlSecondaria)
                {
                    return "";
                }
                return "hidden";
            }
        }

        public string FlagExtraInfo_5
        {
            get
            {
                if (!String.IsNullOrEmpty(TypeInfo.LabelExtraInfo_5))
                {
                    return "";
                }
                return "hidden";
            }
        }

        public string FlagExtraInfo_6
        {
            get
            {
                if (!String.IsNullOrEmpty(TypeInfo.LabelExtraInfo_6))
                {
                    return "";
                }
                return "hidden";
            }
        }


        public string FlagExtraInfo_7
        {
            get
            {
                if (!String.IsNullOrEmpty(TypeInfo.LabelExtraInfo_7))
                {
                    return "";
                }
                return "hidden";
            }
        }


        public string FlagExtraInfo_8
        {
            get
            {
                if (!String.IsNullOrEmpty(TypeInfo.LabelExtraInfo_8))
                {
                    return "";
                }
                return "hidden";
            }
        }


        public string FlagExtraInfoNumber_1
        {
            get
            {
                if (!String.IsNullOrEmpty(TypeInfo.LabelExtraInfoNumber_1))
                {
                    return "";
                }
                return "hidden";
            }
        }


        public string FlagExtraInfoNumber_2
        {
            get
            {
                if (!String.IsNullOrEmpty(TypeInfo.LabelExtraInfoNumber_2))
                {
                    return "";
                }
                return "hidden";
            }
        }


        public string FlagExtraInfoNumber_3
        {
            get
            {
                if (!String.IsNullOrEmpty(TypeInfo.LabelExtraInfoNumber_3))
                {
                    return "";
                }
                return "hidden";
            }
        }


        public string FlagExtraInfoNumber_4
        {
            get
            {
                if (!String.IsNullOrEmpty(TypeInfo.LabelExtraInfoNumber_4))
                {
                    return "";
                }
                return "hidden";
            }
        }


        public string FlagExtraInfoNumber_5
        {
            get
            {
                if (!String.IsNullOrEmpty(TypeInfo.LabelExtraInfoNumber_5))
                {
                    return "";
                }
                return "hidden";
            }
        }


        public string FlagExtraInfoNumber_6
        {
            get
            {
                if (!String.IsNullOrEmpty(TypeInfo.LabelExtraInfoNumber_6))
                {
                    return "";
                }
                return "hidden";
            }
        }


        public string FlagExtraInfoNumber_7
        {
            get
            {
                if (!String.IsNullOrEmpty(TypeInfo.LabelExtraInfoNumber_7))
                {
                    return "";
                }
                return "hidden";
            }
        }


        public string FlagExtraInfoNumber_8
        {
            get
            {
                if (!String.IsNullOrEmpty(TypeInfo.LabelExtraInfoNumber_8))
                {
                    return "";
                }
                return "hidden";
            }
        }

        public string FlagExtraInfoNumberAll
        {
            get
            {
                if ((FlagExtraInfoNumber_1 + FlagExtraInfoNumber_2 + FlagExtraInfoNumber_3 + FlagExtraInfoNumber_4 +
                    FlagExtraInfoNumber_5 + FlagExtraInfoNumber_6 + FlagExtraInfoNumber_7 + FlagExtraInfoNumber_8).Length >= 48)
                {
                    return "hidden";
                }
                return "";
            }
        }

        public string NotActiveReadOnly
        {
            get
            {
                if (TypeInfo.FlagAttivo)
                    return "";
                return "readonly=\"readonly\"";
            }
        }

        public string PermalinkPrefix
        {
            get
            {
                if(MagicLanguage.IsMultilanguage())
                {
                    return "/" + MagicSession.Current.Config.TransSourceLangId + "/[contenitore/]";
                }
                return "/contenitore/";
            }
        }

        #endregion

        #endregion


        protected void Page_Load(object sender, EventArgs e)
        {
            
            int pk = 0, type = 0, parent = 0;
            int.TryParse(Request["pk"], out pk);
            int.TryParse(Request["type"], out type);
            int.TryParse(Request["parent"], out parent);
            TheParent = 0;

            //Modify a post
            if (pk > 0 && type == 0)
            {
                Panel_edit.Visible = true;
                Panel_contents.Visible = true;
                Pk = pk;
                ThePost = new MagicPost(pk);
                TypeInfo = ThePost.TypeInfo;
                PostEditTitle = ThePost.Name + " (" + TypeInfo.Nome + ")";
            }
            // New typed post
            else if (pk == 0 && type > 0 && parent == 0)
            {
                Panel_edit.Visible = true;
                Panel_contents.Visible = false;
                ThePost = new MagicPost(new MagicPostTypeInfo(type));
                TypeInfo = ThePost.TypeInfo;
                Pk = 0;
                PostEditTitle = " Nuovo \"" + TypeInfo.Nome + "\"";
            }
            // New typed post with parent
            else if (pk == 0 && type > 0 && parent > 0)
            {
                Panel_edit.Visible = true;
                Panel_contents.Visible = true;
                ThePost = new MagicPost(new MagicPostTypeInfo(type));
                TypeInfo = ThePost.TypeInfo;
                Pk = ThePost.Pk;
                TheParent = parent;
                ThePost.Parents.Add(parent);
                PostEditTitle = " Nuovo \"" + TypeInfo.Nome + "\" in " + MagicPost.GetPageTitle(parent);
            }
            else
            {
                Panel_edit.Visible = false;
                Panel_contents.Visible = true;
            }
            if (ThePost != null)
                ThePostEnc = new MagicPostHTML_Encoded(ThePost);

			if (Panel_edit.Visible)
			{
				Languages = new MagicTranslationCollection(Pk, true);
				RepeaterLanguages.DataSource = Languages;
				RepeaterLanguages.DataBind();
				Repeter_Tabs.DataSource = Languages;
				Repeter_Tabs.DataBind();

                ServicePointManager.SecurityProtocol = SecurityProtocolType.Tls12;
                List<ListItem> data = new List<ListItem>();
                try
                {
                    var options = new RestClientOptions("https://traduci.magiccms.org")
                    {
                        MaxTimeout = -1,
                    };
                    var client = new RestClient(options);
                    var request = new RestRequest("/api/Translate", Method.Get);
                    //request.AddHeader("Content-Type", "application/json");
                    RestResponse r = client.Execute(request);
                    BingLanguageList langs = JsonConvert.DeserializeObject<BingLanguageList>(r.Content);
                    Newtonsoft.Json.Linq.JObject list = langs.translation as Newtonsoft.Json.Linq.JObject;
                    foreach (var item in list)
                    {
                        var obj = item.Value.First();
                        data.Add(new ListItem(obj.First.ToString(), item.Key));
                    }
                }
                catch (Exception)
                {

                    //throw;
                }
                data.Sort(CompareByText);

                RepeaterFrom.DataSource = data;
                RepeaterFrom.DataBind();
                RepeaterTo.DataSource = data;
                RepeaterTo.DataBind();

            }
            MagicPostTypeInfoCollection infoCollection = new MagicPostTypeInfoCollection(true, MagicPostTypeInfoOrder.Alpha);
            if (TypeInfo != null)
            {
                HtmlGenericControl style = new HtmlGenericControl("style");
                style.ID = "VisibilityStyles";
                style.ClientIDMode = ClientIDMode.Static;
                style.InnerText = TypeInfo.VisibilityStyles;
                Page.Header.Controls.Add(style);

                
                RepeaterElencoTipi.DataSource = infoCollection;
                RepeaterElencoTipi.DataBind();
            }
            RepeaterSearchTipi.DataSource = infoCollection;
            RepeaterSearchTipi.DataBind();

        }

        private static int CompareByText(ListItem x, ListItem y)
        {
            return x.Text.CompareTo(y.Text);
        }
    }
}