<%@ Page Title="" Language="C#" MasterPageFile="~/errors/ErrorPage.master" AutoEventWireup="true" Inherits="MagicCMS.errors.errors_ErrorPage404" Codebehind="ErrorPage404.aspx.cs" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder_errorBody" Runat="Server">
    <p>Not Found - La risorsa richiesta non esiste su questo server. </p>
    <p><a href="/">Vai alla pagina iniziale</a></p>
</asp:Content>

