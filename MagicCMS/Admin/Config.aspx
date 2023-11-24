<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/MasterAdmin.master" AutoEventWireup="true"
    CodeBehind="Config.aspx.cs" Inherits="MagicCMS.Admin.Config" %>

<%@ MasterType TypeName="MagicCMS.Admin.MasterAdmin" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="assets-2022/css/file-man.css" rel="stylesheet" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="HeaderContent" runat="server">
    <h1><i class="fa fa-cogs"></i><%= Master.Translate("Configurazione Sito") %></h1>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
    <div class="row">
        <div class="col-md-12">
            <div class="box box-primary">
                <div class="box-header">
                    <h3 class="box-title"><%= Master.Translate("Lingue disponibili per le traduzioni") %></h3>
                    <div class="box-tools pull-right">
                        <button type="button" class="btn btn-primary btn-sm" data-widget="collapse">
                            <i class="fa fa-minus"></i>
                        </button>
                    </div>
                </div>
                <div class="box-body">
                    <table id="table-lang" class="table table-striped table-bordered" style="width: 100%" width="100%">
                        <thead>
                            <tr>
                                <th>Id</th>
                                <th><%= Master.Translate("Lingua") %></th>
                                <th><i class="fa fa-check"></i></th>
                                <th title="<%= Master.Translate("Nascondi pagine non tradotte") %>">Autohide</th>
                            </tr>
                        </thead>
                        <tbody>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
        <div class="col-md-12">
            <div class="box box-primary" id="edit-record">
                <div class="box-header">
                    <h3 class="box-title"><i class="fa fa-cogs"></i><%= Master.Translate("Configurazione Sito") %></h3>
                    <div class="box-tools pull-right">
                        <button type="button" class="btn btn-primary btn-sm" data-widget="collapse">
                            <i class="fa fa-minus"></i>
                        </button>
                    </div>
                </div>
                <div class="box-body">
                    <div class="form-horizontal" role="form" data-ride="mb-form" data-action="Ajax/Edit.ashx"
                        id="edit-config">
                        <fieldset>
                            <input type="hidden" id="Pk" name="Pk" value="0" />
                            <input type="hidden" id="table" name="table" value="CONFIG" />
                            <div class="form-group" id="fg_SiteName">
                                <label for="SiteName" class="col-sm-2 control-label"><%= Master.Translate("Nome sito") %></label>
                                <div class="col-sm-10">
                                    <input type="text" class="form-control" id="SiteName" value="<% = CMS_config.SiteName %>" />
                                </div>
                            </div>
                            <div class="form-group" id="fg-start">
                                <label for="" class="col-sm-2 control-label"><%= Master.Translate("Pagina iniziale") %></label>
                                <div class="col-sm-10">
                                    <input type="hidden" value="<% = (CMS_config.StartPage > 0 ? CMS_config.StartPage.ToString() : "") %>"
                                        id="StartPage" class="form-control"
                                        data-types="<% = String.Join(",", StartPageList.ToArray()) %>" data-placeholder="Pagina iniziale" />
                                </div>
                            </div>
                            <div class="form-group" id="fg-nav">
                                <label for="" class="col-sm-2 control-label"><%= Master.Translate("Menù") %></label>
                                <div class="col-sm-10">
                                    <div class="row">
                                        <div class="col-sm-4">
                                            <input type="hidden" value="<% = (CMS_config.MainMenu > 0 ? CMS_config.MainMenu.ToString() : "") %>"
                                                id="MainMenu" class="form-control"
                                                data-types="<% = MagicCMS.Core.MagicPostTypeInfo.Menu.ToString() %>" data-placeholder="Menù principale" />
                                        </div>
                                        <div class="col-sm-4">
                                            <input type="hidden" value="<% = (CMS_config.SecondaryMenu > 0 ? CMS_config.SecondaryMenu.ToString() : "") %>"
                                                id="SecondaryMenu"
                                                class="form-control"
                                                data-types="<% = MagicCMS.Core.MagicPostTypeInfo.Menu.ToString() %>" data-placeholder="Menù secondario" />
                                        </div>
                                        <div class="col-sm-4">
                                            <input type="hidden" value="<% = (CMS_config.FooterMenu > 0 ? CMS_config.FooterMenu.ToString() : "")%>"
                                                id="FooterMenu" class="form-control"
                                                data-types="<% = MagicCMS.Core.MagicPostTypeInfo.Menu.ToString() %>" data-placeholder="Terzo menù" />
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group" id="fg-flags">
                                <label for="" class="col-sm-2 control-label"><%= Master.Translate("Flags") %></label>
                                <div class="col-sm-10">
                                    <div class="row">
                                        <div class="col-sm-3">
                                            <label>
                                                <input type="checkbox" value="true" class="minimal" id="SinglePage" <% = CMS_config.SinglePage ? "checked" : "" %> />
                                                <%= Master.Translate("Pagina singola") %>
                                            </label>
                                        </div>
                                        <div class="col-sm-3">
                                            <label>
                                                <input type="checkbox" value="true" class="minimal" id="MultiPage" <% = CMS_config.MultiPage ? "checked" : "" %> />
                                                <%= Master.Translate("Pagine Multiple") %>
                                            </label>
                                        </div>
                                        <div class="col-sm-3">
                                            <label>
                                                <input type="checkbox" value="true" class="minimal" id="TransAuto" <% = CMS_config.TransAuto ? "checked" : "" %> />
                                                <%= Master.Translate("Abilita Bing translator") %>
                                            </label>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="form-group d-none" id="fg-testo-breve">
                                <label for="TransClientId" class="col-sm-2 control-label"><%= Master.Translate("Client Id per Bing Translator") %></label>
                                <div class="col-sm-10">
                                    <input type="text" class="form-control" id="TransClientId" value="<% = CMS_config.TransClientId %>" />
                                </div>
                            </div>
                            <div class="form-group" id="fg-LabelTestoBreve">
                                <label for="TransSecretKey" class="col-sm-2 control-label"><%= Master.Translate("Secret Key per Bing Translator") %></label>
                                <div class="col-sm-10">
                                    <input type="text" class="form-control" id="TransSecretKey" value="<% = CMS_config.TransSecretKey %>" />
                                </div>
                            </div>
                            <div class="form-group" id="fg-TransSourceLangId">
                                <label for="TransSourceLangId" class="col-sm-2 control-label"><%= Master.Translate("Id lingua di origine") %></label>
                                <div class="col-sm-10">
                                    <input type="text" class="form-control" id="TransSourceLangId" value="<% = CMS_config.TransSourceLangId %>" />
                                </div>
                            </div>
                            <div class="form-group" id="fg-TransSourceLangName">
                                <label for="TransSourceLangName" class="col-sm-2 control-label"><%= Master.Translate("Nome lingua di origine") %></label>
                                <div class="col-sm-10">
                                    <input type="text" class="form-control" id="TransSourceLangName" value="<% = CMS_config.TransSourceLangName %>" />
                                </div>
                            </div>
                            <div class="form-group" id="fg-ThemePath">
                                <label for="ThemePath" class="col-sm-2 control-label"><%= Master.Translate("Cartella del tema") %></label>
                                <div class="col-sm-10">
                                    <input type="text" class="form-control" id="ThemePath" value="<% = CMS_config.ThemePath %>" />
                                </div>
                            </div>
                            <div class="form-group" id="fg-DefaultContentMaster">
                                <label for="DefaultContentMaster" class="col-sm-2 control-label"><%= Master.Translate("Pagina master di default") %></label>
                                <div class="col-sm-10">
                                    <input type="text" class="form-control" id="DefaultContentMaster" value="<% = CMS_config.DefaultContentMaster %>" />
                                </div>
                            </div>
                            <div class="form-group" id="fg-ImagesPath">
                                <label for="ImagesPath" class="col-sm-2 control-label"><%= Master.Translate("Cartella delle icone") %></label>
                                <div class="col-sm-10">
                                    <input type="text" class="form-control" id="ImagesPath" value="<% = CMS_config.ImagesPath %>" />
                                </div>
                            </div>
                            <div class="form-group" id="fg-DefaultImage">
                                <label for="DefaultImage" class="col-sm-2 control-label"><%= Master.Translate("Immagine di default") %></label>
                                <div class="col-sm-10">
                                    <div class="input-group">
                                        <input type="text" class="form-control" id="DefaultImage" value="<% = CMS_config.DefaultImage  %>" />
                                        <span class="input-group-btn">
                                            <button class="btn btn-danger btn-flat FlagCercaServer" type="button" data-target="#DefaultImage"
                                                title="" data-action="upload" data-original-title="Cerca il file sul tuo disco">
                                                <i class="fa fa-folder-open-o"></i>Sfoglia...
                                            </button>
                                            <button class="btn btn-warning btn-flat btn-icon FlagCercaServer" type="button"
                                                data-callback="getImageUrl" title="" data-target="#DefaultImage" data-toggle="fb-window"
                                                data-fm-url="FileManager.aspx" data-original-title="Cerca file sul server">
                                                <i class="fa fa-fw fa-database"></i>
                                            </button>
                                            <button class="btn btn-success btn-flat btn-icon" type="button" data-source="#DefaultImage" title=""
                                                data-action="viewer" data-original-title="Guarda il file">
                                                <i class="fa fa-eye"></i>
                                            </button>
                                        </span>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group" id="fg-SmtpServer">
                                <label for="SmtpServer" class="col-sm-2 control-label"><%= Master.Translate("Server SMTP") %></label>
                                <div class="col-sm-10">
                                    <input type="text" class="form-control" id="SmtpServer" value="<% = CMS_config.SmtpServer %>" />
                                </div>
                            </div>
                            <div class="form-group" id="fg-SmtpUsername">
                                <label for="SmtpUsername" class="col-sm-2 control-label"><%= Master.Translate("Utente SMTP") %></label>
                                <div class="col-sm-10">
                                    <input type="text" class="form-control" id="SmtpUsername" value="<% = CMS_config.SmtpUsername %>" />
                                </div>
                            </div>
                            <div class="form-group" id="fg-SmtpPassword">
                                <label for="SmtpPassword" class="col-sm-2 control-label"><%= Master.Translate("Password SMTP") %></label>
                                <div class="col-sm-10">
                                    <input type="password" class="form-control" id="SmtpPassword" value="<% = CMS_config.SmtpPassword %>" />
                                </div>
                            </div>
                            <div class="form-group" id="fg-SmtpDefaultFromMail">
                                <label for="SmtpDefaultFromMail" class="col-sm-2 control-label"><%= Master.Translate("Mittente di default") %></label>
                                <div class="col-sm-10">
                                    <input type="text" class="form-control" id="SmtpDefaultFromMail" value="<% = CMS_config.SmtpDefaultFromMail %>" />
                                </div>
                            </div>
                            <div class="form-group" id="fg-SmtpAdminMail">
                                <label for="SmtpAdminMail" class="col-sm-2 control-label"><%= Master.Translate("Email Web Master") %></label>
                                <div class="col-sm-10">
                                    <input type="text" class="form-control" id="SmtpAdminMail" value="<% = CMS_config.SmtpAdminMail %>" />
                                </div>
                            </div>
                            <div class="form-group" id="fg-GaProperty_ID">
                                <label for="GaProperty_ID" class="col-sm-2 control-label"><%= Master.Translate("Id Google Analytics") %></label>
                                <div class="col-sm-10">
                                    <input type="text" class="form-control" id="GaProperty_ID" value="<% = CMS_config.GaProperty_ID %>"
                                        placeholder="formato: UA-xxxxxxxxx-x" />
                                </div>
                            </div>
                            <div class="form-group">
                                <div class="col-12">
                                    <div class="center-block text-center">
                                        <button type="button" class="btn btn-primary" data-action="submit">
                                            <%= Master.Translate("Salva configurazione") %></button>
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

    <!-- FILE MANAGER VIEWER -->
    <div class="fm-viewer off-screen" id="theViewer">

        <nav class="navbar fm-navbar bg-transparent position-absolute d-flex align-items-center border-0 pl-4 px top-0" role="navigation">
            <!-- Sidebar toggle button-->
            <span class="align-self-start h3 text-white my-auto viewer-title"></span>
            <div class="navbar-right d-flex justify-content-end ml-auto mr-0 ">

                <ul class="nav navbar-nav d-flex align-items-center mr-1">

                    <li class="">
                        <button type="button" data-action="download-file" title="Scarica" class="btn btn-icon btn-lg btn-dark px-3 rounded-0">
                            <i class="fa fa-fw  fa-download "></i>
                        </button>
                    </li>
                    <li class="">
                        <button type="button" data-action="toggle-fullscreen" title="Fullscreen on/off" class="btn btn-icon btn-lg btn-dark px-3 rounded-0  ml-1">
                            <i class="fa fa-fw  fa-arrows-alt"></i>
                        </button>
                    </li>
                    <li class="">
                        <button type="button" data-action="close-viewer" title="Chiudi" class="btn btn-icon btn-lg btn-dark px-3 rounded-0  ml-1">
                            <i class="fa fa-fw  fa-times"></i>
                        </button>
                    </li>
                </ul>
            </div>
        </nav>
    </div>

    <!-- fine vewer -->
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="Scripts" runat="server">
    <script src="assets-2022/mb/FM_Viewer.js?v=3"></script>
    <script src="assets-2022/mb/MB_FileUpload.js"></script>
    <script>
        (function (win, $) {
            win.TheViewer = new FM_Viewer('#theViewer');
            win.TheUploader = new MB_FileUpload('/api/FileUpload');
        })(window, jQuery);
    </script>
    <script>

        document.querySelectorAll('[data-action]').forEach(element => {
            const action = element.dataset.action;
            element.addEventListener('click', () => {
                switch (action) {
                    case "viewer":
                        let sourceSelector = element.dataset.source;
                        const source = document.querySelector(sourceSelector);
                        if (source.value)
                            TheViewer.show(source.value);
                        break;
                    case "upload":
                        let targetSelector = $(element).data('target');
                        TheUploader.getFileSingle().then(url => { if (url) $(targetSelector).val(url); });
                        break;
                    default:
                }
            })
        })

        function getImageUrl(url) {
            $('#DefaultImage').val(url);
            $('#FileBrowserModal').modal('hide');
        }

        $(function () {
            var $langtable = $('#table-lang')
                .on('xhr.dt', function (e, settings, json) {
                    var xhr = settings.jqXHR;
                    if (xhr.status == 403) {

                        Swal.fire({
                            icon: 'error',
                            title: 'Errore',
                            text: 'Sessione scaduta. È necessario ripetere il login.'
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
                    "ajax": {
                        "url": "Ajax/LanguagesDT.ashx",
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
                    "drawCallback": function (settings) {
                        // Init checkboxes with iCheck 
                        $("input[type='checkbox']", $(this))
                            .iCheck({
                                checkboxClass: 'icheckbox_minimal',
                                radioClass: 'iradio_minimal'
                            })
                            // Update database via Ajax on change
                            .on('ifChanged', function () {
                                $this = $(this);
                                var active = $this.is(':checked');
                                var langId = $this.attr('data-rowpk');
                                var action = $this.attr('data-action');
                                var param = {};
                                $('#table-lang').spin();

                                param.langId = langId;
                                param.active = $this.parents('tr').find('[data-action="activate"]').is(':checked');
                                param.autohide = $this.parents('tr').find('[data-action="autohide"]').is(':checked');

                                $.getJSON('Ajax/LangActivate.ashx', param)
                                    .fail(function (jqxhr, textStatus, error) {

                                        Swal.fire({
                                            icon: "error",
                                            title: 'Errore',
                                            text: 'Si è verificaro un errore: ' + textStatus + ", " + error
                                        })
                                    })
                                    .done(function (data) {
                                        if (!data.success) {
                                            $.growl({
                                                icon: 'fa fa-warning',
                                                title: 'Si è verificato un errore ',
                                                message: data.msg
                                            },
                                                {
                                                    type: 'danger'
                                                })
                                        }
                                    })
                                    .always(function () {

                                        $langtable.ajax.url('Ajax/LanguagesDT.ashx').load(function () {
                                            $('#table-lang').spin(false);
                                        });
                                    })
                            });
                    },
                    "columnDefs": [
                        {
                            "targets": 0,
                            "data": "LangId",
                            "width": "10%"
                        },
                        {
                            "targets": 1,
                            "data": "LangName",
                            "width": "70%"
                        },
                        {
                            "targets": 2,
                            "width": "10%",
                            "data": "Active",
                            "searchable": false,
                            "orderable": false,
                            "className": "text-center",
                            "render": function (data, type, full, meta) {
                                var $cb = $('<input />')
                                    //.addClass('btn btn-danger btn-xs')
                                    .attr('data-rowpk', full.LangId)
                                    .attr('data-action', 'activate')
                                    .attr('type', 'checkbox');
                                if (data)
                                    $cb.attr('checked', 'checked');
                                return $('<div />').append($cb).html();
                            }
                        },
                        {
                            "targets": 3,
                            "width": "10%",
                            "data": "AutoHide",
                            "searchable": false,
                            "orderable": false,
                            "className": "text-center",
                            "render": function (data, type, full, meta) {
                                var $cb = $('<input />')
                                    //.addClass('btn btn-danger btn-xs')
                                    .attr('data-rowpk', full.LangId)
                                    .attr('data-action', 'autohide')
                                    .attr('type', 'checkbox');
                                if (data)
                                    $cb.attr('checked', 'checked');
                                return $('<div />').append($cb).html();
                            }
                        }
                    ]
                });

            // Navigation config

            $('#fg-nav input, #fg-start input')
                .each(function (index) {
                    var $this = $(this);
                    $this.select2(
                        {
                            ajax: {
                                url: 'Ajax/Liste.ashx',
                                dataType: 'json',
                                quietMillis: 200,
                                data: function (term, page) {
                                    return { k: term, idField: "CONTENUTI", idList: $this.attr('data-types') };
                                },
                                results: function (data, page, query) {
                                    return { results: data };
                                }
                            },
                            initSelection: function (element, callback) {
                                var pk = $(element).val();
                                $.getJSON('Ajax/GetRecord.ashx', { pk: pk, table: 'MB_contenuti_title' }).done(function (data) {
                                    if (pk != 0)
                                        callback({ id: pk, text: data.data });

                                });
                            },
                            allowClear: true
                        }).parent().tooltip({
                            container: 'body',
                            delay: { show: 500, hide: 300 },
                            title: $(this).attr('data-placeholder'),
                            trigger: 'hover'
                        }).on('click', function () {
                            $this.tooltip('hide');
                        });
                });

            // When pseudo-form is submitted
            $('#edit-config').on('submitted.mb.form', function (e, data) {
                //e.stopPropagation();
                if (data.success) {
                    $.growl({
                        icon: 'fa fa-thumbs-o-up',
                        title: 'Salvataggio dati',
                        message: data.msg
                    },
                        {
                            type: 'success'
                        });
                    // Post Id hidden fields updated !!
                    //$('[name="Pk"], [name="PostPk"]').val(data.pk);
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
            });

        });
    </script>
</asp:Content>
