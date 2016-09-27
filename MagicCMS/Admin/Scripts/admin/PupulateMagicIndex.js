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
