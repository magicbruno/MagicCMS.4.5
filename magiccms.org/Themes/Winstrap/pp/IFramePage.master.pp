﻿<%@ Master Language="C#" MasterPageFile="~/Themes/Winstrap/MasterTheme.master" AutoEventWireup="true" CodeBehind="IFramePage.master.cs" Inherits="$rootnamespace$.Themes.Winstrap.IFramePage" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="PageHeader" runat="server">
	<div class="fullscreen">
		<iframe src="<%= ThePost.Url %>"></iframe>
	</div>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="Main_Content" runat="server">
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="PreScripts" runat="server">
</asp:Content>
<asp:Content ID="Content5" ContentPlaceHolderID="Scripts" runat="server">
</asp:Content>
