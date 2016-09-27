$(function () {
    $('#FileBrowserModal').on('show.bs.modal', function (e) {
        var $btn = $(e.relatedTarget);
        var callback = $btn.attr('data-callback');
        var $iFrame = $(this).find('iframe');
        if (callback)
            $iFrame.attr('src', '/FileBrowser/FileBrowser.aspx?caller=parent&fn=' + callback);
        else
            $iFrame.attr('src', '/FileBrowser/FileBrowser.aspx?caller=parent');
    });
})
