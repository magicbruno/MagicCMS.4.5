<%@ Page Title="" Language="C#" MasterPageFile="~/errors/ErrorPage.master" AutoEventWireup="true" Inherits="MagicCMS.errors.errors_ErrorPage400" Codebehind="ErrorPage400.aspx.cs" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder_errorBody" Runat="Server">
    <p>Bad Request - Richiesta non capita dal server causa sintassi errata. </p>
    <p><a href="/">Vai alla pagina iniziale</a></p>
        
</asp:Content>

