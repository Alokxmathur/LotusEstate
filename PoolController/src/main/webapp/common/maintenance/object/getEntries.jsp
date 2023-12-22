<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@page import="com.axiomtank.objectdb.*,
  org.apache.commons.text.StringEscapeUtils,
  java.text.*,
  java.util.*,
  javax.json.*,
  org.apache.commons.lang3.StringUtils"%>
<%
	String __rolesNeeded[] = {};
	String _title = "Messages";
%>
<%@include file="../../../../common/common.inc"%>
<%
	ArrayList<ObjectCache.CachedEntryInformation> cachedEntries = objectDB.getCachedInformation();
	JsonObjectBuilder objectBuilder = Json.createObjectBuilder();
	JsonArrayBuilder arrayBuilder = Json.createArrayBuilder();
	for (ObjectCache.CachedEntryInformation entry : cachedEntries) {
		JsonObjectBuilder entryObjectBuilder = Json.createObjectBuilder();
		entryObjectBuilder.add("uuid", entry.getUuid());
		entryObjectBuilder.add("type", entry.getType());
		entryObjectBuilder.add("description", entry.getDescription());
		entryObjectBuilder.add("lastAccessed", entry.getLastAccessed().getTime());
		entryObjectBuilder.add("loaded", entry.getLoaded().getTime());
		entryObjectBuilder.add("hits", entry.getHits());
		entryObjectBuilder.add("size", entry.getSize());

		//add the entry to the array
		arrayBuilder.add(entryObjectBuilder.build());
	}
	objectBuilder.add("data", arrayBuilder.build());
	Json.createWriter(out).write(objectBuilder.build());
%>