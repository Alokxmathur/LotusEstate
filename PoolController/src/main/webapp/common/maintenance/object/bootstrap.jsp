<!doctype html>
<html lang="us">
<%@ page
  language="java"
  contentType="text/html; charset=ISO-8859-1"
  pageEncoding="ISO-8859-1"%>
<%@page import="com.axiomtank.objectdb.*, java.util.*,com.axiomtank.common.objects.Role"%>
<%
  String __rolesNeeded[] = null;
  String _title = "Bootstrap";
 %>
<%@include file="../../commonWithMenuJSandCSS.inc" %>
<%
objectDB.bootstrap("Mathur", "Alok", "alok.mathur@axiomtank.com", "betterchangethis");
%>
  <div class="container-fluid">
    <div class="row">
      <div class="md-col-12">
        <h5>Created bootstrap objects</h5>
      </div>
    </div>
  </div> <!-- container -->
</body>
</html>