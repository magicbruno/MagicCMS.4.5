<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/MasterAdmin.master" AutoEventWireup="true" CodeBehind="CustomCss.aspx.cs" Inherits="MagicCMS.Admin.CustomCss" %>
<%@ MasterType TypeName="MagicCMS.Admin.MasterAdmin" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
	<link href="Scripts/plugins/CodeMirror/css-edit/code-mirror-css-bundle.min.css" rel="stylesheet" />
	<style>
		.box-body {
			position: relative;
		}

		#css-editor {
			height: calc(100vh - 220px);
		}

		.CodeMirron {
			font-size: 16px;
		}

		.btn .fa-long-arrow-up, .btn .fa-long-arrow-down {
			font-size: 1em !important;
		}
		.dropdown-menu > li > a > .fa {
			margin-right: 5px;
		}
	</style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="HeaderContent" runat="server">
	<h1><i class="fa fa-css3"></i><%= Master.Translate("CSS Personalizzato") %></h1>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
	<div class="row">
		<div class="col-md-12">
			<div class="box box-primary">
				<div class="box-header">
					<h3 class="box-title"><%= Master.Translate("Editor css") %></h3>
					<div class="box-tools pull-right">
						<button type="button" data-action="color-scheme" class="btn btn-sm btn-info btn-icon"
							title="<%= Master.Translate("Cambia schema colore") %>">
							<i class="fa fa-refresh"></i><%= Master.Translate("Temi") %> 
						</button>
						<button type="button" data-action="smaller-char" class="btn btn-sm btn-primary btn-icon"
							title="<%= Master.Translate("Riduci corpo carattere") %>">
							<span class="small">A</span> <i class="fa fa-long-arrow-down"></i>
						</button>
						<button type="button" data-action="larger-char" class="btn btn-sm btn-primary btn-icon"
							title="<%= Master.Translate("Aumento corpo carattere") %>">
							<span class="">A</span> <i class="fa fa-long-arrow-up"></i>
						</button>
						<button type="button" data-action="save" class="btn btn-sm btn-success btn-icon"
							title="<%= Master.Translate("Salva") %>">
							<i class="fa fa-save"></i>
						</button>
												
						<button type="button" data-action="save-copy" class="btn btn-sm btn-success btn-icon"
							title="<%= Master.Translate("Archivia una copia del foglio di stile corrente") %>">
							<i class="fa fa-archive"></i>
						</button>
						
						<button type="button" class="btn btn-sm btn-info btn-icon"
							title="<%= Master.Translate("Help") %>" data-toggle="modal" data-target="#editor-help">
							<i class="fa fa-question"></i>
						</button>
						<div class="btn-group">
							<button type="button" class="btn btn-sm btn-warning dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
								<i class="fa fa-archive"></i> 
								<%= Master.Translate("Archivio fogli di stile") %> <span class="caret"></span>
							</button>
							<ul class="dropdown-menu dropdown-menu-right" id="versioni">
								<li><a href="#">&nbsp;</a></li>
								<li><a href="#">&nbsp;</a></li>
								<li><a href="#">&nbsp;</a></li>
								<li><a href="#">&nbsp;</a></li>
							</ul>
						</div>
						<%--                        
							<button type="button" class="btn btn-primary btn-sm" data-widget="collapse">
                            <i class="fa fa-minus"></i>
                        </button>--%>
					</div>
				</div>
				<div class="box-body">
					<div id="css-editor">
					</div>
				</div>
			</div>
		</div>
	</div>
	<div class="modal fade" id="editor-help" tabindex="-1" role="dialog" aria-labelledby="editor-help-label">
		<div class="modal-dialog modal-sm" role="document">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
					<h4 class="modal-title" id="editor-help-label">Combinazioni tasti attive<%= Master.Translate("Combinazioni tasti attive") %></h4>
				</div>
				<div class="modal-body">
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-primary" data-dismiss="modal"><%= Master.Translate("Chiudi") %></button>
				</div>
			</div>
		</div>
	</div>
	<div class="modal fade" id="css-preview" tabindex="-1" role="dialog" aria-labelledby="css-preview-label">
		<div class="modal-dialog modal-lg" role="document">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
					<h4 class="modal-title" id="css-preview-label"><%= Master.Translate("Foglio di stile da inserire") %></h4>
				</div>
				<div class="modal-body" id="css-preview-viewport">
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-warning" data-action="replace" data-dismiss="modal"><%= Master.Translate("Sostituisci") %></button>
					<button type="button" class="btn btn-success" data-action="insert" data-dismiss="modal"><%= Master.Translate("Accoda al testo") %></button>
					<button type="button" class="btn btn-danger" data-dismiss="modal"><%= Master.Translate("Annulla") %></button>
				</div>
			</div>
		</div>
	</div>
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="Scripts" runat="server">
	<script src="Scripts/plugins/CodeMirror/css-edit/code-mirror-css-bundle.min.js"></script>
	<script>
		"use strict";

		// Compose theme button label
		function updateThemeBtnLabel(theme) {
			$('[data-action="color-scheme"]').html('<i class="fa fa-refresh"></i>&nbsp;&nbsp;<%= Master.Translate("Tema") %>: ' + theme);

		}

		function date2string(date) {
			var zero = function(n) {
				var s = String(n);
				if (s.length < 2)
					return '0' + s;
				return s;
			}
			return ('<i class="fa fa-calendar"></i>' + zero(date.getDate()) + '-' + zero(date.getMonth() + 1) + '-' + date.getFullYear() + '&nbsp;&nbsp;' + 
				' <i class="fa fa-clock-o"></i>' + zero(date.getHours()) + ':' + zero(date.getMinutes()) + ':' + zero(date.getSeconds()));
		}

		// Simple Array extensione: find next element
		Array.prototype.getNext = function (current) {
			if (this.length == 0)
				return undefined;
			else {
				var cur = this.indexOf(current);
				cur++;
				if (cur > 0 && cur < this.length)
					return this[cur]
				else
					return this[0];
			}
		};

		// Avaliable themes
		var themes = ['default', 'abcdef', 'cobalt', 'monokai', 'xq-light', 'vibrant-ink', 'solarized'];

		// Change monitor object
		var CheckCMEditorChanges = function (editor) {
			this.editor = editor;
			this.init();
		}
		CheckCMEditorChanges.prototype.changed = function (onOff) {
			var me = this;
			this._changed = onOff;
			if (onOff) {
				this.editor.off('change', function () {
					me.changed(true)
				});
			} else {
				this.editor.on('change', function () {
					me.changed(true)
				});
			}
		};

		CheckCMEditorChanges.prototype.init = function () {
			this.changed(false);
		};

		CheckCMEditorChanges.prototype.status = function () {
			return this._changed;
		};

		// Loading editor theme and font size from localStorage
		var currentTheme = 'default';
		var editorFontSize = '16px';
		if (window.localStorage) {
			if (localStorage.getItem('editorFontSize'))
				editorFontSize = localStorage.getItem('editorFontSize');
			if (localStorage.getItem('currentTheme'))
				currentTheme = localStorage.getItem('currentTheme');

		}
		CodeMirror.commands.save = function() {
			$('[data-action="save"]').trigger('click');
		};


		// Create CodeMirror editor
		var myEditor = CodeMirror(document.getElementById('css-editor'), {
			extraKeys: { "Ctrl-Space": "autocomplete" },
			lineNumbers: true,
			theme: currentTheme,
			gutters: ["CodeMirror-lint-markers"],
			lint: CodeMirror.lint.css,
			fullScreen: true,
			mode: 'css',
			value: <%= CssText %>
		});

		// Create changeMonitor
		var changesMonitor = new CheckCMEditorChanges(myEditor);

		// Create CSS preview
		var myCssPreview = CodeMirror(document.getElementById('css-preview-viewport'), {
			lineNumbers: false,
			theme: 'vibrant-ink',
			mode: 'css',
			readOnly: true
		});

		$(function () {

			// Update theme button label with theme saved il localStorge
			updateThemeBtnLabel(currentTheme);

			// Set editor font size to size saved in localStorage
			$('.CodeMirror').css('font-size', editorFontSize);

			// Tollbar buttons handlers
			$('.box-tools .btn').on('click', function () {
				var $this = $(this);
				var action = $this.attr('data-action');
				var $CodeMirror = $('.CodeMirror');
				var amount;
				switch (action) {
					case 'color-scheme':
						var currentTheme = myEditor.getOption('theme');
						var nextTheme = themes.getNext(currentTheme);
						myEditor.setOption('theme', nextTheme);
						updateThemeBtnLabel(nextTheme);
						if (window.localStorage)
							localStorage.setItem('currentTheme', nextTheme);
						break;
					case 'smaller-char':
						amount = parseInt($CodeMirror.css('font-size'));
						if (amount > 8)
							$CodeMirror.css('font-size', (amount - 2) + 'px');
						if (window.localStorage)
							localStorage.setItem('editorFontSize', $CodeMirror.css('font-size'));
						break;
					case 'larger-char':
						amount = parseInt($CodeMirror.css('font-size'));
						if (amount < 36)
							$CodeMirror.css('font-size', (amount + 2) + 'px');
						if (window.localStorage)
							localStorage.setItem('editorFontSize', $CodeMirror.css('font-size'));
						break;
					case 'save':
					case 'save-copy':
						$('.loading').fadeIn();
						var param = {};
						param.cssText = myEditor.getValue();
						param.insert = (action == 'save') ? 0 : 1;
						$.post('CustomCss/Save.ashx', param,	"json")
							.fail(function (jqxhr, textStatus, error) {
								bootbox.alert('Si è verificaro un errore: ' + textStatus + "," + error);
							})
							.done(function (data) {
								if (data.success) {
									bootbox.alert(data.msg);
								} else {
									bootbox.alert("Errore: " + data.msg);
								}
							})
							.always(function () {
								$('.loading').fadeOut();
							});
						changesMonitor.changed(false);
						break;
					default:

				}
			})
			// Pending changes control
			$(window).on('beforeunload', function () {
				if (changesMonitor.status())
					return 'Attenzione sono state rilevate modifiche non salvate.';
			});

			// Editor help modal
			$('#editor-help').on('show.bs.modal', function ( ) {  
				var $modalBody = $(this).find('.modal-body').html(''),
					p = $('<div />'),
					help = "",
					extrakeys = myEditor.getOption('extraKeys'),
					keymap = CodeMirror.keyMap[myEditor.getOption('keyMap')],
					commands = CodeMirror.commands;;
				for (var k in extrakeys) {
					if (commands[extrakeys[k]])
						help += '<kbd>' + k + '</kbd> ' + extrakeys[k] + '<br />';
				}
				for (var k in keymap) {
					if (commands[keymap[k]])
						help += '<kbd>' + k + '</kbd> ' + keymap[k] + '<br />';
				}
				p.html(help).appendTo($modalBody);
			});

			//Popolamento versioni 
			var $dropdown = $('.box-tools .btn-group');
			var $dropdownMenu = $dropdown.find('.dropdown-menu');

			$dropdown.on('shown.bs.dropdown', function ( ) { 
				var $dropdownToggle = $dropdown.find('.dropdown-toggle');

				$dropdownMenu
					.html('<li>&nbsp;</li><li>&nbsp;</li><li>&nbsp;</li><li>&nbsp;</li>')
					.spin();
				$.getJSON('CustomCss/GetSavedCss.ashx')
					.fail(function (jqxhr, textStatus, error) {
						bootbox.alert('Si è verificaro un errore: ' + textStatus + "," + error);
						$dropdownToggle.dropdown('toggle');
					})
					.done(function (data) {
						if (data.data) {
							$dropdownMenu.empty();
							if (data.data.length > 0) {
								for (var item = 0; item < data.data.length; item++) {
									var date = new Date(parseInt(data.data[item].LastModified.replace('/Date(', '')));
									var title = data.data[item].Title;
									if (title)
										title = '<i class="fa fa-archive"></i>' + title;
									var $a = $('<a />')
										.attr({
											'href': '#css-preview', 
											'data-pk': data.data[item].Pk,
											'data-toggle': 'modal'
										})
										.html(title || date2string(date));
									$('<li />').append($a).appendTo($dropdownMenu);

								}
							} else {
								$('<li />').text('Nessuna versione salvata').appendTo($dropdownMenu);
							}
						} else {
							bootbox.alert("Errore: " + data.msg);
						}
					})
					.always(function () {
						$dropdownMenu.spin(false);
					});
			});

			$dropdownMenu.on('click','a',function ( ) {  
				var $this = $(this),
					pk = $this.attr('data-pk');
				var getText = function (p) {  
					myCssPreview.setValue('');
					$.getJSON('CustomCss/GetRecord.ashx',{pk: p})
						.fail(function (jqxhr, textStatus, error) {
							bootbox.alert('Si è verificaro un errore: ' + textStatus + "," + error);
						})
						.done(function (data) {
							if (data.success) {
								myCssPreview.setValue(data.data);
							} else {
								bootbox.alert("Errore: " + data.msg);
							}
						})
						.always(function () {
							//$dropdownMenu.spin(false);
						});
				}	
				$('#css-preview').one('shown.bs.modal', function ( ) {
					getText(pk);
				});
			});

			$('#css-preview').on('hide.bs.modal', function ( ) {
				myCssPreview.setValue('');
			});

			$('#css-preview .modal-footer .btn').on('click', function() {
				var action = $(this).attr('data-action');
				switch (action) {
					case 'replace':
						myEditor.setValue(myCssPreview.getValue());
						break;
					case 'insert':
						myEditor.setValue(myEditor.getValue() + '\n' + myCssPreview.getValue());
						break;
					default:
				}
			});
		});
	</script>
</asp:Content>
