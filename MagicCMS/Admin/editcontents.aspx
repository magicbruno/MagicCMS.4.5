<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/MasterAdmin.master" AutoEventWireup="true"
    CodeBehind="editcontents.aspx.cs" Inherits="MagicCMS.Admin.editcontents" ValidateRequest="false"
    Culture="it-IT" UICulture="it" %>

<%@ MasterType TypeName="MagicCMS.Admin.MasterAdmin" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="assets-2022/css/file-man.css" rel="stylesheet" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="HeaderContent" runat="server">
    <h1><i class="fa fa-edit"></i><%= Master.Translate("Modifica i contenuti del sito") %></h1>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
    <!-- START Tabella contenuti con navigazione -->

    <div class="row">
        <div class="col">
            <asp:Panel runat="server" ID="Panel_contents" CssClass="box box-primary" data-id="Panel_contents">
                <div class="box-header">
                    <h3 class="box-title"><%= Master.Translate("Struttura del sito") %></h3>
                    <div class="box-tools pull-left dropdown">
                        <button data-action="add-element" type="button" class="btn btn-sm btn-success hidden" data-toggle="dropdown" data-taget="#">
                            <i class="fa fa-plus"></i><%= Master.Translate("aggiungi elemento figlio") %>
                        </button>
                        <ul id="dd-preferred" class="dropdown-menu">
                            <li>dummy</li>
                        </ul>
                    </div>
                    <div class="box-tools pull-right">
                        <button type="button" data-action="back" class="btn btn-sm btn-success btn-icon"
                            title="<%= Master.Translate("Back") %>">
                            <i class="fa fa-arrow-left"></i>
                        </button>
                        <button type="button" data-action="home" class="btn btn-sm btn-success btn-icon"
                            title="<%= Master.Translate("Root") %>">
                            <i class="fa fa-home"></i>
                        </button>
                        <button type="button" data-action="forward" class="btn btn-sm btn-success btn-icon"
                            title="<%= Master.Translate("Forward") %>">
                            <i class="fa fa-arrow-right"></i>
                        </button>
                        <button type="button" data-action="full" class="btn btn-sm btn-success btn-icon"
                            title="<%= Master.Translate("Mostra la lista di tutte le componenti del sito") %>">
                            <i class="fa fa-bars"></i>
                        </button>
                        <button type="button" data-action="inbasket" class="btn btn-sm btn-link btn-icon"
                            title="<%= Master.Translate("Mostra gli elementi nel cestino") %>">
                            <span class="fa-stack fa-lg" <%--style="font-size: 65%;"--%>>
                                <i class="fa fa-file-o fa-stack-2x text-success"></i>
                                <i class="fa text-info fa-recycle fa-stack" <%--style="font-size: .7em"--%>></i>
                            </span>
                        </button>                        
                        <button type="button" data-action="trash-multi" class="btn btn-sm btn-danger btn-icon"
                            title="<%= Master.Translate("Elimina pagine selezionate") %>">
                            <i class="fa fa-trash-o"></i>
                        </button>
                        <button type="button" data-action="erase-multi" class="btn btn-sm btn-link btn-icon"
                            title="<%= Master.Translate("Elimina definitivamente pagine selezionate") %>">
                            <span class="fa-stack fa-lg">
                                <i class="fa fa-trash-o fa-stack text-danger"></i>
                                <i class="fa fa-ban fa-stack-2x text-warning" <%--style="font-size: .7em"--%>></i>
                            </span>
                        </button>
                        <button type="button" class="btn btn-primary btn-sm" data-widget="collapse">
                            <i class="fa fa-minus"></i>
                        </button>
                    </div>
                </div>
                <div class="table-responsive">
                    <div class="box-body">
                        <table id="table_contenuti" class="table table-striped table-bordered" style="width: 100%" width="100%">
                            <thead>
                                <tr>
                                    <th>
                                        <input class="small" type="checkbox" id="th-checkbox" value="" data-action="check-all" /></th>
                                    <th><%= Master.Translate("Titolo") %></th>
                                    <th title="<%= Master.Translate("Immagine") %>"><i class="fa fa-image"></th>
                                    <th title="<%= Master.Translate("Pubblicato il") %>..."><i class="fa fa-newspaper-o text-info"></th>
                                    <th title="<%= Master.Translate("Data di scadenza") %>"><i class="fa fa-ban text-red"></th>
                                    <th title="<%= Master.Translate("Modificato il") %>..."><i class="fa fa-edit text-red"></th>
                                    <th title="<%= Master.Translate("Ordinamento") %>"><i class="fa fa-sort-numeric-asc"></i></th>
                                    <th><i class="fa fa-edit"></i></th>
                                    <th><i class="fa fa-trash-o"></i></th>
                                </tr>
                            </thead>
                            <tbody>
                            </tbody>
                        </table>
                    </div>
                </div>
            </asp:Panel>
        </div>
    </div>

    <!-- END Tabella contenuti con navigazione -->


    <!-- START Pannello di editing -->

    <div class="row">
        <div class="col">
            <asp:Panel runat="server" ID="Panel_edit" CssClass="box box-warning">
                <div class="box-header d-flex justify-content-between align-items-center py-1">
                    <h3 class="box-title mr-auto"><i class="fa <% = ThePost.TypeInfo.Icon %>"></i><% = PostEditTitle %>
                    </h3>
                    <div class="box-tools pull-right">
                        <button type="button" class="btn btn-danger btn-sm" data-toggle="modal" data-target="#cambia-tipo-modal"><i class="fa fa-exchange"></i>Cambia tipo post</button>
                        <button type="button" class="btn btn-success btn-sm btn-icon" title="Save" onclick="$('#edit-content [data-action=submit]').click();">
                            <i class="fa fa-save"></i>
                        </button>
                        <button type="button" class="btn btn-primary btn-sm" data-widget="collapse">
                            <i class="fa fa-minus"></i>
                        </button>
                    </div>
                </div>
                <div class="box-body">
                    <div class="nav-tabs-custom tabs-edit">
                        <ul class="nav nav-tabs">
                            <li class="active"><a href="#main-data" data-toggle="tab"><i class="text-danger fa fa-flash hidden"></i><%= Master.Translate("Dati") %></a></li>
                            <%--<li><a href="#parents-modal" data-toggle="modal">Parents</a></li>--%>
                            <li class="FlagTesti"><a href="#main-testi" data-toggle="tab"><%= Master.Translate("Testi") %></a></li>
                            <li><a href="#parents" data-toggle="tab"><%= Master.Translate("Parents") %></a></li>
                            <asp:Repeater ID="Repeter_Tabs" runat="server">
                                <ItemTemplate>
                                    <li>
                                        <a href="#lang-<%# DataBinder.Eval(Container, "DataItem.LangId") %>" data-toggle="tab">
                                            <i class="text-danger fa fa-flash hidden"></i><%# DataBinder.Eval(Container, "DataItem.LangName") %></a>
                                    </li>
                                </ItemTemplate>
                            </asp:Repeater>
                            <li class="pull-right"><a href="#help" data-toggle="tab" class="text-muted"><i class="fa fa-question-circle"></i>Help</a>
                            </li>
                            <li class="<%= !CmsConfig.TransAuto ? "d-none" : ""  %> pull-right"><a href="#text-translator" data-toggle="tab">Bing Translator</a></li>
                        </ul>
                        <div class="tab-content">
                            <!-- Main data -->
                            <div class="tab-pane active" id="main-data">
                                <div class="form-horizontal" role="form" data-ride="mb-form" data-action="Ajax/Edit.ashx"
                                    id="edit-content">
                                    <fieldset>
                                        <input type="hidden" id="Pk" name="Pk" value="<% = Pk.ToString() %>" />
                                        <input type="hidden" id="Tipo" name="Tipo" value="<% = ThePost.Tipo.ToString() %>" />
                                        <input type="hidden" id="Parents" name="Parents" value="<% = PostParents %>" />
                                        <input type="hidden" id="table" name="table" value="MB_contenuti" />
                                        <input type="hidden" id="reload-post" value="0" />
                                        <input type="hidden" id="open-post-in-window" value="0" />
                                        <input type="hidden" id="default-lang-id" value="<%= CmsConfig.TransSourceLangId %>" />
                                        <input type="hidden" id="TestoBreve" value="<%= ThePostEnc.TestoBreve %>" />
                                        <input type="hidden" id="TestoLungo" value="<%= ThePostEnc.TestoLungo %>" />

                                        <div class="form-group align-items-center Permalink" id="fg-permalink">
                                            <label for="PermalinkTitle" class="col-sm-2 control-label py-0">Permalink</label>
                                            <div class="col-auto pr-1">
                                                <%= PermalinkPrefix %>
                                            </div>
                                            <div class="col pl-0">
                                                <div class="input-group">
                                                    <input type="text" class="form-control" id="PermalinkTitle" value="<% = ThePost.PermalinkTitle %>" />
                                                    <span class="input-group-btn">
                                                        <button class="btn btn-icon btn-info btn-flat" type="button" data-action="open-post">
                                                            <i class="fa fa-external-link"></i>
                                                        </button>
                                                    </span>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="form-group" id="fg-titolo">
                                            <label for="Titolo" class="col-sm-2 control-label"><% = TypeInfo.LabelTitolo %></label>
                                            <div class="col-sm-10">
                                                <input type="text" class="form-control" id="Titolo" value="<% = ThePostEnc.Titolo %>" <% = NotActiveReadOnly %> />
                                            </div>
                                        </div>
                                        <div class="form-group FlagExtraInfo" id="fg-ExtraInfo">
                                            <label for="ExtraInfo" class="col-sm-2 control-label"><% = TypeInfo.LabelExtraInfo %></label>
                                            <div class="col-sm-10">
                                                <div class="input-group">
                                                    <input type="text" class="form-control" id="ExtraInfo" value="<% = ThePostEnc.ExtraInfo %>" />
                                                    <span class="input-group-btn FlagBtnGeolog">
                                                        <button class="btn btn-icon btn-success btn-flat" type="button" data-source="#ExtraInfo"
                                                            title="Calcola geolocazione<%= Master.Translate("Calcola geolocazione") %>" data-target="#map-dialog" data-toggle="modal">
                                                            <i class="fa fa-map-marker"></i>
                                                        </button>
                                                    </span>
                                                </div>
                                                <!-- /input-group -->
                                            </div>
                                        </div>
                                        <div class="form-group FlagExtraInfo1" id="fg-extrainfo1">
                                            <label for="ExtraInfo1" class="col-sm-2 control-label"><% = TypeInfo.LabelExtraInfo1 %></label>
                                            <div class="col-sm-10">
                                                <textarea class="form-control" id="ExtraInfo1" rows="2"><% = ThePost.ExtraInfo1 %></textarea>
                                            </div>
                                        </div>
                                        <div class="form-group FlagExtraInfo2" id="fg-ExtraInfo2">
                                            <label for="ExtraInfo2" class="col-sm-2 control-label"><% = TypeInfo.LabelExtraInfo2 %></label>
                                            <div class="col-sm-10">
                                                <input type="text" class="form-control" id="ExtraInfo2" value="<% = ThePostEnc.ExtraInfo2 %>" />
                                            </div>
                                        </div>
                                        <div class="form-group FlagExtraInfo3" id="fg-ExtraInfo3">
                                            <label for="ExtraInfo3" class="col-sm-2 control-label"><% = TypeInfo.LabelExtraInfo3 %></label>
                                            <div class="col-sm-10">
                                                <input type="text" class="form-control" id="ExtraInfo3" value="<% = ThePostEnc.ExtraInfo3 %>" />
                                            </div>
                                        </div>
                                        <div class="form-group FlagExtraInfo4" id="fg-ExtraInfo4">
                                            <label for="ExtraInfo4" class="col-sm-2 control-label"><% = TypeInfo.LabelExtraInfo4 %></label>
                                            <div class="col-sm-10">
                                                <input type="text" class="form-control" id="ExtraInfo4" value="<% = ThePostEnc.ExtraInfo4 %>" />
                                            </div>
                                        </div>
                                        <div class="form-group FlagUrl" id="fg-url">
                                            <label for="Url" class="col-sm-2 control-label"><% = TypeInfo.LabelUrl %></label>
                                            <div class="col-sm-10">
                                                <div class="input-group">
                                                    <input type="text" class="form-control" data-droptarget id="Url" value="<% = ThePostEnc.Url %>" />
                                                    <span class="input-group-btn">
                                                        <button class="btn btn-danger btn-flat FlagCercaServer" type="button" data-target="#Url"
                                                            title="<%= Master.Translate("Cerca il file sul tuo disco") %>" data-action="upload">
                                                            <i class="fa fa-folder-open-o"></i>Sfoglia...
                                                        </button>
                                                        <button class="btn btn-warning btn-flat btn-icon FlagCercaServer" type="button" data-callback="getUrl"
                                                            title="<%= Master.Translate("Cerca file sul server") %>"
                                                            data-target="#Url" data-toggle="fb-window" data-fm-url="FileManager.aspx">
                                                            <i class="fa fa-fw fa-database"></i>
                                                        </button>
                                                        <button class="btn btn-success btn-flat btn-icon" type="button" data-source="#Url"
                                                            title="<%= Master.Translate("Guarda il file") %>" data-action="viewer">
                                                            <i class="fa fa-eye"></i>
                                                        </button>
                                                    </span>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="form-group FlagUrlSecondaria" id="Div2">
                                            <label for="Url2" class="col-sm-2 control-label"><% = TypeInfo.LabelUrlSecondaria %></label>
                                            <div class="col-sm-10">
                                                <div class="input-group">
                                                    <input type="text" class="form-control" data-droptarget id="Url2" value="<% = ThePostEnc.Url2  %>" />
                                                    <span class="input-group-btn">
                                                        <button class="btn btn-danger btn-flat FlagCercaServer" type="button" data-target="#Url2"
                                                            title="<%= Master.Translate("Cerca il file sul tuo disco") %>" data-action="upload">
                                                            <i class="fa fa-folder-open-o"></i>Sfoglia...
                                                        </button>
                                                        <button class="btn btn-warning btn-flat btn-icon FlagCercaServer" type="button" data-callback="getUrl2"
                                                            title="<%= Master.Translate("Cerca file sul server") %>"
                                                            data-target="#Url2" data-toggle="fb-window" data-fm-url="FileManager.aspx">
                                                            <i class="fa fa-fw fa-database"></i>
                                                        </button>
                                                        <button class="btn btn-success btn-flat btn-icon" type="button" data-source="#Url2"
                                                            title="<%= Master.Translate("Guarda il file") %>" data-action="viewer">
                                                            <i class="fa fa-eye"></i>
                                                        </button>
                                                    </span>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="form-group FlagExtraInfo5" id="fg-ExtraInfo5">
                                            <label for="ExtraInfo5" class="col-sm-2 control-label"><% = TypeInfo.LabelExtraInfo_5 %></label>
                                            <div class="col-sm-10">
                                                <textarea class="form-control" id="ExtraInfo5" rows="2"><% = ThePostEnc.ExtraInfo5 %></textarea>
                                            </div>
                                        </div>
                                        <div class="form-group FlagExtraInfo6" id="fg-ExtraInfo6">
                                            <label for="ExtraInfo6" class="col-sm-2 control-label"><% = TypeInfo.LabelExtraInfo_6 %></label>
                                            <div class="col-sm-10">
                                                <textarea class="form-control" id="ExtraInfo6" rows="2"><% = ThePostEnc.ExtraInfo6 %></textarea>
                                            </div>
                                        </div>
                                        <div class="form-group FlagExtraInfo7" id="fg-ExtraInfo7">
                                            <label for="ExtraInfo7" class="col-sm-2 control-label"><% = TypeInfo.LabelExtraInfo_7 %></label>
                                            <div class="col-sm-10">
                                                <textarea class="form-control" id="ExtraInfo7" rows="2"><% = ThePostEnc.ExtraInfo7 %></textarea>
                                            </div>
                                        </div>
                                        <div class="form-group FlagExtraInfo8" id="fg-ExtraInfo8">
                                            <label for="ExtraInfo8" class="col-sm-2 control-label"><% = TypeInfo.LabelExtraInfo_8 %></label>
                                            <div class="col-sm-10">
                                                <textarea class="form-control" id="ExtraInfo8" rows="2"><% = ThePostEnc.ExtraInfo8 %></textarea>
                                            </div>
                                        </div>
                                        <div class="form-group FlagTags" id="fg-tags">
                                            <label for="ProcessParoleChiaveo_PK" class="col-sm-2 control-label"><%= Master.Translate("Parole chiave") %></label>
                                            <div class="col-sm-10">
                                                <input type="hidden" class="form-control" id="Tags" value="<% = ThePostEnc.Tags %>" />
                                            </div>
                                        </div>

                                        <hr class="FlagExtraInfoNumberAll" />
                                        <div class="form-group FlagExtraInfoNumberAll" id="fg-floats">
                                            <div class="col-md-6 col-lg d-flex flex-nowrap no-gutters FlagExtraInfoNumber_1">
                                                <label for="ExtraInfoNumber2" class="col-auto control-label pr-2 ">
                                                    <%=TypeInfo.LabelExtraInfoNumber_1 %>
                                                </label>
                                                <div class="col-lg col-md-6">
                                                    <input type="text" class="form-control float" id="ExtraInfoNumber1"
                                                        value="<% = ThePost.ExtraInfoNumber1.ToString() %>" />
                                                </div>
                                            </div>
                                            <div class="col-md-6 col-lg d-flex flex-nowrap no-gutters FlagExtraInfoNumber_2">
                                                <label for="ExtraInfoNumber2" class="col-auto control-label pr-2 ">
                                                    <%=TypeInfo.LabelExtraInfoNumber_2 %>
                                                </label>
                                                <div class="col-lg col-md-6">
                                                    <input type="text" class="form-control float" id="ExtraInfoNumber2"
                                                        value="<% = ThePost.ExtraInfoNumber2.ToString() %>" />
                                                </div>
                                            </div>
                                            <div class="col-md-6 col-lg d-flex flex-nowrap no-gutters FlagExtraInfoNumber_3">
                                                <label for="ExtraInfoNumber3" class="col-auto control-label pr-2">
                                                    <%=TypeInfo.LabelExtraInfoNumber_3 %>
                                                </label>
                                                <div class="col-lg col-md-6 ">
                                                    <input type="text" class="form-control float " id="ExtraInfoNumber3"
                                                        value="<% = ThePost.ExtraInfoNumber3.ToString() %>" />
                                                </div>
                                            </div>
                                            <div class="col-md-6 col-lg d-flex flex-nowrap no-gutters FlagExtraInfoNumber_4">
                                                <label for="ExtraInfoNumber4" class="col-auto control-label pr-2">
                                                    <%=TypeInfo.LabelExtraInfoNumber_4 %>
                                                </label>
                                                <div class="col-lg col-md-6">
                                                    <input type="text" class="form-control float" id="ExtraInfoNumber4"
                                                        value="<% = ThePost.ExtraInfoNumber4.ToString() %>" />
                                                </div>
                                            </div>
                                            <div class="col-md-6 col-lg d-flex flex-nowrap no-gutters FlagExtraInfoNumber_5">
                                                <label for="ExtraInfoNumber5" class="col-auto control-label pr-2">
                                                    <%=TypeInfo.LabelExtraInfoNumber_5 %>
                                                </label>
                                                <div class="col-lg col-md-6">
                                                    <input type="text" class="form-control float" id="ExtraInfoNumber5"
                                                        value="<% = ThePost.ExtraInfoNumber5.ToString() %>" />
                                                </div>
                                            </div>
                                            <div class="col-md-6 col-lg d-flex flex-nowrap no-gutters FlagExtraInfoNumber_6">
                                                <label for="ExtraInfoNumber6" class="col-auto control-label pr-2">
                                                    <%=TypeInfo.LabelExtraInfoNumber_6 %>
                                                </label>
                                                <div class="col-lg col-md-6 ">
                                                    <input type="text" class="form-control float" id="ExtraInfoNumber6"
                                                        value="<% = ThePost.ExtraInfoNumber6.ToString() %>" />
                                                </div>
                                            </div>
                                            <div class="col-md-6 col-lg d-flex flex-nowrap no-gutters FlagExtraInfoNumber_7">
                                                <label for="ExtraInfoNumber7" class="col-auto control-label pr-2">
                                                    <%=TypeInfo.LabelExtraInfoNumber_7 %>
                                                </label>
                                                <div class="col-lg col-md-6 ">
                                                    <input type="text" class="form-control float" id="ExtraInfoNumber7"
                                                        value="<% = ThePost.ExtraInfoNumber7.ToString() %>" />
                                                </div>
                                            </div>
                                            <div class="col-md-6 col-lg d-flex flex-nowrap no-gutters FlagExtraInfoNumber_8">
                                                <label for="ExtraInfoNumber8" class="col-auto control-label pr-2">
                                                    <%=TypeInfo.LabelExtraInfoNumber_8 %>
                                                </label>
                                                <div class="col-lg col-md-6">
                                                    <input type="text" class="form-control float" id="ExtraInfoNumber8"
                                                        value="<% = ThePost.ExtraInfoNumber8.ToString() %>" />
                                                </div>
                                            </div>
                                        </div>

                                        <!-- Dimensioni date e ordinamento -->
                                        <hr />
                                        <div class="form-group" id="fg-data-dimensioni">
                                            <label for="Ordinamento" class="col-sm-auto control-label"><%= Master.Translate("Ordine") %></label>
                                            <div class="col-lg col-md-4">
                                                <input type="text" class="form-control" id="Ordinamento" value="<% = ThePost.Ordinamento.ToString() %>" />
                                            </div>
                                            <label for="Larghezza" class="col-sm-auto control-label FlagLarghezza">
                                                <% = TypeInfo.LabelLarghezza %></label>
                                            <div class="col-lg col-md-4  FlagLarghezza">
                                                <input type="text" class="form-control" id="Larghezza" value="<% = ThePost.Larghezza.ToString() %>" />
                                            </div>
                                            <label for="Altezza" class="col-sm-auto control-label FlagAltezza"><% = TypeInfo.LabelAltezza %></label>
                                            <div class="col-lg col-md-4  FlagAltezza">
                                                <input type="text" class="form-control" id="Altezza" value="<% = ThePost.Altezza.ToString() %>" />
                                            </div>
                                            <label for="DataPubblicazione" class="col-sm-auto control-label"><%= Master.Translate("Data pubblicazione") %></label>
                                            <div class="col-lg col-md-4 ">
                                                <div class="input-group date">
                                                    <input type="text" data-dateiso="<% = DataPubblicazioneStr %>" class="form-control datepicker" id="DataPubblicazione" value="" />
                                                    <span class="input-group-btn">
                                                        <button class="btn btn-flat btn-primary btn-icon" type="button">
                                                            <i class="fa fa-calendar"></i>
                                                        </button>
                                                    </span>
                                                </div>
                                            </div>
                                            <label for="DataScadenza" class="col-sm-auto control-label FlagScadenza"><% = TypeInfo.LabelScadenza %></label>
                                            <div class="col-lg col-md-4 FlagScadenza">
                                                <div class="input-group date">
                                                    <input type="text" data-dateiso="<% = DataScadenzaStr %>" class="form-control datepicker" id="DataScadenza" value="" />
                                                    <span class="input-group-btn">
                                                        <button class="btn btn-flat btn-primary btn-icon" type="button">
                                                            <i class="fa fa-calendar"></i>
                                                        </button>
                                                    </span>
                                                </div>
                                            </div>
                                        </div>
                                        <hr />
                                        <!-- /Dimensioni date e ordinamento -->

                                        <div class="form-group">
                                            <div class="col-sm-12 text-center">
                                                <button type="button" class="btn btn-warning" data-action="duplicate"><%= Master.Translate("Crea duplicato") %></button>
                                                <button data-target="#preview-modal" data-toggle="modal" type="button" class="btn btn-info" data-action="show-record"><%= Master.Translate("Anteprima") %></button>
                                                <%--<button data-target="#preview-modal"  data-toggle="modal" type="button" class="btn btn-info" data-action="show-in-parent">Mostra nel contenitore</button>--%>
                                                <button type="button" class="btn btn-primary" data-action="submit">
                                                    <%= Master.Translate("Salva e pubblica") %></button>
                                            </div>
                                        </div>
                                        <%--<div class="alert"></div>--%>
                                    </fieldset>
                                </div>
                            </div>
                            <!-- /main-data -->

                            <!-- Testi post -->
                            <div class="tab-pane" id="main-testi">
                                <div class='box box-success <% = FlagBreve %>'>
                                    <div class='box-header'>
                                        <h3 class='box-title'><% = TypeInfo.LabelTestoBreve %></h3>
                                        <!-- tools box -->
                                        <div class="pull-right box-tools">
                                            <button class="btn btn-success btn-sm" data-widget='collapse' data-toggle="tooltip"
                                                title="Comprimi" type="button">
                                                <i class="fa fa-minus"></i>
                                            </button>
                                        </div>
                                        <!-- /. tools -->
                                    </div>
                                    <!-- /.box-header -->
                                    <div class='box-body pad'>
                                        <textarea id="TestoBreve-ck" name="TestoBreve" rows="10" class="ckeditor_mcms <% = FlagBreve %>"><% = ThePostEnc.TestoBreve %></textarea>
                                    </div>
                                </div>
                                <div class='box box-info <% = FlagFull %>'>
                                    <div class='box-header'>
                                        <h3 class='box-title'><% = TypeInfo.LabelTestoLungo %></h3>
                                        <!-- tools box -->
                                        <div class="pull-right box-tools">
                                            <button class="btn btn-info btn-sm" data-widget='collapse' data-toggle="tooltip"
                                                title="<%= Master.Translate("Comprimi") %>" type="button">
                                                <i class="fa fa-minus"></i>
                                            </button>
                                        </div>
                                        <!-- /. tools -->
                                    </div>
                                    <!-- /.box-header -->
                                    <div class='box-body pad'>
                                        <textarea id="TestoLungo-ck" name="TestoLungo" rows="10" class="ckeditor_mcms <% = FlagFull %>"><% = ThePostEnc.TestoLungo %></textarea>
                                    </div>
                                </div>

                            </div>

                            <!-- /Testi post -->

                            <!-- Parents -->
                            <div class="tab-pane" id="parents">
                                <div class="parents-tree" id="parents-tree">
                                </div>
                            </div>
                            <!-- /Parents -->

                            <!-- Text translator -->
                            <div class="tab-pane" id="text-translator">
                                <div class='box box-success <% = FlagBreve %>'>
                                    <div class='box-header d-flex align-items-center py-1'>
                                        <h3 class='box-title'>form </h3>
                                        <select id="select-from-lang" class="form-control selectpicker" data-live-search="true">
                                            <asp:Repeater ID="RepeaterFrom" runat="server" ItemType="ListItem">
                                                <ItemTemplate>
                                                    <option <%# Item.Value == CmsConfig.TransSourceLangId ? "selected" : "" %> value="<%# Item.Value %>">
                                                        <%# Item.Text %>
                                                    </option>
                                                </ItemTemplate>
                                            </asp:Repeater>
                                        </select>
                                        <!-- tools box -->
                                        <div class="pull-right box-tools">
                                            <button class="btn btn-success btn-sm" data-widget='collapse' data-toggle="tooltip"
                                                title="Comprimi" type="button">
                                                <i class="fa fa-minus"></i>
                                            </button>
                                        </div>
                                        <!-- /. tools -->
                                    </div>
                                    <!-- /.box-header -->
                                    <div class='box-body pad'>
                                        <textarea id="text-translator-from" name="TestoBreve" rows="10" class="ckeditor_mcms"></textarea>
                                    </div>
                                </div>
                                <div class='box box-info'>
                                    <div class='box-header d-flex align-items-center py-1'>
                                        <h3 class='box-title'>to </h3>
                                        <select id="select-to-lang" class="form-control selectpicker" data-live-search="true">
                                            <asp:Repeater ID="RepeaterTo" runat="server" ItemType="ListItem">
                                                <ItemTemplate>
                                                    <option <%# Item.Value == CmsConfig.TransSourceLangId ? "selected" : "" %> value="<%# Item.Value %>"><%# Item.Text %></option>
                                                </ItemTemplate>
                                            </asp:Repeater>
                                        </select>
                                        <!-- tools box -->
                                        <div class="pull-right box-tools">
                                            <button class="btn btn-info btn-sm" data-widget='collapse' data-toggle="tooltip"
                                                title="<%= Master.Translate("Comprimi") %>" type="button">
                                                <i class="fa fa-minus"></i>
                                            </button>
                                        </div>
                                        <!-- /. tools -->
                                    </div>
                                    <!-- /.box-header -->
                                    <div class='box-body pad'>
                                        <textarea id="text-translator-to" name="text-translator-to" rows="10" class="ckeditor_mcms"></textarea>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <div class="col-12 text-center">
                                        <button type="button" <%# !CmsConfig.TransAuto ? "disabled" : ""  %> class="btn btn-info btn-sm"
                                            data-action="translate-text">
                                            <% = Master.Translate("Traduci")  %></button>
                                        <button type="button" class="btn btn-danger btn-sm" data-action="clear-translation">
                                            <% = Master.Translate("Svuota testo")  %></button>
                                    </div>
                                </div>

                            </div>

                            <!-- /Testi post -->

                            <asp:Repeater ID="RepeaterLanguages" runat="server" ItemType="MagicCMS.Core.MagicTranslation">
                                <ItemTemplate>
                                    <div class="tab-pane" id="lang-<%# Item.LangId %>">
                                        <div class="form-horizontal" role="form" data-ride="mb-form" data-action="Ajax/Edit.ashx"
                                            id="edit-lang-<%# Item.LangId %>">
                                            <fieldset>
                                                <input type="hidden" name="LangId" value="<%# Item.LangId %>" />
                                                <input type="hidden" name="table" value="ANA_TRANSLATION" />
                                                <input type="hidden" name="PostPk" value="<% = Pk.ToString() %>" />
                                                <div class="form-group align-items-center Permalink" id="fg-permalink">
                                                    <label for="PermalinkTitle" class="col-sm-2 control-label py-0">Permalink</label>
                                                    <div class="col-auto pr-1">
                                                        <%# "/" + Item.LangId + "/[contenitore/]"  %>
                                                    </div>
                                                    <div class="col pl-0">
                                                        <input type="text" class="form-control" name="PermalinkTitle" id="PermalinkTitle-<%# Item.LangId %>"
                                                            value="<%# Item.PermalinkTitle %>" />
                                                    </div>
                                                </div>
                                                <div class="form-group">
                                                    <label for="Titolo-<%# Item.LangId %>" class="col-md-2 control-label">
                                                        <%= TypeInfo.LabelExtraInfo1 %></label>
                                                    <div class="col-md">
                                                        <textarea rows="2" class="form-control" id="Titolo<%# DataBinder.Eval(Container, "DataItem.LangId") %>"
                                                            name="TranslatedTitle"><%# DataBinder.Eval(Container, "DataItem.TranslatedTitle") %></textarea>
                                                    </div>
                                                </div>
                                                <div class="form-group <% = FlagBreve %>">
                                                    <label for="TestoBreve-<%# Item.LangId %>" class="col-md-2 control-label">
                                                        <%# TypeInfo.LabelTestoBreve %></label>
                                                    <div class="col-md">
                                                        <textarea name="TranslatedTestoBreve" rows="10" class="ckeditor_mcms <% = FlagBreve %>"><%# System.Web.HttpUtility.HtmlEncode(DataBinder.Eval(Container, "DataItem.TranslatedTestoBreve").ToString()) %></textarea>
                                                    </div>
                                                </div>
                                                <div class="form-group <% = FlagFull %>">
                                                    <label for="TestoLungo-<%# Item.LangId %>" class="col-md-2 control-label">
                                                        <%# TypeInfo.LabelTestoLungo %></label>
                                                    <div class="col-md">
                                                        <textarea name="TranslatedTestoLungo" rows="10" class="ckeditor_mcms <% = FlagFull %>"><%# System.Web.HttpUtility.HtmlEncode(DataBinder.Eval(Container, "DataItem.TranslatedTestoLungo").ToString()) %></textarea>
                                                    </div>
                                                </div>
                                                <div class="form-group <% = FlagTags %>" id="fg-tags">
                                                    <label for="" class="col-md-2 control-label"><%= Master.Translate("Parole chiave") %></label>
                                                    <div class="col-md">
                                                        <input type="hidden" class="form-control" name="TranslatedTags" value="<%# Item.TranslatedTags%>" />
                                                    </div>
                                                </div>
                                                <div class="form-group">
                                                    <div class="col-12 text-center">
                                                        <button type="button" class="btn btn-primary btn-sm" data-action="submit">
                                                            <% = Master.Translate("Salva traduzione") %></button>
                                                        <button type="button" <%# !CmsConfig.TransAuto ? "disabled" : ""  %> class="btn btn-info btn-sm"
                                                            data-action="translate">
                                                            <% = Master.Translate("Traduci con Bing")  %></button>
                                                        <button type="button" class="btn btn-danger btn-sm" data-action="delete-translation">
                                                            <% = Master.Translate("Elimina traduzione")  %></button>
                                                    </div>
                                                </div>
                                            </fieldset>
                                        </div>
                                    </div>
                                </ItemTemplate>
                            </asp:Repeater>
                            <div class="tab-pane" id="help">
                                <% = TypeInfo.Help %>
                            </div>
                        </div>
                    </div>
                </div>
            </asp:Panel>
        </div>
    </div>

    <!-- Select per ricerca per tipo -->
    <div class="d-none">
        <div class="d-flex align-items-center mb-4 mb-md-0" id="select-tipo-container">
            <label class="mr-3 mb-0">Tipo:</label>
            <select class="form-control selectpicker" data-container="body" id="select-search-tipi">
                <option data-icon="" value="">Tutti</option>
                <asp:Repeater ID="RepeaterSearchTipi" runat="server" ItemType="MagicCMS.Core.MagicPostTypeInfo">
                    <ItemTemplate>
                        <option data-icon="<%# Item.Icon %>" value="<%# Item.Nome %>"><%# Item.Nome %></option>
                    </ItemTemplate>
                </asp:Repeater>
            </select>
        </div>
    </div>

    <!-- Fine ricerca per tipo -->

    <!-- Parents Modal  -->
    <div class="modal fade" id="cambia-tipo-modal" tabindex="-1" role="dialog" aria-labelledby="Types"
        aria-hidden="true" data-source="">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">
                        <span aria-hidden="true">&times;</span><span
                            class="sr-only">Close</span></button>
                    <h4 class="modal-title">Modifica il tipo del post</h4>
                </div>
                <div class="modal-body">
                    <h3>Avvertenze</h3>
                    <p>
                        Cambiare tipo può nascondere informazioni inserite in precedenza. Le informazione non vengono eliminate. 
                        Per recuperarle basta ripristinare il veccio tipo.
                    </p>
                    <p class="mb-4">Per completare l'operazione è necessarrio salvare e ricaricare i contenuti della pagina.</p>
                    <select class="form-control selectpicker mb-4" id="select-elenco-tipi">
                        <asp:Repeater ID="RepeaterElencoTipi" runat="server" ItemType="MagicCMS.Core.MagicPostTypeInfo">
                            <ItemTemplate>
                                <option data-icon="<%# Item.Icon %>" value="<%# Item.Pk %>" <%# Item.Pk == ThePost.Tipo ? "selected" : "" %>><%# Item.Nome %></option>
                            </ItemTemplate>
                        </asp:Repeater>
                    </select>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-success btn-sm" data-action="save-and-reload">
                        Sarva e ricarica</button>
                    <button type="button" class="btn btn-danger btn-sm" data-dismiss="modal">
                        Annulla</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Preview Modal  -->
    <div class="modal fade" id="preview-modal" tabindex="-1" role="dialog" aria-labelledby="Types"
        aria-hidden="true" data-backdrop="static" data-source="">
        <div class="modal-dialog modal-xl">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">
                        <span aria-hidden="true">&times;</span><span
                            class="sr-only">Close</span></button>
                    <h4 class="modal-title"></h4>
                </div>
                <div class="modal-body">
                </div>
                <%--				<div class="modal-footer">
					<button type="button" class="btn btn-danger btn-sm" data-dismiss="modal">
					Chiudi</button>
				</div>--%>
            </div>
        </div>
    </div>

    <!-- Viewer -->

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

    <!-- END Pannello di editing -->


