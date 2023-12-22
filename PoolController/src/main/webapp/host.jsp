<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="java.io.*, java.util.*"%>
<%@page
  import="com.axiomtank.objectdb.*, 
  java.util.*,org.apache.commons.lang3.*,
  com.axiomtank.common.objects.Role,
  com.axiomtank.util.Session,
  com.axiomtank.pool.controller.*"%>
<%
  String __rolesNeeded[] = {"Admin", "SuperAdmin"};
  String _title = Session.getAppName() + " Host";
  boolean inAdvancedMode = "true".equals(request.getParameter("advancedMode"));
  %>
 <%@include file="common/commonWithJSandCSS.inc"%>
 <div class="container">
 	<div class="row">
 		<div class="col-xs-12 h4 text-muted text-center">Welcome <%=Session.getAppName() %> Host</div>
 	</div>

<div id="stateDiv" class="row">
</div>
<form name="poolControl" id="poolControl" method="post">
	<input type="hidden" name="command" id="command">
	<input type="hidden" name="advancedMode" id="advancedMode" value="<%=inAdvancedMode %>">
	<div class="row">
		<div class="col-xs-9">
			<input type="button" name="normalModeButton" id="normalModeButton" 
			value="Normal Mode"
			onclick="javasscript:switchAdvanced()"
			<%= !inAdvancedMode ? "disabled" : ""%>
			>
			<input type="button" name="advancedModeButton" id="advancedModeButton" 
			value="Diagnostic Mode"
			onclick="javasscript:switchAdvanced()"
			<%= inAdvancedMode ? "disabled" : ""%>
			>
		</div>
		<div class="col-xs-3">
			<input type="button" value="Guest Mode" class="button btn-basic" onClick="window.location='switchMode.jsp'">
		</div>
	</div>
</form>
</div>
<div id="dialogDiv"></div>
<script>
function update(){
    $.ajax({
        url: 'getState.jsp', // URL of the server-side script
        data: {
        	"advancedMode": $("#advancedMode").val()},
        success: function(data) {
            $('#stateDiv').html(data); // Update the content of the DIV element
        },
        failure: function(data) {
        	window.location = "host.jsp";
        }
    });
}
function issueCommand(command) {
	$("#command").val(command);
	$("#poolControl").submit();
	console.log(command);
}
function switchAdvanced() {
	if ("true" == $("#advancedMode").val()) {
		$("#advancedMode").val("false");
		$("#advancedModeButton").prop("disabled", false);
		$("#normalModeButton").prop("disabled", true);
	}
	else {
		$("#advancedMode").val("true");
		$("#advancedModeButton").prop("disabled", true);
		$("#normalModeButton").prop("disabled", false);
	}
    update();
}
$(document).ready(function(){
    update();
    setInterval(update, 3000); // Refresh the content every 3 seconds
});
<%Controller controller = Controller.getController();
ControllerState state = controller.getControllerState();
String command = request.getParameter("command");
if (command !=null && command.trim().length() > 0) {
	 controller.addRequest(command);
}%>
</script>