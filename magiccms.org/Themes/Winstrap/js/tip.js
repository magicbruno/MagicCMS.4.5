$(function () {
	$('a[title]')
		.tooltip({trigger: 'hover'})
		.on('click', function () {
			$(this).tooltip('hide');
		});
});