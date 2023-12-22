<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="java.io.*, java.util.*"%>
<%@page
  import="com.axiomtank.objectdb.*, java.util.*,org.apache.commons.lang3.*,com.axiomtank.common.objects.Role,com.axiomtank.pool.controller.*"%><%String __rolesNeeded[] = null;
  String _title = "Lotus Estate Hot Tub";%>
 <%@include file="common/common.inc"%>
 <%
   Controller controller = Controller.getController();
   ControllerState state = controller.getControllerState();
   String command = request.getParameter("command");
   if (command !=null) {
  	 controller.addRequest(command);
   }
  out.print("Welcome to the Lotus Estate.<br><br>");
  int spaTemp = state.getSpaTemp();
  if (state != null && state.isHotTubSetup()) {
  	if (spaTemp >= 95) {
  		out.print("The hot tub is ready. Water temperature is " + spaTemp + "&deg;F.");
  	}
  	else {
  		out.print("The hot tub is currently at " + spaTemp + "&deg;F. Needs a bit more time to heat up. Our guess is " + ((100-spaTemp) * 2) + " minutes.");
  	}
  }
  else {
 %>
	<div>
		The Lotus Estate Hot tub is not turned on.
	</div>
	<div>
		The current water temperature is <%=spaTemp>0 ? (spaTemp + "&deg;F") : "not known"%>.
	</div>
	<%
}
%>
