<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@page import="com.axiomtank.objectdb.*, java.util.*, javax.json.*"%>
<%
  String __rolesNeeded[] = {"Admin", "SuperAdmin"};
  String _title = "Users";
 %>
<%@include file="../../../common/common.inc" %>
<%
	Criteria criteria = new Criteria(User.TYPE);
	Set<String> userUUIDs = objectDB.listObjectUUIDs(criteria);
	JsonArrayBuilder arrayBuilder = Json.createArrayBuilder();
	for (String uuid: userUUIDs)
	{
        User user = (User) objectDB.getObjectByUUID(uuid);
       	if (user != null && user.getUserId().length() > 0) {
    		JsonObjectBuilder userEntryObjectBuilder = Json.createObjectBuilder();
    		userEntryObjectBuilder.add("uuid", user.getUUID());
    		userEntryObjectBuilder.add("name", user.getName());
    		userEntryObjectBuilder.add("email", user.getUserId());
    		userEntryObjectBuilder.add("phone", user.getMobilePhone());
    		
    		arrayBuilder.add(userEntryObjectBuilder.build());
     	}
	}
	
	JsonObjectBuilder entriesObjectBuilder = Json.createObjectBuilder();
	entriesObjectBuilder.add("data", arrayBuilder.build());
	Json.createWriter(out).write(entriesObjectBuilder.build());
  %>