<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/BaseAdmin.Master" AutoEventWireup="true" CodeBehind="FileManager.aspx.cs" Inherits="MagicCMS.Admin.FileManager" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="assets-2022/css/file-man.css" rel="stylesheet" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <!-- Header Navbar: style can be found in header.less -->
    <input type="hidden" id="UserRoot" value="<%= UserRoot %>" />
    <input type="hidden" id="StartRoot" value="<%= CurrentRoot %>" />
    <asp:HiddenField ID="HF_CurrentCulture" runat="server" ClientIDMode="Static" />
    <asp:HiddenField ID="HF_CKEditorFunctionNumber" runat="server" ClientIDMode="Static" />
    <asp:HiddenField ID="HF_Opener" runat="server" ClientIDMode="Static" />
    <asp:HiddenField ID="HF_CallBack" runat="server" ClientIDMode="Static" />
    <asp:HiddenField ID="HF_Field" runat="server" ClientIDMode="Static" />
    <asp:HiddenField ID="HF_Type" runat="server" ClientIDMode="Static" />


    <nav class="navbar fm-navbar navbar-static-top d-flex align-items-center border-0 pr-0 top-0" role="navigation">
        <!-- Sidebar toggle button-->

        <div class="navbar-right d-flex justify-content-end ml-auto mr-0 d-none" data-tab-show="#tab-my-files">
            <ul class="nav navbar-nav d-flex align-items-center mr-1">
                <li class="">
                    <button type="button" data-action="upload" title="Carica file" class="btn btn-icon btn-lg btn-dark px-3 rounded-0">
                        <i class="fa fa-fw fa-upload "></i>
                    </button>
                </li>
                <li class="">
                    <button type="button" data-action="list" title="Layout lista" class="btn btn-icon btn-lg btn-dark px-3 rounded-0">
                        <i class="fa fa-fw   fa-th-list "></i>
                    </button>
                </li>
                <li class="">
                    <button type="button" data-action="grid" title="Layout griglia" class="btn btn-icon btn-lg btn-dark px-3 rounded-0">
                        <i class="fa fa-fw fa-th "></i>
                    </button>
                </li>
                <li class="">
                    <button type="button" data-action="back" title="Back" class="btn btn-icon btn-lg btn-dark px-3 rounded-0">
                        <i class="fa fa-fw   fa-arrow-left "></i>
                    </button>
                </li>
                <li class="">
                    <button type="button" data-action="forward" title="Forward" class="btn btn-icon btn-lg btn-dark px-3 rounded-0">
                        <i class="fa fa-fw fa-arrow-right"></i>
                    </button>
                </li>

                <li class="">
                    <button type="button" data-action="copy-selected" title="Copia i file selezionati in un altra cartella"
                        class="btn btn-icon btn-lg btn-dark px-3 rounded-0  ml-1">
                        <i class="fa fa-fw fa-copy"></i>
                    </button>
                </li>

                <li class="">
                    <button type="button" data-action="delete-selected" title="Elimina i file selezionati"
                        class="btn btn-icon btn-lg btn-dark px-3 rounded-0  ml-1">
                        <i class="fa fa-fw fa-trash-o"></i>
                    </button>
                </li>

                <!-- TO DO - Non ancora implementato -->
                <li class="d-none">
                    <button type="button" data-action="move-selected" title="Sposta i file in un altra cartella"
                        class="btn btn-icon btn-lg btn-dark px-3 rounded-0">
                        <span class="fa-stack small" style="font-size: 65%;">
                            <i class="fa fa-file-o fa-stack-2x"></i>
                            <i class="fa fa-arrow-right fa-stack-1x" style="font-size: .7em"></i>
                        </span>
                    </button>
                </li>
                <!-- Fine TO DO -->

                <li class="">
                    <button type="button" data-action="new-folder" title="Nuova cartella" class="btn btn-icon btn-lg btn-dark px-3 rounded-0">
                        <span class="fa-stack small" style="font-size: 65%;">
                            <i class="fa fa-folder-o fa-stack-2x"></i>
                            <i class="fa fa-plus fa-stack-1x" style="font-size: .7em"></i>
                        </span>
                    </button>
                </li>

                <li class="">
                    <button type="button" data-action="home" title="Home" class="btn btn-icon btn-lg btn-dark px-3 rounded-0  ml-1">
                        <i class="fa fa-fw fa-home"></i>
                    </button>
                </li>
            </ul>
        </div>

        <div class="navbar-right d-flex justify-content-end ml-auto mr-0 d-none" data-tab-show="#tab-recents">
            <ul class="nav navbar-nav d-flex align-items-center mr-1">
                <li class="">
                    <button type="button" data-action="delete-selected" title="Elimina i file selezionati"
                        class="btn btn-icon btn-lg btn-dark px-3 rounded-0  ml-1">
                        <i class="fa fa-fw fa-trash-o"></i>
                    </button>
                </li>
            </ul>
        </div>

        <div class="navbar-right d-flex justify-content-end ml-auto mr-0 d-none" data-tab-show="#tab-images">
            <ul class="nav navbar-nav d-flex align-items-center mr-1">
                <li class="">
                    <button type="button" data-action="load-all" title="Layout a lista" class="btn btn-icon btn-lg btn-dark px-3 rounded-0">
                        Carica tutte
                    </button>
                </li>
                <li class="">
                    <button type="button" data-action="delete-selected" title="Elimina i file selezionati"
                        class="btn btn-icon btn-lg btn-dark px-3 rounded-0  ml-1">
                        <i class="fa fa-fw fa-trash-o"></i>
                    </button>
                </li>
                <li class="">
                    <button type="button" data-action="list-image" title="Layout a lista" class="btn btn-icon btn-lg btn-dark px-3 rounded-0">
                        <i class="fa fa-fw fa-th-list "></i>
                    </button>
                </li>
                <li class="">
                    <button type="button" data-action="grid-image" title="Layout a griglia" class="btn btn-icon btn-lg btn-dark px-3 rounded-0">
                        <i class="fa fa-fw fa-th "></i>
                    </button>
                </li>
                <li class="">
                    <button type="button" data-action="sort-image-name" title="Ordina per nome" class="btn btn-icon btn-lg btn-dark px-3 rounded-0">
                        <i class="fa fa-fw   fa-sort-alpha-asc "></i>
                    </button>
                </li>
                <li class="">
                    <button type="button" data-action="sort-image-date" title="Ordina per data" class="btn btn-icon btn-lg btn-dark px-3 rounded-0">
                        <i class="fa fa-fa-2x fa-fw fa-sort-numeric-asc"></i>
                    </button>
                </li>
            </ul>
        </div>

    </nav>


    <div class="row no-gutters mt-0 align-items-stretch min-vh-100 position-fixed min-vw-100">
        <!-- Left side column. contains the logo and sidebar -->
        <aside class="left-side sidebar-offcanvas col-auto position-static" style="margin-top: 0!important;">
            <div class="user-panel pl-0 py-0">
                <div class="pull-left d-flex  align-items-center" style="width: 260px">
                    <div class="logo d-flex align-items-center hidden-collapsed">
                        <!-- Add the class icon to your logo image or logo icon to add the margining -->
                        <img src="img/ConteIcona.png" alt="Magic CMS" class="icon" />
                        <div class="sitename">
                            <span class="h3">File manager</span>
                        </div>

                    </div>
                    <a class="btn btn-link text-white sidebar-toggle p-4" role="button">
                        <i class="fa fa-lg fa-align-justify text-white"></i>
                    </a>

                </div>

            </div>
            <!-- sidebar: style can be found in sidebar.less -->
            <section class="sidebar">
                <!-- sidebar menu: : style can be found in sidebar.less -->
                <ul class="sidebar-menu">
                    <li class="active">
                        <a href="#tab-my-files" class="d-flex align-items-center" data-toggle="tab" data-tab-title="I miei file">
                            <i class="fa  fa-lg fa-folder fa-fw mr-3"></i><span>I miei file</span>
                        </a>
                    </li>
                    <li class="">
                        <a href="#tab-recents" class="d-flex align-items-center" data-toggle="tab" data-tab-title="File recenti">
                            <i class="fa  fa-lg fa-clock-o fa-fw mr-3"></i><span>File recenti</span>
                        </a>
                    </li>
                    <li class="">
                        <a href="#tab-images" class="d-flex align-items-center" data-toggle="tab" data-tab-title="Immagini">
                            <i class="fa fa-lg fa-camera fa-fw mr-3"></i><span>Immagini</span>
                        </a>
                    </li>
                </ul>
            </section>
            <!-- /.sidebar -->
        </aside>

        <!-- Right side column. Contains the navbar and content of the page -->
        <aside class="col pt-5 px-3 d-flex-column fm-aside">
            <div class="pt-4"></div>
            <div class="row h-100">
                <div class="col-12 h-100">
                    <h2 class="box-title fm-title" id="tab-title">I Miei File</h2>
                    <div class="box box-primary h-100 tab-content" data-ride="fm-container">
                        <div class="box-body tab-pane active" id="tab-my-files" data-fm-tab="myfiles">
                        </div>
                        <div class="box-body tab-pane" id="tab-recents" data-fm-tab="recents">
                        </div>
                        <div class="box-body tab-pane" id="tab-images" data-fm-tab="images">
                        </div>

                        <!-- Context menu -->
                        <div class="dropdown fm-context-menu" id="context-menu">
                            <a class="btn btn-secondary dropdown-toggle opacity-0" href="#" role="button" data-toggle="dropdown" aria-expanded="false"></a>
                            <ul class="dropdown-menu" aria-labelledby="dropdownMenuLink">
                                <li>
                                    <a class="dropdown-item" href="#" data-action="select-file">
                                        <i class="fa fa-fw fa-check-square"></i>Seleziona 
                                    </a>
                                </li>
                                <li>
                                    <a class="dropdown-item" href="#" data-action="rename-file">
                                        <i class="fa fa-fw fa-edit"></i>Rinomina
                                    </a>
                                </li>
                                <li>
                                    <a class="dropdown-item" href="#" data-action="move-file">
                                        <i class="fa fa-fw fa-arrow-right"></i>Sposta il file
                                    </a>
                                </li>
                                <li>
                                    <a class="dropdown-item" href="#" data-action="copy-file">
                                        <i class="fa fa-fw fa-copy"></i>Copia il file
                                    </a>
                                </li>
                                <li>
                                    <a class="dropdown-item" href="#" data-action="delete-file">
                                        <i class="fa fa-fw fa-trash-o"></i>Elimina il file
                                    </a>
                                </li>
                            </ul>
                        </div>
                        <!-- fine context menu -->
                        <!-- MODAL DIRECTORY TREE -->
                        <div class="modal fade modal-dir-tree" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
                            <div class="modal-dialog modal-sm d-flex align-items-center justify-content-center h-100" role="document">
                                <div class="modal-content w-100">
                                    <div class="modal-header text-center">
                                        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                                        <h4 class="modal-title" id="myModalLabel">Scegli cartella di destinazione</h4>
                                    </div>
                                    <div class="modal-body vh-50 overflow-auto d-flex justify-content-center align-items-center">
                                    </div>
                                    <div class="modal-footer text-center">
                                        <button type="button" class="btn btn-success" onclick="$(this).parents('.modal-dir-tree').attr('data-ok','true')" data-dismiss="modal">Conferma</button>
                                        <button type="button" class="btn btn-danger" data-dismiss="modal">Annulla</button>
                                    </div>

                                </div>
                            </div>
                        </div>
                        <!-- Fine modal directoryModal -->
                        <!-- MODAL Rename -->
                        <div class="modal fade modal-rename" id="modal-rename" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
                            <div class="modal-dialog modal-sm d-flex align-items-center justify-content-center h-100" role="document">
                                <div class="modal-content w-100">
                                    <div class="modal-header text-center border-0">
                                        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                                        <h4 class="modal-title" id="modal-rename-label">Rinomina</h4>
                                    </div>
                                    <div class="form-group px-5 m-0">
                                        <input type="text" class="form-control">
                                    </div>
                                    <div class="modal-footer text-center border-0">
                                        <button type="button" class="btn btn-success" onclick="$(this).parents('.modal-rename').attr('data-ok','true')" data-dismiss="modal">Conferma</button>
                                        <button type="button" class="btn btn-danger" data-dismiss="modal" onclick="$(this).parents('.modal-rename').removeAttr('data-ok')">Annulla</button>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <!-- Fine modal rename -->
                    </div>
                    <!-- fine directory tree -->
                </div>
            </div>
            <%--</div>--%>
        </aside>
        <!-- /.right-side -->
    </div>
    <!-- FILE MANAGER VIEWER -->
    <div class="fm-viewer off-screen" id="theViewer">

        <nav class="navbar fm-navbar bg-transparent position-absolute d-flex align-items-center border-0 pl-4 px top-0" role="navigation">
            <!-- Sidebar toggle button-->
            <span class="align-self-start h3 text-white my-auto viewer-title"></span>
            <div class="navbar-right d-flex justify-content-end ml-auto mr-0 ">

                <ul class="nav navbar-nav d-flex align-items-center mr-1">

                    <li class="">
                        <button type="button" data-action="select-file" title="Scegli questo file" class="btn btn-icon btn-lg btn-dark px-3 rounded-0">
                            <i class="fa fa-fw  fa-check-square"></i>
                        </button>
                    </li>
                    <li class="">
                        <button type="button" data-action="download-file" title="Scarica" class="btn btn-icon btn-lg btn-dark px-3 rounded-0">
                            <i class="fa fa-fw  fa-download "></i>
                        </button>
                    </li>
                    <li class="">
                        <button type="button" data-action="previous" title="Precedente" class="btn btn-icon btn-lg btn-dark px-3 rounded-0">
                            <i class="fa fa-fw  fa-chevron-left "></i>
                        </button>
                    </li>
                    <li class="">
                        <button type="button" data-action="next" title="Successivo" class="btn btn-icon btn-lg btn-dark px-3 rounded-0">
                            <i class="fa  fa-fw fa-chevron-right"></i>
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
<asp:Content ID="Content3" ContentPlaceHolderID="Script" runat="server">
    <script type="text/template" id="tmpl-image">
        <a href="#" class="fm-col" data-url="{{Url}}" data-fancybox="gal" data-type="{{Type}}" data-selected="{{Selected}}" data-id="{{Id}}">
            <div class="ratio ratio-1x1">
                <svg id="prefix__Livello_1" data-name="Livello 1" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 180 180">
                    <defs>
                        <pattern id="prefix__Scacchi" data-name="Scacchi" width="36" height="36" patternUnits="userSpaceOnUse">
                            <path class="prefix__cls-2" d="M18 0h18v18H18zM0 18h18v18H0z" />
                        </pattern>
                        <style>
                            .prefix__cls-2 {
                                fill: #231f20
                            }
                        </style>
                    </defs><path opacity=".26" fill="url(#prefix__Scacchi)" d="M0 0h180v180H0z" /></svg>
                <div class="d-flex flex-column justify-content-end image fm-miniature position-absolute w-100 h-100 "
                    style="background-image: url('/api/FileManMiniatures?filename={{EncodedUrl}}');" title="{{Url}} ({{LastWriteTimeStr}})">
                    <div class="etichetta flex-column" title="{{Name}}">
                        <div>{{Name}}</div>
                        <span class="small">{{LastWriteTimeStr}}</span>
                    </div>
                    <input type="checkbox" data-id="{{Id}}">
                </div>
            </div>
        </a>
    </script>
    <script type="text/template" id="tmpl-folder">
        <a href="#" class="fm-col" data-url="{{Url}}" data-type="{{Type}}" data-selected="{{Selected}}" data-id="{{Id}}">
            <div class="ratio ratio-1x1">
                <div class="d-flex flex-column justify-content-end fm-miniature" style="background-image: url('/api/FileManMiniatures?filename={{EncodedUrl}}');">
                    <div class="etichetta flex-column text-dark" title="{{Url}}">
                        <div>{{Name}}</div>
                        <span class="small">{{LastWriteTimeStr}}</span>
                    </div>
                    <input type="checkbox" data-id="{{Id}}">
                </div>
            </div>
        </a>
    </script>

    <script type="text/template" id="tmpl-file">
        <a href="#" class="fm-col" data-url="{{Url}}" data-type="{{Type}}" data-fancybox="gal" data-selected="{{Selected}}" data-id="{{Id}}">
            <div class="ratio ratio-1x1">
                <div class="d-flex flex-column justify-content-end fm-miniature" style="background-image: url('/api/FileManMiniatures?filename={{EncodedUrl}}');">
                    <div class="etichetta flex-column text-dark" title="{{Url}}">
                        <div>{{Name}}</div>
                        <span class="small">{{LastWriteTimeStr}}</span>
                    </div>
                    <input type="checkbox" data-id="{{Id}}">
                </div>
            </div>
        </a>
    </script>

    <script type="text/template" id="tmpl-list">
        <tr data-url="{{Url}}" data-type="{{Type}}" data-selected="{{Selected}}" data-id="{{Id}}">
            <td class="text-center">
                <input type="checkbox" data-id="{{Id}}">
            </td>
            <td scope="row">
                <div class="ratio ratio-4x3">
                    <div class="fm-miniature-list" style="background-image: url('/api/FileManMiniatures?filename={{EncodedUrl}}');">
                    </div>
                </div>
            </td>
            <td><a href="#" class="fm-col" data-url="{{Url}}" data-type="{{Type}}" data-fancybox="gal" data-selected="{{Selected}}" data-id="{{Id}}">{{Name}}</a></td>
            <td>{{FormattedLenght}}</td>
            <td>{{LastAccessTimeStr}}</td>
            <td>{{LastWriteTimeStr}}</td>
            <td>{{CreationTimeStr}}</td>
        </tr>
    </script>
    <!-- Classe FM_Viewer che gestisce la visualizzazione di file nel File Manager -->
    <script src="assets-2022/mb/FM_Viewer.js?v=1"></script>
    <!-- Classe MB_FileUpload che gestisce l'interfaccia con il controller FileUpload -->
    <script src="assets-2022/mb/MB_FileUpload.js"></script>

    <script>


        $(function () {
            $('.sidebar-toggle').on('click', function () {
                $('body').toggleClass('right-out-collapsed');
                Cookies.set('sidebar-collapsed', $(this).parents('.sidebar-offcanvas').hasClass('right-out-collapsed'))
            });
            if (Cookies.get('sidebar-collapsed') == 'true')
                $('body').addClass('right-out-collapsed');

            $('.sidebar-offcanvas [data-toggle="tab"]').on('show.bs.tab', function () {
                const $this = $(this);
                let theTitle = $this.text().trim();
                if (theTitle == 'I miei file')
                    theTitle = FileManager.myFiles.title;
                $('#tab-title').text(theTitle);
                const tab = $this.attr('href');

                $('[data-tab-show]')
                    .addClass('d-none');
                $('[data-tab-show="' + tab + '"]').removeClass('d-none');

                FileManager.currentTab = $(tab).attr('data-fm-tab');

            }).on('hide.bs.tab', function () {
                const tab = $(this).attr('href');
                $(tab).children().remove();
            });

            $('.active [data-toggle="tab"]').trigger('show.bs.tab');
        });

        (function (win, $) {
            "use strict";

            /**
             * ACESSO AL FILE SYSTEM DEL SERVER
             * */
            class MyFiles {
                constructor(root, container) {
                    this.root = root;
                    this.$container = container;
                    this._view = Cookies.get('fm_myfile_view') || 'grid';
                }
                root = "";
                files = null;
                history = [];
                currentFolder = 0;
                $container = null;
                _view = 'grid';

                get selected() {
                    let sel = [];
                    for (var i = 0; i < this.files.length; i++) {
                        if (this.files[i].Selected)
                            sel.push(this.files[i]);
                    }
                    return sel;
                }

                get title() {
                    let title = this.history[this.currentFolder].replace(this.root, '');
                    if (title == '')
                        title = 'I miei file';
                    return title;
                }

                get name() {
                    if (this.$container) {
                        return this.$container.attr('data-fm-tab');
                    }
                    return null;
                }

                get view() {
                    return this._view;
                }

                set view(value) {
                    this._view = value;
                    this.refresh();

                    Cookies.set('fm_myfile_view', value);
                }

                load(root) {

                    let r = root || this.root;
                    const self = this;
                    var settings = {
                        "url": "/api/FileMan?root=" + r,
                        "method": "GET",
                        "timeout": 0,
                    };
                    return new Promise((resolve, reject) => {
                        $.ajax(settings)
                            .done(function (response) {
                                self.files = response;
                                resolve(response);
                            });
                    })
                }

                goto(url) {
                    const self = this;
                    if (this.history.length > self.currentFolder + 1)
                        this.history.splice(self.currentFolder + 1, self.history.length - self.currentFolder);
                    this.history.push(url);
                    this.currentFolder = this.history.length - 1;
                    return new Promise((resolve, reject) => {
                        self.load(url).then((result) => {
                            resolve(result);
                        });
                    })
                }

                back() {
                    const self = this;
                    if (this.currentFolder > 0) {
                        this.currentFolder--;
                        return new Promise((resolve, reject) => {
                            self.load(self.history[self.currentFolder]).then((result) => {
                                resolve(result);
                            });
                        })
                    }
                }

                forward() {
                    const self = this;
                    if (this.currentFolder < this.history.length - 1) {
                        this.currentFolder++;
                        return new Promise((resolve, reject) => {
                            self.load(self.history[self.currentFolder]).then((result) => {
                                resolve(result);
                            });
                        })
                    }
                }

                reload() {
                    const self = this;

                    return new Promise((resolve) => {
                        self.load(self.history[self.currentFolder]).then((result) => {
                            self.render(result);
                            resolve(result);
                        });
                    })

                }

                render(result) {

                    this.$container.children().remove();

                    if (this.view == 'grid') {
                        const fmRow = $('<div />').addClass('fm-row-cols')
                        for (var i = 0; i < result.length; i++) {
                            let item = result[i];
                            let template;
                            if (item.Type == "Folder") {
                                template = $('#tmpl-folder').html();
                            } else if (item.Type == "ImageHandled" || item.Type == "Svg" || item.Type == "Png")
                                template = $('#tmpl-image').html();
                            else
                                template = $('#tmpl-file').html();
                            fmRow.append(Mustache.render(template, item));
                        }
                        this.$container.append(fmRow);
                    } else {
                        const tableTempl =
                            '    <table class="table table-condensed">' +
                            '        <thead>' +
                            '            <tr>' +
                            '                <th class="text-center" style="width:50px"><input type="checkbox" data-action="select-all"></th>' +
                            '                <th class="text-center" style="width:65px"><i class="fa fa-image" aria-hidden="true"></i></th>' +
                            '                <th>Nome</th>' +
                            '                <th class="text-center" title="Lunghezza" style="width:60px"><i class="fa fa-save"' +
                            '                        aria-hidden="true"></i></th>' +
                            '                <th class="text-center" title="Ultimo accesso" style="width:120px"><i class="fa fa-eye"' +
                            '                        aria-hidden="true"></i></th>' +
                            '                <th class="text-center" title="Ultima modifica" style="width:120px"><i class="fa fa-edit"' +
                            '                        aria-hidden="true"></i></th>' +
                            '                <th class="text-center" title="Creazione" style="width:80px"><i class="fa fa-camera"' +
                            '                        aria-hidden="true"></i></th>' +
                            '            </tr>' +
                            '        </thead>' +
                            '        <tbody>' +
                            '        </tbody>' +
                            '    </table>';
                        const $table = $(tableTempl);
                        const $tableBody = $table.find('tbody');
                        for (var i = 0; i < result.length; i++) {
                            let item = result[i];
                            $tableBody.append(Mustache.render($('#tmpl-list').html(), item));
                        }
                        this.$container.append($table);
                    }

                    const self = this;
                    // Gestione check box di selezione
                    $(':checkbox', this.$container).on('change', function () {
                        const $this = $(this);
                        if ($this.data('action') == 'select-all') {
                            let check = $this[0].checked;
                            $(':checkbox', this.$container).each((index, element) => {
                                element.checked = check;
                                $(element).parents('a,tr').attr('data-selected', check);
                                let id = $(element).attr('data-id');
                                self.selectItem(id, check);
                            });
                        } else {
                            $(this).parents('a,tr').attr('data-selected', this.checked);
                            let id = $(this).attr('data-id');
                            self.selectItem(id, this.checked);
                        }
                    }).on('click', function (e) { e.stopPropagation(); });
                    if ($('[data-selected="true"] input:checkbox').length)
                        $('[data-selected="true"] input:checkbox')[0].checked = true;

                    // Controllo bottoni di navigazione
                    if (this.history[this.currentFolder] == this.root)
                        $('[data-action="home"]').addClass('disabled');
                    else
                        $('[data-action="home"]').removeClass('disabled');

                    if (this.currentFolder == 0)
                        $('[data-action="back"]').addClass('disabled');
                    else
                        $('[data-action="back"]').removeClass('disabled');

                    if (this.currentFolder < this.history.length - 1)
                        $('[data-action="forward"]').removeClass('disabled');
                    else
                        $('[data-action="forward"]').addClass('disabled');

                    if (this.view == 'grid') {
                        $('[data-action="grid"]').addClass('disabled');
                        $('[data-action="list"]').removeClass('disabled');
                    }
                    else {
                        $('[data-action="grid"]').removeClass('disabled');
                        $('[data-action="list"]').addClass('disabled');
                    };

                    //Aggiorno titolo
                    $('.fm-title').text(this.title + ` (${self.files.length})`);
                }

                selectItem(itemId, trueOrFalse) {
                    for (var i = 0; i < this.files.length; i++) {
                        if (this.files[i].Id == itemId) {
                            this.files[i].Selected = trueOrFalse;
                            break;
                        }
                    }
                }

                refresh() {
                    this.render(this.files);
                }

            }

            /**
             * ELENCO IMMAGINI
             * */
            class FM_Image {
                constructor(root, container) {
                    this.root = root;
                    this.$container = container;
                    this._view = Cookies.get('fm_image_view') || 'grid';
                }
                root = "";
                files = null;
                //history = [];
                //selected = [];
                currentFolder = 0;
                $container = null;
                _view = 'grid';
                order = 'date';
                dir = 'desc';

                get selected() {
                    let sel = [];
                    for (var i = 0; i < this.files.length; i++) {
                        if (this.files[i].Selected)
                            sel.push(this.files[i]);
                    }
                    return sel;
                }

                get title() {
                    return 'Immagini';
                }

                get name() {
                    if (this.$container) {
                        return this.$container.attr('data-fm-tab');
                    }
                    return null;
                }

                get view() {
                    return this._view;
                }

                set view(value) {
                    this._view = value;
                    this.refresh();
                    Cookies.set('fm_image_view', value);
                }

                setOrder(order, dir) {
                    this.order = order;
                    this.dir = dir;
                    this.$container.children().remove();
                    const parent = this.$container.parent();
                    parent.spin();
                    this.load().then(() => {
                        parent.spin(false);
                    });

                };

                load(root, all) {
                    let allImage = all || false;
                    let max = allImage ? 0 : 300;
                    let r = root || this.root;
                    const self = this;
                    var settings = {
                        "url": "/api/FileManGetImages",
                        "method": "GET",
                        "timeout": 0,
                        "data": {
                            root: "",
                            order: self.order,
                            dir: self.dir,
                            max: max
                        }
                    };

                    return new Promise((resolve) => {
                        $.ajax(settings)
                            .done(function (response) {
                                self.files = response;
                                self.render(response).then(() => resolve(response));
                            });
                    })
                };


                render(result) {

                    this.$container.children().remove();
                    const self = this;
                    return new Promise(resolve => {
                        if (self.view == 'grid') {
                            const fmRow = $('<div />').addClass('fm-row-cols')
                            for (var i = 0; i < result.length; i++) {
                                let item = result[i];
                                let template = $('#tmpl-folder').html();
                                if (item.Type == "Folder") {
                                    template = $('#tmpl-folder').html();
                                } else if (item.Type == "ImageHandled" || item.Type == "Svg" || item.Type == "Png")
                                    template = $('#tmpl-image').html();
                                else
                                    template = $('#tmpl-file').html();
                                fmRow.append(Mustache.render(template, item));
                            }
                            self.$container.append(fmRow);
                        } else {
                            const tableTempl =
                                '    <table class="table table-condensed">' +
                                '        <thead>' +
                                '            <tr>' +
                                '                <th class="text-center" style="width:50px"><input type="checkbox" data-action="select-all"></th>' +
                                '                <th class="text-center" style="width:65px"><i class="fa fa-image" aria-hidden="true"></i></th>' +
                                '                <th>Nome</th>' +
                                '                <th class="text-center" title="Lunghezza" style="width:60px"><i class="fa fa-save"' +
                                '                        aria-hidden="true"></i></th>' +
                                '                <th class="text-center" title="Ultimo accesso" style="width:120px"><i class="fa fa-eye"' +
                                '                        aria-hidden="true"></i></th>' +
                                '                <th class="text-center" title="Ultima modifica" style="width:120px"><i class="fa fa-edit"' +
                                '                        aria-hidden="true"></i></th>' +
                                '                <th class="text-center" title="Creazione" style="width:80px"><i class="fa fa-camera"' +
                                '                        aria-hidden="true"></i></th>' +
                                '            </tr>' +
                                '        </thead>' +
                                '        <tbody>' +
                                '        </tbody>' +
                                '    </table>';
                            const $table = $(tableTempl);
                            const $tableBody = $table.find('tbody');
                            for (var i = 0; i < result.length; i++) {
                                let item = result[i];
                                $tableBody.append(Mustache.render($('#tmpl-list').html(), item));
                            }
                            self.$container.append($table);
                        }

                        // Gestione check box di selezione
                        $(':checkbox', self.$container).on('change', function () {
                            const $this = $(this);
                            if ($this.data('action') == 'select-all') {
                                let check = $this[0].checked;
                                $(':checkbox', this.$container).each((index, element) => {
                                    element.checked = check;
                                    $(element).parents('a,tr').attr('data-selected', check);
                                    let id = $(element).attr('data-id');
                                    self.selectItem(id, check);
                                });
                            } else {
                                $(this).parents('a,tr').attr('data-selected', this.checked);
                                let id = $(this).attr('data-id');
                                self.selectItem(id, this.checked);
                            }
                        }).on('click', function (e) { e.stopPropagation(); });
                        if ($('[data-selected="true"] input:checkbox').length)
                            $('[data-selected="true"] input:checkbox')[0].checked = true;

                        // Controllo bottoni di navigazione

                        if (self.view == 'grid') {
                            $('[data-action="grid-image"]').addClass('disabled');
                            $('[data-action="list-image"]').removeClass('disabled');
                        }
                        else {
                            $('[data-action="grid-image"]').removeClass('disabled');
                            $('[data-action="list-image"]').addClass('disabled');
                        };

                        switch (self.order + "-" + self.dir) {
                            case "alpha-asc":
                                $('[data-action="sort-image-name"] > i').removeClass('fa-sort-alpha-asc').addClass('fa-sort-alpha-desc');
                                break;
                            case "alpha-desc":
                                $('[data-action="sort-image-name"] > i').removeClass('fa-sort-alpha-desc').addClass('fa-sort-alpha-asc');
                                break;
                            case "date-asc":
                                $('[data-action="sort-image-date"] > i').removeClass('fa-sort-numeric-asc').addClass('fa-sort-numeric-desc');
                                break;
                            case "date-desc":
                                $('[data-action="sort-image-date"] > i').removeClass('fa-sort-numeric-desc').addClass('fa-sort-numeric-asc');
                                break;
                            default:
                        }

                        //Aggiorno titolo
                        $('.fm-title').text(this.title + ` (${self.files.length})`);
                        if (self.files.length == 300)
                            $('[data-action="load-all"]').removeClass('disabled');
                        else
                            $('[data-action="load-all"]').addClass('disabled');

                        resolve(true);
                    });


                }

                refresh() {
                    const self = this;
                    return new Promise(resolve => {
                        self.render(this.files).then(esito => resolve(esito));
                    })

                }

                selectItem(itemId, trueOrFalse) {
                    for (var i = 0; i < this.files.length; i++) {
                        if (this.files[i].Id == itemId) {
                            this.files[i].Selected = trueOrFalse;
                            break;
                        }
                    }
                }

            }


            /**
             * ELENCO FILE DI RECENTE ACCESSO
             * */
            class FM_Recents {
                constructor(max, container) {
                    this.max = max;
                    this.$container = container;
                }
                max = 50;
                files = null;

                get selected() {
                    let sel = [];
                    for (var i = 0; i < this.files.length; i++) {
                        if (this.files[i].Selected)
                            sel.push(this.files[i]);
                    }
                    return sel;
                }

                get title() {
                    return 'File recenti';
                }

                get name() {
                    if (this.$container) {
                        return this.$container.attr('data-fm-tab');
                    }
                    return null;
                }


                load() {

                    let r = this.root;
                    const self = this;
                    var settings = {
                        "url": "/api/FileManGetRecents",
                        "method": "GET",
                        "timeout": 0,
                        "data": {
                            max: self.max
                        }
                    };

                    return new Promise((resolve) => {
                        $.ajax(settings)
                            .done(function (response) {
                                self.files = response;
                                self.render(response);
                                resolve(response)
                            });
                    })
                };

                render(result) {

                    this.$container.children().remove();

                    const tableTempl =
                        '    <table class="table table-condensed">' +
                        '        <thead>' +
                        '            <tr>' +
                        '                <th class="text-center" style="width:50px"><input type="checkbox" data-action="select-all"></th>' +
                        '                <th class="text-center" style="width:65px"><i class="fa fa-image" aria-hidden="true"></i></th>' +
                        '                <th>Nome</th>' +
                        '                <th class="text-center" title="Lunghezza" style="width:60px"><i class="fa fa-save"' +
                        '                        aria-hidden="true"></i></th>' +
                        '                <th class="text-center" title="Ultimo accesso" style="width:120px"><i class="fa fa-eye"' +
                        '                        aria-hidden="true"></i></th>' +
                        '                <th class="text-center" title="Ultima modifica" style="width:120px"><i class="fa fa-edit"' +
                        '                        aria-hidden="true"></i></th>' +
                        '                <th class="text-center" title="Creazione" style="width:80px"><i class="fa fa-camera"' +
                        '                        aria-hidden="true"></i></th>' +
                        '            </tr>' +
                        '        </thead>' +
                        '        <tbody>' +
                        '        </tbody>' +
                        '    </table>';
                    const $table = $(tableTempl);
                    const $tableBody = $table.find('tbody');
                    for (var i = 0; i < result.length; i++) {
                        let item = result[i];
                        $tableBody.append(Mustache.render($('#tmpl-list').html(), item));
                    }
                    this.$container.append($table);

                    const self = this;
                    // Gestione check box di selezione
                    $(':checkbox', this.$container).on('change', function () {
                        const $this = $(this);
                        if ($this.data('action') == 'select-all') {
                            let check = $this[0].checked;
                            $(':checkbox', this.$container).each((index, element) => {
                                element.checked = check;
                                $(element).parents('a,tr').attr('data-selected', check);
                                let id = $(element).attr('data-id');
                                self.selectItem(id, check);
                            });
                        } else {
                            $(this).parents('a,tr').attr('data-selected', this.checked);
                            let id = $(this).attr('data-id');
                            self.selectItem(id, this.checked);
                        }

                    }).on('click', function (e) { e.stopPropagation(); });
                    if ($('[data-selected="true"] input:checkbox').length)
                        $('[data-selected="true"] input:checkbox')[0].checked = true;


                    //Aggiorno titolo
                    $('.fm-title').text(this.title + ` (${self.files.length})`);
                }

                selectItem(itemId, trueOrFalse) {
                    for (var i = 0; i < this.files.length; i++) {
                        if (this.files[i].Id == itemId) {
                            this.files[i].Selected = trueOrFalse;
                            break;
                        }
                    }
                }

            }

            /**
             * GESTIONE GLOBALE FILE MANAGER
             * */
            class FileManager {
                constructor(container, root, startfolder, viewerSelector) {
                    this.init(container, root, startfolder, viewerSelector);
                }
                $container = null;
                myFiles = null;
                recents = null;
                images = null;
                viewer = null;
                fileUpload = null;
                contextMenu = null;
                modalDirTree = null;
                _currentTab = 'myFiles';

                set currentTab(name) {
                    var name = name;
                    swal.fire('Caricamento in corso');
                    swal.showLoading();
                    const self = this;


                    if (name == self.myFiles.name) {
                        this.myFiles.reload().then(() => {
                            swal.close();
                        });
                    } else if (name == this.images.name) {
                        //self.images.$container.fadeOut();
                        this.images.load().then(() => {
                            swal.close();
                        });
                    } else if (name == this.recents.name) {
                        this.recents.load().then(() => {
                            swal.close();
                        })
                    }

                    this._currentTab = name;
                }

                get currentTab() {
                    return this._currentTab
                }

                get files() {
                    if (this.currentTab == this.myFiles.name)
                        return this.myFiles.files;
                    else if (this.currentTab == this.images.name)
                        return this.images.files;
                    else if (this.currentTab == this.recents.name)
                        return this.recents.files;
                    return [];
                }

                get selected() {
                    if (this.currentTab == this.myFiles.name)
                        return this.myFiles.selected;
                    else if (this.currentTab == this.images.name)
                        return this.images.selected;
                    else if (this.currentTab == this.recents.name)
                        return this.recents.selected;
                    return [];
                }

                init(container, root, startfolder, viewerSelector) {
                    const self = this;
                    this.$container = $(container);
                    this.myFiles = new MyFiles(root, this.$container.find('[data-fm-tab="myfiles"]'));
                    this.myFiles.goto(startfolder).then((result) => {
                        this.myFiles.render(result);
                    });
                    this.images = new FM_Image(root, this.$container.find('[data-fm-tab="images"]'));
                    this.recents = new FM_Recents(80, this.$container.find('[data-fm-tab="recents"]'))
                    this.viewer = new FM_Viewer(viewerSelector);
                    this.fileUpload = new MB_FileUpload("/api/FileUpload");
                    this.contextMenu = this.$container.find('.fm-context-menu');
                    this.modalDirTree = this.$container.find('.modal-dir-tree');
                    this.modalRename = this.$container.find('.modal-rename');

                    // Click e rightclick sui singoli file nelle lista
                    self.$container
                        .on('click', 'a[data-type]', function (event) {
                            const $this = $(this);
                            const type = $this.attr('data-type');
                            const url = $this.attr('data-url');
                            switch (type) {
                                case 'Folder':
                                    self.goto(url);
                                    break;
                                default:
                                    self.viewer.show($this.data('id'), self.files);
                                    break;
                            }
                        }).on('contextmenu', 'a[data-type]', function (e) {
                            const $this = $(this);
                            var id;
                            if (Number.isInteger($this.data('id')))
                                id = parseInt($this.data('id'));
                            else
                                return;

                            e.preventDefault();
                            var top = e.pageY - 10;
                            var left = e.pageX - 90;
                            self.contextMenu
                                .attr({
                                    'data-type': $this.attr('data-type'),
                                    'data-id': id
                                })
                                .css({
                                    top: top,
                                    left: left,
                                    position: 'fixed'
                                })
                                .find('[data-toggle="dropdown"]')
                                .click();

                        }).on('dragover', 'a[data-type]', function (e) {
                            e.preventDefault();
                            const $this = $(this);
                            const type = $this.attr('data-type');
                            const url = $this.attr('data-url');
                            switch (type) {
                                case 'Folder':
                                    $this.find('.fm-miniature').addClass('drag-over');
                                    break;
                                default:

                                    break;
                            }
                        })
                        .on('dragleave', 'a[data-type]', function () {
                            const $this = $(this);
                            const type = $this.attr('data-type');
                            const url = $this.attr('data-url');
                            switch (type) {
                                case 'Folder':
                                    $this.find('.fm-miniature').removeClass('drag-over');
                                    break;
                                default:

                                    break;
                            }
                        })
                        .on('drop', 'a[data-type="Folder"]', function (e) {
                            e.preventDefault();
                            e.stopPropagation();
                            const $this = $(this);
                            const type = $this.attr('data-type');
                            const url = $this.attr('data-url');
                            const files = e.originalEvent.dataTransfer.files;
                            self.myFiles.goto(url).then(result => {
                                self.myFiles.render(result);

                                if (files.length > 0) {
                                    self.fileUpload.uploadMulti(files, url, function () {
                                        self.reloadSecure(self);
                                    })
                                }
                            })
                        })
                        .on('dragover', e => e.preventDefault())
                        .on('drop', function (e) {
                            e.preventDefault();
                            const $this = $(this);
                            const url = self.myFiles.history[self.myFiles.currentFolder];
                            const files = e.originalEvent.dataTransfer.files;

                            if (files.length > 0) {
                                self.fileUpload.uploadMulti(e.originalEvent.dataTransfer.files, url, function () {
                                    self.reloadSecure(self);
                                })
                            }
                        });

                    // Azioni context menu
                    self.contextMenu.find('[data-action]').on('click', function () {
                        const $this = $(this);
                        const action = $this.data('action');
                        const id = parseInt($this.parents('.fm-context-menu').attr('data-id'))
                        const fileInfo = self.getById(id);
                        switch (action) {
                            case 'select-file':
                                self.resolve(fileInfo.Url);
                                break;
                            case 'rename-file':
                                self.renameWithConfirm(fileInfo);
                                break;
                            case 'move-file':
                                self.moveWithConfirm(fileInfo);
                                break;
                            case 'copy-file':
                                self.copy(fileInfo);
                                break;
                            case 'delete-file':
                                self.deleteWithConfirm(fileInfo);
                                break;
                            default:
                        }
                    });

                    // Selezione file da viewer
                    if (self.viewer.btnChoose) {
                        self.viewer.btnChoose.addEventListener('click', function () {
                            self.resolve(self.files[self.viewer.currentFile].Url);
                        });
                    }

                    // Bottoni di navigazione generale del File manager
                    $('[data-action]').on('click', function () {
                        const action = $(this).data('action');
                        switch (action) {
                            case 'home':
                                self.goto(self.myFiles.root);
                                break;
                            case 'forward':
                                self.forward();
                                break;
                            case 'back':
                                self.back();
                                break;
                            case 'new-folder':
                                self.newFolder();
                                break;
                            case 'grid':
                                self.myFiles.view = 'grid';
                                break;
                            case 'list':
                                self.myFiles.view = 'list';
                                break;
                            case 'grid-image':
                                self.images.view = 'grid';
                                break;
                            case 'list-image':
                                self.images.view = 'list';
                                break;
                            case 'sort-image-name':
                                if ($(this).children('i').hasClass('fa-sort-alpha-desc'))
                                    self.images.setOrder('alpha', 'desc');
                                else
                                    self.images.setOrder('alpha', 'asc');
                                break;
                            case 'sort-image-date':
                                if ($(this).children('i').hasClass('fa-sort-numeric-desc'))
                                    self.images.setOrder('date', 'desc');
                                else
                                    self.images.setOrder('date', 'asc');
                                break;
                            case 'load-all':
                                swal.fire('Caricamento in corso');
                                swal.showLoading();
                                self.images.load('', true).then(() => {
                                    setTimeout(() => {
                                        swal.close();
                                    }, 300)
                                });
                                break;
                            case 'upload':
                                let folder = self.myFiles.history[self.myFiles.currentFolder];
                                //self.fileUpload.getFileSingle(folder)
                                //    .then(filname => self.reload())
                                //    .catch(error => {
                                //        Swal.fire({
                                //            icon: 'error',
                                //            title: 'Errore!',
                                //            text: error
                                //        })
                                //    })
                                self.fileUpload.getFileMulti(folder, function () { self.reloadSecure(self) })
                                    .then(filname => self.reload())
                                    .catch(error => {
                                        Swal.fire({
                                            icon: 'error',
                                            title: 'Errore!',
                                            text: error
                                        })
                                    })
                                break;
                            case 'delete-selected':
                                self.deleteSelected();
                                break;
                            case 'copy-selected':
                                self.copySelected();
                                break;
                            default:
                        }
                    })
                };

                goto(url) {
                    const self = this;
                    self.myFiles.goto(url).then((result) => {
                        self.myFiles.render(result);
                    })
                }

                back() {
                    const self = this;
                    self.myFiles.back().then((result) => {
                        self.myFiles.render(result);
                    })
                }

                forward() {
                    const self = this;
                    self.myFiles.forward().then((result) => {
                        self.myFiles.render(result);
                    })
                }

                deleteWithConfirm(fileinfo) {
                    const self = this;
                    let msg;
                    if (fileinfo.Type == 'Folder')
                        msg = `La catella "${fileinfo.Name}" e tutti i file che contiene saranno eliminati definitivamente.`;
                    else
                        msg = `Il file "${fileinfo.Name}" sarà eliminato definitivamente.`;
                    Swal.fire({
                        icon: 'info',
                        title: 'Attenzione!',
                        text: 'Il file o la directory e il suo contenuto saranno eliminati definitivamente!',
                        showCancelButton: true,
                        confirmButtonText: 'Continua',
                        cancelButtonText: `Annulla`,
                    }).then((result) => {
                        /* Read more about isConfirmed, isDenied below */
                        if (result.isConfirmed) {
                            Swal.fire({
                                icon: 'warning',
                                title: "Confermi l'eliminatione dei file?",
                                showCancelButton: true,
                                confirmButtonText: 'Sì',
                                cancelButtonText: `No`
                            }).then(result => {
                                if (result.isConfirmed)
                                    self.delete(fileinfo)
                                        .then(() => self.reload())
                                        .catch(error => Swal.fire({
                                            icon: 'error',
                                            title: 'Errore!',
                                            text: error
                                        }))
                            });
                        }
                    })
                }

                deleteSelected() {
                    let sel = this.selected.slice();
                    if (sel.length == 0) {
                        swal.fire({
                            icon: 'warning',
                            title: 'Nessun file da cancellare'
                        })
                        return;
                    }
                    let cartelle = 0;
                    let fileitems = 0;
                    for (let i = 0; i < sel.length; i++) {
                        if (sel.Type == "Folder")
                            cartelle++;
                        else
                            fileitems++;
                    }
                    const self = this;
                    let msg = `Saranno eliminati in maniera definitiva ${fileitems} file e ${cartelle} directory con il loro contenuto.`;

                    Swal.fire({
                        icon: 'info',
                        title: 'Attenzione!',
                        text: msg,
                        showCancelButton: true,
                        confirmButtonText: 'Continua',
                        cancelButtonText: `Annulla`,
                    }).then((result) => {
                        /* Read more about isConfirmed, isDenied below */
                        if (result.isConfirmed) {
                            Swal.fire({
                                icon: 'warning',
                                title: `Confermi l'eliminatione di ${sel.length} elementi?`,
                                showCancelButton: true,
                                confirmButtonText: 'Sì',
                                cancelButtonText: `No`
                            }).then(result => {
                                if (result.isConfirmed)
                                    this.deleteRecursive(sel);
                            });
                        }
                    })
                }

                deleteRecursive(sel) {
                    const self = this;
                    let fileinfo = sel.pop();
                    this.delete(fileinfo)
                        .then(() => {
                            self.reload();
                            if (sel.length > 0)
                                this.deleteRecursive(sel);
                        })
                        .catch(error => Swal.fire({
                            icon: 'error',
                            title: 'Errore!',
                            text: error
                        }))
                }

                delete(fileinfo) {
                    const self = this;

                    var myHeaders = new Headers();
                    myHeaders.append("Content-Type", "application/json");
                    myHeaders.append("Authorization", "Bearer " + Cookies.get('MB_AuthToken'));

                    var raw = JSON.stringify({
                        "OperationStr": "Delete",
                        "Input": fileinfo.Url,
                        "Destination": ''
                    });

                    var requestOptions = {
                        method: 'POST',
                        headers: myHeaders,
                        body: raw,
                        redirect: 'follow'
                    };

                    return new Promise((resolve, reject) => {
                        fetch("/api/FileManOp", requestOptions)
                            .then(response => response.json())
                            .then(result => {
                                if (!result.success) {
                                    reject(result.msg);
                                } else {
                                    resolve(result.msg);
                                }
                            })
                            .catch(error => reject(error));
                    })

                }

                newFolder() {
                    const self = this;
                    this.getNewName({
                        Type: 'Folder',
                        Name: ''
                    }, 'Nome nuova cartella')
                        .then(name => {
                            if (name == '') return;
                            var myHeaders = new Headers();
                            myHeaders.append("Content-Type", "application/json");
                            myHeaders.append("Authorization", "Bearer " + Cookies.get('MB_AuthToken'));

                            var raw = JSON.stringify({
                                "OperationStr": "Create",
                                "Input": self.myFiles.history[self.myFiles.currentFolder],
                                "Destination": name
                            });

                            var requestOptions = {
                                method: 'POST',
                                headers: myHeaders,
                                body: raw,
                                redirect: 'follow'
                            };

                            fetch("/api/FileManOp", requestOptions)
                                .then(response => response.json())
                                .then(result => {
                                    if (!result.success) {
                                        Swal.fire({
                                            icon: 'error',
                                            title: 'Errore!',
                                            text: result.msg
                                        });
                                    } else {
                                        self.reload();
                                    }
                                })
                                .catch(error => Swal.fire({
                                    icon: 'error',
                                    title: 'Errore!',
                                    text: error
                                }));
                        }).catch(error => {
                            Swal.fire({
                                icon: 'error',
                                title: 'Errore!',
                                text: error
                            }).then(() => self.newFolder());
                        })
                }

                renameWithConfirm(fileinfo) {
                    const self = this;
                    Swal.fire({
                        title: 'Attenzione!',
                        text: 'Rinominare un file o una directory può interrompere collegamenti impostati in precedenza.',
                        showCancelButton: true,
                        confirmButtonText: 'Continua',
                        cancelButtonText: `Annulla`,
                    }).then((result) => {
                        /* Read more about isConfirmed, isDenied below */
                        if (result.isConfirmed) {
                            self.rename(fileinfo);
                        }
                    })
                }

                rename(fileinfo) {
                    const self = this;
                    this.getNewName(fileinfo, 'Rinomina il file')
                        .then(nome => {
                            nome = nome.trim();
                            if (nome == '' || nome == fileinfo.Name) return;

                            var myHeaders = new Headers();
                            myHeaders.append("Content-Type", "application/json");
                            myHeaders.append("Authorization", "Bearer " + Cookies.get('MB_AuthToken'));

                            var raw = JSON.stringify({
                                "OperationStr": "Rename",
                                "Input": fileinfo.Url,
                                "Destination": nome
                            });

                            var requestOptions = {
                                method: 'POST',
                                headers: myHeaders,
                                body: raw,
                                redirect: 'follow'
                            };

                            fetch("/api/FileManOp", requestOptions)
                                .then(response => response.json())
                                .then(result => {
                                    if (!result.success) {
                                        Swal.fire({
                                            icon: 'error',
                                            title: 'Errore!',
                                            text: result.msg
                                        })
                                            .then(() => self.rename(fileinfo));
                                    } else {
                                        self.reload();
                                    }
                                })
                                .catch(error => Swal.fire({
                                    icon: 'error',
                                    title: 'Errore!',
                                    text: error
                                }));
                        })
                        .catch(error => {
                            Swal.fire({
                                icon: 'error',
                                title: 'Errore!',
                                text: error
                            }).then(() => self.rename(fileinfo));
                        });
                }

                copySelected() {
                    let sel = this.selected.slice();
                    if (sel.length == 0) {
                        swal.fire({
                            icon: 'warning',
                            title: 'Nessun file da copiare'
                        })
                        return;
                    }
                    let cartelle = 0;
                    let fileitems = 0;
                    for (let i = 0; i < sel.length; i++) {
                        if (sel.Type == "Folder")
                            cartelle++;
                        else
                            fileitems++;
                    }
                    const self = this;

                    self.getDestination()
                        .then(destination => {
                            let msg = `${fileitems} file e ${cartelle} directory (con il loro contenuto) saranno copiati nella cartella ${destination}.`;

                            Swal.fire({
                                icon: 'info',
                                title: 'Attenzione!',
                                text: msg,
                                showCancelButton: true,
                                confirmButtonText: 'Continua',
                                cancelButtonText: `Annulla`,
                            }).then(result => {
                                if (result.isConfirmed) {
                                    self.copyRecursive(sel, destination);
                                }
                            })
                        })

                }

                copyRecursive(sel, destination) {
                    const self = this;
                    let fileinfo = sel.pop();
                    this.doCopy(fileinfo, destination)
                        .then(() => {
                            self.reload();
                            if (sel.length > 0)
                                this.copyRecursive(sel, destination);
                        })
                        .catch(error => Swal.fire({
                            icon: 'error',
                            title: 'Errore!',
                            text: error
                        }))
                }

                copy(fileinfo) {
                    const self = this;

                    self.getDestination()
                        .then(dest => {
                            swal.fire('Copia in corso');
                            swal.showLoading();
                            this.doCopy(fileinfo, dest)
                                .then(() => {
                                    swal.close();
                                    self.reload();
                                })
                                .catch(error => {
                                    Swal.fire({
                                        icon: 'error',
                                        title: 'Errore!',
                                        text: error
                                    })
                                })
                        })
                        .catch(error => {
                            Swal.fire({
                                title: "Errore",
                                text: error,
                                icon: 'error'
                            })
                        })
                }

                doCopy(fileinfo, destination) {
                    const self = this;
                    var myHeaders = new Headers();
                    myHeaders.append("Content-Type", "application/json");
                    myHeaders.append("Authorization", "Bearer " + Cookies.get('MB_AuthToken'));

                    var raw = JSON.stringify({
                        "OperationStr": "Copy",
                        "Input": fileinfo.Url,
                        "Destination": destination
                    });

                    var requestOptions = {
                        method: 'POST',
                        headers: myHeaders,
                        body: raw,
                        redirect: 'follow'
                    };

                    return new Promise((resolve, reject) => {
                        fetch("/api/FileManOp", requestOptions)
                            .then(response => response.json())
                            .then(result => {
                                swal.close();
                                if (!result.success) {
                                    reject(result.msg)
                                } else {
                                    resolve(result.msg);
                                }
                            })
                            .catch(error => {
                                swal.close();
                                reject(error);
                            });
                    });
                }

                moveWithConfirm(fileinfo) {
                    const self = this;
                    Swal.fire({
                        title: 'Attenzione!',
                        text: 'Spostare un file o una directory può interrompere collegamenti impostati in precedenza.',
                        showCancelButton: true,
                        confirmButtonText: 'Continua',
                        cancelButtonText: `Annulla`,
                    }).then((result) => {
                        /* Read more about isConfirmed, isDenied below */
                        if (result.isConfirmed) {
                            self.move(fileinfo)
                                .then(() => self.reload())
                                .catch(error => Swall.fire({
                                    icon: 'error',
                                    title: 'Errore!',
                                    text: error
                                }));
                        }
                    })
                }

                move(fileinfo) {
                    const self = this;
                    return new Promise((resolve, reject) => {
                        self.getDestination()
                            .then(dest => {
                                swal.fire('Spostamento in corso');
                                swal.showLoading();
                                var myHeaders = new Headers();
                                myHeaders.append("Content-Type", "application/json");
                                myHeaders.append("Authorization", "Bearer " + Cookies.get('MB_AuthToken'));

                                var raw = JSON.stringify({
                                    "OperationStr": "Move",
                                    "Input": fileinfo.Url,
                                    "Destination": dest
                                });

                                var requestOptions = {
                                    method: 'POST',
                                    headers: myHeaders,
                                    body: raw,
                                    redirect: 'follow'
                                };

                                fetch("/api/FileManOp", requestOptions)
                                    .then(response => response.json())
                                    .then(result => {
                                        swal.close();
                                        if (!result.success) {
                                            reject(result.msg)
                                        } else {
                                            resolve(result.msg);
                                        }
                                    })
                                    .catch(error => {
                                        swal.close();
                                        reject(error);
                                    });

                            })
                            .catch(error => {
                                Swal.fire({
                                    title: "Errore",
                                    text: error,
                                    icon: 'error'
                                })
                            })
                    });
                }


                resolve(fileUrl) {
                    var win;
                    var opener = $('#HF_Opener').val();
                    var fn = $('#HF_CallBack').val();

                    switch (opener) {
                        case 'ckeditor':
                            win = window.opener;
                            if (win.CKEDITOR)
                                win.CKEDITOR.tools.callFunction($('#HF_CKEditorFunctionNumber').val(), fileUrl);
                            break;
                        case 'opener':
                            win = window.opener;
                            win[fn](fileUrl);
                            break;
                        case 'parent':
                            win = window.parent;
                            win[fn](fileUrl);
                            break;
                        case 'top':
                            win = window.top;
                            win[fn](fileUrl);
                            break;
                        case 'tinymce4':
                            var params = window.parent.tinyMCE.activeEditor.windowManager.getParams();
                            var theField = window.parent.document.getElementById(params.field);
                            if (theField) {
                                theField.value = fileUrl;
                                window.parent.tinyMCE.activeEditor.windowManager.close();
                                return true;
                            }
                            break;
                        default:
                            alert(fileUrl);

                    }

                    if (fn == 'newWinFn')
                        return;

                    if (window.opener)
                        window.close();
                }

                getById(id) {
                    for (var i = 0; i < this.files.length; i++) {
                        if (this.files[i].Id == id)
                            return this.files[i];
                    }
                }

                getNewName(fileInfo, title) {
                    let t = title || 'Rinomina file';
                    this.modalRename.modal('show');
                    this.modalRename.find('.modal-title').html(title);
                    this.modalRename.find('input').val(fileInfo.Name);
                    const self = this;
                    return new Promise((resolve, reject) => {
                        this.modalRename.one('hidden.bs.modal', function (e) {
                            let nome = "";
                            if (self.modalRename.attr('data-ok')) {
                                self.modalRename.removeAttr('data-ok');
                                nome = self.modalRename.find('input').val();
                                var regex;
                                if (fileInfo.Type == 'Folder')
                                    regex = /^[\w,\s-]+[\.]{0,1}[A-Za-z]*$/g;
                                else
                                    regex = /^[\w,\s-]+[\.][A-Za-z]+$/g;
                                if (!regex.test(nome))
                                    reject('Nome di file o directory non valido!');
                                else
                                    resolve(nome);
                            } else
                                resolve(nome);
                        })
                    })
                }

                getDestination() {
                    this.modalDirTree.modal('show');
                    const modalBody = this.modalDirTree.find('.modal-body');
                    const self = this;
                    modalBody.spin();
                    return new Promise((resolve, reject) => {
                        var myHeaders = new Headers();
                        myHeaders.append("Authorization", "Bearer " + Cookies.get('MB_AuthToken'));

                        var requestOptions = {
                            method: 'GET',
                            headers: myHeaders,
                            redirect: 'follow'
                        };

                        fetch("/api/FileManGetDirTree2?root=" + $('#UserRoot').val(), requestOptions)
                            .then(response => response.json())
                            .then(result => {
                                modalBody.spin(false);
                                const dirTree = document.createElement('div');
                                dirTree.classList.add('w-100');
                                dirTree.classList.add('h-100');
                                $(dirTree).jstree({
                                    "core": {
                                        "data": result,
                                        "multiple": false
                                    }
                                }).appendTo(modalBody);
                                this.modalDirTree.one('hidden.bs.modal', function (e) {
                                    let cartella = "";
                                    if (self.modalDirTree.attr('data-ok')) {
                                        self.modalDirTree.removeAttr('data-ok');
                                        let selected = $(dirTree).jstree('get_selected');
                                        if (selected.length)
                                            cartella = selected[0];
                                    }
                                    $(dirTree).jstree('destroy').remove();
                                    resolve(cartella);
                                })
                            })
                            .catch(error => reject(error));
                    });
                }

                reload() {
                    this.currentTab = this.currentTab;
                }

                reloadSecure(self) {
                    self.currentTab = self.currentTab;
                }

            }
            win.FileManager = new FileManager('[data-ride="fm-container"]', $('#UserRoot').val(), $('#StartRoot').val(), '#theViewer');

        })(window, jQuery);
    </script>
</asp:Content>
