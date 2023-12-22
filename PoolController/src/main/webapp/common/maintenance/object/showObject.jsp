<!doctype html>
<%@page import="org.json.JSONObject"%>
<html lang="us">
<%@ page
  language="java"
  contentType="text/html; charset=ISO-8859-1"
  pageEncoding="ISO-8859-1"%>
<%@page import="com.axiomtank.objectdb.*, java.io.StringReader, javax.json.*, java.util.*,com.axiomtank.common.objects.Role"%>
<%
  String __rolesNeeded[] = {"Admin", "SuperAdmin"};
  String _title = "Object";
 %>
<%@include file="../../commonWithMenuJSandCSS.inc"%> 
<%
  String uuid = request.getParameter("uuid");
%>
  <div class="container-fluid">
    <div class="row">
      <div class="md-col-12">
      <table class="table" id="indexTable">
      <thead>
      <tr>
        <th>Attribute</th>
        <th>Value</th>
      </tr>
      </thead>
      <tbody>
      <%
      PersistableObject object = objectDB.getObjectByUUID(uuid);
      if (object != null) {
        String stringRep = object.jsonIndices();
        try {
    	  JsonReader jsonReader = Json.createReader(new StringReader(stringRep)); 
    	  JsonObject jsonObject = jsonReader.readObject();
          for (String name : jsonObject.keySet()) {
             out.println("<tr><td>" + name + "</td><td>" + jsonObject.get(name).toString() + "</td></tr>");
          }
        }
        catch (Throwable e) {
          out.print("<tr><td colspan='2'>Error:" + e + "in '" + stringRep + "'</td></tr>"); 
        }
      }
      %>
      </tbody>
      </table>
      </div>
    </div> <!-- row -->
    <div class="row">
      <div class="md-col-12">
      <table class="table" id="attributeTable">
      <thead>
      <tr>
        <th>Key</th>
        <th>Value</th>
      </tr>
      </thead>
      <tbody>
      <%
      if (object != null) {
        JsonReader jsonReader = Json.createReader(new StringReader(object.jsonContents()));
        JsonObject jsonObject = jsonReader.readObject();
          for (String name : jsonObject.keySet()) {
             out.println("<tr><td>" + name + "</td><td>" + jsonObject.get(name).toString() + "</td></tr>");
          }
      }
      %>
      </tbody>
      </table>
      </div>
    </div> <!-- row -->
  </div> <!-- container -->
  <script>
  $(document).ready(function() {
    $(".table").DataTable();
  });
  </script>
</body>
</html>