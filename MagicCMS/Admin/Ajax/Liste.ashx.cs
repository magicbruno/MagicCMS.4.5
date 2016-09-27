using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.SessionState;
using MagicCMS.Core;
using System.Text.RegularExpressions;

namespace MagicCMS.Admin.Ajax
{
    /// <summary>
    /// Descrizione di riepilogo per Liste
    /// </summary>
    public class Liste : IHttpHandler, IRequiresSessionState
    {

        public void ProcessRequest(HttpContext context)
        {
            if (MagicSession.Current.LoggedUser.Level < 4)
            {
                context.Response.StatusCode = 403;
                context.Response.StatusDescription = "Prerogative non sufficienti";
                context.Response.ContentType = "text/html";
                //context.Response.Write("Sessione scaduta.");
                return;
            }

            string idField = context.Request["idField"];        // Nome del campo
            string k = context.Request["k"];                    // Stringa di ricerca
            //string textField ="";                               // Testo da restituire nell'oggetto select2 ({id:..., text:...})
            string[] idList;
            List<int> idList_int = new List<int>();
            // In alternativa questo parametro consente di creare la lista di oggetti
            // select2 selezionati in un multi-select
            int parent_pk = 0;                                  // In alternativa id dell'oggetto parent (prova per le domande e domanda per gli item

            int.TryParse(context.Request["parent_pk"], out parent_pk);

            if (!String.IsNullOrEmpty(context.Request["idlist"]))
                idList = context.Request["idlist"].Split(new char[] { ',' });
            else
                idList = new string[] { };

            for (int i = 0; i < idList.Length; i++)
            {
                int tmp = 0;
                if (int.TryParse(idList[i], out tmp))
                {
                    idList_int.Add(tmp);
                }
            }

            if (String.IsNullOrEmpty(k))
                k = String.Empty;

            List<MagicCmsSelect2> lista;
            //switch (idField)
            //{
            //    case "PREROGATIVE":
            //        textField = "";
            //        break;
            //    default:
            //        idField = textField = "";
            //        break;
            //}
            lista = new List<MagicCmsSelect2>();

            if (idField == "PREROGATIVE")
            {
                foreach (KeyValuePair<int, string> kv in MagicPrerogativa.Prerogative)
                {
                    MagicCmsSelect2 s2 = new MagicCmsSelect2();
                    s2.id = kv.Key;
                    s2.text = kv.Value;
                    lista.Add(s2);
                }
            }
            else if (idField == "ANA_LANGUAGE")
            {
                foreach (string Key in MagicLanguage.Languages.Keys)
                {
                    MagicCmsSelect2 s2 = new MagicCmsSelect2();
                    s2.id = Key;
                    s2.text = Key;
                    lista.Add(s2);
                }
            }
            else if (idField == "CONTENUTI")
            {
                WhereClauseCollection query = new WhereClauseCollection();
                query.Add(new WhereClause()
                {
                    FieldName = "vmca.Titolo",
                    LogicalOperator = "AND",
                    Operator = "LIKE",
                    Value = new ClauseValue(k, ClauseValueType.Fulltext)
                });

                List<string> checkedList = new List<string>();
                foreach (int n in idList_int)
                    checkedList.Add(n.ToString());

                query.Add(new WhereClause()
                {
                    LogicalOperator = "AND",
                    FieldName = "vmca.Tipo",
                    Operator = "IN",
                    Value = new ClauseValue("(" + String.Join(",", checkedList.ToArray()) + ")", ClauseValueType.Function)
                });
                MagicPostCollection mpc = new MagicPostCollection(query, MagicOrdinamento.Asc, 1000, true);
                foreach (MagicPost mp in mpc)
                {
                    MagicCmsSelect2 s2 = new MagicCmsSelect2();
                    s2.id = mp.Pk;
                    s2.text = mp.Pk.ToString() + " - " + mp.Titolo;
                    lista.Add(s2);
                }
                lista.Sort(
                    delegate(MagicCmsSelect2 p1, MagicCmsSelect2 p2)
                    {
                        return ParseInteger( p1.text).CompareTo(ParseInteger(p2.text));
                    });
            }


            System.Web.Script.Serialization.JavaScriptSerializer serializer = new System.Web.Script.Serialization.JavaScriptSerializer();
            string json = serializer.Serialize(lista);
            context.Response.ContentType = "application/json";
            context.Response.Charset = "UTF-8";
            context.Response.Write(json);
        }

        private static readonly Regex LeadingInteger = new Regex(@"^(-?\d+)");

        private static int ParseInteger(string item)
        {
            Match match = LeadingInteger.Match(item);
            if (!match.Success)
            {
                throw new ArgumentException("Not an integer");
            }
            return int.Parse(match.Value);
        }

        public bool IsReusable
        {
            get
            {
                return false;
            }
        }
    }
}