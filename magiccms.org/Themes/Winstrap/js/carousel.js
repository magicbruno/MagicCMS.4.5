

$(function () {
	var slider = $('.mbslider');
	slider.mbSlider({
		//mode:'fade',
		auto: true,
		pause: 10000,
		pager: false,
		controls: false,
		customAnimation: 'slide',
		onSliderLoad: function (currentIndex) {
			slider.goToSlide(0);
			setTimeout(function () { slider.removeClass('fade'); }, 1500);
		}
	});
});

