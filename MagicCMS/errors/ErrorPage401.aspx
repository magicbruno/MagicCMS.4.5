<%@ Page Title="" Language="C#" MasterPageFile="~/errors/ErrorPage.master" AutoEventWireup="true" Inherits="MagicCMS.errors.errors_ErrorPage401" Codebehind="ErrorPage401.aspx.cs" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder_errorBody" Runat="Server">
    <p>Authorization Required - La richiesta è sprovvista dell'autorizzazione necessaria. </p>
    <p><a href="/">Vai alla pagina iniziale</a></p>
</asp:Content>

