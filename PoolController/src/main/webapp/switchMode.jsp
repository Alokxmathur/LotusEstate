<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
String mode = (String) session.getAttribute("mode");
if (mode == null || mode.equals("guest")) {
	session.setAttribute("mode", "host");
	response.sendRedirect("host.jsp");
}
else {
	session.setAttribute("mode", "guest");
	response.sendRedirect("index.jsp");
}
%>