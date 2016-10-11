using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace MagicCMS.Core
{
    /// <summary>
	/// Where clause value types.  Clause value type of a query clause.
    /// </summary>
	/// <seealso cref="MagicCMS.Core.ClauseValue"/>
	/// <seealso cref="MagicCMS.Core.WhereClause"/>
	public enum ClauseValueType
    {
        Function, Number, String, Fulltext
    }

    /// <summary>
    /// Where clause value. Clause value of a query clause
    /// </summary>
	/// <seealso cref="MagicCMS.Core.WhereClause"/>
	public class ClauseValue
    {
		/// <summary>
		/// Gets or sets the type (Function, Number, String, Fulltext).
		/// </summary>
		/// <value>The type. </value>
        public ClauseValueType Type { get; set; }
		/// <summary>
		/// Gets or sets the value (depending on ClauseValueType).
		/// </summary>
		/// <value>The value.</value>
        public object Value { get; set; }

		/// <summary>
		/// Initializes a new instance of the <see cref="ClauseValue"/> class.
		/// </summary>
		/// <param name="value">The value.</param>
		/// <param name="type">The type.</param>
        public ClauseValue(object value, ClauseValueType type)
        {
            Value = value;
            Type = type;
        }

		/// <summary>
		/// Returns a <see cref="System.String" /> that represents this instance.
		/// </summary>
		/// <returns>A <see cref="System.String" /> that represents this instance.</returns>
        public override string ToString()
        {
            return this.Value.ToString();
        }
    }

    /// <summary>
    /// Where clause class. Create and handle not injectable sql queries .
    /// </summary>
    public class WhereClause
    {
        #region Constants

        // Logical
        public const string AND = "AND";
        public const string OR = "OR";
        public const string AND_NOT = "AND NOT";
        public const string OR_NOT = "OR NOT";

        // Comparison
        public const string EQUAL = "=";
        public const string NOT_EQUAL = "<>";
        public const string MORE_THEN = ">";
        public const string MORE_OR_EQUAL = ">=";
        public const string LESS_THEN = "<";
        public const string LESS_OR_EQUAL = "<=";
        public const string LIKE = "LIKE";
        public const string IS_NULL = "IS NULL";
        public const string IS_NOT_NULL = "IS NOT NULL";
        public const string IN = "IN";
        public const string NOT_IN = "NOT IN";

        #endregion

        #region Fields
        private static string[] booleanOperators = new string[] { "AND", "OR", "AND NOT", "OR NOT" };
        private static string[] wOperators = new string[] { "=", "<>", ">", ">=", "<", "<=", "LIKE", "IS NULL", "IS NOT NULL", "IN", "NOT IN"};
        private string _logicalOperator;
        private string _operator;
        
        #endregion


		/// <summary>
		/// Gets or sets the name of the field to filter.
		/// </summary>
		/// <value>The name of the field.</value>
        public string FieldName { get; set; }
		/// <summary>
		/// Gets or sets the logical conjunction to previous query clause.
		/// </summary>
		/// <value>The logical operator.</value>
        public string LogicalOperator
        {
            get { return _logicalOperator; }
            set { _logicalOperator = value.ToUpper(); }
        }

		/// <summary>
		/// Gets or sets the operator of the query clause.
		/// </summary>
		/// <value>The operator.</value>
        public string Operator
        {
            get
            {
                if (!wOperators.Contains(_operator))
                {
                    return "IS NOT NULL";
                }
                return _operator;
            }
            set { _operator = value.ToUpper(); }
        }

		/// <summary>
		/// Gets or sets the value of the clause.
		/// </summary>
		/// <value>The value.</value>
        public ClauseValue Value
        {
            get;
            set;
        }

		/// <summary>
		/// Gets the quoted value of the clause.
		/// </summary>
		/// <value>The quoted value.</value>
        public string QuotedValue
        {
            get
            {
                if (Operator == "IS NOT NULL" || Operator == "IS NULL")
                    return "";

                switch (Value.Type)
                {
                    case ClauseValueType.Function:
                        return Value.Value.ToString();
                    case ClauseValueType.Number:
                        return Value.Value.ToString();
                    case ClauseValueType.String:
                        //return "QUOTENAME ('" + Value.ToString() + "','''')";
                        return "REPLACE ('" + Value.ToString() + "', '''', '''''')";
                    case ClauseValueType.Fulltext:
                        return "REPLACE ('%" + Value.ToString() + "%', '''', '''''')";
                        //return "QUOTENAME ('%" + Value.ToString() + "%', '''')";
                    default:
                        return "";
                }
            }
        }
    }

}