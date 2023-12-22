<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="org.apache.commons.lang3.*, com.axiomtank.util.Session"%>
<% 
  String __rolesNeeded[] = null;
  String _title = Session.getAppName() + "check id";
 %>
<%@include file="../common.inc"%>
<%
String userId=request.getParameter("id");
if (userId != null) { 
  Criteria criteria = new Criteria(User.TYPE);
  criteria.addCriterion(Criterion.Operator.AND, User.USER_ID, userId);
  //find user object ids that match the provided userId
  Set<String> userObjectIds = objectDB.listObjectUUIDs(criteria);
  if (userObjectIds.size() > 0) {
	  out.print("exists");
  }
  else {
	  out.print("does not exist");
  }
}
%>