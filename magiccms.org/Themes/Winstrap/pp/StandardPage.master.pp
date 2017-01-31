<%@ Master Language="C#" MasterPageFile="~/Themes/Winstrap/TwoColumsTemplate.master" AutoEventWireup="true" CodeBehind="StandardPage.master.cs" Inherits="$rootnamespace$.Themes.Winstrap.StandardPage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="PageHeader" runat="server">
	<div class="page-header">
		<div class="container">
			<h1><%= ThePost.Title_RT %></h1>
			<div class="tags">
				<asp:Repeater ID="Repeater_tags" runat="server" ItemType="System.String">
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
		</div>
	</div>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="Main_Content" runat="server">
	<asp:PlaceHolder ID="PlaceHolderVideo" Visible="<%# ThePost.Tipo == MagicCMS.Core.MagicPostTypeInfo.PageWithVideo %>" runat="server">
		<div class="embed-responsive  <%= String.IsNullOrEmpty(ThePost.ExtraInfo2) ? "embed-responsive-16by9" : ThePost.ExtraInfo2 %>">
			<%# ThePost.ExtraInfo %>
		</div>
	</asp:PlaceHolder>
	<div>
		<%= ThePost.TestoLungo %>
	</div>
</asp:Content>
<asp:Content ID="Content6" ContentPlaceHolderID="Aside_content" runat="server">
	<asp:Repeater ID="Repeater_related" runat="server" ItemType="MagicCMS.Core.MagicPost">
		<HeaderTemplate>
			<h3><%# MagicCMS.Core.MagicTransDictionary.Translate("Vedi anche...") %></h3>
			<div class="related">				
		</HeaderTemplate>
			<ItemTemplate>
				<p><a href="<%# MagicCMS.Routing.RouteUtils.GetVirtualPath(Item.Pk) %>"><%# Item.Title_RT %></a></p>
			</ItemTemplate>
		<FooterTemplate>
			</div>
		</FooterTemplate>
	</asp:Repeater>
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="PreScripts" runat="server">
</asp:Content>
<asp:Content ID="Content5" ContentPlaceHolderID="Scripts" runat="server">
</asp:Content>
