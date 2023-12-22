<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="
      com.axiomtank.common.objects.User
    "%><%
    User user = (User) session.getAttribute("__user");
    if (user == null) {
      out.println("Not logged in"); 
    }
    else {
      String[] acceptableRoles = request.getParameterValues("roles");
      if (acceptableRoles == null) {
        out.println("Yes"); 
      }
      else {
        for (String role : acceptableRoles) {
        	if (user.getRoles().contains(role)) {
              out.println("Yes");  
          }
        }
        out.println("Not authorized");
      }
    }
%>