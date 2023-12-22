<!doctype html>
<html lang="us">
<%@ page
  language="java"
  contentType="text/html; charset=ISO-8859-1"
  pageEncoding="ISO-8859-1"%>
<%@page import="com.axiomtank.objectdb.*, java.util.*, org.apache.commons.lang3.*"%>
<%
  String __rolesNeeded[] = {"Admin","SuperAdmin"};
  String _title = "Process Question";
 %>
<%@include file="../../../common/commonWithMenuJSandCSS.inc" %>
  <%
  	String uuid = request.getParameter("uuid");
  	boolean deleteQuestion = "true".equals(request
  			.getParameter("deleteQuestion"));
  	PersistableObject question = objectDB.getObjectByUUID(uuid);
  	if (question == null) {
  		//we must be adding a question
  		question = new PersistableObject("", "AxiomTank_Question");
  	}
    
    question.getContents().clear();
  	Map<String, String[]> parameterMap = request.getParameterMap();
  	for (String parameterName : parameterMap.keySet()) {
  		String[] parameterValues = parameterMap.get(parameterName);
  		question.getContents().put(parameterName, parameterValues[0]);
  	}
  	question.setDescription(StringUtils.defaultString(request.getParameter("Question_Description"), "Question description not provided"));
  	if (deleteQuestion) {
  		objectDB.removeObject(question);
  	} else {
  		objectDB.putObject(question);
  	}
  %>
<div class="container-fluid">
  Question has been
  <%=deleteQuestion ? "deleted" : "saved"%>.
  <form action="listQuestions.jsp">
    <input class="btn btn-primary"
      type="submit"
      value="Continue">
  </form>
</div>
</body>
</html>