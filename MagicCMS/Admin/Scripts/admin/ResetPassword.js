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