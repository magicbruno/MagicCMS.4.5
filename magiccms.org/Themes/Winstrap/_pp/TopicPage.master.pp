﻿<%@ Master Language="C#" MasterPageFile="~/Themes/Winstrap/MasterTheme.master" AutoEventWireup="true" CodeBehind="TopicPage.master.cs" Inherits="$rootnamespace$.Themes.Winstrap.TopicPage" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="PageHeader" runat="server">
	<header class="page-header">
		<div class="container">
			<div class="row">
				<div class="col-xs-24">
					<h1><%= ThePost.Title_RT %></h1>
					<ul class="nav nav-pills" data-scroll="smooth">
						<asp:Repeater ID="Repeater_TopicNavPills" runat="server" ItemType="MagicCMS.Core.MagicPost">
							<ItemTemplate>
								<li role="presentation">
									<a href="#<%# MagicCMS.Routing.MagicIndex.GetTitle(Item.Pk, MagicCMS.Core.MagicSession.Current.CurrentLanguage) %>"><%# Item.Title_RT %></a>
								</li>
							</ItemTemplate>
						</asp:Repeater>
					</ul>
				</div>
			</div>
		</div>
	</header>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="Main_Content" runat="server">
	<asp:Repeater ID="Repeater_TopicSections" runat="server"  ItemType="MagicCMS.Core.MagicPost">
		<ItemTemplate>
			<article class="section" id="<%#  MagicCMS.Routing.MagicIndex.GetTitle(Item.Pk, MagicCMS.Core.MagicSession.Current.CurrentLanguage)%>">
				<header class="section-header">
					<h2><%# Item.Title_RT %></h2>
				</header>
				<div class="row">
					<div class="col-xs-24">	
						<asp:PlaceHolder ID="PlaceHolderVideo" Visible="<%# Item.Tipo == MagicCMS.Core.MagicPostTypeInfo.PageWithVideo %>" runat="server">
							<div class="embed-responsive  <%# String.IsNullOrEmpty(Item.ExtraInfo2) ? "embed-responsive-16by9" : Item.ExtraInfo2 %>">
								<%# ThePost.ExtraInfo %>
							</div>
						</asp:PlaceHolder>
						<%#Item.TestoLungo_RT %>
					</div>
				</div>
			</article>
		</ItemTemplate>

	</asp:Repeater>
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="PreScripts" runat="server">
</asp:Content>
<asp:Content ID="Content5" ContentPlaceHolderID="Scripts" runat="server">
</asp:Content>
