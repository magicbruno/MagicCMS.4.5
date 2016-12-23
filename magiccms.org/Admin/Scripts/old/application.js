/// <reference path="../plugins/bootbox/bootbox.js" />
/// <reference path="../plugins/mb/mb-history.js" />
/// <reference path="../../Scripts/_references.js" />
/// <reference path="../../Scripts/modernizr.custom.27805.js" />





// Plugin per mbAjaxForm 
var app = function () {

    var init = function () {

        tooltips();
        menu();
    };

    var tooltips = function () {
        $('#toggle-left').tooltip();
    };


    var menu = function () {
        $("#leftside-navigation .sub-menu > a").click(function (e) {
            $("#leftside-navigation ul ul").slideUp();
            localStorage.removeItem('openSub');
            if (!$(this).next().is(":visible")) {
                $(this).next().slideDown();
                localStorage.setItem('openSub', $(this).parent().attr('id'));
            }
            e.stopPropagation();
        });
    };
    //End functions

    //Dashboard functions
    var timer = function () {
        $('.timer').countTo();
    };

    //return functions
    return {
        init: init,
        timer: timer
    };
}();



// Black background when form-box

$(function () {
})




$(function () {

})
