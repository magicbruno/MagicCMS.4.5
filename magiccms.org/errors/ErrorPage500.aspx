<%@ Page Title="" Language="C#" MasterPageFile="~/errors/ErrorPage.master" AutoEventWireup="true" Inherits="MagicCMS.errors.errors_ErrorPage500" Codebehind="ErrorPage500.aspx.cs" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder_errorBody" Runat="Server">
    <p>Internal Server Error - Di norma questo errore si verifica quando si tenta di accedere alla amministrazione 
        del sito dopo un lungo periodo di inattvità (Sessione Scaduta) o durante la manutenzione del server. </p>
    <p><a href="/mb_admin/">Ripeti il login</a></p>
    <p><a href="/">Vai alla pagina iniziale</a></p>
</asp:Content>

