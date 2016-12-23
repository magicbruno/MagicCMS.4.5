
function newWinFn(fileurl) {
}

$(function () {
    // Button click event
    var lang = $('html').attr('lang') || 'it';
    $('[data-toggle="fb-window"]').on('click', function (e) {
        e.preventDefault();
        $win = $(window);
        var wh = $win.height();
        var ww = $win.width();
        var callback = $(this).attr('data-callback') || "";
        var height = Math.floor(wh * 0.75);
        height = (height < 480) ? wh : height;

        var width = Math.floor(ww * 0.75);
        width = (width < 640) ? ww : width;

        var top = window.screenTop + ( wh < 480 ? 0 : 50);
        var left = window.screenLeft + (ww < 640 ? 0 : 50);
        window.open('/FileBrowser/FileBrowser.aspx?caller=opener&fn=' + (callback == "" ? "newWinFn" : callback) + '&langCode=' + lang, 'fileBrowser',
            'top=' + top + ',left=' + left + ',menubar=0,scrollbars=0,toolbar=0,height=' + height +',width=' + width);
    })
});
