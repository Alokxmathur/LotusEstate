<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="java.io.*, java.util.*"%>
<%@page
  import="com.axiomtank.objectdb.*, java.util.*,org.apache.commons.lang3.*,com.axiomtank.common.objects.Role,com.axiomtank.pool.controller.*"%><%String __rolesNeeded[] = null;
  String _title = "Lotus Estate Hot Tub control";%>
 <%@include file="common/commonWithJSandCSS.inc"%>
 <%
 Controller controller = Controller.getController();
 ControllerState state = controller.getControllerState();
 controller.turnSpaOff();
 %>
 <div>
 	Hot tub turned off. Thanks for saving energy.
</div>
