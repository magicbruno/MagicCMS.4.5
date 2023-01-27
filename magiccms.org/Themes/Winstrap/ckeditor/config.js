/// <reference path="../../../Admin/Scripts/plugins/ckeditor/plugins/templates/default.js" />
/// <reference path="../../../Admin/Scripts/plugins/ckeditor/plugins/templates/default.js" />
/// <reference path="ckeditor.js" />

/**
 * @license Copyright (c) 2003-2014, CKSource - Frederico Knabben. All rights reserved.
 * For licensing, see LICENSE.md or http://ckeditor.com/license
 */

CKEDITOR.editorConfig = function( config ) {
	// Define changes to default configuration here.
	// For complete reference see:
	// http://docs.ckeditor.com/#!/api/CKEDITOR.config

    // The toolbar groups arrangement, optimized for two toolbar rows.

    config.toolbarGroups = [
		{ name: 'clipboard', groups: ['clipboard', 'undo'] },
		{ name: 'editing', groups: ['find', 'selection', 'spellchecker'] },
		{ name: 'links' },
		{ name: 'insert' },
		{ name: 'forms' },
		{ name: 'tools' },
		{ name: 'document', groups: ['mode', 'document', 'doctools'], modes: { wysiwyg: 1, source: 1 } },
		{ name: 'others' },
		'/',
		{ name: 'basicstyles', groups: ['basicstyles', 'cleanup'] },
		{ name: 'paragraph', groups: ['list', 'indent', 'blocks', 'align', 'bidi'] },
		{ name: 'styles' },
		{ name: 'colors' },
		{ name: 'about' }
    ];

	// Remove some buttons provided by the standard plugins, which are
	// not needed in the Standard(s) toolbar.
	config.removeButtons = 'Underline,Subscript,Superscript,Save';

	// Set the most common block elements.
	config.format_tags = 'p;h1;h2;h3;h4;h5;pre;div';

	// Simplify the dialog windows.
	//config.removeDialogTabs = 'image:advanced;link:advanced';
	config.contentsCss = '/Themes/Winstrap/ckeditor/contents.css';

	config.filebrowserBrowseUrl = '/Admin/FileManager.aspx';
	config.filebrowserFlashBrowseUrl = '/Admin/FileManager.aspx';
	config.filebrowserImageBrowseUrl = '/Admin/FileManager.aspx?type=image';
	config.filebrowserImageBrowseLinkUrl = '/Admin/FileManager.aspx';

	config.filebrowserWindowHeight = '70%';
	config.filebrowserWindowWidth = '70%';
	config.allowedContent = true;
	config.minimumChangeMilliseconds = 200;

	// Prevent adding with and height style properties to img 
	config.disallowedContent = 'img{width,height}';
	config.extraAllowedContent = 'img[width,height]';


	config.templates_files = ['/Themes/Winstrap/ckeditor/plugins/templates/default.js'];
  
	config.templates_replaceContent = false;

	CKEDITOR.dtd.$removeEmpty['i'] = false;
	CKEDITOR.dtd.$removeEmpty['span'] = false;

	config.stylesSet = [
        { name: 'Img responsive', element: 'img', attributes: { 'class': 'img-responsive', style: '' } },
        { name: 'Img circle', element: 'img', attributes: { 'class': 'img-responsive img-circle', style: '' } },
        { name: 'Center block (img)', element: 'img', attributes: { 'class': 'center-block' } },
        { name: 'Table', element: 'table', attributes: { 'class': 'table' } },
        { name: 'Table stripped', element: 'table', attributes: { 'class': 'table-striped' } },
        { name: 'Table bordered', element: 'table', attributes: { 'class': 'table-bordered' } },
        { name: 'Table condensed', element: 'table', attributes: { 'class': 'table-condensed' } },
        { name: 'Clearfix', element:'div', attributes: { 'class': 'clearfix' } },
        { name: 'Big', element: 'big' },
        { name: 'Small', element: 'small' },
        { name: 'Code', element: 'code' },
        { name: 'Kbd', element: 'kbd' },
        { name: 'Var', element: 'var' },
        { name: 'Sample', element: 'sample' }
	]
};
