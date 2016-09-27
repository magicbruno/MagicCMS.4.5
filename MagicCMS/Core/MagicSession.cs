using System;
using System.Web;

namespace MagicCMS.Core
{
    public class ColorPalette
    {
        private string[] _colorPalette;
        private int _paletteIndex = 0;

        public ColorPalette(string[] colorList)
        {
            _colorPalette = colorList;
        }

        public string NextColor
        {
            get
            {
                return _colorPalette[PaletteIndex];
            }
        }

        public int PaletteIndex
        {
            get
            {
                int r = _paletteIndex;
                _paletteIndex++;
                if (_paletteIndex == _colorPalette.Length)
                    _paletteIndex = 0;
                return r;
            }
        }
    }

    public class MagicSession
    {
        private MagicUser _LoggedUser;

        private ColorPalette _palette = new ColorPalette(new string[]  {"#4D4D4D",
                                                                        "#5DA5DA",
                                                                        "#FAA43A",
                                                                        "#60BD68",
                                                                        "#F17CB0",
                                                                        "#B2912F",
                                                                        "#B276B2",
                                                                        "#DECF3F",
                                                                        "#F15854"});

        // private constructor
        private MagicSession()
        {
            AdminLoginId = 0;
            ShowSplash = true;
            LoggedUser = new MagicUser();
            ShowInactiveTypes = false;
        }

        // Gets the current session.
        public static MagicSession Current
        {
            get
            {
                if (HttpContext.Current.Session["__MagicSession__"] == null)
                    HttpContext.Current.Session["__MagicSession__"] = new MagicSession();
                //if (session == null)
                //{
                //    session = new MagicSession();
                //    HttpContext.Current.Session["__MagicSession__"] = session;
                //}
                return HttpContext.Current.Session["__MagicSession__"] as MagicSession;
            }
        }

        // -------- CMS Authoring access ------------------------------------------------------
        public int Admin_id
        {
            get
            {
                int u_id = -1;
                if (HttpContext.Current.Session["User_id"] != null)
                {
                    int.TryParse(HttpContext.Current.Session["User_id"].ToString(), out u_id);
                }
                return u_id;
            }

            set
            {
                HttpContext.Current.Session["User_id"] = value;
            }
        }

        public int Admin_level
        {
            get
            {
                int u_level = -1;
                if (HttpContext.Current.Session["User_level"] != null)
                {
                    int.TryParse(HttpContext.Current.Session["User_level"].ToString(), out u_level);
                }
                return u_level;
            }

            set
            {
                HttpContext.Current.Session["User_level"] = value;
            }
        }

        // **** add your session properties here, e.g like this:
        public int AdminLoginId { get; set; }
        public ColorPalette ColorPalette
        {
            get { return _palette; }
            set { _palette = value; }
        }

        public string LastAccessTry { get; set; }

        public MagicUser LoggedUser
        {
            get
            {
                if (_LoggedUser == null)
                {
                    _LoggedUser = new MagicUser();
                }
                return _LoggedUser;
            }

            set
            {
                _LoggedUser = value;
            }
        }

        public Boolean Preview
        {
            get
            {
                Boolean _preview = false;
                if (HttpContext.Current.Session["Preview"] != null)
                {
                    _preview = Convert.ToBoolean(HttpContext.Current.Session["Preview"]);
                }
                return _preview;
            }
            set
            {
                HttpContext.Current.Session["Preview"] = value;
            }
        }

        private CMS_Config _config;

        public CMS_Config Config
        {
            get
            {
                if (_config == null)
                    _config = new CMS_Config();
                return _config;
            }
        }

        //private string _currentlanguage;
        private MagicLanguage _currentTranslation;
        public string CurrentLanguage
        {
            get
            {
                if (Object.ReferenceEquals(_currentTranslation, null))
                    return "default";
                if (_currentTranslation.LangId == Config.TransSourceLangId)
                    return "default";
                return _currentTranslation.LangId;
            }
            set
            {

                if (MagicLanguage.Languages.ContainsKey(value))
                {
                    _currentTranslation = new MagicLanguage(value);
                }
                else
                {
                    _currentTranslation = null;
                }
            }
        }

        public string CurrentLanguageName
        {
            get
            {
                if (!Object.ReferenceEquals(_currentTranslation, null))
                {
                    return _currentTranslation.LangName;
                }
                return Config.TransSourceLangName;
            }
        }

        public Boolean TransAutoHide
        {
            get
            {
                if (!Object.ReferenceEquals(_currentTranslation, null))
                {
                    return _currentTranslation.AutoHide;
                }
                return false;
            }
        }

        public DateTime SessionStart { get; set; }

        public bool ShowSplash { get; set; }

        public Boolean ShowInactiveTypes { get; set; }

    }
}

