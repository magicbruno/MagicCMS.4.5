///////////////////////////////////////////////////////////////////////
/// --------------- Gestionescadenza sessione ---------------------///
///////////////////////////////////////////////////////////////////////
$(function () {
    var checkSession = function () {
        $.getJSON('Session/SessionHandler.ashx')
            //Errore di rete
            .fail(function (jqxhr, textStatus, error) {
                bootbox.hideAll();
                bootbox.alert('Si è verificaro un errore di rete: ' + textStatus + "," + error, function () {
                    setTimeout(checkSession, 2000);
                });
            })
            .done(function (data) {
                // Sessione scaduta !!
                if (!data.success) {
                    bootbox.hideAll();
                    bootbox.alert(data.msg, function () {
                        window.location.reload();
                    });
                } else {
                    // Allerta: La sessione sta per scadere
                    if (data.exitcode != 0) {
                        bootbox.alert(data.msg);
                        setTimeout(checkSession, data.data * 1000 + 10000)
                    }
                        //Sessione valida
                    else {
                        setTimeout(checkSession, 120000);
                    }
                }
            })
    }
    checkSession();
})
