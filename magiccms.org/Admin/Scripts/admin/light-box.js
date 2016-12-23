$(function () {
    $('#LightBox').on('show.bs.modal', function (e) {
        var $this = $(this);
        var $btn = $(e.relatedTarget);
        var selector = $btn.attr('data-source');
        var url = $(selector).val();
        if (!url)
            url = $btn.attr('data-url');
        var $title = $this.find('.modal-title');
        var $body = $this.find('.modal-body');
        var $dialog = $this
            .children('.modal-dialog')
            .removeClass('modal-lg modal-sm')
        if (url) {
            $title.html(url);
            $body.html('');
            var ext = url.substr(url.lastIndexOf('.')).toLowerCase();
            if (ext == '.jpeg' || ext == '.jpg' || ext == '.gif' || ext == '.png') {
                var $img = $('<img />')
                    .addClass('img-responsive center-block')
                    .attr('src', url)
                    .appendTo($body);
                var img = $img[0];
                img.onload = function () {
                    if (img.width < 300)
                        $dialog.addClass('modal-sm');
                    else if (img.width > 600)
                        $dialog.addClass('modal-lg');
                };
            } else  if(!/<[a-z][\s\S]*>/i.test(url)) {
                $dialog.addClass('modal-lg');
                $('<iframe border="0" />')
                    .css({ 'width': '100%', border: 0, display: 'block' })
                    .height($(window).height() * 0.8)
                    .attr('src', url)
                    .appendTo($body);
            }
            else {
                $title.html('Magic CMS');
                $(url).addClass('text-center center-block').appendTo($body);
                //$body.html(url);
            }
        } else {
            $title.html('Errore');
            $body.html('<h4 class="text-center">Nessun contenuto da visualizzare.</h4>');
        }
    });
})
