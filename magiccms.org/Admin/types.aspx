<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/MasterAdmin.master" AutoEventWireup="true"
    CodeBehind="types.aspx.cs" Inherits="MagicCMS.Admin.types" Culture="it-IT" UICulture="it" %>
<%@ MasterType TypeName="MagicCMS.Admin.MasterAdmin" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="HeaderContent" runat="server">
    <h1><i class="fa fa-gears"></i>Configurazione dei tipi di Container e Content</h1>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
    <div class="row">
        <div class="col-md-12">
            <div class="box box-primary">
                <div class="box-header">
                    <h3 class="box-title">Elenco configurazioni</h3>
                    <div class="box-tools pull-right">
                        <button type="button" data-action="new" data-rowpk="0" class="btn btn-sm btn-success btn-icon"
                            title="Nuova configurazione">
                            <i class="fa fa-file-o"></i>
                        </button>
                        <button type="button" data-action="show-deleted" data-rowpk="0" class="btn btn-sm btn-primary btn-icon"
                            title="Apri o chiudi il cestino">
                            <i class="fa fa-trash-o"></i>
                        </button>
                        <button type="button" class="btn btn-primary btn-sm" data-widget="collapse">
                            <i class="fa fa-minus"></i>
                        </button>
                    </div>
                </div>
                <div class="box-body">
                    <div class="table-responsive">
                        <table id="tipi" class="table table-striped table-bordered" cellspacing="0" width="100%">
                            <thead>
                                <tr>
                                    <th>Id</th>
                                    <th>Nome</th>
                                    <th title="Contenitore"><i class="fa fa-folder-open"></i></th>
                                    <th title="Attivo"><i class="fa fa-thumbs-o-up"></i></th>
                                    <th title="Testo lungo"><i class="fa fa-file-text"></i></th>
                                    <th title="Testo breve"><i class="fa fa-file-text-o"></i></th>
                                    <th title="Url principale"><i class="fa fa-image"></i></th>
                                    <th title="Url secondaria"><i class="fa fa-link"></i></th>
                                    <th title="Tags"><i class="fa fa-tags"></i></th>
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
            <div class="box box-primary" id="edit-record">
                <div class="box-header">
                    <h3 class="box-title">Nuova configurazione</h3>
                    <div class="box-tools pull-right">
                        <button type="button" data-action="new" data-rowpk="0" class="btn btn-sm btn-success">
                            <i class="fa fa-file-o"></i>nuova configuazione</button>
                        <button type="button" class="btn btn-primary btn-sm" data-widget="collapse">
                            <i class="fa fa-minus"></i>
                        </button>
                    </div>
                </div>
                <div class="box-body">
                    <div class="form-horizontal" role="form" data-ride="mb-form" data-action="Ajax/Edit.ashx"
                        id="edit-type">
                        <fieldset>
                            <input type="hidden" id="Pk" name="Pk" value="0" />
                            <input type="hidden" id="table" name="table" value="ANA_CONT_TYPE" />
                            <div class="form-group" id="fg-item">
                                <label for="Nome" class="col-sm-2 control-label">Nome</label>
                                <div class="col-sm-4">
                                    <input type="text" class="form-control" id="Nome" />
                                </div>
                                <div class="col-sm-4">
                                    <input type="hidden" class="form-control" id="MasterPageFile" />
                                </div>
                                <div class="col-sm-2">
                                    <input type="hidden" id="Icon" class="form-control" />
                                </div>
                            </div>
                            <div class="form-group" id="fg-descrizione">
                                <label for="Help" class="col-sm-2 control-label">Help</label>
                                <div class="col-sm-10">
                                    <textarea class="form-control ckeditor_mcms" id="Help" rows="8"></textarea>
                                </div>
                            </div>
                            <div class="form-group" id="fg-preferiti">
                                <label for="ContenutiPreferiti" class="col-sm-2 control-label">Preferiti</label>
                                <div class="col-sm-10">
                                    <div class="input-group">
                                        <input type="text" class="form-control" id="ContenutiPreferiti" placeholder="Inserire id separati da virgola"
                                            title="Tipologie di oggetti MagicPost che possono essere inserite nel contenitore." />

                                        <span class="input-group-btn">
                                            <button type="button" data-target="#checkboxed-types-modal" data-toggle="modal" title="Componi lista tipi"
                                                class="btn btn-flat btn-icon btn-primary" data-selector="#ContenutiPreferiti">
                                                <i class="fa fa-search"></i>
                                            </button>
                                        </span>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group" id="fg-flags">
                                <label for="PercNazCorrette" class="col-sm-2 control-label">flags</label>
                                <div class="col-sm-10">
                                    <div class="row">
                                        <div class="col-sm-3">
                                            <label title="Se non attivo viene nascosto nel menù crea configurazione">
                                                <input type="checkbox" value="true" class="minimal" id="FlagAttivo" />
                                                Attivo
                                            </label>
                                        </div>
                                        <div class="col-sm-3">
                                            <label title="Contenitore">
                                                <input type="checkbox" value="true" class="minimal" id="FlagContenitore" />
                                                Container
                                            </label>
                                        </div>
                                        <div class="col-sm-3">
                                            <label title="Bottone cerca sul server...">
                                                <input type="checkbox" value="true" class="minimal" id="FlagCercaServer" />
                                                Server
                                            </label>
                                        </div>
                                        <div class="col-sm-3">
                                            <label title="Bottone per il calcolo della geolocazione">
                                                <input type="checkbox" value="true" class="minimal" id="FlagBtnGeolog" name="FlagBtnGeolog" />
                                                Geolocazione
                                            </label>
                                        </div>
                                        <div class="col-sm-3">
                                            <label title="Il contenuto è associabile a tag">
                                                <input type="checkbox" value="true" class="minimal" id="FlagTags" />
                                                Tags
                                            </label>
                                        </div>
                                        <div class="col-sm-3">
                                            <label title="Visualizza i campi altezza e larghezza">
                                                <input type="checkbox" value="true" class="minimal" id="FlagDimensioni" />
                                                Dimensioni
                                            </label>
                                        </div>
                                        <div class="col-sm-3">
                                            <label title="Contrassegna il tipo come 'speciale'">
                                                <input type="checkbox" value="true" class="minimal" id="FlagAutoTestoBreve" />
                                                Auto testo breve
                                            </label>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <h4 class="box-header">Etichette da associare ai campi</h4>
                            <div class="form-group" id="fg-testo-breve">
                                <label for="LabelTitolo" class="col-sm-2 control-label">Titolo</label>
                                <div class="col-sm-10">
                                    <input type="text" class="form-control" id="LabelTitolo" title="Etichetta da associare al campo titolo." />
                                </div>
                            </div>
                            <div class="form-group" id="fg-LabelTestoBreve">
                                <label for="LabelTestoBreve" class="col-sm-2 control-label">Testo breve</label>
                                <div class="col-sm-8">
                                    <input type="text" class="form-control" id="LabelTestoBreve" title="Etichetta da associare al campo testo breve." />
                                </div>
                                <div class="col-sm-2">
                                    <label title="Visualizza il campo testo breve.">
                                        <input type="checkbox" value="true" class="minimal" id="FlagBreve" />
                                        Attivo
                                    </label>
                                </div>
                            </div>
                            <div class="form-group" id="fg-LabelTestoLungo">
                                <label for="LabelTestoLungo" class="col-sm-2 control-label">Testo lungo</label>
                                <div class="col-sm-8">
                                    <input type="text" class="form-control" id="LabelTestoLungo" title="Etichetta da associare al campo testo lungo." />
                                </div>
                                <div class="col-sm-2">
                                    <label title="Visualizza il campo testo lungo.">
                                        <input type="checkbox" value="true" class="minimal" id="FlagFull" />
                                        Attivo
                                    </label>
                                </div>
                            </div>
                            <div class="form-group" id="fg-LabelUrl">
                                <label for="LabelUrl" class="col-sm-2 control-label">Url principale</label>
                                <div class="col-sm-8">
                                    <input type="text" class="form-control" id="LabelUrl" title="Etichetta da associare al campo url principale." />
                                </div>
                                <div class="col-sm-2">
                                    <label title="Visualizza il campo url principale.">
                                        <input type="checkbox" value="true" class="minimal" id="FlagUrl" />
                                        Attivo
                                    </label>
                                </div>
                            </div>
                            <div class="form-group" id="fg-LabelUrlSecondaria">
                                <label for="LabelUrlSecondaria" class="col-sm-2 control-label">Url secondaria</label>
                                <div class="col-sm-8">
                                    <input type="text" class="form-control" id="LabelUrlSecondaria" title="Etichetta da associare al campo url secondaria." />
                                </div>
                                <div class="col-sm-2">
                                    <label title="Visualizza il campo url principale.">
                                        <input type="checkbox" value="true" class="minimal" id="FlagUrlSecondaria" />
                                        Attivo
                                    </label>
                                </div>
                            </div>
                            <div class="form-group" id="fg-LabelAltezza">
                                <label for="LabelAltezza" class="col-sm-2 control-label">Altezza</label>
                                <div class="col-sm-8">
                                    <input type="text" class="form-control" id="LabelAltezza" title="Etichetta da associare al campo Altezza." />
                                </div>
                                <div class="col-sm-2">
                                    <label title="Visualizza il campo Altezza.">
                                        <input type="checkbox" value="true" class="minimal" id="FlagAltezza" />
                                        Attivo
                                    </label>
                                </div>
                            </div>
                            <div class="form-group" id="fg-LabelLarghezza">
                                <label for="LabelLarghezza" class="col-sm-2 control-label">Larghezza</label>
                                <div class="col-sm-8">
                                    <input type="text" class="form-control" id="LabelLarghezza" title="Etichetta da associare al campo Larghezza." />
                                </div>
                                <div class="col-sm-2">
                                    <label title="Visualizza il campo Larghezza.">
                                        <input type="checkbox" value="true" class="minimal" id="FlagLarghezza" />
                                        Attivo
                                    </label>
                                </div>
                            </div>
                            <div class="form-group" id="fg-LabelExtraInfo">
                                <label for="LabelExtraInfo" class="col-sm-2 control-label">Extra Info 0</label>
                                <div class="col-sm-8">
                                    <input type="text" class="form-control" id="LabelExtraInfo" title="Etichetta da associare al campo ExtraInfo 0." />
                                </div>
                                <div class="col-sm-2">
                                    <label title="Visualizza il campo Extra Info 0.">
                                        <input type="checkbox" value="true" class="minimal" id="FlagExtraInfo" />
                                        Attivo
                                    </label>
                                </div>
                            </div>
                            <div class="form-group" id="fg-LabelExtraInfo1">
                                <label for="LabelExtraInfo1" class="col-sm-2 control-label">Extra Info 1</label>
                                <div class="col-sm-8">
                                    <input type="text" class="form-control" id="LabelExtraInfo1" title="Etichetta da associare al campo ExtraInfo 1." />
                                </div>
                                <div class="col-sm-2">
                                    <label title="Visualizza il campo Extra Info 1.">
                                        <input type="checkbox" value="true" class="minimal" id="FlagExtrInfo1" />
                                        Attivo
                                    </label>
                                </div>
                            </div>
                            <div class="form-group" id="fg-LabelScadenza">
                                <label for="LabelScadenza" class="col-sm-2 control-label">Scadenza</label>
                                <div class="col-sm-8">
                                    <input type="text" class="form-control" id="LabelScadenza" title="Etichetta da associare al campo scadenza."
                                        placeholder="Lasciare vuoto per nascondere il campo" />
                                </div>
                                <div class="col-sm-2">
                                    <label title="Visualizza il campo Scadenza.">
                                        <input type="checkbox" value="true" class="minimal" id="FlagScadenza" />
                                        Attivo
                                    </label>
                                </div>
                            </div>
                            <div class="form-group" id="fg-LabelExtraInfo2">
                                <label for="LabelExtraInfo2" class="col-sm-2 control-label">Extra Info 2</label>
                                <div class="col-sm-10">
                                    <input type="text" class="form-control" id="LabelExtraInfo2" title="Etichetta da associare al campo ExtraInfo 2."
                                        placeholder="Lasciare vuoto per nascondere il campo" />
                                </div>
                            </div>
                            <div class="form-group" id="fg-LabelExtraInfo3">
                                <label for="LabelExtraInfo3" class="col-sm-2 control-label">Extra Info 3</label>
                                <div class="col-sm-10">
                                    <input type="text" class="form-control" id="LabelExtraInfo3" title="Etichetta da associare al campo ExtraInfo 3."
                                        placeholder="Lasciare vuoto per nascondere il campo" />
                                </div>
                            </div>
                            <div class="form-group" id="fg-LabelExtraInfo4">
                                <label for="LabelExtraInfo4" class="col-sm-2 control-label">Extra Info 4</label>
                                <div class="col-sm-10">
                                    <input type="text" class="form-control" id="LabelExtraInfo4" title="Etichetta da associare al campo ExtraInfo 4."
                                        placeholder="Lasciare vuoto per nascondere il campo" />
                                </div>
                            </div>
                            <div class="form-group" id="fg-LabelExtraInfo_5">
                                <label for="LabelExtraInfo_5" class="col-sm-2 control-label">Extra Info 5</label>
                                <div class="col-sm-10">
                                    <input type="text" class="form-control" id="LabelExtraInfo_5" placeholder="Lasciare vuoto per nascondere il campo"
                                        title="Etichetta da associare al campo ExtraInfo 5." />
                                </div>
                            </div>
                            <div class="form-group" id="fg-LabelExtraInfo_6">
                                <label for="LabelExtraInfo_6" class="col-sm-2 control-label">Extra Info 6</label>
                                <div class="col-sm-10">
                                    <input type="text" class="form-control" id="LabelExtraInfo_6" placeholder="Lasciare vuoto per nascondere il campo"
                                        title="Etichetta da associare al campo ExtraInfo 6." />
                                </div>
                            </div>
                            <div class="form-group" id="fg-LabelExtraInfo_7">
                                <label for="LabelExtraInfo_7" class="col-sm-2 control-label">Extra Info 7</label>
                                <div class="col-sm-10">
                                    <input type="text" class="form-control" id="LabelExtraInfo_7" placeholder="Lasciare vuoto per nascondere il campo"
                                        title="Etichetta da associare al campo ExtraInfo 7." />
                                </div>
                            </div>
                            <div class="form-group" id="fg-LabelExtraInfo_8">
                                <label for="LabelExtraInfo_8" class="col-sm-2 control-label">Extra Info 8</label>
                                <div class="col-sm-10">
                                    <input type="text" class="form-control" id="LabelExtraInfo_8" placeholder="Lasciare vuoto per nascondere il campo"
                                        title="Etichetta da associare al campo ExtraInfo 8." />
                                </div>
                            </div>
                            <div class="form-group" id="fg-LabelExtraInfoNumber_1">
                                <label for="LabelExtraInfoNumber_1" class="col-sm-2 control-label">Campo Numerico 1</label>
                                <div class="col-sm-10">
                                    <input type="text" class="form-control" id="LabelExtraInfoNumber_1" placeholder="Lasciare vuoto per nascondere il campo"
                                        title="Etichetta da associare al campo Numerico 1." />
                                </div>
                            </div>
                            <div class="form-group" id="fg-LabelExtraInfoNumber_2">
                                <label for="LabelExtraInfoNumber_2" class="col-sm-2 control-label">Campo Numerico 2</label>
                                <div class="col-sm-10">
                                    <input type="text" class="form-control" id="LabelExtraInfoNumber_2" placeholder="Lasciare vuoto per nascondere il campo"
                                        title="Etichetta da associare al campo Numerico 2." />
                                </div>
                            </div>
                            <div class="form-group" id="fg-LabelExtraInfoNumber_3">
                                <label for="LabelExtraInfoNumber_3" class="col-sm-2 control-label">Campo Numerico 3</label>
                                <div class="col-sm-10">
                                    <input type="text" class="form-control" id="LabelExtraInfoNumber_3" placeholder="Lasciare vuoto per nascondere il campo"
                                        title="Etichetta da associare al campo Numerico 3." />
                                </div>
                            </div>
                            <div class="form-group" id="fg-LabelExtraInfoNumber_4">
                                <label for="LabelExtraInfoNumber_4" class="col-sm-2 control-label">Campo Numerico 4</label>
                                <div class="col-sm-10">
                                    <input type="text" class="form-control" id="LabelExtraInfoNumber_4" placeholder="Lasciare vuoto per nascondere il campo"
                                        title="Etichetta da associare al campo Numerico 4." />
                                </div>
                            </div>
                            <div class="form-group" id="fg-LabelExtraInfoNumber_5">
                                <label for="LabelExtraInfoNumber_5" class="col-sm-2 control-label">
                                    Campo Numerico 5
                                </label>
                                <div class="col-sm-10">
                                    <input type="text" class="form-control" id="LabelExtraInfoNumber_5" placeholder="Lasciare vuoto per nascondere il campo"
                                        title="Etichetta da associare al campo Numerico 5." />
                                </div>
                            </div>
                            <div class="form-group" id="fg-LabelExtraInfoNumber_6">
                                <label for="LabelExtraInfoNumber_6" class="col-sm-2 control-label">
                                    Campo Numerico 6
                                </label>
                                <div class="col-sm-10">
                                    <input type="text" class="form-control" id="LabelExtraInfoNumber_6" placeholder="Lasciare vuoto per nascondere il campo"
                                        title="Etichetta da associare al campo Numerico 6." />
                                </div>
                            </div>
                            <div class="form-group" id="fg-LabelExtraInfoNumber_7">
                                <label for="LabelExtraInfoNumber_7" class="col-sm-2 control-label">
                                    Campo Numerico 7
                                </label>
                                <div class="col-sm-10">
                                    <input type="text" class="form-control" id="LabelExtraInfoNumber_7" placeholder="Lasciare vuoto per nascondere il campo"
                                        title="Etichetta da associare al campo Numerico 7." />
                                </div>
                            </div>
                            <div class="form-group" id="fg-LabelExtraInfoNumber_8">
                                <label for="LabelExtraInfoNumber_8" class="col-sm-2 control-label">
                                    Campo Numerico 8
                                </label>
                                <div class="col-sm-10">
                                    <input type="text" class="form-control" id="LabelExtraInfoNumber_8" placeholder="Lasciare vuoto per nascondere il campo"
                                        title="Etichetta da associare al campo Numerico 8." />
                                </div>
                            </div>
                            <div class="form-group">
                                <div class="col-xs-12">
                                    <div class="center-block text-center">
                                        <button type="button" class="btn btn-primary" data-action="submit">
                                            Salva modifiche</button>
                                        <%-- <button type="button" class="btn btn-danger btn-sm" data-dismiss="record">Elimina</button>--%>
                                    </div>
                                </div>
                            </div>
                            <%-- <div class="alert"></div>--%>
                        </fieldset>
                    </div>
                </div>
            </div>

        </div>
    </div>
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="Scripts" runat="server">
    <script>
        // Thi flag is set to true everytime a change is made and is set to false everytime the record is saved.
        //var _someChange = false;
        var someChange = function () {
            //if (arguments.length == 0)
            //    return _someChange;
            var value = arguments[0];
            //_someChange = value;
            if (value) {
                $('#edit-record')
                    .removeClass('box-primary')
                    .addClass('box-danger');
            }
            else
                $('#edit-record')
                    .addClass('box-primary')
                    .removeClass('box-danger');
            return value;
        };
        $(function () {
            /**
            *************************    DATA TABLE #tipi    **********************************************
            **/

            // Table init
            var $tableTipi =
                $('#tipi')
                    .on('xhr.dt', function (e, settings, json) {
                        var xhr = settings.jqXHR;
                        if (xhr.status == 403) {
                            bootbox.alert('Sessione scaduta. È necessario ripetere il login.', function () {
                                window.location.href = "login.aspx";
                            });
                        }
                    })
                    .DataTable({
                        "serverSide": true,
                        "stateSave": true,
                        "ajax": {
                            "url": "Ajax/TypesPaginated.ashx?basket=0",
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
                                "data": "Pk",
                                "name": "TYP_PK",
                                "width": "5%"
                            },
                            {
                                "targets": 1,
                                "data": "Nome",
                                "name": "TYP_NAME",
                                "width": "30%",
                                "render": function (data, type, full, meta) {
                                    return '<span><i class="fa ' + full.Icon + '"></i>' + data + '</span>';
                                }
                            },
                            {
                                "targets": 2,
                                "searchable": false,
                                "orderable": false,
                                "data": "FlagContenitore",
                                "width": "5%",
                                "className": "text-center",
                                "render": function (data, type, full, meta) {
                                    if (data)
                                        return '<i class="fa fa-check text-green"></i> ';
                                    else
                                        return '<i class="fa fa-times text-red"></i> ';
                                }
                            },
                            {
                                "targets": 3,
                                "searchable": false,
                                "orderable": false,
                                "data": "FlagAttivo",
                                "width": "5%",
                                "className": "text-center",
                                "render": function (data, type, full, meta) {
                                    if (data)
                                        return '<i class="fa fa-check text-green"></i> ';
                                    else
                                        return '<i class="fa fa-times text-red"></i> ';
                                }
                            },
                            {
                                "targets": 4,
                                "searchable": false,
                                "orderable": false,
                                "data": "FlagFull",
                                "width": "5%",
                                "className": "text-center",
                                "render": function (data, type, full, meta) {
                                    if (data)
                                        return '<i class="fa fa-check text-green"></i> ';
                                    else
                                        return '<i class="fa fa-times text-red"></i> ';
                                }
                            },
                            {
                                "targets": 5,
                                "searchable": false,
                                "orderable": false,
                                "data": "FlagBreve",
                                "width": "5%",
                                "className": "text-center",
                                "render": function (data, type, full, meta) {
                                    if (data)
                                        return '<i class="fa fa-check text-green"></i> ';
                                    else
                                        return '<i class="fa fa-times text-red"></i> ';
                                }
                            },
                            {
                                "targets": 6,
                                "searchable": false,
                                "orderable": false,
                                "data": "FlagUrl",
                                "width": "5%",
                                "className": "text-center",
                                "render": function (data, type, full, meta) {
                                    if (data)
                                        return '<i class="fa fa-check text-green"></i> ';
                                    else
                                        return '<i class="fa fa-times text-red"></i> ';
                                }
                            },
                            {
                                "targets": 7,
                                "searchable": false,
                                "orderable": false,
                                "data": "FlagUrlSecondaria",
                                "width": "5%",
                                "className": "text-center",
                                "render": function (data, type, full, meta) {
                                    if (data)
                                        return '<i class="fa fa-check text-green"></i> ';
                                    else
                                        return '<i class="fa fa-times text-red"></i> ';
                                }
                            },
                            {
                                "targets": 8,
                                "searchable": false,
                                "orderable": false,
                                "data": "FlagTags",
                                "width": "5%",
                                "className": "text-center",
                                "render": function (data, type, full, meta) {
                                    if (data)
                                        return '<i class="fa fa-check text-green"></i> ';
                                    else
                                        return '<i class="fa fa-times text-red"></i> ';
                                }
                            },
                            {
                                "targets": 9,
                                "data": "Pk",
                                "searchable": false,
                                "orderable": false,
                                "className": "text-center",
                                "render": function (data, type, full, meta) {
                                    var btn;
                                    if (full.FlagCancellazione)
                                        btn = $('<button />')
                                                .addClass('btn btn-success btn-xs')
                                                .attr('data-rowpk', data)
                                                .attr('data-action', 'undelete')
                                                .attr('type', 'button')
                                                .attr('title', 'recupera')
                                                .html('<i class="fa fa-external-link-square"></i><span class="hidden-sm hidden-xs">recupera</span>');
                                    else
                                        btn = $('<button />')
                                                .addClass('btn btn-primary btn-xs')
                                                .attr('data-rowpk', data)
                                                .attr('data-action', 'edit')
                                                .attr('type', 'button')
                                                .attr('title', 'modifica')
                                                .html('<i class="fa fa-edit"></i><span class="hidden-sm hidden-xs">modifica</span>');

                                    return $('<div />').append(btn).html();
                                }
                            },
                            {
                                "targets": 10,
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
                                        .attr('data-inbasket', full.FlagCancellazione);
                                    if (!full.FlagCancellazione)
                                        btn
                                        .attr('title', 'cestino')
                                        .html('<i class="fa fa-trash"></i><span class="hidden-sm hidden-xs">cestino</span>');
                                    else
                                        btn
                                        .attr('title', 'elimina')
                                        .html('<i class="fa fa-eraser"></i><span class="hidden-sm hidden-xs">elimina</span>');

                                    return $('<div />').append(btn).html();
                                }
                            }
                        ]
                    });


            // Table buttons
            $("#tipi tbody").on('click', 'button', function (e) {
                e.preventDefault();
                $this = $(this);
                var action = $this.attr('data-action');
                switch (action) {
                    case 'edit':
                        e.preventDefault();
                        if ($('#edit-type').mb_submit('pendingChanges')) {
                            bootbox.confirm('Le modifiche non salvate andranne perse. Vou continuare?', function (result) {
                                if (result)
                                    getRecord($this.attr('data-rowpk'));
                            })
                        }
                        else
                            getRecord($this.attr('data-rowpk'));
                        break;
                    case 'delete':
                        var inbasket = $this.attr('data-inbasket');
                        var msg;
                        if (inbasket == "true")
                            msg = 'La configurazione verrà eliminata definitivamente. Sei sicuro di voler continuare?';
                        else
                            msg = 'Stai spostando la configurazione nel cestino. Ser sicuro di voler continuare?';

                        bootbox.confirm(msg, function (result) {
                            if (result) {
                                $('#tipi').spin();
                                $.ajax({
                                    type: "POST",
                                    url: "Ajax/Delete.ashx",
                                    data: {
                                        table: "ANA_CONT_TYPE",
                                        pk: $this.attr('data-rowpk')
                                    },
                                    dataType: "json"
                                })
                                .done(function (data) {
                                    if (data.success) {
                                        $tableTipi.ajax.reload();
                                        $.growl({
                                            title: 'Info',
                                            message: data.msg,
                                            icon: "fa fa-info-circle"
                                        },
                                        {
                                            type: 'success'
                                        })
                                    } else {
                                        $.growl({
                                            title: 'Errore',
                                            message: data.msg,
                                            icon: "fa fa-warning"
                                        },
                                        {
                                            type: 'danger'
                                        })
                                    }
                                })
                                .fail(function (jqxhr, textStatus, error) {
                                    bootbox.alert('Si è verificaro un errore: ' + textStatus + "," + error);
                                })
                                .always(function () {
                                    $('#tipi').spin(false);
                                });
                            }
                        })
                        break;
                    case 'undelete':
                        $('#tipi').spin();
                        $.ajax({
                            type: "POST",
                            url: "Ajax/Delete.ashx",
                            data: {
                                table: "ANA_CONT_TYPE",
                                pk: $this.attr('data-rowpk'),
                                undelete: 1
                            },
                            dataType: "json"
                        })
                        .done(function (data) {
                            if (data.success) {
                                $tableTipi.ajax.reload();
                                $.growl({
                                    title: 'Info',
                                    message: data.msg,
                                    icon: "fa fa-info-circle"
                                },
                                {
                                    type: 'success'
                                })
                            } else {
                                $.growl({
                                    title: 'Errore',
                                    message: data.msg,
                                    icon: "fa fa-warning"
                                },
                                {
                                    type: 'danger'
                                })
                            }
                        })
                        .fail(function (jqxhr, textStatus, error) {
                            bootbox.alert('Si è verificaro un errore: ' + textStatus + "," + error);
                        })
                        .always(function () {
                            $('#tipi').spin(false);
                        }); break;
                    default:

                }

                // Edit record
                if ($this.is('[data-action="edit"]')) {
                    // Delete record
                } else if ($this.is('[data-action="delete"]')) {

                }

            });

            /*
            ************************* /DataTable Tipi end ********************************************/


            $('#Icon')
                .select2(
                {
                    ajax: {
                        url: 'Ajax/GetFaIconClasses.ashx',
                        dataType: 'json',
                        quietMillis: 200,
                        data: function (term, page) {
                            return { k: term };
                        },
                        results: function (data, page, query) {
                            return { results: data };
                        }
                    },
                    formatResult: function (state) {
                        return unescape(state.text) + " " + state.id;
                    },
                    formatSelection: function (state) {
                        return unescape(state.text) + " " + state.id;
                    },
                    initSelection: function (element, callbak) {
                        callbak({ id: element.val(), text: '<i class="fa ' + element.val() + '"></i>' });
                    },
                    placeholder: 'Icona',
                    allowClear: true
                });

            $('#MasterPageFile')
                .select2(
                {
                    ajax: {
                        url: 'Ajax/GetThemeMasters.ashx',
                        dataType: 'json',
                        quietMillis: 0,
                        results: function (data, page, query) {
                            return { results: data };
                        }
                    },
                    initSelection: function (element, callbak) {
                        callbak({ id: element.val(), text: element.val() });
                    },
                    placeholder: 'Scegli la master page',
                    allowClear: true
                });
            //$('#edit-record').on('change', 'input, textarea', function () {
            //    someChange(true);
            //});

            //$('#edit-record :checkbox').on('click', function () {
            //    someChange(true);
            //});

            $('#edit-type').on('changed.mb.form', function (e, pending) {
                someChange(pending);
            });

            // After update reloading of table data
            $('[data-action="submit"]').on('submitted.mb.form', function (e, data) {
                $tableTipi.ajax.reload(null, false);
                if (data.success) {
                    $.growl({
                        icon: 'fa fa-thumbs-o-up',
                        title: 'Info',
                        message: "Record salvato con successo"
                    },
                    {
                        type: 'success'
                    })
                    $('#edit-type').mb_submit('pendingChanges',false);
                } else {
                    $.growl({
                        icon: 'fa fa-warning',
                        title: 'Errore',
                        message: data.msg
                    },
                    {
                        type: 'danger'
                    });
                }
            })

            $('[data-action="new"]').on('click', function (e) {
                e.preventDefault();
                if ($('#edit-type').mb_submit('pendingChanges')) {
                    bootbox.confirm('Le modifiche non salvate andranne perse. Vou continuare?', function (result) {
                        if (result)
                            getRecord(0);
                    })
                }
                else
                    getRecord(0);

            })
            $('[data-action="show-deleted"').on('click', function () {
                var $this = $(this);
                var $icon = $this.children('i');
                var show = $icon.hasClass('fa-trash-o') ? 1 : 0;
                $icon.toggleClass('fa-trash-o fa-bars');
                $tableTipi.ajax.url("Ajax/TypesPaginated.ashx?basket=" + show).load();
            });

            //Pseudoform init
            var getRecord = function (pk) {
                var $form = $('#edit-type');
                $form.spin();
                $.getJSON('Ajax/GetRecord.ashx', { pk: pk, table: "ANA_CONT_TYPE" })
                    .fail(function (jqxhr, textStatus, error) {
                        $.growl({
                            icon: 'fa fa-warning',
                            title: 'Errore',
                            message: textStatus
                        },
                        {
                            type: 'danger'
                        })
                    })
                    .done(function (data) {
                        if (data.success) {
                            var record = data.data;
                            formFill(record);
                            $.growl({
                                icon: 'fa fa-thumbs-o-up',
                                title: '',
                                message: record.Nome + " è stoto caricato con successo"
                            },
                            {
                                type: 'success'
                            })
                            CKEDITOR.instances.Help.on('dataReady', function () {
                                $('#edit-type').mb_submit('pendingChanges', false);
                            });
                        } else {
                            $.growl({
                                icon: 'fa fa-warning',
                                title: 'Si è verificato un errore: ',
                                message: data.msg
                            },
                            {
                                type: 'danger'
                            })
                        }
                    })
                    .always(function () {
                        $form.spin(false);
                    })
            };

            var formFill = function (data) {
                $('#edit-record .box-title').text(data.Nome);
                for (var prop in data) {
                    var $field = $('#edit-record [name="' + prop + '"]');
                    if (!$field.length)
                        $field = $('#edit-record #' + prop);
                    if ($field.length) {
                        if ($field.is(':checkbox')) {
                            if (data[prop])
                                $field.iCheck('check');
                            else
                                $field.iCheck('uncheck');
                        } else if ($field.siblings('.select2-container').length) {
                            $field.select2('val', data[prop]);
                        } else {
                            $field.val(data[prop]);
                        }
                    }
                }
            };

            getRecord(0);
            $(window).on('beforeunload', function () {
                var ch = $('#edit-type').mb_submit('pendingChanges');
                if (ch)
                    return 'Attenzione sono state rilevate modifiche non salvate.';
            });
        })
    </script>
</asp:Content>
