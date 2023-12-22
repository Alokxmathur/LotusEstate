<!doctype html>
<html lang="us">
<%@ page
  language="java"
  contentType="text/html; charset=ISO-8859-1"
  pageEncoding="ISO-8859-1"%>
<%@page import="com.axiomtank.objectdb.*, 
java.lang.instrument.Instrumentation,
java.util.*,com.axiomtank.common.objects.Role"%>
<%
  String __rolesNeeded[] = {"Admin", "SuperAdmin"};
  String _title = request.getParameter("type") + " Objects";
 %>
<%@include file="../../commonWithMenuJSandCSS.inc"%>
<%
  String type = request.getParameter("type");
  Set<String> uuids = objectDB.listObjectUUIDs(PersistableObject.TYPE, type);
%>
  <div class="container-fluid">
    <div class="row">
      <div class="md-col-12">
        <table
          id="objectTable"
          class="table table-hover">
          <thead>
            <tr>
              <th>UUID</th>
              <th>Description</th>
              <th>Created</th>
              <th>Created Sort</th>
              <th>Last Modified</th>
              <th>Modified Sort</th>
              <th>Size</th>
            </tr>
          </thead>
          <tbody>
          <%
          for (String uuid : uuids) {
            PersistableObject object = objectDB.getObjectByUUID(uuid);
            if (object != null) {
              out.println("<tr><td><a href='showObject.jsp?uuid=" + uuid + "'>" + uuid + "</a>" 
                  + "</td><td>" + object.getDescription() 
                  + "</td><td>" + object.getCreated()
                  + "</td><td>" + object.getCreated().getTime()
                  + "</td><td>" + object.getLastModified()
                  + "</td><td>" + object.getLastModified().getTime()
                  + "</td><td>" + object.getSize()
                  + "</td></tr>");
            }
          }
          %>
          </tbody>
        </table>
      </div> <!-- md-col-12 -->
    </div> <!-- row -->
  </div> <!-- container -->
  <script>
  $(document).ready(function() {
    $("#objectTable").DataTable({
      // sort on the last modified column 
      order : [ 4, "desc" ],
      pageLength: "100",
      columnDefs: [
    	  {
    		  targets: [2],
    		  orderData: 3
    	  },
    	  {
    		  targets: [3],
    		  visible: false,
    		  searchable: false
    	  },
    	  {
    		  targets: [4],
    		  orderData: 5
    	  },
    	  {
    		  targets: [5],
    		  visible: false,
    		  searchable: false
    	  }    	  
      ]
    });
  });
  </script>
</body>
</html>