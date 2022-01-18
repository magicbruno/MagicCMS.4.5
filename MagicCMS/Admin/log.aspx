<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/MasterAdmin.master" AutoEventWireup="true" CodeBehind="log.aspx.cs" Inherits="MagicCMS.Admin.log" %>

<%@ MasterType TypeName="MagicCMS.Admin.MasterAdmin" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="HeaderContent" runat="server">
    <h1><i class="fa fa-warning"></i><%= Master.Translate("Registro attività ed errori") %></h1>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
    <div class="row">
        <div class="col-md-12">
            <div class="box box-primary" data-ride="mb-panel">
                <div class="box-header row no-gutters">
                    <h3 class="box-title col-auto"><%= Master.Translate("Attività ed errori") %></h3>
                    <div class="box-tools ml-auto d-flex align-items-center">
                        <div class="switch switch-md">
                            <input type="checkbox" id="switchErrors" class="simple" />
                            <label for="switchErrors">Toggle</label>
                        </div>
                        <label class="h4 ml-2 mt-1" for="switchErrors">Solo errori</label>
                    </div>
                    <div class="box-tools">
                        <%--<a href="#modal-edit-user" data-toggle="modal" data-rowpk="0" class="btn btn-sm bg-olive">--%>
                        <%--<i class="fa fa-lo"></i>nuova attività<%= Master.Translate("Back") %></a>--%>

                        <button type="button" class="btn btn-primary btn-sm" data-widget="collapse">
                            <i class="fa fa-minus"></i>
                        </button>

                    </div>
                </div>
                <div class="box-body">
                    <table id="log" class="table table-striped table-bordered table-hover dataTable" style="width: 100%" width="100%">
                        <thead>
                            <tr>
                                <th><%= Master.Translate("Data e ora") %></th>
                                <th><%= Master.Translate("Utente") %></th>
                                <th><%= Master.Translate("Tabella dati") %></th>
                                <th><%= Master.Translate("Azione") %></th>
                                <th>Rec. n.</th>
                                <th><%= Master.Translate("Errore") %></th>
                                <th></th>
                            </tr>
                        </thead>

                        <tbody>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
    <div class="modal fade" id="modal-log-details" tabindex="-1" role="dialog" aria-labelledby="Modifica i dati di un utente"
        aria-hidden="true" data-backdrop="static">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">
                        <span aria-hidden="true">&times;</span><span
                            class="sr-only">Chiudi</span></button>
                    <h4 class="modal-title" id="myModalLabel"><%= Master.Translate("Dettagli attività") %></h4>
                </div>
                <div class="template d-none"></div>
                <div class="modal-body">
                    <div class="row">
                        <div class="col-sm-2 text-right">
                            <label><%= Master.Translate("Numero") %></label>
                        </div>
                        <div class="col-sm-10">
                            <span id="Pk">{{Pk}}</span>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-sm-2 text-right">
                            <label><%= Master.Translate("Data e ora") %></label>
                        </div>
                        <div class="col-sm-10">
                            <span id="Timestamp">{{Timestamp}}</span>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-sm-2 text-right">
                            <label><%= Master.Translate("Tabella") %></label>
                        </div>
                        <div class="col-sm-10">
                            <span id="Tabella">{{Tabella}}</span>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-sm-2 text-right">
                            <label><%= Master.Translate("Record") %></label>
                        </div>
                        <div class="col-sm-10">
                            <span id="RecordName">{{RecordName}}</span>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-sm-2 text-right">
                            <label><%= Master.Translate("Utente") %></label>
                        </div>
                        <div class="col-sm-10">
                            <span id="Useremail">{{Useremail}}</span>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-sm-2 text-right">
                            <label><%= Master.Translate("Errore") %></label>
                        </div>
                        <div class="col-sm-10">
                            <span id="Error">{{Error}}</span>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-sm-2 text-right">
                            <label><%= Master.Translate("Nome file") %></label>
                        </div>
                        <div class="col-sm-10">
                            <span id="FileName">{{{FileName}}}</span>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-sm-2 text-right">
                            <label><%= Master.Translate("Nome metodo") %></label>
                        </div>
                        <div class="col-sm-10 ">
                            <span id="MethodName">{{{MethodName}}}</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="Scripts" runat="server">
    <script id="table-logs-templ" type="x-tmpl-mustache">
        <button class="btn btn-primary btn-sm" type="button" data-toggle="modal" data-target="#modal-log-details" data-pk="{{Pk}}">
            <i class="fa fa-search mr-2"></i>Dettagli
        </button>
    </script>
    <script>
        $(function () {
            const $modalDetails = $('#modal-log-details');
            const $modalDetailsTemplate = $modalDetails.find('.template');
            const $modalDetailsBody = $modalDetails.find('.modal-body');

            $modalDetailsTemplate.html($modalDetailsBody.html());
            $modalDetailsBody.html('');
            $modalDetailsBody.css('min-height', '30vh');

            $modalDetails.on('shown.bs.modal', function (e) {
                var pk = $(e.relatedTarget).data('pk');
                $modalDetailsBody.spin();
                var settings = {
                    "url": "/api/LogPaginatedAsync/" + pk,
                    "method": "GET",
                    "timeout": 0,
                    "headers": {
                        "Authorization": "Bearer " + Cookies.get('MB_AuthToken')
                    },
                };
                $.ajax(settings).done(function (response) {
                    $modalDetailsBody.html(Mustache.render($modalDetailsTemplate.html(), response))
                });
            }).on('hidden.bs.modal', function () {
                $modalDetailsBody.html('');
            });
        });


        $(function () {
            var $tablog =
                $('#log')
                    .on('xhr.dt', function (e, settings, json) {
                        var xhr = settings.jqXHR;
                        if (xhr.status == 403) {

                            Swal.fire({
                                icon: 'error',
                                title: 'Errore',
                                text: '<%= Master.Translate("Sessione scaduta. È necessario ripetere il login") %>.'
                            }).then(() => {
                                window.location.href = "/Admin/Login.aspx";
                            });

                        }
                        else if (xhr.status != 200) {
                            Swal.fire({
                                icon: 'error',
                                title: 'Errore',
                                text: 'Si è verificaro un errore: ' + xhr.status + ", " + xhr.statusText
                            }).then(() => {
                                window.location.href = "/Admin/Login.aspx";
                            });
                        }
                        return true;
                    })
                    .DataTable({
                        "serverSide": true,
                        "order": [0, 'desc'],
                        "ajax": {
                            "url": "/api/LogPaginatedAsync/?onlyErrors=false",
                            "headers": {
                                "Content-Type": "application/x-www-form-urlencoded",
                                "Authorization": "Bearer " + Cookies.get('MB_AuthToken')
                            },
                            "dataSrc": function (json) {
                                if (json) return json.data;
                                return [];
                            },
                            "method": "POST"
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
                                "data": "Timestamp",
                                "name": "reg_PK",
                                "width": "auto",
                                "seachable": false,
                                "className": 'text-left text-nowrap',
                                "render": function (data, type, full, meta) {
                                    var date = new Date(parseInt(data.substr(6)));
                                    return new Date(data).toLocaleString();
                                }
                            },
                            {
                                "targets": 1,
                                "data": "Useremail",
                                "name": "usr_EMAIL",
                                //"orderable": false,
                                "width": "auto"
                            },
                            {
                                "targets": 2,
                                //"searchable": false,
                                //"orderable": false,
                                "data": "Tabella",
                                "name": "reg_TABELLA",
                                "width": "16%"
                            },
                            {
                                "targets": 3,
                                "searchable": false,
                                "orderable": false,
                                "data": "ActionString",
                                "width": "10%",
                                "className": "text-center"
                            },
                            {
                                "targets": 4,
                                "data": "Record",
                                "searchable": false,
                                "orderable": false,
                                "className": "text-center",
                                "width": "8%"

                            },
                            {
                                "targets": 5,
                                "data": "Error",
                                "name": "reg_ERROR",
                                "width": "80%",
                                "render": function (data, type, full, meta) {
                                    if (full.IsError)
                                        return Mustache.render('<span class="text-danger"><i class="fa  fa-exclamation-triangle"></i>{{Error}}</span>', full);
                                    return Mustache.render('<span class="text-success"><i class="fa fa-hand-o-right"></i>{{Error}}</span>', full);
                                }
                            },
                            {
                                "targets": 6,
                                "data": "Pk",
                                "name": "reg_Pk",
                                "render": function (data, type, full, meta) {
                                    return Mustache.render(document.getElementById('table-logs-templ').innerHTML, full);
                                }

                            }
                        ]
                    });
            $('#switchErrors').on('change', function () {
                $tablog.ajax.url('/api/LogPaginatedAsync/?onlyError=' + this.checked).load();
            });

        });


    </script>
</asp:Content>
