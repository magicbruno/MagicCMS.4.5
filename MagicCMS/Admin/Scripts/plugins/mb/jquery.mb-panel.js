/// <reference path="../../../Scripts/jquery-1.11.0.intellisense.js" />
/// <reference path="../../../Scripts/jquery-1.11.0.js" />
/// <reference path="../../../Scripts/modernizr.custom.27805.js" />
;(function ($) {
    $.mb_panel = function (el) {
        this.element = el;
    }
    $.mb_panel.prototype = {
        init: function () {
            var $el = $(this.element);
            var self = this;
            $el.find('[data-toggle="mb-panel"]').on('click', function () {
                if ($(this).hasClass('disabled')) return;
                if (self.opened)
                    self.close();
                else
                    self.open();
            })
        },
        open: function () {
            var $el = $(this.element);
            if (this.opened) return;
            this.opened = true;
            $el.find('.panel-body').stop().slideDown(function () {
                $el.find('[data-toggle="mb-panel"]').addClass('fa-minus-square').removeClass('fa-plus-square').removeClass('disabled');
            });
        },
        close: function () {
            var $el = $(this.element);
            if (!this.opened) return;
            this.opened = false;;
            $el.find('.panel-body').stop().slideUp(function () {
                $el.find('[data-toggle="mb-panel"]').removeClass('fa-minus-square').addClass('fa-plus-square');
            });
        },
        lock: function () {
            var $el = $(this.element);
            this.close();
            $el.find('[data-toggle="mb-panel"]').addClass('disabled');
        },
        opened: true
    }
    $.fn.mb_panel = function (cmd) {
        var config = { };

        //if (settings) $.extend(config, settings);

        this.each(function () {
            var $this = $(this);
            if (!$this.data('mb-panel')) {
                var panel = new $.mb_panel(this);
                panel.init();
                $this.data('mb-panel', panel);
            }
            if ($.isFunction( $this.data('mb-panel')[cmd]))
                $this.data('mb-panel')[cmd]();
        });

        return this;
    };
})(jQuery);
$(function () {
    $('[data-ride="mb-panel"]').mb_panel();
})