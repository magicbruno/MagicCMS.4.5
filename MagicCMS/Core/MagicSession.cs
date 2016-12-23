using System;
using System.Web;

namespace MagicCMS.Core
{
	/// <exclude />
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

	/// <summary>
	/// Class MagicSession. Hamdles typed session variables.
	/// </summary>
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

		/// <summary>
		/// Gets the current. This is a static instance of MagicSession created automatically. 
		/// </summary>
		/// <value>The current.</value>
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
		/// <exclude />
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

		/// <exclude />
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
		/// <exclude />
        public int AdminLoginId { get; set; }
		/// <summary>
		/// Gets or sets the color palette.
		/// </summary>
		/// <value>The color palette.</value>
        public ColorPalette ColorPalette
        {
            get { return _palette; }
            set { _palette = value; }
        }

		/// <summary>
		/// Gets or sets the last access try.
		/// </summary>
		/// <value>The last access try.</value>
        public string LastAccessTry { get; set; }

		/// <summary>
		/// Gets or sets the logged user.
		/// </summary>
		/// <value>The logged user.</value>
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

		/// <summary>
		/// Gets or sets the preview flag.
		/// </summary>
		/// <value>The preview.</value>
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

		/// <summary>
		/// Gets the configuration. Copies in session the <see cref="MagicCMS.Core.CMS_Config"/> object.
		/// </summary>
		/// <value>The configuration.</value>
        public CMS_Config Config
        {
            get
            {
                if (_config == null)
                    _config = new CMS_Config();
                return _config;
            }
        }

        
        private MagicLanguage _currentTranslation;
		/// <summary>
		/// Gets or sets the current language in Multilanguage application. Otherwise always return default.
		/// </summary>
		/// <value>The current language.</value>
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

		/// <summary>
		/// Gets the name of the current language.
		/// </summary>
		/// <value>The name of the current language.</value>
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

		/// <summary>
		/// Gets the trans automatic hide. Return the value of <see cref="MagicCMS.Core.MagicLanguage.AutoHide"/> property for the current language.
		/// </summary>
		/// <value>The trans automatic hide.</value>
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

		/// <summary>
		/// Gets or sets the session start. Used by custom management of session expires.
		/// </summary>
		/// <value>The session start.</value>
        public DateTime SessionStart { get; set; }

		/// <summary>
		/// Gets or sets a value indicating whether [show splash].
		/// </summary>
		/// <value><c>true</c> if [show splash]; otherwise, <c>false</c>.</value>
        public bool ShowSplash { get; set; }

		/// <summary>
		/// Gets or sets the show inactive types.
		/// </summary>
		/// <value>The show inactive types.</value>
        public Boolean ShowInactiveTypes { get; set; }

		private MagicPost _previewPost = null;

		/// <summary>
		/// Gets or sets the preview post. Here is temporary stored the post to be previewed.
		/// </summary>
		/// <value>The preview post.</value>
		public MagicPost PreviewPost
		{
			get { return _previewPost; }
			set { _previewPost = value; }
		}

		private string _backEndLang;
		public string BackEndLang
		{
			get
			{
				if (String.IsNullOrEmpty(_backEndLang))
					_backEndLang = MagicCMSConfiguration.GetConfig().BackEndLang;
				if (String.IsNullOrEmpty(_backEndLang))
					_backEndLang = "it";
				return _backEndLang;
			}
		}


    }
}

