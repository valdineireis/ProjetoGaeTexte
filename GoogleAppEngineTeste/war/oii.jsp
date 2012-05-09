<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="javax.jdo.PersistenceManager" %>
<%@ page import="com.google.appengine.api.users.User" %>
<%@ page import="com.google.appengine.api.users.UserService" %>
<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>
<%@ page import="gaeteste.Greeting" %>
<%@ page import="gaeteste.PMF" %>

<html>
  <head>
  	<meta http-equiv="content-type" content="text/html; charset=UTF-8" />
	<meta http-equiv="content-language" content="pt-br" />
  	<title>Valdinei e Siluana</title>
  	<META HTTP-EQUIV="REFRESH" CONTENT="200;URL=http://valdineiesiluana.appspot.com">
    <link type="text/css" rel="stylesheet" href="/stylesheets/main.css" />
  </head>
  <body>
	<div id="conteudo">
		<%
		    UserService userService = UserServiceFactory.getUserService();
		    User user = userService.getCurrentUser();
		    if (user != null) {
		%>
		<p><h2>Olá, <%= user.getNickname() %>!</h2></p>
		<span>(Você pode <a href="<%= userService.createLogoutURL(request.getRequestURI()) %>">sair</a> se quiser.)</span>
		<%
		    } else {
		%>
		<h2>Olá!</h2>
		<span>
			<a href="<%= userService.createLoginURL(request.getRequestURI()) %>">Identifique-se aqui</a> para incluir o seu nome nas mensagens.
		</span>
		<%
		    }
		%>
		
		<hr/>
		
		<%
		    PersistenceManager pm = PMF.get().getPersistenceManager();
			String query = "select from " + Greeting.class.getName() + " order by date desc range 0,5";
		    List<Greeting> greetings = (List<Greeting>) pm.newQuery(query).execute();
		    if (greetings.isEmpty()) {
		%>
		
		<p>Sem mensagens até o momento.</p>
		<%
		    } else {
		        for (Greeting g : greetings) {
		            if (g.getAuthor() == null) {
		%>
		<p>Uma pessoa anônima escreveu:</p>
		<%
		            } else {
		%>
		<p><b><%= g.getAuthor().getNickname() %></b> escreveu:</p>
		<%
		            }
		%>
		<blockquote><%= g.getContent() %></blockquote>
		<%
		        }
		    }
		    pm.close();
		%>
		
		<hr/>
	
	    <form action="/sign" method="post">
	      <div><textarea name="content" rows="3" cols="25"></textarea></div>
	      <div><input type="submit" value="Enviar Mensagem" /></div>
	    </form>
	</div>
  </body>
</html>