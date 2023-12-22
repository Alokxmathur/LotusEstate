<!doctype html>
<html lang="us">
<%@ page
  language="java"
  contentType="text/html; charset=ISO-8859-1"
  pageEncoding="ISO-8859-1"%>
<%@page import="com.axiomtank.objectdb.*, java.util.*,com.axiomtank.common.objects.Role, org.apache.commons.lang3.StringUtils"%>
<%
  String __rolesNeeded[] = {"SuperAdmin"};
  String _title = "Process Role";
 %>
<%@include file="../../commonWithMenuJSandCSS.inc"%>
<div class="container-fluid">
  <%
  	String uuid = StringUtils.defaultString(request.getParameter("uuid"));
    String name = StringUtils.defaultString(request.getParameter(Role.NAME));
    String description = request.getParameter(PersistableObject.DESCRIPTION);
    boolean allInformationProvided = (name.trim().length() > 0 && description.trim().length() > 0);
    boolean deleteRole = "true".equals(request.getParameter("deleteRole"));
  	Role role = (Role) objectDB.getObjectByUUID(uuid);
  	if (role == null) {
  		//we must be adding an role
  		role = new Role();
  	}
    role.setDescription(request.getParameter(PersistableObject.DESCRIPTION));
    role.setName(request.getParameter(Role.NAME));
  	if (deleteRole) {
      objectDB.removeObject(role);
      out.println("Role " + name + " has been deleted.");
  	} 
    else if (allInformationProvided) {
      objectDB.putObject(role);
      out.println("Role " + name + " has been saved.");
    }
    else {
      out.println("<b>Please enter a name and a description for the role.</b><br>");
    }
  %>
  <form action="<%=deleteRole || allInformationProvided ? "listRoles.jsp" : "javascript:window.history.go(-1);"%>">
    <input
      type="submit"
      value="<%=deleteRole || allInformationProvided ? "Continue" : "Go Back"%>">
  </form>
</div>
</body>
</html>