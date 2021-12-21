

$(function () {
	var slider = $('[data-ride="mbslider"]');
	slider.mbSlider({
		auto: true,
		pause: 8000,
		pager: false,
		controls: false,
		customAnimation: 'slide',
		onSliderLoad: function (currentIndex) {
			setTimeout(function () { slider.removeClass('fade'); }, 1500);
		}
	});
});

