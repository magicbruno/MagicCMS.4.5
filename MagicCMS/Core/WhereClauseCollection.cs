using System;
using System.Collections.Generic;
using System.Collections;
using System.Linq;
using System.Web;

namespace MagicCMS.Core
{
    public class WhereClauseCollection : System.Collections.CollectionBase
    {

        public WhereClause this[int index]
        {
            get { return (WhereClause)List[index]; }
            set { List[index] = value; }
        }

        public int Add(WhereClause item)
        {
            return List.Add(item);
        }

        public bool Contains(WhereClause item)
        {
            return List.Contains(item);
        }

        public void CopyTo(WhereClause[] array, int index)
        {
            List.CopyTo(array, index);
        }

        public int IndexOf(WhereClause item)
        {
            return List.IndexOf(item);
        }

        public void Insert(int index, WhereClause item)
        {
            List.Insert(index, item);
        }

        public void Remove(WhereClause item)
        {
            List.Remove(item);
        }

        /// <summary>
        /// To the string.
        /// </summary>
        /// <param name="allowUnsafe">if set to <c>true</c> allow unsafe where clause.</param>
        /// <returns></returns>
        public string ToString(Boolean allowUnsafe)
        {
            string whereClause = "";
            Boolean addParen = false;
            foreach (WhereClause wc in List)
            {
                Boolean valueChceck;
                if (wc.Value == null)
                {
                    valueChceck = true;
                }
                else
                {
                    valueChceck = (wc.Value.Type != ClauseValueType.Function || allowUnsafe);
                }
                if (valueChceck)
                {
                    if (whereClause != "")
                    {
                        whereClause += " " + wc.LogicalOperator + " ";
                        addParen = true;
                    }


                    whereClause += wc.FieldName + " " + wc.Operator + " " + wc.QuotedtValue + " ";
                    if (addParen)
                        whereClause = "(" + whereClause + ")";
                    
                }
            }
            return whereClause;
        }

        public override string ToString()
        {
            return ToString(false);
        }
    }
}