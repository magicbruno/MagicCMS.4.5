﻿<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/MasterAdmin.master" AutoEventWireup="true" CodeBehind="log.aspx.cs" Inherits="MagicCMS.Admin.log" %>
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
				<div class="box-header">
					<h3 class="box-title"><%= Master.Translate("Attività ed errori") %></h3>
					<div class="box-tools pull-right">
						<%--<a href="#modal-edit-user" data-toggle="modal" data-rowpk="0" class="btn btn-sm bg-olive">--%>
							<%--<i class="fa fa-lo"></i>nuova attività<%= Master.Translate("Back") %></a>--%>
						<button type="button" class="btn btn-primary btn-sm" data-widget="collapse">
							<i class="fa fa-minus"></i>
						</button>
					</div>
				</div>
				<div class="box-body">
					<table id="log" class="table table-striped table-bordered table-hover dataTable" >
						<thead>
							<tr>
								<th><%= Master.Translate("Data") %></th>
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
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">&times;</span><span
							class="sr-only">Chiudi</span></button>
					<h4 class="modal-title" id="myModalLabel"><%= Master.Translate("Dettagli attività") %></h4>
				</div>
				<div class="modal-body">
					<div class="row">
						<div class="col-sm-2 text-right">
							<label><%= Master.Translate("Numero") %></label>
						</div>
						<div class="col-sm-10">
							<span id="Pk"></span>
						</div>
					</div>
					<div class="row">
						<div class="col-sm-2 text-right">
							<label><%= Master.Translate("Data e ora") %></label>
						</div>
						<div class="col-sm-10">
							<span id="Timestamp"></span>
						</div>
					</div>
					<div class="row">
						<div class="col-sm-2 text-right">
							<label><%= Master.Translate("Tabella") %></label>
						</div>
						<div class="col-sm-10">
							<span id="Tabella"></span>
						</div>
					</div>
					<div class="row">
						<div class="col-sm-2 text-right">
							<label><%= Master.Translate("Record") %></label>
						</div>
						<div class="col-sm-10">
							<span id="RecordName"></span>
						</div>
					</div>
					<div class="row">
						<div class="col-sm-2 text-right">
							<label><%= Master.Translate("Utente") %></label>
						</div>
						<div class="col-sm-10">
							<span id="Useremail"></span>
						</div>
					</div>
					<div class="row">
						<div class="col-sm-2 text-right">
							<label><%= Master.Translate("Errore") %></label>
						</div>
						<div class="col-sm-10">
							<span id="Error"></span>
						</div>
					</div>
					<div class="row">
						<div class="col-sm-2 text-right">
							<label><%= Master.Translate("Nome file") %></label>
						</div>
						<div class="col-sm-10">
							<span id="FileName"></span>
						</div>
					</div>
					<div class="row">
						<div class="col-sm-2 text-right">
							<label><%= Master.Translate("Nome metodo") %></label>
						</div>
						<div class="col-sm-10">
							<span id="MethodName"></span>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="Scripts" runat="server">
	<script>
		/// <reference path="../../../Scripts/_references.js" />
		$(function () {
			var $tablog =
				$('#log')
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
						"order": [0, 'desc'],
						"ajax": {
							"url": "Ajax/LogPaginated.ashx",
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
								"data": "Timestamp",
								"name": "reg_TIMESTAMP",
								"width": "14%",
								"seachable": false,
								"className": 'text-center',
								"render": function (data, type, full, meta) {
									var date = new Date(parseInt(data.substr(6)));
									return "<span>" + ('0' + String(date.getDate())).substr(-2) + '/' +
										('0' + String(date.getMonth() + 1)).substr(-2) + '/' + date.getFullYear() +
										'&nbsp;' + ('0' + date.getHours()).substr(-2) + ':' + ('0' + date.getMinutes()).substr(-2);
								}
							},
							{
								"targets": 1,
								"data": "Useremail",
								"name": "usr_EMAIL",
								"width": "22%"
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
								"width": "30%"
							},
							{
								"targets": 6,
								"data": "Pk",
								"name": "reg_Pk",
								"className": 'hidden'
							}
						]
					});


			$tablog.on('click', 'tbody tr', function (e) {
				e.preventDefault();
				$('#modal-log-details')
					.modal();
				var recno = $(this).children('td.hidden').text();
				getRecord(recno);
			});

			var getRecord = function (pk) {
				var $form = $('#modal-log-details .modal-body');
				$form.spin();
				$.getJSON('Ajax/GetRecord.ashx', { pk: pk, table: "_LOG_REGISTRY" })
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
								title: '<%= Master.Translate("Notifica") %>',
								message: '<%= Master.Translate("Il record") %> ' + record.Pk + " <%= Master.Translate("è stoto caricato con successo") %>"
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
					.always(function () {
						$form.spin(false);
					})
			};

			var formFill = function (data) {
				for (var prop in data) {
					var $field = $('#modal-log-details [name="' + prop + '"]');
					if (!$field.length)
						$field = $('#modal-log-details #' + prop);
					if ($field.length) {
						var value = (prop == "Timestamp") ? new Date(parseInt(data[prop].substr(6))).toString() : data[prop];
						$field.html(value);
					}

				}
			};

		});


	</script>
</asp:Content>
