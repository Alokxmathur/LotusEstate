<!doctype html>
<html lang="us">
<%@ page
  language="java"
  contentType="text/html; charset=ISO-8859-1"
  pageEncoding="ISO-8859-1"%>
<%@page import="com.axiomtank.objectdb.*, java.util.*,com.axiomtank.common.objects.Role"%>
<%
  String __rolesNeeded[] = {"Admin", "SuperAdmin"};
  String _title = "Objects";
 %>
<%@include file="../../commonWithMenuJSandCSS.inc"%> 
  <div class="container-fluid">
    <div class="row">
      <div class="md-col-12">
        <table
          id="objectsTable"
          class="table-hover">
          <thead>
            <tr>
              <th>Type</th>
              <th>Count</th>
            </tr>
          </thead>
          <tbody>
          <%
          HashMap<String, Integer> types = objectDB.listTypes();
          for (String type : types.keySet()) {
            out.println("<tr><td><a href='showObjects.jsp?type=" + type + "'>'" + type + "'</a></td><td>" + types.get(type) + "</td></tr>"); 
          }
          %>
          </tbody>
        </table>
      </div> <!-- md-col-12 -->
    </div> <!-- row -->
  </div> <!-- container -->
  <script>
  $(document).ready(function() {
    $("#objectsTable").DataTable({
      // sort on the first column and second column, order asc 
        order: [[ 0, "asc" ]],
        pageLength: "50"
    });
  });
  </script>
</body>
</html>