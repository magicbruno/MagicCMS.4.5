using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace MagicCMS.Core
{
	/// <summary>
	/// Class MenuInfoCollection. Represents a collection of menu items (a main menu or a sub menu).
	/// </summary>
	/// <seealso cref="System.Collections.CollectionBase" />
	/// <seealso cref="MagicCMS.Core.MenuInfo"/>
	public class MenuInfoCollection: CollectionBase
	{
		#region Constructor
		/// <summary>
		/// Initializes a new empty instance of the <see cref="MenuInfoCollection"/> class.
		/// </summary>
		public MenuInfoCollection()
		{

		}

		/// <summary>
		/// Initializes a new instance of the <see cref="MenuInfoCollection"/> class creating it from a parent menu.
		/// </summary>
		/// <param name="parent">The parent.</param>
		/// <param name="currentPageId">The current page identifier.</param>
		public MenuInfoCollection(MagicPost parent, int currentPageId)
		{
			Init(parent, currentPageId, true, false);
		}

		/// <summary>
		/// Initializes a new instance of the <see cref="MenuInfoCollection"/> class.
		/// </summary>
		/// <param name="parent">The parent.</param>
		/// <param name="currentPageId">The current page identifier.</param>
		/// <param name="checkLangButtons">if set to <c>true</c> language buttons are shown only if site is multilanguage and current language is not language of button.</param>
		public MenuInfoCollection(MagicPost parent, int currentPageId, bool checkLangButtons)
		{
			Init(parent, currentPageId, checkLangButtons, false);
		}

		/// <summary>
		/// Initializes a new instance of the <see cref="MenuInfoCollection" /> class.
		/// </summary>
		/// <param name="parent">The parent.</param>
		/// <param name="currentPageId">The current page identifier.</param>
		/// <param name="checkLangButtons">if set to <c>true</c> language buttons are shown only if site is multilanguage and current language is not language of button.</param>
		/// <param name="isIconMenu">if set to <c>true</c> menu items are shown as icon (if available).</param>
		public MenuInfoCollection(MagicPost parent, int currentPageId, bool checkLangButtons, bool isIconMenu)
		{
			Init(parent, currentPageId, checkLangButtons, isIconMenu);
		}


		private void Init(MagicPost parent, int currentPageId, bool checkLangButtons, bool isIconMenu)
		{
			if (parent.Tipo != MagicPostTypeInfo.Menu)
				return;
			MagicPostCollection menu = parent.GetChildren(parent.OrderChildrenBy, -1);
			foreach (MagicPost mp in menu)
			{
				if (CheckLangButton(mp, checkLangButtons))
					List.Add(new MenuInfo(mp, currentPageId, isIconMenu));
			}
		}

		#endregion


		#region Public Methods

		/// <summary>
		/// Adds the specified item.
		/// </summary>
		/// <param name="item">The item.</param>
		/// <returns>System.Int32.</returns>
		public int Add(MenuInfo item)
		{
			return List.Add(item);
		}

		/// <summary>
		/// Inserts the specified index.
		/// </summary>
		/// <param name="index">The index.</param>
		/// <param name="item">The item.</param>
		public void Insert(int index, MenuInfo item)
		{
			List.Insert(index, item);
		}

		/// <summary>
		/// Removes the specified item.
		/// </summary>
		/// <param name="item">The item.</param>
		public void Remove(MenuInfo item)
		{
			List.Remove(item);
		}

		/// <summary>
		/// Determines whether [contains] [the specified item].
		/// </summary>
		/// <param name="item">The item.</param>
		/// <returns><c>true</c> if [contains] [the specified item]; otherwise, <c>false</c>.</returns>
		public bool Contains(MenuInfo item)
		{
			return List.Contains(item);
		}

		/// <summary>
		/// Indexes the of.
		/// </summary>
		/// <param name="item">The item.</param>
		/// <returns>System.Int32.</returns>
		public int IndexOf(MenuInfo item)
		{
			return List.IndexOf(item);
		}

		/// <summary>
		/// Copies to.
		/// </summary>
		/// <param name="array">The array.</param>
		/// <param name="index">The index.</param>
		public void CopyTo(MenuInfo[] array, int index)
		{
			List.CopyTo(array, index);
		}

		/// <summary>
		/// Gets or sets the element at the specified index.
		/// </summary>
		/// <param name="index">The index.</param>
		/// <returns>MenuInfo.</returns>
		public MenuInfo this[int index]
		{
			get { return (MenuInfo)List[index]; }
			set { List[index] = value; }
		}

		#endregion

		#region Private Methods
		private bool CheckLangButton(MagicPost mp, bool exclude)
		{
			if (mp.Tipo == MagicPostTypeInfo.ButtonLanguage && exclude && MagicLanguage.IsMultilanguage())
			{
				string currLang = MagicSession.Current.CurrentLanguage == "default" ? MagicSession.Current.Config.TransSourceLangId : MagicSession.Current.CurrentLanguage;
				return (currLang != mp.ExtraInfo && (MagicLanguage.Languages.ContainsKey(mp.ExtraInfo) || mp.ExtraInfo == MagicSession.Current.Config.TransSourceLangId));
			}
			return true;
		} 
		#endregion
	}
}