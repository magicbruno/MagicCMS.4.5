
$(function () {
	var slider = $('.bxSlider');
	slider.bxSlider({
		//mode:'fade',
		speed: 50,
		auto: true,
		pause: 10000,
		startSlide: 1,
		pager: false,
		controls: false,
		onSliderLoad: function (currentIndex) {
			slider.goToSlide(0);
			setTimeout(function () { slider.removeClass('fade'); }, 1500);		
		},
		onSlideAfter: function ($slideElement, oldIndex, newIndex) {
			$slideElement
				.removeClass('out')
				.addClass('in');
			setTimeout(function () {
				$slideElement
					.removeClass('in')
					.addClass('out');
			}, 8000);
		}
	});
})