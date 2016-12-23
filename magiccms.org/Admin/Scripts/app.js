///#source 1 1 /Admin/Scripts/admin/magiccms.js
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

    var lang = $('html').attr('lang') || 'it';
    bootbox.setDefaults({
        locale: lang
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

///#source 1 1 /Admin/Scripts/admin/application.js
/*!
 * Author: Abdullah A Almsaeed
 * Date: 4 Jan 2014
 * Description:
 *      This file should be included in all pages
 !**/

/*
 * Global variables. If you change any of these vars, don't forget 
 * to change the values in the less files!
 */
var left_side_width = 260; //Sidebar width in pixels

$(function () {
    "use strict";

    //Enable sidebar toggle
    $("[data-toggle='offcanvas']").click(function (e) {
        e.preventDefault();

        //If window is small enough, enable sidebar push menu
        if ($(window).width() <= 992) {
            $('.row-offcanvas').toggleClass('active');
            $('.left-side').removeClass("collapse-left");
            $(".right-side").removeClass("strech");
            $('.row-offcanvas').toggleClass("relative");
        } else {
            //Else, enable content streching
            $('.left-side').toggleClass("collapse-left");
            $(".right-side").toggleClass("strech");
        }
    });

    //Add hover support for touch devices
    $('.btn').bind('touchstart', function () {
        $(this).addClass('hover');
    }).bind('touchend', function () {
        $(this).removeClass('hover');
    });

    //Activate tooltips
    $("[data-toggle='tooltip']").tooltip();

    /*     
     * Add collapse and remove events to boxes
     */
    $("[data-widget='collapse']").click(function () {
        //Find the box parent        
        var box = $(this).parents(".box").first();
        //Find the body and the footer
        var bf = box.find(".box-body, .box-footer");
        if (!box.hasClass("collapsed-box")) {
            box.addClass("collapsed-box");
            //Convert minus into plus
            $(this).children(".fa-minus").removeClass("fa-minus").addClass("fa-plus");
            bf.slideUp();
        } else {
            box.removeClass("collapsed-box");
            //Convert plus into minus
            $(this).children(".fa-plus").removeClass("fa-plus").addClass("fa-minus");
            bf.slideDown();
        }
    });

    /*
     * ADD SLIMSCROLL TO THE TOP NAV DROPDOWNS
     * ---------------------------------------
     */
    //$(".navbar .menu").slimscroll({
    //    height: "200px",
    //    alwaysVisible: false,
    //    size: "3px"
    //}).css("width", "100%");

    /*
     * INITIALIZE BUTTON TOGGLE
     * ------------------------
     */
    $('.btn-group[data-toggle="btn-toggle"]').each(function () {
        var group = $(this);
        $(this).find(".btn").click(function (e) {
            group.find(".btn.active").removeClass("active");
            $(this).addClass("active");
            e.preventDefault();
        });

    });

    $("[data-widget='remove']").click(function () {
        //Find the box parent        
        var box = $(this).parents(".box").first();
        box.slideUp();
    });

    /* Sidebar tree view */
    $(".sidebar .treeview").tree();

    /* 
     * Make sure that the sidebar is streched full height
     * ---------------------------------------------
     * We are gonna assign a min-height value every time the
     * wrapper gets resized and upon page load. We will use
     * Ben Alman's method for detecting the resize event.
     * 
     **/
    function _fix() {
        //Get window height and the wrapper height
        var height = $(window).height() - $("body > form > div .header").height() - ($("body > form > div > .footer").outerHeight() || 0);
        $(".wrapper").css("min-height", height + "px");
        var content = $(".wrapper").height();
        //If the wrapper height is greater than the window
        if (content > height)
            //then set sidebar height to the wrapper
            $(".left-side, html, body").css("min-height", content + "px");
        else {
            //Otherwise, set the sidebar to the height of the window
            $(".left-side, html, body").css("min-height", height + "px");
        }
    }
    //Fire upon load
    _fix();
    //Fire when wrapper is resized
    $(window).resize(function () {
        _fix();
        fix_sidebar();
    });

    //Fix the fixed layout sidebar scroll bug
    fix_sidebar();

    /*
     * We are gonna initialize all checkbox and radio inputs to 
     * iCheck plugin in.
     * You can find the documentation at http://fronteed.com/iCheck/
     */
    $("input[type='checkbox']:not(.simple), input[type='radio']:not(.simple)").iCheck({
        checkboxClass: 'icheckbox_minimal',
        radioClass: 'iradio_minimal'
    }).on('ifChanged', function (e) {
        $(this).trigger('change');
    });

});
var test = true;
function fix_sidebar() {
    //Make sure the body tag has the .fixed class
    if (!$("body").hasClass("fixed")) {
        return;
    }

    //Add slimscroll
    var myHeight = ($(window).height() - $(".header").height());
    if (test)
        $(".sidebar").slimscroll({
            height: myHeight + "px",
            color: "rgba(2555,2555,255,0.6)",
            size: '5px'
        });
    else
        $('.sidebar, .slimScrollDiv').css('height', myHeight + 'px');
    test = false;
}
///#source 1 1 /Admin/Scripts/admin/filebrowser.js
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

///#source 1 1 /Admin/Scripts/admin/ResetPassword.js
// Reset password
$(function () {
    $('#btn_request_pwd').on('click', function (e) {
        e.preventDefault();
        var usr_email = $('#email').val();
        var param = { email: usr_email };
        $.getJSON('Ajax/PwdRequest.ashx', param)
            .fail(function (jqxhr, textStatus, error) {
                bootbox.alert('Si è verificaro un errore: ' + textStatus + "," + error);
            })
            .done(function (data) {
                if (data.success) {
                    bootbox.alert('La tua password è stata inviata con successo alla tua casella di posta.')
                } else {
                    bootbox.alert("Errore: " + data.msg);
                }
            })
    })
})
///#source 1 1 /Admin/Scripts/admin/ChangePassword.js
// Cambio password
$(function () {
    $("#btn_change_pwd").on('click', function (e) {
        e.preventDefault();
        var $this = $(this);
        var oldpwd = $('#oldpwd').val();
        var pwd = $('#pwd').val();
        var checkpwd = $('#checkpwd').val();
        // Se un campo è vuoto non vaccioniente
        if (!(oldpwd.length || pwd.length || checkpwd.length))
            return;
        var param = {
            oldpwd: oldpwd,
            pwd: pwd,
            checkpwd: checkpwd
        };
        $this.button('loading');
        $.getJSON('Ajax/PdwChange.ashx', param)
            .fail(function (jqxhr, textStatus, error) {
                $('#Modal_change_pwd .alert')
                    .text('Si è verificaro un errore: ' + textStatus + "," + error)
                    .removeClass('alert-success')
                    .addClass('alert-danger')
                    .show();
            })
            .done(function (data) {
                if (data.success) {
                    $('#Modal_change_pwd .alert')
                        .text(data.msg)
                        .removeClass('alert-danger')
                        .addClass('alert-success')
                        .show();
                } else {
                    $('#Modal_change_pwd .alert')
                        .text(data.msg)
                        .removeClass('alert-success')
                        .addClass('alert-danger')
                        .show();
                }
            })
            .always(function () {
                $this.button('reset').hide();
            })
    })
    $('#Modal_change_pwd').on('hidden.bs.modal show.bs.modal', function () {
        var $this = $(this);
        $this.find('.alert').hide();
        $this.find('.btn').show();
        $this.find(':password').val('');
    })
})

///#source 1 1 /Admin/Scripts/admin/checkSession.js
///////////////////////////////////////////////////////////////////////
/// --------------- Gestionescadenza sessione ---------------------///
///////////////////////////////////////////////////////////////////////

$(function () {
	var checkSession = function () {
		var addZero = function (n) {
			if (n < 10)
				n = '0' + String(n);
			return n;
		}
		$.getJSON('Session/SessionHandler.ashx')
		//Errore di rete
			.fail(function (jqxhr, textStatus, error) {
				bootbox.hideAll();
				var msg = 'Si è verificaro un errore di rete: ' + (error == "" ? 'o il dispositivo non è connesso a Iternet, o il server non risponde.' : textStatus + "," + error);
				bootbox.dialog({
					message: msg,
					closeButton: false,
					buttons: {
						'Riprova': {
							className: 'btn-primary',
							callback: function () {
								setTimeout(checkSession, 1000);
							}
						},
						'Annulla': {
							className: 'btn-danger',
							callback: function () {
								window.location.reload();
							}
						}
					}
				});
			})
			.done(function (data) {
				var sessionExpiryTimeout = data.data;
				var h = Math.floor(sessionExpiryTimeout / 3600);
				var min = sessionExpiryTimeout % 3600;
				var m = Math.floor(min / 60);
				var s = min % 60;

				// Sessione scaduta !!
				if (!data.success) {
					bootbox.hideAll();
					bootbox.alert(data.msg, function () {
						window.location.reload();
					});
				} else {
					// Allerta: La sessione sta per scadere
					$('#sessionExpiresIn').text(addZero(h) + ':' + addZero(m) + ':' + addZero(s));
					if (data.exitcode != 0) {
						$('#RinnovaSessione').modal('show');
					}
						//Sessione valida
					else {
						setTimeout(checkSession, 120000);
					}
				}
			})
	}
	checkSession();

	$('[data-action="sessionInfo"]').on('click', function (e) {
		e.preventDefault();
		var num = parseFloat(sessionExpiryTimeout);
		if (!isNaN(num)) {
			var totminuti = Math.round(num / 60);
			var ore = Math.floor(totminuti / 60);
			var minuti = totminuti % 60;
			if (ore > 0)
				bootbox.alert('La sessione scadrà tra ' + ore + (ore == 1 ? ' ora e ' : ' ore e ') + minuti + ' minuti.');
			else
				bootbox.alert('La sessione scadrà tra ' + minuti + ' minuti.');
		}
		else
			bootbox.alert('Errore di connessione: impossibile stabilire lo stato della sessione.');
	});

	$('[data-action="sessionRefresh"]').on('click', function (e) {
		e.preventDefault();
		var par = {
			email: $('#email').val(),
			password: $('#password').val(),
			"g-recaptcha-response": $('#g-recaptcha-response').val()
		};
		$.ajax('Session/SessionRefresh.ashx', {
			cache: false,
			dataType: "json",
			method: "post",
			data: par
		}).fail(function (jqxhr, textStatus, error) {
			bootbox.hideAll();
			var msg = 'Si è verificaro un errore di rete: ' + (error == "" ? 'o il dispositivo non è connesso a Iternet, o il server non risponde.' : textStatus + "," + error);
			bootbox.alert(msg);
		})
			.done(function (data) {
				// Sessione scaduta !!
				if (data.success) {
					bootbox.hideAll();
					bootbox.alert(data.msg, function () {
						$('#RinnovaSessione').modal('hide')
					});
				} else {
					// Allerta: La sessione sta per scadere
					if (data.exitcode == 1) {
						bootbox.alert(data.msg, function () {
							window.location.reload();
						});
					}
						//Sessione valida
					else {
						bootbox.alert(data.msg);
					}
				}
			})
			.always(function () {
				checkSession();
				if (grecaptcha)
					grecaptcha.reset();
			})
	});
})

///#source 1 1 /Admin/Scripts/admin/light-box.js
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

///#source 1 1 /Admin/Scripts/admin/geolocation.js
$(function () {
	var lastaddress = "";
	var $map_canvas = $('#map-dialog .map-canvas').height($(window).height() * 0.6);
	var $address_field = $('#geolocAddress');
	var $latLang_field = $address_field.siblings('input[type="hidden"]');
	var theMap, theCenter, theMarker;
	var geocoder = new google.maps.Geocoder();

	var geocodeAddress = function (request) {
		if (!$.isPlainObject(request))
			return;
		geocoder.geocode(request, function (results, status) {
			$address_field.parent().spin(false);
			if (status === 'OK') {
				theMap.setCenter(results[0].geometry.location);
				theMarker.setPosition(results[0].geometry.location);
				$address_field.val(results[0].formatted_address);
				$latLang_field.val(results[0].geometry.location.lat() + ',' + results[0].geometry.location.lng());
			} else {
				alert("Impossibile risolvere l'indirizzo (" + status + ')');
			}
		});
	}

	$map_canvas
		.gmap3({
			address: "Roma, Italia",
			zoom: 16,
			//mapTypeId: google.maps.MapTypeId.ROADMAP,
			mapTypeControl: true,
			navigationControl: true,
			scrollwheel: true,
			streetViewControl: true
		})
		.then(function (map) {
			theMap = map;
			theMarker = new google.maps.Marker({
				map: map,
				position: map.getCenter(),
				draggable: true
			});
			theMarker.addListener('dragend', function () {
				$address_field.parent().spin();
				geocodeAddress({ location: theMarker.getPosition() })
			});
			var input = document.getElementById('geolocAddress');
			var autocomplete = new google.maps.places.Autocomplete(input);
			autocomplete.bindTo('bounds', map);
		});

 	$('#map-dialog')
        .on('shown.bs.modal', function (e) {
        	$map_canvas
				.height($(window).height() * 0.6);
        	google.maps.event.trigger(theMap, "resize", {});
        	//var map = $map_canvas.gmap3('get');


        	var $this = $(this);
        	var $btn = $(e.relatedTarget);
        	var selector = $btn.attr('data-source');
        	$this.attr('data-souce', selector);
        	var address = $(selector).val();
        	var $title = $this.find('.modal-title');
        	address = address || "Roma Italy";
        	$address_field.val(address);
        	$('[data-action="geo-search"]').trigger('click');
        })
        .on('hide.bs.modal', function () {
        	var selector = $(this).attr('data-souce');
        	var $address_field = $('#geolocAddress');
        	var $latLang_field = $address_field.siblings('input[type="hidden"]');
        	$(selector).val($latLang_field.val()).change();

        });

	$('[data-action="geo-search"]').on('click', function (e) {
		e.preventDefault();
		var $this = $(this);
		var $map_canvas = $('#map-canvas');
		var selector = $this.attr('data-source');
		var $address_field = $(selector);
		var $latLang_field = $address_field.siblings('input[type="hidden"]');
		var address = $address_field.val();
		$address_field.parent().spin();
		geocodeAddress({address: address});
	})

});

///#source 1 1 /Admin/Scripts/admin/jstree.mb.selectnode.js
;(function ($) {
	$.mb_selectnode = function (tree,data_pk, json_tree, select) {
		for (var i = 0; i < json_tree.length; i++) {
			var node = json_tree[i];
			if (node.a_attr['data-pk'] == data_pk)  {
				if (select)
					tree.select_node(node);
				else
					tree.deselect_node(node);
			}
			if (node.children.length)
				$.mb_selectnode(tree, data_pk, node.children, select);
		}
	}

})(jQuery);
///#source 1 1 /Admin/Scripts/admin/checkboxed-types.js
$(function () {
    $('#checkboxed-types-modal').on('shown.bs.modal', function (e) {
        var $this = $(this);
        var $btn = $(e.relatedTarget);
        var $title = $this.find('.modal-title');
        var $body = $this.find('.modal-body');
        $this.data('target-selector', $btn.attr('data-selector'));
        $body
            .css('min-height', '120px')
            .spin()
            .load('Ajax/GetTypesCheckboxed.ashx', function () {
                $body
                    .spin(false)
                    .css('min-height', 0)
                    .find(':checkbox')
                    .iCheck({
                        checkboxClass: 'icheckbox_minimal'
                    });
                    
            });
    });

    $('#checkboxed-types-modal button[data-action="get-list"]').on('click', function () {
        var $modal = $('#checkboxed-types-modal');
        var selector = $modal.data('target-selector');
        var $btn = $(this);
        var $target = $(selector);
        var $body = $modal.find('.modal-body');
        var checked = $body.find(':checkbox:checked');
        var list = [];
        checked.each(function () {
            list.push($(this).val());
        })
        $target.val(list.join(',')).change();

    })
    
})

///#source 1 1 /Admin/Scripts/admin/filebrowser_win.js

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

///#source 1 1 /Admin/Scripts/admin/PupulateMagicIndex.js
// Cambio password
$(function () {
	var $populateModal = $('#modal-magicindex');
    $('[data-action="populate"]').on('click', function (e) {
        e.preventDefault();
    	var $this = $(this),
    		$modal = $this.closest('.modal-content'),
    		$alert = $modal.find('.alert');
    	$modal.spin();
    	$.getJSON('Ajax/PopulateMagicIndex.ashx')
            .fail(function (jqxhr, textStatus, error) {
                $alert
                    .text('Si è verificaro un errore: ' + textStatus + "," + error)
                    .removeClass('alert-success')
                    .addClass('alert-danger')
                    .show();
            })
            .done(function (data) {
                if (data.success) {
                    $alert
                        .text(data.msg)
                        .removeClass('alert-danger')
                        .addClass('alert-success')
                        .show();
                    $this.attr('disabled', 'disabled');
                } else {
                    $alert
                        .text(data.msg)
                        .removeClass('alert-success')
                        .addClass('alert-danger')
                        .show();
                }
            })
            .always(function () {
                $modal.spin(false);
            })
    })
    $populateModal.on('hidden.bs.modal show.bs.modal', function () {
        var $this = $(this);
        $this.find('.alert').hide();
        $this.find('.btn').removeAttr('disabled');
    })
})

