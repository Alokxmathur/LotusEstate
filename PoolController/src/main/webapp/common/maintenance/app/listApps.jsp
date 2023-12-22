<!doctype html>
<html lang="us">
<%@ page
  language="java"
  contentType="text/html; charset=ISO-8859-1"
  pageEncoding="ISO-8859-1"%>
<%@page import="com.axiomtank.objectdb.*, java.util.*,com.axiomtank.common.objects.App"%>
<%
  String __rolesNeeded[] = {"Admin","SuperAdmin"};
  String _title = "App";
 %>
<%@include file="../../commonWithMenuJSandCSS.inc"%>
  <div class="container-fluid">
    <div class="row">
      <div class="md-col-12">
        <h5>Select an app to edit from the list or <a href="editApp.jsp">add</a> a new one.</h5>
      </div>
    </div>
    <div class="row">
      <div class="md-col-12">
        <table
          id="appsTable"
          class="table table-hover">
          <thead>
            <tr>
              <th>Name</th>
              <th>Description</th>
            </tr>
          </thead>
          <tbody>
            <%
            Set<String> appUUIDs = objectDB.listObjectUUIDs(PersistableObject.TYPE, App.TYPE);
            for (String uuid: appUUIDs)
            {
                App app = (App) objectDB.getObjectByUUID(uuid);
          %>
            <tr>
              <td><a href="editApp.jsp?uuid=<%=uuid%>"><%=app.getName()%>
              </a></td>
              <td><%=app.getDescription()%></td>
            </tr>
            <%
              }
            %>
          </tbody>
        </table>
      </div> <!-- md-col-12 -->
    </div> <!-- row -->	
  </div> <!-- container -->
  <script>
  $(document).ready(function() {
    $("#appsTable").DataTable({
      // sort on the first column and second column, order asc 
      order : [ 1, "asc" ]
    });
  });
  </script>
</body>
</html>