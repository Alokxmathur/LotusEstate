<%@ page  language="java"%>
<%@page import="com.axiomtank.common.objects.Organization"%>
<%
  String __rolesNeeded[] = {"SuperAdmin"};
  String _title = "Organizations";
%>
<%@include file="../../commonWithMenuJSandCSS.inc"%> 
  <div class="container-fluid">
    <div class="row">
      <div class="md-col-12">
        <h5>Select a organization to edit or <a href="editOrganization.jsp">add</a> a new one.</h5>
      </div>
    </div>
    <div class="row">
      <div class="md-col-12">
        <table
          id="organizationsTable"
          class="table table-hover">
          <thead>
            <tr>
              <th>Name</th>
              <th>Address</th>
              <th>Phone</th>
              <th>Email</th>
            </tr>
          </thead>
          <tbody>
 <%
        Set<String> organizationUUIDs = objectDB.listObjectUUIDs(PersistableObject.TYPE, Organization.TYPE);
  		for (String uuid: organizationUUIDs)
  		{
        	Organization organization = (Organization) objectDB.getObjectByUUID(uuid);
    %>
            <tr>
              <td><a href="editOrganization.jsp?uuid=<%=uuid%>"><%=organization.getName()%>
              </a></td>
              <td><%=organization.getAddress()%></td>
              <td><%=organization.getPhone()%></td>
              <td><%=organization.getEmail()%></td>
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
    $("#organizationsTable").DataTable({
      // sort on the first column and second column, order asc 
      order : [ 1, "asc" ]
    });
  });
  </script>
</body>
</html>











