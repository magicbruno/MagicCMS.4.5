<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/BaseAdmin.Master" AutoEventWireup="true"
    CodeBehind="Login2.aspx.cs" Inherits="MagicCMS.Admin.Login2" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        body {
            background-color: #222;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <section id="login-container" style="overflow: hidden">
        <div class="form-box bounce in animated veryfast" id="login-box">
            <div class="header">Richiedi password</div>
            <div class="body bg-gray">
                <div class="form-group">
                    <input type="email" class="form-control" id="email" placeholder="Email">
                </div>
            </div>
            <div class="footer">
                <a href="#" id="btn_request_pwd" class="btn bg-olive btn-block">Invia dati</a>
                <a href="login.aspx" class="btn bg-orange btn-block">Fai login</a>
            </div>

        </div>
    </section>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="Script" runat="server">
    <script type="text/javascript">
        // Reset password
        $(function () {
            $('#btn_request_pwd').on('click', function (e) {
                e.preventDefault();
                var usr_email = $('#email').val();
                var param = { email: usr_email };
                $.getJSON('Ajax/PwdRequest.ashx', param)
                    .fail(function (jqxhr, textStatus, error) {
                        bootbox.alert('Si è verificaro un errore: ' + textStatus + "," + error);
                    })
                    .done(function (data) {
                        if (data.success) {
                            bootbox.alert('La tua password è stata inviata con successo alla tua casella di posta.')
                        } else {
                            bootbox.alert("Errore: " + data.msg);
                        }
                    })
            })
        })

    </script>
</asp:Content>
