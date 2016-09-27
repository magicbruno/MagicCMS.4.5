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
