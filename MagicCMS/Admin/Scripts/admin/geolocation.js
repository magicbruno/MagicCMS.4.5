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
