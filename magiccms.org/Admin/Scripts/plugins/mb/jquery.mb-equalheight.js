/// <reference path="../vendor/jquery-1.11.0.js" />

; (function (defaults, $, window, document, undefined) {

    'use strict';

    $.fn.extend({
        mb_equalheight: function () {
            var onready, selector;
            if (typeof arguments[0] === "string")
                selector = arguments[0];
            else
                selector = "> *";

            if ($.isFunction(arguments[0]))
                onready = arguments[0];
            else if ($.isFunction(arguments[1]))
                onready = arguments[1];

            return $(this).each(function (i, el) {
                var $me = $(this);
                var $children = $me.find(selector);
                $(window).on('load resize', function () {
                    var exec = true;
                    if ($.isFunction(onready)) {
                        exec = onready($me);
                    }
                    if (!exec) return;
                    var max = 0;
                    $children
                        .css("height", "auto")
                        .each(function () {
                            var h = $(this).height();
                            if (max < h)
                                max = h;
                        })
                    .css('height', max + 'px');

                });
            })
        }
    });
})({}, jQuery, window, document);