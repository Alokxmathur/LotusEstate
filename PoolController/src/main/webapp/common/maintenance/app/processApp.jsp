<!doctype html>
<html lang="us">
<%@ page
  language="java"
  contentType="text/html; charset=ISO-8859-1"
  pageEncoding="ISO-8859-1"%>
<%@page import="com.axiomtank.objectdb.*, java.util.*,com.axiomtank.common.objects.App, org.apache.commons.lang3.StringUtils"%>
<%
  String __rolesNeeded[] = {"Admin","SuperAdmin"};
  String _title = "Process App";
 %>
<%@include file="../../commonWithMenuJSandCSS.inc"%>
<div class="container-fluid">
  <%
  	String uuid = StringUtils.defaultString(request.getParameter("uuid"));
    String name = StringUtils.defaultString(request.getParameter(App.NAME));
    String description = request.getParameter(PersistableObject.DESCRIPTION);
    boolean allInformationProvided = (name.trim().length() > 0 && description.trim().length() > 0);
    boolean deleteApp = "true".equals(request.getParameter("deleteApp"));
  	App app = (App) objectDB.getObjectByUUID(uuid);
  	if (app == null) {
  		//we must be adding an app
  		app = new App();
  	}
    app.setDescription(request.getParameter(PersistableObject.DESCRIPTION));
    app.setName(request.getParameter(App.NAME));
  	if (deleteApp) {
      objectDB.removeObject(app);
      out.println("App " + name + " has been deleted.");
  	} 
    else if (allInformationProvided) {
      objectDB.putObject(app);
      out.println("App " + name + " has been saved.");
    }
    else {
      out.println("<b>Please enter a name and a description for the app.</b><br>");
    }
  %>
  <form action="<%=deleteApp || allInformationProvided ? "listApps.jsp" : "javascript:window.history.go(-1);"%>">
    <input
      type="submit"
      value="<%=deleteApp || allInformationProvided ? "Continue" : "Go Back"%>">
  </form>
</div>
</body>
</html>