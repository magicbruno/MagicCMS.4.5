///////////////////////////////////////////////////////////////////////
/// --------------- Gestionescadenza sessione ---------------------///
///////////////////////////////////////////////////////////////////////

$(function () {
	var checkSession = function () {
		var addZero = function (n) {
			if (n < 10)
				n = '0' + String(n);
			return n;
		}
		$.getJSON('Session/SessionHandler.ashx')
		//Errore di rete
			.fail(function (jqxhr, textStatus, error) {
				bootbox.hideAll();
				var msg = 'Si è verificaro un errore di rete: ' + (error == "" ? 'o il dispositivo non è connesso a Iternet, o il server non risponde.' : textStatus + "," + error);
				bootbox.dialog({
					message: msg,
					closeButton: false,
					buttons: {
						'Riprova': {
							className: 'btn-primary',
							callback: function () {
								setTimeout(checkSession, 1000);
							}
						},
						'Annulla': {
							className: 'btn-danger',
							callback: function () {
								window.location.reload();
							}
						}
					}
				});
			})
			.done(function (data) {
				var sessionExpiryTimeout = data.data;
				var h = Math.floor(sessionExpiryTimeout / 3600);
				var min = sessionExpiryTimeout % 3600;
				var m = Math.floor(min / 60);
				var s = min % 60;

				// Sessione scaduta !!
				if (!data.success) {
					bootbox.hideAll();
					bootbox.alert(data.msg, function () {
						window.location.reload();
					});
				} else {
					// Allerta: La sessione sta per scadere
					$('#sessionExpiresIn').text(data.data);
					if (data.exitcode != 0) {
						$('#RinnovaSessione').modal('show');
					}
						//Sessione valida
					else {
						setTimeout(checkSession, 120000);
					}
				}
			})
	}
	checkSession();

	$('[data-action="sessionInfo"]').on('click', function (e) {
		e.preventDefault();
		var num = parseFloat(sessionExpiryTimeout);
		if (!isNaN(num)) {
			var totminuti = Math.round(num / 60);
			var ore = Math.floor(totminuti / 60);
			var minuti = totminuti % 60;
			if (ore > 0)
				bootbox.alert('La sessione scadrà tra ' + ore + (ore == 1 ? ' ora e ' : ' ore e ') + minuti + ' minuti.');
			else
				bootbox.alert('La sessione scadrà tra ' + minuti + ' minuti.');
		}
		else
			bootbox.alert('Errore di connessione: impossibile stabilire lo stato della sessione.');
	});

	$('[data-action="sessionRefresh"]').on('click', function (e) {
		e.preventDefault();
		var par = {
			email: $('#email').val(),
			password: $('#password').val(),
			"g-recaptcha-response": $('#g-recaptcha-response').val()
		};
		$.ajax('Session/SessionRefresh.ashx', {
			cache: false,
			dataType: "json",
			method: "post",
			data: par
		}).fail(function (jqxhr, textStatus, error) {
			bootbox.hideAll();
			var msg = 'Si è verificaro un errore di rete: ' + (error == "" ? 'o il dispositivo non è connesso a Iternet, o il server non risponde.' : textStatus + "," + error);
			bootbox.alert(msg);
		})
			.done(function (data) {
				// Sessione scaduta !!
				if (data.success) {
					bootbox.hideAll();
					bootbox.alert(data.msg, function () {
						$('#RinnovaSessione').modal('hide')
					});
				} else {
					// Allerta: La sessione sta per scadere
					if (data.exitcode == 1) {
						bootbox.alert(data.msg, function () {
							window.location.reload();
						});
					}
						//Sessione valida
					else {
						bootbox.alert(data.msg);
					}
				}
			})
			.always(function () {
				checkSession();
				if (grecaptcha)
					grecaptcha.reset();
			})
	});
})
