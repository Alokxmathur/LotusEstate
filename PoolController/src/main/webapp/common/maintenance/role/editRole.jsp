<!doctype html>
<html lang="us">
<%@ page
  language="java"
  contentType="text/html; charset=ISO-8859-1"
  pageEncoding="ISO-8859-1"%>
<%@page
  import="com.axiomtank.objectdb.*, java.util.*,org.apache.commons.lang3.*,com.axiomtank.common.objects.Role"%>
<%
  String __rolesNeeded[] = {"SuperAdmin"};
  String _title = "Edit a Role";
 %>
<%@include file="../../commonWithMenuJSandCSS.inc" %>
<%
	Role role = null;
	String uuid = request.getParameter("uuid");
	if (uuid == null) {
		//we are adding a new role 
		role = new Role("", "");
		uuid = role.getUUID();
	} else {
		//load role  from the database
		role = (Role) objectDB.getObjectByUUID(uuid);
	}
%>
<div class="container-fluid">
  <form
    method="post"
    id="myForm"
    action="processRole.jsp">
    <input
      type="hidden"
      name="uuid"
      value="<%=uuid%>"> 
    <input
      type="hidden"
      id="deleteRole"
      name="deleteRole"
      value="">
    <div class="tab-content">
      <h3>Edit Role</h3>
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
              size="20"
              name="<%=Role.NAME%>"
              value="<%=StringEscapeUtils.escapeHtml3(role.getName())%>">
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
              value="<%=role.getDescription()%>">
            </td>
          </tr>
          <tr>
            <td>
              Precedence (lower numbers trump higher numbers):
            </td>
            <td>
              <input
              type="text"
              size="3"
              name="<%=Role.PRECEDENCE%>"
              value="<%=role.getPrecedence()%>">
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
      onclick="window.location.href='listRoles.jsp'"> 
    <input
      type="button"
      id="deletebutton"
      class="btn btn-primary"
      value="Delete">
    <div
      id="delete-confirm"
      style="display: none">
      <p>Deleting a role can result in problems with the whole setup.</p>
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
						title : "Delete the role?",
						buttons : {
							"Cancel" : function() {
								$(this).dialog("close");
							},
							"Delete" : function() {
								$("#deleteRole").val("true");
								$("#myForm").submit();
							}
						}
					});
				});
			});
		</script>
</body>
</html>