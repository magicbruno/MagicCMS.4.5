using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace MagicCMS.Core
{
	public class MenuInfoCollection: CollectionBase
	{
		#region Constructor
		public MenuInfoCollection()
		{

		}

		public MenuInfoCollection(MagicPost parent, int currentPageId)
		{
			Init(parent, currentPageId, true);
		}

		public MenuInfoCollection(MagicPost parent, int currentPageId, bool checkLangButtons )
		{
			Init(parent, currentPageId, checkLangButtons);
		}
		private void Init(MagicPost parent, int currentPageId, bool checkLangButtons)
		{
			if (parent.Tipo != MagicPostTypeInfo.Menu)
				return;
			MagicPostCollection menu = parent.GetChildren(parent.OrderChildrenBy, -1);
			foreach (MagicPost mp in menu)
			{
				if (CheckLangButton(mp, checkLangButtons))
					List.Add(new MenuInfo(mp, currentPageId));
			}
		}

		#endregion


		#region Public Methods

		public int Add(MenuInfo item)
		{
			return List.Add(item);
		}

		public void Insert(int index, MenuInfo item)
		{
			List.Insert(index, item);
		}

		public void Remove(MenuInfo item)
		{
			List.Remove(item);
		}

		public bool Contains(MenuInfo item)
		{
			return List.Contains(item);
		}

		public int IndexOf(MenuInfo item)
		{
			return List.IndexOf(item);
		}

		public void CopyTo(MenuInfo[] array, int index)
		{
			List.CopyTo(array, index);
		}

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