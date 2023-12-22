<!doctype html>
<html lang="us">
<%@ page
  language="java"
  contentType="text/html; charset=ISO-8859-1"
  pageEncoding="ISO-8859-1"%>
<%@page import="com.axiomtank.objectdb.*, java.util.*,com.axiomtank.common.objects.Role"%>
<%
  String __rolesNeeded[] = {"Admin", "SuperAdmin"};
  String _title = "Role";
 %>
<%@include file="../../commonWithMenuJSandCSS.inc" %>
  <div class="container-fluid">
    <div class="row">
      <div class="md-col-12">
        <h5>Select a role to edit from the list or <a href="editRole.jsp">add</a> a new one.</h5>
      </div>
    </div>
    <div class="row">
      <div class="md-col-12">
        <table
          id="rolesTable"
          class="table table-hover">
          <thead>
            <tr>
              <th>Name</th>
              <th>Description</th>
            </tr>
          </thead>
          <tbody>
            <%
              Set<String> roleUUIDs = objectDB.listObjectUUIDs(PersistableObject.TYPE, Role.TYPE);
            for (String uuid: roleUUIDs)
            {
                Role role = (Role) objectDB.getObjectByUUID(uuid);
          %>
            <tr>
              <td><a href="editRole.jsp?uuid=<%=uuid%>"><%=role.getName()%>
              </a></td>
              <td><%=role.getDescription()%></td>
            </tr>
            <%
              }
            %>
          </tbody>
          <tfoot>
          </tfoot>
        </table>
      </div> <!-- md-col-12 -->
    </div> <!-- row -->
  </div> <!-- container -->
  <script>
  $(document).ready(function() {
    $("#rolesTable").DataTable({      // sort on the first column and second column, order asc 
      order: [[ 1, "asc" ]]
    });
  });
  </script>
</body>
</html>