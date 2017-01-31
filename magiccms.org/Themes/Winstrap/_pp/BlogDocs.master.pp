<%@ Master Language="C#" MasterPageFile="~/Themes/Winstrap/TwoColumsTemplate.master" AutoEventWireup="true" CodeBehind="BlogDocs.master.cs" Inherits="$rootnamespace$.Themes.Winstrap.BlogDocs" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="PageHeader" runat="server">
	<header class="page-header">
		<div class="container">
			<div class="row">
				<div class="col-xs-24">
					<h1><%= ThePost.Title_RT %></h1>
				</div>
			</div>
		</div>
	</header></asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="Main_Content" runat="server">
	<div class="article-list">
		<asp:Repeater ID="Repeater_Articles" runat="server" ItemType="MagicCMS.Core.MagicPost" OnItemDataBound="Repeater_tags_ItemDataBound">
			<ItemTemplate>
				<article>
					<header class="article-header">
						<h2><a href="<%# MagicCMS.Routing.RouteUtils.GetVirtualPath(Item.Pk, ThePost.Pk) %>"><%# Item.Title_RT %></a></h2>
						<div class="tags">
							<asp:Repeater ID="Repeater_tags" runat="server" ItemType="System.String" >
								<HeaderTemplate>

									<ul class="list-inline">
								</HeaderTemplate>
								<ItemTemplate>
									<li>
										<a href="<%# !String.IsNullOrEmpty(TagSearchUrl) ? TagSearchUrl + "q=" + Item + "/" : "#" %>" class="label label-info"><%# Item %></a>
									</li>
								</ItemTemplate>
								<FooterTemplate>
									</ul>
								</FooterTemplate>
							</asp:Repeater>
						</div>
					</header>
					<div class="article-body">
						<%# Item.TestoBreve_RT %>
					</div>
					<p><a href="<%# MagicCMS.Routing.RouteUtils.GetVirtualPath(Item.Pk, ThePost.Pk) %>">Leggi tutto...</a></p>
				</article>
			</ItemTemplate>
		</asp:Repeater>
	</div>
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="Aside_content" runat="server">
	<div class="facebook">
		<h3><%= MagicCMS.Core.MagicTransDictionary.Translate("Notizie") %></h3>
		<asp:Repeater ID="Repeater_fb" runat="server" ItemType="MagicCMS.Facebook.FacebookPost">
			<HeaderTemplate>
				<ul class="media-list">
			</HeaderTemplate>
			<ItemTemplate>
				<li class="media">
					<div class="media-left">
						<a href="<%# Item.Permalink_Url %>" title="Vai al post" target="_blank">
							<div class="media-object" style="background-image: url(<%# Item.Picture %>)"></div>
						</a>
					</div>
					<div class="media-body">
						<h4 class="media-heading"><%# Item.Time_ago %></h4>
						<a href="<%# Item.Permalink_Url %>" title="Vai al post" target="_blank">
							<%# System.StringHtmlExtensions.TruncateWords(Item.Message, 140,"...") %>
						</a>
						<%# (String.IsNullOrEmpty(Item.Link) ? "" :"<a target=\"_blank\" href=\"" + Item.Link + "\">" + Item.Link + "</a>" ) %>
					</div>
				</li>
			</ItemTemplate>
			<FooterTemplate>
				</ul>
			</FooterTemplate>
		</asp:Repeater>
	</div>
</asp:Content>
<asp:Content ID="Content5" ContentPlaceHolderID="PreScripts" runat="server">
</asp:Content>
<asp:Content ID="Content6" ContentPlaceHolderID="Scripts" runat="server">
</asp:Content>
