<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/MasterAdmin.master" AutoEventWireup="true" CodeBehind="Dictionary.aspx.cs" Inherits="MagicCMS.Admin.Dictionary" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="HeaderContent" runat="server">
    <h1><i class="fa fa-book"></i>Vocabolario</h1>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
    <div class="row">
        <div class="col-md-12">
            <div class="box box-primary" data-ride="mb-panel">
                <div class="box-header">
                    <h3 class="box-title">Termini e traduzioni</h3>
                    <div class="box-tools pull-right">
                        <a href="#modal-edit-term" data-toggle="modal" data-rowpk="0" class="btn btn-sm bg-olive">
                            <i class="fa fa-book"></i>nuovo termine</a>
                        <button type="button" class="btn btn-primary btn-sm" data-widget="collapse">
                            <i class="fa fa-minus"></i>
                        </button>
                    </div>
                </div>
                <div class="box-body">
                    <table id="table_dictionary" class="table table-striped table-bordered" cellspacing="0" width="100%">
                        <thead>
                            <tr>
                                <th>Termine</th>
                                <th>Lang</th>
                                <th>Traduzione</th>
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
    <div class="modal fade" id="modal-edit-term" tabindex="-1" role="dialog" aria-labelledby="Modifica "
        aria-hidden="true" data-backdrop="static">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">
                        <span aria-hidden="true">&times;</span><span
                            class="sr-only">Chiudi</span></button>
                    <h4 class="modal-title" id="myModalLabel">Modifica termine (o aggiungi traduzione)</h4>
                </div>
                <div class="modal-body">
                    <div class="form-horizontal" role="form" data-action="Ajax/Edit.ashx" data-ride="mb-form">
                        <input type="hidden" id="pk" value="0" />
                        <input type="hidden" id="table" value="ANA_Dictionary" />
                        <div class="form-group" id="fg-Source">
                            <label for="Source" class="col-sm-2 control-label">Termine o frase</label>
                            <div class="col-sm-10">
                                <input type="email" class="form-control" id="Source" placeholder="Termine o frase" />
                            </div>
                        </div>
                        <div class="form-group" id="fg-LangId">
                            <label for="LangId" class="col-sm-2 control-label">Id lingua</label>
                            <div class="col-sm-10">
                                <input id="LangId" class="form-control" type="hidden" />
                            </div>
                        </div>
                        <div class="form-group" id="fg-Translation">
                            <label for="Translation" class="col-sm-2 control-label">Traduzione</label>
                            <div class="col-sm-10">
                                <input type="text" class="form-control" id="Translation" placeholder="Traduzione" />
                            </div>
                        </div>
                        <div class="form-group">
                            <div class="col-sm-offset-2 col-sm-10">
                                <button type="button" class="btn btn-primary" data-action="submit">Salva</button>
                                <button type="button" class="btn btn-info" data-action="translate">Traduci con bing</button>
                                <button type="button" class="btn btn-danger" data-dismiss="modal">Chiudi</button>
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
        $('#LangId').select2(
            {
                data: []
            }
        );


        var $tabledictionary =
            $('#table_dictionary')
                .on('xhr.dt', function (e, settings, json) {
                    var xhr = settings.jqXHR;
                    if (xhr.status == 403) {
                        bootbox.alert('Sessione scaduta. È necessario ripetere il login.', function () {
                            window.location.href = "/login.aspx";
                        });
                    }
                    //else if (xhr.status != 200)
                    //    bootbox.alert('Si è verificaro un errore: ' + xhr.status + ", " + xhr.statusText);
                })
                .DataTable({
                    "serverSide": true,
                    "ajax": {
                        "url": "Ajax/TransDictionaryPaginated.ashx",
                        "type": "POST"
                    },
                    "language": {
                        "sEmptyTable": "Nessun dato presente nella tabella",
                        "sInfo": "Vista da _START_ a _END_ di _TOTAL_ elementi",
                        "sInfoEmpty": "Vista da 0 a 0 di 0 elementi",
                        "sInfoFiltered": "(filtrati da _MAX_ elementi totali)",
                        "sInfoPostFix": "",
                        "sInfoThousands": ",",
                        "sLengthMenu": "Visualizza _MENU_ elementi",
                        "sLoadingRecords": "Caricamento...",
                        "sProcessing": "Elaborazione...",
                        "sSearch": "Cerca:",
                        "sZeroRecords": "La ricerca non ha portato alcun risultato.",
                        "oPaginate": {
                            "sFirst": "Inizio",
                            "sPrevious": "Precedente",
                            "sNext": "Successivo",
                            "sLast": "Fine"
                        },
                        "oAria": {
                            "sSortAscending": ": attiva per ordinare la colonna in ordine crescente",
                            "sSortDescending": ": attiva per ordinare la colonna in ordine decrescente"
                        }
                    },
                    "columnDefs": [
                        {
                            "targets": 0,
                            "data": "Source",
                            "name": "DICT_Source",
                            "width": "25%"
                        },
                        {
                            "targets": 1,
                            "data": "LangId",
                            "name": "DICT_LANG_Id",
                            "width": "10%"
                        },
                        {
                            "targets": 2,
                            "data": "Translation",
                            "name": "DICT_Translation",
                            "width": "25%"
                        },
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
                                    .attr('data-target', '#modal-edit-term')
                                    .attr('type', 'button')
                                    .html('<i class="fa fa-edit"></i>modifica/aggiungi');
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
                                    .html('<i class="fa fa-times"></i>elimina');
                                return $('<div />').append(btn).html();
                            }
                        }
                    ]
                });

        //Click sui bottoni della tabella
        $("#table_dictionary tbody").on('click', 'button', function (e) {
            e.preventDefault();
            $this = $(this);
            // Modifica tabella
            if ($this.is('[data-toggle="modal"]')) {
                e.preventDefault();
                $('#pk').val($this.attr('data-rowpk'));
                // Delete record
            } else if ($this.is('[data-action="delete"]')) {
                bootbox.confirm('Il termine verrà eliminato definitivamente. Ser sicuro di voler continuare?', function (result) {
                    if (result) {
                        $('#table_dictionary').spin();
                        $.ajax({
                            type: "POST",
                            url: "Ajax/Delete.ashx",
                            data: {
                                table: "ANA_Dictionary",
                                pk: $this.attr('data-rowpk')
                            },
                            dataType: "json"
                        })
                        .done(function (data) {
                            if (data.success) {
                                $tabledictionary.ajax.reload(false, false);
                            } else {
                                bootbox.alert('Si è verificato un errore: ' + data.msg);
                            }
                        })
                        .fail(function (jqxhr, textStatus, error) {
                            bootbox.alert('Si è verificaro un errore: ' + textStatus + "," + error);
                        })
                        .always(function () {
                            $('#table_dictionary').spin(false);
                        });
                    }
                })
            }

        })

        // Prima di aprire la finestra di editing record
        $("#modal-edit-term").on('show.bs.modal', function (e) {
            var $modal = $(this);
            var $sender = $(e.relatedTarget);
            // L'evento arriva dal bottone inserisci nuovo record
            var pk = $sender.attr('data-rowpk');
            if (pk)
                $('#pk').val(pk);
            $('#Source').val('');
            $('#Translation').val('');

            $modal.find('.alert').hide();
        });

        // Dopo che la modal è stata mostrata
        $("#modal-edit-term").on('shown.bs.modal', function (e) {
            var $modal = $(this);
            $modal.find('.modal-dialog').spin();
            if ($('#pk').val() == 0) {

                //Imposto selezione linguaggio e carico dati

                // Inserimento nuovo record: campi vuoti e linguaggio
                $('#LangId').select2(
                    {
                        ajax: {
                            url: 'Ajax/liste.ashx?idField=ANA_LANGUAGE',
                            results: function (data) {
                                return { results: data };
                            }
                        },
                        initSelection: function (element, callback) {
                            callback({ id: 'en', text: 'en' });
                            $(element).val('en');
                        }
                    });
                $modal.find('.modal-dialog').spin(false);

            } else {
                // Modifica record: carico i dati
                $.getJSON('Ajax/GetRecord.ashx', { pk: $('#pk').val(), table: "ANA_Dictionary" })
                    .fail(function (jqxhr, textStatus, error) {
                        $('.alert', $modal)
                            .text('Si è verificaro un errore: ' + textStatus + "," + error)
                            .removeClass('alert-success')
                            .addClass('alert-danger')
                            .show();
                    })
                    .done(function (data) {
                        if (data.success) {
                            var record = data.data;
                            $('#Source').val(record.Source);
                            $('#Translation').val(record.Translation);
                            $('#LangId').select2({
                                ajax: {
                                    url: 'Ajax/liste.ashx?idField=ANA_LANGUAGE',
                                    results: function (data) {
                                        return { results: data };
                                    }
                                },
                                initSelection: function (element, callback) {
                                    $(element).val(record.LangId);
                                    callback({ id: record.LangId, text: record.LangId });
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
                $tabledictionary.ajax.reload(null, false);
                if ($('#pk').val() == 0 && data.success)
                    $("#modal-edit-term").modal('hide');
            })

            $('[data-action="translate"]').on('click', function (e) {
                e.preventDefault();
                var $me = $(this);
                var $form = $me.parents('[role="form"]');
                var $alert = $form.find('.alert');
                var langid = $('#LangId').val();
                var source = $("#Source").val();
                var params = {
                    LangId: langid,
                    term: source
                };
                $form.spin();
                $alert.hide();
                $.ajax('Ajax/BingTranslation.ashx',
                    {
                        data: params,
                        dataType: 'json',
                        type: 'POST'
                    })
                    .done(function (data) {
                        if (data.success) {
                            $alert
                                .text(data.msg)
                                .removeClass('alert-danger')
                                .addClass('alert-success')
                                .show();
                            $('#Translation').val(data.data);
                        } else {
                            $('.alert', $modal)
                                .text(data.msg)
                                .removeClass('alert-success')
                                .addClass('alert-danger')
                                .show();
                        }
                    })
                    .fail(function (jqxhr, textStatus, error) {
                        $('.alert', $modal)
                            .text(textStatus)
                            .removeClass('alert-success')
                            .addClass('alert-danger')
                            .show();
                    })
                    .always(function () {
                        $form.spin(false);
                    });

            });
        })

    </script>
</asp:Content>
