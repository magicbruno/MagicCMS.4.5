/// <reference path="../../../Scripts/_references.js" />

/**
* toISOString
**/
if (!Date.prototype.toISOString) {
    (function () {

        function pad(number) {
            if (number < 10) {
                return '0' + number;
            }
            return number;
        }

        Date.prototype.toISOString = function () {
            return this.getUTCFullYear() +
              '-' + pad(this.getUTCMonth() + 1) +
              '-' + pad(this.getUTCDate()) +
              'T' + pad(this.getUTCHours()) +
              ':' + pad(this.getUTCMinutes()) +
              ':' + pad(this.getUTCSeconds()) +
              '.' + (this.getUTCMilliseconds() / 1000).toFixed(3).slice(2, 5) +
              'Z';
        };

    }());
}

//Load global functions
$(document).ready(function () {

    /*
    Tooltip
    */
    $('.btn[title]')
        .tooltip({
            trigger: 'hover',
            container: 'body',
            viewport: {
                "selector": 'body',
                "padding": 0
            }
        })
        .on('click', function () {
            $(this).tooltip('hide');
        })
    ;


    bootbox.setDefaults({
        locale: 'it'
    })
    //app.init();
    var opensub = localStorage.getItem('openSub');
    if (opensub)
        $('#' + opensub + ' ul').slideDown();
    var page = window.location.pathname;
    $('[href="' + page.substr(1) + '"]').parent().addClass('active');

    //Numeric (int)
    $('.numeric').numeric({
        decimalPlaces: 0
    });
    $('.float').numeric({
        decimalPlaces: 2,
        decimal: ','
    });

    //datepicker
    $(document).off('.datepicker.data-api');

    $('.datepicker').datepicker({
        autoclose: 'true',
        language: 'it',
        todayBtn: true,
        todayHighlight: true,
        weekStart: 1,
        format: "dd/mm/yyyy"
    }).on('changeDate', function (e) {
        var $this = $(this);
        $this.attr('data-dateiso', $this.datepicker('getUTCDate').toISOString());
    }).each(function () {
        var $me = $(this);
        try {
            var d = Date.parse($me.attr('data-dateiso'));
            if (d)
                $me.datepicker('setUTCDate', new Date(d));
        } catch (e) {

        }
    })

    //bootstrap-growl
    $.growl(false,
        {
            element: 'body',
            allow_dismiss: true,
            placement: {
                from: "bottom",
                align: "right"
            },
            offset: 20,
            spacing: 10,
            z_index: 1031,
            delay: 6000,
            timer: 1000,
            url_target: '_blank',
            mouse_over: false,
            animate: {
                enter: 'animated fadeDown in fast',
                exit: 'animated fadeDown out fast'
            },
            icon_type: 'class',
            template: '<div data-growl="container" class="alert" role="alert"> ' +
               '<button type="button" class="close" data-growl="dismiss"> ' +
               '    <span aria-hidden="true">×</span> ' +
               '    <span class="sr-only">Close</span> ' +
               '</button> ' +
               '<span data-growl="icon"></span> ' +
               '<h4 data-growl="title"></h4> ' +
               '<span data-growl="message"></span> ' +
               '<a href="#" data-growl="url"></a> ' +
            '</div>'
        });

    // Open treeview ul with active li inside
    $('.treeview').each(function () {
        var $this = $(this);
        if ($this.find('.active').length)
            $this.addClass('active');
    })

    // Date picker component button
    $('.input-group.date .btn').on('click', function (e) {
        e.preventDefault();
        var $this = $(this);
        $this.parent().siblings('.datepicker').trigger('focus');
    })

});
