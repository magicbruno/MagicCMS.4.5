(function ($) {
    $.mb_fullscreen = function (el, options, callback) {

        /* Setup base elem vars */
        var base = this;
        base.$el = $(el);
        base.el = el;
        base.$el.data("fullscreen", base);
        base.options = { centerpoint: 0.5 };

        $.extend(base.options, options || {});
        /*
		 * Init
		 */
        base.init = function () {
            base.$inner = $("<div />");
            base.$inner
				.append(base.$el.children())
				.appendTo(base.$el);
        };

        /*
		 * Callback func when successful (returns element)
		 */
        base.arrange = function () {
            base.$inner.css({ "padding-top": 0, "padding-bottom": 0 });
            var diff = $(window).height() - base.$el.outerHeight();
            if (diff > 0) {
                var up = parseFloat(base.options.centerpoint);
                if (isNaN(up) || up > 1) {
                    throw "Centerpoint è out of legal range.";
                    return;
                }
                var topPadding = Math.floor(diff * up) + "px";
                var bottomPadding = Math.ceil(diff * (1 - up)) + "px";
                base.$inner.css({ "padding-top": topPadding, "padding-bottom": bottomPadding });
            }
            if (callback)
                callback(base.$el); // Return elem
        };
        base.init();
    };

    $.fn.mb_fullscreen = function (option, callback) {
        return this.each(function () {
            var mbf = new $.mb_fullscreen(this, option, callback);
            $(window).on("load resize", function () {
                mbf.arrange();
            });
        });
    };
})(jQuery);
