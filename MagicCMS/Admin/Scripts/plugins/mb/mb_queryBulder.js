/// <reference path="../select2/select2.js" />
/// <reference path="../../js/app.dataTable.js" />
/// <reference path="../../../Scripts/jquery-1.11.0.js" />
; (function ($) {
    $.WhereClause = function (logicalOperator, fieldName, operator, value) {
        this.LogicalOperator = logicalOperator;
        this.FieldName = fieldName;
        this.Operator = operator;
        this.Value = value;
    }

    $.MB_qbField = function (options) {
        this.init(options);
    };
    $.MB_qbField.prototype = {
        defaults: {
            name: 'SCONOSCIUTO',
            displayname: '',
            defaultValue: '',
            type: 'text',
            operators: [
                {
                    id: '=',
                    text: 'uguale a'
                },
                {
                    id: '<>',
                    text: 'diverso da'
                },
                {
                    id: 'LIKE',
                    text: 'contiene'
                },
                {
                    id: 'NOT LIKE',
                    text: 'non contiene'
                }
            ],
            values: {
                ajax: null,
                data: []
            }
        },
        options: {},
        init: function (options) {
            $.extend(this.options, this.defaults, options || {});
            this.name = this.options.name;
            this.operators = this.options.operators;
            this.displayname = this.options.displayname;
            this.values = this.options.values;
        },
        getDisplayName: function () {
            return this.displayname || this.name;
        },
        getOperators: function () {
            return this.operators;
        },
        getValues: function () {
            return this.values;
        }
    };

    $.MB_qbGroup = function (fieldsArray, id, parent) {
        this.init(fieldsArray, id, parent);
    };

    $.MB_qbGroup.prototype = {
        fields: [],
        $element: $(),
        init: function (fieldsArray, id, parent) {
            var self = this;
            for (var i = 0; i < fieldsArray.length; i++) {
                this.fields.push(new $.MB_qbField(fieldsArray[i]));
            };
            var html = "<div id=\"qb1\" class=\"form-group\">" +
                        "    <div class=\"row\">" +
                        "        <div class=\"col-sm-2 col-xs-4\">" +
                        "            <select class=\"form-control logical\">" +
                        "                <option value=\"AND\">AND</option>" +
                        "                <option value=\"OR\">OR</option>" +
                        "            </select>" +
                        "        </div>" +
                        "        <div class=\"col-sm-2 col-xs-4\">" +
                        "            <input type=\"text\" class=\"form-control fields\" />" +
                        "        </div>" +
                        "        <div class=\"col-sm-2 col-xs-4\">" +
                        "            <input type=\"text\" class=\"form-control operators\" />" +
                        "        </div>" +
                        "        <div class=\"col-sm-6\">" +
                        "            <input type=\"text\" class=\"form-control values\" />" +
                        "        </div>" +
                        "    </div>" +
                        "</div>";
            var fieldList = this.getFieldsData();
            this.$element =
                $(html)
                    .attr('id', id || 'qb' + String(Math.random()).substr(2))
                    .appendTo($(parent));
            $('.fields', this.$element)
                    .select2({
                        data: fieldList,
                        change: true
                    })
                    .on('change', function (e) {
                        self.setConfigByfield(e.val);
                    });

        },
        getField: function (name) {
            var f = this.fields;
            for (var i = 0; i < f.length; i++) {
                if (f[i].name == name)
                    return f[i];
            }
        },
        getDisplayName: function (name) {
            var field = this.getField(name);
            return field.getDisplayName();
        },
        getOperators: function (name) {
            var field = this.getField(name);
            return field.getOperators();
        },
        getValues: function (name) {
            var field = this.getField(name);
            return field.getValues();
        },
        //Array di oggetti (formato { id: , text: }) che contiene i nomi dei campi
        getFieldsData: function () {
            var f = this.fields;
            var data = [];
            for (var i = 0; i < f.length; i++) {
                var d = {};
                d.id = f[i].name;
                d.text = f[i].getDisplayName() || d.id;
                data.push(d);
            }
            return data;
        },
        select2Destroy: function (selectClass) {
            var $el = this.$element.find('input.' + selectClass);
            $el.val('');
            if ($el.select2)
                $el.select2('destroy');
        },
        select2InitData: function (selectClass, data, options) {
            options = options || {};
            var $el = this.$element.find('input.' + selectClass);
            if ($el.select2)
                $el.select2('val', '').select2("destroy");
            $el.select2({
                minimumInputLength: options.minimumInputLength || 0,
                placeholder: options.placeholder || 0,
                data: data
            }).select2('data', data[0]);
        },
        select2InitAjax: function (selectClass, ajaxObj, options) {
            options = options || {};
            var $el = this.$element.find('input.' + selectClass);
            if ($el.select2)
                $el.select2('val', '').select2("destroy");
            $el.select2({
                minimumInputLength: options.minimumInputLength || 0,
                placeholder: options.placeholder || 0,
                ajax: ajaxObj
            });
        },
        setConfigByfield: function (fieldName) {
            this.select2InitData('operators', this.getOperators(fieldName));
            var getval = this.getValues(fieldName);
            if (getval.ajax) {
                this.select2InitAjax('values', getval.ajax, getval);
            } else if (getval.data) {
                this.select2InitData('values', getval.data, getval);
            } else
                this.select2Destroy('values');
        },
        getValue: function (selectClass) {
            var $el = this.$element.find('input.' + selectClass);
            if ($el.parent().hasClass('select2-container')) 
                return $el.select2('val');
            else 
                return $el.val();
    
        },
        destroy: function () {
            this.select2Destroy('fields');
            this.select2Destroy('operators');
            this.select2Destroy('values');
            this.$element.remove();
        },
        getQuery: function () {
            var q = new $.WhereClause();
            q.LogicalOperator = this.$element.find('.logical').val();
            q.FieldName = this.getValue('fields');
            q.Operator = this.getValue('operators');
            q.Value = this.getValue('values');
            return q;
        }
    };

    $.MB_qbBuilder = function (element, options) {
        this.init(element, options);
    };

    $.MB_qbBuilder.prototype = {
        clauses: [],
        init: function (element, options) {
            this.clauses.push(new $.MB_qbGroup(options, '', element));
            this.clauses[0].$element.find('.logical').parent().hide();
            this.options = {};
            $.extend(this.options, options);
            this.element = element;
        },
        deleteLastClause: function () {
            if (this.clauses.length > 1) {
                var clause = this.clauses.pop();
                clause.destroy();
            }
        },
        addClause: function () {
            this.clauses.push(new $.MB_qbGroup(this.options, '', this.element));
        },
        getQuery: function () {
            var query = [];
            for (var i = 0; i < this.clauses.length; i++) {
                query.push(this.clauses[i].getQuery());
            }
            return query;
        }
    }


    jQuery.fn.mb_queryBuilder = function (options) {

        var result = null;
        this.each(function () {
            $this = $(this);
            if (!$this.data('mb_queryBuilder')) {
                $this.data('mb_queryBuilder', new $.MB_qbBuilder(this, options));
            } else {
                if (typeof options == 'string') {
                    switch (options) {
                        case 'add':
                            $this.data('mb_queryBuilder').addClause();
                            break;
                        case 'remove':
                        case 'delete':
                            $this.data('mb_queryBuilder').deleteLastClause();
                            break;
                        case 'getclauses':
                            if(!result)
                                result = $this.data('mb_queryBuilder').getQuery();
                            break;

                        default:
                            break;

                    }
                }
            }

        });
        return result || this;
    };


})(jQuery)