<%@ Master Language="C#" MasterPageFile="~/Themes/Winstrap/MasterTheme.master" AutoEventWireup="true" CodeBehind="SlideShow.master.cs" Inherits="$rootnamespace$.Themes.Winstrap.SlideShow" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="PageHeader" runat="server">
    <div class="jumbotron theme-alt">
        <div class="container-fluid">
            <asp:Repeater ID="RepeaterSequenza" runat="server" ItemType="MagicCMS.Core.MagicPost">
                <HeaderTemplate>
                    <ul class="mbslider fade" data-ride="mbslider">
                </HeaderTemplate>
                <ItemTemplate>
                    <li id='slide_<%# Item.Pk %>' <%# Item.Altezza > 0 ? "data-pauseafterin=" + Item.Altezza.ToString() : "" %> 
						<%# Item.Larghezza > 0 ? "data-pausebeforeout=" + Item.Larghezza.ToString() : "" %> >
                        <%# Item.TestoBreve_RT%>
                    </li>
                </ItemTemplate>
                <FooterTemplate>
                    </ul>
                </FooterTemplate>
            </asp:Repeater>
        </div>
    </div>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="Main_Content" runat="server">
	<div class="row">
		<div class="<%= FbColumn ? "col-md-16" : "col-md-22" %>">
			<%= ThePost.TestoLungo_RT %>
		</div>
		<asp:Repeater ID="Repeater_fb" runat="server" ItemType="MagicCMS.Facebook.FacebookPost">
			<HeaderTemplate>
				<aside class="col-md-7 col-md-offset-1">
					<div class="facebook">
						<h2><%= MagicCMS.Core.MagicTransDictionary.Translate("Notizie") %></h2>
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
					</div>
				</aside>
			</FooterTemplate>
		</asp:Repeater>
	</div>
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="PreScripts" runat="server">
</asp:Content>
<asp:Content ID="Content5" ContentPlaceHolderID="Scripts" runat="server">
</asp:Content>
