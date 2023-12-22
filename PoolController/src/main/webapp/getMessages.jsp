<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="java.io.*, java.util.*"%><%@page
  import="com.axiomtank.objectdb.*, java.util.*,org.apache.commons.lang3.*,
    com.axiomtank.common.objects.Role,
    com.axiomtank.util.Session,
    com.axiomtank.pool.controller.*"%>
  <%
  String __rolesNeeded[] = null;
  String _title = "";
  User user = (User) session.getAttribute("__user");
	if (user == null) {
		response.sendError(501, "Sesion timedout");
	}
	%>
	 <%@include file="common/common.inc"%>
	<%
	
	 Controller controller = Controller.getController();
	 ControllerState state = controller.getControllerState();
	 out.print(state.getControllerMessage().trim());
 %>
