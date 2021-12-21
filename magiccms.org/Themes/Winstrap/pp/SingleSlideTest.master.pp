<%@ Master Language="C#" MasterPageFile="~/Themes/Winstrap/MasterTheme.master" AutoEventWireup="true" CodeBehind="SingleSlideTest.master.cs" Inherits="$rootnamespace$.Themes.Winstrap.SingleSlideTest" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="PageHeader" runat="server">
	<div class="jumbotron theme-alt">
		<div class="container-fluid">
			<ul class="mbslider fade">
				<li id='slide_<%= ThePost.Pk %>' class="out" <%= ThePost.Altezza > 0 ? "data-pauseafterin=" + ThePost.Altezza.ToString() : "" %> 
						<%= ThePost.Larghezza > 0 ? "data-pausebeforeout=" + ThePost.Larghezza.ToString() : "" %>>
					<%= ThePost.TestoBreve_RT%>
				</li>
			</ul>
		</div>
	</div>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="Main_Content" runat="server">
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="PreScripts" runat="server">
</asp:Content>
<asp:Content ID="Content5" ContentPlaceHolderID="Scripts" runat="server">
	<script>
		$(function () {
			$(window).on('load', function () {
				var $slideElement = $('#slide_<%= ThePost.Pk %>');
				setTimeout(function () {
					$('.mbslider').removeClass('fade');
				}, 1500);
				$slideElement
					.removeClass('out')
					.addClass('in');
				setTimeout(function () {
					$slideElement
						.removeClass('in')
						.addClass('out');
				}, 8000);
			});
		});	</script>
</asp:Content>
