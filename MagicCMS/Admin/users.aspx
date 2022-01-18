<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/MasterAdmin.master" AutoEventWireup="true"
    CodeBehind="users.aspx.cs"
    Inherits="MagicCMS.Admin.users" Culture="it-IT" UICulture="it" %>
<%@ MasterType TypeName="MagicCMS.Admin.MasterAdmin" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="HeaderContent" runat="server">
    <h1><i class="fa fa-users"></i><%= Master.Translate("Gestione utenti") %></h1>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
    <div class="row">
        <div class="col-md-12">
            <div class="box box-primary" data-ride="mb-panel">
                <div class="box-header">
                    <h3 class="box-title"><%= Master.Translate("Elenco utenti") %></h3>
                    <div class="box-tools pull-right">
                        <button type="button" class="btn btn-success btn-sm btn-icon" data-action="download-csv">
                            <i class="fa fa-file-excel-o"></i>
                        </button>
                        <a href="#modal-edit-user" data-toggle="modal" data-rowpk="0" class="btn btn-sm bg-olive">
                            <i class="fa fa-user"></i><%= Master.Translate("nuovo utente") %></a>
                        <button type="button" class="btn btn-primary btn-sm" data-widget="collapse">
                            <i class="fa fa-minus"></i>
                        </button>
                    </div>
                </div>
                <div class="box-body">
                    <table id="utenti" class="table table-striped table-bordered"  style="width:100%" width="100%">
                        <thead>
                            <tr>
                                <th>Email</th>
                                <th><%= Master.Translate("Nome") %></th>
                                <th><%= Master.Translate("Prerogative") %></th>
                                <%--<th>Attivato<%= Master.Translate("") %></th>--%>
                                <th><i class="fa fa-edit"></i></th>
                                <th><i class="fa fa-eraser"></i></th>
                            </tr>
                        </thead>

                        <tbody>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
    <div class="modal fade" id="modal-edit-user" tabindex="-1" role="dialog" aria-labelledby="<%= Master.Translate("Modifica i dati di un utente") %>"
        aria-hidden="true" data-backdrop="static">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">
                        <span aria-hidden="true">&times;</span><span
                            class="sr-only">Chiudi</span></button>
                    <h4 class="modal-title" id="myModalLabel"><%= Master.Translate("Modifica i dati di un utente") %></h4>
                </div>
                <div class="modal-body">
                    <div class="form-horizontal" role="form" data-action="Ajax/Edit.ashx" data-ride="mb-form">
                        <input type="hidden" id="pk" value="0" />
                        <input type="hidden" id="table" value="ANA_USR" />
                        <div class="form-group" id="fg-email">
                            <label for="user_email" class="col-sm-2 control-label">Email</label>
                            <div class="col-sm-10">
                                <input type="email" class="form-control" id="Email" placeholder="Email" />
                            </div>
                        </div>
                        <div class="form-group" id="fg-name">
                            <label for="user_name" class="col-sm-2 control-label"><%= Master.Translate("Nome") %></label>
                            <div class="col-sm-10">
                                <input type="text" class="form-control" id="Name" placeholder="<%= Master.Translate("Nome e Cognome") %>" />
                            </div>
                        </div>
                        <div class="form-group" id="fg-level">
                            <label for="user_name" class="col-sm-2 control-label"><%= Master.Translate("Prerogative") %></label>
                            <div class="col-sm-10">
                                <input id="Level" class="form-control user_prerogatives" type="text" />
                            </div>
                        </div>
                        <div class="form-group" id="fg-sendmail">
                            <div class="col-sm-offset-2 col-sm-10">
                                <div class="checkbox">
                                    <label>
                                        <input type="checkbox" id="sendmail" class="" />
                                        <%= Master.Translate("invia automaticamente una e-mail all'utente dopo la registrazione") %>
                                    </label>
                                </div>
                            </div>
                        </div>
                        <div class="form-group">
                            <div class="col-sm-offset-2 col-sm-10">
                                <button type="button" class="btn btn-primary" data-action="submit"><%= Master.Translate("Salva") %></button>
                                <button type="button" class="btn btn-danger" data-dismiss="modal"><%= Master.Translate("Chiudi") %></button>
                            </div>
                        </div>
                        <div class="alert"></div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="Scripts" runat="server">
    <script>
        $('input.user_prerogatives').select2(
            {
                data: []
            }
        );


        var $tableUtenti =
            $('#utenti')
                .on('xhr.dt', function (e, settings, json) {
                    var xhr = settings.jqXHR;
                    if (xhr.status == 403) {
                        bootbox.alert('<%= Master.Translate("Sessione scaduta. È necessario ripetere il login") %>.', function () {
                            window.location.href = "/login.aspx";
                        });
                    }
                    //else if (xhr.status != 200)
                    //    bootbox.alert('Si è verificaro un errore: ' + xhr.status + ", " + xhr.statusText);
                })
                .DataTable({
                    "serverSide": true,
                    "ajax": {
                        "url": "Ajax/UsersPaginated.ashx",
                        "type": "POST"
                    },
                    "language": {
                        "sEmptyTable": "<%= Master.Translate("Nessun dato presente nella tabella") %>",
                        "sInfo": "<%= Master.Translate("Vista da _START_ a _END_ di _TOTAL_ elementi") %>",
                        "sInfoEmpty": "<%= Master.Translate("Vista da 0 a 0 di 0 elementi") %>",
                        "sInfoFiltered": "<%= Master.Translate("(filtrati da _MAX_ elementi totali)") %>",
                        "sInfoPostFix": "",
                        "sInfoThousands": ",",
                        "sLengthMenu": "<%= Master.Translate("Visualizza _MENU_ elementi") %>",
                        "sLoadingRecords": "<%= Master.Translate("Caricamento") %>...",
                        "sProcessing": "<%= Master.Translate("Elaborazione") %>...",
                        "sSearch": "<%= Master.Translate("Cerca") %>:",
                        "sZeroRecords": "<%= Master.Translate("La ricerca non ha portato alcun risultato") %>.",
                        "oPaginate": {
                            "sFirst": "<%= Master.Translate("Inizio") %>",
                            "sPrevious": "<%= Master.Translate("Precedente") %>",
                            "sNext": "<%= Master.Translate("Successivo") %>",
                            "sLast": "<%= Master.Translate("Fine") %>"
                        },
                        "oAria": {
                            "sSortAscending": ": <%= Master.Translate("attiva per ordinare la colonna in ordine crescente") %>",
                            "sSortDescending": ": <%= Master.Translate("attiva per ordinare la colonna in ordine decrescente") %>"
                        }
                    },
                    "columnDefs": [
                        {
                            "targets": 0,
                            "data": "Email",
                            "name": "usr_EMAIL",
                            "width": "22%"
                        },
                        {
                            "targets": 1,
                            "data": "Name",
                            "name": "usr_NAME",
                            "width": "22%"
                        },
                        {
                            "targets": 2,
                            "searchable": false,
                            "orderable": false,
                            "data": "LevelDescription",
                            "width": "16%"
                        },
                        //{
                        //    "targets": 3,
                        //    "searchable": false,
                        //    "orderable": false,
                        //    "data": "Activated",
                        //    "width": "12%",
                        //    "className": "text-center",
                        //    "render": function (data, type, full, meta) {
                        //        if (data)
                        //            return '<i class="fa fa-check"></i> ';
                        //        else
                        //            return '<i class="fa fa-times"></i> ';
                        //    }
                        //},
                        {
                            "targets": 3,
                            "data": "Pk",
                            "searchable": false,
                            "orderable": false,
                            "className": "text-center",
                            "render": function (data, type, full, meta) {
                                var btn = $('<button />')
                                    .addClass('btn btn-primary btn-xs')
                                    .attr('data-rowpk', data)
                                    .attr('data-toggle', 'modal')
                                    .attr('data-target', '#modal-edit-user')
                                    .attr('type', 'button')
                                    .html('<i class="fa fa-edit"></i><%= Master.Translate("modifica") %>');
                                return $('<div />').append(btn).html();
                            }
                        },
                        {
                            "targets": 4,
                            "data": "Pk",
                            "searchable": false,
                            "orderable": false,
                            "className": "text-center",
                            "render": function (data, type, full, meta) {
                                var btn = $('<button />')
                                    .addClass('btn btn-danger btn-xs')
                                    .attr('data-rowpk', data)
                                    .attr('data-action', 'delete')
                                    .attr('type', 'button')
                                    .html('<i class="fa fa-times"></i><%= Master.Translate("elimina") %>');
                                return $('<div />').append(btn).html();
                            }
                        }
                    ]
                });

        //Click sui bottoni della tabella
        $("#utenti tbody").on('click', 'button', function (e) {
            e.preventDefault();
            $this = $(this);
            // Modifica tabella
            if ($this.is('[data-toggle="modal"]')) {
                e.preventDefault();
                $('#pk').val($this.attr('data-rowpk'));
                // Delete record
            } else if ($this.is('[data-action="delete"]')) {
                bootbox.confirm("<%= Master.Translate("L'utente verrà eliminato definitivamente. Ser sicuro di voler continuare") %>?", function (result) {
                    if (result) {
                        $('#utenti').spin();
                        $.ajax({
                            type: "POST",
                            url: "Ajax/Delete.ashx",
                            data: {
                                table: "ANA_USR",
                                pk: $this.attr('data-rowpk')
                            },
                            dataType: "json"
                        })
                            .done(function (data) {
                                if (data.success) {
                                    $tableUtenti.ajax.reload();
                                } else {
                                    bootbox.alert('<%= Master.Translate("Si è verificato un errore") %>: ' + data.msg);
                            }
                        })
                            .fail(function (jqxhr, textStatus, error) {
                                bootbox.alert('<%= Master.Translate("Si è verificato un errore") %>: ' + textStatus + "," + error);
                        })
                            .always(function () {
                                $('#utenti').spin(false);
                            });
                    }
                })
            }

        })

        // Prima di aprire la finestra di editing record
        $("#modal-edit-user").on('show.bs.modal', function (e) {
            var $modal = $(this);
            var $sender = $(e.relatedTarget);
            // L'evento arriva dal bottone inserisci nuovo record
            var pk = $sender.attr('data-rowpk');
            if (pk)
                $('#pk').val(pk);
            $('#Email').val('');
            $('#Name').val('');

            // Modal in attesa
            // Se insert rendo visibile la checkbox manda mail
            if ($('#pk').val() == 0) {
                $('#fg-sendmail').show().find(':checkbox').removeAttr('checked');
                $modal.find('.modal-title').text('<%= Master.Translate("Inserisci nuovo utente") %>');
            }
            // Altrimenti la nascondo
            else {
                $('#fg-sendmail').hide().find(':checkbox').removeAttr('checked');
                $modal.find('.modal-title').text('<%= Master.Translate("Modifica utente") %>');
            }
            $modal.find('.alert').hide();
        });

        // Dopo che la modal è stata mostrata
        $("#modal-edit-user").on('shown.bs.modal', function (e) {
            var $modal = $(this);
            $modal.find('.modal-dialog').spin();
            if ($('#pk').val() == 0) {

                //Imposto selezione prerogative e carico dati

                // Inserimento nuovo record: campi vuoti e pregoative a Ospite
                $('#Level').select2(
                    {
                        ajax: {
                            url: 'Ajax/liste.ashx?idField=PREROGATIVE',
                            results: function (data) {
                                return { results: data };
                            }
                        },
                        initSelection: function (element, callback) {
                            callback({ id: 0, text: 'Guest' });
                        }
                    });
                $modal.find('.modal-dialog').spin(false);

            } else {
                // Modifica record: carico i dati
                $.getJSON('Ajax/GetRecord.ashx', { pk: $('#pk').val(), table: "ANA_USR" })
                    .fail(function (jqxhr, textStatus, error) {
                        $('.alert', $modal)
                            .text('e<%= Master.Translate("Si è verificato un errore") %>: ' + textStatus + "," + error)
                            .removeClass('alert-success')
                            .addClass('alert-danger')
                            .show();
                    })
                    .done(function (data) {
                        if (data.success) {
                            var record = data.data;
                            $('#Email').val(record.Email);
                            $('#Name').val(record.Name);
                            $('#Level').select2({
                                ajax: {
                                    url: 'Ajax/liste.ashx?idField=PREROGATIVE',
                                    results: function (data) {
                                        return { results: data };
                                    }
                                },
                                initSelection: function (element, callback) {
                                    callback({ id: record.Level, text: record.LevelDescription });
                                }
                            });
                        } else {
                            $('.alert', $modal)
                                .text(data.msg)
                                .removeClass('alert-success')
                                .addClass('alert-danger')
                                .show();
                        }
                    })
                    .always(function () {
                        $modal.find('.modal-dialog').spin(false);
                    })
            }

            // Dopo l'infio dello pseudoform
            $('[data-action="submit"]').on('submitted.mb.form', function (e, data) {
                $tableUtenti.ajax.reload();
                if ($('#pk').val() == 0 && data.success)
                    $("#modal-edit-user").modal('hide');
            })
        })

        $('[data-action="download-csv"]').on('click', function () {
            var settings = {
                "url": "/api/UserCsvAsync",
                "method": "GET",
                "timeout": 0,
                "headers": {
                    "Authorization": "Bearer " + Cookies.get("MB_AuthToken")
                },
            };
            location.href = "/api/UserCsvAsync/?k=" + Cookies.get("MB_AuthToken");

            //$.ajax(settings).done(function (response) {
            //    console.log(response);
            //});
        })

    </script>
</asp:Content>
