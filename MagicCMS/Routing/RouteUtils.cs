using MagicCMS.Core;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace MagicCMS.Routing
{
	public static class RouteUtils
	{
		public static string GetVirtualPath(int postPk)
		{
			return GetVirtualPath(postPk, 0);
		}

		public static string GetVirtualPath(int postPk, int parent)
		{
			return GetVirtualPath(postPk, parent, 0);
		}

		public static string GetVirtualPath(int postPk, int parent, int granParent)
		{
			//string vp = "";
			int homeId = MagicSession.Current.Config.StartPage;

			if (homeId == 0)
				homeId = MagicPost.GetSpecialItem(MagicPostTypeInfo.HomePage);

			if (homeId == postPk)
				return ComposePath("home","","");
			string parentName = "",
				granParentName = "",
				title = "";

			MagicPost mp = new MagicPost(postPk);
			if (parent > 0 && mp.Pk > 0)
			{
				if (mp.Tipo == MagicPostTypeInfo.CollegamentoInternet)
					return mp.Url;

				title = MagicIndex.GetTitle(postPk, MagicSession.Current.CurrentLanguage);

				MagicPost parentPost = new MagicPost(parent);
				parentName = MagicIndex.EncodeTitle(parentPost.Title_RT);
				if (granParent > 0)
				{
					MagicPost granParentPost = new MagicPost(granParent);
					granParentName = MagicIndex.EncodeTitle(granParentPost.Title_RT);
				}
				return ComposePath(title, parentName, granParentName);
			}
			else return GetVirtualPath(postPk, new int[] { });
		}

		public static string GetVirtualPath(int postPk, int[] parentTypes)
		{
			return GetVirtualPath(postPk, parentTypes, 0);
		}

		public static string GetVirtualPath(int postPk, int[] parentTypes, int granParent)
		{
			//string vp = "";
			int homeId = MagicSession.Current.Config.StartPage;

			if (homeId == 0)
				homeId = MagicPost.GetSpecialItem(MagicPostTypeInfo.HomePage);

			if (homeId == postPk)
				return GetVirtualPath(postPk, "home");

			string parentName = "pages";
			MagicPost mp = new MagicPost(postPk);

			if (mp.Tipo == MagicPostTypeInfo.Blog)
			{
				parentName = "blog";
			}
			else if (mp.Tipo == MagicPostTypeInfo.News)
			{
				parentName = "news";
			}
			else if (mp.Tipo == MagicPostTypeInfo.CollegamentoInternet)
				return mp.Url;
			string title = MagicIndex.GetTitle(postPk, MagicSession.Current.CurrentLanguage);

			MagicPostCollection parents;

			parents = mp.GetParents(parentTypes, MagicOrdinamento.Asc);
			if (parents.Count > 0)
			{
				parentName = MagicIndex.EncodeTitle(parents[0].Title_RT);
			}
			string granParentName =  "";
			if (granParent > 0)
			{
				MagicPost granParentPost = new MagicPost(granParent);
				granParentName = MagicIndex.EncodeTitle(granParentPost.Title_RT);
			}
			return ComposePath(title, parentName, granParentName);
		}

		public static string GetVirtualPath(int postPk, string parentName)
		{
			string lang = "";
			if (MagicLanguage.IsMultilanguage())
				lang = (MagicSession.Current.CurrentLanguage == "default") ? "/" + MagicSession.Current.Config.TransSourceLangId : "/" + MagicSession.Current.CurrentLanguage;
			return GetVirtualPath(postPk, parentName, lang);
		}

		public static string GetVirtualPath(int postPk, string parentName, string lang)
		{
			if (!string.IsNullOrEmpty(lang))
				lang = lang.Substring(0, 1) == "/" ? lang : "/" + lang;
			string vp = "";
			if (parentName == "home")
				vp = lang + "/home";
			else
				vp = lang + (String.IsNullOrEmpty(parentName) ? "" : "/" + parentName) + "/" + MagicIndex.GetTitle(postPk, MagicSession.Current.CurrentLanguage);
			return vp;
		}

		public static string ComposePath(string title, string parentName, string granParentName)
		{
			string url = "";
			if (MagicLanguage.IsMultilanguage())
				url = (MagicSession.Current.CurrentLanguage == "default") ? "/" + MagicSession.Current.Config.TransSourceLangId : "/" + MagicSession.Current.CurrentLanguage;
			url += String.IsNullOrEmpty(granParentName) ? "" : "/" + granParentName;
			url += String.IsNullOrEmpty(parentName) ? "" : "/" + parentName;
			url += "/" + title + "/";
			return url;
		}

		public static void InitMagicIndex()
		{
			if (!MagicIndex.ExistsMagicIndex())
			{
				string errorMessage = "";
				int processed = 0;
				MagicIndex.Populate(out processed, out errorMessage);
			}
		}

	}
}