/// <reference path="../../../Scripts/_references.js" />
/// <reference path="plugins/jquery.prettySocial.js" />


////////////////////////////////////////////////////////////////////////////////
/// --------------------------mb_fullscreen ------------------------//
////////////////////////////////////////////////////////////////////////////////



$(function () {
	$("body").mb_waitspinner({
		locked: true,
		windowColor: "rgba(21,21,21,0.8",
		color: "#FFF",
		callback: function (ws) {
			setTimeout(function () {
				if ($(".slick-slider").length) {
					$(".slick-slider")
						.css('opacity', 0)
						.removeClass('invisible')
						.animate({ opacity: 1 }, "fast", function () {
						//$(".slick-carousel").slickPlay();
						ws.hide();
					});
				}
				else
					ws.hide();
			}, 100)
			return false;
		}
	})
});

$(document).ready(function () {

	/** TOOLTIP **/
	$('[data-toggle="tooltip"]').tooltip({
		container: "body"
	})

	/** SMOOTH SCROLL SELECTOR **/
	//$('ul.scroll-nav a').smoothScroll({
	//    easing: 'swing',
	//    speed: 500
	//});
 
	//$('#back-top a').smoothScroll({
	//    easing: 'swing',
	//    speed: 500
	//});

	//++ Small Dispaly Menu **/
	$("#mobile-menu select").on("change", function () {
		var $this = $(this);
		var myTarget = $this.val();
		if (myTarget != "0")
			$('a[href="' + myTarget + '"]').click();
		$this.val("0");
	})


	/** BACK TO TOP **/
	$("#back-top").hide();

	/** BACk TO TOP FADE IN **/
	$(function () {
		$(window).scroll(function () {
			if ($(this).scrollTop() > 100) {
				$('#back-top').fadeIn();
			} else {
				$('#back-top').fadeOut();
			}
		});
	});


});

/*---------------------------------------------
************* Tube player *****************
---------------------------------------------*/
/*
	Responsive embedded You Tube Player 
*/

$(function () {
	// Enbed player into div with id "mb_youtube_player" 
	// and get video id from "data-videoid" attribute
	$(".mb-tubeplayer").each(function () {
		var $this = $(this);
		var myWidth = $this.parent().width();
		var myHeight = myWidth / 16 * 9;
		var videoId = $this.attr("data-videoid");
		$this.tubeplayer({
			width: myWidth, // the width of the player
			height: myHeight, // the height of the player
			allowFullScreen: "true", // true by default, allow user to go full screen
			initialVideo: videoId, // the video that is loaded into the player
			preferredQuality: "default"
		});
	})
	// Video responsive !!
	// Resize player to fill parent div
	$(window).resize(function () {
		var myWidth = $(".jquery-youtube-tubeplayer").parent().width();
		var myHeight = myWidth / 16 * 9;
		$(".jquery-youtube-tubeplayer").tubeplayer("size", { width: myWidth, height: myHeight });
	})

});

/////////////////////////////////////////////////////////////////////////////////
///---------------- regolo altezza carousel ------------------------///
/////////////////////////////////////////////////////////////////////////////////
$(function () {
	//$(window).on("load resize", function () {
	//	$('.carousel').each(function () {
	//		var $this = $(this);
	//		var maxHeight = 120;
	//		var $items = $this.find('.item');
	//		$items.each(function () {
	//			var $item = $(this);
	//			$this.css({ " matgin-top": 0, "margin-bottom": 0 });
	//			var h = $(this).outerHeight();
	//			if (h > maxHeight)
	//				maxHeight = h;
	//		})
	//		$this.height(maxHeight);
	//		$items.each(function () {
	//			var $item = $(this);
	//			$item.css('margin-top', (maxHeight - $item.outerHeight()) / 2 + "px");
	//		})
	//	})
	//})
	$('.carousel').carousel({ interval: false });

})
////////////////////////////////////////////////////////////////////////////////////
///------------------Form Messaggio in Contatti ------------------------------////
////////////////////////////////////////////////////////////////////////////////////
$(function () {
	var mySerialize = function (selector) {
		var result = {};
		$(selector).find('*').each(function () {
			var $this = $(this);
			var id = $this.attr('id') ? $this.attr('id') : $this.attr('name')

			if (id && $this.val) {
				result[id] = $this.val();
			}
		});
		return result;
	}
	$('#submitcontatti').on("click", function (e) {
		var waitScreen = new MbWaitSpinner({ locked: true, color: "#fff", windowColor: "rgba(0,0,0,0.60)" });
		waitScreen.show();
		e.preventDefault();
		$.getJSON("SendMail_ajax-JSON.aspx", mySerialize("#fieldset_contatti"))
			.done(function (data) {
				bootbox.alert(data.msg);
				waitScreen.hide();
			})
			.fail(function (jqXHR, testStatus, error) {
				bootbox.alert('Errore di tipo "' + testStatus + '": ' + error);
				waitScreen.hide();
			});
	});
});

