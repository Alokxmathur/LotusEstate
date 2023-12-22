<!doctype html>
<html lang="us">
<%@ page
  language="java"
  pageEncoding="ISO-8859-1"%>
<%@page
  import="com.axiomtank.objectdb.*, java.util.*,org.apache.commons.lang3.*,com.axiomtank.common.objects.Organization"%>
<%
  String __rolesNeeded[] = {"SuperAdmin"};
  String _title = "Edit Organization";
 %>
<%@include file="../../commonWithMenuJSandCSS.inc" %>
<%
	Organization organization = null;
	String uuid = request.getParameter("uuid");
	if (uuid == null) {
		//we are adding a new organization 
		organization = new Organization("", "");
		uuid = organization.getUUID();
	} else {
		//load organization  from the database
		organization = (Organization) objectDB.getObjectByUUID(uuid);
	}
%>
<div class="container-fluid">
  <form
    method="post"
    id="myForm"
    action="processOrganization.jsp">
    <input
      type="hidden"
      name="uuid"
      value="<%=uuid%>"> 
    <input
      type="hidden"
      id="deleteOrganization"
      name="deleteOrganization"
      value="">
    <div class="tab-content">
      <h3>Edit Organization</h3>
      <div>
        <table class="table">
        <thead>
        </thead>
        <tbody>
          <tr>
            <td>
              Name:
            </td>
            <td>
              <input
              type="text"
              size="50"
              name="<%=Organization.NAME%>"
              value="<%=StringEscapeUtils.escapeHtml3(organization.getName())%>">
            </td>
          </tr>
          <tr>
            <td>
              Description:
            </td>
            <td>
              <input
              type="text"
              size="50"
              name="<%=PersistableObject.DESCRIPTION%>"
              value="<%=organization.getDescription()%>">
            </td>
          </tr>
          <tr>
            <td>
              Phone:
            </td>
            <td>
              <input
              type="text"
              size="50"
              name="<%=Organization.PHONE%>"
              value="<%=StringEscapeUtils.escapeHtml3(organization.getPhone())%>">
            </td>
          </tr>
          <tr>
            <td>
              Address:
            </td>
            <td>
              <input
              type="text"
              size="50"
              name="<%=Organization.ADDRESS%>"
              value="<%=StringEscapeUtils.escapeHtml3(organization.getAddress())%>">
            </td>
          </tr>
          <tr>
            <td>
              Email:
            </td>
            <td>
              <input
              type="text"
              size="50"
              name="<%=Organization.EMAIL%>"
              value="<%=StringEscapeUtils.escapeHtml3(organization.getEmail())%>">
            </td>
          </tr>
        </tbody>
        </table>
      </div>
    </div>
    <input
      type="submit"
      class="btn btn-primary"
      value="Save">
    <input
      type="button"
      value="Cancel"
      class="btn btn-primary"
      onclick="window.location.href='listOrganizations.jsp'"> 
    <input
      type="button"
      id="deletebutton"
      class="btn btn-primary"
      value="Delete">
    <div
      id="delete-confirm"
      style="display: none">
      <p>Deleting an organization can result in problems with the whole setup.</p>
    </div>
  </form>
</div>
  <script type="text/javascript">
			$(document).ready(function() {
				$("#accordion").accordion({
					heightStyle : "content"
				});
				//show the dialog on click of the delete button
				$("#deletebutton").click(function() {
					$("#delete-confirm").dialog({
						modal : true,
						title : "Delete the organization?",
						buttons : {
							"Cancel" : function() {
								$(this).dialog("close");
							},
							"Delete" : function() {
								$("#deleteOrganization").val("true");
								$("#myForm").submit();
							}
						}
					});
				});
			});
		</script>
</body>
</html>