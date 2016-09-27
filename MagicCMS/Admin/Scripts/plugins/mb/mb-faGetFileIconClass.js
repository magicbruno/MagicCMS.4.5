(function ($) {
    $.faGetFileIconClass = function (filename) {
        var config = { 'foo': 'bar' };
        var extension = filename.substr((filename.lastIndexOf('.') + 1));
        switch (extension) {
            case 'gif':
            case 'png':
            case 'jpg':
            case 'jpeg':
                return 'fa-image-o';
                break;
            case 'pdf':
                return 'fa-file-pdf-o';
                break;
            case 'rar':
            case 'zip':
            case 'tarz':
                return 'fa-file-archive-o';
                break;
            case 'mp3':
            case 'wav':
            case 'ogg':
                return 'fa-file-audio-o';
                break;
            case 'xls':
            case 'xlsx':
                return 'fa-file-excel-o';
                break;
            case 'doc':
            case 'docx':
                return 'fa-file-word-o';
            case 'ppt':
            case 'pptx':
            case 'pps':
            case 'ppsx':
                return 'fa-file-powerpoint-o';
                break;
            case 'txt':
                return 'fa-file-text-o';
            default:
                return 'fa-file-o';
        }
    };
})(jQuery);