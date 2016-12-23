/// <reference path="../../../Scripts/jquery-1.11.0.intellisense.js" />
/// <reference path="../../../Scripts/jquery-1.11.0.js" />


; (function ($, undefined) {
    $.MB_submit = function (element, settings) {
        this.init(element, settings);
    };

    $.MB_submit.prototype = {
        init: function (element, settings) {
            var self = this;
            this.$form = $(element);
            this.$submit = this.$form.find('[data-action="submit"]').first();
            if (settings.ajax)
                this.ajax = settings.ajax;
            else
                this.ajax = {
                    url: this.$form.attr('data-action')
                };
            if (settings.alert)
                this.$alert = $(settings.alert);
            else
                this.$alert = this.$form.find('.alert').first();
            this.$submit.on('click', function () {
                self.submitForm();
            });
            this.$form.on('change', 'input, select, textarea', function () {
                self.pendingChanges(true);
            });
            //this.$form.on('click isChanged', ':checkbox, :radio', function () {
            //    self.pendingChanges(true);
            //});
        },
        getValues: function () {
            var values = {};
            var $theForm = this.$form;
            $theForm
                .find('input, select, textarea')
                .each(function () {
                    var $me = $(this);
                    var evt = $.Event('validation.mb.form');
                    evt.relatedTarget = $me;
                    $theForm.trigger(evt);
                    if (evt.isDefaultPrevented()) {
                        values = {};
                        return false;
                    }
                    if ($me.data('datepicker')) {
                        var theDate = $me.data('datepicker').getDate();
                        var dateStr ='';
                        if (!isNaN(theDate.getTime()))
                            dateStr = theDate.toISOString();
                        if ($me.attr('name'))
                            values[$me.attr('name')] = dateStr;
                        else
                            values[$me.attr('id')] = dateStr;

                    } else if ($me.is(':checkbox')) {
                        if ($me.attr('name'))
                            values[$me.attr('name')] = $me.is(':checkbox:checked') ? true : false;
                        else
                            values[$me.attr('id')] = $me.is(':checkbox:checked') ? true : false;
                    } else if ($me.is(':radio:checked')) {
                        values[$me.attr('name')] = $me.val();
                    } else {
                        if ($me.attr('name'))
                            values[$me.attr('name')] = ($me.val() || '');
                        else
                            values[$me.attr('id')] = ($me.val() || '');
                    }

                });
            return values;
        },
        submitForm: function () {
            var params = this.getValues();
            var me = this;
            me.$form.spin();
            //$.getJSON(this.ajax.url, params)
            $.ajax(this.ajax.url,
                {
                    data: params,
                    dataType: 'json',
                    type: 'POST'
                })
                .fail(function (jqxhr, textStatus, error) {
                    if (me.$alert.length)
                        me.$alert
                            .text('Si è verificaro un errore: ' + textStatus + "," + error)
                            .removeClass('alert-success')
                            .addClass('alert-danger')
                            .show();
                })
                .done(function (data) {
                    if (data.success) {
                        if (me.$alert.length)
                            me.$alert
                                .text(data.msg)
                                .addClass('alert-success')
                                .removeClass('alert-danger')
                                .show();
                        me.pendingChanges(false);
                    } else {
                        if (me.$alert.length)
                            me.$alert
                                .text(data.msg)
                                .removeClass('alert-success')
                                .addClass('alert-danger')
                                .show();
                    }
                })
                .always(function (data) {
                    me.$form.spin(false);
                    //Viene lanciato l'evento custom
                    me.$submit
                        .trigger('submitted.mb.form', data);
                    //me.$form
                    //    .trigger('submitted.mb.form', data);
                })
        },
        enable: function (on) {
            if (on)
                this.$form
                    .find('fieldset').removeAttr('disabled');
            else
                this.$form
                    .find('fieldset').attr('disabled', '');

            this.$form.find('input[type="hidden"].form-control, select').each(function () {
                var $this = $(this);
                if ($this.select2)
                    $this.select2("enable", on);
            })
        },
        pendingChanges: function () {
            var self = this;
            if (arguments.length == 0)
                return self._pendingChanges;
            var value = arguments[0] ? true : false;
            if (value != this._pendingChanges) {
                self._pendingChanges = value;
            }
            self.$form.trigger('changed.mb.form', value);
        },
        ajax: {},
        $submit: null,
        $form: null,
        $alert: null,
        _pendingChanges: false

    }


    $.fn.mb_submit = function (s, arg) {

        var config = {};
        var $el = this;
        var settings = s || {};
        if ($.isPlainObject(settings)) {
            $.extend(config, settings);
            return $el.each(function () {
                var $this = $(this);
                if (!$this.data('mb-submit')) {
                    $this.data('mb-submit', new $.MB_submit(this, config));
                    return $el;
                };

            });
        }
        else 
        {
            switch (settings) {
                case 'enable':
                    var on = (typeof arg === typeof undefined) ? true : arg;
                    return $el.each(function() {
                        $(this).data('mb-submit').enable(on);
                    });
                    break;
                case 'submit':
                    return $el.each(function () {
                        $(this).data('mb-submit').submitForm();
                    });
                    break;
            	case 'pendingChanges':
            		if (typeof arg === typeof undefined) {
            			if ($el.data('mb-submit'))
            				return $el.data('mb-submit').pendingChanges();
            			else
            				return false;
                	}
                    else
                        return $el.each(function () {
                            $(this).data('mb-submit').pendingChanges(arg);
                        });
            		break;
            	case 'getValues':
            		if ($el.data('mb-submit'))
            			return $el.data('mb-submit').getValues();
            		else
            			return undefined;
            		break;
                default:
                    return $el;
                    break;
            }

        }
    };
})(jQuery, undefined);

$('[data-ride="mb-form"]').mb_submit();

