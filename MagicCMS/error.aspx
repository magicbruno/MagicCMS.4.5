<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="error.aspx.cs" Inherits="MagicCMS.error" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<meta name="viewport" content="width=device-width; initial-scale=1" />
	<title>Error <%= ErrorNo %></title>
    <link href="Admin/assets-2022/css/bootstrap/bootstrap-grid.min.css" rel="stylesheet" />
	<link href="Admin/css/main.css" rel="stylesheet" />
	<style>
		body, html {
			background-color: #555;
			color: #fff;
		}
	</style>
</head> 
<body class="error-page container">
	<form id="form1" runat="server">
		<div class="error-page">
			<img class="center-block" src="/Admin/img/apple-touch-icon-180x180-precomposed.png" alt="" />
			<h3 class="text-center"><small><%= Brand %></small> </h3>
			<div class="headline text-center"><%= ErrorNo %></div>
			<div class="">
				<h3 class="text-center"><%= ShortMessage %></h3></div>
			<p class="text-center"><%= LongMessage %></p>
		</div>
		<div class="row justify-content-center">
			<div class="col-md-2 col-sm-3 col-xs-6"><a href="/" class="btn btn-block btn-primary">home</a></div>
			<div class="col-md-2 col-sm-3 col-xs-6"><a href="/Admin" class="btn btn-block btn-success">login</a></div>
		</div>
	</form>
</body>
</html>
