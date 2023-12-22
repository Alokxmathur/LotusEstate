<!doctype html>
<html lang="us">
<%@ page
  language="java"
  contentType="text/html; charset=ISO-8859-1"
  pageEncoding="ISO-8859-1"%>
<%@page
  import="com.axiomtank.objectdb.*, 
  java.util.*, 
  org.apache.commons.lang3.StringUtils,
  com.axiomtank.common.objects.User, com.axiomtank.util.Session"%>
<%
  String __rolesNeeded[] = null;
  String _title = Session.getAppName() + " Reset Password";
  String token = request.getParameter("p");
 %>
<%@include file="../commonWithJSandCSS.inc"%>
<%
User user = (User) session.getAttribute("requestingUser");
String expectedToken = (String) session.getAttribute("resetToken");
String providedToken = request.getParameter("token");
Date expirationDate = (Date) session.getAttribute("resetExpiration");
if (user == null || expectedToken == null || expirationDate == null) {
   out.println("The password reset session seems to have expired. Click <a href='passwordReset.jsp'>here </a>to try again.");
   return;
}
if (providedToken == null || providedToken.trim().length() == 0) {
	   out.println("You must provide a token to reset your password. Click <a href='javascript:window.history.back()'>here </a>to try again.");
	   return;
}

if (!expectedToken.equals(providedToken) || (new Date().after(expirationDate))) {
	   out.println("The tokens don't match or your session has expired. Click <a href='passwordReset.jsp'>here </a>to try again.");
	   return;
}
session.setAttribute("resetPasswordUser", user);
RequestDispatcher dispatcher = request.getRequestDispatcher("newPassword.jsp"); 
dispatcher.forward(request, response);
%>
</body>
</html>