<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/BaseAdmin.Master" AutoEventWireup="true"
    CodeBehind="Login2.aspx.cs" Inherits="MagicCMS.Admin.Login2" %>

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
            <div class="header"><%= Translate("Richiedi password") %></div>
            <div class="body bg-gray">
                <div class="form-group">
                    <input type="email" class="form-control" id="email" placeholder="Email">
                </div>
                <div class="g-recaptcha" runat="server" id="recaptchaVerify"></div>
            </div>
            <div class="footer">
                <a href="#" id="btn_request_pwd" class="btn bg-olive btn-block"><%= Translate("Invia richiesta") %></a>
                <a href="login.aspx" class="btn bg-orange btn-block"><%= Translate("Vai al login") %></a>
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
                var googleRecaptcha, param;
                if ($('#g-recaptcha-response').length) {
                	googleRecaptcha = $('#g-recaptcha-response').val();
                	if (!googleRecaptcha) {
                		e.preventDefault();
                		bootbox.alert("<%= Translate("È necessario eseguire la verifica reCaptcha") %>!");
						return;
                	}
                	param = { email: usr_email, "g-recaptcha-response": googleRecaptcha };
                } else {
                	param = { email: usr_email };
                };
                
                $.post('Ajax/PwdRequest.ashx', param, 'JSON')
                    .fail(function (jqxhr, textStatus, error) {
                    	bootbox.alert('<%= Translate("Si è verificaro un errore") %>: ' + textStatus + "," + error);
                    })
                    .done(function (data) {
                        if (data.success) {
                        	bootbox.alert('<%= Translate("La tua password è stata inviata con successo alla tua casella di posta") %>.')
                        } else {
                        	bootbox.alert("<%= Translate("Errore") %>: " + data.msg);
                        }
                    })
            })
        })

    </script>
</asp:Content>
