using MagicCMS.Core;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace MagicCMS.Routing
{
	/// <summary>
	/// Class RouteUtils. Collection of method to handle routing.
	/// </summary>
	public static class RouteUtils
	{
		/// <summary>
		/// Gets the routing path for a <see cref="MagicCms.Core.Magicpost"/>
		/// </summary>
		/// <param name="postPk">The post pk.</param>
		/// <returns>If application is multilanguage "/lang/routing-title/" otherwise "/routing-title/"</returns>
		public static string GetVirtualPath(int postPk)
		{
			return GetVirtualPath(postPk, 0);
		}

		/// <summary>
		/// Gets the routing path for a <see cref="MagicCms.Core.Magicpost"/>
		/// </summary>
		/// <param name="postPk">The post pk.</param>
		/// <param name="parent">The parent pk.</param>
		/// <returns>If application is multilanguage "/lang/parent-name/routing-title/" otherwise "/parent-name/routing-title/"</returns>
		public static string GetVirtualPath(int postPk, int parent)
		{
			return GetVirtualPath(postPk, parent, 0);
		}

		/// <summary>
		/// Gets the routing path for a <see cref="MagicCms.Core.Magicpost"/>
		/// </summary>
		/// <param name="postPk">The post pk.</param>
		/// <param name="parent">The parent pk.</param>
		/// <param name="granParent">The gran parent pk.</param>
		/// <returns>If application is multilanguage "/lang/gran-parent-name/parent-name/routing-title/" otherwise "/gran-parent-name/parent-name/routing-title/"</returns>
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
			else return GetVirtualPath(postPk, new int[] { }, granParent);
		}

		/// <summary>
		/// Gets the routing path for a <see cref="MagicCms.Core.Magicpost"/>. Add automatically a parent name
		/// </summary>
		/// <param name="postPk">The post pk.</param>
		/// <param name="parentTypes">Array of post types with which filter parents. If empty non filter is applied.</param>
		/// <returns>If application is multilanguage "/lang/parent-name/routing-title/" otherwise "/parent-name/routing-title/"</returns>
		public static string GetVirtualPath(int postPk, int[] parentTypes)
		{
			return GetVirtualPath(postPk, parentTypes, 0);
		}

		/// <summary>
		/// Gets the routing path for a <see cref="MagicCms.Core.Magicpost"/>. Add automatically a parent name
		/// </summary>
		/// <param name="postPk">The post pk.</param>
		/// <param name="parentTypes">Array of post types with which filter parents. If empty non filter is applied.</param>
		/// <param name="granParent">The gran parent pk.</param>
		/// <returns>If application is multilanguage "/lang/gran-parent-name/parent-name/routing-title/" otherwise "/gran-parent-name/parent-name/routing-title/"</returns>
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

		/// <summary>
		/// Gets the routing path for a <see cref="MagicCms.Core.Magicpost"/>
		/// </summary>
		/// <param name="postPk">The post pk.</param>
		/// <param name="parentName">Name of the parent.</param>
		/// <returns>If application is multilanguage "/lang/parent-name/routing-title/" otherwise "/parent-name/routing-title/"</returns>
		public static string GetVirtualPath(int postPk, string parentName)
		{
			string lang = "";
			if (MagicLanguage.IsMultilanguage())
				lang = (MagicSession.Current.CurrentLanguage == "default") ? "/" + MagicSession.Current.Config.TransSourceLangId : "/" + MagicSession.Current.CurrentLanguage;
			return GetVirtualPath(postPk, parentName, lang);
		}

		/// <summary>
		/// Gets the routing path for a <see cref="MagicCms.Core.Magicpost"/>
		/// </summary>
		/// <param name="postPk">The post pk.</param>
		/// <param name="parentName">Name of the parent.</param>
		/// <param name="lang">The language.</param>
		/// <returns>If application is multilanguage "/lang/parent-name/routing-title/" otherwise "/parent-name/routing-title/"</returns>
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

		/// <summary>
		/// Composes the path. 
		/// </summary>
		/// <param name="title">The title.</param>
		/// <param name="parentName">Name of the parent.</param>
		/// <param name="granParentName">Name of the gran parent.</param>
		/// <returns>System.String.</returns>
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

		/// <summary>
		/// Initializes the routing titles table.
		/// </summary>
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