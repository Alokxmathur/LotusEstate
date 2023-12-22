<!doctype html>
<html lang="us">
<%@ page
  language="java"
  contentType="text/html; charset=ISO-8859-1"
  pageEncoding="ISO-8859-1"%>
<%@page import="com.axiomtank.objectdb.*, java.util.*, org.apache.commons.lang3.*"%>
<%
  String __rolesNeeded[] = {"Admin","SuperAdmin"};
  String _title = "Edit Question";
 %>
 <head>
<script src="../../common/assets/jquery/autogrow.min.js"></script>
<%@include file="../../../common/commonWithMenuJSandCSS.inc" %>
<%
	PersistableObject question = null;
	String uuid = request.getParameter("uuid");
	if (uuid == null) {
		//we are adding a new question 
		question = new PersistableObject("?", "AxiomTank_Question");
		uuid = question.getUUID();
	} else {
		//load question  from the database
		question = objectDB.getObjectByUUID(uuid);
	}
%>
  <div class="container-fluid">
    <div class="row">
      <form method="post" id="myForm" action="processQuestion.jsp" role="form" class="form-horizontal">
        <input type="hidden"
          name="uuid"
          value="<%=uuid%>">
        <input
          type="hidden"
          id="deleteQuestion"
          name="deleteQuestion"
          value="">
          <div class="row">
          	<div class="md-col-2">
                <h3>Edit Question</h3>
              </div>
          </div>
        <div class="form-group">
          <div class="col-md-2">
            <label class="control-label" for="Question_Name">Name:</label>
          </div>
          <div class="col-md-10">
            <input
              type="text"
              id="Question_Name"
              name="Question_Name"
              class="form-control" 
              required
              value="<%=StringEscapeUtils.escapeEcmaScript(StringUtils.defaultString(question.getString("Question_Name")))%>"></input>
          </div>
        </div>
        <div class="form-group">
          <div class="col-md-2">
            <label class="control-label" for="Question_Description">Description:</label>
          </div>
          <div class="col-md-10">
            <input
              type="text"
              name="Question_Description"
              class="form-control" 
              required
              value="<%=StringEscapeUtils.escapeEcmaScript(StringUtils.defaultString(question.getString("Question_Description")))%>">
          </div>
        </div>
        <div class="form-group">
          <div class="col-md-2">
            <label class="control-label" for="Question_Question">Question:</label>
          </div>
          <div class="col-md-10">
            <input type="text" name="Question_Question" id="Question_Question" class="form-control" required
              value="<%=StringEscapeUtils.escapeEcmaScript(StringUtils.defaultString(question.getString("Question_Question")))%>">
          </div>
        </div>
        <div class="form-group">
          <div class="col-md-2">
            <label class="control-label" for="Question_Question_PlaceHolderText">Place holder text:</label>
          </div>
          <div class="col-md-10">
            <input type="text" size="10" name="Question_Question_PlaceHolderText" id="Question_Question_PlaceHolderText" class="form-control" 
              value="<%=StringEscapeUtils.escapeEcmaScript(StringUtils.defaultString(question.getString("Question_Question_PlaceHolderText")))%>">
          </div>
        </div>
      	<div>
    			<input
      			type="submit"
      			class="btn btn-primary"
      			value="Save"> 
    			<input
      			type="button"
      			value="Cancel"
      			class="btn btn-primary"
      			onclick="window.location.href='listQuestions.jsp'"> 
    			<input
      			type="button"
      			id="deletebutton"
      			class="btn btn-primary"
      			value="Delete">
    	  	<div
      			id="delete-confirm"
      			style="display: none">
      			<p>Deleting a question can result in problems.</p>
    	  	</div>  
        </div>
      </form>
    </div>
  </div>        
  <script type="text/javascript">
    $(document).ready(function() {
    	//show the dialog on click of the delete button
    	$("#deletebutton").click(function() {
  			$("#delete-confirm").dialog({
  				modal : true,
  				title : "Delete the Question?",
  				buttons : {
  					"Cancel" : function() {
  						$(this).dialog("close");
  					},
  					"Delete" : function() {
  						$("#deleteQuestion").val("true");
  						$("#myForm").submit();
  					}
  				}
  			});
  		});
	)};
  </script>
</body>
</html>