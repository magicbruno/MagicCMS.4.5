/*
 Copyright (c) 2003-2015, CKSource - Frederico Knabben. All rights reserved.
 For licensing, see LICENSE.md or http://ckeditor.com/license
*/
CKEDITOR.addTemplates("default",
	{
		imagesPath: "/Admin/Scripts/plugins/ckeditor/plugins/templates/images/",
		templates: [
			{
				title: "Bootstrap two columns",
				image: "template_2cols.png",
				description: "Two equal columns.",
				html: '<div class="row"><div class="col-sm-6">Insert content</div><div class="col-sm-6">Insert content</div></div>'
			},
			{
				title: "Bootstrap two columns 8-16",
				image: "template_2cols_sideBar_left.png",
				description: "One large column with left sidebar.",
				html: '<div class="row"><div class="col-sm-4">Insert content</div><div class="col-sm-8">Insert content</div></div>'
			},
			{
				title: "Bootstrap two columns 16-8",
				image: "template_2cols_sideBar_right.png",
				description: "One large column with right sidebar.",
				html: '<div class="row"><div class="col-sm-8">Insert content</div><div class="col-sm-4">Insert content</div></div>'
			},
			{
				title: "Bootstrap three columns",
				image: "template_3cols.png",
				description: "Three equal columns.",
				html: '<div class="row"><div class="col-sm-4">Insert content</div><div class="col-sm-4">Insert content</div><div class="col-sm-4">Insert content</div></div>'
			},
			{
				title: "Share button code",
				image: "addtoany-image.png",
				description: "Javascript code to customize Add to Any Share Button.",
				html:	"<div class=\"hidden customize_a2a\">\n" +
						"<h3>Passa in modalità &quot;Codice sorgente&quot; per personalizzare la configurazione.</h3>\n" +
						"<script>\n" +
						"  var a2a_config = a2a_config || {};\n" +
						"  //a2a_config.color_main = \"001030\";\n" +
						"  //a2a_config.color_border = \"002050\";\n" +
						"  //a2a_config.color_link_text = \"ffffff\";\n" +
						"  //a2a_config.color_link_text_hover = \"ffffff\";\n" +
						"  //a2a_config.color_bg = \"002050\";\n" +
						"  //a2a_config.icon_color = \"002050\";\n" +
						"</script>\n" +
						"</div>\n"
			},
			{
				title: "Bootstrap four columns",
				image: "bootstrap-framework-seeklogo.com.png",
				description: "Four equal columns.",
				html: '<div class="row"><div class="col-sm-3">Insert content</div><div class="col-sm-3">Insert content</div><div class="col-sm-3">Insert content</div><div class="col-sm-3">Insert content</div></div>'
			}]
	});
 