</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="Scripts" runat="server">
    <!-- START script Pannello di editing  blocco 1 Viewer e Upload-->
    <script src="assets-2022/mb/FM_Viewer.js?v=2"></script>
    <script src="assets-2022/mb/MB_FileUpload.js"></script>
    <script>
        (function (win, $) {
            win.TheViewer = new FM_Viewer('#theViewer');
            win.TheUploader = new MB_FileUpload('/api/FileUpload');
        })(window, jQuery);
    </script>
    <!-- END script Pannello di editing  blocco 1-->

    <!-- START script Tablella  blocco 1 -->

    <script id="table-cont-parent" type="x-tmpl-mustache">
        <div class="row no-gutters title">
            <div class="col-auto px-2"><i class="fa {{Icon}} text-primary"></i></div>
            <div class="col"><a href="#" data-action="goto" data-rowtitle="{{Titolo}}" data-rowpk="{{Pk}}" data-order="{{ExtraInfo}}" data-icon="{{Icon}}" title="{{Titolo}} ({{NomeTipo}})">{{Titolo}}</a>
            <br /><small>{{NomeTipo}}</small></div>
        </div>
    </script>

    <script id="table-cont-child" type="x-tmpl-mustache">
        <div class="row no-gutters title">
            <div class="col-auto px-2"><i class="fa {{Icon}}" ></i></div>
            <div class="col"><span data-rowpk="{{Pk}}" title="{{Titolo}} ({{NomeTipo}})">{{Titolo}}</span>
            <br /><small>{{NomeTipo}}</small></div>
        </div>
    </script>

    <script>
        var tableContentHistory;
        $form_contents = $('#edit-content');
        /** 
        ------------- TableStatus -------------
        Define table status (filter an order) memorized in TableHistory
        **/
        var TableStatus = function (parentId, order, name) {
            this.parent = parentId;
            this.setOrder(order);
            this.page = 0;
            this.setName(name);
        }
        TableStatus.prototype = {
            parent: 0,
            order: [6, 'asc'],
            page: 0,
            name: 'Root',
            search: '',
            setName: function (name) {
                if (this.parent == 0)
                    this.name = "Root";
                else
                    this.name = name;
            },
            setOrder: function (order) {
                if (order.constructor === Array)
                    this.order = order;
                else {
                    switch (order.toUpperCase().trim()) {
                        case "ALPHA ASC":
                        case "ALPHA":
                            order = [1, 'asc'];
                            break;

                        case "ALPHA DESC":
                            order = [1, 'desc'];
                            break;

                        case "DESC":
                            order = [6, 'desc'];
                            break;

                        case "ASC":
                            order = [6, 'asc'];
                            break;

                        case "DATA DESC":
                        case "DESC DATA":
                            order = [3, 'desc'];
                            break;

                        case "DATA ASC":
                        case "ASC DATA":
                            order = [3, 'asc'];
                            break;

                        case "DATAMODIFICA DESC":
                        case "DESC DATAMODIFICA":
                            order = [5, 'asc'];
                            break;

                        case "DATAMODIFICA ASC":
                        case "ASC DATAMODIFICA":
                            order = [5, 'desc'];
                            break;

                        default:
                            order = [6, 'asc'];
                            break;
                    }

                }
            }
        };

        /**
        ************** Hndlers for Filebrowser ********************
        **/
        function getUrl(url) {
            $('#Url').val(url).change();
            $('#FileBrowserModal').modal('hide');
        }

        function getUrl2(url) {
            $('#Url2').val(url).change();
            $('#FileBrowserModal').modal('hide');
        }
    </script>


    <script>


        var $parentstree;


        $(function () {

            /*
            Parents modal
            */
            //$('#parents-modal').on('show.bs.modal', function () {
            //    var $modalbody = $(this).find('.modal-body');
            //    var $modalContent = $('#parents');
            //    if (!$modalbody.children().length)
            //        $modalbody.append($modalContent);

            //})

            /*
            ** Contents navigation table
            **/

            // datatable
            var $table_contenuti =
                $('#table_contenuti')
                    .on('xhr.dt', function (e, settings, json) {
                        if (!json) {
                            e.preventDefault();
                            return true;
                        }
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
                        "serverSide": true,
                        "dom": "<'row'<'col-sm-12 col-md'l><'col-md col-xl-2'<'search-tipo'>><'col-sm-12 col-md'f>>" +
                            "<'row'<'col-sm-12'tr>>" +
                            "<'row'<'col-sm-12 col-md-5'i><'col-sm-12 col-md-7'p>>",
                        "ajax": {
                            "url": "api/ContentsPaginated/?parent_id=0",
                            "headers": {
                                "Content-Type": "application/x-www-form-urlencoded",
                                "Authorization": "Bearer " + Cookies.get('MB_AuthToken')
                            },
                            "dataSrc": function (json) {
                                if (json) return json.data;
                                return [];
                            },
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
                        "stateSave": true,
                        "columnDefs": [
                            {
                                "targets": 0,
                                "data": "Pk",
                                "searchable": false,
                                "name": "Id",
                                "orderable": true,
                                "className": "text-right",
                                render: function (data, type, ful, meta) {
                                    return `<div class="d-flex align-items-center justify-content-end">
                                                <label class="m-0">${data}</label> 
                                                <input class="my-0 ml-2" type="checkbox" data-id="${data}" />
                                            </div>`;
                                }
                            },
                            {
                                "targets": 1,
                                "data": "Titolo",
                                "name": "Titolo",
                                "width": "100%",
                                render: function (data, type, full, meta) {
                                    full.ExtraInfo = full.ExtraInfo || 'ASC';
                                    var template;
                                    if (full.FlagContainer) {
                                        template = document.getElementById('table-cont-parent').innerHTML;

                                    }
                                    else
                                        template = document.getElementById('table-cont-child').innerHTML;
                                    return Mustache.render(template, full);
                                }
                            },
                            {
                                "targets": 2,
                                "name": "TYP_NAME",
                                "searchable": false,
                                "orderable": false,
                                "data": "NomeTipo",
                                "width": "10%",
                                "className": "text-center",
                                "render": function (data, type, full, meta) {
                                    var miniature = full.Miniature_pk;
                                    if (miniature == 0)
                                        return '<div class="type">&nbsp;</div>';
                                    else {
                                        var btn = $('<button />')
                                            .addClass('btn btn-link')
                                            .attr('data-action', 'show')
                                            .attr('data-url', full.Url || full.Url2)
                                            .attr('type', 'button')
                                            .attr('data-target', '#LightBox')
                                            .attr('data-toggle', 'modal')
                                            .attr('title', data)
                                            .html('<img style="min-width:52px" class="img-responsive" src="/Min.ashx?pk=' + miniature + '"></img>');

                                        var div = $('<div />').append(btn);
                                        return $('<div />').append(div).html();
                                    }
                                }
                            },
                            {
                                "targets": 3,
                                "searchable": false,
                                "orderable": true,
                                "data": "DataPubblicazione",
                                "name": "DataPubblicazione",
                                "width": "10%",
                                "className": "text-right",
                                "render": function (data, type, full, meta) {
                                    if (!data) return "Mancante";
                                    return new Date(data).toLocaleDateString('it-it');
                                }
                            },
                            {
                                "targets": 4,
                                "searchable": false,
                                "orderable": true,
                                "data": "DataScadenza",
                                "name": "DataScadenza",
                                "width": "10%",
                                "className": "text-right",
                                "render": function (data, type, full, meta) {
                                    if (data == null) return "Nessuna";
                                    return new Date(data).toLocaleDateString('it-it');
                                }
                            },
                            {
                                "targets": 5,
                                "searchable": false,
                                "orderable": true,
                                "data": "DataUltimaModifica",
                                "name": "DataUltimaModifica",
                                "width": "10%",
                                "className": "text-right",
                                "render": function (data, type, full, meta) {
                                    if (data == null) return "Mancante";
                                    return new Date(data).toLocaleDateString('it-it');
                                }
                            },
                            {
                                "targets": 6,
                                "name": "Ordinamento",
                                "searchable": false,
                                "orderable": true,
                                "visible": true,
                                "data": "Order",
                                "className": "text-right"
                            },
                            {
                                "targets": 7,
                                "data": "Pk",
                                "searchable": false,
                                "orderable": false,
                                "className": "text-center",
                                "render": function (data, type, full, meta) {
                                    var btn;
                                    if (full.FlagCancellazione) {
                                        btn = $('<button />')
                                            .addClass('btn btn-success btn-xs')
                                            .attr('data-rowpk', full.Pk)
                                            .attr('data-action', 'undelete')
                                            .attr('type', 'button')
                                            .attr('title', 'recupera')
                                            .html('<i class="fa fa-external-link-square"></i><span class="hidden-sm hidden-xs"><%= Master.Translate("recupera") %></span>');
                                    } else {
                                        btn = $('<a />')
                                            .addClass('btn btn-primary btn-xs')
                                            .attr('data-rowpk', full.Pk)
                                            .attr('data-action', 'edit')
                                            .attr('title', 'modifica')
                                            .attr('href', 'editcontents.aspx?pk=' + full.Pk)
                                            .html('<i class="fa fa-edit"></i><span class="hidden-sm hidden-xs"><%= Master.Translate("modifica") %></span>');
                                    }


                                    return $('<div />').append(btn).html();
                                }
                            },
                            {
                                "targets": 8,
                                "data": "Pk",
                                "searchable": false,
                                "orderable": false,
                                "className": "text-center",
                                "render": function (data, type, full, meta) {
                                    var btn;
                                    if (full.FlagCancellazione) {
                                        btn = $('<button />')
                                            .addClass('btn btn-danger btn-xs')
                                            .attr('data-rowpk', full.Pk)
                                            .attr('data-action', 'erase')
                                            .attr('title', 'elimina')
                                            .attr('type', 'button')
                                            .html('<i class="fa fa-eraser"></i><span class="hidden-sm hidden-xs"><%= Master.Translate("elimina") %></span>');
                                    } else {
                                        btn = $('<button />')
                                            .addClass('btn btn-danger btn-xs')
                                            .attr('data-rowpk', full.Pk)
                                            .attr('data-action', 'delete')
                                            .attr('title', 'cestino')
                                            .attr('type', 'button')
                                            .html('<i class="fa fa-trash"></i><span class="hidden-sm hidden-xs"><%= Master.Translate("cestino") %></span>');
                                    }
                                    return $('<div />').append(btn).html();
                                }
                            }
                        ]
                    });
            $('div.search-tipo').append($('#select-tipo-container'));

            $('#select-tipo-container select').on('change', function () {
                //$('#table_contenuti_filter input').val($('#select-tipo-container select').val());
                $table_contenuti.search($('#select-tipo-container select').val()).draw();
            })

            //DataTable events
            $table_contenuti
                .on('search.dt', function (e, setting) {
                    $('#select-tipo-container select').selectpicker('val', $('#table_contenuti_filter input').val());
                })
                .on('draw.dt column-sizing.dt ', function () {
                    var w = $(this).parents('.box-body').width();
                    $('td > div.ellipsis.title').width(w * 0.25);
                    $('td > div.ellipsis.type').width(w * 0.18);
                })
                .on('click', 'button, a, input', function (e) {
                    var $button = $(this);
                    var action = $button.attr('data-action');
                    var pk = $button.attr('data-rowpk');
                    var order = $button.attr('data-order');
                    var name = $button.attr('data-rowtitle');
                    switch (action) {
                        case 'undelete':
                            $('[data-id="Panel_contents"]').spin();
                            $.ajax({
                                type: "POST",
                                url: "Ajax/Delete.ashx",
                                data: {
                                    table: "MB_Contenuti",
                                    pk: $button.attr('data-rowpk'),
                                    undelete: 1
                                },
                                dataType: "json"
                            })
                                .done(function (data) {
                                    if (data.success) {
                                        $table_contenuti.ajax.reload();
                                        $.growl({
                                            icon: 'fa fa-thumbs-o-up',
                                            title: '',
                                            message: data.msg
                                        },
                                            {
                                                type: 'success'
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
                                .fail(function (jqxhr, textStatus, error) {
                                    Swal.fire({
                                        icon: "error",
                                        title: 'Errore',
                                        text: 'Si è verificaro un errore: ' + textStatus + ", " + error
                                    });
                                })
                                .always(function () {
                                    $('[data-id="Panel_contents"]').spin(false);
                                }); break;
                            break;
                        case 'delete':
                        case 'erase':
                            var msg;
                            if (action == "erase")
                                msg = "<%= Master.Translate("L'elemento verrà eliminato definitivamente. Sei sicuro di voler continuare") %>?";
                            else
                                msg = "<%= Master.Translate("Stai spostando l'elemento nel cestino. Ser sicuro di voler continuare") %>?";

                            Swal.fire({
                                title: '<%= Master.Translate("Avvertenza") %>' + '!',
                                text: msg,
                                icon: 'warning',
                                showCancelButton: true,
                                confirmButtonColor: '#3085d6',
                                cancelButtonColor: '#d33',
                                confirmButtonText: 'Ok!'
                            }).then((result) => {
                                if (result.isConfirmed) {
                                    $('[data-id="Panel_contents"]').spin();
                                    $.ajax({
                                        type: "POST",
                                        url: "Ajax/Delete.ashx",
                                        data: {
                                            table: "MB_Contenuti",
                                            pk: $button.attr('data-rowpk'),
                                            undelete: 0
                                        },
                                        dataType: "json"
                                    })
                                        .done(function (data) {
                                            if (data.success) {
                                                $table_contenuti.ajax.reload();
                                                $.growl({
                                                    icon: 'fa fa-thumbs-o-up',
                                                    title: '',
                                                    message: data.msg
                                                },
                                                    {
                                                        type: 'success'
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
                                        .fail(function (jqxhr, textStatus, error) {
                                            $.growl({
                                                icon: 'fa fa-warning',
                                                message: textStatus
                                            },
                                                {
                                                    type: 'danger'
                                                })
                                        })
                                        .always(function () {
                                            $('[data-id="Panel_contents"]').spin(false);
                                        });
                                }
                            });
                            break;
                        case 'add':
                            break;
                        case 'show':
                            e.stopPropagation();
                            $('#LightBox').modal('show', $button);
                            break;
                        case 'goto':
                            var obj = new TableStatus(pk, order, name);
                            obj.icon = $button.attr('data-icon');
                            obj.search = '';
                            tableContentHistory.getCurrent().search = $table_contenuti.search();
                            tableContentHistory.goto(obj);
                            break;
                        default:
                            break;
                    }
                })
                // Update of History info on page changing
                .on('page.dt', function (e, settings) {
                    var info = $table_contenuti.page.info();
                    var obj = tableContentHistory.getCurrent();
                    obj.page = info.page;
                    obj.search = $table_contenuti.search();
                    tableContentHistory.setCurrent(obj);
                }).on('click', '.sorting, .sorting_asc', function (e, settings) {
                    var info = $table_contenuti.order();
                    if (info.length > 0) {
                        var obj = tableContentHistory.getCurrent();
                        obj.order = info[0];
                        //obj.search = $table_contenuti.search();
                        tableContentHistory.setCurrent(obj);
                    }
                });
            $('#table_contenuti').on('change', '#th-checkbox', function (e) {
                let check = this.checked;
                //e.stopPropagation();
                $('#table_contenuti').find(':checkbox[data-id]').each(function () { this.checked = check });
            })

            window.tableContenuti = $table_contenuti;
            /*
            ** /Contents navigation table end
            **/

            // Loading tags from database
            $('#Tags').parent().spin();
            var settings = {
                "url": "/api/Keywords",
                "data": { "lang": "default", "k": "" },
                "method": "GET",
                "timeout": 0,
                "headers": {
                    "Authorization": "Bearer " + Cookies.get('MB_AuthToken')
                },
            };
            $.ajax(settings)
                .fail(function (jqxhr, textStatus, error) {
                    $alert
                        .text('<%= Master.Translate("Si è verificaro un errore") %>: ' + textStatus + "," + error)
                        .removeClass('alert-success')
                        .addClass('alert-danger')
                        .show();
                })
                .done(function (data) {
                    if (data) {
                        $('#Tags')
                            .select2(
                                {
                                    tags: data.data,
                                    initSelection: function (element, callback) {
                                        var keys = element.val().split(',');
                                        var s2Arr = [];
                                        for (var i = 0; i < keys.length; i++) {
                                            if (keys[i].trim())
                                                s2Arr.push({ id: keys[i], text: keys[i] });
                                        }
                                        callback(s2Arr);
                                    },
                                    placeholder: '<%= Master.Translate("Parole chiave") %>',
                                    multiple: true
                                });
                    } else {
                        $.growl({
                            icon: 'fa fa-warning',
                            title: '<%= Master.Translate("Si è verificato un errore") %>: ',
                            message: data.msg
                        },
                            {
                                type: 'danger'
                            });
                    }
                })
                .always(function () {
                    $('#Tags').parent().spin(false);
                })

            // Loading translated tags from database
            $('[name="TranslatedTags"]').each(function () {
                var $tags = $(this);
                var lang = $tags.parents('.form-horizontal').find('[name="LangId"]').val();
                $tags.parent().spin();
                var settings = {
                    "url": "/api/Keywords",
                    "data": { "lang": lang, "k": "" },
                    "method": "GET",
                    "timeout": 0,
                    "headers": {
                        "Authorization": "Bearer " + Cookies.get('MB_AuthToken')
                    },
                };

                $.ajax(settings)
                    .fail(function (jqxhr, textStatus, error) {
                        $alert
                            .text('<%= Master.Translate("Si è verificato un errore") %>: ' + textStatus + "," + error)
                            .removeClass('alert-success')
                            .addClass('alert-danger')
                            .show();
                    })
                    .done(function (data) {
                        if (data) {
                            $tags
                                .select2(
                                    {
                                        tags: data.data,
                                        initSelection: function (element, callback) {
                                            var keys = element.val().split(',');
                                            var s2Arr = [];
                                            for (var i = 0; i < keys.length; i++) {
                                                if (keys[i].trim())
                                                    s2Arr.push({ id: keys[i], text: keys[i] });
                                            }
                                            callback(s2Arr);
                                        },
                                        placeholder: '<%= Master.Translate("Parole chiave") %>',
                                        multiple: true
                                    });
                        } else {
                            $.growl({
                                icon: 'fa fa-warning',
                                title: '<%= Master.Translate("Si è verificato un errore") %>: ',
                                message: data.msg
                            },
                                {
                                    type: 'danger'
                                });
                        }
                    })
                    .always(function () {
                        $tags.parent().spin(false);
                    })
            })


            /*
            ** Handling contents table navigation history 
            **/
            //localStorage.removeItem('tableContentHistory');
            tableContentHistory = new Mb_history({
                loadsaved: 'tableContentHistory',
                home: new TableStatus(0, [6, 'asc'], 'Root'),
                action: function (obj, index, len) {
                    var $panel = $('[data-id="Panel_contents"]');
                    $panel.spin();
                    if ($table_contenuti.ajax) {
                        $table_contenuti.ajax.url('/api/ContentsPaginated/?parent_id=' + obj.parent).load(function () {
                            var $boxTitle = $('[data-id="Panel_contents"]').find('.box-title');
                            var $addElementBtn = $('[data-action="add-element"]');
                            switch (obj.parent) {
                                case 0:
                                    $boxTitle.html('<i class="fa fa-home"></i>' + obj.name);
                                    $addElementBtn.addClass('hidden');
                                    break;
                                    $('[data-action="trash-multi"]').removeClass('d-none');
                                    $('[data-action="erase-multi"]').addClass('d-none');
                                case -1:
                                    $boxTitle.html('<i class="fa fa-bars"></i>' + obj.name);
                                    $addElementBtn.addClass('hidden');
                                    $('[data-action="trash-multi"]').removeClass('d-none');
                                    $('[data-action="erase-multi"]').addClass('d-none');
                                    break;
                                case -2:
                                    $boxTitle.html('<i class="fa fa-trash-o"></i>' + obj.name);
                                    $addElementBtn.addClass('hidden');
                                    $('[data-action="trash-multi"]').addClass('d-none');
                                    $('[data-action="erase-multi"]').removeClass('d-none');
                                    break;
                                default:
                                    $boxTitle.html('<i class="fa ' + obj.icon + '"></i>' + obj.name);
                                    $('[data-action="trash-multi"]').removeClass('d-none');
                                    $('[data-action="erase-multi"]').addClass('d-none');
                                    $addElementBtn
                                        .attr('data-title', '<%= Master.Translate("Aggiungi un elemento a") %> &quot;' + obj.name + '&quot;')
                                        .attr('data-parent', obj.parent)
                                        .removeClass('hidden');
                                    break;
                            }

                            setTimeout(function () {
                                $table_contenuti
                                    .search(obj.search);
                                $table_contenuti
                                    .order(obj.order);
                                $table_contenuti
                                    .page(obj.page)
                                    .draw(false);
                                $panel.spin(false);
                            }, 10)

                            var $back = $('[data-action="back"]');
                            var $forward = $('[data-action="forward"]');
                            var $home = $('[data-action="home"]');
                            if (index > 0)
                                $back.removeAttr('disabled');
                            else
                                $back.attr('disabled', 'disabled');

                            if (len > (index + 1))
                                $forward.removeAttr('disabled');
                            else
                                $forward.attr('disabled', 'disabled');
                            if (typeof window.JSON !== "undefined") {
                                var homeState = JSON.stringify(tableContentHistory.home);
                                var currentState = JSON.stringify(tableContentHistory.history[tableContentHistory.current]);
                                if (homeState === currentState)
                                    $home.attr('disabled', 'disabled')
                                else
                                    $home.removeAttr('disabled');
                            }

                        })
                    }
                }
            });

            // Carico l'history memorizzata in local storage
            //tableContentHistory.load('tableContentHistory');

            /*
            ** /navigation history end
            **/

            // Add child element button
            $('[data-action="add-element"]')
                .tooltip({
                    trigger: 'hover',
                    container: 'body',
                    html: true,
                    title: function () {
                        return $(this).attr('data-title');
                    }
                })
                .on('mousedown', function () {
                    $(this).tooltip('hide');
                });

            var $preferredDropdown = $('#dd-preferred').parent();
            $preferredDropdown.on('shown.bs.dropdown', function (e) {
                var parent = $preferredDropdown.parent().spin();
                var $this = $(this);
                $this
                    .find('.dropdown-menu')
                    .html('<li>&nbsp;<%= Master.Translate("Caricando") %>...</li>')
                    .load('Ajax/GetContainerrPreferred.ashx ul>li', 'parent=' + $this.find('[data-toggle="dropdown"]').attr('data-parent'), function () {
                        parent.spin(false);
                    });
            });

            // Handlers for other buttons
            $('[data-action]').on('click', function () {
                var $this = $(this);
                var action = $this.attr('data-action');
                // Accuirni la ricerca custom del record corrente
                tableContentHistory.getCurrent().search = $table_contenuti.search();
                switch (action) {
                    case 'url':
                        tableContentHistory.forward();
                        break;
                    case 'url2':
                        tableContentHistory.forward();
                        break;
                    case 'forward':
                        tableContentHistory.forward();
                        break;
                    case 'back':
                        tableContentHistory.back();
                        break;
                    case "home":
                        tableContentHistory.gohome();
                        break;
                    case "full":
                        tableContentHistory.goto(new TableStatus(-1, "ALPHA ASC", 'Tutti'));
                        break;
                    case "inbasket":
                        tableContentHistory.goto(new TableStatus(-2, "ALPHA ASC", 'Cestino'));
                        break;
                    case "duplicate":
                        var dup = function () {
                            $('#Pk').val(0);
                            var $titolo = $('#Titolo');
                            $titolo.val($titolo.val() + '(duplicato)');
                            $('[name="PostPk"]').val(0);
                            $('#PermalinkTitle').val('');
                        };
                        if ($('#Parents').parents('[role="form"]').mb_submit('pendingChanges')) {

                            Swal.fire({
                                title: '<%= Master.Translate("Avvertenza") %>' + '!',
                                text: '<%= Master.Translate("Ci sono modifiche non salvate! Vuoi contunuare") %>?',
                                icon: 'warning',
                                showCancelButton: true,
                                confirmButtonColor: '#3085d6',
                                cancelButtonColor: '#d33',
                                confirmButtonText: 'Ok!'
                            }).then((result) => {
                                if (result.isConfirmed) {
                                    dup();
                                }
                            })
                        } else {
                            dup();
                        }
                        break;
                    case "save-and-reload":
                        let tipo = $('#select-elenco-tipi').val();
                        let modal = $('#select-elenco-tipi').parents('.modal-body');
                        $('#Tipo').val(tipo);
                        $('#reload-post').val(1);
                        modal.spin();
                        $('#edit-content [data-action=submit]').click();
                        break;
                    case "open-post":
                        openPost();
                        break;
                    case "translate-text":
                        $('#text-translator-from').parents('.tab-pane').spin();
                        var data = {
                            "Text": $('#text-translator-from').val(),
                            "To": $('#select-to-lang').val(),
                            "From": $('#select-from-lang').val(),
                            "TextType": "html"
                        };
                        var settings = {
                            "url": "/api/TextTranslator",
                            "method": "POST",
                            "timeout": 0,
                            "headers": {
                                "Content-Type": "application/json",
                                "Authorization": "Bearer " + Cookies.get('MB_AuthToken')
                            },
                            "data": JSON.stringify(data)
                        };
                        $.ajax(settings)
                            .done(function (response) {
                                if (response.success) {
                                    $('#text-translator-to').val(response.data);
                                } else if (response.exitcode == -1) {
                                    Swal.fire({
                                        icon: "warning",
                                        title: 'Attenzione',
                                        text: response.msg
                                    });
                                    $('#text-translator-to').val(response.data);
                                } else {
                                    Swal.fire({
                                        icon: "error",
                                        title: 'Errore',
                                        text: 'Si è verificaro un errore: ' + response.msg
                                    });
                                }
                            })
                            .fail(function (jqxhr, textStatus, error) {
                                Swal.fire({
                                    icon: "error",
                                    title: 'Errore',
                                    text: 'Si è verificaro un errore: ' + textStatus + ", " + error
                                });
                            })
                            .always(function () {
                                $('#text-translator-from').parents('.tab-pane').spin(false);
                            });
                        break;
                    case "clear-translation":
                        break;
                    case "viewer":
                        let sourceSelector = $this.data('source');
                        if ($(sourceSelector).val())
                            TheViewer.show($(sourceSelector).val());
                        break;
                    case "upload":
                        let targetSelector = $this.data('target');
                        TheUploader.getFileSingle().then(url => { if (url) $(targetSelector).val(url); });
                        break;
                    case "trash-multi":
                        deletePost(true);
                        break;
                    case "erase-multi":
                        deletePost(false);
                        break;
                    default:

                }
            });

            /**
             *  CESTINO E CANCELLAZIONE DEFINITIVA POST SELEZIONATI
             * */

            function deletePost(basket) {
                var selected = [];
                $('#table_contenuti :checkbox[data-id]').each(function () {
                    if (this.checked)
                        selected.push(parseInt($(this).data('id')));
                })
                if (selected.length == 0)
                    Swal.fire({
                        icon: 'info',
                        title: 'Nessun post selezionato'
                    });
                else {
                    let message;
                    if (basket) {
                        message = `Stai per inviare ${selected.length} post al cestino. I post potranno essere recuperati 
                                    ma i collegamenti ai post figli e ai post genitori andranno persi. Confermi?`
                    } else {
                        message = `Stai per eliminare definitivamente ${selected.length} post. I post non potranno essere
                                    recuperati. Confermi?`
                    }
                    Swal.fire({
                        icon: 'info',
                        title: 'Attenzione!',
                        text: message,
                        showCancelButton: true,
                        confirmButtonText: 'Continua',
                        cancelButtonText: `Annulla`,
                    }).then((result) => {
                        /* Read more about isConfirmed, isDenied below */
                        if (result.isConfirmed) {
                            Swal.fire({
                                icon: 'warning',
                                title: `Confermi l'eliminazione di ${selected.length} post?`,
                                showCancelButton: true,
                                confirmButtonText: 'Sì',
                                cancelButtonText: `No`
                            }).then(result => {
                                if (result.isConfirmed) {
                                    var myHeaders = new Headers();
                                    myHeaders.append("Content-Type", "application/json");
                                    myHeaders.append("Authorization", "Bearer " + Cookies.get('MB_AuthToken'));

                                    var raw = JSON.stringify({
                                        "OperationStr": "Delete",
                                        "PkList": selected
                                    });

                                    var requestOptions = {
                                        method: 'POST',
                                        headers: myHeaders,
                                        body: raw,
                                        redirect: 'follow'
                                    };

                                    fetch("/api/MagicPost", requestOptions)
                                        .then(response => response.json())
                                        .then(result => {
                                            if (!result.success) {
                                                Swal.fire({
                                                    icon: 'error',
                                                    title: 'Errore',
                                                    text: result.msg
                                                })
                                            }
                                            tableContentHistory.reload();
                                        })
                                        .catch(error => Swal.fire({
                                            icon: 'error',
                                            title: 'Errore',
                                            text: error
                                        }).then(() => tableContentHistory.reload()));
                                }                                    
                            });
                        }
                    })
                }
            }


            $(document).on('dragover drop', event => event.preventDefault());
            $('[data-droptarget]').on('drop', event => {
                event.preventDefault();
                const evt = event.originalEvent;
                const $this = $(event.currentTarget);
                if (evt.dataTransfer.files.length == 1) {
                    TheUploader.uploadSingle(evt.dataTransfer.files[0]).then(url => $this.val(url));
                };
            });



            // Parents tree
            $parentstree = $("#parents-tree").jstree({
                "core": {
                    "expand_selected_onload": true,
<%--                    "data": {
                        //"url": "Ajax/GetParentsTreeJSON.ashx?pk=<% =Pk.ToString() %>&parent=<% = TheParent.ToString() %>"
                        "url": "/api/GetParentsTree?pk=<% = Pk %>&<%= TheParent %>&k=" + Cookies.get('MB_AuthToken'),
                        "method": "GET",
                        "timeout": 0,

                    }, --%>
                    'data': function (obj, callback) {
                        var settings = {
                            "url": "/api/GetParentsTree?pk=<% = Pk %>&parent=<%= TheParent %>",
                            "method": "GET",
                            "timeout": 0,
                            "headers": {
                                "Authorization": "Bearer " + Cookies.get('MB_AuthToken')
                            },
                        };

                        $.ajax(settings).done(function (response) {
                            callback.call(this, response);
                        })

                    }
                },
                "themes": {
                    "name": "default",
                    "variant": "responsive"
                },

                "checkbox": {
                    "three_state": false,
                    "keep_selected_style": false
                },
                "plugins": ["checkbox"]
            })
                .on('select_node.jstree deselect_node.jstree', function (e, jtree) {
                    var node = jtree.node;
                    $.mb_selectnode($(this).data('jstree'), node.a_attr['data-pk'], $parentstree.jstree('get_json'), node.state.selected);
                    var parents = new Array();
                    var selected = $(this).data('jstree').get_selected();
                    $.each(selected, function (index, value) {
                        var n = parseInt(value);
                        if ($.inArray(n, parents) == -1)
                            parents.push(n);
                    })
                    $('#Parents').val(parents.join(','));
                    $('#Parents').parents('[role="form"]').mb_submit('pendingChanges', true);
                })
                .on('ready.jstree', function (e, jtree) {
                    $('#Parents').parents('[role="form"]').mb_submit('pendingChanges', false);
                });

            //$parentstree.


            /***
            ******************** Translations ******************
            */
            var fillForm = function (form, data) {

                Swal.fire({
                    title: '<%= Master.Translate("Avvertenza") %>' + '!',
                    text: '<%= Master.Translate("Attenzione! I testi presenti nei campi saranno sostituiti dalla traduzione automatica. Continuare") %>?',
                    icon: 'warning',
                    showCancelButton: true,
                    confirmButtonColor: '#3085d6',
                    cancelButtonColor: '#d33',
                    confirmButtonText: 'Ok!'
                }).then((result) => {
                    if (result.isConfirmed) {
                        for (var prop in data) {
                            var $field = form.find('[name="' + prop + '"]');
                            if ($field.length) {
                                if ($field.data('select2')) {
                                    var tmpArray = data[prop].split(',');
                                    var tagsArray = [];
                                    while (tmpArray.length) {
                                        tagsArray.push(tmpArray.pop().trim());
                                    }
                                    $field.select2('val', tagsArray);
                                }
                                else
                                    $field.val(data[prop]);
                            }
                        }
                    }
                })
            };

            /**
            * ------------ Translate with Bing
            **/
            $('[data-action="translate"], [data-action="delete-translation"]').on('click', function (e) {
                e.preventDefault();
                var $me = $(this);
                var action = $me.attr('data-action');
                var $form = $me.parents('[role="form"]');
                var langid = $form.find('[name="LangId"]').val();
                var pk = $form.find('[name="PostPk"]').val();
                var titolo = $("#ExtraInfo1").val();
                if (!titolo)
                    titolo = $("#Titolo").val();
                var fromLangId = $('#default-lang-id').val();
                var testoBreve = $('#TestoBreve').val();
                var testoLungo = $('#TestoLungo').val();
                var tags = $('#Tags').val();
                var param = {};
                if (action == 'translate') {
                    var data = {
                        To: langid,
                        From: fromLangId,
                        Title: titolo,
                        TestoBreve: testoBreve,
                        TestoLungo: testoLungo,
                        Tags: tags
                    };
                    $form.spin();
                    var settings = {
                        "url": "/api/PostTranslator",
                        "method": "POST",
                        "timeout": 0,
                        "headers": {
                            "Content-Type": "application/json",
                            "Authorization": "Bearer " + Cookies.get('MB_AuthToken')
                        },
                        data: JSON.stringify(data)
                    };
                    $.ajax(settings)
                        .done(function (data) {
                            if (data.Success) {
                                Swal.fire({
                                    title: 'Traduzione del post completata',
                                    html: data.Error,
                                    showDenyButton: true,
                                    showCancelButton: true,
                                    confirmButtonText: 'Sostituisci il testo',
                                    denyButtonText: `Accoda al testo`,
                                    cancelButtonText: "Annulla"
                                }).then((result) => {
                                    /* Read more about isConfirmed, isDenied below */
                                    if (result.isConfirmed) {
                                        $form.find('[name="TranslatedTitle"]').val(data.Title.Translation);
                                        $form.find('[name="TranslatedTestoBreve"]').val(data.TestoBreve.Translation);
                                        $form.find('[name="TranslatedTestoLungo"]').val(data.TestoLungo.Translation);
                                        $form.find('[name="TranslatedTags"]').select2("val", data.Tags.Translation.split(','));
                                    } else if (result.isDenied) {
                                        $form.find('[name="TranslatedTitle"]').val(data.Title.Translation);
                                        $form.find('[name="TranslatedTestoBreve"]').val($form.find('[name="TranslatedTestoBreve"]').val() + data.TestoBreve.Translation);
                                        $form.find('[name="TranslatedTestoLungo"]').val($form.find('[name="TranslatedTestoLungo"]').val() + data.TestoLungo.Translation);
                                        $form.find('[name="TranslatedTags"]').select2("val", data.Tags.Translation.split(','));
                                    }
                                })
                            } else {
                                Swal.fire({
                                    icon: "error",
                                    title: 'Errore',
                                    text: 'Si è verificaro un errore: ' + data.Error
                                });
                            }
                        })
                        .fail(function (jqxhr, textStatus, error) {
                            Swal.fire({
                                icon: "error",
                                title: 'Errore',
                                text: 'Si è verificaro un errore: ' + textStatus + ", " + error
                            });
                        })
                        .always(function () {
                            $form.spin(false);
                        });
                } else if (action == 'delete-translation') {
                    params = {
                        LangId: langid,
                        Pk: pk,
                        table: 'ANA_TRANSLATION'
                    };

                    Swal.fire({
                        title: '<%= Master.Translate("Avvertenza") %>' + '!',
                        text: "<%= Master.Translate("Confermi l'eliminazione della traduzione") %>?",
                        icon: 'warning',
                        showCancelButton: true,
                        confirmButtonColor: '#3085d6',
                        cancelButtonColor: '#d33',
                        confirmButtonText: 'Ok!'
                    }).then((result) => {
                        if (result.isConfirmed) {
                            $.ajax('Ajax/Delete.ashx',
                                {
                                    data: params,
                                    dataType: 'json',
                                    type: 'POST'
                                })
                                .done(function (data) {
                                    if (data.success) {
                                        $.growl({
                                            icon: 'fa fa-thumbs-o-up',
                                            title: '',
                                            message: data.msg
                                        },
                                            {
                                                type: 'success'
                                            });
                                        $form.find('[name="TranslatedTitle"]').val("");
                                        $form.find('[name="TranslatedTestoBreve"]').val("");
                                        $form.find('[name="TranslatedTestoLungo"]').val("");
                                        $form.find('[name="TranslatedTags"]').select2("val", []);
                                        setTimeout(function () { $form.mb_submit('pendingChanges', false); }, 200);
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
                                .fail(function (jqxhr, textStatus, error) {
                                    $.growl({
                                        icon: 'fa fa-warning',
                                        message: textStatus
                                    },
                                        {
                                            type: 'danger'
                                        })
                                })
                                .always(function () {
                                    $form.spin(false);
                                });
                        }
                    })
                }

            });

            //End Translations

            /////  Correzione per creazione tab autonomo per i CKEditor

            $('#TestoBreve-ck, #TestoLungo-ck').on('change', function () {
                $('#TestoBreve').val($('#TestoBreve-ck').val());
                $('#TestoLungo').val($('#TestoLungo-ck').val());
                // Innesto l'evento 'change' per lo pseudo-fprm
                $('#Titolo').trigger('change');
            })

            //eventi form contenuti
            $form_contents.on('submitted.mb.form', function (e, data) {
                //e.stopPropagation();
                if (data.success) {
                    $table_contenuti.ajax.reload(null, false);
                    $.growl({
                        icon: 'fa fa-thumbs-o-up',
                        title: '<%= Master.Translate("Salvataggio dati") %>',
                        message: data.msg
                    },
                        {
                            type: 'success'
                        });
                    // Post Id hidden fields updated !!
                    $('[name="Pk"], [name="PostPk"]').val(data.pk);
                    $('#PermalinkTitle').parents('.form-group').removeClass('has-success has-error');
                    if ($('#reload-post').val() == 1) {
                        window.location.reload();
                    }
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
                .on('changed.mb.form', function (e, pending) {
                    var $tabicon = $('a[href="#main-data"] i');
                    if (pending)
                        $tabicon.removeClass('hidden');
                    else
                        $tabicon.addClass('hidden');
                });

            //Pseudoforms translations
            $('[id^="edit-lang-"]').on('submitted.mb.form', function (e, data) {
                if (data.success) {
                    $.growl({
                        icon: 'fa fa-thumbs-o-up',
                        title: '<%= Master.Translate("Salvataggio dati") %>',
                        message: data.msg
                    },
                        {
                            type: 'success'
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
                .on('changed.mb.form', function (e, pending) {
                    var $this = $(this);
                    var langid = $this.find('[name="LangId"]').val();
                    var $tabicon = $('a[href="#lang-' + langid + '"] i');
                    if (pending)
                        $tabicon.removeClass('hidden');
                    else
                        $tabicon.addClass('hidden');
                });

            // Pending changes control
            $(window).on('beforeunload', function () {
                tableContentHistory.save('tableContentHistory');
                var ch = $form_contents.mb_submit('pendingChanges');
                $('[id^="edit-lang-"]').each(function () {
                    if ($(this).mb_submit('pendingChanges'))
                        ch = true;
                });
                if (ch)
                    return '<%= Master.Translate("Attenzione sono state rilevate modifiche non salvate") %>.';
            });

            /*
            *********** Preview modal *****************
            */
            $('#preview-modal').on('show.bs.modal', function (e) {
                //var ch = $form_contents.mb_submit('pendingChanges');
                var previewData = $form_contents.mb_submit('getValues');
                var url;
                var $this = $(this);
                var $btn = $(e.relatedTarget);
                var selector = $btn.attr('data-source');
                var error = '';
                var $title = $this.find('.modal-title');
                var $body = $this.find('.modal-body');
                var $dialog = $this
                    .children('.modal-dialog')
                    .removeClass('modal-lg modal-sm')
                $.ajax('Ajax/PreviewPost.ashx',
                    {
                        data: previewData,
                        dataType: 'json',
                        type: 'POST'
                    })
                    .fail(function (jqxhr, textStatus, error) {

                        Swal.fire({
                            icon: "error",
                            title: 'Errore',
                            text: 'Si è verificaro un errore: ' + textStatus + ", " + error
                        });
                    })
                    .done(function (data) {
                        $title.html("<%= Master.Translate("Anteprima") %>: <strong>" + $('#Titolo').val() + "</strong>");
                        if (data.success) {
                            url = '/preview';
                            $body.html('');
                            $('<iframe border="0" />')
                                .css({ 'width': '100%', border: 0, display: 'block' })
                                .height($(window).height() * 0.8)
                                .attr('src', url)
                                .appendTo($body);
                        } else {
                            $body.html('<h4 class="text-center">' + data.msg + '</h4>');
                        }
                    })

                //	.always(function (data) {
                //		me.$form.spin(false);
                //		//Viene lanciato l'evento custom
                //		me.$submit
                //			.trigger('submitted.mb.form', data);
                //		//me.$form
                //		//    .trigger('submitted.mb.form', data);
                //	})
                ////$('[id^="edit-lang-"]').each(function () {
                //    if ($(this).mb_submit('pendingChanges'))
                //        ch = true;
                //});

                //var $this = $(this);
                //var $btn = $(e.relatedTarget);
                //var selector = $btn.attr('data-source');
                //var url = '';
                //var error = '';
                //if (!ch) {

                //    if ($btn.attr('data-action') == 'show-record')
                //        url = '/Contenuti.aspx?p=' + $('#Pk').val();
                //    else if ($btn.attr('data-action') == 'show-in-parent') {
                //        var p = $('#Parents').val();
                //        if (p) {
                //            var parents = p.split(',');
                //            url = '/Contenuti.aspx?p=' + parents[0];
                //        }
                //        else {
                //            error = 'Il record non ha parents';
                //        }
                //    }
                //}
                //else
                //    error = 'Per visualizzare una pagina è necessario prima salvare le modifiche';

            });

            /// Fine preview

            /*
            *********** Controllo Permalink *****************
            */

            const $permalink = $('#PermalinkTitle, [name="PermalinkTitle"');
            const $title = $('#ExtraInfo1, [name="TranslatedTitle"]');

            $permalink.on('change', function () {
                const self = $(this);
                var $form = self.parents('[role="form"]');
                var langid = $form.find('[name="LangId"]').val();
                var $tit = $form.find('#ExtraInfo1, [name="TranslatedTitle"]');
                var settings = {
                    "url": "/api/CheckPermalink",
                    "method": "POST",
                    "timeout": 0,
                    "headers": {
                        "Content-Type": "application/x-www-form-urlencoded",
                        "Authorization": "Bearer " + Cookies.get('MB_AuthToken')
                    },
                    "data": {
                        "pk": $('#Pk').val(),
                        "title": self.val() || $tit.val(),
                        "lang": langid
                    }
                };

                $.ajax(settings)
                    .done(function (response) {
                        self.parents('.form-group').removeClass('has-success has-error');
                        if (response.success) {
                            self.parents('.form-group').addClass('has-success');
                        }
                        else {
                            self.parents('.form-group').addClass('has-error');
                        }
                        if (response.data)
                            self.val(response.data);
                    });
            });

            $title.on('change', function () {

                var settings = {
                    "url": "/api/CheckPermalink",
                    "method": "POST",
                    "timeout": 0,
                    "headers": {
                        "Content-Type": "application/x-www-form-urlencoded",
                        "Authorization": "Bearer " + Cookies.get('MB_AuthToken')
                    },
                    "data": {
                        "pk": $('#Pk').val(),
                        "title": $title.val()
                    }
                };

                $.ajax(settings)
                    .done(function (response) {
                        if (!$permalink.val()) {
                            $permalink.parents('.form-group').removeClass('has-success has-error');

                            if (response.data)
                                $permalink.val(response.data);
                        }
                    });
            });

            // Open permalink in new window

            function openPost() {
                var ch = $form_contents.mb_submit('pendingChanges');
                if (ch) {

                }
                else
                    openInWindow("/anteprima/" + $permalink.val());
            }

            const openInWindow = function (url) {
                window.open(url, "postNewWindow", "width=1200;height=800", true);
            }

            // Fine controllo permalink


        });



    </script>
</asp:Content>
