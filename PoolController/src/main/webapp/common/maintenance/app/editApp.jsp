<!doctype html>
<html lang="us">
<%@ page
  language="java"
  contentType="text/html; charset=ISO-8859-1"
  pageEncoding="ISO-8859-1"%>
<%@page
  import="com.axiomtank.objectdb.*, java.util.*,org.apache.commons.lang3.StringUtils,
  org.apache.commons.text.StringEscapeUtils, com.axiomtank.common.objects.App"%>
<%
  String __rolesNeeded[] = {"Admin","SuperAdmin"}; 
  String _title = "Edit a App";
 %>
<%@include file="../../commonWithMenuJSandCSS.inc" %>
<%
	App app = null;
	String uuid = request.getParameter("uuid");
	if (uuid == null) {
		//we are adding a new app 
		app = new App("", "");
		uuid = app.getUUID();
	} else {
		//load app  from the database
		app = (App) objectDB.getObjectByUUID(uuid);
	}
%>
<div class="container-fluid">
  <form
    method="post"
    id="myForm"
    action="processApp.jsp">
    <input
      type="hidden"
      name="uuid"
      value="<%=uuid%>"> 
    <input
      type="hidden"
      id="deleteApp"
      name="deleteApp"
      value="">
    <div class="tab-content">
      <h3>Edit App</h3>
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
              name="<%=App.NAME%>"
              value="<%=StringEscapeUtils.escapeHtml3(app.getName())%>">
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
              value="<%=app.getDescription()%>">
            </td>
          </tr>
          <tr>
            <td>
              UUID:
            </td>
            <td>
              <input
              type="text"
              size="50"
              disabled
              value="<%=StringEscapeUtils.escapeHtml3(uuid)%>">
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
      onclick="window.location.href='listApps.jsp'"> 
    <input
      type="button"
      id="deletebutton"
      class="btn btn-primary"
      value="Delete">
    <div
      id="delete-confirm"
      style="display: none">
      <p>Deleting an app can result in problems with the whole setup.</p>
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
						title : "Delete the app?",
						buttons : {
							"Cancel" : function() {
								$(this).dialog("close");
							},
							"Delete" : function() {
								$("#deleteApp").val("true");
								$("#myForm").submit();
							}
						}
					});
				});
			});
		</script>
</body>
</html>