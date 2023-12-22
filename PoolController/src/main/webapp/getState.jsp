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
 <style>
.switch {
	position: relative;
	display: block;
	vertical-align: top;
	width: 100px;
	height: 30px;
	padding: 3px;
	margin: 0 10px 10px 0;
	background: linear-gradient(to bottom, #eeeeee, #FFFFFF 25px);
	background-image: -webkit-linear-gradient(top, #eeeeee, #FFFFFF 25px);
	border-radius: 18px;
	box-shadow: inset 0 -1px white, inset 0 1px 1px rgba(0, 0, 0, 0.05);
	cursor: pointer;
	box-sizing:content-box;
}
.switch-input {
	position: absolute;
	top: 0;
	left: 0;
	opacity: 0;
	box-sizing:content-box;
}
.switch-label {
	position: relative;
	display: block;
	height: inherit;
	font-size: 10px;
	text-transform: uppercase;
	background: #eceeef;
	border-radius: inherit;
	box-shadow: inset 0 1px 2px rgba(0, 0, 0, 0.12), inset 0 0 2px rgba(0, 0, 0, 0.15);
	box-sizing:content-box;
}
.switch-label:before, .switch-label:after {
	position: absolute;
	top: 50%;
	margin-top: -.5em;
	line-height: 1;
	-webkit-transition: inherit;
	-moz-transition: inherit;
	-o-transition: inherit;
	transition: inherit;
	box-sizing:content-box;
}
.switch-label:before {
	content: attr(data-off);
	right: 11px;
	color: #aaaaaa;
	text-shadow: 0 1px rgba(255, 255, 255, 0.5);
}
.switch-label:after {
	content: attr(data-on);
	left: 11px;
	color: #FFFFFF;
	text-shadow: 0 1px rgba(0, 0, 0, 0.2);
	opacity: 0;
}
.switch-input:checked ~ .switch-label {
	background: #E1B42B;
	box-shadow: inset 0 1px 2px rgba(0, 0, 0, 0.15), inset 0 0 3px rgba(0, 0, 0, 0.2);
}
.switch-input:checked ~ .switch-label:before {
	opacity: 0;
}
.switch-input:checked ~ .switch-label:after {
	opacity: 1;
}
.switch-handle {
	position: absolute;
	top: 4px;
	left: 4px;
	width: 28px;
	height: 28px;
	background: linear-gradient(to bottom, #FFFFFF 40%, #f0f0f0);
	background-image: -webkit-linear-gradient(top, #FFFFFF 40%, #f0f0f0);
	border-radius: 100%;
	box-shadow: 1px 1px 5px rgba(0, 0, 0, 0.2);
}
.switch-handle:before {
	content: "";
	position: absolute;
	top: 50%;
	left: 50%;
	margin: -6px 0 0 -6px;
	width: 12px;
	height: 12px;
	background: linear-gradient(to bottom, #eeeeee, #FFFFFF);
	background-image: -webkit-linear-gradient(top, #eeeeee, #FFFFFF);
	border-radius: 6px;
	box-shadow: inset 0 1px rgba(0, 0, 0, 0.02);
}
.switch-input:checked ~ .switch-handle {
	left: 74px;
	box-shadow: -1px 1px 5px rgba(0, 0, 0, 0.2);
}
 
/* Transition
========================== */
.switch-label, .switch-handle {
	transition: All 0.3s ease;
	-webkit-transition: All 0.3s ease;
	-moz-transition: All 0.3s ease;
	-o-transition: All 0.3s ease;
}
/* Switch Flat
==========================*/
.switch-flat {
	padding: 0;
	background: #FFF;
	background-image: none;
}
.switch-flat .switch-label {
	background: #FFF;
	border: solid 2px #eceeef;
	box-shadow: none;
}
.switch-flat .switch-label:after {
	color: #0088cc;
}
.switch-flat .switch-handle {
	top: 6px;
	left: 6px;
	background: #dadada;
	width: 22px;
	height: 22px;
	box-shadow: none;
}
.switch-flat .switch-handle:before {
	background: #eceeef;
}
.switch-flat .switch-input:checked ~ .switch-label {
	background: #FFF;
	border-color: #0088cc;
}
.switch-flat .switch-input:checked ~ .switch-handle {
	left: 72px;
	background: #0088cc;
	box-shadow: none;
}
</style>
 <%
 Controller controller = Controller.getController();
 ControllerState state = controller.getControllerState();
 String pendingDisplay = state.getPendingRequestsStatus();

 %>
	<%
		int spaCountDown = state.getSpaCountDownMinutes();
		String spaMessage = "";
		if (state.getMode()==ControllerState.Mode.Spa && spaCountDown > 0) {
			if (spaCountDown > 59) {
				int spaHours = (int) spaCountDown/60;
				int spaMinutes = spaCountDown % 60;
				spaMessage = " (" + spaHours + ":" + spaMinutes + ")";
			}
			else if (spaCountDown > 1) {
				spaMessage = (" (" + spaCountDown + ")");
			}
		}
	%>
	<div class="row">
		<div class="col-xs-4 h4 text-muted">Hot tub</div>
		<div class="col-xs-8">
			<%
			if (pendingDisplay.indexOf("HotTub") < 0) {
			%>
				<label class="switch switch-flat">
					<input 
						class="switch-input" 
						type="checkbox" <%=(state.isHotTubSetup() ? "checked": "")%> 
						onclick="javascript:issueCommand('HotTub<%=(state.isHotTubSetup() ? "Off": "On")%>');"
						<%= pendingDisplay.indexOf("HotTub") >= 0 ? "diabled" : ""%>
					/>
					<span class="switch-label" data-on="On" data-off="Off"></span> 
					<span class="switch-handle"></span> 
				</label>
				<%
				int spaTemp = state.getSpaTemp();
				if (spaTemp >= 95) {
					out.print("Ready. " + spaTemp + "&deg;F.");
				}
				else if (spaTemp > 0) {
					out.print (spaTemp + "&deg;F. ~ ");
					int readyTime = (100-spaTemp) * 3;
					int readyHours = (int) readyTime/60;
					int readyMinutes = readyTime % 60;
					if (readyHours > 0) {
						out.print(readyHours + " hr "); 
					}
					out.print(readyMinutes + " min to ready");
				}
			}
			else {
			%>
			<img src="common/assets/images/loading.gif" height="10px">
			<%
			}
			%>
		</div>		
	</div>
 	<div class="row">
 		<div class="col-xs-12 h4 text-muted text-center">Individual controls</div>
 	</div>
 	<div class="row">
		<div class="col-xs-4">Mode</div>
		<div class="col-xs-8">
			<input type="button" class="btn <%="Pool".equalsIgnoreCase(state.getMode().toString()) ? "btn-success" : "btn-basic" %>" onClick="javascript:issueCommand('PoolMode');" value="Pool" <%=pendingDisplay.indexOf("PoolMode") >= 0 ? " disabled" : "" %>>
			<%
			if (pendingDisplay.indexOf("PoolMode") >= 0) {
			%>
			<img src="common/assets/images/loading.gif" height="10px">
			<%
			}
			%>
			
			<input type="button" class="btn <%="Spa".equalsIgnoreCase(state.getMode().toString()) ? "btn-success" : "btn-basic" %>" onClick="javascript:issueCommand('SpaMode');" value="Spa<%=spaMessage%>" <%=pendingDisplay.indexOf("SpaMode") >= 0 ? " disabled" : "" %>>
						<%
			if (pendingDisplay.indexOf("SpaMode") >= 0) {
			%>
			<img src="common/assets/images/loading.gif" height="10px">
			<%
			}
			%>
			<input type="button" class="btn <%="SpillOver".equalsIgnoreCase(state.getMode().toString()) ? "btn-success" : "btn-basic" %>" onClick="javascript:issueCommand('SpillOverMode');" value="SpillOver" <%=pendingDisplay.indexOf("SpillOverMode") >= 0 ? " disabled" : "" %>>
						<%
			if (pendingDisplay.indexOf("SpillOverMode") >= 0) {
			%>
			<img src="common/assets/images/loading.gif" height="10px">
			<%
			}
			%>
		</div>
	</div>
	<div class="row">
		<div class="col-xs-4">Filter</div>		 	
		<div class="col-xs-8">
			<%
			if (pendingDisplay.indexOf("Filter") >= 0) {
			%>
			<img src="common/assets/images/loading.gif" height="10px">
			<%
				if (state.getControllerMessage().indexOf("Valves") > -1) {
					out.print(state.getControllerMessage());
				}
			}
			else {
			%>	
			<label class="switch switch-flat">
				<input class="switch-input" type="checkbox" <%=(state.isFilterOn() ? "checked": "")%> onclick="javascript:issueCommand('Filter<%=(state.isFilterOn() ? "Off": "On")%>');"/>
				<span class="switch-label" data-on="On" data-off="Off"></span> 
				<span class="switch-handle"></span> 
			</label>
			<%
			}
			%>
		</div>
	</div>
	<div class="row">
		<div class="col-xs-4">Cleaner</div>
		<div class="col-xs-8">
			<%
			if (pendingDisplay.indexOf("Cleaner") >= 0
				|| pendingDisplay.indexOf("Mode") >= 0
				|| pendingDisplay.indexOf("Filter") >= 0
				)
			{
			%>
			<img src="common/assets/images/loading.gif" height="10px">
			<%
				if (state.getControllerMessage().indexOf("Interlock") > -1) {
					out.print(state.getControllerMessage());
				}
			}
			else if (state.canCleanerBeOn()) {
			%>
			<label class="switch switch-flat">
				<input class="switch-input" type="checkbox" <%=(state.isCleanerOn() ? "checked": "")%> onclick="javascript:issueCommand('Cleaner<%=(state.isCleanerOn() ? "Off": "On")%>');"/>
				<span class="switch-label" data-on="On" data-off="Off"></span> 
				<span class="switch-handle"></span> 
			</label>
			<%
			}
			else {
			%>
				Cleaner can be on only in pool mode with filter on
			<%
			}
			%>
		</div>		
	</div>
	<div class="row">
		<div class="col-xs-4">Heater</div>
		<div class="col-xs-8">
			<%
			if (pendingDisplay.indexOf("Heater") >= 0) {
			%>
			<img src="common/assets/images/loading.gif" height="10px">
			<%
			}
			else {
			%>
			<label class="switch switch-flat">
				<input class="switch-input" type="checkbox" <%=(state.isHeaterOn() ? "checked": "")%> onclick="javascript:issueCommand('Heater<%=(state.isHeaterOn() ? "Off": "On")%>');"/>
				<span class="switch-label" data-on="On" data-off="Off"></span> 
				<span class="switch-handle"></span> 
			</label>
			<%
			}
			%>
		</div>	
	</div>
	<div class="row">
		<div class="col-xs-4">Jets</div>
		<div class="col-xs-8">
			<%
			if (pendingDisplay.indexOf("Jets") >= 0) {
			%>
			<img src="common/assets/images/loading.gif" height="10px">
			<%
			}
			else {
			%>	
			<label class="switch switch-flat">
				<input class="switch-input" type="checkbox" <%=(state.areJetsOn() ? "checked": "")%> onclick="javascript:issueCommand('Jets<%=(state.areJetsOn() ? "Off": "On")%>');"/>
				<span class="switch-label" data-on="On" data-off="Off"></span> 
				<span class="switch-handle"></span> 
			</label>
			<%
			}
			%>
		</div>		
	</div>
	<div class="row">
		<div class="col-xs-4">Pool Lights</div>		
		<div class="col-xs-8">
		<%
		if (pendingDisplay.indexOf("PoolLights") >= 0) {
		%>
		<img src="common/assets/images/loading.gif" height="10px">
		<%
		}
		else {
		%>		
			<label class="switch switch-flat">
				<input class="switch-input" type="checkbox" <%=(state.arePoolLightsOn() ? "checked": "")%> onclick="javascript:issueCommand('PoolLights<%=(state.arePoolLightsOn() ? "Off": "On")%>');"/>
				<span class="switch-label" data-on="On" data-off="Off"></span> 
				<span class="switch-handle"></span> 
			</label>
		<%
		}
		%>
		</div>		
	</div>
	<div class="row">
		<div class="col-xs-4">Spa Light</div>
		<div class="col-xs-8">
			<%
			if (pendingDisplay.indexOf("SpaLight") >= 0) {
			%>
			&nbsp;<img src="common/assets/images/loading.gif" height="10px">
			<%
			}
			else {
			%>
			<label class="switch switch-flat">
				<input class="switch-input" type="checkbox" <%=(state.isSpaLightOn() ? "checked": "")%> onclick="javascript:issueCommand('SpaLight<%=(state.isSpaLightOn() ? "Off": "On")%>');"/>
				<span class="switch-label" data-on="On" data-off="Off"></span> 
				<span class="switch-handle"></span> 
			</label>
			<%
			}
			%>
		</div>		
	</div>
	<div class="row">
		<div class="col-xs-4">Temps</div>
		<div class="col-xs-8">
			Spa: <%=state.getSpaTemp() > 0 ? state.getSpaTemp() + "&deg F" : "_"%>, 
			Pool:<%=state.getPoolTemp() > 0 ? state.getPoolTemp() + "&deg F" : "_"%>,
			Air:<%=state.getAirTemp() > 0 ? state.getAirTemp() + "&deg F" : "_"%>
		</div>
	</div>
	<div class="row">
		<div class="col-xs-4">Pending Commands</div>
		<div class="col-xs-8">
			<b><%=pendingDisplay.toString()%></b>
		</div>
	</div>
	<div class="row">
		<div class="col-xs-4">System Message</div>
		<div class="col-xs-8">
			<%=state.getControllerMessage().replaceAll("_F", "&deg;F")%>
		</div>
	</div>
	<%
	if ("true".equals(request.getParameter("advancedMode"))) {
	%>
	<div class="row">
		<div class="col-xs-4">Salt Level</div>
		<div class="col-xs-8">
			<%=state.getSaltLevel() %> ppm
		</div>
	</div>
	<div class="row">
		<div class="col-xs-4">Pool Chlorination</div>
		<div class="col-xs-8">
			<%=state.getPoolChlorinator() %>%
		</div>
	</div>
		<div class="row">
		<div class="col-xs-4">Spa Chlorination</div>
		<div class="col-xs-8">
			<%=state.getSpaChlorinator() %>%
		</div>
	</div>
	<%
	if (state.getCheckSystem().trim().length() > 0) {
	%>
	<div class="row">
		<div class="col-xs-4">System warning</div>
		<div class="col-xs-8">
			<%=state.getCheckSystem() %>
		</div>
	</div>
	<%
	}
	%>
	<div class="row">
		<div class="col-xs-1">
			Menu: &nbsp;
		</div>
		<div class="col-xs-11">
			<input type="button" class="btn <%="Default".equalsIgnoreCase(state.getMenu().toString()) ? "btn-success" : "btn-basic" %>" onClick="javascript:issueCommand('DefaultMenuMode');" value="Default" <%=pendingDisplay.indexOf("MenuMode") >= 0 ? " disabled" : "" %>>
			<%
			if (pendingDisplay.indexOf("MenuMode") >= 0) {
			%>
			<img src="common/assets/images/loading.gif" height="10px">
			<%
			}
			%>
			<input type="button" class="btn <%="Timers".equalsIgnoreCase(state.getMenu().toString()) ? "btn-success" : "btn-basic" %>" onClick="javascript:issueCommand('TimersMenuMode');" value="Timers" <%=pendingDisplay.indexOf("MenuMode") >= 0 ? " disabled" : "" %>>
			<%
			if (pendingDisplay.indexOf("MenuMode") >= 0) {
			%>
			<img src="common/assets/images/loading.gif" height="10px">
			<%
			}
			%>
			<input type="button" class="btn <%="Settings".equalsIgnoreCase(state.getMenu().toString()) ? "btn-success" : "btn-basic" %>" onClick="javascript:issueCommand('SettingsMenuMode');" value="Settings" <%=pendingDisplay.indexOf("MenuMode") >= 0 ? " disabled" : "" %>>
			<%
			if (pendingDisplay.indexOf("MenuMode") >= 0) {
			%>
			<img src="common/assets/images/loading.gif" height="10px">
			<%
			}
			%>

			<input type="button" class="btn <%="Diagnostic".equalsIgnoreCase(state.getMenu().toString()) ? "btn-success" : "btn-basic" %>" onClick="javascript:issueCommand('DiagnosticMenuMode');" value="Diagnostic" <%=pendingDisplay.indexOf("MenuMode") >= 0 ? " disabled" : "" %>>
			<%
			if (pendingDisplay.indexOf("MenuMode") >= 0) {
			%>
			<img src="common/assets/images/loading.gif" height="10px">
			<%
			}
			%>
		</div>
	</div>
	<div class="row">
		<div class="col-xs-1">Keys:&nbsp;</div>
		<div class="col-xs-11">
			<input type="button" class="btn btn-basic" onClick="javascript:issueCommand('LeftKey');" value="<">					
			<input type="button" class="btn btn-basic" onClick="javascript:issueCommand('RightKey');" value=">">
			<input type="button" class="btn btn-basic" onClick="javascript:issueCommand('PlusKey');" value="+">					
			<input type="button" class="btn btn-basic" onClick="javascript:issueCommand('MinusKey');" value="-">			
		</div>			
	</div>
	<%
	}
	%>
