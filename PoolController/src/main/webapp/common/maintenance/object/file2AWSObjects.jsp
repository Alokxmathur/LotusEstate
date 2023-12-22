<!doctype html>
<html lang="us">
<%@ page
  language="java"
  contentType="text/html; charset=ISO-8859-1"
  pageEncoding="ISO-8859-1"%>
<%@page import="com.axiomtank.objectdb.*, java.util.*"%>
<head>
  <title>
    Convert to AWS Object DB
  </title>
</head>
<%
ObjectDB awsObjectDB = ObjectDB.getInstance(request.getContextPath(), "commonDB");
ObjectDB fileObjectDB = FileBasedObjectDB.getInstance("/data/iStewardLive", "commonDB");
Map<String, Integer> types = fileObjectDB.listTypes();
for (String type : types.keySet()) {
  Set<String> allObjectsOfType = fileObjectDB.listObjectUUIDs(new Criteria(type));
  for (String uuid : allObjectsOfType) {
    out.println("<br>Copying objects of type: " + type);
    PersistableObject object = fileObjectDB.getObjectByUUID(uuid);
    if (object != null) {
    	awsObjectDB.putObject(object);
    	out.println("<br>  Copied object " + uuid + ":" + object.getDescription());
    }
  }
}
%>
  <div class="container-fluid">
    <div class="row">
      <div class="md-col-12">
        <h5>Copied objects</h5>
      </div>
    </div>
  </div> <!-- container -->
</body>
</html>