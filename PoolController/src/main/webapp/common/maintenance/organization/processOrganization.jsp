<!doctype html>
<%@ page
  language="java"
  contentType="text/html; charset=ISO-8859-1"
  pageEncoding="ISO-8859-1"%>
<%@page import="com.axiomtank.objectdb.*, java.util.*,com.axiomtank.common.objects.Organization, org.apache.commons.lang3.StringUtils"%>
<%
  String __rolesNeeded[] = {"SuperAdmin"};
  String _title = "Organizations";
 %>
<%@include file="../../commonWithMenuJSandCSS.inc"%>
<div class="container-fluid">
  <%
  	String uuid = StringUtils.defaultString(request.getParameter("uuid"));
    String name = StringUtils.defaultString(request.getParameter(Organization.NAME));
    String description = request.getParameter(PersistableObject.DESCRIPTION);
    boolean allInformationProvided = (name.trim().length() > 0 && description.trim().length() > 0);
    boolean deleteOrganization = "true".equals(request.getParameter("deleteOrganization"));
  	Organization organization = (Organization) objectDB.getObjectByUUID(uuid);
  	if (organization == null) {
  		//we must be adding an organization
  		organization = new Organization();
  	}
    organization.setDescription(request.getParameter(PersistableObject.DESCRIPTION));
    organization.setName(request.getParameter(Organization.NAME));
    organization.setAddress(request.getParameter(Organization.ADDRESS));
    organization.setPhone(request.getParameter(Organization.PHONE));
    organization.setEmail(request.getParameter(Organization.EMAIL));
  	if (deleteOrganization) {
      objectDB.removeObject(organization);
      out.println("Organization " + name + " has been deleted.");
  	} 
    else if (allInformationProvided) {
      objectDB.putObject(organization);
      out.println("Organization " + name + " has been saved.");
    }
    else {
      out.println("<b>Please enter a name and a description for the organization.</b><br>");
    }
  %>
  <form action="<%=deleteOrganization || allInformationProvided ? "listOrganizations.jsp" : "javascript:window.history.go(-1);"%>">
    <input
      type="submit"
      value="<%=deleteOrganization || allInformationProvided ? "Continue" : "Go Back"%>">
  </form>
</div>
</body>
</html>