$(function () {
	$(".slick-carousel").on('init', function (e, slider) {
		var h = slider.$slider.height();
		var wh = $(window).height();
		var padding = 0;
		if (h < wh)
			padding = (h - slider.$slides.eq(0).css('padding-top', 0).height()) / 2;
		slider.$slides
			.eq(0)
			.removeClass("out")
			.addClass("in")
			.children()
			.first()
			.css("padding-top", padding + "px");
	});
	$(".slick-carousel").slick({
		autoplay: true,
		autoplaySpeed: 7000,
		speed: 1000,
		arrows: false,
		fade: true
	});
	$(".slick-carousel").on('beforeChange', function (e, slider, index) {
		slider.$slides
			.eq(index)
			.removeClass("in")
			.addClass("out");
	});
	$(".slick-carousel").on('afterChange', function (e, slider, index) {
		var h = slider.$slider.height();
		var wh = $(window).height();
		var padding = 0;
		var $mySlide = slider.$slides.eq(index);
		$mySlide.children().first().css("padding-top", 0);
		var self = $mySlide.height();
		if (h < wh)
			padding = (h - self) / 2;

		slider.$slides
			.eq(index)
			.removeClass("out")
			.addClass("in")
			.children()
			.first()
			.css("padding-top", padding + "px");
	});

})
/*---------------------------------------------
************* Google map *****************
---------------------------------------------*/
$(function () {

	$("#map_canvas").gmap3({
		//map: {
		//    address: mapaddress,
		//    options: {
		//        zoom: mapzoom,		//initial zoom defined above
		//        scrollwheel: false  //No mousewheel zomm-> set to true to activate
		//    },
		//    events: {
		//        // Close infowindow when click outside
		//        click: function () {
		//            var map = $(this).gmap3("get"),
		//			  infowindow = $(this).gmap3({ get: { name: "infowindow" } });
		//            if (infowindow)
		//                infowindow.close();
		//        }
		//    }
		//},
		//marker: {
		//    values: markervalues,		// Marker define above
		//    options: {
		//        draggable: false		// You can't drag markers!
		//    },
		//    events: {
		//        // Open infowindow on marker click
		//        click: function (marker, event, context) {
		//            var map = $(this).gmap3("get"),
		//			  infowindow = $(this).gmap3({ get: { name: "infowindow" } });
		//            if (infowindow) {
		//                infowindow.open(map, marker);
		//                infowindow.setContent(context.data);
		//            } else {
		//                $(this).gmap3({
		//                    infowindow: {
		//                        anchor: marker,		// Infowindow is over the clicked marker
		//                        options: { content: context.data }  // HTML content of infowoindow (as defined above)
		//                    }
		//                });
		//            }
		//        }
		//    }
		//}
	});
	$(window).on("load resize", function () {
		var $target = $('.addresses .img-responsive').css("max-height", 10000 + 'px');
		var $target2 = $('addresses > div').css("height", "auto");
		var min = 10000, max = 0;
		$target.each(function () {
			var h = $(this).height();
			if (min > h) min = h;
		}).css('max-height', min + 'px');

		$target2.each(function () {
			var h = $(this).height();
			if (max < h) max = h;
		}).css('height', max + 'px');
	})
});

//$(function () {
//    $('.row').mb_equalheight(".blog-column");
//})



