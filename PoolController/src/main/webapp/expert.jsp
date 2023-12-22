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
	<div class="row">
		<div class=".col.xs-4">Show system messages: <input type="checkbox" name="advancedMode" id="advancedMode" value="true"
		<%="true".equals(request.getParameter("advancedMode")) ? "checked" :"" %>></div>
	</div>
	<div class="row">
		<div class=".col.xs-4">
			<textarea rows=4 cols=80 name="messages" id="messages"></textarea>
		</div>
	</div>
	<div class="row">
		<div class=".col-xs-12">
			<a href="switchMode.jsp">
				<input type="button" value="Guest Mode" class="button btn-basic align-right">
			</a>
		</div>
	</div>
</form>
</div>
<div id="dialogDiv"></div>
<script>
function issueCommand(command) {
	$("#command").val(command);
	$("#poolControl").submit();
	console.log(command);
}
$(document).ready(function(){
    $.ajax({
        url: 'getState.jsp', // URL of the server-side script
        data: {"advancedMode": $("#advancedMode").prop('checked')},
        success: function(data) {
            $('#stateDiv').html(data); // Update the content of the DIV element
        }
    });
    $.ajax({
        url: 'getMessages.jsp', // URL of the server-side script
        success: function(data) {
            $('#messages').val(data); // Update the content of the DIV element
        },
        failure: function(data) {
        	window.location = "host.jsp";
        }
    
    });
    setInterval(function(){
        console.log("State update");
        $.ajax({
            url: 'getState.jsp', // URL of the server-side script
            data: {"advancedMode": $("#advancedMode").prop('checked')},
            success: function(data) {
                $('#stateDiv').html(data); // Update the content of the DIV element
            },
            failure: function(data) {
            	window.location = "host.jsp";
            }
        
        });
        $.ajax({
            url: 'getMessages.jsp', // URL of the server-side script
            success: function(data) {
                $('#messages').val(data); // Update the content of the DIV element
            },
            failure: function(data) {
            	window.location = "host.jsp";
            }
        
        });
      }, 3000); // Refresh the content every 3 seconds
});
<%Controller controller = Controller.getController();
ControllerState state = controller.getControllerState();
String command = request.getParameter("command");
if (command !=null && command.trim().length() > 0) {
	 controller.addRequest(command);
}%>
</script>