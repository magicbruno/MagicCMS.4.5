<%@ Master Language="C#" MasterPageFile="~/Themes/Winstrap/MasterTheme.master" AutoEventWireup="true" CodeBehind="ComingSoon.master.cs" 
	Inherits="$rootnamespace$.Themes.Winstrap.ComingSoon" %>
<%@ MasterType TypeName="$rootnamespace$.Themes.Winstrap.MasterTheme" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
	<link href="/Themes/Winstrap/js/mb-comingsoon/css/mb-comingsoon-iceberg.min.css" rel="stylesheet" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="PageHeader" runat="server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="Main_Content" runat="server">
	<%= ThePost.TestoLungo_RT %>
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="PreScripts" runat="server">
</asp:Content>
<asp:Content ID="Content5" ContentPlaceHolderID="Scripts" runat="server">
	<script src="/Themes/Winstrap/js/mb-comingsoon/js/jquery.mb-comingsoon.js"></script>
	<script>
		var dataStr = '<%= ExpiryDate %>';
		var myDate = new Date(dataStr);
		var selector = '<%= ThePost.ExtraInfo5 %>';
		$(selector).mbComingsoon(
			{
				expiryDate: myDate,   //Expiry Date required
				interval: 1000,   //Update interval in milliseconds (default = 1000))
				localization: {
					days: "giorni",           //Localize labels of counter
					hours: "ore",
					minutes: "minuti",
					seconds: "secondi"
				},
				callBack: null
		});
	</script>
</asp:Content>
