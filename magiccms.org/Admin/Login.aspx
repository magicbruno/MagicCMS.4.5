﻿<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/BaseAdmin.Master" AutoEventWireup="true"
    CodeBehind="Login.aspx.cs" Inherits="MagicCMS.Admin.Login" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        body {
            background-color: #222;
        }
    </style>
    <% = Captcha ? "<script src='https://www.google.com/recaptcha/api.js'></script>" : "" %>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <section id="login-container" style="overflow: hidden">
        <div class="form-box bounce in animated veryfast" id="login-box">
            <div class="header"><%= Translate("Accesso") %></div>
            <div class="body bg-gray">
                <div class="form-group">
                    <asp:TextBox ID="email" TextMode="SingleLine" CssClass="form-control" runat="server"
                        placeholder="Email"></asp:TextBox>
                </div>
                <div class="form-group">
                    <asp:TextBox ID="password" TextMode="Password" CssClass="form-control" runat="server"
                        placeholder="Password"></asp:TextBox>
                    <a href="login2.aspx" class="help-block"><%= Translate("Password dimenticata") %>?</a>
                </div>
                <div class="g-recaptcha" runat="server" id="recaptchaVerify"></div>
            </div>
            <div class="footer">
                <asp:Button ID="Button1" runat="server" Text="Invia dati"
                    CssClass="btn bg-olive btn-block" OnClick="Button_submit_Click" />
                <a href="login2.aspx" class="btn btn-block bg-orange"><%= Translate("Primo accesso") %></a>
            </div>
        </div>
    </section>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="Script" runat="server">
    <script>
        $("#aspnetForm").on('submit', function (e) {
            if ($('#g-recaptcha-response').length) {
                if (!$('#g-recaptcha-response').val()) {
                    e.preventDefault();
                    bootbox.alert("<%= Translate("È necessario eseguire la verifica reCaptcha") %>!");
                }
            }
        });
    </script>
</asp:Content>
