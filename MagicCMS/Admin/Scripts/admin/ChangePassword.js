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
