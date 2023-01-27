<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/MasterAdmin.master" AutoEventWireup="true"
    CodeBehind="types.aspx.cs" Inherits="MagicCMS.Admin.types" Culture="it-IT" UICulture="it" %>
<%@ MasterType TypeName="MagicCMS.Admin.MasterAdmin" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="HeaderContent" runat="server">
    <h1><i class="fa fa-gears"></i><%= Master.Translate("Definizione oggetti Web") %></h1>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
    <div class="row">
        <div class="col-md-12">
            <div class="box box-primary">
                <div class="box-header">
                    <h3 class="box-title"><%= Master.Translate("Elenco configurazioni") %></h3>
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
                        <table id="tipi" class="table table-striped table-bordered" style="width:100%" width="100%">
                            <thead>
                                <tr>
                                    <th>Id</th>
                                    <th><%= Master.Translate("Nome") %></th>
                                    <th title="<%= Master.Translate("Contenitore") %>"><i class="fa fa-folder-open"></i></th>
                                    <th title="<%= Master.Translate("Attivo") %>"><i class="fa fa-thumbs-o-up"></i></th>
                                    <th title="<%= Master.Translate("Testo completo") %>"><i class="fa fa-file-text"></i></th>
                                    <th title="<%= Master.Translate("Descrizione breve") %>"><i class="fa fa-file-text-o"></i></th>
                                    <th title="<%= Master.Translate("Url principale") %>"><i class="fa fa-image"></i></th>
                                    <th title="<%= Master.Translate("Url secondaria") %>"><i class="fa fa-link"></i></th>
                                    <th title="<%= Master.Translate("Parole chiave") %>"><i class="fa fa-tags"></i></th>
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
                    <h3 class="box-title"><%= Master.Translate("Nuova configurazione") %></h3>
                    <div class="box-tools pull-right">
                        <button type="button" data-action="new" data-rowpk="0" class="btn btn-sm btn-success">
                            <i class="fa fa-file-o"></i><%= Master.Translate("Nuova configuazione") %></button>
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
                                <label for="Nome" class="col-sm-2 control-label"><%= Master.Translate("Nome") %></label>
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
                                <label for="Help" class="col-sm-2 control-label"><%= Master.Translate("Help") %></label>
                                <div class="col-sm-10">
                                    <textarea class="form-control ckeditor_mcms" id="Help" rows="8"></textarea>
                                </div>
                            </div>
                            <div class="form-group" id="fg-preferiti">
                                <label for="ContenutiPreferiti" class="col-sm-2 control-label"><%= Master.Translate("Preferiti") %></label>
                                <div class="col-sm-10">
                                    <div class="input-group">
                                        <input type="text" class="form-control" id="ContenutiPreferiti" placeholder="<%= Master.Translate("Inserire id separati da virgola") %>"
                                            title="<%= Master.Translate("Tipologie di oggetti MagicPost che possono essere inserite nel contenitore") %>." />

                                        <span class="input-group-btn">
                                            <button type="button" data-target="#checkboxed-types-modal" data-toggle="modal" title="<%= Master.Translate("Componi lista tipi") %>"
                                                class="btn btn-flat btn-icon btn-primary" data-selector="#ContenutiPreferiti">
                                                <i class="fa fa-search"></i>
                                            </button>
                                        </span>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group" id="fg-flags">
                                <label for="PercNazCorrette" class="col-sm-2 control-label"><%= Master.Translate("Flags") %></label>
                                <div class="col-sm-10">
                                    <div class="row">
                                        <div class="col-sm-3">
                                            <label title="<%= Master.Translate("Se la configurazione non è attiva il tipo di oggetto viene nascosto") %>">
                                                <input type="checkbox" value="true" class="minimal" id="FlagAttivo" />
                                                <%= Master.Translate("Attivo") %>
                                            </label>
                                        </div>
                                        <div class="col-sm-3">
                                            <label title="<%= Master.Translate("Può contenere elementi figli") %>">
                                                <input type="checkbox" value="true" class="minimal" id="FlagContenitore" />
                                                <%= Master.Translate("Contenitore") %>
                                            </label>
                                        </div>
                                        <div class="col-sm-3">
                                            <label title="<%= Master.Translate("Bottone 'cerca sul server'") %>...">
                                                <input type="checkbox" value="true" class="minimal" id="FlagCercaServer" />
                                                <%= Master.Translate("Server") %>
                                            </label>
                                        </div>
                                        <div class="col-sm-3">
                                            <label title="<%= Master.Translate("Bottone che apre la dialog box per il calcolo della geolocazione") %>">
                                                <input type="checkbox" value="true" class="minimal" id="FlagBtnGeolog" name="FlagBtnGeolog" />
                                                <%= Master.Translate("Geolocazione") %>
                                            </label>
                                        </div>
                                        <div class="col-sm-3">
                                            <label title="<%= Master.Translate("Viene visualizzato il campo parole chiave") %>">
                                                <input type="checkbox" value="true" class="minimal" id="FlagTags" />
                                                <%= Master.Translate("Parole chiave") %>
                                            </label>
                                        </div>
                                        <div class="col-sm-3">
                                            <label title="<%= Master.Translate("Vengono visualizzati i campi altezza e larghezza") %>">
                                                <input type="checkbox" value="true" class="minimal" id="FlagDimensioni" />
                                                <%= Master.Translate("Dimensioni") %>
                                            </label>
                                        </div>
                                        <div class="col-sm-3">
                                            <label title="<%= Master.Translate("Il campo descrizione viene ricavato automaticamente dal campo testo completo") %>">
                                                <input type="checkbox" value="true" class="minimal" id="FlagAutoTestoBreve" />
                                                <%= Master.Translate("Crea descrizione") %>
                                            </label>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <h4 class="box-header"><%= Master.Translate("Etichette che verranno associate ai campi") %></h4>
                            <div class="form-group" id="fg-testo-breve">
                                <label for="LabelTitolo" class="col-sm-2 control-label">Titolo<%= Master.Translate("") %></label>
                                <div class="col-sm-10">
                                    <input type="text" class="form-control" id="LabelTitolo" title="<%= Master.Translate("Etichetta da associare al campo titolo") %>." />
                                </div>
                            </div>
                            <div class="form-group" id="fg-LabelTestoBreve">
                                <label for="LabelTestoBreve" class="col-sm-2 control-label"><%= Master.Translate("Descrizione breve") %></label>
                                <div class="col-sm-8">
                                    <input type="text" class="form-control" id="LabelTestoBreve" title="<%= Master.Translate("Etichetta da associare al campo descrizione breve") %>." />
                                </div>
                                <div class="col-sm-2">
                                    <label title="<%= Master.Translate("Visualizza il campo descrizione breve") %>.">
                                        <input type="checkbox" value="true" class="minimal" id="FlagBreve" />
                                        Attivo<%= Master.Translate("") %>
                                    </label>
                                </div>
                            </div>
                            <div class="form-group" id="fg-LabelTestoLungo">

                                <label for="LabelTestoLungo" class="col-sm-2 control-label">Testo completo<%= Master.Translate("") %></label>
                                <div class="col-sm-8">
                                    <input type="text" class="form-control" id="LabelTestoLungo" title="Etichetta da associare al campo testo completo<%= Master.Translate("") %>." />
                                </div>
                                <div class="col-sm-2">
                                    <label title="Visualizza il campo testo completo<%= Master.Translate("") %>.">
                                        <input type="checkbox" value="true" class="minimal" id="FlagFull" />
                                        <%= Master.Translate("Attivo") %>
                                    </label>
                                </div>
                            </div>
                            <div class="form-group" id="fg-LabelUrl">
                                <label for="LabelUrl" class="col-sm-2 control-label"><%= Master.Translate("Url principale") %></label>
                                <div class="col-sm-8">
                                    <input type="text" class="form-control" id="LabelUrl" title="<%= Master.Translate("Etichetta da associare al campo url principale") %>." />
                                </div>
                                <div class="col-sm-2">
                                    <label title="<%= Master.Translate("Visualizza il campo url principale") %>.">
                                        <input type="checkbox" value="true" class="minimal" id="FlagUrl" />
                                        <%= Master.Translate("Attivo") %>
                                    </label>
                                </div>
                            </div>
                            <div class="form-group" id="fg-LabelUrlSecondaria">
                                <label for="LabelUrlSecondaria" class="col-sm-2 control-label"><%= Master.Translate("Url secondaria") %></label>
                                <div class="col-sm-8">
                                    <input type="text" class="form-control" id="LabelUrlSecondaria" title="<%= Master.Translate("Etichetta da associare al campo url secondaria") %>." />
                                </div>
                                <div class="col-sm-2">
                                    <label title="<%= Master.Translate("Visualizza il campo url secondaria") %>.">
                                        <input type="checkbox" value="true" class="minimal" id="FlagUrlSecondaria" />
                                        <%= Master.Translate("Attivo") %>
                                    </label>
                                </div>
                            </div>
                            <div class="form-group" id="fg-LabelAltezza">
                                <label for="LabelAltezza" class="col-sm-2 control-label"><%= Master.Translate("Altezza") %></label>
                                <div class="col-sm-8">
                                    <input type="text" class="form-control" id="LabelAltezza" title="<%= Master.Translate("Etichetta da associare al campo Altezza") %>." />
                                </div>
                                <div class="col-sm-2">
                                    <label title="<%= Master.Translate("Visualizza il campo Altezza") %>.">
                                        <input type="checkbox" value="true" class="minimal" id="FlagAltezza" />
                                        <%= Master.Translate("Attivo") %>
                                    </label>
                                </div>
                            </div>
                            <div class="form-group" id="fg-LabelLarghezza">
                                <label for="LabelLarghezza" class="col-sm-2 control-label"><%= Master.Translate("Larghezza") %></label>
                                <div class="col-sm-8">
                                    <input type="text" class="form-control" id="LabelLarghezza" title="<%= Master.Translate("Etichetta da associare al campo Larghezza") %>." />
                                </div>
                                <div class="col-sm-2">
                                    <label title="<%= Master.Translate("Visualizza il campo Larghezza") %>.">
                                        <input type="checkbox" value="true" class="minimal" id="FlagLarghezza" />
                                        <%= Master.Translate("Attivo") %>
                                    </label>
                                </div>
                            </div>
                            <div class="form-group" id="fg-LabelExtraInfo">
                                <label for="LabelExtraInfo" class="col-sm-2 control-label">Extra Info</label>
                                <div class="col-sm-8">
                                    <input type="text" class="form-control" id="LabelExtraInfo" title="<%= Master.Translate("Etichetta da associare al campo") %> 'ExtraInfo 0'." />
                                </div>
                                <div class="col-sm-2">
                                    <label title="<%= Master.Translate("Visualizza il campo") %>.">
                                        <input type="checkbox" value="true" class="minimal" id="FlagExtraInfo" />
                                         <%= Master.Translate("Attivo") %>
                                    </label>
                                </div>
                            </div>
                            <div class="form-group" id="fg-LabelExtraInfo1">
                                <label for="LabelExtraInfo1" class="col-sm-2 control-label">ExtraInfo 1 (<%= Master.Translate("Titolo mostrato") %>)</label>
                                <div class="col-sm-8">
                                    <input type="text" class="form-control" id="LabelExtraInfo1" title="<%= Master.Translate("Etichetta da associare al campo") %> ExtraInfo 1." />
                                </div>
                                <div class="col-sm-2">
                                    <label title="<%= Master.Translate("Visualizza il campo") %>.">
                                        <input type="checkbox" value="true" class="minimal" id="FlagExtrInfo1" />
                                        Attivo
                                    </label>
                                </div>
                            </div>
                            <div class="form-group" id="fg-LabelScadenza">
                                <label for="LabelScadenza" class="col-sm-2 control-label"><%= Master.Translate("Scadenza") %></label>
                                <div class="col-sm-8">
                                    <input type="text" class="form-control" id="LabelScadenza" title="<%= Master.Translate("Etichetta da associare al campo scadenza") %>."
                                        placeholder="Lasciare vuoto per nascondere il campo" />
                                </div>
                                <div class="col-sm-2">
                                    <label title="<%= Master.Translate("Visualizza il campo") %>.">
                                        <input type="checkbox" value="true" class="minimal" id="FlagScadenza" />
                                        Attivo
                                    </label>
                                </div>
                            </div>
                            <div class="form-group" id="fg-LabelExtraInfo2">
                                <label for="LabelExtraInfo2" class="col-sm-2 control-label">ExtraInfo 2</label>
                                <div class="col-sm-10">
                                    <input type="text" class="form-control" id="LabelExtraInfo2" title="<%= Master.Translate("Etichetta da associare al campo") %> 'ExtraInfo 2'."
                                        placeholder="<%= Master.Translate("Lasciare vuoto per nascondere il campo") %>" />
                                </div>
                            </div>
                            <div class="form-group" id="fg-LabelExtraInfo3">
                                <label for="LabelExtraInfo3" class="col-sm-2 control-label">ExtraInfo 3</label>
                                <div class="col-sm-10">
                                    <input type="text" class="form-control" id="LabelExtraInfo3" title="<%= Master.Translate("Etichetta da associare al campo") %> 'ExtraInfo 3'."
                                        placeholder="<%= Master.Translate("Lasciare vuoto per nascondere il campo") %>" />
                                </div>
                            </div>
                            <div class="form-group" id="fg-LabelExtraInfo4">
                                <label for="LabelExtraInfo4" class="col-sm-2 control-label">Extra Info 4</label>
                                <div class="col-sm-10">
                                    <input type="text" class="form-control" id="LabelExtraInfo4" title="<%= Master.Translate("Etichetta da associare al campo") %> 'ExtraInfo 4'."
                                        placeholder="<%= Master.Translate("Lasciare vuoto per nascondere il campo") %>" />
                                </div>
                            </div>
                            <div class="form-group" id="fg-LabelExtraInfo_5">
                                <label for="LabelExtraInfo_5" class="col-sm-2 control-label">Extra Info 5</label>
                                <div class="col-sm-10">
                                    <input type="text" class="form-control" id="LabelExtraInfo_5" placeholder="<%= Master.Translate("Lasciare vuoto per nascondere il campo") %>"
                                        title="<%= Master.Translate("Etichetta da associare al campo") %> 'ExtraInfo 5'." />
                                </div>
                            </div>
                            <div class="form-group" id="fg-LabelExtraInfo_6">
                                <label for="LabelExtraInfo_6" class="col-sm-2 control-label">Extra Info 6</label>
                                <div class="col-sm-10">
                                    <input type="text" class="form-control" id="LabelExtraInfo_6" placeholder="<%= Master.Translate("Lasciare vuoto per nascondere il campo") %>"
                                        title="<%= Master.Translate("Etichetta da associare al campo") %> 'ExtraInfo 6'." />
                                </div>
                            </div>
                            <div class="form-group" id="fg-LabelExtraInfo_7">
                                <label for="LabelExtraInfo_7" class="col-sm-2 control-label">Extra Info 7</label>
                                <div class="col-sm-10">
                                    <input type="text" class="form-control" id="LabelExtraInfo_7" placeholder="<%= Master.Translate("Lasciare vuoto per nascondere il campo") %>"
                                        title="<%= Master.Translate("Etichetta da associare al campo") %> 'ExtraInfo 7'." />
                                </div>
                            </div>
                            <div class="form-group" id="fg-LabelExtraInfo_8">
                                <label for="LabelExtraInfo_8" class="col-sm-2 control-label">Extra Info 8</label>
                                <div class="col-sm-10">
                                    <input type="text" class="form-control" id="LabelExtraInfo_8" placeholder="<%= Master.Translate("Lasciare vuoto per nascondere il campo") %>"
                                        title="<%= Master.Translate("Etichetta da associare al campo") %> 'ExtraInfo 8'." />
                                </div>
                            </div>
                            <div class="form-group" id="fg-LabelExtraInfoNumber_1">
                                <label for="LabelExtraInfoNumber_1" class="col-sm-2 control-label"><%= Master.Translate("Campo Numerico") %> 1</label>
                                <div class="col-sm-10">
                                    <input type="text" class="form-control" id="LabelExtraInfoNumber_1" placeholder="<%= Master.Translate("Lasciare vuoto per nascondere il campo") %>"
                                        title="Etichetta da associare al <%= Master.Translate("Campo numerico") %> 1." />
                                </div>
                            </div>
                            <div class="form-group" id="fg-LabelExtraInfoNumber_2">
                                <label for="LabelExtraInfoNumber_2" class="col-sm-2 control-label"><%= Master.Translate("Campo numerico") %> 2</label>
                                <div class="col-sm-10">
                                    <input type="text" class="form-control" id="LabelExtraInfoNumber_2" placeholder="<%= Master.Translate("Lasciare vuoto per nascondere il campo") %>"
                                        title="Etichetta da associare al <%= Master.Translate("Campo numerico") %> 2." />
                                </div>
                            </div>
                            <div class="form-group" id="fg-LabelExtraInfoNumber_3">
                                <label for="LabelExtraInfoNumber_3" class="col-sm-2 control-label"><%= Master.Translate("Campo numerico") %> 3</label>
                                <div class="col-sm-10">
                                    <input type="text" class="form-control" id="LabelExtraInfoNumber_3" placeholder="<%= Master.Translate("Lasciare vuoto per nascondere il campo") %>"
                                        title="Etichetta da associare al <%= Master.Translate("Campo numerico") %> 3." />
                                </div>
                            </div>
                            <div class="form-group" id="fg-LabelExtraInfoNumber_4">
                                <label for="LabelExtraInfoNumber_4" class="col-sm-2 control-label"><%= Master.Translate("Campo numerico") %> 4</label>
                                <div class="col-sm-10">
                                    <input type="text" class="form-control" id="LabelExtraInfoNumber_4" placeholder="<%= Master.Translate("Lasciare vuoto per nascondere il campo") %>"
                                        title="Etichetta da associare al <%= Master.Translate("Campo numerico") %> 4." />
                                </div>
                            </div>
                            <div class="form-group" id="fg-LabelExtraInfoNumber_5">
                                <label for="LabelExtraInfoNumber_5" class="col-sm-2 control-label">
                                    <%= Master.Translate("Campo numerico") %> 5
                                </label>
                                <div class="col-sm-10">
                                    <input type="text" class="form-control" id="LabelExtraInfoNumber_5" placeholder="<%= Master.Translate("Lasciare vuoto per nascondere il campo") %>"
                                        title="Etichetta da associare al <%= Master.Translate("Campo numerico") %> 5." />
                                </div>
                            </div>
                            <div class="form-group" id="fg-LabelExtraInfoNumber_6">
                                <label for="LabelExtraInfoNumber_6" class="col-sm-2 control-label">
                                    <%= Master.Translate("Campo numerico") %> 6
                                </label>
                                <div class="col-sm-10">
                                    <input type="text" class="form-control" id="LabelExtraInfoNumber_6" placeholder="<%= Master.Translate("Lasciare vuoto per nascondere il campo") %>"
                                        title="Etichetta da associare al <%= Master.Translate("Campo numerico") %> 6." />
                                </div>
                            </div>
                            <div class="form-group" id="fg-LabelExtraInfoNumber_7">
                                <label for="LabelExtraInfoNumber_7" class="col-sm-2 control-label">
                                    <%= Master.Translate("Campo numerico") %> 7
                                </label>
                                <div class="col-sm-10">
                                    <input type="text" class="form-control" id="LabelExtraInfoNumber_7" placeholder="<%= Master.Translate("Lasciare vuoto per nascondere il campo") %>"
                                        title="Etichetta da associare al <%= Master.Translate("Campo numerico") %> 7." />
                                </div>
                            </div>
                            <div class="form-group" id="fg-LabelExtraInfoNumber_8">
                                <label for="LabelExtraInfoNumber_8" class="col-sm-2 control-label">
                                    <%= Master.Translate("Campo numerico") %> 8
                                </label>
                                <div class="col-sm-10">
                                    <input type="text" class="form-control" id="LabelExtraInfoNumber_8" placeholder="<%= Master.Translate("Lasciare vuoto per nascondere il campo") %>"
                                        title="Etichetta da associare al <%= Master.Translate("Campo numerico") %> 8." />
                                </div>
                            </div>
                            <div class="form-group">
                                <div class="col-12">
                                    <div class="center-block text-center">
                                        <button type="button" class="btn btn-primary" data-action="submit">
                                            <%= Master.Translate("Salva modifiche") %></button>
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
                        "stateSave": true,
                        "ajax": {
                            "url": "Ajax/TypesPaginated.ashx?basket=0",
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
                                                .html('<i class="fa fa-external-link-square"></i><span class="hidden-sm hidden-xs">"<%= Master.Translate("recupera") %></span>');
                                    else
                                        btn = $('<button />')
                                                .addClass('btn btn-primary btn-xs')
                                                .attr('data-rowpk', data)
                                                .attr('data-action', 'edit')
                                                .attr('type', 'button')
                                                .attr('title', 'modifica')
                                                .html('<i class="fa fa-edit"></i><span class="hidden-sm hidden-xs"><%= Master.Translate("modifica") %></span>');

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
                                        .html('<i class="fa fa-trash"></i><span class="hidden-sm hidden-xs"><%= Master.Translate("cestino") %></span>');
                                    else
                                        btn
                                        .attr('title', 'elimina')
                                        .html('<i class="fa fa-eraser"></i><span class="hidden-sm hidden-xs"><%= Master.Translate("elimina") %></span>');

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
                        	bootbox.confirm('<%= Master.Translate("Le modifiche non salvate andranno perse. Voui continuare") %>?', function (result) {
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
                        	msg = '<%= Master.Translate("La configurazione verrà eliminata definitivamente. Sei sicuro di voler continuare") %>?';
                        else
                        	msg = '<%= Master.Translate("Stai spostando la configurazione nel cestino. Ser sicuro di voler continuare") %>?';

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
                                        	title: '<%= Master.Translate("Info") %>',
                                            message: data.msg,
                                            icon: "fa fa-info-circle"
                                        },
                                        {
                                            type: 'success'
                                        })
                                    } else {
                                        $.growl({
                                        	title: '<%= Master.Translate("Errore") %>',
                                            message: data.msg,
                                            icon: "fa fa-warning"
                                        },
                                        {
                                            type: 'danger'
                                        })
                                    }
                                })
                                .fail(function (jqxhr, textStatus, error) {
                                	bootbox.alert('<%= Master.Translate("Si è verificato un errore") %>: ' + textStatus + "," + error);
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
                                	title: '<%= Master.Translate("Info") %>',
                                    message: data.msg,
                                    icon: "fa fa-info-circle"
                                },
                                {
                                    type: 'success'
                                })
                            } else {
                                $.growl({
                                	title: '<%= Master.Translate("Errore") %>',
                                    message: data.msg,
                                    icon: "fa fa-warning"
                                },
                                {
                                    type: 'danger'
                                })
                            }
                        })
                        .fail(function (jqxhr, textStatus, error) {
                        	bootbox.alert('<%= Master.Translate("Si è verificato un errore") %>: ' + textStatus + "," + error);
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
                    placeholder: '<%= Master.Translate("Icona") %>',
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
                    placeholder: '<%= Master.Translate("Scegli la master page") %>',
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
                        title: '<%= Master.Translate("Info") %>',
                        message: "<%= Master.Translate("Record salvato con successo") %>"
                    },
                    {
                        type: 'success'
                    })
                    $('#edit-type').mb_submit('pendingChanges',false);
                } else {
                    $.growl({
                        icon: 'fa fa-warning',
                        title: '<%= Master.Translate("Errore") %>',
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
                	bootbox.confirm('<%= Master.Translate("Le modifiche non salvate andranno perse. Voui continuare") %>?', function (result) {
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
                            title: '<%= Master.Translate("Errore") %>',
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
                                message: record.Nome + " <%= Master.Translate("è stato caricato con successo") %>"
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
                                title: '<%= Master.Translate("Si è verificato un errore") %>: ',
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
                	return '<%= Master.Translate("Attenzione sono state rilevate modifiche non salvate") %>.';
            });
        })
    </script>
</asp:Content>
