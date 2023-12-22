<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" 
    import="java.util.*, 
            com.axiomtank.objectdb.*, 
            com.axiomtank.common.objects.*, 
            com.axiomtank.common.authentication.Authenticator, com.axiomtank.util.Session
     "%>
<%
  String __rolesNeeded[] = null;
  String _title = Session.getAppName() + " Logout";
 %>
<%@include file="../../../common/commonWithMenuJSandCSS.inc" %> 
<%
session.invalidate();
RequestDispatcher dispatcher = request.getRequestDispatcher("/common/authentication/loginForm.jsp?reason=You have logged out"); 
dispatcher.forward(request, response);
return;
%>