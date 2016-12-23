using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using MagicCMS.Core;

namespace MagicCMS.Admin.Ajax
{
	public static class Localize
	{
		public static string Translate(string backEndinterfaceString)
		{
			string backEndLang = MagicSession.Current.BackEndLang;
			if (backEndLang == "it")
				return backEndinterfaceString;
			return MagicTransDictionary.Translate(backEndinterfaceString, backEndLang);
		}
	}
}